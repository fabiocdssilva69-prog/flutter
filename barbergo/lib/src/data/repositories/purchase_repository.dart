import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/in_app_purchase.dart';

part 'purchase_repository.g.dart';

/// Repository para In-App Purchases
@riverpod
PurchaseRepository purchaseRepository(PurchaseRepositoryRef ref) {
  return PurchaseRepository(FirebaseFirestore.instance);
}

class PurchaseRepository {
  final FirebaseFirestore _firestore;

  PurchaseRepository(this._firestore);

  CollectionReference get _purchasesCollection => _firestore.collection('purchases');
  CollectionReference get _productsCollection => _firestore.collection('products');
  CollectionReference get _inventoryCollection => _firestore.collection('user_inventory');
  CollectionReference get _transactionsCollection => _firestore.collection('payment_transactions');
  CollectionReference get _promotionsCollection => _firestore.collection('product_promotions');

  // ============================================
  // PRODUCTS
  // ============================================

  /// Obter todos os produtos disponíveis
  Future<List<PurchaseableProduct>> getAvailableProducts() async {
    final snapshot = await _productsCollection.where('isAvailable', isEqualTo: true).orderBy('price').get();

    return snapshot.docs
        .map((doc) => PurchaseableProductMapper.fromMap({...doc.data() as Map<String, dynamic>, 'productId': doc.id}))
        .toList();
  }

  /// Obter produto por ID
  Future<PurchaseableProduct?> getProduct(String productId) async {
    final doc = await _productsCollection.doc(productId).get();
    if (!doc.exists) return null;

    return PurchaseableProductMapper.fromMap({...doc.data() as Map<String, dynamic>, 'productId': doc.id});
  }

  /// Obter produtos por tipo
  Future<List<PurchaseableProduct>> getProductsByType(ProductType type) async {
    final snapshot = await _productsCollection
        .where('type', isEqualTo: type.name)
        .where('isAvailable', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => PurchaseableProductMapper.fromMap({...doc.data() as Map<String, dynamic>, 'productId': doc.id}))
        .toList();
  }

  /// Criar produto (admin)
  Future<String> createProduct(PurchaseableProduct product) async {
    final docRef = await _productsCollection.add(product.toMap());
    return docRef.id;
  }

  // ============================================
  // PURCHASES
  // ============================================

  /// Criar compra
  Future<String> createPurchase(InAppPurchase purchase) async {
    final docRef = await _purchasesCollection.add(purchase.toMap());
    return docRef.id;
  }

  /// Obter compra por ID
  Future<InAppPurchase?> getPurchase(String purchaseId) async {
    final doc = await _purchasesCollection.doc(purchaseId).get();
    if (!doc.exists) return null;

    return InAppPurchaseMapper.fromMap({...doc.data() as Map<String, dynamic>, 'purchaseId': doc.id});
  }

  /// Obter compras do usuário
  Future<List<InAppPurchase>> getUserPurchases(String userId) async {
    final snapshot = await _purchasesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('purchaseDate', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => InAppPurchaseMapper.fromMap({...doc.data() as Map<String, dynamic>, 'purchaseId': doc.id}))
        .toList();
  }

  /// Atualizar status da compra
  Future<void> updatePurchaseStatus(String purchaseId, PurchaseStatus status) async {
    await _purchasesCollection.doc(purchaseId).update({'status': status.name});
  }

  /// Marcar compra como consumida
  Future<void> consumePurchase(String purchaseId) async {
    await _purchasesCollection.doc(purchaseId).update({'consumedAt': FieldValue.serverTimestamp()});
  }

  // ============================================
  // INVENTORY
  // ============================================

  /// Obter inventário do usuário
  Future<UserInventory?> getUserInventory(String userId) async {
    final doc = await _inventoryCollection.doc(userId).get();
    if (!doc.exists) {
      // Criar inventário vazio
      final emptyInventory = UserInventory(userId: userId, balance: {}, items: [], updatedAt: DateTime.now());
      await _inventoryCollection.doc(userId).set(emptyInventory.toMap());
      return emptyInventory;
    }

    return UserInventoryMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  /// Adicionar item ao inventário
  Future<void> addToInventory({
    required String userId,
    required RewardType rewardType,
    required int quantity,
    DateTime? expiresAt,
  }) async {
    final inventory = await getUserInventory(userId);
    if (inventory == null) return;

    final currentBalance = inventory.getBalance(rewardType);
    final newBalance = {...inventory.balance};
    newBalance[rewardType] = currentBalance + quantity;

    final newItem = InventoryItem(
      itemId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: rewardType,
      quantity: quantity,
      acquiredAt: DateTime.now(),
      expiresAt: expiresAt,
      isExpired: false,
    );

    await _inventoryCollection.doc(userId).update({
      'balance': newBalance.map((k, v) => MapEntry(k.name, v)),
      'items': FieldValue.arrayUnion([newItem.toMap()]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Consumir item do inventário
  Future<bool> consumeFromInventory({
    required String userId,
    required RewardType rewardType,
    required int quantity,
  }) async {
    final inventory = await getUserInventory(userId);
    if (inventory == null || !inventory.hasEnough(rewardType, quantity)) {
      return false;
    }

    final currentBalance = inventory.getBalance(rewardType);
    final newBalance = {...inventory.balance};
    newBalance[rewardType] = currentBalance - quantity;

    await _inventoryCollection.doc(userId).update({
      'balance': newBalance.map((k, v) => MapEntry(k.name, v)),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  /// Obter saldo específico
  Future<int> getBalance(String userId, RewardType type) async {
    final inventory = await getUserInventory(userId);
    return inventory?.getBalance(type) ?? 0;
  }

  // ============================================
  // TRANSACTIONS
  // ============================================

  /// Criar transação
  Future<String> createTransaction(PaymentTransaction transaction) async {
    final docRef = await _transactionsCollection.add(transaction.toMap());
    return docRef.id;
  }

  /// Obter transação por ID
  Future<PaymentTransaction?> getTransaction(String transactionId) async {
    final doc = await _transactionsCollection.doc(transactionId).get();
    if (!doc.exists) return null;

    return PaymentTransactionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'transactionId': doc.id});
  }

  /// Atualizar status da transação
  Future<void> updateTransactionStatus(String transactionId, PaymentStatus status, {String? errorMessage}) async {
    final updates = <String, dynamic>{'status': status.name};

    if (status == PaymentStatus.completed) {
      updates['completedAt'] = FieldValue.serverTimestamp();
    }

    if (errorMessage != null) {
      updates['errorMessage'] = errorMessage;
    }

    await _transactionsCollection.doc(transactionId).update(updates);
  }

  /// Obter transações do usuário
  Future<List<PaymentTransaction>> getUserTransactions(String userId) async {
    final snapshot = await _transactionsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => PaymentTransactionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'transactionId': doc.id}),
        )
        .toList();
  }

  // ============================================
  // PROMOTIONS
  // ============================================

  /// Obter promoções ativas
  Future<List<ProductPromotion>> getActivePromotions() async {
    final now = DateTime.now();
    final snapshot = await _promotionsCollection
        .where('isActive', isEqualTo: true)
        .where('validFrom', isLessThanOrEqualTo: Timestamp.fromDate(now))
        .where('validUntil', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .get();

    return snapshot.docs
        .map((doc) => ProductPromotionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'promotionId': doc.id}))
        .where((p) => p.isValid)
        .toList();
  }

  /// Obter promoção para produto
  Future<ProductPromotion?> getPromotionForProduct(String productId) async {
    final promotions = await getActivePromotions();

    try {
      return promotions.firstWhere((p) => p.productIds.contains(productId));
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // PURCHASE HISTORY
  // ============================================

  /// Obter histórico de compras
  Future<PurchaseHistory> getPurchaseHistory(String userId) async {
    final purchases = await getUserPurchases(userId);

    final totalSpent = purchases.where((p) => p.isCompleted).fold<double>(0, (sum, p) => sum + p.amount);

    final rewardsSummary = <RewardType, int>{};
    for (final purchase in purchases.where((p) => p.isCompleted)) {
      final type = purchase.product.reward.type;
      rewardsSummary[type] = (rewardsSummary[type] ?? 0) + purchase.product.reward.quantity;
    }

    final completedPurchases = purchases.where((p) => p.isCompleted).toList();

    return PurchaseHistory(
      userId: userId,
      purchases: purchases,
      totalSpent: totalSpent,
      totalPurchases: completedPurchases.length,
      firstPurchaseDate: completedPurchases.isEmpty ? DateTime.now() : completedPurchases.last.purchaseDate,
      lastPurchaseDate: completedPurchases.isEmpty ? null : completedPurchases.first.purchaseDate,
      rewardsSummary: rewardsSummary,
    );
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Obter estatísticas de compras
  Future<PurchaseStats> getStats() async {
    final purchasesSnapshot = await _purchasesCollection.get();
    final purchases = purchasesSnapshot.docs
        .map((doc) => InAppPurchaseMapper.fromMap({...doc.data() as Map<String, dynamic>, 'purchaseId': doc.id}))
        .toList();

    final completed = purchases.where((p) => p.isCompleted).toList();
    final totalRevenue = completed.fold<double>(0, (sum, p) => sum + p.amount);

    final purchasesByType = <ProductType, int>{};
    final rewardsDistribution = <RewardType, int>{};

    for (final purchase in completed) {
      purchasesByType[purchase.product.type] = (purchasesByType[purchase.product.type] ?? 0) + 1;

      rewardsDistribution[purchase.product.reward.type] =
          (rewardsDistribution[purchase.product.reward.type] ?? 0) + purchase.product.reward.quantity;
    }

    // Top selling products
    final productCounts = <String, int>{};
    for (final purchase in completed) {
      productCounts[purchase.product.productId] = (productCounts[purchase.product.productId] ?? 0) + 1;
    }

    final sortedProducts = productCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final topProducts = <PurchaseableProduct>[];
    for (final entry in sortedProducts.take(5)) {
      final product = await getProduct(entry.key);
      if (product != null) topProducts.add(product);
    }

    return PurchaseStats(
      totalPurchases: completed.length,
      totalRevenue: totalRevenue,
      purchasesByType: purchasesByType,
      rewardsDistribution: rewardsDistribution,
      topSellingProducts: topProducts,
      averageTransactionValue: completed.isEmpty ? 0 : totalRevenue / completed.length,
      generatedAt: DateTime.now(),
    );
  }

  /// Stream de inventário
  Stream<UserInventory?> watchUserInventory(String userId) {
    return _inventoryCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserInventoryMapper.fromMap(doc.data() as Map<String, dynamic>);
    });
  }
}
