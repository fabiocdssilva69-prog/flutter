import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/in_app_purchase.dart';
import '../../../data/repositories/purchase_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'purchase_controller.g.dart';

/// Controller para In-App Purchases
@riverpod
class PurchaseController extends _$PurchaseController {
  @override
  FutureOr<bool> build() async {
    // Inicializar produtos padrão se necessário
    await _ensureDefaultProducts();
    return true;
  }

  // ============================================
  // PRODUCTS
  // ============================================

  /// Obter todos os produtos
  Future<List<PurchaseableProduct>> getAvailableProducts() async {
    final repo = ref.read(purchaseRepositoryProvider);
    return repo.getAvailableProducts();
  }

  /// Obter produtos por tipo
  Future<List<PurchaseableProduct>> getProductsByType(ProductType type) async {
    final repo = ref.read(purchaseRepositoryProvider);
    return repo.getProductsByType(type);
  }

  /// Obter produto por ID
  Future<PurchaseableProduct?> getProduct(String productId) async {
    final repo = ref.read(purchaseRepositoryProvider);
    return repo.getProduct(productId);
  }

  // ============================================
  // PURCHASE FLOW
  // ============================================

  /// Processar compra
  Future<InAppPurchase> processPurchase({
    required String productId,
    required PaymentMethod paymentMethod,
    int quantity = 1,
    String? promotionCode,
  }) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final repo = ref.read(purchaseRepositoryProvider);

      // Obter produto
      final product = await repo.getProduct(productId);
      if (product == null) {
        throw Exception('Produto não encontrado');
      }

      // Verificar promoção
      double finalPrice = product.price * quantity;
      if (promotionCode != null) {
        final promotion = await repo.getPromotionForProduct(productId);
        if (promotion != null && promotion.isValid) {
          finalPrice = promotion.calculateDiscountedPrice(finalPrice);
        }
      }

      // Criar transação
      final transaction = PaymentTransaction(
        transactionId: '',
        userId: currentUser.userId,
        method: paymentMethod,
        amount: finalPrice,
        status: PaymentStatus.pending,
        purchaseIds: [],
        createdAt: DateTime.now(),
      );

      final transactionId = await repo.createTransaction(transaction);

      // Criar compra
      final purchase = InAppPurchase(
        purchaseId: '',
        userId: currentUser.userId,
        product: product,
        status: PurchaseStatus.pending,
        amount: finalPrice,
        paymentProvider: _getPaymentProvider(paymentMethod),
        transactionId: transactionId,
        purchaseDate: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final purchaseId = await repo.createPurchase(purchase);

      // Simular processamento (em produção, integrar com payment gateway)
      await _processPayment(transactionId, purchaseId, product, quantity);

      state = const AsyncData(null);

      // Invalidar cache
      ref.invalidate(userInventoryProvider);

      return purchase;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Consumir item comprado
  Future<void> consumeItem({required RewardType rewardType, required int quantity}) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return;

    final repo = ref.read(purchaseRepositoryProvider);
    final success = await repo.consumeFromInventory(
      userId: currentUser.userId,
      rewardType: rewardType,
      quantity: quantity,
    );

    if (!success) {
      throw Exception('Saldo insuficiente');
    }

    ref.invalidate(userInventoryProvider);
  }

  // ============================================
  // INVENTORY
  // ============================================

  /// Obter inventário do usuário
  Future<UserInventory?> getInventory() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return null;

    final repo = ref.read(purchaseRepositoryProvider);
    return repo.getUserInventory(currentUser.userId);
  }

  /// Obter saldo de um tipo específico
  Future<int> getBalance(RewardType type) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return 0;

    final repo = ref.read(purchaseRepositoryProvider);
    return repo.getBalance(currentUser.userId, type);
  }

  /// Verificar se tem saldo suficiente
  Future<bool> hasEnoughBalance(RewardType type, int quantity) async {
    final balance = await getBalance(type);
    return balance >= quantity;
  }

  // ============================================
  // PURCHASE HISTORY
  // ============================================

  /// Obter histórico de compras
  Future<PurchaseHistory> getPurchaseHistory() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado');
    }

    final repo = ref.read(purchaseRepositoryProvider);
    return repo.getPurchaseHistory(currentUser.userId);
  }

  /// Obter compras do usuário
  Future<List<InAppPurchase>> getMyPurchases() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(purchaseRepositoryProvider);
    return repo.getUserPurchases(currentUser.userId);
  }

  // ============================================
  // PROMOTIONS
  // ============================================

  /// Obter promoções ativas
  Future<List<ProductPromotion>> getActivePromotions() async {
    final repo = ref.read(purchaseRepositoryProvider);
    return repo.getActivePromotions();
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Obter estatísticas de compras
  Future<PurchaseStats> getStats() async {
    final repo = ref.read(purchaseRepositoryProvider);
    return repo.getStats();
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  Future<void> _ensureDefaultProducts() async {
    final repo = ref.read(purchaseRepositoryProvider);
    final existing = await repo.getAvailableProducts();

    if (existing.isEmpty) {
      await _createDefaultProducts();
    }
  }

  Future<void> _createDefaultProducts() async {
    final repo = ref.read(purchaseRepositoryProvider);

    final defaultProducts = [
      // SUPER LIKES
      PurchaseableProduct(
        productId: '',
        name: '5 Super Likes',
        description: 'Destaque-se com Super Likes',
        type: ProductType.consumable,
        price: 9.99,
        sku: 'super_likes_5',
        reward: const ProductReward(type: RewardType.superLikes, quantity: 5),
        createdAt: DateTime.now(),
      ),
      PurchaseableProduct(
        productId: '',
        name: '25 Super Likes',
        description: 'Pacote de Super Likes',
        type: ProductType.consumable,
        price: 39.99,
        sku: 'super_likes_25',
        reward: const ProductReward(type: RewardType.superLikes, quantity: 25),
        createdAt: DateTime.now(),
      ),

      // BOOSTS
      PurchaseableProduct(
        productId: '',
        name: '1 Profile Boost',
        description: 'Boost de 30 minutos no seu perfil',
        type: ProductType.consumable,
        price: 14.99,
        sku: 'boost_1',
        reward: const ProductReward(type: RewardType.boosts, quantity: 1, duration: Duration(minutes: 30)),
        createdAt: DateTime.now(),
      ),
      PurchaseableProduct(
        productId: '',
        name: '5 Profile Boosts',
        description: 'Pacote de Boosts',
        type: ProductType.consumable,
        price: 59.99,
        sku: 'boost_5',
        reward: const ProductReward(type: RewardType.boosts, quantity: 5, duration: Duration(minutes: 30)),
        createdAt: DateTime.now(),
      ),

      // REWINDS
      PurchaseableProduct(
        productId: '',
        name: '10 Rewinds',
        description: 'Desfaça swipes acidentais',
        type: ProductType.consumable,
        price: 7.99,
        sku: 'rewind_10',
        reward: const ProductReward(type: RewardType.rewinds, quantity: 10),
        createdAt: DateTime.now(),
      ),

      // COINS (moeda virtual)
      PurchaseableProduct(
        productId: '',
        name: '100 Coins',
        description: 'Moedas para usar no app',
        type: ProductType.consumable,
        price: 4.99,
        sku: 'coins_100',
        reward: const ProductReward(type: RewardType.coins, quantity: 100),
        createdAt: DateTime.now(),
      ),
      PurchaseableProduct(
        productId: '',
        name: '500 Coins',
        description: 'Pacote de moedas',
        type: ProductType.consumable,
        price: 19.99,
        sku: 'coins_500',
        reward: const ProductReward(type: RewardType.coins, quantity: 500),
        createdAt: DateTime.now(),
      ),

      // SPOTLIGHT
      PurchaseableProduct(
        productId: '',
        name: 'Spotlight 24h',
        description: 'Destaque seu perfil por 24 horas',
        type: ProductType.consumable,
        price: 29.99,
        sku: 'spotlight_24h',
        reward: const ProductReward(type: RewardType.spotlights, quantity: 1, duration: Duration(hours: 24)),
        createdAt: DateTime.now(),
      ),
    ];

    for (final product in defaultProducts) {
      await repo.createProduct(product);
    }
  }

  Future<void> _processPayment(
    String transactionId,
    String purchaseId,
    PurchaseableProduct product,
    int quantity,
  ) async {
    final repo = ref.read(purchaseRepositoryProvider);
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return;

    try {
      // Simular processamento (em produção, integrar com Stripe/RevenueCat/etc)
      await Future.delayed(const Duration(seconds: 1));

      // Marcar transação como completa
      await repo.updateTransactionStatus(transactionId, PaymentStatus.completed);

      // Marcar compra como completa
      await repo.updatePurchaseStatus(purchaseId, PurchaseStatus.completed);

      // Adicionar recompensa ao inventário
      await repo.addToInventory(
        userId: currentUser.userId,
        rewardType: product.reward.type,
        quantity: product.reward.quantity * quantity,
        expiresAt: product.reward.duration != null ? DateTime.now().add(product.reward.duration!) : null,
      );

      // Se for consumível, marcar como consumido após adicionar ao inventário
      if (product.type == ProductType.consumable) {
        await repo.consumePurchase(purchaseId);
      }
    } catch (e) {
      // Marcar como falhou
      await repo.updateTransactionStatus(transactionId, PaymentStatus.failed, errorMessage: e.toString());
      await repo.updatePurchaseStatus(purchaseId, PurchaseStatus.failed);
      rethrow;
    }
  }

  String _getPaymentProvider(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.googlePay:
        return 'google_pay';
      case PaymentMethod.applePay:
        return 'apple_pay';
      case PaymentMethod.pix:
      case PaymentMethod.creditCard:
      case PaymentMethod.debitCard:
        return 'stripe';
      case PaymentMethod.paypal:
        return 'paypal';
      case PaymentMethod.storeCredit:
        return 'store_credit';
    }
  }
}

/// Provider para produtos disponíveis
@riverpod
Future<List<PurchaseableProduct>> availableProducts(AvailableProductsRef ref) async {
  final controller = ref.watch(purchaseControllerProvider.notifier);
  return controller.getAvailableProducts();
}

/// Provider para inventário do usuário
@riverpod
Future<UserInventory?> userInventory(UserInventoryRef ref) async {
  final controller = ref.watch(purchaseControllerProvider.notifier);
  return controller.getInventory();
}

/// Provider para saldo específico
@riverpod
Future<int> rewardBalance(RewardBalanceRef ref, RewardType type) async {
  final controller = ref.watch(purchaseControllerProvider.notifier);
  return controller.getBalance(type);
}

/// Provider para histórico de compras
@riverpod
Future<PurchaseHistory> purchaseHistory(PurchaseHistoryRef ref) async {
  final controller = ref.watch(purchaseControllerProvider.notifier);
  return controller.getPurchaseHistory();
}
