import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/firestore_service.dart';
import '../../domain/entities/chat/chat_room_entity.dart';
import '../../domain/entities/chat/direct_message_entity.dart';

part 'chat_room_repository.g.dart';

@riverpod
ChatRoomRepository chatRoomRepository(Ref ref) {
  return ChatRoomRepository(service: ref.watch(firestoreServiceProvider));
}

class ChatRoomRepository {
  final FirestoreService _service;
  ChatRoomRepository({required FirestoreService service}) : _service = service;

  static const String roomsPath = 'chat_rooms';
  static const String messagesSubPath = 'messages';
  static const int pageSize = 30;

  // Cria uma nova sala de chat
  Future<String> createRoom(ChatRoomEntity room) async {
    final docRef = _service.db.collection(roomsPath).doc(room.roomId);
    // Usamos merge: true para garantir idempotência.
    await docRef.set(room.toMap(), SetOptions(merge: true));
    return docRef.id;
  }

  // Observa as salas de chat do usuário (Inbox)
  Stream<List<ChatRoomEntity>> watchMyRooms(String userId) {
    // Query eficiente: busca salas onde o userId está na lista 'participantIds'.
    final query = _service.db
        .collection(roomsPath)
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true);

    return query.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        return ChatRoomEntity.fromMap(doc.data());
      }).toList(),
    );
  }

  // === PAGINAÇÃO DE MENSAGENS ===
  CollectionReference _getMessagesCollection(String roomId) {
    return _service.db.collection(roomsPath).doc(roomId).collection(messagesSubPath);
  }

  // Busca a primeira página
  Future<List<DirectMessageEntity>> fetchInitialMessages(String roomId) async {
    final query = _getMessagesCollection(roomId).orderBy('timestamp', descending: true).limit(pageSize);

    final snapshot = await query.get();
    // Reverte a ordem para exibição correta no chat (mais antigo no topo)
    return snapshot.docs
        .map((doc) => DirectMessageEntity.fromMap(doc.data() as Map<String, dynamic>))
        .toList()
        .reversed
        .toList();
  }

  // Busca as próximas páginas (Cursor-based)
  Future<List<DirectMessageEntity>> fetchMoreMessages(String roomId, DateTime startAfterTimestamp) async {
    final query = _getMessagesCollection(
      roomId,
    ).orderBy('timestamp', descending: true).startAfter([Timestamp.fromDate(startAfterTimestamp)]).limit(pageSize);

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => DirectMessageEntity.fromMap(doc.data() as Map<String, dynamic>))
        .toList()
        .reversed
        .toList();
  }

  // Envia uma mensagem e atualiza os metadados da sala (Usando WriteBatch para Atomicidade)
  Future<void> sendMessage(String roomId, DirectMessageEntity message, List<String> allParticipantIds) async {
    final roomRef = _service.db.collection(roomsPath).doc(roomId);
    final messageRef = roomRef.collection(messagesSubPath).doc(message.messageId);
    final batch = _service.db.batch();

    // 1. Salva a mensagem na subcoleção (Garantimos isSent: true ao salvar)
    batch.set(messageRef, message.copyWith(isSent: true).toMap());

    // 2. Atualiza os metadados da sala
    Map<String, dynamic> roomUpdates = {
      'lastMessage': message.content,
      'lastMessageTimestamp': Timestamp.fromDate(message.timestamp),
    };

    // 3. Atualiza contadores de não lidas (Usando FieldValue.increment para atomicidade)
    for (final uid in allParticipantIds) {
      if (uid != message.senderId) {
        // Incrementa para os outros participantes
        roomUpdates['unreadCounts.$uid'] = FieldValue.increment(1);
      }
      // Nota: Não resetamos para o remetente aqui, pois ele pode estar enviando de outro dispositivo.
      // O reset ocorre quando ele abre a sala (markAsRead).
    }

    batch.update(roomRef, roomUpdates);

    await batch.commit();
  }

  // Marca o canal como lido para um usuário específico (Reseta o contador)
  Future<void> markAsRead(String roomId, String userId) async {
    final roomRef = _service.db.collection(roomsPath).doc(roomId);
    // Atualização atômica para resetar o contador específico do usuário.
    await roomRef.update({'unreadCounts.$userId': 0});
  }
}
