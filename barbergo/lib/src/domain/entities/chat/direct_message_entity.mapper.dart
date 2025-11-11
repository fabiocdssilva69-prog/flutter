// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'direct_message_entity.dart';

class DirectMessageEntityMapper extends ClassMapperBase<DirectMessageEntity> {
  DirectMessageEntityMapper._();

  static DirectMessageEntityMapper? _instance;
  static DirectMessageEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DirectMessageEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DirectMessageEntity';

  static String _$messageId(DirectMessageEntity v) => v.messageId;
  static const Field<DirectMessageEntity, String> _f$messageId = Field(
    'messageId',
    _$messageId,
  );
  static String _$senderId(DirectMessageEntity v) => v.senderId;
  static const Field<DirectMessageEntity, String> _f$senderId = Field(
    'senderId',
    _$senderId,
  );
  static String _$content(DirectMessageEntity v) => v.content;
  static const Field<DirectMessageEntity, String> _f$content = Field(
    'content',
    _$content,
  );
  static DateTime _$timestamp(DirectMessageEntity v) => v.timestamp;
  static const Field<DirectMessageEntity, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    hook: TimestampHook(),
  );
  static bool _$isSent(DirectMessageEntity v) => v.isSent;
  static const Field<DirectMessageEntity, bool> _f$isSent = Field(
    'isSent',
    _$isSent,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<DirectMessageEntity> fields = const {
    #messageId: _f$messageId,
    #senderId: _f$senderId,
    #content: _f$content,
    #timestamp: _f$timestamp,
    #isSent: _f$isSent,
  };

  static DirectMessageEntity _instantiate(DecodingData data) {
    return DirectMessageEntity(
      messageId: data.dec(_f$messageId),
      senderId: data.dec(_f$senderId),
      content: data.dec(_f$content),
      timestamp: data.dec(_f$timestamp),
      isSent: data.dec(_f$isSent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DirectMessageEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DirectMessageEntity>(map);
  }

  static DirectMessageEntity fromJson(String json) {
    return ensureInitialized().decodeJson<DirectMessageEntity>(json);
  }
}

mixin DirectMessageEntityMappable {
  String toJson() {
    return DirectMessageEntityMapper.ensureInitialized()
        .encodeJson<DirectMessageEntity>(this as DirectMessageEntity);
  }

  Map<String, dynamic> toMap() {
    return DirectMessageEntityMapper.ensureInitialized()
        .encodeMap<DirectMessageEntity>(this as DirectMessageEntity);
  }

  DirectMessageEntityCopyWith<
    DirectMessageEntity,
    DirectMessageEntity,
    DirectMessageEntity
  >
  get copyWith =>
      _DirectMessageEntityCopyWithImpl<
        DirectMessageEntity,
        DirectMessageEntity
      >(this as DirectMessageEntity, $identity, $identity);
  @override
  String toString() {
    return DirectMessageEntityMapper.ensureInitialized().stringifyValue(
      this as DirectMessageEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return DirectMessageEntityMapper.ensureInitialized().equalsValue(
      this as DirectMessageEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return DirectMessageEntityMapper.ensureInitialized().hashValue(
      this as DirectMessageEntity,
    );
  }
}

extension DirectMessageEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DirectMessageEntity, $Out> {
  DirectMessageEntityCopyWith<$R, DirectMessageEntity, $Out>
  get $asDirectMessageEntity => $base.as(
    (v, t, t2) => _DirectMessageEntityCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DirectMessageEntityCopyWith<
  $R,
  $In extends DirectMessageEntity,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? messageId,
    String? senderId,
    String? content,
    DateTime? timestamp,
    bool? isSent,
  });
  DirectMessageEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DirectMessageEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DirectMessageEntity, $Out>
    implements DirectMessageEntityCopyWith<$R, DirectMessageEntity, $Out> {
  _DirectMessageEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DirectMessageEntity> $mapper =
      DirectMessageEntityMapper.ensureInitialized();
  @override
  $R call({
    String? messageId,
    String? senderId,
    String? content,
    DateTime? timestamp,
    bool? isSent,
  }) => $apply(
    FieldCopyWithData({
      if (messageId != null) #messageId: messageId,
      if (senderId != null) #senderId: senderId,
      if (content != null) #content: content,
      if (timestamp != null) #timestamp: timestamp,
      if (isSent != null) #isSent: isSent,
    }),
  );
  @override
  DirectMessageEntity $make(CopyWithData data) => DirectMessageEntity(
    messageId: data.get(#messageId, or: $value.messageId),
    senderId: data.get(#senderId, or: $value.senderId),
    content: data.get(#content, or: $value.content),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    isSent: data.get(#isSent, or: $value.isSent),
  );

  @override
  DirectMessageEntityCopyWith<$R2, DirectMessageEntity, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DirectMessageEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

