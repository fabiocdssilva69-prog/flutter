import 'package:dart_mappable/dart_mappable.dart';

part 'subscription.g.dart';

/// Entity para Premium Tiers System (Phase 4 - Feature 1/6)
/// Sistema de assinaturas e features premium
@MappableClass()
class Subscription with SubscriptionMappable {
  final String subscriptionId;
  final String userId;
  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final String? paymentProvider; // stripe, revenue_cat, etc
  final String? externalSubscriptionId;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? trialEndDate;
  final bool isInTrial;
  final bool autoRenew;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.subscriptionId,
    required this.userId,
    required this.tier,
    required this.status,
    this.paymentProvider,
    this.externalSubscriptionId,
    required this.startDate,
    this.endDate,
    this.trialEndDate,
    this.isInTrial = false,
    this.autoRenew = true,
    this.cancelledAt,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Verificar se está ativa
  bool get isActive => status == SubscriptionStatus.active || status == SubscriptionStatus.trialing;

  /// Verificar se expirou
  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  /// Dias restantes
  int get daysRemaining {
    if (endDate == null) return 999;
    return endDate!.difference(DateTime.now()).inDays;
  }
}

/// Tiers de assinatura
enum SubscriptionTier {
  free, // Grátis
  basic, // Básico
  premium, // Premium
  elite, // Elite
}

/// Status da assinatura
enum SubscriptionStatus {
  active, // Ativa
  trialing, // Em período de teste
  cancelled, // Cancelada
  expired, // Expirada
  pastDue, // Pagamento atrasado
  paused, // Pausada
}

/// Features disponíveis por tier
@MappableClass()
class TierFeatures with TierFeaturesMappable {
  final SubscriptionTier tier;
  final String name;
  final String description;
  final double monthlyPrice;
  final double yearlyPrice;
  final int trialDays;
  final List<FeatureAccess> features;
  final List<String> highlightedFeatures;

  const TierFeatures({
    required this.tier,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    this.trialDays = 0,
    required this.features,
    required this.highlightedFeatures,
  });

  /// Economia anual (%)
  double get yearlyDiscount {
    if (monthlyPrice == 0) return 0;
    final yearlyEquivalent = monthlyPrice * 12;
    return ((yearlyEquivalent - yearlyPrice) / yearlyEquivalent) * 100;
  }
}

/// Acesso a features
@MappableClass()
class FeatureAccess with FeatureAccessMappable {
  final String featureKey;
  final String featureName;
  final bool isEnabled;
  final int? limit; // null = ilimitado
  final String? description;

  const FeatureAccess({
    required this.featureKey,
    required this.featureName,
    this.isEnabled = true,
    this.limit,
    this.description,
  });

  /// Verificar se é ilimitado
  bool get isUnlimited => limit == null;
}

/// Features disponíveis
enum PremiumFeature {
  // Matches e Descoberta
  unlimitedLikes, // Likes ilimitados
  rewind, // Desfazer swipe
  seeWhoLikedYou, // Ver quem deu like
  advancedFilters, // Filtros avançados
  topPicks, // Top Picks diários
  // Visibilidade
  profileBoost, // Boost de perfil
  superLike, // Super Likes
  priorityLikes, // Likes com prioridade
  readReceipts, // Confirmação de leitura
  // Comunicação
  videoCall, // Chamadas de vídeo
  voiceCall, // Chamadas de voz
  vanishMode, // Modo de mensagens efêmeras
  aiChatEnhancement, // IA melhorada no chat
  // Privacidade
  incognitoMode, // Modo incógnito
  hideAge, // Ocultar idade
  hideDistance, // Ocultar distância
  controlWhoSeesYou, // Controlar quem vê você
  // Perfil
  morePhotos, // Mais fotos (15 vs 6)
  verifiedBadge, // Badge verificado
  customBadge, // Badge customizado
  videoProfile, // Perfil em vídeo
  // Data Ideas
  unlimitedDateIdeas, // Ideias ilimitadas
  aiDatePlanning, // Planejamento com IA
  exclusiveLocations, // Localizações exclusivas
  // Analytics
  profileAnalytics, // Analytics do perfil
  whoViewedYou, // Quem visualizou você
  // Suporte
  prioritySupport, // Suporte prioritário
}

/// Uso de features com limite
@MappableClass()
class FeatureUsage with FeatureUsageMappable {
  final String usageId;
  final String userId;
  final PremiumFeature feature;
  final int usedCount;
  final int? limit;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime lastUsedAt;

  const FeatureUsage({
    required this.usageId,
    required this.userId,
    required this.feature,
    this.usedCount = 0,
    this.limit,
    required this.periodStart,
    required this.periodEnd,
    required this.lastUsedAt,
  });

  /// Verificar se ainda tem uso disponível
  bool get hasUsageAvailable {
    if (limit == null) return true; // Ilimitado
    return usedCount < limit!;
  }

  /// Usos restantes
  int get remainingUsage {
    if (limit == null) return 999;
    return (limit! - usedCount).clamp(0, limit!);
  }

  /// Progresso (0-1)
  double get progress {
    if (limit == null) return 0;
    return (usedCount / limit!).clamp(0, 1);
  }
}

/// Plano de assinatura (pricing)
@MappableClass()
class SubscriptionPlan with SubscriptionPlanMappable {
  final String planId;
  final SubscriptionTier tier;
  final BillingPeriod billingPeriod;
  final double price;
  final String currency;
  final String? productId; // Store product ID
  final bool isActive;
  final DateTime createdAt;

  const SubscriptionPlan({
    required this.planId,
    required this.tier,
    required this.billingPeriod,
    required this.price,
    this.currency = 'BRL',
    this.productId,
    this.isActive = true,
    required this.createdAt,
  });

  /// Preço mensal equivalente
  double get monthlyEquivalentPrice {
    switch (billingPeriod) {
      case BillingPeriod.monthly:
        return price;
      case BillingPeriod.quarterly:
        return price / 3;
      case BillingPeriod.yearly:
        return price / 12;
      case BillingPeriod.lifetime:
        return price / 120; // 10 anos
    }
  }
}

/// Período de cobrança
enum BillingPeriod {
  monthly, // Mensal
  quarterly, // Trimestral
  yearly, // Anual
  lifetime, // Vitalício
}

/// Histórico de assinatura
@MappableClass()
class SubscriptionHistory with SubscriptionHistoryMappable {
  final String historyId;
  final String userId;
  final SubscriptionEvent event;
  final SubscriptionTier? fromTier;
  final SubscriptionTier? toTier;
  final String? notes;
  final DateTime createdAt;

  const SubscriptionHistory({
    required this.historyId,
    required this.userId,
    required this.event,
    this.fromTier,
    this.toTier,
    this.notes,
    required this.createdAt,
  });
}

/// Eventos de assinatura
enum SubscriptionEvent {
  created, // Criada
  upgraded, // Upgrade
  downgraded, // Downgrade
  renewed, // Renovada
  cancelled, // Cancelada
  expired, // Expirada
  reactivated, // Reativada
  refunded, // Reembolsada
  trialStarted, // Trial iniciado
  trialEnded, // Trial terminado
  paymentFailed, // Pagamento falhou
}

/// Oferta especial
@MappableClass()
class SubscriptionOffer with SubscriptionOfferMappable {
  final String offerId;
  final String title;
  final String description;
  final SubscriptionTier tier;
  final double discountPercent;
  final double? discountAmount;
  final DateTime validFrom;
  final DateTime validUntil;
  final List<String> eligibleUserIds; // Se vazio, válido para todos
  final int? maxRedemptions;
  final int currentRedemptions;
  final bool isActive;

  const SubscriptionOffer({
    required this.offerId,
    required this.title,
    required this.description,
    required this.tier,
    this.discountPercent = 0,
    this.discountAmount,
    required this.validFrom,
    required this.validUntil,
    this.eligibleUserIds = const [],
    this.maxRedemptions,
    this.currentRedemptions = 0,
    this.isActive = true,
  });

  /// Verificar se está válida
  bool get isValid {
    if (!isActive) return false;
    final now = DateTime.now();
    if (now.isBefore(validFrom) || now.isAfter(validUntil)) return false;
    if (maxRedemptions != null && currentRedemptions >= maxRedemptions!) return false;
    return true;
  }

  /// Verificar se usuário é elegível
  bool isEligibleUser(String userId) {
    if (eligibleUserIds.isEmpty) return true;
    return eligibleUserIds.contains(userId);
  }

  /// Calcular preço com desconto
  double calculateDiscountedPrice(double originalPrice) {
    if (discountAmount != null) {
      return (originalPrice - discountAmount!).clamp(0, originalPrice);
    }
    return originalPrice * (1 - discountPercent / 100);
  }
}

/// Comparação de tiers
@MappableClass()
class TierComparison with TierComparisonMappable {
  final SubscriptionTier tier;
  final Map<String, bool> features; // feature -> enabled
  final List<String> pros;
  final List<String> cons;

  const TierComparison({required this.tier, required this.features, required this.pros, required this.cons});
}

/// Estatísticas de assinatura
@MappableClass()
class SubscriptionStats with SubscriptionStatsMappable {
  final int totalSubscribers;
  final int activeSubscribers;
  final int trialUsers;
  final Map<SubscriptionTier, int> tierDistribution;
  final double averageLifetime; // dias
  final double churnRate; // taxa de cancelamento
  final double mrr; // Monthly Recurring Revenue
  final double arr; // Annual Recurring Revenue
  final DateTime generatedAt;

  const SubscriptionStats({
    required this.totalSubscribers,
    required this.activeSubscribers,
    required this.trialUsers,
    required this.tierDistribution,
    required this.averageLifetime,
    required this.churnRate,
    required this.mrr,
    required this.arr,
    required this.generatedAt,
  });
}

/// Request para upgrade/downgrade
@MappableClass()
class ChangeTierRequest with ChangeTierRequestMappable {
  final String userId;
  final SubscriptionTier targetTier;
  final BillingPeriod billingPeriod;
  final String? offerCode;

  const ChangeTierRequest({
    required this.userId,
    required this.targetTier,
    required this.billingPeriod,
    this.offerCode,
  });
}
