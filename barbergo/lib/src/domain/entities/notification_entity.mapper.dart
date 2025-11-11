// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notification_entity.dart';

class NotificationEntityMapper extends ClassMapperBase<NotificationEntity> {
  NotificationEntityMapper._();

  static NotificationEntityMapper? _instance;
  static NotificationEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationEntity';

  static String _$id(NotificationEntity v) => v.id;
  static const Field<NotificationEntity, String> _f$id = Field('id', _$id);
  static NotificationType _$type(NotificationEntity v) => v.type;
  static const Field<NotificationEntity, NotificationType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$title(NotificationEntity v) => v.title;
  static const Field<NotificationEntity, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$message(NotificationEntity v) => v.message;
  static const Field<NotificationEntity, String> _f$message = Field(
    'message',
    _$message,
  );
  static DateTime _$createdAt(NotificationEntity v) => v.createdAt;
  static const Field<NotificationEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );
  static Map<String, dynamic>? _$contextData(NotificationEntity v) =>
      v.contextData;
  static const Field<NotificationEntity, Map<String, dynamic>> _f$contextData =
      Field('contextData', _$contextData, opt: true);
  static bool _$isRead(NotificationEntity v) => v.isRead;
  static const Field<NotificationEntity, bool> _f$isRead = Field(
    'isRead',
    _$isRead,
    opt: true,
    def: false,
  );
  static String _$iconName(NotificationEntity v) => v.iconName;
  static const Field<NotificationEntity, String> _f$iconName = Field(
    'iconName',
    _$iconName,
    mode: FieldMode.member,
  );
  static String? _$deepLinkRoute(NotificationEntity v) => v.deepLinkRoute;
  static const Field<NotificationEntity, String> _f$deepLinkRoute = Field(
    'deepLinkRoute',
    _$deepLinkRoute,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<NotificationEntity> fields = const {
    #id: _f$id,
    #type: _f$type,
    #title: _f$title,
    #message: _f$message,
    #createdAt: _f$createdAt,
    #contextData: _f$contextData,
    #isRead: _f$isRead,
    #iconName: _f$iconName,
    #deepLinkRoute: _f$deepLinkRoute,
  };

  static NotificationEntity _instantiate(DecodingData data) {
    return NotificationEntity(
      id: data.dec(_f$id),
      type: data.dec(_f$type),
      title: data.dec(_f$title),
      message: data.dec(_f$message),
      createdAt: data.dec(_f$createdAt),
      contextData: data.dec(_f$contextData),
      isRead: data.dec(_f$isRead),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationEntity>(map);
  }

  static NotificationEntity fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationEntity>(json);
  }
}

mixin NotificationEntityMappable {
  String toJson() {
    return NotificationEntityMapper.ensureInitialized()
        .encodeJson<NotificationEntity>(this as NotificationEntity);
  }

  Map<String, dynamic> toMap() {
    return NotificationEntityMapper.ensureInitialized()
        .encodeMap<NotificationEntity>(this as NotificationEntity);
  }

  NotificationEntityCopyWith<
    NotificationEntity,
    NotificationEntity,
    NotificationEntity
  >
  get copyWith =>
      _NotificationEntityCopyWithImpl<NotificationEntity, NotificationEntity>(
        this as NotificationEntity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return NotificationEntityMapper.ensureInitialized().stringifyValue(
      this as NotificationEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotificationEntityMapper.ensureInitialized().equalsValue(
      this as NotificationEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return NotificationEntityMapper.ensureInitialized().hashValue(
      this as NotificationEntity,
    );
  }
}

extension NotificationEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationEntity, $Out> {
  NotificationEntityCopyWith<$R, NotificationEntity, $Out>
  get $asNotificationEntity => $base.as(
    (v, t, t2) => _NotificationEntityCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class NotificationEntityCopyWith<
  $R,
  $In extends NotificationEntity,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get contextData;
  $R call({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    Map<String, dynamic>? contextData,
    bool? isRead,
  });
  NotificationEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NotificationEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationEntity, $Out>
    implements NotificationEntityCopyWith<$R, NotificationEntity, $Out> {
  _NotificationEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationEntity> $mapper =
      NotificationEntityMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get contextData => $value.contextData != null
      ? MapCopyWith(
          $value.contextData!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(contextData: v),
        )
      : null;
  @override
  $R call({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    Object? contextData = $none,
    bool? isRead,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (type != null) #type: type,
      if (title != null) #title: title,
      if (message != null) #message: message,
      if (createdAt != null) #createdAt: createdAt,
      if (contextData != $none) #contextData: contextData,
      if (isRead != null) #isRead: isRead,
    }),
  );
  @override
  NotificationEntity $make(CopyWithData data) => NotificationEntity(
    id: data.get(#id, or: $value.id),
    type: data.get(#type, or: $value.type),
    title: data.get(#title, or: $value.title),
    message: data.get(#message, or: $value.message),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    contextData: data.get(#contextData, or: $value.contextData),
    isRead: data.get(#isRead, or: $value.isRead),
  );

  @override
  NotificationEntityCopyWith<$R2, NotificationEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NotificationEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

