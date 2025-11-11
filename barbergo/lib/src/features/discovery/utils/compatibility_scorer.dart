import '../../../domain/entities/profile_entity.dart';

/// Enhanced Discovery Algorithm - Phase 1
///
/// Calcula score de compatibilidade entre dois perfis baseado em múltiplos fatores.
class CompatibilityScorer {
  /// Calcular score total de compatibilidade (0.0 - 1.0)
  static double calculateScore({required ProfileEntity userProfile, required ProfileEntity targetProfile}) {
    double totalScore = 0.0;
    int factors = 0;

    // 1. Proximidade Geográfica (peso: 25%)
    final distanceScore = _calculateDistanceScore(userProfile, targetProfile);
    if (distanceScore != null) {
      totalScore += distanceScore * 0.25;
      factors++;
    }

    // 2. Preferências de Serviço (peso: 20%)
    final serviceScore = _calculateServiceScore(userProfile, targetProfile);
    if (serviceScore != null) {
      totalScore += serviceScore * 0.20;
      factors++;
    }

    // 3. Disponibilidade (peso: 15%)
    final availabilityScore = _calculateAvailabilityScore(targetProfile);
    totalScore += availabilityScore * 0.15;
    factors++;

    // 4. Rating e Avaliações (peso: 15%)
    final ratingScore = _calculateRatingScore(targetProfile);
    totalScore += ratingScore * 0.15;
    factors++;

    // 5. Atividade Recente (peso: 10%)
    final activityScore = _calculateActivityScore(targetProfile);
    totalScore += activityScore * 0.10;
    factors++;

    // 6. Completude do Perfil (peso: 10%)
    final completenessScore = _calculateCompletenessScore(targetProfile);
    totalScore += completenessScore * 0.10;
    factors++;

    // 7. Prompts e Personalidade (peso: 5%)
    final promptScore = _calculatePromptScore(targetProfile);
    totalScore += promptScore * 0.05;
    factors++;

    return factors > 0 ? totalScore : 0.0;
  }

  /// 1. Score de distância (quanto mais perto, melhor)
  static double? _calculateDistanceScore(ProfileEntity user, ProfileEntity target) {
    // TODO: Implementar cálculo de distância real via GeoFirePoint
    // Por enquanto, retornar score médio
    return 0.7;
  }

  /// 2. Score de compatibilidade de serviços
  static double? _calculateServiceScore(ProfileEntity user, ProfileEntity target) {
    // TODO: Comparar serviceTypes quando implementado
    // Por enquanto, retornar score médio
    return 0.6;
  }

  /// 3. Score de disponibilidade
  static double _calculateAvailabilityScore(ProfileEntity target) {
    // Perfis disponíveis agora recebem score máximo
    if (target.isAvailable) return 1.0;
    return 0.5;
  }

  /// 4. Score baseado em rating
  static double _calculateRatingScore(ProfileEntity target) {
    final rating = target.rating;
    if (rating == null || rating == 0) return 0.5; // Sem reviews = neutro

    // Normalizar rating (0-5) para (0-1)
    return rating / 5.0;
  }

  /// 5. Score de atividade recente
  static double _calculateActivityScore(ProfileEntity target) {
    final lastUpdate = target.updatedAt;
    final now = DateTime.now();
    final daysSinceUpdate = now.difference(lastUpdate).inDays;

    // Penalizar perfis inativos
    if (daysSinceUpdate <= 1) return 1.0; // Ativo hoje
    if (daysSinceUpdate <= 7) return 0.8; // Ativo na semana
    if (daysSinceUpdate <= 30) return 0.6; // Ativo no mês
    return 0.3; // Inativo há mais de 30 dias
  }

  /// 6. Score de completude do perfil
  static double _calculateCompletenessScore(ProfileEntity target) {
    int completed = 0;
    int total = 8;

    if (target.name.isNotEmpty) completed++;
    if (target.bio.isNotEmpty) completed++;
    if (target.photos.isNotEmpty) completed++;
    if (target.location != null) completed++;
    if (target.phoneNumber.isNotEmpty) completed++;
    if (target.serviceTypes.isNotEmpty) completed++;
    if (target.prompts.isNotEmpty) completed++; // Phase 1
    if (target.rating != null && target.rating! > 0) completed++;

    return completed / total;
  }

  /// 7. Score de prompts (Phase 1)
  static double _calculatePromptScore(ProfileEntity target) {
    final promptCount = target.prompts.length;

    // 0 prompts = 0.0, 1-2 prompts = 0.5, 3+ prompts = 1.0
    if (promptCount == 0) return 0.0;
    if (promptCount < 3) return 0.5;
    return 1.0;
  }
}

/// Ordenador de perfis com múltiplos critérios
class ProfileSorter {
  /// Ordenar perfis por prioridade (boost > premium > score > atividade)
  static List<ProfileEntity> sortByPriority({
    required List<ProfileEntity> profiles,
    required ProfileEntity userProfile,
  }) {
    final now = DateTime.now();

    // Calcular scores para todos os perfis
    final profilesWithScore = profiles.map((profile) {
      return _ProfileWithScore(
        profile: profile,
        compatibilityScore: CompatibilityScorer.calculateScore(userProfile: userProfile, targetProfile: profile),
      );
    }).toList();

    // Ordenar com múltiplos critérios
    profilesWithScore.sort((a, b) {
      // 1. Boosted profiles primeiro
      final aIsBoosted = a.profile.boostedUntil != null && a.profile.boostedUntil!.isAfter(now);
      final bIsBoosted = b.profile.boostedUntil != null && b.profile.boostedUntil!.isAfter(now);
      if (aIsBoosted && !bIsBoosted) return -1;
      if (!aIsBoosted && bIsBoosted) return 1;

      // 2. Premium profiles depois
      if (a.profile.isPremium && !b.profile.isPremium) return -1;
      if (!a.profile.isPremium && b.profile.isPremium) return 1;

      // 3. Score de compatibilidade
      final scoreDiff = b.compatibilityScore.compareTo(a.compatibilityScore);
      if (scoreDiff != 0) return scoreDiff;

      // 4. Atividade recente (updatedAt)
      return b.profile.updatedAt.compareTo(a.profile.updatedAt);
    });

    return profilesWithScore.map((p) => p.profile).toList();
  }
}

/// Wrapper interno para perfil + score
class _ProfileWithScore {
  final ProfileEntity profile;
  final double compatibilityScore;

  _ProfileWithScore({required this.profile, required this.compatibilityScore});
}
