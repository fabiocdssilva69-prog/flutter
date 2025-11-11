import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/compatibility_score.dart';
import '../../../../domain/entities/profile_entity.dart';
import '../../../data/repositories/compatibility_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'advanced_matching_controller.g.dart';

/// Controller para Advanced Matching Algorithm (Phase 3)
@riverpod
class AdvancedMatchingController extends _$AdvancedMatchingController {
  @override
  FutureOr<bool> build() {
    return true; // Inicializar
  }

  /// Calcular score de compatibilidade entre dois usuários
  Future<CompatibilityScore> calculateCompatibility({required String userId1, required String userId2}) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(compatibilityRepositoryProvider);

      // Verificar se já existe score recente (< 7 dias)
      final existing = await repo.getScore(userId1, userId2);
      if (existing != null && DateTime.now().difference(existing.calculatedAt).inDays < 7) {
        state = const AsyncData(null);
        return existing;
      }

      // Obter perfis
      final profileRepo = ref.read(profileRepositoryProvider);
      final profile1 = await profileRepo.getProfileById(userId1);
      final profile2 = await profileRepo.getProfileById(userId2);

      if (profile1 == null || profile2 == null) {
        throw Exception('Perfis não encontrados');
      }

      // Calcular scores por fator
      final factorScores = await _calculateFactorScores(profile1, profile2);

      // Calcular score geral
      final config = await repo.getConfig();
      final overallScore = _calculateOverallScore(factorScores, config);

      // Gerar insights
      final insights = _generateInsights(factorScores, profile1, profile2);

      // Gerar predição
      final prediction = _generatePrediction(overallScore, factorScores);

      // Análise comportamental (se disponível)
      BehavioralAnalysis? behavioralData;
      final behavior1 = await repo.getBehaviorProfile(userId1);
      final behavior2 = await repo.getBehaviorProfile(userId2);

      if (behavior1 != null && behavior2 != null) {
        behavioralData = _analyzeBehavioralCompatibility(behavior1, behavior2);
      }

      // Criar score
      final users = [userId1, userId2]..sort();
      final score = CompatibilityScore(
        scoreId: '',
        userId1: users[0],
        userId2: users[1],
        overallScore: overallScore,
        calculatedAt: DateTime.now(),
        factorScores: factorScores,
        insights: insights,
        prediction: prediction,
        behavioralData: behavioralData,
      );

      // Salvar
      await repo.saveScore(score);

      state = const AsyncData(null);
      return score;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Obter top matches para o usuário atual
  Future<List<CompatibilityScore>> getTopMatches({double minScore = 70.0, int limit = 20}) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(compatibilityRepositoryProvider);
    return repo.getTopMatches(currentUser.userId, minScore: minScore, limit: limit);
  }

  /// Atualizar perfil comportamental do usuário
  Future<void> updateBehaviorProfile({
    required String userId,
    ResponsePattern? responsePattern,
    ActivityPattern? activityPattern,
    double? averageResponseTimeMinutes,
  }) async {
    final repo = ref.read(compatibilityRepositoryProvider);

    final updates = <String, dynamic>{};
    if (responsePattern != null) updates['responsePattern'] = responsePattern.name;
    if (activityPattern != null) updates['activityPattern'] = activityPattern.name;
    if (averageResponseTimeMinutes != null) {
      updates['averageResponseTimeMinutes'] = averageResponseTimeMinutes;
    }

    await repo.updateBehaviorProfile(userId, updates);
  }

  /// Gerar feature vector para ML
  Future<MLFeatureVector> generateFeatureVector(String userId) async {
    final profileRepo = ref.read(profileRepositoryProvider);
    final profile = await profileRepo.getProfileById(userId);

    if (profile == null) {
      throw Exception('Perfil não encontrado');
    }

    // Extrair features numéricas
    final features = <double>[
      profile.age.toDouble(),
      profile.interests.length.toDouble(),
      profile.photos.length.toDouble(),
      profile.bio.length.toDouble() / 100, // Normalizar
      profile.rating,
      profile.reviewCount.toDouble(),
      // Adicionar mais features conforme necessário
    ];

    final vector = MLFeatureVector(
      userId: userId,
      features: features,
      metadata: {
        'profileCompleteness': _calculateProfileCompleteness(profile),
        'accountType': profile.accountType.name,
      },
      generatedAt: DateTime.now(),
    );

    // Salvar
    final repo = ref.read(compatibilityRepositoryProvider);
    await repo.saveFeatureVector(vector);

    return vector;
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  Future<Map<CompatibilityFactor, double>> _calculateFactorScores(
    ProfileEntity profile1,
    ProfileEntity profile2,
  ) async {
    return {
      CompatibilityFactor.interests: _calculateInterestsScore(profile1, profile2),
      CompatibilityFactor.values: _calculateValuesScore(profile1, profile2),
      CompatibilityFactor.lifestyle: _calculateLifestyleScore(profile1, profile2),
      CompatibilityFactor.location: _calculateLocationScore(profile1, profile2),
      CompatibilityFactor.personality: _calculatePersonalityScore(profile1, profile2),
      CompatibilityFactor.goals: _calculateGoalsScore(profile1, profile2),
      CompatibilityFactor.communication: _calculateCommunicationScore(profile1, profile2),
    };
  }

  double _calculateInterestsScore(ProfileEntity p1, ProfileEntity p2) {
    final common = p1.interests.toSet().intersection(p2.interests.toSet());
    final total = p1.interests.toSet().union(p2.interests.toSet());

    if (total.isEmpty) return 50.0;
    return (common.length / total.length) * 100;
  }

  double _calculateValuesScore(ProfileEntity p1, ProfileEntity p2) {
    // TODO: Implementar quando tiver campo de valores no perfil
    return 75.0; // Mock
  }

  double _calculateLifestyleScore(ProfileEntity p1, ProfileEntity p2) {
    // Comparar estilos de vida baseado em dados disponíveis
    var score = 70.0;

    // Se ambos são do mesmo tipo de conta
    if (p1.accountType == p2.accountType) {
      score += 10;
    }

    return score.clamp(0, 100);
  }

  double _calculateLocationScore(ProfileEntity p1, ProfileEntity p2) {
    if (p1.geoLocation == null || p2.geoLocation == null) return 50.0;

    // Calcular distância (simplificado)
    final distance = _calculateDistance(
      p1.geoLocation!.latitude,
      p1.geoLocation!.longitude,
      p2.geoLocation!.latitude,
      p2.geoLocation!.longitude,
    );

    // Converter distância em score (0-10km = 100, >50km = 0)
    if (distance <= 10) return 100.0;
    if (distance >= 50) return 0.0;
    return ((50 - distance) / 40) * 100;
  }

  double _calculatePersonalityScore(ProfileEntity p1, ProfileEntity p2) {
    // TODO: Implementar teste de personalidade
    return 80.0; // Mock
  }

  double _calculateGoalsScore(ProfileEntity p1, ProfileEntity p2) {
    // TODO: Implementar objetivos de relacionamento
    return 85.0; // Mock
  }

  double _calculateCommunicationScore(ProfileEntity p1, ProfileEntity p2) {
    // Baseado em completude do perfil e bio
    final p1Completeness = _calculateProfileCompleteness(p1);
    final p2Completeness = _calculateProfileCompleteness(p2);

    return (p1Completeness + p2Completeness) / 2;
  }

  double _calculateOverallScore(Map<CompatibilityFactor, double> factorScores, MatchingAlgorithmConfig config) {
    var total = 0.0;
    var totalWeight = 0.0;

    for (final entry in factorScores.entries) {
      final weight = config.factorWeights[entry.key] ?? 0.1;
      total += entry.value * weight;
      totalWeight += weight;
    }

    return totalWeight > 0 ? total / totalWeight : 0;
  }

  List<CompatibilityInsight> _generateInsights(
    Map<CompatibilityFactor, double> scores,
    ProfileEntity p1,
    ProfileEntity p2,
  ) {
    final insights = <CompatibilityInsight>[];

    // Insights para fatores fortes (>80)
    for (final entry in scores.entries) {
      if (entry.value >= 80) {
        insights.add(
          CompatibilityInsight(
            insightId: DateTime.now().millisecondsSinceEpoch.toString(),
            type: InsightType.strength,
            title: 'Forte compatibilidade em ${_getFactorName(entry.key)}',
            description: 'Vocês têm muito em comum nesta área!',
            impactScore: 8.0,
            suggestions: ['Explore este tema nas conversas'],
          ),
        );
      }
    }

    // Insights para fatores fracos (<40)
    for (final entry in scores.entries) {
      if (entry.value < 40) {
        insights.add(
          CompatibilityInsight(
            insightId: DateTime.now().millisecondsSinceEpoch.toString(),
            type: InsightType.opportunity,
            title: 'Oportunidade em ${_getFactorName(entry.key)}',
            description: 'Diferenças podem trazer crescimento!',
            impactScore: 6.0,
            suggestions: ['Esteja aberto a novas perspectivas'],
          ),
        );
      }
    }

    return insights.take(5).toList();
  }

  MatchPrediction _generatePrediction(double overallScore, Map<CompatibilityFactor, double> factors) {
    final probability = overallScore / 100;

    MatchOutcome outcome;
    if (overallScore >= 80) {
      outcome = MatchOutcome.highSuccess;
    } else if (overallScore >= 50) {
      outcome = MatchOutcome.moderateSuccess;
    } else if (overallScore >= 30) {
      outcome = MatchOutcome.uncertain;
    } else {
      outcome = MatchOutcome.lowSuccess;
    }

    return MatchPrediction(
      successProbability: probability,
      predictedOutcome: outcome,
      estimatedMessagesBeforeMeet: (50 - (overallScore / 2)).toInt().clamp(10, 40),
      estimatedDaysToFirstDate: (20 - (overallScore / 5)).toInt().clamp(3, 15),
      longTermPotential: overallScore,
      successFactors: factors.entries.where((e) => e.value >= 70).map((e) => _getFactorName(e.key)).toList(),
      riskFactors: factors.entries.where((e) => e.value < 40).map((e) => _getFactorName(e.key)).toList(),
    );
  }

  BehavioralAnalysis _analyzeBehavioralCompatibility(UserBehaviorProfile b1, UserBehaviorProfile b2) {
    // Calcular compatibilidade comportamental
    var score = 70.0;

    // Padrões de resposta similares
    if (b1.responsePattern == b2.responsePattern) score += 10;

    // Padrões de atividade compatíveis
    if (_areActivityPatternsCompatible(b1.activityPattern, b2.activityPattern)) {
      score += 10;
    }

    // Estilos de conversa complementares
    if (_areConversationStylesCompatible(b1.conversationStyle, b2.conversationStyle)) {
      score += 10;
    }

    return BehavioralAnalysis(
      analysisId: DateTime.now().millisecondsSinceEpoch.toString(),
      analyzedAt: DateTime.now(),
      user1Behavior: b1,
      user2Behavior: b2,
      behavioralCompatibility: score.clamp(0, 100),
      sharedPatterns: [],
      conflictingPatterns: [],
    );
  }

  bool _areActivityPatternsCompatible(ActivityPattern p1, ActivityPattern p2) {
    // Mesmo padrão ou complementares
    return p1 == p2 ||
        (p1 == ActivityPattern.morningPerson && p2 == ActivityPattern.afternoonPerson) ||
        (p1 == ActivityPattern.afternoonPerson && p2 == ActivityPattern.morningPerson);
  }

  bool _areConversationStylesCompatible(ConversationStyle s1, ConversationStyle s2) {
    // Estilos complementares
    if (s1 == ConversationStyle.detailed && s2 == ConversationStyle.analytical) return true;
    if (s1 == ConversationStyle.playful && s2 == ConversationStyle.playful) return true;
    return s1 == s2;
  }

  double _calculateProfileCompleteness(ProfileEntity profile) {
    var score = 0.0;

    if (profile.photos.isNotEmpty) score += 20;
    if (profile.bio.length >= 50) score += 20;
    if (profile.interests.length >= 3) score += 20;
    if (profile.serviceTypes.isNotEmpty) score += 20;
    if (profile.geoLocation != null) score += 20;

    return score;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // km

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(lat1)) * _cos(_toRadians(lat2)) * _sin(dLon / 2) * _sin(dLon / 2);

    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * 3.141592653589793 / 180;
  double _sin(double x) => x; // Simplificado
  double _cos(double x) => 1 - (x * x) / 2; // Simplificado
  double _sqrt(double x) => x < 0 ? 0 : x.sqrt();
  double _atan2(double y, double x) => y / x; // Simplificado

  String _getFactorName(CompatibilityFactor factor) {
    switch (factor) {
      case CompatibilityFactor.interests:
        return 'Interesses';
      case CompatibilityFactor.values:
        return 'Valores';
      case CompatibilityFactor.lifestyle:
        return 'Estilo de Vida';
      case CompatibilityFactor.location:
        return 'Localização';
      case CompatibilityFactor.personality:
        return 'Personalidade';
      case CompatibilityFactor.goals:
        return 'Objetivos';
      case CompatibilityFactor.communication:
        return 'Comunicação';
      default:
        return factor.name;
    }
  }
}

extension on double {
  double sqrt() {
    if (this <= 0) return 0;
    var guess = this / 2;
    for (var i = 0; i < 10; i++) {
      guess = (guess + this / guess) / 2;
    }
    return guess;
  }
}

/// Provider para score de compatibilidade
@riverpod
Future<CompatibilityScore?> compatibilityScore(CompatibilityScoreRef ref, String userId1, String userId2) async {
  final repo = ref.watch(compatibilityRepositoryProvider);
  return repo.getScore(userId1, userId2);
}

/// Provider para top matches
@riverpod
Future<List<CompatibilityScore>> topMatches(TopMatchesRef ref) async {
  final controller = ref.watch(advancedMatchingControllerProvider.notifier);
  return controller.getTopMatches();
}
