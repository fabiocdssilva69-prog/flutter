import 'package:cloud_firestore/cloud_firestore.dart';

/// Tipos de notificação disponíveis
enum NotificationType {
  match,
  message,
  like,
  booking,
  aiSuggestion,
  system,
}

/// Entidade de notificação
class NotificationEntity {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
    this.data,
    required this.isRead,
    required this.createdAt,
  });

  /// Converter de Firestore para Entity
  factory NotificationEntity.fromMap(String id, Map<String, dynamic> map) {
    return NotificationEntity(
      id: id,
      userId: map['userId'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.system,
      ),
      title: map['title'] as String,
      body: map['body'] as String,
      imageUrl: map['imageUrl'] as String?,
      data: map['data'] as Map<String, dynamic>?,
      isRead: map['isRead'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Converter Entity para Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type.name,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'data': data,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Copiar com modificações
  NotificationEntity copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    String? imageUrl,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Obter rota de navegação baseada no tipo
  String? get deepLinkRoute {
    if (data == null) return null;

    switch (type) {
      case NotificationType.match:
        return '/matches/${data!['matchId']}';
      case NotificationType.message:
        return '/chat/${data!['chatId']}';
      case NotificationType.like:
        return '/profile/${data!['profileId']}';
      case NotificationType.booking:
        return '/bookings/${data!['bookingId']}';
      case NotificationType.aiSuggestion:
        return '/ai/suggestions/${data!['suggestionId']}';
      case NotificationType.system:
        return null;
    }
  }

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
      case NotificationType.system:
        return 'notifications';
    }
  }
}
