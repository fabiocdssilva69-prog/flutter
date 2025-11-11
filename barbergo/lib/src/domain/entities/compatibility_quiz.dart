import 'package:dart_mappable/dart_mappable.dart';

part 'compatibility_quiz.g.dart';

/// Entity para Compatibility Quiz (Phase 3)
/// Sistema de perguntas para avaliar compatibilidade
@MappableClass()
class CompatibilityQuiz with CompatibilityQuizMappable {
  final String quizId;
  final String title;
  final String description;
  final QuizCategory category;
  final List<QuizQuestion> questions;
  final int estimatedMinutes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CompatibilityQuiz({
    required this.quizId,
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
    required this.estimatedMinutes,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  CompatibilityQuiz copyWith({bool? isActive, DateTime? updatedAt}) {
    return CompatibilityQuiz(
      quizId: quizId,
      title: title,
      description: description,
      category: category,
      questions: questions,
      estimatedMinutes: estimatedMinutes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Categorias de quiz
enum QuizCategory {
  personality, // Personalidade
  values, // Valores
  lifestyle, // Estilo de vida
  relationshipGoals, // Objetivos de relacionamento
  communication, // Comunicação
  interests, // Interesses
  dealBreakers, // Deal breakers
  futureVision, // Visão de futuro
}

/// Pergunta do quiz
@MappableClass()
class QuizQuestion with QuizQuestionMappable {
  final String questionId;
  final String text;
  final QuestionType type;
  final List<QuizOption> options;
  final bool isRequired;
  final int weight; // 1-10 (importância)
  final String? explanation;

  const QuizQuestion({
    required this.questionId,
    required this.text,
    required this.type,
    required this.options,
    this.isRequired = true,
    this.weight = 5,
    this.explanation,
  });
}

/// Tipos de pergunta
enum QuestionType {
  singleChoice, // Escolha única
  multipleChoice, // Múltipla escolha
  scale, // Escala (1-5, 1-10)
  ranking, // Ordenar por preferência
  boolean, // Sim/Não
}

/// Opção de resposta
@MappableClass()
class QuizOption with QuizOptionMappable {
  final String optionId;
  final String text;
  final int value; // Valor numérico para cálculo
  final String? description;

  const QuizOption({required this.optionId, required this.text, required this.value, this.description});
}

/// Resposta do usuário ao quiz
@MappableClass()
class QuizResponse with QuizResponseMappable {
  final String responseId;
  final String userId;
  final String quizId;
  final Map<String, dynamic> answers; // questionId -> answer
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isComplete;
  final int timeSpentSeconds;

  const QuizResponse({
    required this.responseId,
    required this.userId,
    required this.quizId,
    required this.answers,
    required this.startedAt,
    this.completedAt,
    this.isComplete = false,
    this.timeSpentSeconds = 0,
  });

  QuizResponse copyWith({
    Map<String, dynamic>? answers,
    DateTime? completedAt,
    bool? isComplete,
    int? timeSpentSeconds,
  }) {
    return QuizResponse(
      responseId: responseId,
      userId: userId,
      quizId: quizId,
      answers: answers ?? this.answers,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      isComplete: isComplete ?? this.isComplete,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
    );
  }

  /// Calcular progresso (%)
  double calculateProgress(int totalQuestions) {
    if (totalQuestions == 0) return 0;
    return (answers.length / totalQuestions) * 100;
  }
}

/// Resultado do quiz
@MappableClass()
class QuizResult with QuizResultMappable {
  final String resultId;
  final String userId;
  final String quizId;
  final Map<QuizCategory, double> categoryScores; // 0-100
  final PersonalityProfile? personalityProfile;
  final List<QuizInsight> insights;
  final DateTime generatedAt;

  const QuizResult({
    required this.resultId,
    required this.userId,
    required this.quizId,
    required this.categoryScores,
    this.personalityProfile,
    required this.insights,
    required this.generatedAt,
  });
}

/// Perfil de personalidade (MBTI-like)
@MappableClass()
class PersonalityProfile with PersonalityProfileMappable {
  final String profileId;
  final String userId;
  final PersonalityType type;
  final Map<PersonalityTrait, int> traits; // 0-100
  final String description;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<PersonalityType> compatibleTypes;
  final DateTime generatedAt;

  const PersonalityProfile({
    required this.profileId,
    required this.userId,
    required this.type,
    required this.traits,
    required this.description,
    required this.strengths,
    required this.weaknesses,
    required this.compatibleTypes,
    required this.generatedAt,
  });
}

/// Tipos de personalidade (simplificado MBTI)
enum PersonalityType {
  // Extroversion vs Introversion
  // Sensing vs Intuition
  // Thinking vs Feeling
  // Judging vs Perceiving
  analyst, // Analítico (INTJ, INTP, ENTJ, ENTP)
  diplomat, // Diplomata (INFJ, INFP, ENFJ, ENFP)
  sentinel, // Sentinela (ISTJ, ISFJ, ESTJ, ESFJ)
  explorer, // Explorador (ISTP, ISFP, ESTP, ESFP)
}

/// Traços de personalidade
enum PersonalityTrait {
  extroversion, // Extroversão
  agreeableness, // Amabilidade
  conscientiousness, // Conscienciosidade
  emotionalStability, // Estabilidade emocional
  openness, // Abertura a experiências
}

/// Insight do quiz
@MappableClass()
class QuizInsight with QuizInsightMappable {
  final String insightId;
  final QuizInsightType type;
  final String title;
  final String message;
  final double confidence; // 0-1

  const QuizInsight({
    required this.insightId,
    required this.type,
    required this.title,
    required this.message,
    required this.confidence,
  });
}

/// Tipos de insight do quiz
enum QuizInsightType { strength, improvement, compatibility, warning, recommendation }

/// Comparação entre dois usuários
@MappableClass()
class QuizCompatibilityComparison with QuizCompatibilityComparisonMappable {
  final String comparisonId;
  final String user1Id;
  final String user2Id;
  final double overallCompatibility; // 0-100
  final Map<QuizCategory, double> categoryCompatibility;
  final List<CompatibilityMatch> matches;
  final List<CompatibilityConflict> conflicts;
  final List<String> recommendations;
  final DateTime comparedAt;

  const QuizCompatibilityComparison({
    required this.comparisonId,
    required this.user1Id,
    required this.user2Id,
    required this.overallCompatibility,
    required this.categoryCompatibility,
    required this.matches,
    required this.conflicts,
    required this.recommendations,
    required this.comparedAt,
  });

  /// Verificar se é alta compatibilidade
  bool get isHighCompatibility => overallCompatibility >= 75;

  /// Obter categoria com maior compatibilidade
  QuizCategory? get topCategory {
    if (categoryCompatibility.isEmpty) return null;
    return categoryCompatibility.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

/// Match entre respostas
@MappableClass()
class CompatibilityMatch with CompatibilityMatchMappable {
  final String questionId;
  final String questionText;
  final String user1Answer;
  final String user2Answer;
  final double matchScore; // 0-100

  const CompatibilityMatch({
    required this.questionId,
    required this.questionText,
    required this.user1Answer,
    required this.user2Answer,
    required this.matchScore,
  });
}

/// Conflito entre respostas
@MappableClass()
class CompatibilityConflict with CompatibilityConflictMappable {
  final String questionId;
  final String questionText;
  final String user1Answer;
  final String user2Answer;
  final ConflictSeverity severity;
  final String? resolutionTip;

  const CompatibilityConflict({
    required this.questionId,
    required this.questionText,
    required this.user1Answer,
    required this.user2Answer,
    required this.severity,
    this.resolutionTip,
  });
}

/// Severidade do conflito
enum ConflictSeverity {
  low, // Baixa (diferenças pequenas)
  medium, // Média (pode causar atrito)
  high, // Alta (deal breaker potencial)
  critical, // Crítica (incompatibilidade fundamental)
}

/// Estatísticas do quiz
@MappableClass()
class QuizStats with QuizStatsMappable {
  final String quizId;
  final int totalResponses;
  final int completedResponses;
  final double averageCompletionTime; // Minutos
  final double completionRate; // 0-1
  final Map<String, int> popularAnswers; // questionId -> most common answer
  final DateTime generatedAt;

  const QuizStats({
    required this.quizId,
    required this.totalResponses,
    required this.completedResponses,
    required this.averageCompletionTime,
    required this.completionRate,
    required this.popularAnswers,
    required this.generatedAt,
  });
}

/// Request para criar quiz
@MappableClass()
class CreateQuizRequest with CreateQuizRequestMappable {
  final String title;
  final String description;
  final QuizCategory category;
  final List<QuizQuestion> questions;

  const CreateQuizRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
  });
}

/// Request para submeter resposta
@MappableClass()
class SubmitQuizRequest with SubmitQuizRequestMappable {
  final String quizId;
  final Map<String, dynamic> answers;
  final int timeSpentSeconds;

  const SubmitQuizRequest({required this.quizId, required this.answers, required this.timeSpentSeconds});
}
