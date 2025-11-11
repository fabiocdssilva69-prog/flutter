// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'application_entity.dart';

class ApplicationEntityMapper extends ClassMapperBase<ApplicationEntity> {
  ApplicationEntityMapper._();

  static ApplicationEntityMapper? _instance;
  static ApplicationEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ApplicationEntityMapper._());
      ApplicationStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ApplicationEntity';

  static String _$applicationId(ApplicationEntity v) => v.applicationId;
  static const Field<ApplicationEntity, String> _f$applicationId = Field(
    'applicationId',
    _$applicationId,
  );
  static String _$vacancyId(ApplicationEntity v) => v.vacancyId;
  static const Field<ApplicationEntity, String> _f$vacancyId = Field(
    'vacancyId',
    _$vacancyId,
  );
  static String _$barberId(ApplicationEntity v) => v.barberId;
  static const Field<ApplicationEntity, String> _f$barberId = Field(
    'barberId',
    _$barberId,
  );
  static String _$barbershopId(ApplicationEntity v) => v.barbershopId;
  static const Field<ApplicationEntity, String> _f$barbershopId = Field(
    'barbershopId',
    _$barbershopId,
  );
  static String _$barbershopName(ApplicationEntity v) => v.barbershopName;
  static const Field<ApplicationEntity, String> _f$barbershopName = Field(
    'barbershopName',
    _$barbershopName,
  );
  static ApplicationStatus _$status(ApplicationEntity v) => v.status;
  static const Field<ApplicationEntity, ApplicationStatus> _f$status = Field(
    'status',
    _$status,
  );
  static DateTime _$createdAt(ApplicationEntity v) => v.createdAt;
  static const Field<ApplicationEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );
  static DateTime? _$updatedAt(ApplicationEntity v) => v.updatedAt;
  static const Field<ApplicationEntity, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
    hook: TimestampHook(),
  );

  @override
  final MappableFields<ApplicationEntity> fields = const {
    #applicationId: _f$applicationId,
    #vacancyId: _f$vacancyId,
    #barberId: _f$barberId,
    #barbershopId: _f$barbershopId,
    #barbershopName: _f$barbershopName,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static ApplicationEntity _instantiate(DecodingData data) {
    return ApplicationEntity(
      applicationId: data.dec(_f$applicationId),
      vacancyId: data.dec(_f$vacancyId),
      barberId: data.dec(_f$barberId),
      barbershopId: data.dec(_f$barbershopId),
      barbershopName: data.dec(_f$barbershopName),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ApplicationEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ApplicationEntity>(map);
  }

  static ApplicationEntity fromJson(String json) {
    return ensureInitialized().decodeJson<ApplicationEntity>(json);
  }
}

mixin ApplicationEntityMappable {
  String toJson() {
    return ApplicationEntityMapper.ensureInitialized()
        .encodeJson<ApplicationEntity>(this as ApplicationEntity);
  }

  Map<String, dynamic> toMap() {
    return ApplicationEntityMapper.ensureInitialized()
        .encodeMap<ApplicationEntity>(this as ApplicationEntity);
  }

  ApplicationEntityCopyWith<
    ApplicationEntity,
    ApplicationEntity,
    ApplicationEntity
  >
  get copyWith =>
      _ApplicationEntityCopyWithImpl<ApplicationEntity, ApplicationEntity>(
        this as ApplicationEntity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ApplicationEntityMapper.ensureInitialized().stringifyValue(
      this as ApplicationEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return ApplicationEntityMapper.ensureInitialized().equalsValue(
      this as ApplicationEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return ApplicationEntityMapper.ensureInitialized().hashValue(
      this as ApplicationEntity,
    );
  }
}

extension ApplicationEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ApplicationEntity, $Out> {
  ApplicationEntityCopyWith<$R, ApplicationEntity, $Out>
  get $asApplicationEntity => $base.as(
    (v, t, t2) => _ApplicationEntityCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ApplicationEntityCopyWith<
  $R,
  $In extends ApplicationEntity,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? applicationId,
    String? vacancyId,
    String? barberId,
    String? barbershopId,
    String? barbershopName,
    ApplicationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  ApplicationEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ApplicationEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ApplicationEntity, $Out>
    implements ApplicationEntityCopyWith<$R, ApplicationEntity, $Out> {
  _ApplicationEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ApplicationEntity> $mapper =
      ApplicationEntityMapper.ensureInitialized();
  @override
  $R call({
    String? applicationId,
    String? vacancyId,
    String? barberId,
    String? barbershopId,
    String? barbershopName,
    ApplicationStatus? status,
    DateTime? createdAt,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (applicationId != null) #applicationId: applicationId,
      if (vacancyId != null) #vacancyId: vacancyId,
      if (barberId != null) #barberId: barberId,
      if (barbershopId != null) #barbershopId: barbershopId,
      if (barbershopName != null) #barbershopName: barbershopName,
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  ApplicationEntity $make(CopyWithData data) => ApplicationEntity(
    applicationId: data.get(#applicationId, or: $value.applicationId),
    vacancyId: data.get(#vacancyId, or: $value.vacancyId),
    barberId: data.get(#barberId, or: $value.barberId),
    barbershopId: data.get(#barbershopId, or: $value.barbershopId),
    barbershopName: data.get(#barbershopName, or: $value.barbershopName),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  ApplicationEntityCopyWith<$R2, ApplicationEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ApplicationEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

