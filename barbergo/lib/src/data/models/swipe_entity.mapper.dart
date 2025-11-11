// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'swipe_entity.dart';

class SwipeEntityMapper extends ClassMapperBase<SwipeEntity> {
  SwipeEntityMapper._();

  static SwipeEntityMapper? _instance;
  static SwipeEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SwipeEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SwipeEntity';

  static String _$swipeId(SwipeEntity v) => v.swipeId;
  static const Field<SwipeEntity, String> _f$swipeId = Field(
    'swipeId',
    _$swipeId,
  );
  static String _$fromUserId(SwipeEntity v) => v.fromUserId;
  static const Field<SwipeEntity, String> _f$fromUserId = Field(
    'fromUserId',
    _$fromUserId,
  );
  static String _$toUserId(SwipeEntity v) => v.toUserId;
  static const Field<SwipeEntity, String> _f$toUserId = Field(
    'toUserId',
    _$toUserId,
  );
  static bool _$liked(SwipeEntity v) => v.liked;
  static const Field<SwipeEntity, bool> _f$liked = Field('liked', _$liked);
  static bool _$isSuperLike(SwipeEntity v) => v.isSuperLike;
  static const Field<SwipeEntity, bool> _f$isSuperLike = Field(
    'isSuperLike',
    _$isSuperLike,
    opt: true,
    def: false,
  );
  static String? _$comment(SwipeEntity v) => v.comment;
  static const Field<SwipeEntity, String> _f$comment = Field(
    'comment',
    _$comment,
    opt: true,
  );
  static String? _$promptResponseId(SwipeEntity v) => v.promptResponseId;
  static const Field<SwipeEntity, String> _f$promptResponseId = Field(
    'promptResponseId',
    _$promptResponseId,
    opt: true,
  );
  static DateTime _$createdAt(SwipeEntity v) => v.createdAt;
  static const Field<SwipeEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );

  @override
  final MappableFields<SwipeEntity> fields = const {
    #swipeId: _f$swipeId,
    #fromUserId: _f$fromUserId,
    #toUserId: _f$toUserId,
    #liked: _f$liked,
    #isSuperLike: _f$isSuperLike,
    #comment: _f$comment,
    #promptResponseId: _f$promptResponseId,
    #createdAt: _f$createdAt,
  };

  static SwipeEntity _instantiate(DecodingData data) {
    return SwipeEntity(
      swipeId: data.dec(_f$swipeId),
      fromUserId: data.dec(_f$fromUserId),
      toUserId: data.dec(_f$toUserId),
      liked: data.dec(_f$liked),
      isSuperLike: data.dec(_f$isSuperLike),
      comment: data.dec(_f$comment),
      promptResponseId: data.dec(_f$promptResponseId),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SwipeEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SwipeEntity>(map);
  }

  static SwipeEntity fromJson(String json) {
    return ensureInitialized().decodeJson<SwipeEntity>(json);
  }
}

mixin SwipeEntityMappable {
  String toJson() {
    return SwipeEntityMapper.ensureInitialized().encodeJson<SwipeEntity>(
      this as SwipeEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return SwipeEntityMapper.ensureInitialized().encodeMap<SwipeEntity>(
      this as SwipeEntity,
    );
  }

  SwipeEntityCopyWith<SwipeEntity, SwipeEntity, SwipeEntity> get copyWith =>
      _SwipeEntityCopyWithImpl<SwipeEntity, SwipeEntity>(
        this as SwipeEntity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SwipeEntityMapper.ensureInitialized().stringifyValue(
      this as SwipeEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return SwipeEntityMapper.ensureInitialized().equalsValue(
      this as SwipeEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return SwipeEntityMapper.ensureInitialized().hashValue(this as SwipeEntity);
  }
}

extension SwipeEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SwipeEntity, $Out> {
  SwipeEntityCopyWith<$R, SwipeEntity, $Out> get $asSwipeEntity =>
      $base.as((v, t, t2) => _SwipeEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SwipeEntityCopyWith<$R, $In extends SwipeEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? swipeId,
    String? fromUserId,
    String? toUserId,
    bool? liked,
    bool? isSuperLike,
    String? comment,
    String? promptResponseId,
    DateTime? createdAt,
  });
  SwipeEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SwipeEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SwipeEntity, $Out>
    implements SwipeEntityCopyWith<$R, SwipeEntity, $Out> {
  _SwipeEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SwipeEntity> $mapper =
      SwipeEntityMapper.ensureInitialized();
  @override
  $R call({
    String? swipeId,
    String? fromUserId,
    String? toUserId,
    bool? liked,
    bool? isSuperLike,
    Object? comment = $none,
    Object? promptResponseId = $none,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (swipeId != null) #swipeId: swipeId,
      if (fromUserId != null) #fromUserId: fromUserId,
      if (toUserId != null) #toUserId: toUserId,
      if (liked != null) #liked: liked,
      if (isSuperLike != null) #isSuperLike: isSuperLike,
      if (comment != $none) #comment: comment,
      if (promptResponseId != $none) #promptResponseId: promptResponseId,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  SwipeEntity $make(CopyWithData data) => SwipeEntity(
    swipeId: data.get(#swipeId, or: $value.swipeId),
    fromUserId: data.get(#fromUserId, or: $value.fromUserId),
    toUserId: data.get(#toUserId, or: $value.toUserId),
    liked: data.get(#liked, or: $value.liked),
    isSuperLike: data.get(#isSuperLike, or: $value.isSuperLike),
    comment: data.get(#comment, or: $value.comment),
    promptResponseId: data.get(#promptResponseId, or: $value.promptResponseId),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  SwipeEntityCopyWith<$R2, SwipeEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SwipeEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

