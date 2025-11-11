import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/subscription.dart';
import '../../../data/repositories/subscription_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'subscription_controller.g.dart';

/// Controller para Premium Tiers System
@riverpod
class SubscriptionController extends _$SubscriptionController {
  @override
  FutureOr<bool> build() async { return true; }

  // ============================================
  // SUBSCRIPTION MANAGEMENT
  // ============================================

  /// Criar assinatura (iniciar trial ou compra)
  Future<Subscription> startSubscription({
    required SubscriptionTier tier,
    required BillingPeriod billingPeriod,
    bool startTrial = false,
    String? paymentProvider,
    String? externalSubscriptionId,
  }) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final now = DateTime.now();
      final subscription = Subscription(
        subscriptionId: '',
        userId: currentUser.userId,
        tier: tier,
        status: startTrial ? SubscriptionStatus.trialing : SubscriptionStatus.active,
        paymentProvider: paymentProvider,
        externalSubscriptionId: externalSubscriptionId,
        startDate: now,
        endDate: _calculateEndDate(now, billingPeriod),
        trialEndDate: startTrial ? now.add(const Duration(days: 7)) : null,
        isInTrial: startTrial,
        autoRenew: true,
        createdAt: now,
        updatedAt: now,
      );

      final repo = ref.read(subscriptionRepositoryProvider);
      await repo.createSubscription(subscription);

      state = const AsyncData(null);
      
      // Invalidar cache
      ref.invalidate(currentUserSubscriptionProvider);
      
      return subscription;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Cancelar assinatura
  Future<void> cancelSubscription(String reason) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final repo = ref.read(subscriptionRepositoryProvider);
      final subscription = await repo.getUserSubscription(currentUser.userId);
      
      if (subscription == null) {
        throw Exception('Assinatura não encontrada');
      }

      await repo.cancelSubscription(subscription.subscriptionId, reason);

      state = const AsyncData(null);
      ref.invalidate(currentUserSubscriptionProvider);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Fazer upgrade de tier
  Future<void> upgradeTier(SubscriptionTier newTier) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final repo = ref.read(subscriptionRepositoryProvider);
      await repo.upgradeTier(currentUser.userId, newTier);

      state = const AsyncData(null);
      ref.invalidate(currentUserSubscriptionProvider);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Fazer downgrade de tier
  Future<void> downgradeTier(SubscriptionTier newTier) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final repo = ref.read(subscriptionRepositoryProvider);
      await repo.downgradeTier(currentUser.userId, newTier);

      state = const AsyncData(null);
      ref.invalidate(currentUserSubscriptionProvider);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  // ============================================
  // PLANS & PRICING
  // ============================================

  /// Obter todos os planos disponíveis
  Future<List<SubscriptionPlan>> getAvailablePlans() async {
    final repo = ref.read(subscriptionRepositoryProvider);
    return repo.getAvailablePlans();
  }

  /// Obter tier features
  TierFeatures getTierFeatures(SubscriptionTier tier) {
    return _tierFeaturesMap[tier]!;
  }

  /// Comparar tiers
  List<TierComparison> compareTiers() {
    return _generateTierComparison();
  }

  // ============================================
  // FEATURE ACCESS
  // ============================================

  /// Verificar se tem acesso a feature
  Future<bool> hasFeatureAccess(PremiumFeature feature) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return false;

    final repo = ref.read(subscriptionRepositoryProvider);
    return repo.hasFeatureAccess(currentUser.userId, feature);
  }

  /// Verificar se pode usar feature (considerando limites)
  Future<bool> canUseFeature(PremiumFeature feature) async {
    // Verificar acesso
    final hasAccess = await hasFeatureAccess(feature);
    if (!hasAccess) return false;

    // Verificar limites de uso
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return false;

    final repo = ref.read(subscriptionRepositoryProvider);
    final usage = await repo.getFeatureUsage(currentUser.userId, feature);
    
    if (usage == null) return true; // Sem limite ou primeiro uso
    return usage.hasUsageAvailable;
  }

  /// Usar feature (incrementar contador)
  Future<void> useFeature(PremiumFeature feature) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return;

    final repo = ref.read(subscriptionRepositoryProvider);
    await repo.incrementFeatureUsage(currentUser.userId, feature);
  }

  /// Obter uso de feature
  Future<FeatureUsage?> getFeatureUsage(PremiumFeature feature) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return null;

    final repo = ref.read(subscriptionRepositoryProvider);
    return repo.getFeatureUsage(currentUser.userId, feature);
  }

  // ============================================
  // OFFERS
  // ============================================

  /// Obter ofertas disponíveis
  Future<List<SubscriptionOffer>> getActiveOffers() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(subscriptionRepositoryProvider);
    return repo.getActiveOffers(userId: currentUser.userId);
  }

  /// Aplicar oferta
  Future<double> applyOffer(String offerId, double originalPrice) async {
    final repo = ref.read(subscriptionRepositoryProvider);
    final offers = await repo.getActiveOffers();
    
    final offer = offers.firstWhere(
      (o) => o.offerId == offerId,
      orElse: () => throw Exception('Oferta não encontrada'),
    );

    await repo.redeemOffer(offerId);
    return offer.calculateDiscountedPrice(originalPrice);
  }

  // ============================================
  // HISTORY & STATS
  // ============================================

  /// Obter histórico de assinaturas
  Future<List<SubscriptionHistory>> getHistory() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(subscriptionRepositoryProvider);
    return repo.getUserHistory(currentUser.userId);
  }

  /// Obter estatísticas
  Future<SubscriptionStats> getStats() async {
    final repo = ref.read(subscriptionRepositoryProvider);
    return repo.getStats();
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  DateTime _calculateEndDate(DateTime start, BillingPeriod period) {
    switch (period) {
      case BillingPeriod.monthly:
        return start.add(const Duration(days: 30));
      case BillingPeriod.quarterly:
        return start.add(const Duration(days: 90));
      case BillingPeriod.yearly:
        return start.add(const Duration(days: 365));
      case BillingPeriod.lifetime:
        return start.add(const Duration(days: 36500)); // 100 anos
    }
  }

  // ============================================
  // TIER FEATURES CONFIGURATION
  // ============================================

  static final Map<SubscriptionTier, TierFeatures> _tierFeaturesMap = {
    SubscriptionTier.free: TierFeatures(
      tier: SubscriptionTier.free,
      name: 'Free',
      description: 'Recursos básicos para começar',
      monthlyPrice: 0,
      yearlyPrice: 0,
      features: [
        const FeatureAccess(
          featureKey: 'likes',
          featureName: 'Likes diários',
          limit: 20,
        ),
        const FeatureAccess(
          featureKey: 'matches',
          featureName: 'Matches ilimitados',
        ),
        const FeatureAccess(
          featureKey: 'messages',
          featureName: 'Mensagens ilimitadas',
        ),
      ],
      highlightedFeatures: [
        '20 likes por dia',
        'Matches ilimitados',
        'Mensagens ilimitadas',
      ],
    ),
    SubscriptionTier.basic: TierFeatures(
      tier: SubscriptionTier.basic,
      name: 'Basic',
      description: 'Mais matches e recursos',
      monthlyPrice: 19.99,
      yearlyPrice: 179.99,
      trialDays: 7,
      features: [
        const FeatureAccess(
          featureKey: 'unlimitedLikes',
          featureName: 'Likes ilimitados',
        ),
        const FeatureAccess(
          featureKey: 'rewind',
          featureName: 'Desfazer swipes',
          limit: 5,
          description: '5 por dia',
        ),
        const FeatureAccess(
          featureKey: 'seeWhoLikedYou',
          featureName: 'Ver quem curtiu você',
        ),
        const FeatureAccess(
          featureKey: 'advancedFilters',
          featureName: 'Filtros avançados',
        ),
        const FeatureAccess(
          featureKey: 'topPicks',
          featureName: 'Top Picks diários',
          limit: 3,
        ),
      ],
      highlightedFeatures: [
        'Likes ilimitados',
        'Ver quem curtiu você',
        'Desfazer swipes (5/dia)',
        'Filtros avançados',
        '3 Top Picks/dia',
      ],
    ),
    SubscriptionTier.premium: TierFeatures(
      tier: SubscriptionTier.premium,
      name: 'Premium',
      description: 'Máxima visibilidade e recursos',
      monthlyPrice: 39.99,
      yearlyPrice: 359.99,
      trialDays: 7,
      features: [
        const FeatureAccess(
          featureKey: 'allBasic',
          featureName: 'Todos recursos Basic',
        ),
        const FeatureAccess(
          featureKey: 'profileBoost',
          featureName: 'Profile Boost',
          limit: 2,
          description: '2 por mês',
        ),
        const FeatureAccess(
          featureKey: 'superLike',
          featureName: 'Super Likes',
          limit: 5,
          description: '5 por semana',
        ),
        const FeatureAccess(
          featureKey: 'videoCall',
          featureName: 'Videochamadas ilimitadas',
        ),
        const FeatureAccess(
          featureKey: 'readReceipts',
          featureName: 'Confirmação de leitura',
        ),
        const FeatureAccess(
          featureKey: 'hideAge',
          featureName: 'Ocultar idade',
        ),
        const FeatureAccess(
          featureKey: 'morePhotos',
          featureName: 'Até 15 fotos',
        ),
      ],
      highlightedFeatures: [
        'Tudo do Basic',
        '2 Profile Boosts/mês',
        '5 Super Likes/semana',
        'Videochamadas',
        'Confirmação de leitura',
        'Até 15 fotos',
      ],
    ),
    SubscriptionTier.elite: TierFeatures(
      tier: SubscriptionTier.elite,
      name: 'Elite',
      description: 'Experiência completa e exclusiva',
      monthlyPrice: 59.99,
      yearlyPrice: 539.99,
      trialDays: 14,
      features: [
        const FeatureAccess(
          featureKey: 'allPremium',
          featureName: 'Todos recursos Premium',
        ),
        const FeatureAccess(
          featureKey: 'incognitoMode',
          featureName: 'Modo Incógnito',
        ),
        const FeatureAccess(
          featureKey: 'customBadge',
          featureName: 'Badge customizado',
        ),
        const FeatureAccess(
          featureKey: 'profileAnalytics',
          featureName: 'Analytics do perfil',
        ),
        const FeatureAccess(
          featureKey: 'whoViewedYou',
          featureName: 'Quem visualizou você',
        ),
        const FeatureAccess(
          featureKey: 'prioritySupport',
          featureName: 'Suporte prioritário',
        ),
        const FeatureAccess(
          featureKey: 'aiDatePlanning',
          featureName: 'Planejamento com IA',
        ),
        const FeatureAccess(
          featureKey: 'exclusiveLocations',
          featureName: 'Localizações exclusivas',
        ),
      ],
      highlightedFeatures: [
        'Tudo do Premium',
        'Modo Incógnito',
        'Badge customizado',
        'Analytics completo',
        'Suporte prioritário',
        'IA exclusiva',
      ],
    ),
  };

  List<TierComparison> _generateTierComparison() {
    return [
      TierComparison(
        tier: SubscriptionTier.free,
        features: {
          'Likes diários': true,
          'Matches ilimitados': true,
          'Mensagens': true,
          'Likes ilimitados': false,
          'Ver quem curtiu': false,
          'Profile Boost': false,
          'Modo Incógnito': false,
        },
        pros: ['Grátis', 'Sem compromisso'],
        cons: ['Apenas 20 likes/dia', 'Sem recursos avançados'],
      ),
      TierComparison(
        tier: SubscriptionTier.basic,
        features: {
          'Likes diários': true,
          'Matches ilimitados': true,
          'Mensagens': true,
          'Likes ilimitados': true,
          'Ver quem curtiu': true,
          'Profile Boost': false,
          'Modo Incógnito': false,
        },
        pros: ['Likes ilimitados', 'Ver quem curtiu', 'Filtros avançados'],
        cons: ['Sem boosts', 'Sem modo incógnito'],
      ),
      TierComparison(
        tier: SubscriptionTier.premium,
        features: {
          'Likes diários': true,
          'Matches ilimitados': true,
          'Mensagens': true,
          'Likes ilimitados': true,
          'Ver quem curtiu': true,
          'Profile Boost': true,
          'Modo Incógnito': false,
        },
        pros: ['Profile Boosts', 'Super Likes', 'Videochamadas', 'Mais fotos'],
        cons: ['Sem modo incógnito', 'Sem analytics'],
      ),
      TierComparison(
        tier: SubscriptionTier.elite,
        features: {
          'Likes diários': true,
          'Matches ilimitados': true,
          'Mensagens': true,
          'Likes ilimitados': true,
          'Ver quem curtiu': true,
          'Profile Boost': true,
          'Modo Incógnito': true,
        },
        pros: ['Recursos completos', 'Modo Incógnito', 'Analytics', 'Suporte prioritário'],
        cons: ['Mais caro'],
      ),
    ];
  }
}

/// Provider para assinatura do usuário atual
@riverpod
Future<Subscription?> currentUserSubscription(CurrentUserSubscriptionRef ref) async {
  final currentUser = ref.watch(currentUserProfileProvider).value;
  if (currentUser == null) return null;

  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.getUserSubscription(currentUser.userId);
}

/// Provider para tier do usuário atual
@riverpod
Future<SubscriptionTier> currentUserTier(CurrentUserTierRef ref) async {
  final subscription = await ref.watch(currentUserSubscriptionProvider.future);
  if (subscription == null || !subscription.isActive) {
    return SubscriptionTier.free;
  }
  return subscription.tier;
}

/// Provider para verificar feature access
@riverpod
Future<bool> hasFeature(HasFeatureRef ref, PremiumFeature feature) async {
  final controller = ref.watch(subscriptionControllerProvider.notifier);
  return controller.hasFeatureAccess(feature);
}

