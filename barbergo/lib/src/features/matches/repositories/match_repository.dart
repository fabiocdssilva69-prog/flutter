import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/match_entity.dart';

class MatchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser!.uid;

  // Stream de todos os matches do usuário atual
  Stream<List<MatchEntity>> watchUserMatches() {
    return _firestore
        .collection('matches')
        .where('userIds', arrayContains: _currentUserId)
        .where('isActive', isEqualTo: true)
        .orderBy('lastInteractionAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return MatchEntity.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // Buscar match específico entre dois usuários
  Future<MatchEntity?> getMatch(String otherUserId) async {
    final snapshot = await _firestore
        .collection('matches')
        .where('userIds', arrayContains: _currentUserId)
        .where('isActive', isEqualTo: true)
        .get();

    for (var doc in snapshot.docs) {
      final match = MatchEntity.fromMap(doc.data(), doc.id);
      if (match.userIds.contains(otherUserId)) {
        return match;
      }
    }

    return null;
  }

  // Criar match (normalmente chamado por Cloud Function)
  Future<MatchEntity> createMatch(String otherUserId) async {
    final matchData = {
      'userIds': [_currentUserId, otherUserId],
      'createdAt': FieldValue.serverTimestamp(),
      'lastInteractionAt': FieldValue.serverTimestamp(),
      'isActive': true,
    };

    final docRef = await _firestore.collection('matches').add(matchData);
    final doc = await docRef.get();

    return MatchEntity.fromMap(doc.data()!, doc.id);
  }

  // Atualizar última interação (chamado quando envia mensagem)
  Future<void> updateLastInteraction(String matchId) async {
    await _firestore.collection('matches').doc(matchId).update({'lastInteractionAt': FieldValue.serverTimestamp()});
  }

  // Unmatch (desativar match)
  Future<void> unmatch(String matchId) async {
    await _firestore.collection('matches').doc(matchId).update({
      'isActive': false,
      'unmatchedAt': FieldValue.serverTimestamp(),
      'unmatchedBy': _currentUserId,
    });
  }

  // Block user
  Future<void> blockUser(String userId) async {
    await _firestore.collection('profiles').doc(_currentUserId).collection('blocked').doc(userId).set({
      'blockedAt': FieldValue.serverTimestamp(),
    });

    // Desativar match existente
    final match = await getMatch(userId);
    if (match != null) {
      await unmatch(match.id);
    }
  }

  // Report user
  Future<void> reportUser({required String userId, required String reason, String? details}) async {
    await _firestore.collection('reports').add({
      'reportedBy': _currentUserId,
      'reportedUser': userId,
      'reason': reason,
      'details': details,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }

  // Verificar se usuário está bloqueado
  Future<bool> isUserBlocked(String userId) async {
    final doc = await _firestore.collection('profiles').doc(_currentUserId).collection('blocked').doc(userId).get();

    return doc.exists;
  }

  // Contar matches ativos
  Future<int> getMatchesCount() async {
    final snapshot = await _firestore
        .collection('matches')
        .where('userIds', arrayContains: _currentUserId)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.length;
  }
}
