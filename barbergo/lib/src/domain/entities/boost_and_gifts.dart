import 'package:dart_mappable/dart_mappable.dart';

part 'boost.g.dart';

/// Entity para Paid Boosts (Phase 4 - Feature 3/6)
/// Sistema de boosts pagos para visibilidade
@MappableClass()
class ProfileBoost with ProfileBoostMappable {
  final String boostId;
  final String userId;
  final BoostType type;
  final BoostStatus status;
  final DateTime startTime;
  final DateTime endTime;
  final int impressions; // Quantas pessoas viram
  final int profileViews; // Quantas clicaram no perfil
  final int likesReceived; // Likes recebidos durante boost
  final int matchesReceived; // Matches durante boost
  final double ctr; // Click-through rate
  final DateTime createdAt;

  const ProfileBoost({
    required this.boostId,
    required this.userId,
    required this.type,
    required this.status,
    required this.startTime,
    required this.endTime,
    this.impressions = 0,
    this.profileViews = 0,
    this.likesReceived = 0,
    this.matchesReceived = 0,
    this.ctr = 0,
    required this.createdAt,
  });

  /// Verificar se está ativo
  bool get isActive {
    if (status != BoostStatus.active) return false;
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Duração
  Duration get duration => endTime.difference(startTime);

  /// Tempo restante
  Duration get timeRemaining {
    if (!isActive) return Duration.zero;
    return endTime.difference(DateTime.now());
  }

  /// Taxa de conversão (profile views -> likes)
  double get conversionRate {
    if (profileViews == 0) return 0;
    return (likesReceived / profileViews) * 100;
  }
}

/// Tipos de boost
enum BoostType {
  standard, // Boost padrão (30 min)
  superBoost, // Super boost (1 hora)
  megaBoost, // Mega boost (3 horas)
  prime, // Prime time boost (horário nobre)
  weekend, // Boost de fim de semana
  targeted, // Boost direcionado
}

/// Status do boost
enum BoostStatus {
  scheduled, // Agendado
  active, // Ativo
  completed, // Completo
  cancelled, // Cancelado
  expired, // Expirado
}

/// Configuração de boost
@MappableClass()
class BoostConfig with BoostConfigMappable {
  final BoostType type;
  final String name;
  final String description;
  final Duration duration;
  final int multiplier; // Multiplicador de visibilidade
  final double price;
  final List<String> benefits;
  final bool isPrimeTime;
  final String? targetAudience;

  const BoostConfig({
    required this.type,
    required this.name,
    required this.description,
    required this.duration,
    required this.multiplier,
    required this.price,
    required this.benefits,
    this.isPrimeTime = false,
    this.targetAudience,
  });
}

/// Estatísticas de boost
@MappableClass()
class BoostStats with BoostStatsMappable {
  final String userId;
  final int totalBoostsUsed;
  final Duration totalBoostTime;
  final int totalImpressions;
  final int totalProfileViews;
  final int totalLikesReceived;
  final int totalMatchesReceived;
  final double averageCTR;
  final double averageConversionRate;
  final DateTime? lastBoostDate;
  final BoostType? mostEffectiveBoost;

  const BoostStats({
    required this.userId,
    required this.totalBoostsUsed,
    required this.totalBoostTime,
    required this.totalImpressions,
    required this.totalProfileViews,
    required this.totalLikesReceived,
    required this.totalMatchesReceived,
    required this.averageCTR,
    required this.averageConversionRate,
    this.lastBoostDate,
    this.mostEffectiveBoost,
  });

  /// ROI médio (matches por boost)
  double get averageMatchesPerBoost {
    if (totalBoostsUsed == 0) return 0;
    return totalMatchesReceived / totalBoostsUsed;
  }
}

/// Virtual Gift Entity
@MappableClass()
class VirtualGift with VirtualGiftMappable {
  final String giftId;
  final String name;
  final String description;
  final GiftCategory category;
  final int coinPrice; // Preço em moedas virtuais
  final String? imageUrl;
  final String? animationUrl;
  final GiftRarity rarity;
  final bool isAvailable;
  final DateTime createdAt;

  const VirtualGift({
    required this.giftId,
    required this.name,
    required this.description,
    required this.category,
    required this.coinPrice,
    this.imageUrl,
    this.animationUrl,
    this.rarity = GiftRarity.common,
    this.isAvailable = true,
    required this.createdAt,
  });
}

/// Categorias de presente
enum GiftCategory {
  romantic, // Romântico
  funny, // Engraçado
  cute, // Fofo
  luxury, // Luxo
  seasonal, // Sazonal
  special, // Especial
}

/// Raridade do presente
enum GiftRarity {
  common, // Comum
  uncommon, // Incomum
  rare, // Raro
  epic, // Épico
  legendary, // Lendário
}

/// Presente enviado
@MappableClass()
class GiftTransaction with GiftTransactionMappable {
  final String transactionId;
  final String senderId;
  final String recipientId;
  final VirtualGift gift;
  final String? message;
  final bool isAnonymous;
  final DateTime sentAt;
  final DateTime? viewedAt;
  final bool wasViewed;

  const GiftTransaction({
    required this.transactionId,
    required this.senderId,
    required this.recipientId,
    required this.gift,
    this.message,
    this.isAnonymous = false,
    required this.sentAt,
    this.viewedAt,
    this.wasViewed = false,
  });
}

/// Estatísticas de presentes
@MappableClass()
class GiftStats with GiftStatsMappable {
  final String userId;
  final int giftsSent;
  final int giftsReceived;
  final int coinsSpent;
  final Map<GiftCategory, int> sentByCategory;
  final Map<GiftCategory, int> receivedByCategory;
  final List<VirtualGift> mostSentGifts;
  final List<VirtualGift> mostReceivedGifts;

  const GiftStats({
    required this.userId,
    required this.giftsSent,
    required this.giftsReceived,
    required this.coinsSpent,
    required this.sentByCategory,
    required this.receivedByCategory,
    required this.mostSentGifts,
    required this.mostReceivedGifts,
  });
}

/// Analytics Dashboard Entity
@MappableClass()
class ProfileAnalytics with ProfileAnalyticsMappable {
  final String userId;
  final DateTime periodStart;
  final DateTime periodEnd;

  // Visibilidade
  final int profileViews;
  final int profileViewsGrowth; // vs período anterior
  final List<ViewerDemographic> viewerDemographics;

  // Engagement
  final int likesReceived;
  final int likesSent;
  final int superLikesReceived;
  final int matchesCreated;
  final double matchRate; // likes sent -> matches

  // Mensagens
  final int messagesReceived;
  final int messagesSent;
  final double responseRate;
  final Duration averageResponseTime;

  // Popularidade
  final int popularityScore; // 0-100
  final ProfileRanking ranking;

  // Comparação
  final int percentileTier; // Top X%

  final DateTime generatedAt;

  const ProfileAnalytics({
    required this.userId,
    required this.periodStart,
    required this.periodEnd,
    required this.profileViews,
    this.profileViewsGrowth = 0,
    required this.viewerDemographics,
    required this.likesReceived,
    required this.likesSent,
    required this.superLikesReceived,
    required this.matchesCreated,
    required this.matchRate,
    required this.messagesReceived,
    required this.messagesSent,
    required this.responseRate,
    required this.averageResponseTime,
    required this.popularityScore,
    required this.ranking,
    required this.percentileTier,
    required this.generatedAt,
  });
}

/// Demografia de quem visualizou
@MappableClass()
class ViewerDemographic with ViewerDemographicMappable {
  final String ageRange; // "18-25", "26-35", etc
  final int count;
  final double percentage;

  const ViewerDemographic({required this.ageRange, required this.count, required this.percentage});
}

/// Ranking do perfil
enum ProfileRanking {
  novice, // Novato
  rising, // Em ascensão
  popular, // Popular
  trending, // Trending
  superstar, // Superstar
}

/// Revenue Tracking Entity
@MappableClass()
class RevenueRecord with RevenueRecordMappable {
  final String recordId;
  final String userId;
  final RevenueSource source;
  final double amount;
  final String currency;
  final String? transactionId;
  final DateTime recordedAt;

  const RevenueRecord({
    required this.recordId,
    required this.userId,
    required this.source,
    required this.amount,
    this.currency = 'BRL',
    this.transactionId,
    required this.recordedAt,
  });
}

/// Fonte de receita
enum RevenueSource {
  subscription, // Assinatura
  inAppPurchase, // Compra in-app
  boost, // Boost
  gift, // Presente
  other, // Outro
}

/// Relatório de receita
@MappableClass()
class RevenueReport with RevenueReportMappable {
  final DateTime periodStart;
  final DateTime periodEnd;

  // Receitas totais
  final double totalRevenue;
  final double subscriptionRevenue;
  final double purchaseRevenue;
  final double boostRevenue;
  final double giftRevenue;

  // Métricas
  final int totalTransactions;
  final double averageTransactionValue;
  final int uniquePayers;

  // Crescimento
  final double revenueGrowth; // % vs período anterior

  // Distribuição
  final Map<RevenueSource, double> revenueBySource;
  final Map<String, double> revenueByRegion;

  // Previsões
  final double projectedMRR; // Monthly Recurring Revenue
  final double projectedARR; // Annual Recurring Revenue

  final DateTime generatedAt;

  const RevenueReport({
    required this.periodStart,
    required this.periodEnd,
    required this.totalRevenue,
    required this.subscriptionRevenue,
    required this.purchaseRevenue,
    required this.boostRevenue,
    required this.giftRevenue,
    required this.totalTransactions,
    required this.averageTransactionValue,
    required this.uniquePayers,
    this.revenueGrowth = 0,
    required this.revenueBySource,
    required this.revenueByRegion,
    required this.projectedMRR,
    required this.projectedARR,
    required this.generatedAt,
  });
}

/// Request para ativar boost
@MappableClass()
class ActivateBoostRequest with ActivateBoostRequestMappable {
  final String userId;
  final BoostType type;
  final DateTime? scheduledTime; // null = imediato

  const ActivateBoostRequest({required this.userId, required this.type, this.scheduledTime});
}
