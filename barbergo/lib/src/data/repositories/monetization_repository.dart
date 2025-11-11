import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/boost_and_gifts.dart';

part 'monetization_repository.g.dart';

/// Repository para Boosts, Gifts, Analytics e Revenue
@riverpod
MonetizationRepository monetizationRepository(MonetizationRepositoryRef ref) {
  return MonetizationRepository(FirebaseFirestore.instance);
}

class MonetizationRepository {
  final FirebaseFirestore _firestore;

  MonetizationRepository(this._firestore);

  CollectionReference get _boostsCollection => _firestore.collection('profile_boosts');
  CollectionReference get _giftsCollection => _firestore.collection('virtual_gifts');
  CollectionReference get _giftTransactionsCollection => _firestore.collection('gift_transactions');
  CollectionReference get _analyticsCollection => _firestore.collection('profile_analytics');
  CollectionReference get _revenueCollection => _firestore.collection('revenue_records');

  // ============================================
  // BOOSTS
  // ============================================

  /// Criar boost
  Future<String> createBoost(ProfileBoost boost) async {
    final docRef = await _boostsCollection.add(boost.toMap());
    return docRef.id;
  }

  /// Obter boost por ID
  Future<ProfileBoost?> getBoost(String boostId) async {
    final doc = await _boostsCollection.doc(boostId).get();
    if (!doc.exists) return null;

    return ProfileBoostMapper.fromMap({...doc.data() as Map<String, dynamic>, 'boostId': doc.id});
  }

  /// Obter boosts do usuário
  Future<List<ProfileBoost>> getUserBoosts(String userId) async {
    final snapshot = await _boostsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ProfileBoostMapper.fromMap({...doc.data() as Map<String, dynamic>, 'boostId': doc.id}))
        .toList();
  }

  /// Obter boost ativo do usuário
  Future<ProfileBoost?> getActiveBoost(String userId) async {
    final now = DateTime.now();
    final snapshot = await _boostsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: BoostStatus.active.name)
        .where('endTime', isGreaterThan: Timestamp.fromDate(now))
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return ProfileBoostMapper.fromMap({...doc.data() as Map<String, dynamic>, 'boostId': doc.id});
  }

  /// Atualizar estatísticas do boost
  Future<void> updateBoostStats({
    required String boostId,
    int? impressions,
    int? profileViews,
    int? likesReceived,
    int? matchesReceived,
  }) async {
    final updates = <String, dynamic>{};

    if (impressions != null) {
      updates['impressions'] = FieldValue.increment(impressions);
    }
    if (profileViews != null) {
      updates['profileViews'] = FieldValue.increment(profileViews);
      if (impressions != null) {
        // Calcular CTR
        final boost = await getBoost(boostId);
        if (boost != null) {
          final newImpressions = boost.impressions + impressions;
          final newViews = boost.profileViews + profileViews;
          updates['ctr'] = (newViews / newImpressions) * 100;
        }
      }
    }
    if (likesReceived != null) {
      updates['likesReceived'] = FieldValue.increment(likesReceived);
    }
    if (matchesReceived != null) {
      updates['matchesReceived'] = FieldValue.increment(matchesReceived);
    }

    if (updates.isNotEmpty) {
      await _boostsCollection.doc(boostId).update(updates);
    }
  }

  /// Completar boost
  Future<void> completeBoost(String boostId) async {
    await _boostsCollection.doc(boostId).update({'status': BoostStatus.completed.name});
  }

  /// Obter estatísticas de boosts
  Future<BoostStats> getBoostStats(String userId) async {
    final boosts = await getUserBoosts(userId);
    final completed = boosts.where((b) => b.status == BoostStatus.completed).toList();

    if (completed.isEmpty) {
      return BoostStats(
        userId: userId,
        totalBoostsUsed: 0,
        totalBoostTime: Duration.zero,
        totalImpressions: 0,
        totalProfileViews: 0,
        totalLikesReceived: 0,
        totalMatchesReceived: 0,
        averageCTR: 0,
        averageConversionRate: 0,
      );
    }

    final totalTime = completed.fold<Duration>(Duration.zero, (sum, b) => sum + b.duration);

    final totalImpressions = completed.fold(0, (sum, b) => sum + b.impressions);
    final totalViews = completed.fold(0, (sum, b) => sum + b.profileViews);
    final totalLikes = completed.fold(0, (sum, b) => sum + b.likesReceived);
    final totalMatches = completed.fold(0, (sum, b) => sum + b.matchesReceived);

    final avgCTR = completed.fold(0.0, (sum, b) => sum + b.ctr) / completed.length;
    final avgConversion = completed.fold(0.0, (sum, b) => sum + b.conversionRate) / completed.length;

    // Encontrar boost mais efetivo (por matches)
    BoostType? mostEffective;
    if (completed.isNotEmpty) {
      final grouped = <BoostType, List<ProfileBoost>>{};
      for (final boost in completed) {
        grouped.putIfAbsent(boost.type, () => []).add(boost);
      }

      var maxMatches = 0.0;
      for (final entry in grouped.entries) {
        final avgMatches = entry.value.fold(0, (sum, b) => sum + b.matchesReceived) / entry.value.length;
        if (avgMatches > maxMatches) {
          maxMatches = avgMatches;
          mostEffective = entry.key;
        }
      }
    }

    return BoostStats(
      userId: userId,
      totalBoostsUsed: completed.length,
      totalBoostTime: totalTime,
      totalImpressions: totalImpressions,
      totalProfileViews: totalViews,
      totalLikesReceived: totalLikes,
      totalMatchesReceived: totalMatches,
      averageCTR: avgCTR,
      averageConversionRate: avgConversion,
      lastBoostDate: completed.first.createdAt,
      mostEffectiveBoost: mostEffective,
    );
  }

  // ============================================
  // GIFTS
  // ============================================

  /// Obter todos os presentes
  Future<List<VirtualGift>> getAvailableGifts() async {
    final snapshot = await _giftsCollection.where('isAvailable', isEqualTo: true).orderBy('coinPrice').get();

    return snapshot.docs
        .map((doc) => VirtualGiftMapper.fromMap({...doc.data() as Map<String, dynamic>, 'giftId': doc.id}))
        .toList();
  }

  /// Enviar presente
  Future<String> sendGift(GiftTransaction transaction) async {
    final docRef = await _giftTransactionsCollection.add(transaction.toMap());
    return docRef.id;
  }

  /// Obter presentes recebidos
  Future<List<GiftTransaction>> getReceivedGifts(String userId) async {
    final snapshot = await _giftTransactionsCollection
        .where('recipientId', isEqualTo: userId)
        .orderBy('sentAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => GiftTransactionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'transactionId': doc.id}))
        .toList();
  }

  /// Marcar presente como visualizado
  Future<void> markGiftAsViewed(String transactionId) async {
    await _giftTransactionsCollection.doc(transactionId).update({
      'wasViewed': true,
      'viewedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Obter estatísticas de presentes
  Future<GiftStats> getGiftStats(String userId) async {
    final sent = await _giftTransactionsCollection.where('senderId', isEqualTo: userId).get();

    final received = await _giftTransactionsCollection.where('recipientId', isEqualTo: userId).get();

    final sentList = sent.docs
        .map((doc) => GiftTransactionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'transactionId': doc.id}))
        .toList();

    final receivedList = received.docs
        .map((doc) => GiftTransactionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'transactionId': doc.id}))
        .toList();

    final coinsSpent = sentList.fold(0, (sum, t) => sum + t.gift.coinPrice);

    final sentByCategory = <GiftCategory, int>{};
    for (final tx in sentList) {
      sentByCategory[tx.gift.category] = (sentByCategory[tx.gift.category] ?? 0) + 1;
    }

    final receivedByCategory = <GiftCategory, int>{};
    for (final tx in receivedList) {
      receivedByCategory[tx.gift.category] = (receivedByCategory[tx.gift.category] ?? 0) + 1;
    }

    return GiftStats(
      userId: userId,
      giftsSent: sentList.length,
      giftsReceived: receivedList.length,
      coinsSpent: coinsSpent,
      sentByCategory: sentByCategory,
      receivedByCategory: receivedByCategory,
      mostSentGifts: [],
      mostReceivedGifts: [],
    );
  }

  // ============================================
  // ANALYTICS
  // ============================================

  /// Salvar analytics
  Future<void> saveAnalytics(ProfileAnalytics analytics) async {
    await _analyticsCollection.doc(analytics.userId).set(analytics.toMap());
  }

  /// Obter analytics do usuário
  Future<ProfileAnalytics?> getUserAnalytics(String userId) async {
    final doc = await _analyticsCollection.doc(userId).get();
    if (!doc.exists) return null;

    return ProfileAnalyticsMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  // ============================================
  // REVENUE
  // ============================================

  /// Registrar receita
  Future<String> recordRevenue(RevenueRecord record) async {
    final docRef = await _revenueCollection.add(record.toMap());
    return docRef.id;
  }

  /// Gerar relatório de receita
  Future<RevenueReport> generateRevenueReport({required DateTime periodStart, required DateTime periodEnd}) async {
    final snapshot = await _revenueCollection
        .where('recordedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(periodStart))
        .where('recordedAt', isLessThanOrEqualTo: Timestamp.fromDate(periodEnd))
        .get();

    final records = snapshot.docs
        .map((doc) => RevenueRecordMapper.fromMap({...doc.data() as Map<String, dynamic>, 'recordId': doc.id}))
        .toList();

    final totalRevenue = records.fold<double>(0, (sum, r) => sum + r.amount);

    final bySource = <RevenueSource, double>{};
    for (final record in records) {
      bySource[record.source] = (bySource[record.source] ?? 0) + record.amount;
    }

    final uniquePayers = records.map((r) => r.userId).toSet().length;

    return RevenueReport(
      periodStart: periodStart,
      periodEnd: periodEnd,
      totalRevenue: totalRevenue,
      subscriptionRevenue: bySource[RevenueSource.subscription] ?? 0,
      purchaseRevenue: bySource[RevenueSource.inAppPurchase] ?? 0,
      boostRevenue: bySource[RevenueSource.boost] ?? 0,
      giftRevenue: bySource[RevenueSource.gift] ?? 0,
      totalTransactions: records.length,
      averageTransactionValue: records.isEmpty ? 0 : totalRevenue / records.length,
      uniquePayers: uniquePayers,
      revenueBySource: bySource,
      revenueByRegion: {},
      projectedMRR: totalRevenue, // Simplificado
      projectedARR: totalRevenue * 12,
      generatedAt: DateTime.now(),
    );
  }

  /// Stream de boost ativo
  Stream<ProfileBoost?> watchActiveBoost(String userId) {
    return _boostsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: BoostStatus.active.name)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;

          final doc = snapshot.docs.first;
          return ProfileBoostMapper.fromMap({...doc.data() as Map<String, dynamic>, 'boostId': doc.id});
        });
  }
}
