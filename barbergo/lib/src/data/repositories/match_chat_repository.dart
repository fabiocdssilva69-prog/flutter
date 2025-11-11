import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../datasources/firestore_service.dart';
import '../models/chat_entity.dart';
import '../models/message_entity.dart';

part 'match_chat_repository.g.dart';

@riverpod
MatchChatRepository matchChatRepository(Ref ref) {
  return MatchChatRepository(ref.watch(firestoreServiceProvider));
}

/// Repositório para gerenciar chats entre matches
class MatchChatRepository {
  final FirestoreService _service;
  static const String chatsPath = 'chats';
  static const String messagesPath = 'messages';

  MatchChatRepository(this._service);

  /// Criar um chat
  Future<String> createChat({required String matchId, required List<String> participants}) async {
    final chat = ChatEntity(
      chatId: '',
      matchId: matchId,
      participants: participants,
      lastMessage: null,
      lastMessageAt: null,
      createdAt: DateTime.now(),
    );

    final doc = await _service.db.collection(chatsPath).add(chat.toFirestore());
    return doc.id;
  }

  /// Obter chat por matchId
  Future<ChatEntity?> getChatByMatchId(String matchId) async {
    final query = await _service.db.collection(chatsPath).where('matchId', isEqualTo: matchId).limit(1).get();

    if (query.docs.isEmpty) return null;

    return ChatEntity.fromFirestore(query.docs.first);
  }

  /// Listar todos os chats do usuário
  Stream<List<ChatEntity>> watchUserChats(String userId) {
    return _service.db
        .collection(chatsPath)
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => ChatEntity.fromFirestore(doc)).toList();
        });
  }

  /// Enviar mensagem
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? imageUrl,
  }) async {
    final message = MessageEntity(
      messageId: '',
      senderId: senderId,
      text: text,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      read: false,
    );

    // Adicionar mensagem na subcollection
    await _service.db.collection(chatsPath).doc(chatId).collection(messagesPath).add(message.toFirestore());

    // Atualizar última mensagem no chat
    await _service.db.collection(chatsPath).doc(chatId).update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }

  /// Listar mensagens do chat
  Stream<List<MessageEntity>> watchChatMessages(String chatId, {int limit = 100}) {
    return _service.db
        .collection(chatsPath)
        .doc(chatId)
        .collection(messagesPath)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => MessageEntity.fromFirestore(doc)).toList();
        });
  }

  /// Marcar mensagem como lida
  Future<void> markMessageAsRead(String chatId, String messageId) async {
    await _service.db.collection(chatsPath).doc(chatId).collection(messagesPath).doc(messageId).update({'read': true});
  }

  /// Marcar todas as mensagens como lidas
  Future<void> markAllMessagesAsRead(String chatId, String userId) async {
    final unreadMessages = await _service.db
        .collection(chatsPath)
        .doc(chatId)
        .collection(messagesPath)
        .where('senderId', isNotEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    final batch = _service.db.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }
}
