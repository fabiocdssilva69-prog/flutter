import 'package:dart_mappable/dart_mappable.dart';

import 'package:barbergo_app/src/core/infrastructure/mappable_hooks.dart';

part 'review_entity.mapper.dart';

@MappableClass()
class ReviewEntity with ReviewEntityMappable {
  final String reviewId;
  final String reviewerId;
  final String targetId;
  final int rating;
  final String? comment;

  @MappableField(hook: TimestampHook())
  final DateTime createdAt;

  const ReviewEntity({
    required this.reviewId,
    required this.reviewerId,
    required this.targetId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  // Factory constructors para compatibilidade com repositórios
  static ReviewEntity fromMap(Map<String, dynamic> map) => ReviewEntityMapper.fromMap(map);

  static ReviewEntity fromJson(String json) => ReviewEntityMapper.fromJson(json);
}
