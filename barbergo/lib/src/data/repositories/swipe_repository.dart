import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../datasources/firestore_service.dart';
import '../models/swipe_entity.dart';

part 'swipe_repository.g.dart';

@riverpod
SwipeRepository swipeRepository(Ref ref) {
  return SwipeRepository(ref.watch(firestoreServiceProvider));
}

class SwipeRepository {
  final FirestoreService _service;
  static const String swipesPath = 'swipes';

  SwipeRepository(this._service);

  /// Criar um swipe (like ou dislike)
  Future<void> createSwipe({
    required String fromUserId,
    required String toUserId,
    required bool liked,
    bool isSuperLike = false, // NOVO - Phase 11: Support for Super Likes
    String? comment, // NOVO - Phase 1: Comentário opcional
    String? promptResponseId, // NOVO - Phase 1: ID do prompt comentado
  }) async {
    final swipe = SwipeEntity(
      swipeId: '',
      fromUserId: fromUserId,
      toUserId: toUserId,
      liked: liked,
      isSuperLike: isSuperLike, // NOVO - Phase 11
      comment: comment, // NOVO - Phase 1
      promptResponseId: promptResponseId, // NOVO - Phase 1
      createdAt: DateTime.now(),
    );

    await _service.db.collection(swipesPath).add(swipe.toFirestore());
  }

  /// Verificar se já existe swipe de A para B
  Future<SwipeEntity?> getSwipe(String fromUserId, String toUserId) async {
    final query = await _service.db
        .collection(swipesPath)
        .where('fromUserId', isEqualTo: fromUserId)
        .where('toUserId', isEqualTo: toUserId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return SwipeEntity.fromFirestore(query.docs.first);
  }

  /// Verificar se existe swipe reverso (B deu like em A)
  Future<bool> hasReverseSwipe(String fromUserId, String toUserId) async {
    final query = await _service.db
        .collection(swipesPath)
        .where('fromUserId', isEqualTo: toUserId)
        .where('toUserId', isEqualTo: fromUserId)
        .where('liked', isEqualTo: true)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  /// Listar todos os swipes que o usuário deu
  Stream<List<SwipeEntity>> watchUserSwipes(String userId) {
    return _service.db
        .collection(swipesPath)
        .where('fromUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => SwipeEntity.fromFirestore(doc)).toList();
        });
  }

  /// NOVO - Phase 11: Listar quem deu LIKE no usuário (para "Ver Quem Curtiu")
  /// Retorna stream de SwipeEntity onde toUserId == userId e liked == true
  Stream<List<SwipeEntity>> watchLikesReceived(String userId) {
    return _service.db
        .collection(swipesPath)
        .where('toUserId', isEqualTo: userId)
        .where('liked', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => SwipeEntity.fromFirestore(doc)).toList();
        });
  }

  /// NOVO - Phase 11: Contar quantos likes o usuário recebeu
  Future<int> countLikesReceived(String userId) async {
    final snapshot = await _service.db
        .collection(swipesPath)
        .where('toUserId', isEqualTo: userId)
        .where('liked', isEqualTo: true)
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// NOVO - Phase 11: Listar Super Likes recebidos (priority)
  Stream<List<SwipeEntity>> watchSuperLikesReceived(String userId) {
    return _service.db
        .collection(swipesPath)
        .where('toUserId', isEqualTo: userId)
        .where('isSuperLike', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => SwipeEntity.fromFirestore(doc)).toList();
        });
  }

  /// NOVO - Get swipes received by user (query única para WhoLikedMeScreen)
  Future<List<SwipeEntity>> getSwipesReceivedByUser(String userId) async {
    final snapshot = await _service.db
        .collection(swipesPath)
        .where('toUserId', isEqualTo: userId)
        .where('liked', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => SwipeEntity.fromFirestore(doc)).toList();
  }
}
