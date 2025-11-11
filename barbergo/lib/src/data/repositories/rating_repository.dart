import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/rating_entity.dart';
import '../services/firestore_service.dart';

part 'rating_repository.g.dart';

@riverpod
RatingRepository ratingRepository(RatingRepositoryRef ref) {
  return RatingRepository(ref.watch(firestoreServiceProvider));
}

class RatingRepository {
  final FirestoreService _service;

  RatingRepository(this._service);

  static const String ratingsPath = 'ratings';

  /// Criar nova avaliação
  Future<void> createRating({
    required String fromUserId,
    required String toUserId,
    required int stars,
    String comment = '',
  }) async {
    // Validar estrelas
    if (stars < 1 || stars > 5) {
      throw ArgumentError('Stars must be between 1 and 5');
    }

    // Verificar se já avaliou
    final existingRating = await hasUserRatedTarget(fromUserId, toUserId);
    if (existingRating) {
      throw Exception('Você já avaliou este usuário');
    }

    final rating = RatingEntity(
      ratingId: '',
      fromUserId: fromUserId,
      toUserId: toUserId,
      stars: stars,
      comment: comment.trim(),
      createdAt: DateTime.now(),
    );

    await _service.db.collection(ratingsPath).add(rating.toFirestore());
  }

  /// Atualizar avaliação existente
  Future<void> updateRating({required String ratingId, required int stars, required String comment}) async {
    // Validar estrelas
    if (stars < 1 || stars > 5) {
      throw ArgumentError('Stars must be between 1 and 5');
    }

    await _service.db.collection(ratingsPath).doc(ratingId).update({'stars': stars, 'comment': comment.trim()});
  }

  /// Deletar avaliação
  Future<void> deleteRating(String ratingId) async {
    await _service.db.collection(ratingsPath).doc(ratingId).delete();
  }

  /// Buscar avaliação específica de um usuário para outro
  Future<RatingEntity?> getRating(String fromUserId, String toUserId) async {
    final snapshot = await _service.db
        .collection(ratingsPath)
        .where('fromUserId', isEqualTo: fromUserId)
        .where('toUserId', isEqualTo: toUserId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return RatingEntity.fromFirestore(snapshot.docs.first);
  }

  /// Buscar todas as avaliações recebidas por um usuário
  Future<List<RatingEntity>> getRatingsForUser(String toUserId) async {
    final snapshot = await _service.db
        .collection(ratingsPath)
        .where('toUserId', isEqualTo: toUserId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => RatingEntity.fromFirestore(doc)).toList();
  }

  /// Buscar avaliações com paginação
  Future<List<RatingEntity>> getRatingsForUserPaginated({
    required String toUserId,
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = _service.db
        .collection(ratingsPath)
        .where('toUserId', isEqualTo: toUserId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) => RatingEntity.fromFirestore(doc)).toList();
  }

  /// Calcular média de avaliações de um usuário
  Future<double> getAverageRating(String toUserId) async {
    final ratings = await getRatingsForUser(toUserId);

    if (ratings.isEmpty) return 0.0;

    final sum = ratings.fold<int>(0, (sum, rating) => sum + rating.stars);
    return sum / ratings.length;
  }

  /// Contar total de avaliações de um usuário
  Future<int> getRatingCount(String toUserId) async {
    final snapshot = await _service.db.collection(ratingsPath).where('toUserId', isEqualTo: toUserId).count().get();

    return snapshot.count ?? 0;
  }

  /// Buscar estatísticas completas de avaliações
  Future<RatingStats> getRatingStats(String toUserId) async {
    final ratings = await getRatingsForUser(toUserId);

    if (ratings.isEmpty) return RatingStats.empty();

    // Calcular distribuição de estrelas
    final distribution = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (final rating in ratings) {
      distribution[rating.stars] = (distribution[rating.stars] ?? 0) + 1;
    }

    // Calcular média
    final sum = ratings.fold<int>(0, (sum, rating) => sum + rating.stars);
    final average = sum / ratings.length;

    return RatingStats(averageStars: average, totalRatings: ratings.length, starsDistribution: distribution);
  }

  /// Verificar se usuário já avaliou outro usuário
  Future<bool> hasUserRatedTarget(String fromUserId, String toUserId) async {
    final snapshot = await _service.db
        .collection(ratingsPath)
        .where('fromUserId', isEqualTo: fromUserId)
        .where('toUserId', isEqualTo: toUserId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// Stream de avaliações recebidas por um usuário
  Stream<List<RatingEntity>> watchRatingsForUser(String toUserId) {
    return _service.db
        .collection(ratingsPath)
        .where('toUserId', isEqualTo: toUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => RatingEntity.fromFirestore(doc)).toList());
  }

  /// Stream de estatísticas de avaliações
  Stream<RatingStats> watchRatingStats(String toUserId) {
    return watchRatingsForUser(toUserId).map((ratings) {
      if (ratings.isEmpty) return RatingStats.empty();

      // Calcular distribuição
      final distribution = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

      for (final rating in ratings) {
        distribution[rating.stars] = (distribution[rating.stars] ?? 0) + 1;
      }

      // Calcular média
      final sum = ratings.fold<int>(0, (sum, rating) => sum + rating.stars);
      final average = sum / ratings.length;

      return RatingStats(averageStars: average, totalRatings: ratings.length, starsDistribution: distribution);
    });
  }

  /// Buscar avaliações feitas por um usuário (para mostrar histórico)
  Future<List<RatingEntity>> getRatingsByUser(String fromUserId) async {
    final snapshot = await _service.db
        .collection(ratingsPath)
        .where('fromUserId', isEqualTo: fromUserId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => RatingEntity.fromFirestore(doc)).toList();
  }

  /// Stream de avaliações feitas por um usuário
  Stream<List<RatingEntity>> watchRatingsByUser(String fromUserId) {
    return _service.db
        .collection(ratingsPath)
        .where('fromUserId', isEqualTo: fromUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => RatingEntity.fromFirestore(doc)).toList());
  }
}
