// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'system_entities.dart';

class AppNotificationMapper extends ClassMapperBase<AppNotification> {
  AppNotificationMapper._();

  static AppNotificationMapper? _instance;
  static AppNotificationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppNotificationMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AppNotification';

  static String _$notificationId(AppNotification v) => v.notificationId;
  static const Field<AppNotification, String> _f$notificationId = Field(
    'notificationId',
    _$notificationId,
  );
  static String _$userId(AppNotification v) => v.userId;
  static const Field<AppNotification, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static NotificationType _$type(AppNotification v) => v.type;
  static const Field<AppNotification, NotificationType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$title(AppNotification v) => v.title;
  static const Field<AppNotification, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$body(AppNotification v) => v.body;
  static const Field<AppNotification, String> _f$body = Field('body', _$body);
  static Map<String, dynamic> _$data(AppNotification v) => v.data;
  static const Field<AppNotification, Map<String, dynamic>> _f$data = Field(
    'data',
    _$data,
    opt: true,
    def: const {},
  );
  static bool _$isRead(AppNotification v) => v.isRead;
  static const Field<AppNotification, bool> _f$isRead = Field(
    'isRead',
    _$isRead,
    opt: true,
    def: false,
  );
  static DateTime _$createdAt(AppNotification v) => v.createdAt;
  static const Field<AppNotification, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime? _$readAt(AppNotification v) => v.readAt;
  static const Field<AppNotification, DateTime> _f$readAt = Field(
    'readAt',
    _$readAt,
    opt: true,
  );
  static String? _$actionUrl(AppNotification v) => v.actionUrl;
  static const Field<AppNotification, String> _f$actionUrl = Field(
    'actionUrl',
    _$actionUrl,
    opt: true,
  );
  static NotificationPriority _$priority(AppNotification v) => v.priority;
  static const Field<AppNotification, NotificationPriority> _f$priority = Field(
    'priority',
    _$priority,
    opt: true,
    def: NotificationPriority.normal,
  );

  @override
  final MappableFields<AppNotification> fields = const {
    #notificationId: _f$notificationId,
    #userId: _f$userId,
    #type: _f$type,
    #title: _f$title,
    #body: _f$body,
    #data: _f$data,
    #isRead: _f$isRead,
    #createdAt: _f$createdAt,
    #readAt: _f$readAt,
    #actionUrl: _f$actionUrl,
    #priority: _f$priority,
  };

  static AppNotification _instantiate(DecodingData data) {
    return AppNotification(
      notificationId: data.dec(_f$notificationId),
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      title: data.dec(_f$title),
      body: data.dec(_f$body),
      data: data.dec(_f$data),
      isRead: data.dec(_f$isRead),
      createdAt: data.dec(_f$createdAt),
      readAt: data.dec(_f$readAt),
      actionUrl: data.dec(_f$actionUrl),
      priority: data.dec(_f$priority),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppNotification fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppNotification>(map);
  }

  static AppNotification fromJson(String json) {
    return ensureInitialized().decodeJson<AppNotification>(json);
  }
}

mixin AppNotificationMappable {
  String toJson() {
    return AppNotificationMapper.ensureInitialized()
        .encodeJson<AppNotification>(this as AppNotification);
  }

  Map<String, dynamic> toMap() {
    return AppNotificationMapper.ensureInitialized().encodeMap<AppNotification>(
      this as AppNotification,
    );
  }

  AppNotificationCopyWith<AppNotification, AppNotification, AppNotification>
  get copyWith =>
      _AppNotificationCopyWithImpl<AppNotification, AppNotification>(
        this as AppNotification,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AppNotificationMapper.ensureInitialized().stringifyValue(
      this as AppNotification,
    );
  }

  @override
  bool operator ==(Object other) {
    return AppNotificationMapper.ensureInitialized().equalsValue(
      this as AppNotification,
      other,
    );
  }

  @override
  int get hashCode {
    return AppNotificationMapper.ensureInitialized().hashValue(
      this as AppNotification,
    );
  }
}

extension AppNotificationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AppNotification, $Out> {
  AppNotificationCopyWith<$R, AppNotification, $Out> get $asAppNotification =>
      $base.as((v, t, t2) => _AppNotificationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppNotificationCopyWith<$R, $In extends AppNotification, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get data;
  $R call({
    String? notificationId,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
    String? actionUrl,
    NotificationPriority? priority,
  });
  AppNotificationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AppNotificationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppNotification, $Out>
    implements AppNotificationCopyWith<$R, AppNotification, $Out> {
  _AppNotificationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppNotification> $mapper =
      AppNotificationMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get data => MapCopyWith(
    $value.data,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(data: v),
  );
  @override
  $R call({
    String? notificationId,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
    Object? readAt = $none,
    Object? actionUrl = $none,
    NotificationPriority? priority,
  }) => $apply(
    FieldCopyWithData({
      if (notificationId != null) #notificationId: notificationId,
      if (userId != null) #userId: userId,
      if (type != null) #type: type,
      if (title != null) #title: title,
      if (body != null) #body: body,
      if (data != null) #data: data,
      if (isRead != null) #isRead: isRead,
      if (createdAt != null) #createdAt: createdAt,
      if (readAt != $none) #readAt: readAt,
      if (actionUrl != $none) #actionUrl: actionUrl,
      if (priority != null) #priority: priority,
    }),
  );
  @override
  AppNotification $make(CopyWithData data) => AppNotification(
    notificationId: data.get(#notificationId, or: $value.notificationId),
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    title: data.get(#title, or: $value.title),
    body: data.get(#body, or: $value.body),
    data: data.get(#data, or: $value.data),
    isRead: data.get(#isRead, or: $value.isRead),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    readAt: data.get(#readAt, or: $value.readAt),
    actionUrl: data.get(#actionUrl, or: $value.actionUrl),
    priority: data.get(#priority, or: $value.priority),
  );

  @override
  AppNotificationCopyWith<$R2, AppNotification, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppNotificationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AppRouteMapper extends ClassMapperBase<AppRoute> {
  AppRouteMapper._();

  static AppRouteMapper? _instance;
  static AppRouteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppRouteMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AppRoute';

  static String _$path(AppRoute v) => v.path;
  static const Field<AppRoute, String> _f$path = Field('path', _$path);
  static String _$name(AppRoute v) => v.name;
  static const Field<AppRoute, String> _f$name = Field('name', _$name);
  static bool _$requiresAuth(AppRoute v) => v.requiresAuth;
  static const Field<AppRoute, bool> _f$requiresAuth = Field(
    'requiresAuth',
    _$requiresAuth,
    opt: true,
    def: false,
  );
  static bool _$requiresPremium(AppRoute v) => v.requiresPremium;
  static const Field<AppRoute, bool> _f$requiresPremium = Field(
    'requiresPremium',
    _$requiresPremium,
    opt: true,
    def: false,
  );
  static Map<String, dynamic> _$arguments(AppRoute v) => v.arguments;
  static const Field<AppRoute, Map<String, dynamic>> _f$arguments = Field(
    'arguments',
    _$arguments,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<AppRoute> fields = const {
    #path: _f$path,
    #name: _f$name,
    #requiresAuth: _f$requiresAuth,
    #requiresPremium: _f$requiresPremium,
    #arguments: _f$arguments,
  };

  static AppRoute _instantiate(DecodingData data) {
    return AppRoute(
      path: data.dec(_f$path),
      name: data.dec(_f$name),
      requiresAuth: data.dec(_f$requiresAuth),
      requiresPremium: data.dec(_f$requiresPremium),
      arguments: data.dec(_f$arguments),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppRoute fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppRoute>(map);
  }

  static AppRoute fromJson(String json) {
    return ensureInitialized().decodeJson<AppRoute>(json);
  }
}

mixin AppRouteMappable {
  String toJson() {
    return AppRouteMapper.ensureInitialized().encodeJson<AppRoute>(
      this as AppRoute,
    );
  }

  Map<String, dynamic> toMap() {
    return AppRouteMapper.ensureInitialized().encodeMap<AppRoute>(
      this as AppRoute,
    );
  }

  AppRouteCopyWith<AppRoute, AppRoute, AppRoute> get copyWith =>
      _AppRouteCopyWithImpl<AppRoute, AppRoute>(
        this as AppRoute,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AppRouteMapper.ensureInitialized().stringifyValue(this as AppRoute);
  }

  @override
  bool operator ==(Object other) {
    return AppRouteMapper.ensureInitialized().equalsValue(
      this as AppRoute,
      other,
    );
  }

  @override
  int get hashCode {
    return AppRouteMapper.ensureInitialized().hashValue(this as AppRoute);
  }
}

extension AppRouteValueCopy<$R, $Out> on ObjectCopyWith<$R, AppRoute, $Out> {
  AppRouteCopyWith<$R, AppRoute, $Out> get $asAppRoute =>
      $base.as((v, t, t2) => _AppRouteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppRouteCopyWith<$R, $In extends AppRoute, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get arguments;
  $R call({
    String? path,
    String? name,
    bool? requiresAuth,
    bool? requiresPremium,
    Map<String, dynamic>? arguments,
  });
  AppRouteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AppRouteCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppRoute, $Out>
    implements AppRouteCopyWith<$R, AppRoute, $Out> {
  _AppRouteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppRoute> $mapper =
      AppRouteMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get arguments => MapCopyWith(
    $value.arguments,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(arguments: v),
  );
  @override
  $R call({
    String? path,
    String? name,
    bool? requiresAuth,
    bool? requiresPremium,
    Map<String, dynamic>? arguments,
  }) => $apply(
    FieldCopyWithData({
      if (path != null) #path: path,
      if (name != null) #name: name,
      if (requiresAuth != null) #requiresAuth: requiresAuth,
      if (requiresPremium != null) #requiresPremium: requiresPremium,
      if (arguments != null) #arguments: arguments,
    }),
  );
  @override
  AppRoute $make(CopyWithData data) => AppRoute(
    path: data.get(#path, or: $value.path),
    name: data.get(#name, or: $value.name),
    requiresAuth: data.get(#requiresAuth, or: $value.requiresAuth),
    requiresPremium: data.get(#requiresPremium, or: $value.requiresPremium),
    arguments: data.get(#arguments, or: $value.arguments),
  );

  @override
  AppRouteCopyWith<$R2, AppRoute, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppRouteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class OnboardingProgressMapper extends ClassMapperBase<OnboardingProgress> {
  OnboardingProgressMapper._();

  static OnboardingProgressMapper? _instance;
  static OnboardingProgressMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OnboardingProgressMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'OnboardingProgress';

  static String _$userId(OnboardingProgress v) => v.userId;
  static const Field<OnboardingProgress, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static List<OnboardingStep> _$completedSteps(OnboardingProgress v) =>
      v.completedSteps;
  static const Field<OnboardingProgress, List<OnboardingStep>>
  _f$completedSteps = Field(
    'completedSteps',
    _$completedSteps,
    opt: true,
    def: const [],
  );
  static OnboardingStep? _$currentStep(OnboardingProgress v) => v.currentStep;
  static const Field<OnboardingProgress, OnboardingStep> _f$currentStep = Field(
    'currentStep',
    _$currentStep,
    opt: true,
  );
  static double _$progressPercentage(OnboardingProgress v) =>
      v.progressPercentage;
  static const Field<OnboardingProgress, double> _f$progressPercentage = Field(
    'progressPercentage',
    _$progressPercentage,
    opt: true,
    def: 0,
  );
  static DateTime _$startedAt(OnboardingProgress v) => v.startedAt;
  static const Field<OnboardingProgress, DateTime> _f$startedAt = Field(
    'startedAt',
    _$startedAt,
  );
  static DateTime? _$completedAt(OnboardingProgress v) => v.completedAt;
  static const Field<OnboardingProgress, DateTime> _f$completedAt = Field(
    'completedAt',
    _$completedAt,
    opt: true,
  );

  @override
  final MappableFields<OnboardingProgress> fields = const {
    #userId: _f$userId,
    #completedSteps: _f$completedSteps,
    #currentStep: _f$currentStep,
    #progressPercentage: _f$progressPercentage,
    #startedAt: _f$startedAt,
    #completedAt: _f$completedAt,
  };

  static OnboardingProgress _instantiate(DecodingData data) {
    return OnboardingProgress(
      userId: data.dec(_f$userId),
      completedSteps: data.dec(_f$completedSteps),
      currentStep: data.dec(_f$currentStep),
      progressPercentage: data.dec(_f$progressPercentage),
      startedAt: data.dec(_f$startedAt),
      completedAt: data.dec(_f$completedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static OnboardingProgress fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OnboardingProgress>(map);
  }

  static OnboardingProgress fromJson(String json) {
    return ensureInitialized().decodeJson<OnboardingProgress>(json);
  }
}

mixin OnboardingProgressMappable {
  String toJson() {
    return OnboardingProgressMapper.ensureInitialized()
        .encodeJson<OnboardingProgress>(this as OnboardingProgress);
  }

  Map<String, dynamic> toMap() {
    return OnboardingProgressMapper.ensureInitialized()
        .encodeMap<OnboardingProgress>(this as OnboardingProgress);
  }

  OnboardingProgressCopyWith<
    OnboardingProgress,
    OnboardingProgress,
    OnboardingProgress
  >
  get copyWith =>
      _OnboardingProgressCopyWithImpl<OnboardingProgress, OnboardingProgress>(
        this as OnboardingProgress,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return OnboardingProgressMapper.ensureInitialized().stringifyValue(
      this as OnboardingProgress,
    );
  }

  @override
  bool operator ==(Object other) {
    return OnboardingProgressMapper.ensureInitialized().equalsValue(
      this as OnboardingProgress,
      other,
    );
  }

  @override
  int get hashCode {
    return OnboardingProgressMapper.ensureInitialized().hashValue(
      this as OnboardingProgress,
    );
  }
}

extension OnboardingProgressValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OnboardingProgress, $Out> {
  OnboardingProgressCopyWith<$R, OnboardingProgress, $Out>
  get $asOnboardingProgress => $base.as(
    (v, t, t2) => _OnboardingProgressCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class OnboardingProgressCopyWith<
  $R,
  $In extends OnboardingProgress,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    OnboardingStep,
    ObjectCopyWith<$R, OnboardingStep, OnboardingStep>
  >
  get completedSteps;
  $R call({
    String? userId,
    List<OnboardingStep>? completedSteps,
    OnboardingStep? currentStep,
    double? progressPercentage,
    DateTime? startedAt,
    DateTime? completedAt,
  });
  OnboardingProgressCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _OnboardingProgressCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OnboardingProgress, $Out>
    implements OnboardingProgressCopyWith<$R, OnboardingProgress, $Out> {
  _OnboardingProgressCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OnboardingProgress> $mapper =
      OnboardingProgressMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    OnboardingStep,
    ObjectCopyWith<$R, OnboardingStep, OnboardingStep>
  >
  get completedSteps => ListCopyWith(
    $value.completedSteps,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(completedSteps: v),
  );
  @override
  $R call({
    String? userId,
    List<OnboardingStep>? completedSteps,
    Object? currentStep = $none,
    double? progressPercentage,
    DateTime? startedAt,
    Object? completedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (completedSteps != null) #completedSteps: completedSteps,
      if (currentStep != $none) #currentStep: currentStep,
      if (progressPercentage != null) #progressPercentage: progressPercentage,
      if (startedAt != null) #startedAt: startedAt,
      if (completedAt != $none) #completedAt: completedAt,
    }),
  );
  @override
  OnboardingProgress $make(CopyWithData data) => OnboardingProgress(
    userId: data.get(#userId, or: $value.userId),
    completedSteps: data.get(#completedSteps, or: $value.completedSteps),
    currentStep: data.get(#currentStep, or: $value.currentStep),
    progressPercentage: data.get(
      #progressPercentage,
      or: $value.progressPercentage,
    ),
    startedAt: data.get(#startedAt, or: $value.startedAt),
    completedAt: data.get(#completedAt, or: $value.completedAt),
  );

  @override
  OnboardingProgressCopyWith<$R2, OnboardingProgress, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _OnboardingProgressCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatConversationMapper extends ClassMapperBase<ChatConversation> {
  ChatConversationMapper._();

  static ChatConversationMapper? _instance;
  static ChatConversationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatConversationMapper._());
      ChatMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatConversation';

  static String _$conversationId(ChatConversation v) => v.conversationId;
  static const Field<ChatConversation, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
  );
  static List<String> _$participants(ChatConversation v) => v.participants;
  static const Field<ChatConversation, List<String>> _f$participants = Field(
    'participants',
    _$participants,
  );
  static ChatMessage? _$lastMessage(ChatConversation v) => v.lastMessage;
  static const Field<ChatConversation, ChatMessage> _f$lastMessage = Field(
    'lastMessage',
    _$lastMessage,
    opt: true,
  );
  static int _$unreadCount(ChatConversation v) => v.unreadCount;
  static const Field<ChatConversation, int> _f$unreadCount = Field(
    'unreadCount',
    _$unreadCount,
    opt: true,
    def: 0,
  );
  static bool _$isMuted(ChatConversation v) => v.isMuted;
  static const Field<ChatConversation, bool> _f$isMuted = Field(
    'isMuted',
    _$isMuted,
    opt: true,
    def: false,
  );
  static bool _$isArchived(ChatConversation v) => v.isArchived;
  static const Field<ChatConversation, bool> _f$isArchived = Field(
    'isArchived',
    _$isArchived,
    opt: true,
    def: false,
  );
  static DateTime _$createdAt(ChatConversation v) => v.createdAt;
  static const Field<ChatConversation, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$updatedAt(ChatConversation v) => v.updatedAt;
  static const Field<ChatConversation, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );

  @override
  final MappableFields<ChatConversation> fields = const {
    #conversationId: _f$conversationId,
    #participants: _f$participants,
    #lastMessage: _f$lastMessage,
    #unreadCount: _f$unreadCount,
    #isMuted: _f$isMuted,
    #isArchived: _f$isArchived,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static ChatConversation _instantiate(DecodingData data) {
    return ChatConversation(
      conversationId: data.dec(_f$conversationId),
      participants: data.dec(_f$participants),
      lastMessage: data.dec(_f$lastMessage),
      unreadCount: data.dec(_f$unreadCount),
      isMuted: data.dec(_f$isMuted),
      isArchived: data.dec(_f$isArchived),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatConversation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatConversation>(map);
  }

  static ChatConversation fromJson(String json) {
    return ensureInitialized().decodeJson<ChatConversation>(json);
  }
}

mixin ChatConversationMappable {
  String toJson() {
    return ChatConversationMapper.ensureInitialized()
        .encodeJson<ChatConversation>(this as ChatConversation);
  }

  Map<String, dynamic> toMap() {
    return ChatConversationMapper.ensureInitialized()
        .encodeMap<ChatConversation>(this as ChatConversation);
  }

  ChatConversationCopyWith<ChatConversation, ChatConversation, ChatConversation>
  get copyWith =>
      _ChatConversationCopyWithImpl<ChatConversation, ChatConversation>(
        this as ChatConversation,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatConversationMapper.ensureInitialized().stringifyValue(
      this as ChatConversation,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatConversationMapper.ensureInitialized().equalsValue(
      this as ChatConversation,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatConversationMapper.ensureInitialized().hashValue(
      this as ChatConversation,
    );
  }
}

extension ChatConversationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatConversation, $Out> {
  ChatConversationCopyWith<$R, ChatConversation, $Out>
  get $asChatConversation =>
      $base.as((v, t, t2) => _ChatConversationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatConversationCopyWith<$R, $In extends ChatConversation, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get participants;
  ChatMessageCopyWith<$R, ChatMessage, ChatMessage>? get lastMessage;
  $R call({
    String? conversationId,
    List<String>? participants,
    ChatMessage? lastMessage,
    int? unreadCount,
    bool? isMuted,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  ChatConversationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatConversationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatConversation, $Out>
    implements ChatConversationCopyWith<$R, ChatConversation, $Out> {
  _ChatConversationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatConversation> $mapper =
      ChatConversationMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participants => ListCopyWith(
    $value.participants,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(participants: v),
  );
  @override
  ChatMessageCopyWith<$R, ChatMessage, ChatMessage>? get lastMessage =>
      $value.lastMessage?.copyWith.$chain((v) => call(lastMessage: v));
  @override
  $R call({
    String? conversationId,
    List<String>? participants,
    Object? lastMessage = $none,
    int? unreadCount,
    bool? isMuted,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (conversationId != null) #conversationId: conversationId,
      if (participants != null) #participants: participants,
      if (lastMessage != $none) #lastMessage: lastMessage,
      if (unreadCount != null) #unreadCount: unreadCount,
      if (isMuted != null) #isMuted: isMuted,
      if (isArchived != null) #isArchived: isArchived,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  ChatConversation $make(CopyWithData data) => ChatConversation(
    conversationId: data.get(#conversationId, or: $value.conversationId),
    participants: data.get(#participants, or: $value.participants),
    lastMessage: data.get(#lastMessage, or: $value.lastMessage),
    unreadCount: data.get(#unreadCount, or: $value.unreadCount),
    isMuted: data.get(#isMuted, or: $value.isMuted),
    isArchived: data.get(#isArchived, or: $value.isArchived),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  ChatConversationCopyWith<$R2, ChatConversation, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatConversationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

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

  static String _$messageId(ChatMessage v) => v.messageId;
  static const Field<ChatMessage, String> _f$messageId = Field(
    'messageId',
    _$messageId,
  );
  static String _$conversationId(ChatMessage v) => v.conversationId;
  static const Field<ChatMessage, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
  );
  static String _$senderId(ChatMessage v) => v.senderId;
  static const Field<ChatMessage, String> _f$senderId = Field(
    'senderId',
    _$senderId,
  );
  static MessageType _$type(ChatMessage v) => v.type;
  static const Field<ChatMessage, MessageType> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: MessageType.text,
  );
  static String _$content(ChatMessage v) => v.content;
  static const Field<ChatMessage, String> _f$content = Field(
    'content',
    _$content,
  );
  static List<String> _$attachments(ChatMessage v) => v.attachments;
  static const Field<ChatMessage, List<String>> _f$attachments = Field(
    'attachments',
    _$attachments,
    opt: true,
    def: const [],
  );
  static bool _$isRead(ChatMessage v) => v.isRead;
  static const Field<ChatMessage, bool> _f$isRead = Field(
    'isRead',
    _$isRead,
    opt: true,
    def: false,
  );
  static DateTime _$sentAt(ChatMessage v) => v.sentAt;
  static const Field<ChatMessage, DateTime> _f$sentAt = Field(
    'sentAt',
    _$sentAt,
  );
  static DateTime? _$readAt(ChatMessage v) => v.readAt;
  static const Field<ChatMessage, DateTime> _f$readAt = Field(
    'readAt',
    _$readAt,
    opt: true,
  );
  static DateTime? _$deletedAt(ChatMessage v) => v.deletedAt;
  static const Field<ChatMessage, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    opt: true,
  );
  static String? _$replyToId(ChatMessage v) => v.replyToId;
  static const Field<ChatMessage, String> _f$replyToId = Field(
    'replyToId',
    _$replyToId,
    opt: true,
  );

  @override
  final MappableFields<ChatMessage> fields = const {
    #messageId: _f$messageId,
    #conversationId: _f$conversationId,
    #senderId: _f$senderId,
    #type: _f$type,
    #content: _f$content,
    #attachments: _f$attachments,
    #isRead: _f$isRead,
    #sentAt: _f$sentAt,
    #readAt: _f$readAt,
    #deletedAt: _f$deletedAt,
    #replyToId: _f$replyToId,
  };

  static ChatMessage _instantiate(DecodingData data) {
    return ChatMessage(
      messageId: data.dec(_f$messageId),
      conversationId: data.dec(_f$conversationId),
      senderId: data.dec(_f$senderId),
      type: data.dec(_f$type),
      content: data.dec(_f$content),
      attachments: data.dec(_f$attachments),
      isRead: data.dec(_f$isRead),
      sentAt: data.dec(_f$sentAt),
      readAt: data.dec(_f$readAt),
      deletedAt: data.dec(_f$deletedAt),
      replyToId: data.dec(_f$replyToId),
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get attachments;
  $R call({
    String? messageId,
    String? conversationId,
    String? senderId,
    MessageType? type,
    String? content,
    List<String>? attachments,
    bool? isRead,
    DateTime? sentAt,
    DateTime? readAt,
    DateTime? deletedAt,
    String? replyToId,
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get attachments => ListCopyWith(
    $value.attachments,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(attachments: v),
  );
  @override
  $R call({
    String? messageId,
    String? conversationId,
    String? senderId,
    MessageType? type,
    String? content,
    List<String>? attachments,
    bool? isRead,
    DateTime? sentAt,
    Object? readAt = $none,
    Object? deletedAt = $none,
    Object? replyToId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (messageId != null) #messageId: messageId,
      if (conversationId != null) #conversationId: conversationId,
      if (senderId != null) #senderId: senderId,
      if (type != null) #type: type,
      if (content != null) #content: content,
      if (attachments != null) #attachments: attachments,
      if (isRead != null) #isRead: isRead,
      if (sentAt != null) #sentAt: sentAt,
      if (readAt != $none) #readAt: readAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
      if (replyToId != $none) #replyToId: replyToId,
    }),
  );
  @override
  ChatMessage $make(CopyWithData data) => ChatMessage(
    messageId: data.get(#messageId, or: $value.messageId),
    conversationId: data.get(#conversationId, or: $value.conversationId),
    senderId: data.get(#senderId, or: $value.senderId),
    type: data.get(#type, or: $value.type),
    content: data.get(#content, or: $value.content),
    attachments: data.get(#attachments, or: $value.attachments),
    isRead: data.get(#isRead, or: $value.isRead),
    sentAt: data.get(#sentAt, or: $value.sentAt),
    readAt: data.get(#readAt, or: $value.readAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
    replyToId: data.get(#replyToId, or: $value.replyToId),
  );

  @override
  ChatMessageCopyWith<$R2, ChatMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SearchFiltersMapper extends ClassMapperBase<SearchFilters> {
  SearchFiltersMapper._();

  static SearchFiltersMapper? _instance;
  static SearchFiltersMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SearchFiltersMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SearchFilters';

  static int? _$minAge(SearchFilters v) => v.minAge;
  static const Field<SearchFilters, int> _f$minAge = Field(
    'minAge',
    _$minAge,
    opt: true,
  );
  static int? _$maxAge(SearchFilters v) => v.maxAge;
  static const Field<SearchFilters, int> _f$maxAge = Field(
    'maxAge',
    _$maxAge,
    opt: true,
  );
  static int? _$maxDistance(SearchFilters v) => v.maxDistance;
  static const Field<SearchFilters, int> _f$maxDistance = Field(
    'maxDistance',
    _$maxDistance,
    opt: true,
  );
  static List<String> _$interests(SearchFilters v) => v.interests;
  static const Field<SearchFilters, List<String>> _f$interests = Field(
    'interests',
    _$interests,
    opt: true,
    def: const [],
  );
  static List<String> _$educationLevels(SearchFilters v) => v.educationLevels;
  static const Field<SearchFilters, List<String>> _f$educationLevels = Field(
    'educationLevels',
    _$educationLevels,
    opt: true,
    def: const [],
  );
  static List<String> _$occupations(SearchFilters v) => v.occupations;
  static const Field<SearchFilters, List<String>> _f$occupations = Field(
    'occupations',
    _$occupations,
    opt: true,
    def: const [],
  );
  static List<String> _$relationshipGoals(SearchFilters v) =>
      v.relationshipGoals;
  static const Field<SearchFilters, List<String>> _f$relationshipGoals = Field(
    'relationshipGoals',
    _$relationshipGoals,
    opt: true,
    def: const [],
  );
  static bool _$verifiedOnly(SearchFilters v) => v.verifiedOnly;
  static const Field<SearchFilters, bool> _f$verifiedOnly = Field(
    'verifiedOnly',
    _$verifiedOnly,
    opt: true,
    def: false,
  );
  static bool _$hasPhotos(SearchFilters v) => v.hasPhotos;
  static const Field<SearchFilters, bool> _f$hasPhotos = Field(
    'hasPhotos',
    _$hasPhotos,
    opt: true,
    def: false,
  );
  static bool _$activeRecently(SearchFilters v) => v.activeRecently;
  static const Field<SearchFilters, bool> _f$activeRecently = Field(
    'activeRecently',
    _$activeRecently,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<SearchFilters> fields = const {
    #minAge: _f$minAge,
    #maxAge: _f$maxAge,
    #maxDistance: _f$maxDistance,
    #interests: _f$interests,
    #educationLevels: _f$educationLevels,
    #occupations: _f$occupations,
    #relationshipGoals: _f$relationshipGoals,
    #verifiedOnly: _f$verifiedOnly,
    #hasPhotos: _f$hasPhotos,
    #activeRecently: _f$activeRecently,
  };

  static SearchFilters _instantiate(DecodingData data) {
    return SearchFilters(
      minAge: data.dec(_f$minAge),
      maxAge: data.dec(_f$maxAge),
      maxDistance: data.dec(_f$maxDistance),
      interests: data.dec(_f$interests),
      educationLevels: data.dec(_f$educationLevels),
      occupations: data.dec(_f$occupations),
      relationshipGoals: data.dec(_f$relationshipGoals),
      verifiedOnly: data.dec(_f$verifiedOnly),
      hasPhotos: data.dec(_f$hasPhotos),
      activeRecently: data.dec(_f$activeRecently),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SearchFilters fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SearchFilters>(map);
  }

  static SearchFilters fromJson(String json) {
    return ensureInitialized().decodeJson<SearchFilters>(json);
  }
}

mixin SearchFiltersMappable {
  String toJson() {
    return SearchFiltersMapper.ensureInitialized().encodeJson<SearchFilters>(
      this as SearchFilters,
    );
  }

  Map<String, dynamic> toMap() {
    return SearchFiltersMapper.ensureInitialized().encodeMap<SearchFilters>(
      this as SearchFilters,
    );
  }

  SearchFiltersCopyWith<SearchFilters, SearchFilters, SearchFilters>
  get copyWith => _SearchFiltersCopyWithImpl<SearchFilters, SearchFilters>(
    this as SearchFilters,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SearchFiltersMapper.ensureInitialized().stringifyValue(
      this as SearchFilters,
    );
  }

  @override
  bool operator ==(Object other) {
    return SearchFiltersMapper.ensureInitialized().equalsValue(
      this as SearchFilters,
      other,
    );
  }

  @override
  int get hashCode {
    return SearchFiltersMapper.ensureInitialized().hashValue(
      this as SearchFilters,
    );
  }
}

extension SearchFiltersValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SearchFilters, $Out> {
  SearchFiltersCopyWith<$R, SearchFilters, $Out> get $asSearchFilters =>
      $base.as((v, t, t2) => _SearchFiltersCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SearchFiltersCopyWith<$R, $In extends SearchFilters, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get interests;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get educationLevels;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get occupations;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get relationshipGoals;
  $R call({
    int? minAge,
    int? maxAge,
    int? maxDistance,
    List<String>? interests,
    List<String>? educationLevels,
    List<String>? occupations,
    List<String>? relationshipGoals,
    bool? verifiedOnly,
    bool? hasPhotos,
    bool? activeRecently,
  });
  SearchFiltersCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SearchFiltersCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SearchFilters, $Out>
    implements SearchFiltersCopyWith<$R, SearchFilters, $Out> {
  _SearchFiltersCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SearchFilters> $mapper =
      SearchFiltersMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get interests =>
      ListCopyWith(
        $value.interests,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(interests: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get educationLevels => ListCopyWith(
    $value.educationLevels,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(educationLevels: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get occupations => ListCopyWith(
    $value.occupations,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(occupations: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get relationshipGoals => ListCopyWith(
    $value.relationshipGoals,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(relationshipGoals: v),
  );
  @override
  $R call({
    Object? minAge = $none,
    Object? maxAge = $none,
    Object? maxDistance = $none,
    List<String>? interests,
    List<String>? educationLevels,
    List<String>? occupations,
    List<String>? relationshipGoals,
    bool? verifiedOnly,
    bool? hasPhotos,
    bool? activeRecently,
  }) => $apply(
    FieldCopyWithData({
      if (minAge != $none) #minAge: minAge,
      if (maxAge != $none) #maxAge: maxAge,
      if (maxDistance != $none) #maxDistance: maxDistance,
      if (interests != null) #interests: interests,
      if (educationLevels != null) #educationLevels: educationLevels,
      if (occupations != null) #occupations: occupations,
      if (relationshipGoals != null) #relationshipGoals: relationshipGoals,
      if (verifiedOnly != null) #verifiedOnly: verifiedOnly,
      if (hasPhotos != null) #hasPhotos: hasPhotos,
      if (activeRecently != null) #activeRecently: activeRecently,
    }),
  );
  @override
  SearchFilters $make(CopyWithData data) => SearchFilters(
    minAge: data.get(#minAge, or: $value.minAge),
    maxAge: data.get(#maxAge, or: $value.maxAge),
    maxDistance: data.get(#maxDistance, or: $value.maxDistance),
    interests: data.get(#interests, or: $value.interests),
    educationLevels: data.get(#educationLevels, or: $value.educationLevels),
    occupations: data.get(#occupations, or: $value.occupations),
    relationshipGoals: data.get(
      #relationshipGoals,
      or: $value.relationshipGoals,
    ),
    verifiedOnly: data.get(#verifiedOnly, or: $value.verifiedOnly),
    hasPhotos: data.get(#hasPhotos, or: $value.hasPhotos),
    activeRecently: data.get(#activeRecently, or: $value.activeRecently),
  );

  @override
  SearchFiltersCopyWith<$R2, SearchFilters, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SearchFiltersCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminActionMapper extends ClassMapperBase<AdminAction> {
  AdminActionMapper._();

  static AdminActionMapper? _instance;
  static AdminActionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminActionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AdminAction';

  static String _$actionId(AdminAction v) => v.actionId;
  static const Field<AdminAction, String> _f$actionId = Field(
    'actionId',
    _$actionId,
  );
  static String _$adminId(AdminAction v) => v.adminId;
  static const Field<AdminAction, String> _f$adminId = Field(
    'adminId',
    _$adminId,
  );
  static AdminActionType _$type(AdminAction v) => v.type;
  static const Field<AdminAction, AdminActionType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$targetUserId(AdminAction v) => v.targetUserId;
  static const Field<AdminAction, String> _f$targetUserId = Field(
    'targetUserId',
    _$targetUserId,
  );
  static String _$reason(AdminAction v) => v.reason;
  static const Field<AdminAction, String> _f$reason = Field('reason', _$reason);
  static Map<String, dynamic> _$metadata(AdminAction v) => v.metadata;
  static const Field<AdminAction, Map<String, dynamic>> _f$metadata = Field(
    'metadata',
    _$metadata,
    opt: true,
    def: const {},
  );
  static DateTime _$performedAt(AdminAction v) => v.performedAt;
  static const Field<AdminAction, DateTime> _f$performedAt = Field(
    'performedAt',
    _$performedAt,
  );

  @override
  final MappableFields<AdminAction> fields = const {
    #actionId: _f$actionId,
    #adminId: _f$adminId,
    #type: _f$type,
    #targetUserId: _f$targetUserId,
    #reason: _f$reason,
    #metadata: _f$metadata,
    #performedAt: _f$performedAt,
  };

  static AdminAction _instantiate(DecodingData data) {
    return AdminAction(
      actionId: data.dec(_f$actionId),
      adminId: data.dec(_f$adminId),
      type: data.dec(_f$type),
      targetUserId: data.dec(_f$targetUserId),
      reason: data.dec(_f$reason),
      metadata: data.dec(_f$metadata),
      performedAt: data.dec(_f$performedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminAction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminAction>(map);
  }

  static AdminAction fromJson(String json) {
    return ensureInitialized().decodeJson<AdminAction>(json);
  }
}

mixin AdminActionMappable {
  String toJson() {
    return AdminActionMapper.ensureInitialized().encodeJson<AdminAction>(
      this as AdminAction,
    );
  }

  Map<String, dynamic> toMap() {
    return AdminActionMapper.ensureInitialized().encodeMap<AdminAction>(
      this as AdminAction,
    );
  }

  AdminActionCopyWith<AdminAction, AdminAction, AdminAction> get copyWith =>
      _AdminActionCopyWithImpl<AdminAction, AdminAction>(
        this as AdminAction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AdminActionMapper.ensureInitialized().stringifyValue(
      this as AdminAction,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminActionMapper.ensureInitialized().equalsValue(
      this as AdminAction,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminActionMapper.ensureInitialized().hashValue(this as AdminAction);
  }
}

extension AdminActionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminAction, $Out> {
  AdminActionCopyWith<$R, AdminAction, $Out> get $asAdminAction =>
      $base.as((v, t, t2) => _AdminActionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AdminActionCopyWith<$R, $In extends AdminAction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata;
  $R call({
    String? actionId,
    String? adminId,
    AdminActionType? type,
    String? targetUserId,
    String? reason,
    Map<String, dynamic>? metadata,
    DateTime? performedAt,
  });
  AdminActionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AdminActionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminAction, $Out>
    implements AdminActionCopyWith<$R, AdminAction, $Out> {
  _AdminActionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminAction> $mapper =
      AdminActionMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata => MapCopyWith(
    $value.metadata,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(metadata: v),
  );
  @override
  $R call({
    String? actionId,
    String? adminId,
    AdminActionType? type,
    String? targetUserId,
    String? reason,
    Map<String, dynamic>? metadata,
    DateTime? performedAt,
  }) => $apply(
    FieldCopyWithData({
      if (actionId != null) #actionId: actionId,
      if (adminId != null) #adminId: adminId,
      if (type != null) #type: type,
      if (targetUserId != null) #targetUserId: targetUserId,
      if (reason != null) #reason: reason,
      if (metadata != null) #metadata: metadata,
      if (performedAt != null) #performedAt: performedAt,
    }),
  );
  @override
  AdminAction $make(CopyWithData data) => AdminAction(
    actionId: data.get(#actionId, or: $value.actionId),
    adminId: data.get(#adminId, or: $value.adminId),
    type: data.get(#type, or: $value.type),
    targetUserId: data.get(#targetUserId, or: $value.targetUserId),
    reason: data.get(#reason, or: $value.reason),
    metadata: data.get(#metadata, or: $value.metadata),
    performedAt: data.get(#performedAt, or: $value.performedAt),
  );

  @override
  AdminActionCopyWith<$R2, AdminAction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AdminActionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

