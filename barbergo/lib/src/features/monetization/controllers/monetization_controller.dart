import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/boost_and_gifts.dart';
import '../../../../domain/entities/in_app_purchase.dart';
import '../../../data/repositories/monetization_repository.dart';
import '../../../data/repositories/purchase_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'monetization_controller.g.dart';

/// Controller para Boosts, Gifts, Analytics e Revenue
@riverpod
class MonetizationController extends _$MonetizationController {
  @override
  FutureOr<bool> build() async {
    await _ensureDefaultGifts();
    return true;
  }

  // ============================================
  // BOOSTS
  // ============================================

  /// Ativar boost
  Future<ProfileBoost> activateBoost({required BoostType type, DateTime? scheduledTime}) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      // Verificar se já tem boost ativo
      final repo = ref.read(monetizationRepositoryProvider);
      final activeBoost = await repo.getActiveBoost(currentUser.userId);

      if (activeBoost != null) {
        throw Exception('Você já tem um boost ativo');
      }

      // Obter configuração do boost
      final config = _boostConfigs[type]!;

      // Consumir do inventário
      final purchaseRepo = ref.read(purchaseRepositoryProvider);
      final hasBoosts = await purchaseRepo.getBalance(currentUser.userId, RewardType.boosts);

      if (hasBoosts < 1) {
        throw Exception('Você não tem boosts disponíveis');
      }

      await purchaseRepo.consumeFromInventory(userId: currentUser.userId, rewardType: RewardType.boosts, quantity: 1);

      // Criar boost
      final now = scheduledTime ?? DateTime.now();
      final boost = ProfileBoost(
        boostId: '',
        userId: currentUser.userId,
        type: type,
        status: scheduledTime == null ? BoostStatus.active : BoostStatus.scheduled,
        startTime: now,
        endTime: now.add(config.duration),
        createdAt: DateTime.now(),
      );

      await repo.createBoost(boost);

      // Registrar receita
      await _recordRevenue(userId: currentUser.userId, amount: config.price, source: RevenueSource.boost);

      state = const AsyncData(null);
      ref.invalidate(activeBoostProvider);

      return boost;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Obter boost ativo
  Future<ProfileBoost?> getActiveBoost() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return null;

    final repo = ref.read(monetizationRepositoryProvider);
    return repo.getActiveBoost(currentUser.userId);
  }

  /// Obter estatísticas de boosts
  Future<BoostStats> getBoostStats() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado');
    }

    final repo = ref.read(monetizationRepositoryProvider);
    return repo.getBoostStats(currentUser.userId);
  }

  /// Incrementar estatísticas do boost
  Future<void> incrementBoostStats({
    required String boostId,
    bool impression = false,
    bool profileView = false,
    bool likeReceived = false,
    bool matchReceived = false,
  }) async {
    final repo = ref.read(monetizationRepositoryProvider);
    await repo.updateBoostStats(
      boostId: boostId,
      impressions: impression ? 1 : null,
      profileViews: profileView ? 1 : null,
      likesReceived: likeReceived ? 1 : null,
      matchesReceived: matchReceived ? 1 : null,
    );
  }

  // ============================================
  // GIFTS
  // ============================================

  /// Obter presentes disponíveis
  Future<List<VirtualGift>> getAvailableGifts() async {
    final repo = ref.read(monetizationRepositoryProvider);
    return repo.getAvailableGifts();
  }

  /// Enviar presente
  Future<void> sendGift({
    required String recipientId,
    required String giftId,
    String? message,
    bool isAnonymous = false,
  }) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final repo = ref.read(monetizationRepositoryProvider);
      final gifts = await repo.getAvailableGifts();
      final gift = gifts.firstWhere((g) => g.giftId == giftId);

      // Verificar saldo de moedas
      final purchaseRepo = ref.read(purchaseRepositoryProvider);
      final coinBalance = await purchaseRepo.getBalance(currentUser.userId, RewardType.coins);

      if (coinBalance < gift.coinPrice) {
        throw Exception('Moedas insuficientes');
      }

      // Consumir moedas
      await purchaseRepo.consumeFromInventory(
        userId: currentUser.userId,
        rewardType: RewardType.coins,
        quantity: gift.coinPrice,
      );

      // Enviar presente
      final transaction = GiftTransaction(
        transactionId: '',
        senderId: currentUser.userId,
        recipientId: recipientId,
        gift: gift,
        message: message,
        isAnonymous: isAnonymous,
        sentAt: DateTime.now(),
      );

      await repo.sendGift(transaction);

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Obter presentes recebidos
  Future<List<GiftTransaction>> getReceivedGifts() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(monetizationRepositoryProvider);
    return repo.getReceivedGifts(currentUser.userId);
  }

  /// Marcar presente como visto
  Future<void> markGiftAsViewed(String transactionId) async {
    final repo = ref.read(monetizationRepositoryProvider);
    await repo.markGiftAsViewed(transactionId);
  }

  /// Obter estatísticas de presentes
  Future<GiftStats> getGiftStats() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado');
    }

    final repo = ref.read(monetizationRepositoryProvider);
    return repo.getGiftStats(currentUser.userId);
  }

  // ============================================
  // ANALYTICS
  // ============================================

  /// Gerar analytics do perfil
  Future<ProfileAnalytics> generateAnalytics({DateTime? periodStart, DateTime? periodEnd}) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado');
    }

    final end = periodEnd ?? DateTime.now();
    final start = periodStart ?? end.subtract(const Duration(days: 30));

    // Mock analytics (em produção, agregar dados reais)
    final analytics = ProfileAnalytics(
      userId: currentUser.userId,
      periodStart: start,
      periodEnd: end,
      profileViews: 245,
      profileViewsGrowth: 15,
      viewerDemographics: [
        const ViewerDemographic(ageRange: '18-25', count: 98, percentage: 40),
        const ViewerDemographic(ageRange: '26-35', count: 123, percentage: 50),
        const ViewerDemographic(ageRange: '36-45', count: 24, percentage: 10),
      ],
      likesReceived: 42,
      likesSent: 38,
      superLikesReceived: 5,
      matchesCreated: 8,
      matchRate: 21.0,
      messagesReceived: 64,
      messagesSent: 58,
      responseRate: 85.0,
      averageResponseTime: const Duration(hours: 2, minutes: 15),
      popularityScore: 78,
      ranking: ProfileRanking.popular,
      percentileTier: 25,
      generatedAt: DateTime.now(),
    );

    final repo = ref.read(monetizationRepositoryProvider);
    await repo.saveAnalytics(analytics);

    return analytics;
  }

  /// Obter analytics do usuário
  Future<ProfileAnalytics?> getAnalytics() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return null;

    final repo = ref.read(monetizationRepositoryProvider);
    return repo.getUserAnalytics(currentUser.userId);
  }

  // ============================================
  // REVENUE
  // ============================================

  /// Gerar relatório de receita
  Future<RevenueReport> generateRevenueReport({DateTime? periodStart, DateTime? periodEnd}) async {
    final end = periodEnd ?? DateTime.now();
    final start = periodStart ?? end.subtract(const Duration(days: 30));

    final repo = ref.read(monetizationRepositoryProvider);
    return repo.generateRevenueReport(periodStart: start, periodEnd: end);
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  Future<void> _ensureDefaultGifts() async {
    final repo = ref.read(monetizationRepositoryProvider);
    final existing = await repo.getAvailableGifts();

    if (existing.isEmpty) {
      // Em produção, criar presentes padrão
    }
  }

  Future<void> _recordRevenue({
    required String userId,
    required double amount,
    required RevenueSource source,
    String? transactionId,
  }) async {
    final record = RevenueRecord(
      recordId: '',
      userId: userId,
      source: source,
      amount: amount,
      transactionId: transactionId,
      recordedAt: DateTime.now(),
    );

    final repo = ref.read(monetizationRepositoryProvider);
    await repo.recordRevenue(record);
  }

  // ============================================
  // BOOST CONFIGS
  // ============================================

  static final Map<BoostType, BoostConfig> _boostConfigs = {
    BoostType.standard: const BoostConfig(
      type: BoostType.standard,
      name: 'Boost Padrão',
      description: '30 minutos de visibilidade aumentada',
      duration: Duration(minutes: 30),
      multiplier: 10,
      price: 14.99,
      benefits: ['Apareça em mais perfis', 'Multiplique sua visibilidade por 10x', '30 minutos de destaque'],
    ),
    BoostType.superBoost: const BoostConfig(
      type: BoostType.superBoost,
      name: 'Super Boost',
      description: '1 hora de máxima visibilidade',
      duration: Duration(hours: 1),
      multiplier: 15,
      price: 24.99,
      benefits: ['Visibilidade máxima por 1 hora', 'Multiplique por 15x', 'Prioridade absoluta'],
    ),
    BoostType.megaBoost: const BoostConfig(
      type: BoostType.megaBoost,
      name: 'Mega Boost',
      description: '3 horas de destaque premium',
      duration: Duration(hours: 3),
      multiplier: 20,
      price: 49.99,
      benefits: ['3 horas de destaque', 'Multiplique por 20x', 'Máxima exposição'],
    ),
    BoostType.prime: const BoostConfig(
      type: BoostType.prime,
      name: 'Prime Time Boost',
      description: 'Boost durante horário nobre',
      duration: Duration(hours: 1),
      multiplier: 18,
      price: 29.99,
      benefits: ['Horário de pico (19h-22h)', 'Multiplique por 18x', 'Quando mais pessoas estão online'],
      isPrimeTime: true,
    ),
    BoostType.weekend: const BoostConfig(
      type: BoostType.weekend,
      name: 'Weekend Boost',
      description: 'Boost especial de fim de semana',
      duration: Duration(hours: 2),
      multiplier: 16,
      price: 34.99,
      benefits: ['2 horas no fim de semana', 'Multiplique por 16x', 'Momento ideal para matches'],
    ),
    BoostType.targeted: const BoostConfig(
      type: BoostType.targeted,
      name: 'Boost Direcionado',
      description: 'Boost focado no seu público-alvo',
      duration: Duration(minutes: 45),
      multiplier: 12,
      price: 19.99,
      benefits: ['45 minutos direcionados', 'Multiplique por 12x', 'Foco no público compatível'],
      targetAudience: 'Baseado em suas preferências',
    ),
  };
}

/// Provider para boost ativo
@riverpod
Future<ProfileBoost?> activeBoost(ActiveBoostRef ref) async {
  final controller = ref.watch(monetizationControllerProvider.notifier);
  return controller.getActiveBoost();
}

/// Provider para presentes disponíveis
@riverpod
Future<List<VirtualGift>> availableGifts(AvailableGiftsRef ref) async {
  final controller = ref.watch(monetizationControllerProvider.notifier);
  return controller.getAvailableGifts();
}

/// Provider para analytics do usuário
@riverpod
Future<ProfileAnalytics?> userAnalytics(UserAnalyticsRef ref) async {
  final controller = ref.watch(monetizationControllerProvider.notifier);
  return controller.getAnalytics();
}

/// Provider para configurações de boost
@riverpod
BoostConfig boostConfig(BoostConfigRef ref, BoostType type) {
  return MonetizationController._boostConfigs[type]!;
}
