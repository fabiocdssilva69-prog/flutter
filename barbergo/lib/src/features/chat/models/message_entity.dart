import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, audio }

class MessageEntity {
  final String id;
  final String senderId;
  final String text;
  final MessageType type;
  final String? mediaUrl;
  final String? replyToId;
  final DateTime createdAt;
  final List<String> readBy;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.type,
    this.mediaUrl,
    this.replyToId,
    required this.createdAt,
    required this.readBy,
  });

  factory MessageEntity.fromMap(Map<String, dynamic> map, String id) {
    return MessageEntity(
      id: id,
      senderId: map['senderId'] as String,
      text: map['text'] as String? ?? '',
      type: MessageType.values.firstWhere((e) => e.name == map['type'], orElse: () => MessageType.text),
      mediaUrl: map['mediaUrl'] as String?,
      replyToId: map['replyToId'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      readBy: List<String>.from(map['readBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type.name,
      'mediaUrl': mediaUrl,
      'replyToId': replyToId,
      'createdAt': Timestamp.fromDate(createdAt),
      'readBy': readBy,
    };
  }

  bool isReadBy(String userId) => readBy.contains(userId);

  MessageEntity copyWith({
    String? id,
    String? senderId,
    String? text,
    MessageType? type,
    String? mediaUrl,
    String? replyToId,
    DateTime? createdAt,
    List<String>? readBy,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      replyToId: replyToId ?? this.replyToId,
      createdAt: createdAt ?? this.createdAt,
      readBy: readBy ?? this.readBy,
    );
  }
}
