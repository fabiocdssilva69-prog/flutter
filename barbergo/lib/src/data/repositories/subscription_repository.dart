import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/subscription.dart';

part 'subscription_repository.g.dart';

/// Repository para Subscription Management
@riverpod
SubscriptionRepository subscriptionRepository(SubscriptionRepositoryRef ref) {
  return SubscriptionRepository(FirebaseFirestore.instance);
}

class SubscriptionRepository {
  final FirebaseFirestore _firestore;

  SubscriptionRepository(this._firestore);

  CollectionReference get _subscriptionsCollection => _firestore.collection('subscriptions');
  CollectionReference get _plansCollection => _firestore.collection('subscription_plans');
  CollectionReference get _usageCollection => _firestore.collection('feature_usage');
  CollectionReference get _historyCollection => _firestore.collection('subscription_history');
  CollectionReference get _offersCollection => _firestore.collection('subscription_offers');

  // ============================================
  // SUBSCRIPTIONS
  // ============================================

  /// Criar assinatura
  Future<String> createSubscription(Subscription subscription) async {
    final docRef = await _subscriptionsCollection.add(subscription.toMap());

    // Criar histórico
    await _addHistory(userId: subscription.userId, event: SubscriptionEvent.created, toTier: subscription.tier);

    return docRef.id;
  }

  /// Obter assinatura do usuário
  Future<Subscription?> getUserSubscription(String userId) async {
    final snapshot = await _subscriptionsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return SubscriptionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'subscriptionId': doc.id});
  }

  /// Atualizar assinatura
  Future<void> updateSubscription(String subscriptionId, Map<String, dynamic> updates) async {
    await _subscriptionsCollection.doc(subscriptionId).update({...updates, 'updatedAt': FieldValue.serverTimestamp()});
  }

  /// Cancelar assinatura
  Future<void> cancelSubscription(String subscriptionId, String reason) async {
    final subscription = await _getSubscription(subscriptionId);

    await updateSubscription(subscriptionId, {
      'status': SubscriptionStatus.cancelled.name,
      'cancelledAt': FieldValue.serverTimestamp(),
      'cancellationReason': reason,
      'autoRenew': false,
    });

    if (subscription != null) {
      await _addHistory(
        userId: subscription.userId,
        event: SubscriptionEvent.cancelled,
        fromTier: subscription.tier,
        notes: reason,
      );
    }
  }

  /// Renovar assinatura
  Future<void> renewSubscription(String subscriptionId) async {
    final subscription = await _getSubscription(subscriptionId);
    if (subscription == null) return;

    final newEndDate = DateTime.now().add(const Duration(days: 30));

    await updateSubscription(subscriptionId, {
      'status': SubscriptionStatus.active.name,
      'endDate': Timestamp.fromDate(newEndDate),
    });

    await _addHistory(userId: subscription.userId, event: SubscriptionEvent.renewed, toTier: subscription.tier);
  }

  /// Fazer upgrade
  Future<void> upgradeTier(String userId, SubscriptionTier newTier) async {
    final currentSub = await getUserSubscription(userId);
    if (currentSub == null) return;

    await updateSubscription(currentSub.subscriptionId, {'tier': newTier.name});

    await _addHistory(userId: userId, event: SubscriptionEvent.upgraded, fromTier: currentSub.tier, toTier: newTier);
  }

  /// Fazer downgrade
  Future<void> downgradeTier(String userId, SubscriptionTier newTier) async {
    final currentSub = await getUserSubscription(userId);
    if (currentSub == null) return;

    await updateSubscription(currentSub.subscriptionId, {'tier': newTier.name});

    await _addHistory(userId: userId, event: SubscriptionEvent.downgraded, fromTier: currentSub.tier, toTier: newTier);
  }

  // ============================================
  // PLANS & FEATURES
  // ============================================

  /// Obter todos os planos
  Future<List<SubscriptionPlan>> getAvailablePlans() async {
    final snapshot = await _plansCollection.where('isActive', isEqualTo: true).orderBy('price').get();

    return snapshot.docs
        .map((doc) => SubscriptionPlanMapper.fromMap({...doc.data() as Map<String, dynamic>, 'planId': doc.id}))
        .toList();
  }

  /// Obter planos por tier
  Future<List<SubscriptionPlan>> getPlansByTier(SubscriptionTier tier) async {
    final snapshot = await _plansCollection
        .where('tier', isEqualTo: tier.name)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => SubscriptionPlanMapper.fromMap({...doc.data() as Map<String, dynamic>, 'planId': doc.id}))
        .toList();
  }

  /// Verificar se usuário tem acesso a feature
  Future<bool> hasFeatureAccess(String userId, PremiumFeature feature) async {
    final subscription = await getUserSubscription(userId);

    if (subscription == null || !subscription.isActive) {
      return false;
    }

    // Regras de acesso por tier (simplificado)
    final tierLevel = subscription.tier.index;

    switch (feature) {
      case PremiumFeature.unlimitedLikes:
      case PremiumFeature.seeWhoLikedYou:
        return tierLevel >= SubscriptionTier.basic.index;

      case PremiumFeature.profileBoost:
      case PremiumFeature.superLike:
      case PremiumFeature.videoCall:
        return tierLevel >= SubscriptionTier.premium.index;

      case PremiumFeature.incognitoMode:
      case PremiumFeature.prioritySupport:
      case PremiumFeature.customBadge:
        return tierLevel >= SubscriptionTier.elite.index;

      default:
        return false;
    }
  }

  // ============================================
  // FEATURE USAGE
  // ============================================

  /// Obter uso de feature
  Future<FeatureUsage?> getFeatureUsage(String userId, PremiumFeature feature) async {
    final now = DateTime.now();
    final periodStart = DateTime(now.year, now.month, 1);
    final periodEnd = DateTime(now.year, now.month + 1, 0);

    final snapshot = await _usageCollection
        .where('userId', isEqualTo: userId)
        .where('feature', isEqualTo: feature.name)
        .where('periodStart', isEqualTo: Timestamp.fromDate(periodStart))
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return FeatureUsageMapper.fromMap({...doc.data() as Map<String, dynamic>, 'usageId': doc.id});
  }

  /// Incrementar uso de feature
  Future<void> incrementFeatureUsage(String userId, PremiumFeature feature) async {
    final now = DateTime.now();
    final periodStart = DateTime(now.year, now.month, 1);
    final periodEnd = DateTime(now.year, now.month + 1, 0);

    final existing = await getFeatureUsage(userId, feature);

    if (existing == null) {
      // Criar novo registro
      await _usageCollection.add({
        'userId': userId,
        'feature': feature.name,
        'usedCount': 1,
        'limit': null, // Define limites se necessário
        'periodStart': Timestamp.fromDate(periodStart),
        'periodEnd': Timestamp.fromDate(periodEnd),
        'lastUsedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Incrementar existente
      await _usageCollection.doc(existing.usageId).update({
        'usedCount': FieldValue.increment(1),
        'lastUsedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ============================================
  // OFFERS
  // ============================================

  /// Obter ofertas ativas
  Future<List<SubscriptionOffer>> getActiveOffers({String? userId}) async {
    final now = DateTime.now();

    var query = _offersCollection
        .where('isActive', isEqualTo: true)
        .where('validFrom', isLessThanOrEqualTo: Timestamp.fromDate(now))
        .where('validUntil', isGreaterThanOrEqualTo: Timestamp.fromDate(now));

    final snapshot = await query.get();

    var offers = snapshot.docs
        .map((doc) => SubscriptionOfferMapper.fromMap({...doc.data() as Map<String, dynamic>, 'offerId': doc.id}))
        .toList();

    // Filtrar por elegibilidade se userId fornecido
    if (userId != null) {
      offers = offers.where((o) => o.isEligibleUser(userId)).toList();
    }

    return offers.where((o) => o.isValid).toList();
  }

  /// Resgatar oferta
  Future<void> redeemOffer(String offerId) async {
    await _offersCollection.doc(offerId).update({'currentRedemptions': FieldValue.increment(1)});
  }

  // ============================================
  // HISTORY
  // ============================================

  /// Obter histórico do usuário
  Future<List<SubscriptionHistory>> getUserHistory(String userId) async {
    final snapshot = await _historyCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => SubscriptionHistoryMapper.fromMap({...doc.data() as Map<String, dynamic>, 'historyId': doc.id}))
        .toList();
  }

  Future<void> _addHistory({
    required String userId,
    required SubscriptionEvent event,
    SubscriptionTier? fromTier,
    SubscriptionTier? toTier,
    String? notes,
  }) async {
    await _historyCollection.add({
      'userId': userId,
      'event': event.name,
      'fromTier': fromTier?.name,
      'toTier': toTier?.name,
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Obter estatísticas de assinaturas
  Future<SubscriptionStats> getStats() async {
    final subscriptionsSnapshot = await _subscriptionsCollection.get();
    final subscriptions = subscriptionsSnapshot.docs
        .map((doc) => SubscriptionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'subscriptionId': doc.id}))
        .toList();

    final active = subscriptions.where((s) => s.isActive).length;
    final trial = subscriptions.where((s) => s.isInTrial).length;

    final tierDist = <SubscriptionTier, int>{};
    for (final sub in subscriptions) {
      tierDist[sub.tier] = (tierDist[sub.tier] ?? 0) + 1;
    }

    // Mock MRR/ARR (calcular com dados reais de pagamento)
    final mrr = active * 29.99; // Exemplo
    final arr = mrr * 12;

    return SubscriptionStats(
      totalSubscribers: subscriptions.length,
      activeSubscribers: active,
      trialUsers: trial,
      tierDistribution: tierDist,
      averageLifetime: 90.0, // Mock
      churnRate: 0.05, // Mock 5%
      mrr: mrr,
      arr: arr,
      generatedAt: DateTime.now(),
    );
  }

  /// Stream de assinatura do usuário
  Stream<Subscription?> watchUserSubscription(String userId) {
    return _subscriptionsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;

          final doc = snapshot.docs.first;
          return SubscriptionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'subscriptionId': doc.id});
        });
  }

  // ============================================
  // INTERNAL
  // ============================================

  Future<Subscription?> _getSubscription(String subscriptionId) async {
    final doc = await _subscriptionsCollection.doc(subscriptionId).get();
    if (!doc.exists) return null;

    return SubscriptionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'subscriptionId': doc.id});
  }
}
