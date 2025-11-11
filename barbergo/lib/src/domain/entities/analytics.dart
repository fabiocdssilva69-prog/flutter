import 'package:dart_mappable/dart_mappable.dart';

part 'analytics.g.dart';

/// Sistema completo de Analytics e Métricas
@MappableClass()
class AnalyticsEvent with AnalyticsEventMappable {
  final String eventId;
  final String userId;
  final EventCategory category;
  final String eventName;
  final Map<String, dynamic> properties;
  final DateTime timestamp;
  final String? sessionId;
  final String? screenName;

  const AnalyticsEvent({
    required this.eventId,
    required this.userId,
    required this.category,
    required this.eventName,
    this.properties = const {},
    required this.timestamp,
    this.sessionId,
    this.screenName,
  });
}

enum EventCategory { user, profile, discovery, matching, messaging, monetization, engagement, navigation, system }

/// Session tracking
@MappableClass()
class UserSession with UserSessionMappable {
  final String sessionId;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration; // seconds
  final int screenViews;
  final List<String> screensVisited;
  final Map<String, int> actionsPerformed;

  const UserSession({
    required this.sessionId,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.duration = 0,
    this.screenViews = 0,
    this.screensVisited = const [],
    this.actionsPerformed = const {},
  });
}

/// Crash & Error Reporting
@MappableClass()
class CrashReport with CrashReportMappable {
  final String crashId;
  final String userId;
  final CrashSeverity severity;
  final String errorType;
  final String errorMessage;
  final String stackTrace;
  final Map<String, dynamic> deviceInfo;
  final Map<String, dynamic> appInfo;
  final DateTime timestamp;
  final bool isFatal;

  const CrashReport({
    required this.crashId,
    required this.userId,
    required this.severity,
    required this.errorType,
    required this.errorMessage,
    required this.stackTrace,
    this.deviceInfo = const {},
    this.appInfo = const {},
    required this.timestamp,
    this.isFatal = false,
  });
}

enum CrashSeverity { debug, info, warning, error, fatal }

/// Performance Monitoring
@MappableClass()
class PerformanceMetric with PerformanceMetricMappable {
  final String metricId;
  final String userId;
  final MetricType type;
  final String name;
  final double value;
  final String unit;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  const PerformanceMetric({
    required this.metricId,
    required this.userId,
    required this.type,
    required this.name,
    required this.value,
    this.unit = 'ms',
    this.metadata = const {},
    required this.timestamp,
  });
}

enum MetricType { appStart, screenLoad, apiCall, databaseQuery, imageLoad, custom }

/// User Behavior Analytics
@MappableClass()
class BehaviorMetrics with BehaviorMetricsMappable {
  final String userId;
  final int dailyActiveStreak;
  final int totalSessions;
  final double averageSessionDuration; // minutes
  final int profileViews;
  final int swipes;
  final int likes;
  final int matches;
  final int messages;
  final double engagementScore;
  final DateTime lastActive;
  final Map<String, int> featureUsage;

  const BehaviorMetrics({
    required this.userId,
    this.dailyActiveStreak = 0,
    this.totalSessions = 0,
    this.averageSessionDuration = 0,
    this.profileViews = 0,
    this.swipes = 0,
    this.likes = 0,
    this.matches = 0,
    this.messages = 0,
    this.engagementScore = 0,
    required this.lastActive,
    this.featureUsage = const {},
  });
}

/// A/B Testing
@MappableClass()
class ABTest with ABTestMappable {
  final String testId;
  final String testName;
  final String description;
  final bool isActive;
  final List<ABTestVariant> variants;
  final DateTime startDate;
  final DateTime? endDate;
  final Map<String, int> participantCounts;

  const ABTest({
    required this.testId,
    required this.testName,
    required this.description,
    this.isActive = true,
    required this.variants,
    required this.startDate,
    this.endDate,
    this.participantCounts = const {},
  });
}

@MappableClass()
class ABTestVariant with ABTestVariantMappable {
  final String variantId;
  final String name;
  final double weight; // 0-1
  final Map<String, dynamic> config;

  const ABTestVariant({required this.variantId, required this.name, required this.weight, this.config = const {}});
}

/// Logging
@MappableClass()
class AppLog with AppLogMappable {
  final String logId;
  final LogLevel level;
  final String message;
  final String? tag;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String? userId;
  final String? sessionId;

  const AppLog({
    required this.logId,
    required this.level,
    required this.message,
    this.tag,
    this.data = const {},
    required this.timestamp,
    this.userId,
    this.sessionId,
  });
}

enum LogLevel { verbose, debug, info, warning, error, wtf }

/// App Health Monitor
@MappableClass()
class AppHealthStatus with AppHealthStatusMappable {
  final DateTime checkTime;
  final bool isHealthy;
  final List<HealthCheck> checks;
  final Map<String, dynamic> metrics;

  const AppHealthStatus({
    required this.checkTime,
    required this.isHealthy,
    required this.checks,
    this.metrics = const {},
  });
}

@MappableClass()
class HealthCheck with HealthCheckMappable {
  final String checkName;
  final bool passed;
  final String? message;
  final double? responseTime;

  const HealthCheck({required this.checkName, required this.passed, this.message, this.responseTime});
}

/// Remote Config
@MappableClass()
class RemoteConfig with RemoteConfigMappable {
  final String configId;
  final String key;
  final dynamic value;
  final ConfigType type;
  final String? description;
  final DateTime updatedAt;

  const RemoteConfig({
    required this.configId,
    required this.key,
    required this.value,
    required this.type,
    this.description,
    required this.updatedAt,
  });
}

enum ConfigType { string, int, double, bool, json }

/// App Feedback
@MappableClass()
class UserFeedback with UserFeedbackMappable {
  final String feedbackId;
  final String userId;
  final FeedbackType type;
  final int? rating; // 1-5
  final String? comment;
  final String? screenshot;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final bool wasReviewed;

  const UserFeedback({
    required this.feedbackId,
    required this.userId,
    required this.type,
    this.rating,
    this.comment,
    this.screenshot,
    this.metadata = const {},
    required this.createdAt,
    this.wasReviewed = false,
  });
}

enum FeedbackType { bug, feature, improvement, complaint, praise, other }
