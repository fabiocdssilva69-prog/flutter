import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository.dart';
import '../models/chat_entity.dart';
import '../models/message_entity.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
    authRepository: ref.watch(authRepositoryProvider),
  );
});

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final AuthRepository authRepository;

  ChatRepository({required this.firestore, required this.storage, required this.authRepository});

  /// Get current user ID
  String? get currentUserId => authRepository.currentUser?.uid;

  // ==================== CHATS ====================

  /// Watch all chats for current user
  Stream<List<ChatEntity>> watchUserChats() {
    final userId = currentUserId;
    if (userId == null) return Stream.value([]);

    return firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatEntity.fromMap(doc.data(), doc.id)).toList());
  }

  /// Get or create chat between two users
  Future<ChatEntity> getOrCreateChat(String otherUserId) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    // Check if chat already exists
    final existingChats = await firestore.collection('chats').where('participants', arrayContains: userId).get();

    for (var doc in existingChats.docs) {
      final participants = List<String>.from(doc.data()['participants'] ?? []);
      if (participants.contains(otherUserId)) {
        return ChatEntity.fromMap(doc.data(), doc.id);
      }
    }

    // Create new chat
    final chatRef = firestore.collection('chats').doc();
    final newChat = ChatEntity(
      id: chatRef.id,
      participants: [userId, otherUserId],
      lastMessage: null,
      lastMessageTime: DateTime.now(),
      unreadCount: {userId: 0, otherUserId: 0},
      createdAt: DateTime.now(),
    );

    await chatRef.set(newChat.toMap());
    return newChat;
  }

  /// Delete chat
  Future<void> deleteChat(String chatId) async {
    // Delete all messages first
    final messagesSnapshot = await firestore.collection('chats').doc(chatId).collection('messages').get();

    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete chat document
    await firestore.collection('chats').doc(chatId).delete();
  }

  // ==================== MESSAGES ====================

  /// Watch messages in a chat
  Stream<List<MessageEntity>> watchMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageEntity.fromMap(doc.data(), doc.id)).toList());
  }

  /// Send text message
  Future<void> sendMessage({required String chatId, required String text, String? replyToId}) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final messageRef = firestore.collection('chats').doc(chatId).collection('messages').doc();

    final message = MessageEntity(
      id: messageRef.id,
      senderId: userId,
      text: text,
      type: MessageType.text,
      mediaUrl: null,
      replyToId: replyToId,
      createdAt: DateTime.now(),
      readBy: [userId],
    );

    await messageRef.set(message.toMap());

    // Update chat last message
    await _updateChatLastMessage(chatId, text);
  }

  /// Send image message
  Future<void> sendImageMessage({required String chatId, required String imagePath, String? caption}) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    // Upload image to Storage
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = storage.ref().child('chat_media/$userId/$fileName');

    await storageRef.putFile(File(imagePath));
    final imageUrl = await storageRef.getDownloadURL();

    // Create message
    final messageRef = firestore.collection('chats').doc(chatId).collection('messages').doc();

    final message = MessageEntity(
      id: messageRef.id,
      senderId: userId,
      text: caption ?? '',
      type: MessageType.image,
      mediaUrl: imageUrl,
      replyToId: null,
      createdAt: DateTime.now(),
      readBy: [userId],
    );

    await messageRef.set(message.toMap());

    // Update chat last message
    await _updateChatLastMessage(chatId, '📷 Foto');
  }

  /// Mark messages as read
  Future<void> markAsRead(String chatId, List<String> messageIds) async {
    final userId = currentUserId;
    if (userId == null) return;

    final batch = firestore.batch();

    for (var messageId in messageIds) {
      final messageRef = firestore.collection('chats').doc(chatId).collection('messages').doc(messageId);

      batch.update(messageRef, {
        'readBy': FieldValue.arrayUnion([userId]),
      });
    }

    await batch.commit();

    // Reset unread count
    await firestore.collection('chats').doc(chatId).update({'unreadCount.$userId': 0});
  }

  /// Delete message
  Future<void> deleteMessage(String chatId, String messageId) async {
    await firestore.collection('chats').doc(chatId).collection('messages').doc(messageId).delete();
  }

  // ==================== PRIVATE HELPERS ====================

  Future<void> _updateChatLastMessage(String chatId, String text) async {
    final userId = currentUserId;
    if (userId == null) return;

    final chatRef = firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();
    final participants = List<String>.from(chatDoc.data()?['participants'] ?? []);
    final otherUserId = participants.firstWhere((id) => id != userId);

    await chatRef.update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount.$otherUserId': FieldValue.increment(1),
    });
  }
}
