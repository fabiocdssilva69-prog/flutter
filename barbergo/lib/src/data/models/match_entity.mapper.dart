// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'match_entity.dart';

class MatchEntityMapper extends ClassMapperBase<MatchEntity> {
  MatchEntityMapper._();

  static MatchEntityMapper? _instance;
  static MatchEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MatchEntity';

  static String _$matchId(MatchEntity v) => v.matchId;
  static const Field<MatchEntity, String> _f$matchId = Field(
    'matchId',
    _$matchId,
  );
  static List<String> _$userIds(MatchEntity v) => v.userIds;
  static const Field<MatchEntity, List<String>> _f$userIds = Field(
    'userIds',
    _$userIds,
  );
  static String _$user1(MatchEntity v) => v.user1;
  static const Field<MatchEntity, String> _f$user1 = Field('user1', _$user1);
  static String _$user2(MatchEntity v) => v.user2;
  static const Field<MatchEntity, String> _f$user2 = Field('user2', _$user2);
  static DateTime _$createdAt(MatchEntity v) => v.createdAt;
  static const Field<MatchEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );
  static DateTime? _$lastMessageAt(MatchEntity v) => v.lastMessageAt;
  static const Field<MatchEntity, DateTime> _f$lastMessageAt = Field(
    'lastMessageAt',
    _$lastMessageAt,
    opt: true,
    hook: TimestampHook(),
  );
  static Map<String, int> _$unreadCount(MatchEntity v) => v.unreadCount;
  static const Field<MatchEntity, Map<String, int>> _f$unreadCount = Field(
    'unreadCount',
    _$unreadCount,
  );

  @override
  final MappableFields<MatchEntity> fields = const {
    #matchId: _f$matchId,
    #userIds: _f$userIds,
    #user1: _f$user1,
    #user2: _f$user2,
    #createdAt: _f$createdAt,
    #lastMessageAt: _f$lastMessageAt,
    #unreadCount: _f$unreadCount,
  };

  static MatchEntity _instantiate(DecodingData data) {
    return MatchEntity(
      matchId: data.dec(_f$matchId),
      userIds: data.dec(_f$userIds),
      user1: data.dec(_f$user1),
      user2: data.dec(_f$user2),
      createdAt: data.dec(_f$createdAt),
      lastMessageAt: data.dec(_f$lastMessageAt),
      unreadCount: data.dec(_f$unreadCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MatchEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchEntity>(map);
  }

  static MatchEntity fromJson(String json) {
    return ensureInitialized().decodeJson<MatchEntity>(json);
  }
}

mixin MatchEntityMappable {
  String toJson() {
    return MatchEntityMapper.ensureInitialized().encodeJson<MatchEntity>(
      this as MatchEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return MatchEntityMapper.ensureInitialized().encodeMap<MatchEntity>(
      this as MatchEntity,
    );
  }

  MatchEntityCopyWith<MatchEntity, MatchEntity, MatchEntity> get copyWith =>
      _MatchEntityCopyWithImpl<MatchEntity, MatchEntity>(
        this as MatchEntity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MatchEntityMapper.ensureInitialized().stringifyValue(
      this as MatchEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return MatchEntityMapper.ensureInitialized().equalsValue(
      this as MatchEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return MatchEntityMapper.ensureInitialized().hashValue(this as MatchEntity);
  }
}

extension MatchEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchEntity, $Out> {
  MatchEntityCopyWith<$R, MatchEntity, $Out> get $asMatchEntity =>
      $base.as((v, t, t2) => _MatchEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchEntityCopyWith<$R, $In extends MatchEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userIds;
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get unreadCount;
  $R call({
    String? matchId,
    List<String>? userIds,
    String? user1,
    String? user2,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    Map<String, int>? unreadCount,
  });
  MatchEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MatchEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchEntity, $Out>
    implements MatchEntityCopyWith<$R, MatchEntity, $Out> {
  _MatchEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchEntity> $mapper =
      MatchEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userIds =>
      ListCopyWith(
        $value.userIds,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(userIds: v),
      );
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get unreadCount =>
      MapCopyWith(
        $value.unreadCount,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(unreadCount: v),
      );
  @override
  $R call({
    String? matchId,
    List<String>? userIds,
    String? user1,
    String? user2,
    DateTime? createdAt,
    Object? lastMessageAt = $none,
    Map<String, int>? unreadCount,
  }) => $apply(
    FieldCopyWithData({
      if (matchId != null) #matchId: matchId,
      if (userIds != null) #userIds: userIds,
      if (user1 != null) #user1: user1,
      if (user2 != null) #user2: user2,
      if (createdAt != null) #createdAt: createdAt,
      if (lastMessageAt != $none) #lastMessageAt: lastMessageAt,
      if (unreadCount != null) #unreadCount: unreadCount,
    }),
  );
  @override
  MatchEntity $make(CopyWithData data) => MatchEntity(
    matchId: data.get(#matchId, or: $value.matchId),
    userIds: data.get(#userIds, or: $value.userIds),
    user1: data.get(#user1, or: $value.user1),
    user2: data.get(#user2, or: $value.user2),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    lastMessageAt: data.get(#lastMessageAt, or: $value.lastMessageAt),
    unreadCount: data.get(#unreadCount, or: $value.unreadCount),
  );

  @override
  MatchEntityCopyWith<$R2, MatchEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MatchEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

