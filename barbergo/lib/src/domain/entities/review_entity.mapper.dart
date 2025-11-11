// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'review_entity.dart';

class ReviewEntityMapper extends ClassMapperBase<ReviewEntity> {
  ReviewEntityMapper._();

  static ReviewEntityMapper? _instance;
  static ReviewEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReviewEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ReviewEntity';

  static String _$reviewId(ReviewEntity v) => v.reviewId;
  static const Field<ReviewEntity, String> _f$reviewId = Field(
    'reviewId',
    _$reviewId,
  );
  static String _$reviewerId(ReviewEntity v) => v.reviewerId;
  static const Field<ReviewEntity, String> _f$reviewerId = Field(
    'reviewerId',
    _$reviewerId,
  );
  static String _$targetId(ReviewEntity v) => v.targetId;
  static const Field<ReviewEntity, String> _f$targetId = Field(
    'targetId',
    _$targetId,
  );
  static int _$rating(ReviewEntity v) => v.rating;
  static const Field<ReviewEntity, int> _f$rating = Field('rating', _$rating);
  static String? _$comment(ReviewEntity v) => v.comment;
  static const Field<ReviewEntity, String> _f$comment = Field(
    'comment',
    _$comment,
    opt: true,
  );
  static DateTime _$createdAt(ReviewEntity v) => v.createdAt;
  static const Field<ReviewEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );

  @override
  final MappableFields<ReviewEntity> fields = const {
    #reviewId: _f$reviewId,
    #reviewerId: _f$reviewerId,
    #targetId: _f$targetId,
    #rating: _f$rating,
    #comment: _f$comment,
    #createdAt: _f$createdAt,
  };

  static ReviewEntity _instantiate(DecodingData data) {
    return ReviewEntity(
      reviewId: data.dec(_f$reviewId),
      reviewerId: data.dec(_f$reviewerId),
      targetId: data.dec(_f$targetId),
      rating: data.dec(_f$rating),
      comment: data.dec(_f$comment),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ReviewEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReviewEntity>(map);
  }

  static ReviewEntity fromJson(String json) {
    return ensureInitialized().decodeJson<ReviewEntity>(json);
  }
}

mixin ReviewEntityMappable {
  String toJson() {
    return ReviewEntityMapper.ensureInitialized().encodeJson<ReviewEntity>(
      this as ReviewEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return ReviewEntityMapper.ensureInitialized().encodeMap<ReviewEntity>(
      this as ReviewEntity,
    );
  }

  ReviewEntityCopyWith<ReviewEntity, ReviewEntity, ReviewEntity> get copyWith =>
      _ReviewEntityCopyWithImpl<ReviewEntity, ReviewEntity>(
        this as ReviewEntity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ReviewEntityMapper.ensureInitialized().stringifyValue(
      this as ReviewEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReviewEntityMapper.ensureInitialized().equalsValue(
      this as ReviewEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return ReviewEntityMapper.ensureInitialized().hashValue(
      this as ReviewEntity,
    );
  }
}

extension ReviewEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReviewEntity, $Out> {
  ReviewEntityCopyWith<$R, ReviewEntity, $Out> get $asReviewEntity =>
      $base.as((v, t, t2) => _ReviewEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReviewEntityCopyWith<$R, $In extends ReviewEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? reviewId,
    String? reviewerId,
    String? targetId,
    int? rating,
    String? comment,
    DateTime? createdAt,
  });
  ReviewEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReviewEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReviewEntity, $Out>
    implements ReviewEntityCopyWith<$R, ReviewEntity, $Out> {
  _ReviewEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReviewEntity> $mapper =
      ReviewEntityMapper.ensureInitialized();
  @override
  $R call({
    String? reviewId,
    String? reviewerId,
    String? targetId,
    int? rating,
    Object? comment = $none,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (reviewId != null) #reviewId: reviewId,
      if (reviewerId != null) #reviewerId: reviewerId,
      if (targetId != null) #targetId: targetId,
      if (rating != null) #rating: rating,
      if (comment != $none) #comment: comment,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  ReviewEntity $make(CopyWithData data) => ReviewEntity(
    reviewId: data.get(#reviewId, or: $value.reviewId),
    reviewerId: data.get(#reviewerId, or: $value.reviewerId),
    targetId: data.get(#targetId, or: $value.targetId),
    rating: data.get(#rating, or: $value.rating),
    comment: data.get(#comment, or: $value.comment),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  ReviewEntityCopyWith<$R2, ReviewEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReviewEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

