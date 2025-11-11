import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de mensagem do chat com IA
class AiMessageEntity {
  final String id;
  final String content;
  final bool isUserMessage; // true = usuário, false = IA
  final DateTime timestamp;
  final String? imageUrl; // Se mensagem inclui imagem
  final MessageType type;

  AiMessageEntity({
    required this.id,
    required this.content,
    required this.isUserMessage,
    required this.timestamp,
    this.imageUrl,
    this.type = MessageType.text,
  });

  factory AiMessageEntity.fromMap(Map<String, dynamic> map, String id) {
    return AiMessageEntity(
      id: id,
      content: map['content'] ?? '',
      isUserMessage: map['isUserMessage'] ?? false,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${map['type']}',
        orElse: () => MessageType.text,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isUserMessage': isUserMessage,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
      'type': type.toString().split('.').last,
    };
  }

  AiMessageEntity copyWith({
    String? id,
    String? content,
    bool? isUserMessage,
    DateTime? timestamp,
    String? imageUrl,
    MessageType? type,
  }) {
    return AiMessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
    );
  }
}

enum MessageType { text, image, suggestion }

/// Modelo de sessão de chat com IA
class AiChatSessionEntity {
  final String id;
  final String userId;
  final String title; // Ex: "Dicas de Corte", "Análise de Estilo"
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final int messageCount;

  AiChatSessionEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.lastMessageAt,
    required this.messageCount,
  });

  factory AiChatSessionEntity.fromMap(Map<String, dynamic> map, String id) {
    return AiChatSessionEntity(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? 'Chat com IA',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastMessageAt: (map['lastMessageAt'] as Timestamp).toDate(),
      messageCount: map['messageCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessageAt': Timestamp.fromDate(lastMessageAt),
      'messageCount': messageCount,
    };
  }

  AiChatSessionEntity copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    int? messageCount,
  }) {
    return AiChatSessionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messageCount: messageCount ?? this.messageCount,
    );
  }
}

/// Modelo de sugestão de estilo salva
class StyleSuggestionEntity {
  final String id;
  final String userId;
  final String suggestion;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isFavorite;

  StyleSuggestionEntity({
    required this.id,
    required this.userId,
    required this.suggestion,
    this.imageUrl,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory StyleSuggestionEntity.fromMap(Map<String, dynamic> map, String id) {
    return StyleSuggestionEntity(
      id: id,
      userId: map['userId'] ?? '',
      suggestion: map['suggestion'] ?? '',
      imageUrl: map['imageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'suggestion': suggestion,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'isFavorite': isFavorite,
    };
  }

  StyleSuggestionEntity copyWith({
    String? id,
    String? userId,
    String? suggestion,
    String? imageUrl,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return StyleSuggestionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      suggestion: suggestion ?? this.suggestion,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
