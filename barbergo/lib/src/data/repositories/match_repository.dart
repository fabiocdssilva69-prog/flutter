import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../datasources/firestore_service.dart';
import '../models/match_entity.dart';

part 'match_repository.g.dart';

@riverpod
MatchRepository matchRepository(Ref ref) {
  return MatchRepository(ref.watch(firestoreServiceProvider));
}

class MatchRepository {
  final FirestoreService _service;
  static const String matchesPath = 'matches';

  MatchRepository(this._service);

  /// Criar um match
  Future<String> createMatch({required String user1, required String user2}) async {
    final match = MatchEntity(
      matchId: '',
      userIds: [user1, user2],
      user1: user1,
      user2: user2,
      createdAt: DateTime.now(),
      lastMessageAt: null,
      unreadCount: {user1: 0, user2: 0},
    );

    final doc = await _service.db.collection(matchesPath).add(match.toFirestore());
    return doc.id;
  }

  /// Verificar se existe match entre dois usuários
  Future<MatchEntity?> getMatch(String user1, String user2) async {
    final query = await _service.db.collection(matchesPath).where('userIds', arrayContains: user1).get();

    final matches = query.docs
        .map((doc) => MatchEntity.fromFirestore(doc))
        .where((match) => match.userIds.contains(user2))
        .toList();

    return matches.isNotEmpty ? matches.first : null;
  }

  /// Listar todos os matches do usuário
  Stream<List<MatchEntity>> watchUserMatches(String userId) {
    return _service.db
        .collection(matchesPath)
        .where('userIds', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => MatchEntity.fromFirestore(doc)).toList();
        });
  }

  /// Atualizar última mensagem do match
  Future<void> updateLastMessage(String matchId, String message) async {
    await _service.db.collection(matchesPath).doc(matchId).update({
      'lastMessage': message,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }

  /// Incrementar contador de não lidas
  Future<void> incrementUnreadCount(String matchId, String userId) async {
    await _service.db.collection(matchesPath).doc(matchId).update({'unreadCount.$userId': FieldValue.increment(1)});
  }

  /// Resetar contador de não lidas
  Future<void> resetUnreadCount(String matchId, String userId) async {
    await _service.db.collection(matchesPath).doc(matchId).update({'unreadCount.$userId': 0});
  }

  /// Deletar match (usado pelo anti-ghosting quando timer expira)
  Future<void> deleteMatch(String matchId) async {
    await _service.db.collection(matchesPath).doc(matchId).delete();
  }
}
