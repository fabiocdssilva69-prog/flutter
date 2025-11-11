// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_interaction_entity.dart';

class UserInteractionEntityMapper
    extends ClassMapperBase<UserInteractionEntity> {
  UserInteractionEntityMapper._();

  static UserInteractionEntityMapper? _instance;
  static UserInteractionEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserInteractionEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserInteractionEntity';

  static String _$vacancyId(UserInteractionEntity v) => v.vacancyId;
  static const Field<UserInteractionEntity, String> _f$vacancyId = Field(
    'vacancyId',
    _$vacancyId,
  );
  static InteractionType _$type(UserInteractionEntity v) => v.type;
  static const Field<UserInteractionEntity, InteractionType> _f$type = Field(
    'type',
    _$type,
  );
  static DateTime _$timestamp(UserInteractionEntity v) => v.timestamp;
  static const Field<UserInteractionEntity, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    hook: TimestampHook(),
  );

  @override
  final MappableFields<UserInteractionEntity> fields = const {
    #vacancyId: _f$vacancyId,
    #type: _f$type,
    #timestamp: _f$timestamp,
  };

  static UserInteractionEntity _instantiate(DecodingData data) {
    return UserInteractionEntity(
      vacancyId: data.dec(_f$vacancyId),
      type: data.dec(_f$type),
      timestamp: data.dec(_f$timestamp),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserInteractionEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserInteractionEntity>(map);
  }

  static UserInteractionEntity fromJson(String json) {
    return ensureInitialized().decodeJson<UserInteractionEntity>(json);
  }
}

mixin UserInteractionEntityMappable {
  String toJson() {
    return UserInteractionEntityMapper.ensureInitialized()
        .encodeJson<UserInteractionEntity>(this as UserInteractionEntity);
  }

  Map<String, dynamic> toMap() {
    return UserInteractionEntityMapper.ensureInitialized()
        .encodeMap<UserInteractionEntity>(this as UserInteractionEntity);
  }

  UserInteractionEntityCopyWith<
    UserInteractionEntity,
    UserInteractionEntity,
    UserInteractionEntity
  >
  get copyWith =>
      _UserInteractionEntityCopyWithImpl<
        UserInteractionEntity,
        UserInteractionEntity
      >(this as UserInteractionEntity, $identity, $identity);
  @override
  String toString() {
    return UserInteractionEntityMapper.ensureInitialized().stringifyValue(
      this as UserInteractionEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserInteractionEntityMapper.ensureInitialized().equalsValue(
      this as UserInteractionEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return UserInteractionEntityMapper.ensureInitialized().hashValue(
      this as UserInteractionEntity,
    );
  }
}

extension UserInteractionEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserInteractionEntity, $Out> {
  UserInteractionEntityCopyWith<$R, UserInteractionEntity, $Out>
  get $asUserInteractionEntity => $base.as(
    (v, t, t2) => _UserInteractionEntityCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UserInteractionEntityCopyWith<
  $R,
  $In extends UserInteractionEntity,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? vacancyId, InteractionType? type, DateTime? timestamp});
  UserInteractionEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UserInteractionEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserInteractionEntity, $Out>
    implements UserInteractionEntityCopyWith<$R, UserInteractionEntity, $Out> {
  _UserInteractionEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserInteractionEntity> $mapper =
      UserInteractionEntityMapper.ensureInitialized();
  @override
  $R call({String? vacancyId, InteractionType? type, DateTime? timestamp}) =>
      $apply(
        FieldCopyWithData({
          if (vacancyId != null) #vacancyId: vacancyId,
          if (type != null) #type: type,
          if (timestamp != null) #timestamp: timestamp,
        }),
      );
  @override
  UserInteractionEntity $make(CopyWithData data) => UserInteractionEntity(
    vacancyId: data.get(#vacancyId, or: $value.vacancyId),
    type: data.get(#type, or: $value.type),
    timestamp: data.get(#timestamp, or: $value.timestamp),
  );

  @override
  UserInteractionEntityCopyWith<$R2, UserInteractionEntity, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserInteractionEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

