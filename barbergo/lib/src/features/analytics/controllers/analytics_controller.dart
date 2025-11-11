import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/analytics_repository.dart';
import '../../domain/entities/analytics.dart';

part 'analytics_controller.g.dart';

@riverpod
class AnalyticsController extends _$AnalyticsController {
  String? _currentSessionId;
  DateTime? _sessionStartTime;

  @override
  FutureOr<bool> build() {
    return true; // Initialization
  }

  AnalyticsRepository get _repository => ref.read(analyticsRepositoryProvider);

  // ============================================
  // EVENT TRACKING
  // ============================================

  Future<void> logEvent({
    required String userId,
    required EventCategory category,
    required String eventName,
    Map<String, dynamic>? properties,
    String? screenName,
  }) async {
    final event = AnalyticsEvent(
      eventId: '',
      userId: userId,
      category: category,
      eventName: eventName,
      properties: properties ?? {},
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      screenName: screenName,
    );

    await _repository.logEvent(event);
  }

  // Common events helpers
  Future<void> logScreenView(String userId, String screenName) async {
    await logEvent(
      userId: userId,
      category: EventCategory.navigation,
      eventName: 'screen_view',
      properties: {'screen_name': screenName},
      screenName: screenName,
    );
  }

  Future<void> logButtonClick(String userId, String buttonName, {String? screen}) async {
    await logEvent(
      userId: userId,
      category: EventCategory.engagement,
      eventName: 'button_click',
      properties: {'button_name': buttonName, 'screen': screen},
    );
  }

  Future<void> logMatch(String userId, String matchedUserId) async {
    await logEvent(
      userId: userId,
      category: EventCategory.matching,
      eventName: 'new_match',
      properties: {'matched_user_id': matchedUserId},
    );
  }

  Future<void> logPurchase(String userId, String productId, double amount) async {
    await logEvent(
      userId: userId,
      category: EventCategory.monetization,
      eventName: 'purchase',
      properties: {'product_id': productId, 'amount': amount, 'currency': 'BRL'},
    );
  }

  // ============================================
  // SESSION TRACKING
  // ============================================

  Future<void> startSession(String userId) async {
    _sessionStartTime = DateTime.now();

    final session = UserSession(sessionId: '', userId: userId, startTime: _sessionStartTime!);

    _currentSessionId = await _repository.startSession(session);
  }

  Future<void> endSession() async {
    if (_currentSessionId == null || _sessionStartTime == null) return;

    final duration = DateTime.now().difference(_sessionStartTime!).inSeconds;

    await _repository.endSession(_currentSessionId!, duration: duration);

    _currentSessionId = null;
    _sessionStartTime = null;
  }

  // ============================================
  // CRASH REPORTING
  // ============================================

  Future<void> reportError({
    required String userId,
    required Object error,
    required StackTrace stackTrace,
    CrashSeverity severity = CrashSeverity.error,
    bool isFatal = false,
    Map<String, dynamic>? metadata,
  }) async {
    final crash = CrashReport(
      crashId: '',
      userId: userId,
      severity: severity,
      errorType: error.runtimeType.toString(),
      errorMessage: error.toString(),
      stackTrace: stackTrace.toString(),
      deviceInfo: await _getDeviceInfo(),
      appInfo: _getAppInfo(),
      timestamp: DateTime.now(),
      isFatal: isFatal,
    );

    await _repository.reportCrash(crash);
  }

  // ============================================
  // PERFORMANCE MONITORING
  // ============================================

  Future<void> trackPerformance({
    required String userId,
    required MetricType type,
    required String name,
    required double value,
    String unit = 'ms',
    Map<String, dynamic>? metadata,
  }) async {
    final metric = PerformanceMetric(
      metricId: '',
      userId: userId,
      type: type,
      name: name,
      value: value,
      unit: unit,
      metadata: metadata ?? {},
      timestamp: DateTime.now(),
    );

    await _repository.logPerformanceMetric(metric);
  }

  /// Helper para medir duração de operações
  Future<T> measurePerformance<T>({
    required String userId,
    required String operationName,
    required MetricType type,
    required Future<T> Function() operation,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await operation();
      stopwatch.stop();

      await trackPerformance(
        userId: userId,
        type: type,
        name: operationName,
        value: stopwatch.elapsedMilliseconds.toDouble(),
      );

      return result;
    } catch (e) {
      stopwatch.stop();
      await trackPerformance(
        userId: userId,
        type: type,
        name: '$operationName.error',
        value: stopwatch.elapsedMilliseconds.toDouble(),
      );
      rethrow;
    }
  }

  // ============================================
  // BEHAVIOR METRICS
  // ============================================

  Future<void> updateBehaviorMetrics({
    required String userId,
    int? profileViews,
    int? swipes,
    int? likes,
    int? matches,
    int? messages,
  }) async {
    if (profileViews != null) {
      await _repository.incrementBehaviorMetric(userId, 'profileViews', profileViews);
    }
    if (swipes != null) {
      await _repository.incrementBehaviorMetric(userId, 'swipes', swipes);
    }
    if (likes != null) {
      await _repository.incrementBehaviorMetric(userId, 'likes', likes);
    }
    if (matches != null) {
      await _repository.incrementBehaviorMetric(userId, 'matches', matches);
    }
    if (messages != null) {
      await _repository.incrementBehaviorMetric(userId, 'messages', messages);
    }
  }

  // ============================================
  // LOGGING
  // ============================================

  Future<void> log({
    required LogLevel level,
    required String message,
    String? tag,
    Map<String, dynamic>? data,
    String? userId,
  }) async {
    final appLog = AppLog(
      logId: '',
      level: level,
      message: message,
      tag: tag,
      data: data ?? {},
      timestamp: DateTime.now(),
      userId: userId,
      sessionId: _currentSessionId,
    );

    await _repository.writeLog(appLog);
  }

  // Log helpers
  Future<void> logDebug(String message, {String? tag, Map<String, dynamic>? data}) async {
    await log(level: LogLevel.debug, message: message, tag: tag, data: data);
  }

  Future<void> logInfo(String message, {String? tag, Map<String, dynamic>? data}) async {
    await log(level: LogLevel.info, message: message, tag: tag, data: data);
  }

  Future<void> logWarning(String message, {String? tag, Map<String, dynamic>? data}) async {
    await log(level: LogLevel.warning, message: message, tag: tag, data: data);
  }

  Future<void> logError(String message, {String? tag, Map<String, dynamic>? data}) async {
    await log(level: LogLevel.error, message: message, tag: tag, data: data);
  }

  // ============================================
  // FEEDBACK
  // ============================================

  Future<String> submitFeedback({
    required String userId,
    required FeedbackType type,
    int? rating,
    String? comment,
    String? screenshot,
    Map<String, dynamic>? metadata,
  }) async {
    final feedback = UserFeedback(
      feedbackId: '',
      userId: userId,
      type: type,
      rating: rating,
      comment: comment,
      screenshot: screenshot,
      metadata: metadata ?? {},
      createdAt: DateTime.now(),
    );

    return await _repository.submitFeedback(feedback);
  }

  // ============================================
  // REMOTE CONFIG
  // ============================================

  Future<T?> getRemoteConfig<T>(String key, T defaultValue) async {
    final config = await _repository.getConfig(key);
    if (config == null) return defaultValue;

    return config.value as T? ?? defaultValue;
  }

  // ============================================
  // HELPERS
  // ============================================

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': kIsWeb ? 'web' : Platform.operatingSystem,
      'version': kIsWeb ? 'web' : Platform.operatingSystemVersion,
      'isPhysical': !kIsWeb,
    };
  }

  Map<String, dynamic> _getAppInfo() {
    return {'version': '1.0.0', 'buildNumber': '1', 'environment': 'production'};
  }
}

// ============================================
// PROVIDERS
// ============================================

@riverpod
Future<BehaviorMetrics?> behaviorMetrics(BehaviorMetricsRef ref, String userId) async {
  final repository = ref.read(analyticsRepositoryProvider);
  return await repository.getBehaviorMetrics(userId);
}

@riverpod
Future<List<CrashReport>> recentCrashes(RecentCrashesRef ref, {String? userId}) async {
  final repository = ref.read(analyticsRepositoryProvider);
  return await repository.getCrashReports(userId: userId, limit: 10);
}
