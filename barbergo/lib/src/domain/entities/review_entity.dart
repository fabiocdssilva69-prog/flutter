import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'review_entity.freezed.dart';
part 'review_entity.g.dart';

@freezed
class ReviewEntity with _$ReviewEntity {
  const factory ReviewEntity({
    required String reviewId,
    required String reviewerId,
    required String targetId,
    required int rating,
    String? comment,
    @TimestampConverter() required DateTime createdAt,
  }) = _ReviewEntity;

  factory ReviewEntity.fromJson(Map<String, dynamic> json) => _$ReviewEntityFromJson(json);
}
