import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/compatibility_quiz.dart';
import '../../../data/repositories/compatibility_quiz_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'compatibility_quiz_controller.g.dart';

/// Controller para Compatibility Quiz (Phase 3)
@riverpod
class CompatibilityQuizController extends _$CompatibilityQuizController {
  @override
  FutureOr<bool> build() async {
    // Inicializar e criar quizzes padrão se necessário
    await _ensureDefaultQuizzes();
    return true;
  }

  // ============================================
  // QUIZ MANAGEMENT
  // ============================================

  /// Obter todos os quizzes disponíveis
  Future<List<CompatibilityQuiz>> getAvailableQuizzes() async {
    final repo = ref.read(compatibilityQuizRepositoryProvider);
    return repo.getActiveQuizzes();
  }

  /// Obter quiz por ID
  Future<CompatibilityQuiz?> getQuiz(String quizId) async {
    final repo = ref.read(compatibilityQuizRepositoryProvider);
    return repo.getQuiz(quizId);
  }

  // ============================================
  // QUIZ RESPONSES
  // ============================================

  /// Iniciar quiz
  Future<String> startQuiz(String quizId) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = QuizResponse(
        responseId: '',
        userId: currentUser.userId,
        quizId: quizId,
        answers: {},
        startedAt: DateTime.now(),
      );

      final repo = ref.read(compatibilityQuizRepositoryProvider);
      final responseId = await repo.startQuizResponse(response);

      state = const AsyncData(null);
      return responseId;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Salvar resposta de pergunta
  Future<void> saveAnswer({required String responseId, required String questionId, required dynamic answer}) async {
    final repo = ref.read(compatibilityQuizRepositoryProvider);
    final response = await repo.getQuizResponse(responseId);

    if (response == null) {
      throw Exception('Resposta não encontrada');
    }

    final updatedAnswers = {...response.answers, questionId: answer};
    final updatedResponse = response.copyWith(answers: updatedAnswers);

    await repo.updateQuizResponse(responseId, updatedResponse);
  }

  /// Submeter quiz completo
  Future<QuizResult> submitQuiz({required String responseId, required int timeSpentSeconds}) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(compatibilityQuizRepositoryProvider);
      final response = await repo.getQuizResponse(responseId);

      if (response == null) {
        throw Exception('Resposta não encontrada');
      }

      // Marcar como completo
      final completedResponse = response.copyWith(
        completedAt: DateTime.now(),
        isComplete: true,
        timeSpentSeconds: timeSpentSeconds,
      );
      await repo.updateQuizResponse(responseId, completedResponse);

      // Calcular resultado
      final result = await _calculateQuizResult(completedResponse);

      // Salvar resultado
      await repo.saveQuizResult(result);

      // Se for quiz de personalidade, salvar perfil
      final quiz = await repo.getQuiz(response.quizId);
      if (quiz?.category == QuizCategory.personality && result.personalityProfile != null) {
        await repo.savePersonalityProfile(result.personalityProfile!);
      }

      state = const AsyncData(null);
      return result;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  // ============================================
  // RESULTS & COMPARISON
  // ============================================

  /// Obter resultado do quiz
  Future<QuizResult?> getQuizResult(String quizId) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return null;

    final repo = ref.read(compatibilityQuizRepositoryProvider);
    return repo.getQuizResult(currentUser.userId, quizId);
  }

  /// Comparar compatibilidade com outro usuário
  Future<QuizCompatibilityComparison> compareWith(String otherUserId) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final repo = ref.read(compatibilityQuizRepositoryProvider);

      // Verificar se já existe comparação recente
      final existing = await repo.getCompatibilityComparison(currentUser.userId, otherUserId);

      if (existing != null && DateTime.now().difference(existing.comparedAt).inDays < 30) {
        state = const AsyncData(null);
        return existing;
      }

      // Obter resultados de ambos os usuários
      final results1 = await repo.getUserResults(currentUser.userId);
      final results2 = await repo.getUserResults(otherUserId);

      if (results1.isEmpty || results2.isEmpty) {
        throw Exception('Ambos os usuários precisam completar quizzes');
      }

      // Calcular compatibilidade
      final comparison = _calculateCompatibility(currentUser.userId, otherUserId, results1, results2);

      // Salvar comparação
      await repo.saveCompatibilityComparison(comparison);

      state = const AsyncData(null);
      return comparison;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Obter perfil de personalidade
  Future<PersonalityProfile?> getPersonalityProfile(String userId) async {
    final repo = ref.read(compatibilityQuizRepositoryProvider);
    return repo.getPersonalityProfile(userId);
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  Future<void> _ensureDefaultQuizzes() async {
    final repo = ref.read(compatibilityQuizRepositoryProvider);
    final existing = await repo.getActiveQuizzes();

    if (existing.isEmpty) {
      // Criar quiz padrão de personalidade
      await _createDefaultPersonalityQuiz();
      // Criar quiz padrão de valores
      await _createDefaultValuesQuiz();
    }
  }

  Future<void> _createDefaultPersonalityQuiz() async {
    final quiz = CompatibilityQuiz(
      quizId: '',
      title: 'Quiz de Personalidade',
      description: 'Descubra seu tipo de personalidade e encontre matches compatíveis',
      category: QuizCategory.personality,
      questions: [
        QuizQuestion(
          questionId: 'p1',
          text: 'Você se considera mais:',
          type: QuestionType.singleChoice,
          options: [
            QuizOption(optionId: 'o1', text: 'Extrovertido', value: 1),
            QuizOption(optionId: 'o2', text: 'Introvertido', value: 0),
          ],
          weight: 8,
        ),
        QuizQuestion(
          questionId: 'p2',
          text: 'Em decisões, você prioriza:',
          type: QuestionType.singleChoice,
          options: [
            QuizOption(optionId: 'o1', text: 'Lógica e razão', value: 1),
            QuizOption(optionId: 'o2', text: 'Sentimentos e emoções', value: 0),
          ],
          weight: 7,
        ),
        QuizQuestion(
          questionId: 'p3',
          text: 'Você prefere:',
          type: QuestionType.singleChoice,
          options: [
            QuizOption(optionId: 'o1', text: 'Planejar com antecedência', value: 1),
            QuizOption(optionId: 'o2', text: 'Ser espontâneo', value: 0),
          ],
          weight: 6,
        ),
        QuizQuestion(
          questionId: 'p4',
          text: 'Em conversas, você:',
          type: QuestionType.singleChoice,
          options: [
            QuizOption(optionId: 'o1', text: 'Fala mais que ouve', value: 1),
            QuizOption(optionId: 'o2', text: 'Ouve mais que fala', value: 0),
          ],
          weight: 7,
        ),
        QuizQuestion(
          questionId: 'p5',
          text: 'Você é mais:',
          type: QuestionType.singleChoice,
          options: [
            QuizOption(optionId: 'o1', text: 'Prático e realista', value: 0),
            QuizOption(optionId: 'o2', text: 'Criativo e idealista', value: 1),
          ],
          weight: 6,
        ),
      ],
      estimatedMinutes: 5,
      createdAt: DateTime.now(),
    );

    final repo = ref.read(compatibilityQuizRepositoryProvider);
    await repo.createQuiz(quiz);
  }

  Future<void> _createDefaultValuesQuiz() async {
    final quiz = CompatibilityQuiz(
      quizId: '',
      title: 'Quiz de Valores',
      description: 'Entenda seus valores fundamentais para encontrar alguém alinhado',
      category: QuizCategory.values,
      questions: [
        QuizQuestion(
          questionId: 'v1',
          text: 'Para você, família é:',
          type: QuestionType.scale,
          options: List.generate(5, (i) => QuizOption(optionId: 'o${i + 1}', text: '${i + 1}', value: i + 1)),
          weight: 10,
          explanation: '1 = Não muito importante, 5 = Extremamente importante',
        ),
        QuizQuestion(
          questionId: 'v2',
          text: 'Ambição profissional na sua vida:',
          type: QuestionType.scale,
          options: List.generate(5, (i) => QuizOption(optionId: 'o${i + 1}', text: '${i + 1}', value: i + 1)),
          weight: 8,
        ),
        QuizQuestion(
          questionId: 'v3',
          text: 'Religião/espiritualidade:',
          type: QuestionType.scale,
          options: List.generate(5, (i) => QuizOption(optionId: 'o${i + 1}', text: '${i + 1}', value: i + 1)),
          weight: 9,
        ),
      ],
      estimatedMinutes: 3,
      createdAt: DateTime.now(),
    );

    final repo = ref.read(compatibilityQuizRepositoryProvider);
    await repo.createQuiz(quiz);
  }

  Future<QuizResult> _calculateQuizResult(QuizResponse response) async {
    final repo = ref.read(compatibilityQuizRepositoryProvider);
    final quiz = await repo.getQuiz(response.quizId);

    if (quiz == null) {
      throw Exception('Quiz não encontrado');
    }

    // Calcular scores por categoria
    final categoryScores = <QuizCategory, double>{
      quiz.category: 75.0, // Mock - calcular baseado nas respostas
    };

    // Gerar insights
    final insights = <QuizInsight>[
      QuizInsight(
        insightId: '1',
        type: QuizInsightType.strength,
        title: 'Perfil Completo',
        message: 'Você completou o quiz! Isso aumenta suas chances de matches.',
        confidence: 0.9,
      ),
    ];

    // Gerar perfil de personalidade se for quiz de personalidade
    PersonalityProfile? personality;
    if (quiz.category == QuizCategory.personality) {
      personality = _generatePersonalityProfile(response);
    }

    return QuizResult(
      resultId: '',
      userId: response.userId,
      quizId: response.quizId,
      categoryScores: categoryScores,
      personalityProfile: personality,
      insights: insights,
      generatedAt: DateTime.now(),
    );
  }

  PersonalityProfile _generatePersonalityProfile(QuizResponse response) {
    // Mock - implementar lógica real baseada nas respostas
    return PersonalityProfile(
      profileId: '',
      userId: response.userId,
      type: PersonalityType.diplomat,
      traits: {
        PersonalityTrait.extroversion: 60,
        PersonalityTrait.agreeableness: 75,
        PersonalityTrait.conscientiousness: 80,
        PersonalityTrait.emotionalStability: 70,
        PersonalityTrait.openness: 85,
      },
      description: 'Você é uma pessoa empática e criativa, que valoriza conexões profundas.',
      strengths: ['Empatia', 'Criatividade', 'Comunicação'],
      weaknesses: ['Pode ser muito idealista', 'Evita conflitos'],
      compatibleTypes: [PersonalityType.diplomat, PersonalityType.analyst],
      generatedAt: DateTime.now(),
    );
  }

  QuizCompatibilityComparison _calculateCompatibility(
    String userId1,
    String userId2,
    List<QuizResult> results1,
    List<QuizResult> results2,
  ) {
    // Calcular compatibilidade geral
    var totalScore = 0.0;
    var count = 0;

    final categoryCompat = <QuizCategory, double>{};

    // Comparar resultados por categoria
    for (final r1 in results1) {
      for (final r2 in results2) {
        for (final cat in r1.categoryScores.keys) {
          if (r2.categoryScores.containsKey(cat)) {
            final score1 = r1.categoryScores[cat]!;
            final score2 = r2.categoryScores[cat]!;

            // Compatibilidade = 100 - diferença absoluta
            final compat = 100 - (score1 - score2).abs();
            categoryCompat[cat] = compat;
            totalScore += compat;
            count++;
          }
        }
      }
    }

    final overallCompat = count > 0 ? totalScore / count : 50.0;

    // Gerar matches e conflitos
    final matches = <CompatibilityMatch>[];
    final conflicts = <CompatibilityConflict>[];

    // Mock data
    if (overallCompat >= 70) {
      matches.add(
        CompatibilityMatch(
          questionId: 'shared1',
          questionText: 'Valores familiares',
          user1Answer: 'Muito importante',
          user2Answer: 'Muito importante',
          matchScore: 95,
        ),
      );
    }

    // Normalizar IDs
    final users = [userId1, userId2]..sort();

    return QuizCompatibilityComparison(
      comparisonId: '',
      user1Id: users[0],
      user2Id: users[1],
      overallCompatibility: overallCompat,
      categoryCompatibility: categoryCompat,
      matches: matches,
      conflicts: conflicts,
      recommendations: _generateRecommendations(overallCompat, categoryCompat),
      comparedAt: DateTime.now(),
    );
  }

  List<String> _generateRecommendations(double overallCompat, Map<QuizCategory, double> categoryCompat) {
    final recommendations = <String>[];

    if (overallCompat >= 75) {
      recommendations.add('Alta compatibilidade! Vocês têm muito em comum.');
    } else if (overallCompat >= 50) {
      recommendations.add('Compatibilidade moderada. Explore suas diferenças.');
    } else {
      recommendations.add('Baixa compatibilidade. Comunicação será essencial.');
    }

    return recommendations;
  }
}

/// Provider para quizzes disponíveis
@riverpod
Future<List<CompatibilityQuiz>> availableQuizzes(AvailableQuizzesRef ref) async {
  final controller = ref.watch(compatibilityQuizControllerProvider.notifier);
  return controller.getAvailableQuizzes();
}

/// Provider para perfil de personalidade do usuário atual
@riverpod
Future<PersonalityProfile?> currentUserPersonality(CurrentUserPersonalityRef ref) async {
  final currentUser = ref.watch(currentUserProfileProvider).value;
  if (currentUser == null) return null;

  final controller = ref.watch(compatibilityQuizControllerProvider.notifier);
  return controller.getPersonalityProfile(currentUser.userId);
}
