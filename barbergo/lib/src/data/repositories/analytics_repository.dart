import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/analytics.dart';

part 'analytics_repository.g.dart';

@riverpod
AnalyticsRepository analyticsRepository(AnalyticsRepositoryRef ref) {
  return AnalyticsRepository(FirebaseFirestore.instance);
}

class AnalyticsRepository {
  final FirebaseFirestore _firestore;

  AnalyticsRepository(this._firestore);

  CollectionReference get _eventsCollection => _firestore.collection('analytics_events');
  CollectionReference get _sessionsCollection => _firestore.collection('user_sessions');
  CollectionReference get _crashesCollection => _firestore.collection('crash_reports');
  CollectionReference get _performanceCollection => _firestore.collection('performance_metrics');
  CollectionReference get _behaviorCollection => _firestore.collection('behavior_metrics');
  CollectionReference get _logsCollection => _firestore.collection('app_logs');
  CollectionReference get _feedbackCollection => _firestore.collection('user_feedback');
  CollectionReference get _remoteConfigCollection => _firestore.collection('remote_config');

  // ============================================
  // ANALYTICS EVENTS
  // ============================================

  Future<void> logEvent(AnalyticsEvent event) async {
    await _eventsCollection.add(event.toMap());
  }

  Future<List<AnalyticsEvent>> getUserEvents(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    EventCategory? category,
    int limit = 100,
  }) async {
    Query query = _eventsCollection.where('userId', isEqualTo: userId);

    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }
    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: endDate);
    }
    if (category != null) {
      query = query.where('category', isEqualTo: category.name);
    }

    final snapshot = await query.orderBy('timestamp', descending: true).limit(limit).get();

    return snapshot.docs
        .map((doc) => AnalyticsEventMapper.fromMap({...doc.data() as Map<String, dynamic>, 'eventId': doc.id}))
        .toList();
  }

  // ============================================
  // SESSIONS
  // ============================================

  Future<String> startSession(UserSession session) async {
    final docRef = await _sessionsCollection.add(session.toMap());
    return docRef.id;
  }

  Future<void> endSession(String sessionId, {int? duration, int? screenViews}) async {
    await _sessionsCollection.doc(sessionId).update({
      'endTime': FieldValue.serverTimestamp(),
      if (duration != null) 'duration': duration,
      if (screenViews != null) 'screenViews': screenViews,
    });
  }

  Future<void> updateSession(String sessionId, Map<String, dynamic> updates) async {
    await _sessionsCollection.doc(sessionId).update(updates);
  }

  // ============================================
  // CRASH REPORTS
  // ============================================

  Future<String> reportCrash(CrashReport crash) async {
    final docRef = await _crashesCollection.add(crash.toMap());
    return docRef.id;
  }

  Future<List<CrashReport>> getCrashReports({String? userId, CrashSeverity? severity, int limit = 50}) async {
    Query query = _crashesCollection.orderBy('timestamp', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    if (severity != null) {
      query = query.where('severity', isEqualTo: severity.name);
    }

    final snapshot = await query.limit(limit).get();

    return snapshot.docs
        .map((doc) => CrashReportMapper.fromMap({...doc.data() as Map<String, dynamic>, 'crashId': doc.id}))
        .toList();
  }

  // ============================================
  // PERFORMANCE METRICS
  // ============================================

  Future<void> logPerformanceMetric(PerformanceMetric metric) async {
    await _performanceCollection.add(metric.toMap());
  }

  Future<List<PerformanceMetric>> getPerformanceMetrics({
    MetricType? type,
    DateTime? startDate,
    int limit = 100,
  }) async {
    Query query = _performanceCollection.orderBy('timestamp', descending: true);

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }
    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }

    final snapshot = await query.limit(limit).get();

    return snapshot.docs
        .map((doc) => PerformanceMetricMapper.fromMap({...doc.data() as Map<String, dynamic>, 'metricId': doc.id}))
        .toList();
  }

  // ============================================
  // BEHAVIOR METRICS
  // ============================================

  Future<void> saveBehaviorMetrics(BehaviorMetrics metrics) async {
    await _behaviorCollection.doc(metrics.userId).set(metrics.toMap());
  }

  Future<BehaviorMetrics?> getBehaviorMetrics(String userId) async {
    final doc = await _behaviorCollection.doc(userId).get();
    if (!doc.exists) return null;

    return BehaviorMetricsMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> incrementBehaviorMetric(String userId, String metricName, [int amount = 1]) async {
    await _behaviorCollection.doc(userId).update({
      metricName: FieldValue.increment(amount),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  // ============================================
  // LOGS
  // ============================================

  Future<void> writeLog(AppLog log) async {
    await _logsCollection.add(log.toMap());
  }

  Future<List<AppLog>> getLogs({LogLevel? level, String? tag, String? userId, int limit = 100}) async {
    Query query = _logsCollection.orderBy('timestamp', descending: true);

    if (level != null) {
      query = query.where('level', isEqualTo: level.name);
    }
    if (tag != null) {
      query = query.where('tag', isEqualTo: tag);
    }
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    final snapshot = await query.limit(limit).get();

    return snapshot.docs
        .map((doc) => AppLogMapper.fromMap({...doc.data() as Map<String, dynamic>, 'logId': doc.id}))
        .toList();
  }

  // ============================================
  // FEEDBACK
  // ============================================

  Future<String> submitFeedback(UserFeedback feedback) async {
    final docRef = await _feedbackCollection.add(feedback.toMap());
    return docRef.id;
  }

  Future<List<UserFeedback>> getFeedback({
    String? userId,
    FeedbackType? type,
    bool? wasReviewed,
    int limit = 50,
  }) async {
    Query query = _feedbackCollection.orderBy('createdAt', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }
    if (wasReviewed != null) {
      query = query.where('wasReviewed', isEqualTo: wasReviewed);
    }

    final snapshot = await query.limit(limit).get();

    return snapshot.docs
        .map((doc) => UserFeedbackMapper.fromMap({...doc.data() as Map<String, dynamic>, 'feedbackId': doc.id}))
        .toList();
  }

  // ============================================
  // REMOTE CONFIG
  // ============================================

  Future<List<RemoteConfig>> getAllConfigs() async {
    final snapshot = await _remoteConfigCollection.get();

    return snapshot.docs
        .map((doc) => RemoteConfigMapper.fromMap({...doc.data() as Map<String, dynamic>, 'configId': doc.id}))
        .toList();
  }

  Future<RemoteConfig?> getConfig(String key) async {
    final snapshot = await _remoteConfigCollection.where('key', isEqualTo: key).limit(1).get();

    if (snapshot.docs.isEmpty) return null;

    return RemoteConfigMapper.fromMap({
      ...snapshot.docs.first.data() as Map<String, dynamic>,
      'configId': snapshot.docs.first.id,
    });
  }

  // ============================================
  // STATS & AGGREGATIONS
  // ============================================

  Future<Map<String, int>> getEventCounts({String? userId, DateTime? startDate, DateTime? endDate}) async {
    Query query = _eventsCollection;

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }
    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: endDate);
    }

    final snapshot = await query.get();
    final counts = <String, int>{};

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final eventName = data['eventName'] as String;
      counts[eventName] = (counts[eventName] ?? 0) + 1;
    }

    return counts;
  }
}
