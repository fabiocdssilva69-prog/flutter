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
  static List<String> _$participants(MatchEntity v) => v.participants;
  static const Field<MatchEntity, List<String>> _f$participants = Field(
    'participants',
    _$participants,
  );
  static DateTime _$matchedAt(MatchEntity v) => v.matchedAt;
  static const Field<MatchEntity, DateTime> _f$matchedAt = Field(
    'matchedAt',
    _$matchedAt,
    hook: TimestampHook(),
  );
  static Map<String, dynamic>? _$contactInfo(MatchEntity v) => v.contactInfo;
  static const Field<MatchEntity, Map<String, dynamic>> _f$contactInfo = Field(
    'contactInfo',
    _$contactInfo,
    opt: true,
  );

  @override
  final MappableFields<MatchEntity> fields = const {
    #matchId: _f$matchId,
    #participants: _f$participants,
    #matchedAt: _f$matchedAt,
    #contactInfo: _f$contactInfo,
  };

  static MatchEntity _instantiate(DecodingData data) {
    return MatchEntity(
      matchId: data.dec(_f$matchId),
      participants: data.dec(_f$participants),
      matchedAt: data.dec(_f$matchedAt),
      contactInfo: data.dec(_f$contactInfo),
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get participants;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get contactInfo;
  $R call({
    String? matchId,
    List<String>? participants,
    DateTime? matchedAt,
    Map<String, dynamic>? contactInfo,
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participants => ListCopyWith(
    $value.participants,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(participants: v),
  );
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get contactInfo => $value.contactInfo != null
      ? MapCopyWith(
          $value.contactInfo!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(contactInfo: v),
        )
      : null;
  @override
  $R call({
    String? matchId,
    List<String>? participants,
    DateTime? matchedAt,
    Object? contactInfo = $none,
  }) => $apply(
    FieldCopyWithData({
      if (matchId != null) #matchId: matchId,
      if (participants != null) #participants: participants,
      if (matchedAt != null) #matchedAt: matchedAt,
      if (contactInfo != $none) #contactInfo: contactInfo,
    }),
  );
  @override
  MatchEntity $make(CopyWithData data) => MatchEntity(
    matchId: data.get(#matchId, or: $value.matchId),
    participants: data.get(#participants, or: $value.participants),
    matchedAt: data.get(#matchedAt, or: $value.matchedAt),
    contactInfo: data.get(#contactInfo, or: $value.contactInfo),
  );

  @override
  MatchEntityCopyWith<$R2, MatchEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MatchEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

