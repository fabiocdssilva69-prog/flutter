// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_room_entity.dart';

class ParticipantInfoMapper extends ClassMapperBase<ParticipantInfo> {
  ParticipantInfoMapper._();

  static ParticipantInfoMapper? _instance;
  static ParticipantInfoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ParticipantInfoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ParticipantInfo';

  static String _$userId(ParticipantInfo v) => v.userId;
  static const Field<ParticipantInfo, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$name(ParticipantInfo v) => v.name;
  static const Field<ParticipantInfo, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<ParticipantInfo> fields = const {
    #userId: _f$userId,
    #name: _f$name,
  };

  static ParticipantInfo _instantiate(DecodingData data) {
    return ParticipantInfo(
      userId: data.dec(_f$userId),
      name: data.dec(_f$name),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ParticipantInfo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ParticipantInfo>(map);
  }

  static ParticipantInfo fromJson(String json) {
    return ensureInitialized().decodeJson<ParticipantInfo>(json);
  }
}

mixin ParticipantInfoMappable {
  String toJson() {
    return ParticipantInfoMapper.ensureInitialized()
        .encodeJson<ParticipantInfo>(this as ParticipantInfo);
  }

  Map<String, dynamic> toMap() {
    return ParticipantInfoMapper.ensureInitialized().encodeMap<ParticipantInfo>(
      this as ParticipantInfo,
    );
  }

  ParticipantInfoCopyWith<ParticipantInfo, ParticipantInfo, ParticipantInfo>
  get copyWith =>
      _ParticipantInfoCopyWithImpl<ParticipantInfo, ParticipantInfo>(
        this as ParticipantInfo,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ParticipantInfoMapper.ensureInitialized().stringifyValue(
      this as ParticipantInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    return ParticipantInfoMapper.ensureInitialized().equalsValue(
      this as ParticipantInfo,
      other,
    );
  }

  @override
  int get hashCode {
    return ParticipantInfoMapper.ensureInitialized().hashValue(
      this as ParticipantInfo,
    );
  }
}

extension ParticipantInfoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ParticipantInfo, $Out> {
  ParticipantInfoCopyWith<$R, ParticipantInfo, $Out> get $asParticipantInfo =>
      $base.as((v, t, t2) => _ParticipantInfoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ParticipantInfoCopyWith<$R, $In extends ParticipantInfo, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? userId, String? name});
  ParticipantInfoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ParticipantInfoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ParticipantInfo, $Out>
    implements ParticipantInfoCopyWith<$R, ParticipantInfo, $Out> {
  _ParticipantInfoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ParticipantInfo> $mapper =
      ParticipantInfoMapper.ensureInitialized();
  @override
  $R call({String? userId, String? name}) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (name != null) #name: name,
    }),
  );
  @override
  ParticipantInfo $make(CopyWithData data) => ParticipantInfo(
    userId: data.get(#userId, or: $value.userId),
    name: data.get(#name, or: $value.name),
  );

  @override
  ParticipantInfoCopyWith<$R2, ParticipantInfo, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ParticipantInfoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatRoomEntityMapper extends ClassMapperBase<ChatRoomEntity> {
  ChatRoomEntityMapper._();

  static ChatRoomEntityMapper? _instance;
  static ChatRoomEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatRoomEntityMapper._());
      ParticipantInfoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatRoomEntity';

  static String _$roomId(ChatRoomEntity v) => v.roomId;
  static const Field<ChatRoomEntity, String> _f$roomId = Field(
    'roomId',
    _$roomId,
  );
  static List<String> _$participantIds(ChatRoomEntity v) => v.participantIds;
  static const Field<ChatRoomEntity, List<String>> _f$participantIds = Field(
    'participantIds',
    _$participantIds,
  );
  static Map<String, ParticipantInfo> _$participants(ChatRoomEntity v) =>
      v.participants;
  static const Field<ChatRoomEntity, Map<String, ParticipantInfo>>
  _f$participants = Field('participants', _$participants);
  static DateTime _$createdAt(ChatRoomEntity v) => v.createdAt;
  static const Field<ChatRoomEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );
  static Map<String, int> _$unreadCounts(ChatRoomEntity v) => v.unreadCounts;
  static const Field<ChatRoomEntity, Map<String, int>> _f$unreadCounts = Field(
    'unreadCounts',
    _$unreadCounts,
  );
  static String? _$lastMessage(ChatRoomEntity v) => v.lastMessage;
  static const Field<ChatRoomEntity, String> _f$lastMessage = Field(
    'lastMessage',
    _$lastMessage,
    opt: true,
  );
  static DateTime? _$lastMessageTimestamp(ChatRoomEntity v) =>
      v.lastMessageTimestamp;
  static const Field<ChatRoomEntity, DateTime> _f$lastMessageTimestamp = Field(
    'lastMessageTimestamp',
    _$lastMessageTimestamp,
    opt: true,
    hook: TimestampHook(),
  );

  @override
  final MappableFields<ChatRoomEntity> fields = const {
    #roomId: _f$roomId,
    #participantIds: _f$participantIds,
    #participants: _f$participants,
    #createdAt: _f$createdAt,
    #unreadCounts: _f$unreadCounts,
    #lastMessage: _f$lastMessage,
    #lastMessageTimestamp: _f$lastMessageTimestamp,
  };

  static ChatRoomEntity _instantiate(DecodingData data) {
    return ChatRoomEntity(
      roomId: data.dec(_f$roomId),
      participantIds: data.dec(_f$participantIds),
      participants: data.dec(_f$participants),
      createdAt: data.dec(_f$createdAt),
      unreadCounts: data.dec(_f$unreadCounts),
      lastMessage: data.dec(_f$lastMessage),
      lastMessageTimestamp: data.dec(_f$lastMessageTimestamp),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatRoomEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatRoomEntity>(map);
  }

  static ChatRoomEntity fromJson(String json) {
    return ensureInitialized().decodeJson<ChatRoomEntity>(json);
  }
}

mixin ChatRoomEntityMappable {
  String toJson() {
    return ChatRoomEntityMapper.ensureInitialized().encodeJson<ChatRoomEntity>(
      this as ChatRoomEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatRoomEntityMapper.ensureInitialized().encodeMap<ChatRoomEntity>(
      this as ChatRoomEntity,
    );
  }

  ChatRoomEntityCopyWith<ChatRoomEntity, ChatRoomEntity, ChatRoomEntity>
  get copyWith => _ChatRoomEntityCopyWithImpl<ChatRoomEntity, ChatRoomEntity>(
    this as ChatRoomEntity,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ChatRoomEntityMapper.ensureInitialized().stringifyValue(
      this as ChatRoomEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatRoomEntityMapper.ensureInitialized().equalsValue(
      this as ChatRoomEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatRoomEntityMapper.ensureInitialized().hashValue(
      this as ChatRoomEntity,
    );
  }
}

extension ChatRoomEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatRoomEntity, $Out> {
  ChatRoomEntityCopyWith<$R, ChatRoomEntity, $Out> get $asChatRoomEntity =>
      $base.as((v, t, t2) => _ChatRoomEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatRoomEntityCopyWith<$R, $In extends ChatRoomEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participantIds;
  MapCopyWith<
    $R,
    String,
    ParticipantInfo,
    ParticipantInfoCopyWith<$R, ParticipantInfo, ParticipantInfo>
  >
  get participants;
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get unreadCounts;
  $R call({
    String? roomId,
    List<String>? participantIds,
    Map<String, ParticipantInfo>? participants,
    DateTime? createdAt,
    Map<String, int>? unreadCounts,
    String? lastMessage,
    DateTime? lastMessageTimestamp,
  });
  ChatRoomEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatRoomEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatRoomEntity, $Out>
    implements ChatRoomEntityCopyWith<$R, ChatRoomEntity, $Out> {
  _ChatRoomEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatRoomEntity> $mapper =
      ChatRoomEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participantIds => ListCopyWith(
    $value.participantIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(participantIds: v),
  );
  @override
  MapCopyWith<
    $R,
    String,
    ParticipantInfo,
    ParticipantInfoCopyWith<$R, ParticipantInfo, ParticipantInfo>
  >
  get participants => MapCopyWith(
    $value.participants,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(participants: v),
  );
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get unreadCounts =>
      MapCopyWith(
        $value.unreadCounts,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(unreadCounts: v),
      );
  @override
  $R call({
    String? roomId,
    List<String>? participantIds,
    Map<String, ParticipantInfo>? participants,
    DateTime? createdAt,
    Map<String, int>? unreadCounts,
    Object? lastMessage = $none,
    Object? lastMessageTimestamp = $none,
  }) => $apply(
    FieldCopyWithData({
      if (roomId != null) #roomId: roomId,
      if (participantIds != null) #participantIds: participantIds,
      if (participants != null) #participants: participants,
      if (createdAt != null) #createdAt: createdAt,
      if (unreadCounts != null) #unreadCounts: unreadCounts,
      if (lastMessage != $none) #lastMessage: lastMessage,
      if (lastMessageTimestamp != $none)
        #lastMessageTimestamp: lastMessageTimestamp,
    }),
  );
  @override
  ChatRoomEntity $make(CopyWithData data) => ChatRoomEntity(
    roomId: data.get(#roomId, or: $value.roomId),
    participantIds: data.get(#participantIds, or: $value.participantIds),
    participants: data.get(#participants, or: $value.participants),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    unreadCounts: data.get(#unreadCounts, or: $value.unreadCounts),
    lastMessage: data.get(#lastMessage, or: $value.lastMessage),
    lastMessageTimestamp: data.get(
      #lastMessageTimestamp,
      or: $value.lastMessageTimestamp,
    ),
  );

  @override
  ChatRoomEntityCopyWith<$R2, ChatRoomEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatRoomEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

