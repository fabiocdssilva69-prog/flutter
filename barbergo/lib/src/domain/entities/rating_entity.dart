import 'package:cloud_firestore/cloud_firestore.dart';

/// Entidade de avaliação (rating/review)
/// Um usuário avalia outro após match ou serviço prestado
class RatingEntity {
  final String ratingId;
  final String fromUserId; // Quem avaliou
  final String toUserId; // Quem foi avaliado
  final int stars; // 1 a 5 estrelas
  final String comment; // Comentário opcional
  final DateTime createdAt;

  const RatingEntity({
    required this.ratingId,
    required this.fromUserId,
    required this.toUserId,
    required this.stars,
    required this.comment,
    required this.createdAt,
  });

  /// Criar RatingEntity a partir do Firestore
  factory RatingEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RatingEntity(
      ratingId: doc.id,
      fromUserId: data['fromUserId'] ?? '',
      toUserId: data['toUserId'] ?? '',
      stars: data['stars'] ?? 0,
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converter para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'stars': stars,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Criar cópia com modificações
  RatingEntity copyWith({
    String? ratingId,
    String? fromUserId,
    String? toUserId,
    int? stars,
    String? comment,
    DateTime? createdAt,
  }) {
    return RatingEntity(
      ratingId: ratingId ?? this.ratingId,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Validar se as estrelas estão no range correto
  bool get isValid => stars >= 1 && stars <= 5;
}

/// Estatísticas de avaliação de um usuário
class RatingStats {
  final double averageStars;
  final int totalRatings;
  final Map<int, int> starsDistribution; // {5: 10, 4: 5, 3: 2, 2: 1, 1: 0}

  const RatingStats({required this.averageStars, required this.totalRatings, required this.starsDistribution});

  /// Criar stats vazios
  factory RatingStats.empty() {
    return const RatingStats(averageStars: 0.0, totalRatings: 0, starsDistribution: {});
  }

  /// Calcular porcentagem de cada estrela
  double getPercentage(int stars) {
    if (totalRatings == 0) return 0.0;
    final count = starsDistribution[stars] ?? 0;
    return (count / totalRatings) * 100;
  }

  /// Verificar se tem avaliações
  bool get hasRatings => totalRatings > 0;

  /// Arredondar média para exibição (1 casa decimal)
  String get averageDisplay => averageStars.toStringAsFixed(1);
}
