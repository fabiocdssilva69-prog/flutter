// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'vacancy_entity.dart';

class VacancyEntityMapper extends ClassMapperBase<VacancyEntity> {
  VacancyEntityMapper._();

  static VacancyEntityMapper? _instance;
  static VacancyEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VacancyEntityMapper._());
      VacancyTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'VacancyEntity';

  static String _$vacancyId(VacancyEntity v) => v.vacancyId;
  static const Field<VacancyEntity, String> _f$vacancyId = Field(
    'vacancyId',
    _$vacancyId,
  );
  static String _$barbershopId(VacancyEntity v) => v.barbershopId;
  static const Field<VacancyEntity, String> _f$barbershopId = Field(
    'barbershopId',
    _$barbershopId,
  );
  static String _$barbershopName(VacancyEntity v) => v.barbershopName;
  static const Field<VacancyEntity, String> _f$barbershopName = Field(
    'barbershopName',
    _$barbershopName,
  );
  static String _$locationCityState(VacancyEntity v) => v.locationCityState;
  static const Field<VacancyEntity, String> _f$locationCityState = Field(
    'locationCityState',
    _$locationCityState,
  );
  static Map<String, dynamic>? _$preciseLocation(VacancyEntity v) =>
      v.preciseLocation;
  static const Field<VacancyEntity, Map<String, dynamic>> _f$preciseLocation =
      Field(
        'preciseLocation',
        _$preciseLocation,
        opt: true,
        hook: GeoFirePointHook(),
      );
  static String _$title(VacancyEntity v) => v.title;
  static const Field<VacancyEntity, String> _f$title = Field('title', _$title);
  static VacancyType _$type(VacancyEntity v) => v.type;
  static const Field<VacancyEntity, VacancyType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$workHours(VacancyEntity v) => v.workHours;
  static const Field<VacancyEntity, String> _f$workHours = Field(
    'workHours',
    _$workHours,
  );
  static bool _$isActive(VacancyEntity v) => v.isActive;
  static const Field<VacancyEntity, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
  );
  static DateTime _$createdAt(VacancyEntity v) => v.createdAt;
  static const Field<VacancyEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );
  static double? _$commissionPercentage(VacancyEntity v) =>
      v.commissionPercentage;
  static const Field<VacancyEntity, double> _f$commissionPercentage = Field(
    'commissionPercentage',
    _$commissionPercentage,
    opt: true,
  );
  static String? _$requirements(VacancyEntity v) => v.requirements;
  static const Field<VacancyEntity, String> _f$requirements = Field(
    'requirements',
    _$requirements,
    opt: true,
  );
  static List<String>? _$benefits(VacancyEntity v) => v.benefits;
  static const Field<VacancyEntity, List<String>> _f$benefits = Field(
    'benefits',
    _$benefits,
    opt: true,
  );
  static DateTime? _$updatedAt(VacancyEntity v) => v.updatedAt;
  static const Field<VacancyEntity, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
    hook: TimestampHook(),
  );
  static GeoFirePoint _$geoLocation(VacancyEntity v) => v.geoLocation;
  static const Field<VacancyEntity, GeoFirePoint> _f$geoLocation = Field(
    'geoLocation',
    _$geoLocation,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<VacancyEntity> fields = const {
    #vacancyId: _f$vacancyId,
    #barbershopId: _f$barbershopId,
    #barbershopName: _f$barbershopName,
    #locationCityState: _f$locationCityState,
    #preciseLocation: _f$preciseLocation,
    #title: _f$title,
    #type: _f$type,
    #workHours: _f$workHours,
    #isActive: _f$isActive,
    #createdAt: _f$createdAt,
    #commissionPercentage: _f$commissionPercentage,
    #requirements: _f$requirements,
    #benefits: _f$benefits,
    #updatedAt: _f$updatedAt,
    #geoLocation: _f$geoLocation,
  };

  static VacancyEntity _instantiate(DecodingData data) {
    return VacancyEntity(
      vacancyId: data.dec(_f$vacancyId),
      barbershopId: data.dec(_f$barbershopId),
      barbershopName: data.dec(_f$barbershopName),
      locationCityState: data.dec(_f$locationCityState),
      preciseLocation: data.dec(_f$preciseLocation),
      title: data.dec(_f$title),
      type: data.dec(_f$type),
      workHours: data.dec(_f$workHours),
      isActive: data.dec(_f$isActive),
      createdAt: data.dec(_f$createdAt),
      commissionPercentage: data.dec(_f$commissionPercentage),
      requirements: data.dec(_f$requirements),
      benefits: data.dec(_f$benefits),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VacancyEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VacancyEntity>(map);
  }

  static VacancyEntity fromJson(String json) {
    return ensureInitialized().decodeJson<VacancyEntity>(json);
  }
}

mixin VacancyEntityMappable {
  String toJson() {
    return VacancyEntityMapper.ensureInitialized().encodeJson<VacancyEntity>(
      this as VacancyEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return VacancyEntityMapper.ensureInitialized().encodeMap<VacancyEntity>(
      this as VacancyEntity,
    );
  }

  VacancyEntityCopyWith<VacancyEntity, VacancyEntity, VacancyEntity>
  get copyWith => _VacancyEntityCopyWithImpl<VacancyEntity, VacancyEntity>(
    this as VacancyEntity,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return VacancyEntityMapper.ensureInitialized().stringifyValue(
      this as VacancyEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return VacancyEntityMapper.ensureInitialized().equalsValue(
      this as VacancyEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return VacancyEntityMapper.ensureInitialized().hashValue(
      this as VacancyEntity,
    );
  }
}

extension VacancyEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VacancyEntity, $Out> {
  VacancyEntityCopyWith<$R, VacancyEntity, $Out> get $asVacancyEntity =>
      $base.as((v, t, t2) => _VacancyEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VacancyEntityCopyWith<$R, $In extends VacancyEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get preciseLocation;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get benefits;
  $R call({
    String? vacancyId,
    String? barbershopId,
    String? barbershopName,
    String? locationCityState,
    Map<String, dynamic>? preciseLocation,
    String? title,
    VacancyType? type,
    String? workHours,
    bool? isActive,
    DateTime? createdAt,
    double? commissionPercentage,
    String? requirements,
    List<String>? benefits,
    DateTime? updatedAt,
  });
  VacancyEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VacancyEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VacancyEntity, $Out>
    implements VacancyEntityCopyWith<$R, VacancyEntity, $Out> {
  _VacancyEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VacancyEntity> $mapper =
      VacancyEntityMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get preciseLocation => $value.preciseLocation != null
      ? MapCopyWith(
          $value.preciseLocation!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(preciseLocation: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get benefits =>
      $value.benefits != null
      ? ListCopyWith(
          $value.benefits!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(benefits: v),
        )
      : null;
  @override
  $R call({
    String? vacancyId,
    String? barbershopId,
    String? barbershopName,
    String? locationCityState,
    Object? preciseLocation = $none,
    String? title,
    VacancyType? type,
    String? workHours,
    bool? isActive,
    DateTime? createdAt,
    Object? commissionPercentage = $none,
    Object? requirements = $none,
    Object? benefits = $none,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (vacancyId != null) #vacancyId: vacancyId,
      if (barbershopId != null) #barbershopId: barbershopId,
      if (barbershopName != null) #barbershopName: barbershopName,
      if (locationCityState != null) #locationCityState: locationCityState,
      if (preciseLocation != $none) #preciseLocation: preciseLocation,
      if (title != null) #title: title,
      if (type != null) #type: type,
      if (workHours != null) #workHours: workHours,
      if (isActive != null) #isActive: isActive,
      if (createdAt != null) #createdAt: createdAt,
      if (commissionPercentage != $none)
        #commissionPercentage: commissionPercentage,
      if (requirements != $none) #requirements: requirements,
      if (benefits != $none) #benefits: benefits,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  VacancyEntity $make(CopyWithData data) => VacancyEntity(
    vacancyId: data.get(#vacancyId, or: $value.vacancyId),
    barbershopId: data.get(#barbershopId, or: $value.barbershopId),
    barbershopName: data.get(#barbershopName, or: $value.barbershopName),
    locationCityState: data.get(
      #locationCityState,
      or: $value.locationCityState,
    ),
    preciseLocation: data.get(#preciseLocation, or: $value.preciseLocation),
    title: data.get(#title, or: $value.title),
    type: data.get(#type, or: $value.type),
    workHours: data.get(#workHours, or: $value.workHours),
    isActive: data.get(#isActive, or: $value.isActive),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    commissionPercentage: data.get(
      #commissionPercentage,
      or: $value.commissionPercentage,
    ),
    requirements: data.get(#requirements, or: $value.requirements),
    benefits: data.get(#benefits, or: $value.benefits),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  VacancyEntityCopyWith<$R2, VacancyEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VacancyEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

