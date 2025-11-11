import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/compatibility_quiz.dart';

part 'compatibility_quiz_repository.g.dart';

/// Repository para Compatibility Quiz
@riverpod
CompatibilityQuizRepository compatibilityQuizRepository(CompatibilityQuizRepositoryRef ref) {
  return CompatibilityQuizRepository(FirebaseFirestore.instance);
}

class CompatibilityQuizRepository {
  final FirebaseFirestore _firestore;

  CompatibilityQuizRepository(this._firestore);

  CollectionReference get _quizzesCollection => _firestore.collection('compatibility_quizzes');
  CollectionReference get _responsesCollection => _firestore.collection('quiz_responses');
  CollectionReference get _resultsCollection => _firestore.collection('quiz_results');
  CollectionReference get _personalityCollection => _firestore.collection('personality_profiles');

  // ============================================
  // QUIZZES
  // ============================================

  /// Criar novo quiz
  Future<String> createQuiz(CompatibilityQuiz quiz) async {
    final docRef = await _quizzesCollection.add(quiz.toMap());
    return docRef.id;
  }

  /// Obter quiz por ID
  Future<CompatibilityQuiz?> getQuiz(String quizId) async {
    final doc = await _quizzesCollection.doc(quizId).get();
    if (!doc.exists) return null;

    return CompatibilityQuizMapper.fromMap({...doc.data() as Map<String, dynamic>, 'quizId': doc.id});
  }

  /// Obter todos os quizzes ativos
  Future<List<CompatibilityQuiz>> getActiveQuizzes() async {
    final snapshot = await _quizzesCollection
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => CompatibilityQuizMapper.fromMap({...doc.data() as Map<String, dynamic>, 'quizId': doc.id}))
        .toList();
  }

  /// Obter quizzes por categoria
  Future<List<CompatibilityQuiz>> getQuizzesByCategory(QuizCategory category) async {
    final snapshot = await _quizzesCollection
        .where('category', isEqualTo: category.name)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => CompatibilityQuizMapper.fromMap({...doc.data() as Map<String, dynamic>, 'quizId': doc.id}))
        .toList();
  }

  /// Atualizar quiz
  Future<void> updateQuiz(String quizId, Map<String, dynamic> updates) async {
    await _quizzesCollection.doc(quizId).update(updates);
  }

  // ============================================
  // RESPONSES
  // ============================================

  /// Iniciar resposta de quiz
  Future<String> startQuizResponse(QuizResponse response) async {
    final docRef = await _responsesCollection.add(response.toMap());
    return docRef.id;
  }

  /// Atualizar resposta de quiz
  Future<void> updateQuizResponse(String responseId, QuizResponse response) async {
    await _responsesCollection.doc(responseId).update(response.toMap());
  }

  /// Obter resposta de quiz
  Future<QuizResponse?> getQuizResponse(String responseId) async {
    final doc = await _responsesCollection.doc(responseId).get();
    if (!doc.exists) return null;

    return QuizResponseMapper.fromMap({...doc.data() as Map<String, dynamic>, 'responseId': doc.id});
  }

  /// Obter respostas do usuário
  Future<List<QuizResponse>> getUserResponses(String userId) async {
    final snapshot = await _responsesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('startedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => QuizResponseMapper.fromMap({...doc.data() as Map<String, dynamic>, 'responseId': doc.id}))
        .toList();
  }

  /// Obter resposta específica do usuário para um quiz
  Future<QuizResponse?> getUserQuizResponse(String userId, String quizId) async {
    final snapshot = await _responsesCollection
        .where('userId', isEqualTo: userId)
        .where('quizId', isEqualTo: quizId)
        .where('isComplete', isEqualTo: true)
        .orderBy('completedAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return QuizResponseMapper.fromMap({
      ...snapshot.docs.first.data() as Map<String, dynamic>,
      'responseId': snapshot.docs.first.id,
    });
  }

  // ============================================
  // RESULTS
  // ============================================

  /// Salvar resultado do quiz
  Future<String> saveQuizResult(QuizResult result) async {
    final docRef = await _resultsCollection.add(result.toMap());
    return docRef.id;
  }

  /// Obter resultado do quiz
  Future<QuizResult?> getQuizResult(String userId, String quizId) async {
    final snapshot = await _resultsCollection
        .where('userId', isEqualTo: userId)
        .where('quizId', isEqualTo: quizId)
        .orderBy('generatedAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return QuizResultMapper.fromMap({
      ...snapshot.docs.first.data() as Map<String, dynamic>,
      'resultId': snapshot.docs.first.id,
    });
  }

  /// Obter todos os resultados do usuário
  Future<List<QuizResult>> getUserResults(String userId) async {
    final snapshot = await _resultsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('generatedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => QuizResultMapper.fromMap({...doc.data() as Map<String, dynamic>, 'resultId': doc.id}))
        .toList();
  }

  // ============================================
  // PERSONALITY PROFILES
  // ============================================

  /// Salvar perfil de personalidade
  Future<void> savePersonalityProfile(PersonalityProfile profile) async {
    await _personalityCollection.doc(profile.userId).set(profile.toMap());
  }

  /// Obter perfil de personalidade
  Future<PersonalityProfile?> getPersonalityProfile(String userId) async {
    final doc = await _personalityCollection.doc(userId).get();
    if (!doc.exists) return null;

    return PersonalityProfileMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  // ============================================
  // COMPATIBILITY COMPARISON
  // ============================================

  /// Salvar comparação de compatibilidade
  Future<String> saveCompatibilityComparison(QuizCompatibilityComparison comparison) async {
    final docRef = await _firestore.collection('quiz_compatibility_comparisons').add(comparison.toMap());
    return docRef.id;
  }

  /// Obter comparação entre dois usuários
  Future<QuizCompatibilityComparison?> getCompatibilityComparison(String userId1, String userId2) async {
    // Normalizar ordem dos IDs
    final users = [userId1, userId2]..sort();

    final snapshot = await _firestore
        .collection('quiz_compatibility_comparisons')
        .where('user1Id', isEqualTo: users[0])
        .where('user2Id', isEqualTo: users[1])
        .orderBy('comparedAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return QuizCompatibilityComparisonMapper.fromMap({
      ...snapshot.docs.first.data(),
      'comparisonId': snapshot.docs.first.id,
    });
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Obter estatísticas do quiz
  Future<QuizStats> getQuizStats(String quizId) async {
    final snapshot = await _responsesCollection.where('quizId', isEqualTo: quizId).get();

    final responses = snapshot.docs
        .map((doc) => QuizResponseMapper.fromMap({...doc.data() as Map<String, dynamic>, 'responseId': doc.id}))
        .toList();

    final completed = responses.where((r) => r.isComplete).length;
    final totalTime = responses.where((r) => r.isComplete).fold<int>(0, (sum, r) => sum + r.timeSpentSeconds);

    return QuizStats(
      quizId: quizId,
      totalResponses: responses.length,
      completedResponses: completed,
      averageCompletionTime: completed > 0 ? totalTime / completed / 60 : 0,
      completionRate: responses.isEmpty ? 0 : completed / responses.length,
      popularAnswers: {}, // TODO: Implementar análise de respostas populares
      generatedAt: DateTime.now(),
    );
  }

  /// Stream de quizzes ativos
  Stream<List<CompatibilityQuiz>> watchActiveQuizzes() {
    return _quizzesCollection
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CompatibilityQuizMapper.fromMap({...doc.data() as Map<String, dynamic>, 'quizId': doc.id}))
              .toList(),
        );
  }

  /// Deletar resposta (GDPR)
  Future<void> deleteUserResponses(String userId) async {
    final batch = _firestore.batch();

    final responses = await _responsesCollection.where('userId', isEqualTo: userId).get();

    for (final doc in responses.docs) {
      batch.delete(doc.reference);
    }

    final results = await _resultsCollection.where('userId', isEqualTo: userId).get();

    for (final doc in results.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
