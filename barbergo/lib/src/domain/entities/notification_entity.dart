import 'package:dart_mappable/dart_mappable.dart';

import '../../core/infrastructure/mappable_hooks.dart';

part 'notification_entity.mapper.dart';

enum NotificationType { 
  applicationReceived, 
  applicationStatusUpdate, 
  systemAlert,
  match,
  message,
  like,
  booking,
  aiSuggestion,
}

@MappableClass()
class NotificationEntity with NotificationEntityMappable {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final Map<String, dynamic>? contextData;
  final bool isRead;

  @MappableField(hook: TimestampHook())
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.contextData,
    this.isRead = false,
  });

  static const fromMap = NotificationEntityMapper.fromMap;

  /// Obter ícone baseado no tipo
  String get iconName {
    switch (type) {
      case NotificationType.match:
        return 'favorite';
      case NotificationType.message:
        return 'chat_bubble';
      case NotificationType.like:
        return 'thumb_up';
      case NotificationType.booking:
        return 'event';
      case NotificationType.aiSuggestion:
        return 'auto_awesome';
      case NotificationType.applicationReceived:
      case NotificationType.applicationStatusUpdate:
      case NotificationType.systemAlert:
        return 'notifications';
    }
  }

  /// Obter rota de navegação baseada no tipo
  String? get deepLinkRoute {
    if (contextData == null) return null;

    switch (type) {
      case NotificationType.match:
        return contextData!['matchId'] != null ? '/matches/${contextData!['matchId']}' : null;
      case NotificationType.message:
        return contextData!['chatId'] != null ? '/chat/${contextData!['chatId']}' : null;
      case NotificationType.like:
        return contextData!['profileId'] != null ? '/profile/${contextData!['profileId']}' : null;
      case NotificationType.booking:
        return contextData!['bookingId'] != null ? '/bookings/${contextData!['bookingId']}' : null;
      case NotificationType.aiSuggestion:
        return contextData!['suggestionId'] != null ? '/ai/suggestions/${contextData!['suggestionId']}' : null;
      default:
        return null;
    }
  }
}
