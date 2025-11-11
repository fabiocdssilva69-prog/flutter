import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../core/infrastructure/mappable_hooks.dart';

part 'message_entity.mapper.dart';

/// Entidade representando uma mensagem no chat
@MappableClass()
class MessageEntity with MessageEntityMappable {
  final String messageId;
  final String senderId;
  final String text;
  final String? imageUrl; // Opcional - mensagem pode ter imagem
  @MappableField(hook: TimestampHook())
  final DateTime createdAt;
  final bool read;

  const MessageEntity({
    required this.messageId,
    required this.senderId,
    required this.text,
    this.imageUrl,
    required this.createdAt,
    required this.read,
  });

  /// Converte para Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'read': read,
    };
  }

  /// Cria MessageEntity de documento Firestore
  factory MessageEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageEntityMapper.fromMap({'messageId': doc.id, ...data});
  }

  /// Copia a mensagem marcando como lida
  MessageEntity markAsRead() {
    return MessageEntity(
      messageId: messageId,
      senderId: senderId,
      text: text,
      imageUrl: imageUrl,
      createdAt: createdAt,
      read: true,
    );
  }
}
