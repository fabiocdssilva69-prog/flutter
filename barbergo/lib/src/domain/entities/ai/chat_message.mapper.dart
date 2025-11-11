// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_message.dart';

class ChatMessageMapper extends ClassMapperBase<ChatMessage> {
  ChatMessageMapper._();

  static ChatMessageMapper? _instance;
  static ChatMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatMessage';

  static String _$id(ChatMessage v) => v.id;
  static const Field<ChatMessage, String> _f$id = Field('id', _$id);
  static MessageRole _$role(ChatMessage v) => v.role;
  static const Field<ChatMessage, MessageRole> _f$role = Field('role', _$role);
  static String _$content(ChatMessage v) => v.content;
  static const Field<ChatMessage, String> _f$content = Field(
    'content',
    _$content,
  );
  static DateTime _$timestamp(ChatMessage v) => v.timestamp;
  static const Field<ChatMessage, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    hook: TimestampHook(),
  );
  static bool _$isError(ChatMessage v) => v.isError;
  static const Field<ChatMessage, bool> _f$isError = Field(
    'isError',
    _$isError,
    opt: true,
    def: false,
  );
  static MessageFeedback _$feedback(ChatMessage v) => v.feedback;
  static const Field<ChatMessage, MessageFeedback> _f$feedback = Field(
    'feedback',
    _$feedback,
    opt: true,
    def: MessageFeedback.none,
  );
  static bool _$isUser(ChatMessage v) => v.isUser;
  static const Field<ChatMessage, bool> _f$isUser = Field(
    'isUser',
    _$isUser,
    mode: FieldMode.member,
  );
  static DateTime _$createdAt(ChatMessage v) => v.createdAt;
  static const Field<ChatMessage, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ChatMessage> fields = const {
    #id: _f$id,
    #role: _f$role,
    #content: _f$content,
    #timestamp: _f$timestamp,
    #isError: _f$isError,
    #feedback: _f$feedback,
    #isUser: _f$isUser,
    #createdAt: _f$createdAt,
  };

  static ChatMessage _instantiate(DecodingData data) {
    return ChatMessage(
      id: data.dec(_f$id),
      role: data.dec(_f$role),
      content: data.dec(_f$content),
      timestamp: data.dec(_f$timestamp),
      isError: data.dec(_f$isError),
      feedback: data.dec(_f$feedback),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatMessage>(map);
  }

  static ChatMessage fromJson(String json) {
    return ensureInitialized().decodeJson<ChatMessage>(json);
  }
}

mixin ChatMessageMappable {
  String toJson() {
    return ChatMessageMapper.ensureInitialized().encodeJson<ChatMessage>(
      this as ChatMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatMessageMapper.ensureInitialized().encodeMap<ChatMessage>(
      this as ChatMessage,
    );
  }

  ChatMessageCopyWith<ChatMessage, ChatMessage, ChatMessage> get copyWith =>
      _ChatMessageCopyWithImpl<ChatMessage, ChatMessage>(
        this as ChatMessage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatMessageMapper.ensureInitialized().stringifyValue(
      this as ChatMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatMessageMapper.ensureInitialized().equalsValue(
      this as ChatMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatMessageMapper.ensureInitialized().hashValue(this as ChatMessage);
  }
}

extension ChatMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatMessage, $Out> {
  ChatMessageCopyWith<$R, ChatMessage, $Out> get $asChatMessage =>
      $base.as((v, t, t2) => _ChatMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatMessageCopyWith<$R, $In extends ChatMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    bool? isError,
    MessageFeedback? feedback,
  });
  ChatMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatMessage, $Out>
    implements ChatMessageCopyWith<$R, ChatMessage, $Out> {
  _ChatMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatMessage> $mapper =
      ChatMessageMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    bool? isError,
    MessageFeedback? feedback,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (role != null) #role: role,
      if (content != null) #content: content,
      if (timestamp != null) #timestamp: timestamp,
      if (isError != null) #isError: isError,
      if (feedback != null) #feedback: feedback,
    }),
  );
  @override
  ChatMessage $make(CopyWithData data) => ChatMessage(
    id: data.get(#id, or: $value.id),
    role: data.get(#role, or: $value.role),
    content: data.get(#content, or: $value.content),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    isError: data.get(#isError, or: $value.isError),
    feedback: data.get(#feedback, or: $value.feedback),
  );

  @override
  ChatMessageCopyWith<$R2, ChatMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

