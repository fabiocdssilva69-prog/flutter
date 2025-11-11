// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_entity.dart';

class ChatEntityMapper extends ClassMapperBase<ChatEntity> {
  ChatEntityMapper._();

  static ChatEntityMapper? _instance;
  static ChatEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatEntity';

  static String _$chatId(ChatEntity v) => v.chatId;
  static const Field<ChatEntity, String> _f$chatId = Field('chatId', _$chatId);
  static String _$matchId(ChatEntity v) => v.matchId;
  static const Field<ChatEntity, String> _f$matchId = Field(
    'matchId',
    _$matchId,
  );
  static List<String> _$participants(ChatEntity v) => v.participants;
  static const Field<ChatEntity, List<String>> _f$participants = Field(
    'participants',
    _$participants,
  );
  static String? _$lastMessage(ChatEntity v) => v.lastMessage;
  static const Field<ChatEntity, String> _f$lastMessage = Field(
    'lastMessage',
    _$lastMessage,
    opt: true,
  );
  static DateTime? _$lastMessageAt(ChatEntity v) => v.lastMessageAt;
  static const Field<ChatEntity, DateTime> _f$lastMessageAt = Field(
    'lastMessageAt',
    _$lastMessageAt,
    opt: true,
    hook: TimestampHook(),
  );
  static DateTime _$createdAt(ChatEntity v) => v.createdAt;
  static const Field<ChatEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );

  @override
  final MappableFields<ChatEntity> fields = const {
    #chatId: _f$chatId,
    #matchId: _f$matchId,
    #participants: _f$participants,
    #lastMessage: _f$lastMessage,
    #lastMessageAt: _f$lastMessageAt,
    #createdAt: _f$createdAt,
  };

  static ChatEntity _instantiate(DecodingData data) {
    return ChatEntity(
      chatId: data.dec(_f$chatId),
      matchId: data.dec(_f$matchId),
      participants: data.dec(_f$participants),
      lastMessage: data.dec(_f$lastMessage),
      lastMessageAt: data.dec(_f$lastMessageAt),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatEntity>(map);
  }

  static ChatEntity fromJson(String json) {
    return ensureInitialized().decodeJson<ChatEntity>(json);
  }
}

mixin ChatEntityMappable {
  String toJson() {
    return ChatEntityMapper.ensureInitialized().encodeJson<ChatEntity>(
      this as ChatEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatEntityMapper.ensureInitialized().encodeMap<ChatEntity>(
      this as ChatEntity,
    );
  }

  ChatEntityCopyWith<ChatEntity, ChatEntity, ChatEntity> get copyWith =>
      _ChatEntityCopyWithImpl<ChatEntity, ChatEntity>(
        this as ChatEntity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatEntityMapper.ensureInitialized().stringifyValue(
      this as ChatEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatEntityMapper.ensureInitialized().equalsValue(
      this as ChatEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatEntityMapper.ensureInitialized().hashValue(this as ChatEntity);
  }
}

extension ChatEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatEntity, $Out> {
  ChatEntityCopyWith<$R, ChatEntity, $Out> get $asChatEntity =>
      $base.as((v, t, t2) => _ChatEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatEntityCopyWith<$R, $In extends ChatEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get participants;
  $R call({
    String? chatId,
    String? matchId,
    List<String>? participants,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
  });
  ChatEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatEntity, $Out>
    implements ChatEntityCopyWith<$R, ChatEntity, $Out> {
  _ChatEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatEntity> $mapper =
      ChatEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participants => ListCopyWith(
    $value.participants,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(participants: v),
  );
  @override
  $R call({
    String? chatId,
    String? matchId,
    List<String>? participants,
    Object? lastMessage = $none,
    Object? lastMessageAt = $none,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (chatId != null) #chatId: chatId,
      if (matchId != null) #matchId: matchId,
      if (participants != null) #participants: participants,
      if (lastMessage != $none) #lastMessage: lastMessage,
      if (lastMessageAt != $none) #lastMessageAt: lastMessageAt,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  ChatEntity $make(CopyWithData data) => ChatEntity(
    chatId: data.get(#chatId, or: $value.chatId),
    matchId: data.get(#matchId, or: $value.matchId),
    participants: data.get(#participants, or: $value.participants),
    lastMessage: data.get(#lastMessage, or: $value.lastMessage),
    lastMessageAt: data.get(#lastMessageAt, or: $value.lastMessageAt),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  ChatEntityCopyWith<$R2, ChatEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

