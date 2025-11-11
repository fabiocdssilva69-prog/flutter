// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ai_coach_message.dart';

class AICoachMessageMapper extends ClassMapperBase<AICoachMessage> {
  AICoachMessageMapper._();

  static AICoachMessageMapper? _instance;
  static AICoachMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AICoachMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AICoachMessage';

  static String _$messageId(AICoachMessage v) => v.messageId;
  static const Field<AICoachMessage, String> _f$messageId = Field(
    'messageId',
    _$messageId,
  );
  static String _$userId(AICoachMessage v) => v.userId;
  static const Field<AICoachMessage, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static CoachMessageType _$type(AICoachMessage v) => v.type;
  static const Field<AICoachMessage, CoachMessageType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$content(AICoachMessage v) => v.content;
  static const Field<AICoachMessage, String> _f$content = Field(
    'content',
    _$content,
  );
  static Map<String, dynamic>? _$context(AICoachMessage v) => v.context;
  static const Field<AICoachMessage, Map<String, dynamic>> _f$context = Field(
    'context',
    _$context,
    opt: true,
  );
  static bool _$isRead(AICoachMessage v) => v.isRead;
  static const Field<AICoachMessage, bool> _f$isRead = Field(
    'isRead',
    _$isRead,
    opt: true,
    def: false,
  );
  static DateTime _$createdAt(AICoachMessage v) => v.createdAt;
  static const Field<AICoachMessage, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static int? _$userRating(AICoachMessage v) => v.userRating;
  static const Field<AICoachMessage, int> _f$userRating = Field(
    'userRating',
    _$userRating,
    opt: true,
  );

  @override
  final MappableFields<AICoachMessage> fields = const {
    #messageId: _f$messageId,
    #userId: _f$userId,
    #type: _f$type,
    #content: _f$content,
    #context: _f$context,
    #isRead: _f$isRead,
    #createdAt: _f$createdAt,
    #userRating: _f$userRating,
  };

  static AICoachMessage _instantiate(DecodingData data) {
    return AICoachMessage(
      messageId: data.dec(_f$messageId),
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      content: data.dec(_f$content),
      context: data.dec(_f$context),
      isRead: data.dec(_f$isRead),
      createdAt: data.dec(_f$createdAt),
      userRating: data.dec(_f$userRating),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AICoachMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AICoachMessage>(map);
  }

  static AICoachMessage fromJson(String json) {
    return ensureInitialized().decodeJson<AICoachMessage>(json);
  }
}

mixin AICoachMessageMappable {
  String toJson() {
    return AICoachMessageMapper.ensureInitialized().encodeJson<AICoachMessage>(
      this as AICoachMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return AICoachMessageMapper.ensureInitialized().encodeMap<AICoachMessage>(
      this as AICoachMessage,
    );
  }

  AICoachMessageCopyWith<AICoachMessage, AICoachMessage, AICoachMessage>
  get copyWith => _AICoachMessageCopyWithImpl<AICoachMessage, AICoachMessage>(
    this as AICoachMessage,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return AICoachMessageMapper.ensureInitialized().stringifyValue(
      this as AICoachMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return AICoachMessageMapper.ensureInitialized().equalsValue(
      this as AICoachMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return AICoachMessageMapper.ensureInitialized().hashValue(
      this as AICoachMessage,
    );
  }
}

extension AICoachMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AICoachMessage, $Out> {
  AICoachMessageCopyWith<$R, AICoachMessage, $Out> get $asAICoachMessage =>
      $base.as((v, t, t2) => _AICoachMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AICoachMessageCopyWith<$R, $In extends AICoachMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get context;
  $R call({
    String? messageId,
    String? userId,
    CoachMessageType? type,
    String? content,
    Map<String, dynamic>? context,
    bool? isRead,
    DateTime? createdAt,
    int? userRating,
  });
  AICoachMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AICoachMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AICoachMessage, $Out>
    implements AICoachMessageCopyWith<$R, AICoachMessage, $Out> {
  _AICoachMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AICoachMessage> $mapper =
      AICoachMessageMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get context => $value.context != null
      ? MapCopyWith(
          $value.context!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(context: v),
        )
      : null;
  @override
  $R call({
    String? messageId,
    String? userId,
    CoachMessageType? type,
    String? content,
    Object? context = $none,
    bool? isRead,
    DateTime? createdAt,
    Object? userRating = $none,
  }) => $apply(
    FieldCopyWithData({
      if (messageId != null) #messageId: messageId,
      if (userId != null) #userId: userId,
      if (type != null) #type: type,
      if (content != null) #content: content,
      if (context != $none) #context: context,
      if (isRead != null) #isRead: isRead,
      if (createdAt != null) #createdAt: createdAt,
      if (userRating != $none) #userRating: userRating,
    }),
  );
  @override
  AICoachMessage $make(CopyWithData data) => AICoachMessage(
    messageId: data.get(#messageId, or: $value.messageId),
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    content: data.get(#content, or: $value.content),
    context: data.get(#context, or: $value.context),
    isRead: data.get(#isRead, or: $value.isRead),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    userRating: data.get(#userRating, or: $value.userRating),
  );

  @override
  AICoachMessageCopyWith<$R2, AICoachMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AICoachMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AICoachRequestMapper extends ClassMapperBase<AICoachRequest> {
  AICoachRequestMapper._();

  static AICoachRequestMapper? _instance;
  static AICoachRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AICoachRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AICoachRequest';

  static CoachMessageType _$type(AICoachRequest v) => v.type;
  static const Field<AICoachRequest, CoachMessageType> _f$type = Field(
    'type',
    _$type,
  );
  static Map<String, dynamic> _$context(AICoachRequest v) => v.context;
  static const Field<AICoachRequest, Map<String, dynamic>> _f$context = Field(
    'context',
    _$context,
  );
  static List<String>? _$recentMessages(AICoachRequest v) => v.recentMessages;
  static const Field<AICoachRequest, List<String>> _f$recentMessages = Field(
    'recentMessages',
    _$recentMessages,
    opt: true,
  );

  @override
  final MappableFields<AICoachRequest> fields = const {
    #type: _f$type,
    #context: _f$context,
    #recentMessages: _f$recentMessages,
  };

  static AICoachRequest _instantiate(DecodingData data) {
    return AICoachRequest(
      type: data.dec(_f$type),
      context: data.dec(_f$context),
      recentMessages: data.dec(_f$recentMessages),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AICoachRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AICoachRequest>(map);
  }

  static AICoachRequest fromJson(String json) {
    return ensureInitialized().decodeJson<AICoachRequest>(json);
  }
}

mixin AICoachRequestMappable {
  String toJson() {
    return AICoachRequestMapper.ensureInitialized().encodeJson<AICoachRequest>(
      this as AICoachRequest,
    );
  }

  Map<String, dynamic> toMap() {
    return AICoachRequestMapper.ensureInitialized().encodeMap<AICoachRequest>(
      this as AICoachRequest,
    );
  }

  AICoachRequestCopyWith<AICoachRequest, AICoachRequest, AICoachRequest>
  get copyWith => _AICoachRequestCopyWithImpl<AICoachRequest, AICoachRequest>(
    this as AICoachRequest,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return AICoachRequestMapper.ensureInitialized().stringifyValue(
      this as AICoachRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return AICoachRequestMapper.ensureInitialized().equalsValue(
      this as AICoachRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return AICoachRequestMapper.ensureInitialized().hashValue(
      this as AICoachRequest,
    );
  }
}

extension AICoachRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AICoachRequest, $Out> {
  AICoachRequestCopyWith<$R, AICoachRequest, $Out> get $asAICoachRequest =>
      $base.as((v, t, t2) => _AICoachRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AICoachRequestCopyWith<$R, $In extends AICoachRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get context;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get recentMessages;
  $R call({
    CoachMessageType? type,
    Map<String, dynamic>? context,
    List<String>? recentMessages,
  });
  AICoachRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AICoachRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AICoachRequest, $Out>
    implements AICoachRequestCopyWith<$R, AICoachRequest, $Out> {
  _AICoachRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AICoachRequest> $mapper =
      AICoachRequestMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get context => MapCopyWith(
    $value.context,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(context: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get recentMessages => $value.recentMessages != null
      ? ListCopyWith(
          $value.recentMessages!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(recentMessages: v),
        )
      : null;
  @override
  $R call({
    CoachMessageType? type,
    Map<String, dynamic>? context,
    Object? recentMessages = $none,
  }) => $apply(
    FieldCopyWithData({
      if (type != null) #type: type,
      if (context != null) #context: context,
      if (recentMessages != $none) #recentMessages: recentMessages,
    }),
  );
  @override
  AICoachRequest $make(CopyWithData data) => AICoachRequest(
    type: data.get(#type, or: $value.type),
    context: data.get(#context, or: $value.context),
    recentMessages: data.get(#recentMessages, or: $value.recentMessages),
  );

  @override
  AICoachRequestCopyWith<$R2, AICoachRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AICoachRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

