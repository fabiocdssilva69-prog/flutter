import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/ai_message_entity.dart';

/// Repository para operações de chat com IA
class AiRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _currentUserId => _auth.currentUser!.uid;

  // ========== CHAT SESSIONS ==========

  /// Cria nova sessão de chat
  Future<AiChatSessionEntity> createChatSession(String title) async {
    final docRef = await _firestore.collection('profiles').doc(_currentUserId).collection('ai_chats').add({
      'userId': _currentUserId,
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessageAt': FieldValue.serverTimestamp(),
      'messageCount': 0,
    });

    final doc = await docRef.get();
    return AiChatSessionEntity.fromMap(doc.data()!, doc.id);
  }

  /// Stream de sessões de chat do usuário
  Stream<List<AiChatSessionEntity>> watchChatSessions() {
    return _firestore
        .collection('profiles')
        .doc(_currentUserId)
        .collection('ai_chats')
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AiChatSessionEntity.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  /// Busca sessão específica
  Future<AiChatSessionEntity?> getChatSession(String sessionId) async {
    final doc = await _firestore.collection('profiles').doc(_currentUserId).collection('ai_chats').doc(sessionId).get();

    if (!doc.exists) return null;
    return AiChatSessionEntity.fromMap(doc.data()!, doc.id);
  }

  /// Atualiza sessão (título, lastMessageAt, etc)
  Future<void> updateChatSession(String sessionId, Map<String, dynamic> data) async {
    await _firestore.collection('profiles').doc(_currentUserId).collection('ai_chats').doc(sessionId).update(data);
  }

  /// Deleta sessão de chat
  Future<void> deleteChatSession(String sessionId) async {
    // Deletar todas as mensagens primeiro
    final messages = await _firestore
        .collection('profiles')
        .doc(_currentUserId)
        .collection('ai_chats')
        .doc(sessionId)
        .collection('messages')
        .get();

    for (var doc in messages.docs) {
      await doc.reference.delete();
    }

    // Deletar sessão
    await _firestore.collection('profiles').doc(_currentUserId).collection('ai_chats').doc(sessionId).delete();
  }

  // ========== MESSAGES ==========

  /// Adiciona mensagem à sessão
  Future<AiMessageEntity> addMessage({
    required String sessionId,
    required String content,
    required bool isUserMessage,
    String? imageUrl,
    MessageType type = MessageType.text,
  }) async {
    final docRef = await _firestore
        .collection('profiles')
        .doc(_currentUserId)
        .collection('ai_chats')
        .doc(sessionId)
        .collection('messages')
        .add({
          'content': content,
          'isUserMessage': isUserMessage,
          'timestamp': FieldValue.serverTimestamp(),
          'imageUrl': imageUrl,
          'type': type.toString().split('.').last,
        });

    // Atualizar sessão
    await updateChatSession(sessionId, {
      'lastMessageAt': FieldValue.serverTimestamp(),
      'messageCount': FieldValue.increment(1),
    });

    final doc = await docRef.get();
    return AiMessageEntity.fromMap(doc.data()!, doc.id);
  }

  /// Stream de mensagens da sessão
  Stream<List<AiMessageEntity>> watchMessages(String sessionId) {
    return _firestore
        .collection('profiles')
        .doc(_currentUserId)
        .collection('ai_chats')
        .doc(sessionId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AiMessageEntity.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  /// Busca últimas mensagens (para contexto)
  Future<List<AiMessageEntity>> getRecentMessages(String sessionId, {int limit = 10}) async {
    final snapshot = await _firestore
        .collection('profiles')
        .doc(_currentUserId)
        .collection('ai_chats')
        .doc(sessionId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => AiMessageEntity.fromMap(doc.data(), doc.id)).toList().reversed.toList();
  }

  // ========== STYLE SUGGESTIONS ==========

  /// Salva sugestão de estilo
  Future<StyleSuggestionEntity> saveSuggestion({required String suggestion, String? imageUrl}) async {
    final docRef = await _firestore.collection('profiles').doc(_currentUserId).collection('ai_suggestions').add({
      'userId': _currentUserId,
      'suggestion': suggestion,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'isFavorite': false,
    });

    final doc = await docRef.get();
    return StyleSuggestionEntity.fromMap(doc.data()!, doc.id);
  }

  /// Stream de sugestões salvas
  Stream<List<StyleSuggestionEntity>> watchSuggestions() {
    return _firestore
        .collection('profiles')
        .doc(_currentUserId)
        .collection('ai_suggestions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return StyleSuggestionEntity.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  /// Toggle favorite em sugestão
  Future<void> toggleSuggestionFavorite(String suggestionId, bool isFavorite) async {
    await _firestore.collection('profiles').doc(_currentUserId).collection('ai_suggestions').doc(suggestionId).update({
      'isFavorite': isFavorite,
    });
  }

  /// Deleta sugestão
  Future<void> deleteSuggestion(String suggestionId) async {
    await _firestore.collection('profiles').doc(_currentUserId).collection('ai_suggestions').doc(suggestionId).delete();
  }

  // ========== IMAGE UPLOAD ==========

  /// Upload de imagem para análise
  Future<String> uploadImage(File imageFile) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('ai_uploads/$_currentUserId/$fileName');

    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
