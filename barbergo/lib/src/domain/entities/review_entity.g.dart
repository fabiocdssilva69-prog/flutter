// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewEntity _$ReviewEntityFromJson(Map<String, dynamic> json) =>
    _ReviewEntity(
      reviewId: json['reviewId'] as String,
      reviewerId: json['reviewerId'] as String,
      targetId: json['targetId'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: const DateTimeTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$ReviewEntityToJson(_ReviewEntity instance) =>
    <String, dynamic>{
      'reviewId': instance.reviewId,
      'reviewerId': instance.reviewerId,
      'targetId': instance.targetId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
    };
