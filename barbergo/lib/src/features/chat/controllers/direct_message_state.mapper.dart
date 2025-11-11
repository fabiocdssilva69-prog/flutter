// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'direct_message_state.dart';

class DirectMessageStateMapper extends ClassMapperBase<DirectMessageState> {
  DirectMessageStateMapper._();

  static DirectMessageStateMapper? _instance;
  static DirectMessageStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DirectMessageStateMapper._());
      DirectMessageEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DirectMessageState';

  static List<DirectMessageEntity> _$messages(DirectMessageState v) =>
      v.messages;
  static const Field<DirectMessageState, List<DirectMessageEntity>>
  _f$messages = Field('messages', _$messages);
  static bool _$hasMore(DirectMessageState v) => v.hasMore;
  static const Field<DirectMessageState, bool> _f$hasMore = Field(
    'hasMore',
    _$hasMore,
  );
  static bool _$isLoadingMore(DirectMessageState v) => v.isLoadingMore;
  static const Field<DirectMessageState, bool> _f$isLoadingMore = Field(
    'isLoadingMore',
    _$isLoadingMore,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<DirectMessageState> fields = const {
    #messages: _f$messages,
    #hasMore: _f$hasMore,
    #isLoadingMore: _f$isLoadingMore,
  };

  static DirectMessageState _instantiate(DecodingData data) {
    return DirectMessageState(
      messages: data.dec(_f$messages),
      hasMore: data.dec(_f$hasMore),
      isLoadingMore: data.dec(_f$isLoadingMore),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DirectMessageState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DirectMessageState>(map);
  }

  static DirectMessageState fromJson(String json) {
    return ensureInitialized().decodeJson<DirectMessageState>(json);
  }
}

mixin DirectMessageStateMappable {
  String toJson() {
    return DirectMessageStateMapper.ensureInitialized()
        .encodeJson<DirectMessageState>(this as DirectMessageState);
  }

  Map<String, dynamic> toMap() {
    return DirectMessageStateMapper.ensureInitialized()
        .encodeMap<DirectMessageState>(this as DirectMessageState);
  }

  DirectMessageStateCopyWith<
    DirectMessageState,
    DirectMessageState,
    DirectMessageState
  >
  get copyWith =>
      _DirectMessageStateCopyWithImpl<DirectMessageState, DirectMessageState>(
        this as DirectMessageState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DirectMessageStateMapper.ensureInitialized().stringifyValue(
      this as DirectMessageState,
    );
  }

  @override
  bool operator ==(Object other) {
    return DirectMessageStateMapper.ensureInitialized().equalsValue(
      this as DirectMessageState,
      other,
    );
  }

  @override
  int get hashCode {
    return DirectMessageStateMapper.ensureInitialized().hashValue(
      this as DirectMessageState,
    );
  }
}

extension DirectMessageStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DirectMessageState, $Out> {
  DirectMessageStateCopyWith<$R, DirectMessageState, $Out>
  get $asDirectMessageState => $base.as(
    (v, t, t2) => _DirectMessageStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DirectMessageStateCopyWith<
  $R,
  $In extends DirectMessageState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    DirectMessageEntity,
    DirectMessageEntityCopyWith<$R, DirectMessageEntity, DirectMessageEntity>
  >
  get messages;
  $R call({
    List<DirectMessageEntity>? messages,
    bool? hasMore,
    bool? isLoadingMore,
  });
  DirectMessageStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DirectMessageStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DirectMessageState, $Out>
    implements DirectMessageStateCopyWith<$R, DirectMessageState, $Out> {
  _DirectMessageStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DirectMessageState> $mapper =
      DirectMessageStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    DirectMessageEntity,
    DirectMessageEntityCopyWith<$R, DirectMessageEntity, DirectMessageEntity>
  >
  get messages => ListCopyWith(
    $value.messages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(messages: v),
  );
  @override
  $R call({
    List<DirectMessageEntity>? messages,
    bool? hasMore,
    bool? isLoadingMore,
  }) => $apply(
    FieldCopyWithData({
      if (messages != null) #messages: messages,
      if (hasMore != null) #hasMore: hasMore,
      if (isLoadingMore != null) #isLoadingMore: isLoadingMore,
    }),
  );
  @override
  DirectMessageState $make(CopyWithData data) => DirectMessageState(
    messages: data.get(#messages, or: $value.messages),
    hasMore: data.get(#hasMore, or: $value.hasMore),
    isLoadingMore: data.get(#isLoadingMore, or: $value.isLoadingMore),
  );

  @override
  DirectMessageStateCopyWith<$R2, DirectMessageState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DirectMessageStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

