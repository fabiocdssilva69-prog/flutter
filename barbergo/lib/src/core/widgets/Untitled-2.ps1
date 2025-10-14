import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/ai/chat_message.dart';
import '../datasources/firestore_service.dart';

part 'chat_repository.g.dart';

/// Provedor do ChatRepository
/// 
/// Gerencia persistência de conversas de chat com IA no Firestore
@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(service: ref.watch(firestoreServiceProvider));
}

/// Repository para gerenciar históricos de chat com IA no Firestore
/// 
/// Estrutura de dados escalável:
/// ```
/// users/{userId}/ai_chats/{personaKey}/messages/{messageId}
/// users/{userId}/ai_chats/{personaKey}/metadata (documento único)
/// ```
/// 
/// Vantagens desta estrutura:
/// - ✅ Chats isolados por usuário e persona
/// - ✅ Subcoleções permitem queries eficientes
/// - ✅ Fácil implementar paginação futuramente
/// - ✅ Metadados separados (última mensagem, contagem, etc)
/// - ✅ Suporta múltiplas conversas simultâneas
/// 
/// Exemplo de uso:
/// ```dart
/// final repo = ref.read(chatRepositoryProvider);
/// 
/// // Salvar mensagem
/// await repo.saveMessage('user123', 'business', message);
/// 
/// // Observar histórico
/// final stream = repo.watchMessages('user123', 'business');
/// ```
class ChatRepository {
  final FirestoreService _service;

  ChatRepository({required FirestoreService service}) : _service = service;

  static const String usersPath = 'users';

  /// Retorna a coleção de mensagens para um usuário/persona específico
  /// 
  /// Estrutura: users/{userId}/ai_chats/{personaKey}/messages
  CollectionReference _getMessagesCollection(String userId, String personaKey) {
    return _service.db
        .collection(usersPath)
        .doc(userId)
        .collection('ai_chats') // Subcoleção para chats de IA
        .doc(personaKey)
        .collection('messages');
  }

  /// Retorna o documento de metadados do chat
  /// 
  /// Estrutura: users/{userId}/ai_chats/{personaKey}
  DocumentReference _getChatMetadataDoc(String userId, String personaKey) {
    return _service.db
        .collection(usersPath)
        .doc(userId)
        .collection('ai_chats')
        .doc(personaKey);
  }

  /// Salva uma nova mensagem no histórico
  /// 
  /// Usa o message.id como ID do documento para garantir idempotência.
  /// Também atualiza os metadados do chat.
  Future<void> saveMessage(
    String userId,
    String personaKey,
    ChatMessage message,
  ) async {
    final batch = _service.db.batch();

    // 1. Salvar mensagem
    final messageRef = _getMessagesCollection(userId, personaKey)
        .doc(message.id);
    batch.set(messageRef, message.toJson());

    // 2. Atualizar metadados do chat
    final metadataRef = _getChatMetadataDoc(userId, personaKey);
    batch.set(
      metadataRef,
      {
        'lastMessageAt': message.timestamp,
        'lastMessageContent': message.content.substring(
          0,
          message.content.length > 100 ? 100 : message.content.length,
        ),
        'messageCount': FieldValue.increment(1),
        'personaKey': personaKey,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // 3. Executar batch atomicamente
    await batch.commit();
  }

  /// Salva múltiplas mensagens de uma vez (otimização)
  /// 
  /// Útil para sincronizar histórico após geração offline
  Future<void> saveMessages(
    String userId,
    String personaKey,
    List<ChatMessage> messages,
  ) async {
    if (messages.isEmpty) return;

    final batch = _service.db.batch();

    // Salvar todas as mensagens
    for (final message in messages) {
      final messageRef = _getMessagesCollection(userId, personaKey)
          .doc(message.id);
      batch.set(messageRef, message.toJson());
    }

    // Atualizar metadados com última mensagem
    final lastMessage = messages.last;
    final metadataRef = _getChatMetadataDoc(userId, personaKey);
    batch.set(
      metadataRef,
      {
        'lastMessageAt': lastMessage.timestamp,
        'lastMessageContent': lastMessage.content.substring(
          0,
          lastMessage.content.length > 100 ? 100 : lastMessage.content.length,
        ),
        'messageCount': FieldValue.increment(messages.length),
        'personaKey': personaKey,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  /// Observa o stream de mensagens ordenado por timestamp
  /// 
  /// Retorna todas as mensagens em ordem cronológica (mais antigas primeiro).
  /// Ideal para exibir histórico completo do chat.
  Stream<List<ChatMessage>> watchMessages(String userId, String personaKey) {
    final collection = _getMessagesCollection(userId, personaKey);
    
    // Ordenação crucial para o chat (ascendente)
    final query = collection.orderBy('timestamp', descending: false);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChatMessage.fromJson(data);
      }).toList();
    });
  }

  /// Observa apenas as últimas N mensagens
  /// 
  /// Útil para paginação ou limitar histórico exibido inicialmente
  Stream<List<ChatMessage>> watchRecentMessages(
    String userId,
    String personaKey, {
    int limit = 50,
  }) {
    final collection = _getMessagesCollection(userId, personaKey);
    
    // Busca as últimas N mensagens (ordem descendente) e depois inverte
    final query = collection
        .orderBy('timestamp', descending: true)
        .limit(limit);

    return query.snapshots().map((snapshot) {
      final messages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChatMessage.fromJson(data);
      }).toList();
      
      // Inverte para ordem cronológica
      return messages.reversed.toList();
    });
  }

  /// Deleta uma mensagem específica
  Future<void> deleteMessage(
    String userId,
    String personaKey,
    String messageId,
  ) async {
    final messageRef = _getMessagesCollection(userId, personaKey)
        .doc(messageId);
    
    await messageRef.delete();

    // Atualizar contagem nos metadados
    final metadataRef = _getChatMetadataDoc(userId, personaKey);
    await metadataRef.update({
      'messageCount': FieldValue.increment(-1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Limpa todo o histórico de um chat específico
  /// 
  /// ⚠️ Operação destrutiva! Use com cuidado.
  Future<void> clearChatHistory(String userId, String personaKey) async {
    final collection = _getMessagesCollection(userId, personaKey);
    
    // Buscar todos os documentos
    final snapshot = await collection.get();
    
    // Deletar em batch
    final batch = _service.db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    
    // Resetar metadados
    final metadataRef = _getChatMetadataDoc(userId, personaKey);
    batch.set(
      metadataRef,
      {
        'messageCount': 0,
        'lastMessageAt': null,
        'lastMessageContent': null,
        'clearedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    
    await batch.commit();
  }

  /// Obtém metadados de um chat (última mensagem, contagem, etc)
  Future<Map<String, dynamic>?> getChatMetadata(
    String userId,
    String personaKey,
  ) async {
    final doc = await _getChatMetadataDoc(userId, personaKey).get();
    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }

  /// Lista todas as conversas (personas) de um usuário
  /// 
  /// Útil para mostrar histórico de chats na UI
  Stream<List<Map<String, dynamic>>> watchUserChats(String userId) {
    return _service.db
        .collection(usersPath)
        .doc(userId)
        .collection('ai_chats')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'personaKey': doc.id,
                ...doc.data(),
              })
          .toList();
    });
  }

  /// Exporta histórico completo como JSON
  /// 
  /// Útil para backup ou migração de dados
  Future<List<Map<String, dynamic>>> exportChatHistory(
    String userId,
    String personaKey,
  ) async {
    final collection = _getMessagesCollection(userId, personaKey);
    final snapshot = await collection
        .orderBy('timestamp', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}