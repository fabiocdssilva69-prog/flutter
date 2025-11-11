// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'vacancy_match_entity.dart';

class VacancyMatchEntityMapper extends ClassMapperBase<VacancyMatchEntity> {
  VacancyMatchEntityMapper._();

  static VacancyMatchEntityMapper? _instance;
  static VacancyMatchEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VacancyMatchEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VacancyMatchEntity';

  static String _$matchId(VacancyMatchEntity v) => v.matchId;
  static const Field<VacancyMatchEntity, String> _f$matchId = Field(
    'matchId',
    _$matchId,
  );
  static String _$barberId(VacancyMatchEntity v) => v.barberId;
  static const Field<VacancyMatchEntity, String> _f$barberId = Field(
    'barberId',
    _$barberId,
  );
  static String _$barbershopId(VacancyMatchEntity v) => v.barbershopId;
  static const Field<VacancyMatchEntity, String> _f$barbershopId = Field(
    'barbershopId',
    _$barbershopId,
  );
  static String _$vacancyId(VacancyMatchEntity v) => v.vacancyId;
  static const Field<VacancyMatchEntity, String> _f$vacancyId = Field(
    'vacancyId',
    _$vacancyId,
  );
  static String _$barberName(VacancyMatchEntity v) => v.barberName;
  static const Field<VacancyMatchEntity, String> _f$barberName = Field(
    'barberName',
    _$barberName,
  );
  static String _$barbershopName(VacancyMatchEntity v) => v.barbershopName;
  static const Field<VacancyMatchEntity, String> _f$barbershopName = Field(
    'barbershopName',
    _$barbershopName,
  );
  static String _$vacancyTitle(VacancyMatchEntity v) => v.vacancyTitle;
  static const Field<VacancyMatchEntity, String> _f$vacancyTitle = Field(
    'vacancyTitle',
    _$vacancyTitle,
  );
  static String _$status(VacancyMatchEntity v) => v.status;
  static const Field<VacancyMatchEntity, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: 'pending',
  );
  static DateTime _$createdAt(VacancyMatchEntity v) => v.createdAt;
  static const Field<VacancyMatchEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );
  static DateTime? _$lastMessageAt(VacancyMatchEntity v) => v.lastMessageAt;
  static const Field<VacancyMatchEntity, DateTime> _f$lastMessageAt = Field(
    'lastMessageAt',
    _$lastMessageAt,
    opt: true,
    hook: TimestampHook(),
  );
  static Map<String, int> _$unreadCount(VacancyMatchEntity v) => v.unreadCount;
  static const Field<VacancyMatchEntity, Map<String, int>> _f$unreadCount =
      Field('unreadCount', _$unreadCount, opt: true, def: const {});

  @override
  final MappableFields<VacancyMatchEntity> fields = const {
    #matchId: _f$matchId,
    #barberId: _f$barberId,
    #barbershopId: _f$barbershopId,
    #vacancyId: _f$vacancyId,
    #barberName: _f$barberName,
    #barbershopName: _f$barbershopName,
    #vacancyTitle: _f$vacancyTitle,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #lastMessageAt: _f$lastMessageAt,
    #unreadCount: _f$unreadCount,
  };

  static VacancyMatchEntity _instantiate(DecodingData data) {
    return VacancyMatchEntity(
      matchId: data.dec(_f$matchId),
      barberId: data.dec(_f$barberId),
      barbershopId: data.dec(_f$barbershopId),
      vacancyId: data.dec(_f$vacancyId),
      barberName: data.dec(_f$barberName),
      barbershopName: data.dec(_f$barbershopName),
      vacancyTitle: data.dec(_f$vacancyTitle),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      lastMessageAt: data.dec(_f$lastMessageAt),
      unreadCount: data.dec(_f$unreadCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VacancyMatchEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VacancyMatchEntity>(map);
  }

  static VacancyMatchEntity fromJson(String json) {
    return ensureInitialized().decodeJson<VacancyMatchEntity>(json);
  }
}

mixin VacancyMatchEntityMappable {
  String toJson() {
    return VacancyMatchEntityMapper.ensureInitialized()
        .encodeJson<VacancyMatchEntity>(this as VacancyMatchEntity);
  }

  Map<String, dynamic> toMap() {
    return VacancyMatchEntityMapper.ensureInitialized()
        .encodeMap<VacancyMatchEntity>(this as VacancyMatchEntity);
  }

  VacancyMatchEntityCopyWith<
    VacancyMatchEntity,
    VacancyMatchEntity,
    VacancyMatchEntity
  >
  get copyWith =>
      _VacancyMatchEntityCopyWithImpl<VacancyMatchEntity, VacancyMatchEntity>(
        this as VacancyMatchEntity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VacancyMatchEntityMapper.ensureInitialized().stringifyValue(
      this as VacancyMatchEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return VacancyMatchEntityMapper.ensureInitialized().equalsValue(
      this as VacancyMatchEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return VacancyMatchEntityMapper.ensureInitialized().hashValue(
      this as VacancyMatchEntity,
    );
  }
}

extension VacancyMatchEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VacancyMatchEntity, $Out> {
  VacancyMatchEntityCopyWith<$R, VacancyMatchEntity, $Out>
  get $asVacancyMatchEntity => $base.as(
    (v, t, t2) => _VacancyMatchEntityCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VacancyMatchEntityCopyWith<
  $R,
  $In extends VacancyMatchEntity,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get unreadCount;
  $R call({
    String? matchId,
    String? barberId,
    String? barbershopId,
    String? vacancyId,
    String? barberName,
    String? barbershopName,
    String? vacancyTitle,
    String? status,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    Map<String, int>? unreadCount,
  });
  VacancyMatchEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VacancyMatchEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VacancyMatchEntity, $Out>
    implements VacancyMatchEntityCopyWith<$R, VacancyMatchEntity, $Out> {
  _VacancyMatchEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VacancyMatchEntity> $mapper =
      VacancyMatchEntityMapper.ensureInitialized();
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
    String? barberId,
    String? barbershopId,
    String? vacancyId,
    String? barberName,
    String? barbershopName,
    String? vacancyTitle,
    String? status,
    DateTime? createdAt,
    Object? lastMessageAt = $none,
    Map<String, int>? unreadCount,
  }) => $apply(
    FieldCopyWithData({
      if (matchId != null) #matchId: matchId,
      if (barberId != null) #barberId: barberId,
      if (barbershopId != null) #barbershopId: barbershopId,
      if (vacancyId != null) #vacancyId: vacancyId,
      if (barberName != null) #barberName: barberName,
      if (barbershopName != null) #barbershopName: barbershopName,
      if (vacancyTitle != null) #vacancyTitle: vacancyTitle,
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (lastMessageAt != $none) #lastMessageAt: lastMessageAt,
      if (unreadCount != null) #unreadCount: unreadCount,
    }),
  );
  @override
  VacancyMatchEntity $make(CopyWithData data) => VacancyMatchEntity(
    matchId: data.get(#matchId, or: $value.matchId),
    barberId: data.get(#barberId, or: $value.barberId),
    barbershopId: data.get(#barbershopId, or: $value.barbershopId),
    vacancyId: data.get(#vacancyId, or: $value.vacancyId),
    barberName: data.get(#barberName, or: $value.barberName),
    barbershopName: data.get(#barbershopName, or: $value.barbershopName),
    vacancyTitle: data.get(#vacancyTitle, or: $value.vacancyTitle),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    lastMessageAt: data.get(#lastMessageAt, or: $value.lastMessageAt),
    unreadCount: data.get(#unreadCount, or: $value.unreadCount),
  );

  @override
  VacancyMatchEntityCopyWith<$R2, VacancyMatchEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VacancyMatchEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

