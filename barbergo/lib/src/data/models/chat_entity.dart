import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../core/infrastructure/mappable_hooks.dart';

part 'chat_entity.mapper.dart';

/// Entidade representando um chat entre dois usuários
@MappableClass()
class ChatEntity with ChatEntityMappable {
  final String chatId;
  final String matchId;
  final List<String> participants; // [userId1, userId2]
  final String? lastMessage;
  @MappableField(hook: TimestampHook())
  final DateTime? lastMessageAt;
  @MappableField(hook: TimestampHook())
  final DateTime createdAt;

  const ChatEntity({
    required this.chatId,
    required this.matchId,
    required this.participants,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdAt,
  });

  /// Converte para Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'matchId': matchId,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt != null ? Timestamp.fromDate(lastMessageAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Cria ChatEntity de documento Firestore
  factory ChatEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatEntityMapper.fromMap({'chatId': doc.id, ...data});
  }

  /// Retorna o outro participante do chat
  String getOtherUserId(String currentUserId) {
    return participants.firstWhere((id) => id != currentUserId);
  }
}
