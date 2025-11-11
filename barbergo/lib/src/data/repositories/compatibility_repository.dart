import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/compatibility_score.dart';

part 'compatibility_repository.g.dart';

/// Repository para Compatibility Scores
@riverpod
CompatibilityRepository compatibilityRepository(CompatibilityRepositoryRef ref) {
  return CompatibilityRepository(FirebaseFirestore.instance);
}

class CompatibilityRepository {
  final FirebaseFirestore _firestore;

  CompatibilityRepository(this._firestore);

  CollectionReference get _scoresCollection => _firestore.collection('compatibility_scores');
  CollectionReference get _behaviorCollection => _firestore.collection('user_behavior_profiles');
  CollectionReference get _configCollection => _firestore.collection('matching_config');

  // ============================================
  // COMPATIBILITY SCORES
  // ============================================

  /// Salvar score de compatibilidade
  Future<String> saveScore(CompatibilityScore score) async {
    final docRef = await _scoresCollection.add(score.toMap());
    return docRef.id;
  }

  /// Obter score entre dois usuários
  Future<CompatibilityScore?> getScore(String userId1, String userId2) async {
    // Normalizar ordem (menor ID primeiro)
    final users = [userId1, userId2]..sort();

    final snapshot = await _scoresCollection
        .where('userId1', isEqualTo: users[0])
        .where('userId2', isEqualTo: users[1])
        .orderBy('calculatedAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return CompatibilityScoreMapper.fromMap({
      ...snapshot.docs.first.data() as Map<String, dynamic>,
      'scoreId': snapshot.docs.first.id,
    });
  }

  /// Obter todos os scores de um usuário
  Future<List<CompatibilityScore>> getUserScores(String userId, {int limit = 50}) async {
    final snapshot1 = await _scoresCollection
        .where('userId1', isEqualTo: userId)
        .orderBy('overallScore', descending: true)
        .limit(limit)
        .get();

    final snapshot2 = await _scoresCollection
        .where('userId2', isEqualTo: userId)
        .orderBy('overallScore', descending: true)
        .limit(limit)
        .get();

    final scores = <CompatibilityScore>[];

    for (final doc in snapshot1.docs) {
      scores.add(CompatibilityScoreMapper.fromMap({...doc.data() as Map<String, dynamic>, 'scoreId': doc.id}));
    }

    for (final doc in snapshot2.docs) {
      scores.add(CompatibilityScoreMapper.fromMap({...doc.data() as Map<String, dynamic>, 'scoreId': doc.id}));
    }

    // Ordenar por score
    scores.sort((a, b) => b.overallScore.compareTo(a.overallScore));
    return scores.take(limit).toList();
  }

  /// Obter top matches para um usuário
  Future<List<CompatibilityScore>> getTopMatches(String userId, {double minScore = 70.0, int limit = 20}) async {
    final allScores = await getUserScores(userId, limit: 100);

    return allScores.where((s) => s.overallScore >= minScore).take(limit).toList();
  }

  /// Atualizar score existente
  Future<void> updateScore(String scoreId, CompatibilityScore score) async {
    await _scoresCollection.doc(scoreId).update(score.toMap());
  }

  /// Deletar score
  Future<void> deleteScore(String scoreId) async {
    await _scoresCollection.doc(scoreId).delete();
  }

  // ============================================
  // BEHAVIORAL PROFILES
  // ============================================

  /// Salvar perfil comportamental
  Future<void> saveBehaviorProfile(UserBehaviorProfile profile) async {
    await _behaviorCollection.doc(profile.userId).set(profile.toMap());
  }

  /// Obter perfil comportamental
  Future<UserBehaviorProfile?> getBehaviorProfile(String userId) async {
    final doc = await _behaviorCollection.doc(userId).get();
    if (!doc.exists) return null;

    return UserBehaviorProfileMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  /// Atualizar perfil comportamental
  Future<void> updateBehaviorProfile(String userId, Map<String, dynamic> updates) async {
    await _behaviorCollection.doc(userId).update(updates);
  }

  // ============================================
  // ML FEATURES
  // ============================================

  /// Salvar feature vector (para ML)
  Future<void> saveFeatureVector(MLFeatureVector vector) async {
    await _firestore.collection('ml_features').doc(vector.userId).set(vector.toMap());
  }

  /// Obter feature vector
  Future<MLFeatureVector?> getFeatureVector(String userId) async {
    final doc = await _firestore.collection('ml_features').doc(userId).get();

    if (!doc.exists) return null;

    return MLFeatureVectorMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  // ============================================
  // CONFIGURATION
  // ============================================

  /// Salvar configuração do algoritmo
  Future<void> saveConfig(MatchingAlgorithmConfig config) async {
    await _configCollection.doc('default').set(config.toMap());
  }

  /// Obter configuração do algoritmo
  Future<MatchingAlgorithmConfig> getConfig() async {
    final doc = await _configCollection.doc('default').get();

    if (!doc.exists) {
      return MatchingAlgorithmConfig.defaultConfig();
    }

    return MatchingAlgorithmConfigMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Obter estatísticas de matching
  Future<MatchingStats> getMatchingStats({DateTime? startDate, DateTime? endDate}) async {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = endDate ?? DateTime.now();

    final snapshot = await _scoresCollection
        .where('calculatedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('calculatedAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    if (snapshot.docs.isEmpty) {
      return MatchingStats(
        totalScoresCalculated: 0,
        averageScore: 0,
        highCompatibilityCount: 0,
        factorAverages: {},
        periodStart: start,
        periodEnd: end,
      );
    }

    final scores = snapshot.docs
        .map((doc) => CompatibilityScoreMapper.fromMap({...doc.data() as Map<String, dynamic>, 'scoreId': doc.id}))
        .toList();

    final totalScore = scores.fold<double>(0, (sum, s) => sum + s.overallScore);
    final highCompat = scores.where((s) => s.overallScore >= 75).length;

    // Calcular médias por fator
    final factorAverages = <CompatibilityFactor, double>{};
    for (final factor in CompatibilityFactor.values) {
      final values = scores.map((s) => s.factorScores[factor] ?? 0).where((v) => v > 0).toList();

      if (values.isNotEmpty) {
        factorAverages[factor] = values.reduce((a, b) => a + b) / values.length;
      }
    }

    return MatchingStats(
      totalScoresCalculated: scores.length,
      averageScore: totalScore / scores.length,
      highCompatibilityCount: highCompat,
      factorAverages: factorAverages,
      periodStart: start,
      periodEnd: end,
    );
  }

  /// Obter insights agregados
  Future<Map<InsightType, int>> getInsightDistribution(String userId) async {
    final scores = await getUserScores(userId);

    final distribution = <InsightType, int>{};
    for (final type in InsightType.values) {
      distribution[type] = 0;
    }

    for (final score in scores) {
      for (final insight in score.insights) {
        distribution[insight.type] = (distribution[insight.type] ?? 0) + 1;
      }
    }

    return distribution;
  }

  /// Stream de scores do usuário
  Stream<List<CompatibilityScore>> watchUserScores(String userId) {
    return _scoresCollection
        .where('userId1', isEqualTo: userId)
        .orderBy('overallScore', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CompatibilityScoreMapper.fromMap({...doc.data() as Map<String, dynamic>, 'scoreId': doc.id}),
              )
              .toList(),
        );
  }
}
