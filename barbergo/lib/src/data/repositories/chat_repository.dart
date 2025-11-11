import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/ai/chat_message.dart';
import '../datasources/firestore_service.dart';

part 'chat_repository.g.dart';

@riverpod
ChatRepository chatRepository(ref) {
  return ChatRepository(service: ref.watch(firestoreServiceProvider));
}

/// Repositório responsável pela persistência e paginação de mensagens de chat.
///
/// **Mudança Arquitetural (Sprint 10):**
/// - Antes: `watchMessages()` → Stream completo (sem paginação)
/// - Agora: `fetchInitialMessages()` + `fetchMoreMessages()` → Paginação baseada em cursor
///
/// **Estrutura Firestore:**
/// ```
/// users/{userId}/ai_chats/{personaKey}/messages/{messageId}
/// ```
class ChatRepository {
  final FirestoreService _service;
  ChatRepository({required FirestoreService service}) : _service = service;

  static const String usersPath = 'users';

  /// Tamanho padrão de página para paginação.
  ///
  /// **Justificativa:**
  /// - 30 mensagens = ~15 trocas usuário-IA
  /// - Suficiente para contexto sem overhead de rede
  /// - Permite scroll suave com pull-to-load-more
  static const int pageSize = 30;

  /// Retorna a referência da coleção de mensagens para um usuário e persona específicos.
  ///
  /// **Estrutura:** `users/{userId}/ai_chats/{personaKey}/messages`
  CollectionReference _getMessagesCollection(String userId, String personaKey) {
    return _service.db.collection(usersPath).doc(userId).collection('ai_chats').doc(personaKey).collection('messages');
  }

  /// Salva uma nova mensagem no Firestore.
  ///
  /// **Uso:**
  /// ```dart
  /// final userMessage = ChatMessage.user('Olá!');
  /// await repo.saveMessage(userId, 'business', userMessage);
  /// ```
  Future<void> saveMessage(String userId, String personaKey, ChatMessage message) async {
    final collection = _getMessagesCollection(userId, personaKey);
    await collection.doc(message.id).set(message.toMap());
  }

  /// Busca a primeira página de mensagens (mais recentes).
  ///
  /// **Ordem Firestore:** Descending (mais recente primeiro)
  /// **Ordem Retornada:** Ascending (mais antiga primeiro) → reversed
  ///
  /// **Exemplo:**
  /// ```dart
  /// final firstPage = await repo.fetchInitialMessages(userId, 'artistic');
  /// // firstPage.length <= 30 (pageSize)
  /// // firstPage[0] = mensagem mais antiga
  /// // firstPage[n] = mensagem mais recente
  /// ```
  Future<List<ChatMessage>> fetchInitialMessages(String userId, String personaKey) async {
    final collection = _getMessagesCollection(userId, personaKey);

    // Query: Ordena por timestamp (desc) e limita ao pageSize
    final query = collection.orderBy('timestamp', descending: true).limit(pageSize);

    final snapshot = await query.get();

    // Mapeia documentos para ChatMessage e inverte ordem (antiga → recente)
    return snapshot.docs
        .map((doc) => ChatMessage.fromMap(doc.data() as Map<String, dynamic>))
        .toList()
        .reversed
        .toList();
  }

  /// Busca as próximas páginas de mensagens usando cursor (Timestamp).
  ///
  /// **Parâmetros:**
  /// - `startAfterTimestamp`: Timestamp da mensagem mais antiga já carregada
  ///
  /// **Exemplo:**
  /// ```dart
  /// // Estado atual: messages = [msg1, msg2, ..., msg30]
  /// final oldestMessage = messages.first; // msg1
  ///
  /// // Carrega página anterior (mensagens mais antigas que msg1)
  /// final olderMessages = await repo.fetchMoreMessages(
  ///   userId,
  ///   'writing',
  ///   oldestMessage.timestamp, // Cursor
  /// );
  ///
  /// // Combina: [...olderMessages, ...messages]
  /// ```
  Future<List<ChatMessage>> fetchMoreMessages(String userId, String personaKey, DateTime startAfterTimestamp) async {
    final collection = _getMessagesCollection(userId, personaKey);

    // Query: Começa DEPOIS do cursor e limita ao pageSize
    final query = collection
        .orderBy('timestamp', descending: true)
        .startAfter([Timestamp.fromDate(startAfterTimestamp)])
        .limit(pageSize);

    final snapshot = await query.get();

    // Mapeia e inverte ordem
    return snapshot.docs
        .map((doc) => ChatMessage.fromMap(doc.data() as Map<String, dynamic>))
        .toList()
        .reversed
        .toList();
  }

  /// Atualiza o feedback de uma mensagem específica.
  ///
  /// **Uso:**
  /// ```dart
  /// // Usuário clica em "Thumbs Up" na resposta da IA
  /// await repo.updateMessageFeedback(
  ///   userId,
  ///   'business',
  ///   aiMessage.id,
  ///   MessageFeedback.thumbsUp,
  /// );
  /// ```
  ///
  /// **Firestore:** Atualiza apenas o campo `feedback` (partial update)
  Future<void> updateMessageFeedback(
    String userId,
    String personaKey,
    String messageId,
    MessageFeedback feedback,
  ) async {
    final docRef = _getMessagesCollection(userId, personaKey).doc(messageId);

    // Update parcial: apenas o campo 'feedback'
    await docRef.update({'feedback': feedback.name});
  }

  /// Limpa todo o histórico de mensagens do chat usando WriteBatch.
  ///
  /// **⚠️ Performance Warning:**
  /// - Para históricos grandes (>500 mensagens), considerar Cloud Function
  /// - WriteBatch tem limite de 500 operações por batch
  ///
  /// **Uso:**
  /// ```dart
  /// // Botão "Clear History"
  /// await repo.clearChatHistory(userId, 'artistic');
  /// ```
  Future<void> clearChatHistory(String userId, String personaKey) async {
    final collection = _getMessagesCollection(userId, personaKey);
    final snapshot = await collection.get();

    final batch = _service.db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
