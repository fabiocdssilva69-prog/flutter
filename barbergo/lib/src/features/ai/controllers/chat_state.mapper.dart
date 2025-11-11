// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_state.dart';

class ChatStateDataMapper extends ClassMapperBase<ChatStateData> {
  ChatStateDataMapper._();

  static ChatStateDataMapper? _instance;
  static ChatStateDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatStateDataMapper._());
      ChatMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatStateData';

  static List<ChatMessage> _$messages(ChatStateData v) => v.messages;
  static const Field<ChatStateData, List<ChatMessage>> _f$messages = Field(
    'messages',
    _$messages,
  );
  static bool _$hasMore(ChatStateData v) => v.hasMore;
  static const Field<ChatStateData, bool> _f$hasMore = Field(
    'hasMore',
    _$hasMore,
  );
  static bool _$isLoadingMore(ChatStateData v) => v.isLoadingMore;
  static const Field<ChatStateData, bool> _f$isLoadingMore = Field(
    'isLoadingMore',
    _$isLoadingMore,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ChatStateData> fields = const {
    #messages: _f$messages,
    #hasMore: _f$hasMore,
    #isLoadingMore: _f$isLoadingMore,
  };

  static ChatStateData _instantiate(DecodingData data) {
    return ChatStateData(
      messages: data.dec(_f$messages),
      hasMore: data.dec(_f$hasMore),
      isLoadingMore: data.dec(_f$isLoadingMore),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatStateData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatStateData>(map);
  }

  static ChatStateData fromJson(String json) {
    return ensureInitialized().decodeJson<ChatStateData>(json);
  }
}

mixin ChatStateDataMappable {
  String toJson() {
    return ChatStateDataMapper.ensureInitialized().encodeJson<ChatStateData>(
      this as ChatStateData,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatStateDataMapper.ensureInitialized().encodeMap<ChatStateData>(
      this as ChatStateData,
    );
  }

  ChatStateDataCopyWith<ChatStateData, ChatStateData, ChatStateData>
  get copyWith => _ChatStateDataCopyWithImpl<ChatStateData, ChatStateData>(
    this as ChatStateData,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ChatStateDataMapper.ensureInitialized().stringifyValue(
      this as ChatStateData,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatStateDataMapper.ensureInitialized().equalsValue(
      this as ChatStateData,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatStateDataMapper.ensureInitialized().hashValue(
      this as ChatStateData,
    );
  }
}

extension ChatStateDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatStateData, $Out> {
  ChatStateDataCopyWith<$R, ChatStateData, $Out> get $asChatStateData =>
      $base.as((v, t, t2) => _ChatStateDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatStateDataCopyWith<$R, $In extends ChatStateData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ChatMessage,
    ChatMessageCopyWith<$R, ChatMessage, ChatMessage>
  >
  get messages;
  $R call({List<ChatMessage>? messages, bool? hasMore, bool? isLoadingMore});
  ChatStateDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatStateDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatStateData, $Out>
    implements ChatStateDataCopyWith<$R, ChatStateData, $Out> {
  _ChatStateDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatStateData> $mapper =
      ChatStateDataMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ChatMessage,
    ChatMessageCopyWith<$R, ChatMessage, ChatMessage>
  >
  get messages => ListCopyWith(
    $value.messages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(messages: v),
  );
  @override
  $R call({List<ChatMessage>? messages, bool? hasMore, bool? isLoadingMore}) =>
      $apply(
        FieldCopyWithData({
          if (messages != null) #messages: messages,
          if (hasMore != null) #hasMore: hasMore,
          if (isLoadingMore != null) #isLoadingMore: isLoadingMore,
        }),
      );
  @override
  ChatStateData $make(CopyWithData data) => ChatStateData(
    messages: data.get(#messages, or: $value.messages),
    hasMore: data.get(#hasMore, or: $value.hasMore),
    isLoadingMore: data.get(#isLoadingMore, or: $value.isLoadingMore),
  );

  @override
  ChatStateDataCopyWith<$R2, ChatStateData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatStateDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

