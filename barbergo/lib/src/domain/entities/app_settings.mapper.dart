// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_settings.dart';

class AppSettingsMapper extends ClassMapperBase<AppSettings> {
  AppSettingsMapper._();

  static AppSettingsMapper? _instance;
  static AppSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppSettingsMapper._());
      NotificationSettingsMapper.ensureInitialized();
      PrivacySettingsMapper.ensureInitialized();
      DiscoverySettingsMapper.ensureInitialized();
      CommunicationSettingsMapper.ensureInitialized();
      AppearanceSettingsMapper.ensureInitialized();
      AccessibilitySettingsMapper.ensureInitialized();
      SecuritySettingsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AppSettings';

  static String _$userId(AppSettings v) => v.userId;
  static const Field<AppSettings, String> _f$userId = Field('userId', _$userId);
  static NotificationSettings _$notifications(AppSettings v) => v.notifications;
  static const Field<AppSettings, NotificationSettings> _f$notifications =
      Field('notifications', _$notifications);
  static PrivacySettings _$privacy(AppSettings v) => v.privacy;
  static const Field<AppSettings, PrivacySettings> _f$privacy = Field(
    'privacy',
    _$privacy,
  );
  static DiscoverySettings _$discovery(AppSettings v) => v.discovery;
  static const Field<AppSettings, DiscoverySettings> _f$discovery = Field(
    'discovery',
    _$discovery,
  );
  static CommunicationSettings _$communication(AppSettings v) =>
      v.communication;
  static const Field<AppSettings, CommunicationSettings> _f$communication =
      Field('communication', _$communication);
  static AppearanceSettings _$appearance(AppSettings v) => v.appearance;
  static const Field<AppSettings, AppearanceSettings> _f$appearance = Field(
    'appearance',
    _$appearance,
  );
  static AccessibilitySettings _$accessibility(AppSettings v) =>
      v.accessibility;
  static const Field<AppSettings, AccessibilitySettings> _f$accessibility =
      Field('accessibility', _$accessibility);
  static SecuritySettings _$security(AppSettings v) => v.security;
  static const Field<AppSettings, SecuritySettings> _f$security = Field(
    'security',
    _$security,
  );
  static DateTime _$updatedAt(AppSettings v) => v.updatedAt;
  static const Field<AppSettings, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );

  @override
  final MappableFields<AppSettings> fields = const {
    #userId: _f$userId,
    #notifications: _f$notifications,
    #privacy: _f$privacy,
    #discovery: _f$discovery,
    #communication: _f$communication,
    #appearance: _f$appearance,
    #accessibility: _f$accessibility,
    #security: _f$security,
    #updatedAt: _f$updatedAt,
  };

  static AppSettings _instantiate(DecodingData data) {
    return AppSettings(
      userId: data.dec(_f$userId),
      notifications: data.dec(_f$notifications),
      privacy: data.dec(_f$privacy),
      discovery: data.dec(_f$discovery),
      communication: data.dec(_f$communication),
      appearance: data.dec(_f$appearance),
      accessibility: data.dec(_f$accessibility),
      security: data.dec(_f$security),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppSettings>(map);
  }

  static AppSettings fromJson(String json) {
    return ensureInitialized().decodeJson<AppSettings>(json);
  }
}

mixin AppSettingsMappable {
  String toJson() {
    return AppSettingsMapper.ensureInitialized().encodeJson<AppSettings>(
      this as AppSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return AppSettingsMapper.ensureInitialized().encodeMap<AppSettings>(
      this as AppSettings,
    );
  }

  AppSettingsCopyWith<AppSettings, AppSettings, AppSettings> get copyWith =>
      _AppSettingsCopyWithImpl<AppSettings, AppSettings>(
        this as AppSettings,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AppSettingsMapper.ensureInitialized().stringifyValue(
      this as AppSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return AppSettingsMapper.ensureInitialized().equalsValue(
      this as AppSettings,
      other,
    );
  }

  @override
  int get hashCode {
    return AppSettingsMapper.ensureInitialized().hashValue(this as AppSettings);
  }
}

extension AppSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AppSettings, $Out> {
  AppSettingsCopyWith<$R, AppSettings, $Out> get $asAppSettings =>
      $base.as((v, t, t2) => _AppSettingsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppSettingsCopyWith<$R, $In extends AppSettings, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  NotificationSettingsCopyWith<$R, NotificationSettings, NotificationSettings>
  get notifications;
  PrivacySettingsCopyWith<$R, PrivacySettings, PrivacySettings> get privacy;
  DiscoverySettingsCopyWith<$R, DiscoverySettings, DiscoverySettings>
  get discovery;
  CommunicationSettingsCopyWith<
    $R,
    CommunicationSettings,
    CommunicationSettings
  >
  get communication;
  AppearanceSettingsCopyWith<$R, AppearanceSettings, AppearanceSettings>
  get appearance;
  AccessibilitySettingsCopyWith<
    $R,
    AccessibilitySettings,
    AccessibilitySettings
  >
  get accessibility;
  SecuritySettingsCopyWith<$R, SecuritySettings, SecuritySettings> get security;
  $R call({
    String? userId,
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    DiscoverySettings? discovery,
    CommunicationSettings? communication,
    AppearanceSettings? appearance,
    AccessibilitySettings? accessibility,
    SecuritySettings? security,
    DateTime? updatedAt,
  });
  AppSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AppSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppSettings, $Out>
    implements AppSettingsCopyWith<$R, AppSettings, $Out> {
  _AppSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppSettings> $mapper =
      AppSettingsMapper.ensureInitialized();
  @override
  NotificationSettingsCopyWith<$R, NotificationSettings, NotificationSettings>
  get notifications =>
      $value.notifications.copyWith.$chain((v) => call(notifications: v));
  @override
  PrivacySettingsCopyWith<$R, PrivacySettings, PrivacySettings> get privacy =>
      $value.privacy.copyWith.$chain((v) => call(privacy: v));
  @override
  DiscoverySettingsCopyWith<$R, DiscoverySettings, DiscoverySettings>
  get discovery => $value.discovery.copyWith.$chain((v) => call(discovery: v));
  @override
  CommunicationSettingsCopyWith<
    $R,
    CommunicationSettings,
    CommunicationSettings
  >
  get communication =>
      $value.communication.copyWith.$chain((v) => call(communication: v));
  @override
  AppearanceSettingsCopyWith<$R, AppearanceSettings, AppearanceSettings>
  get appearance =>
      $value.appearance.copyWith.$chain((v) => call(appearance: v));
  @override
  AccessibilitySettingsCopyWith<
    $R,
    AccessibilitySettings,
    AccessibilitySettings
  >
  get accessibility =>
      $value.accessibility.copyWith.$chain((v) => call(accessibility: v));
  @override
  SecuritySettingsCopyWith<$R, SecuritySettings, SecuritySettings>
  get security => $value.security.copyWith.$chain((v) => call(security: v));
  @override
  $R call({
    String? userId,
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    DiscoverySettings? discovery,
    CommunicationSettings? communication,
    AppearanceSettings? appearance,
    AccessibilitySettings? accessibility,
    SecuritySettings? security,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (notifications != null) #notifications: notifications,
      if (privacy != null) #privacy: privacy,
      if (discovery != null) #discovery: discovery,
      if (communication != null) #communication: communication,
      if (appearance != null) #appearance: appearance,
      if (accessibility != null) #accessibility: accessibility,
      if (security != null) #security: security,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  AppSettings $make(CopyWithData data) => AppSettings(
    userId: data.get(#userId, or: $value.userId),
    notifications: data.get(#notifications, or: $value.notifications),
    privacy: data.get(#privacy, or: $value.privacy),
    discovery: data.get(#discovery, or: $value.discovery),
    communication: data.get(#communication, or: $value.communication),
    appearance: data.get(#appearance, or: $value.appearance),
    accessibility: data.get(#accessibility, or: $value.accessibility),
    security: data.get(#security, or: $value.security),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  AppSettingsCopyWith<$R2, AppSettings, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NotificationSettingsMapper extends ClassMapperBase<NotificationSettings> {
  NotificationSettingsMapper._();

  static NotificationSettingsMapper? _instance;
  static NotificationSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationSettingsMapper._());
      QuietHoursMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationSettings';

  static bool _$enabled(NotificationSettings v) => v.enabled;
  static const Field<NotificationSettings, bool> _f$enabled = Field(
    'enabled',
    _$enabled,
    opt: true,
    def: true,
  );
  static bool _$newMatches(NotificationSettings v) => v.newMatches;
  static const Field<NotificationSettings, bool> _f$newMatches = Field(
    'newMatches',
    _$newMatches,
    opt: true,
    def: true,
  );
  static bool _$newMessages(NotificationSettings v) => v.newMessages;
  static const Field<NotificationSettings, bool> _f$newMessages = Field(
    'newMessages',
    _$newMessages,
    opt: true,
    def: true,
  );
  static bool _$likes(NotificationSettings v) => v.likes;
  static const Field<NotificationSettings, bool> _f$likes = Field(
    'likes',
    _$likes,
    opt: true,
    def: true,
  );
  static bool _$superLikes(NotificationSettings v) => v.superLikes;
  static const Field<NotificationSettings, bool> _f$superLikes = Field(
    'superLikes',
    _$superLikes,
    opt: true,
    def: true,
  );
  static bool _$profileVisits(NotificationSettings v) => v.profileVisits;
  static const Field<NotificationSettings, bool> _f$profileVisits = Field(
    'profileVisits',
    _$profileVisits,
    opt: true,
    def: false,
  );
  static bool _$reminders(NotificationSettings v) => v.reminders;
  static const Field<NotificationSettings, bool> _f$reminders = Field(
    'reminders',
    _$reminders,
    opt: true,
    def: true,
  );
  static bool _$promotions(NotificationSettings v) => v.promotions;
  static const Field<NotificationSettings, bool> _f$promotions = Field(
    'promotions',
    _$promotions,
    opt: true,
    def: false,
  );
  static bool _$soundEnabled(NotificationSettings v) => v.soundEnabled;
  static const Field<NotificationSettings, bool> _f$soundEnabled = Field(
    'soundEnabled',
    _$soundEnabled,
    opt: true,
    def: true,
  );
  static bool _$vibrationEnabled(NotificationSettings v) => v.vibrationEnabled;
  static const Field<NotificationSettings, bool> _f$vibrationEnabled = Field(
    'vibrationEnabled',
    _$vibrationEnabled,
    opt: true,
    def: true,
  );
  static QuietHours? _$quietHours(NotificationSettings v) => v.quietHours;
  static const Field<NotificationSettings, QuietHours> _f$quietHours = Field(
    'quietHours',
    _$quietHours,
    opt: true,
  );

  @override
  final MappableFields<NotificationSettings> fields = const {
    #enabled: _f$enabled,
    #newMatches: _f$newMatches,
    #newMessages: _f$newMessages,
    #likes: _f$likes,
    #superLikes: _f$superLikes,
    #profileVisits: _f$profileVisits,
    #reminders: _f$reminders,
    #promotions: _f$promotions,
    #soundEnabled: _f$soundEnabled,
    #vibrationEnabled: _f$vibrationEnabled,
    #quietHours: _f$quietHours,
  };

  static NotificationSettings _instantiate(DecodingData data) {
    return NotificationSettings(
      enabled: data.dec(_f$enabled),
      newMatches: data.dec(_f$newMatches),
      newMessages: data.dec(_f$newMessages),
      likes: data.dec(_f$likes),
      superLikes: data.dec(_f$superLikes),
      profileVisits: data.dec(_f$profileVisits),
      reminders: data.dec(_f$reminders),
      promotions: data.dec(_f$promotions),
      soundEnabled: data.dec(_f$soundEnabled),
      vibrationEnabled: data.dec(_f$vibrationEnabled),
      quietHours: data.dec(_f$quietHours),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationSettings>(map);
  }

  static NotificationSettings fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationSettings>(json);
  }
}

mixin NotificationSettingsMappable {
  String toJson() {
    return NotificationSettingsMapper.ensureInitialized()
        .encodeJson<NotificationSettings>(this as NotificationSettings);
  }

  Map<String, dynamic> toMap() {
    return NotificationSettingsMapper.ensureInitialized()
        .encodeMap<NotificationSettings>(this as NotificationSettings);
  }

  NotificationSettingsCopyWith<
    NotificationSettings,
    NotificationSettings,
    NotificationSettings
  >
  get copyWith =>
      _NotificationSettingsCopyWithImpl<
        NotificationSettings,
        NotificationSettings
      >(this as NotificationSettings, $identity, $identity);
  @override
  String toString() {
    return NotificationSettingsMapper.ensureInitialized().stringifyValue(
      this as NotificationSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotificationSettingsMapper.ensureInitialized().equalsValue(
      this as NotificationSettings,
      other,
    );
  }

  @override
  int get hashCode {
    return NotificationSettingsMapper.ensureInitialized().hashValue(
      this as NotificationSettings,
    );
  }
}

extension NotificationSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationSettings, $Out> {
  NotificationSettingsCopyWith<$R, NotificationSettings, $Out>
  get $asNotificationSettings => $base.as(
    (v, t, t2) => _NotificationSettingsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class NotificationSettingsCopyWith<
  $R,
  $In extends NotificationSettings,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  QuietHoursCopyWith<$R, QuietHours, QuietHours>? get quietHours;
  $R call({
    bool? enabled,
    bool? newMatches,
    bool? newMessages,
    bool? likes,
    bool? superLikes,
    bool? profileVisits,
    bool? reminders,
    bool? promotions,
    bool? soundEnabled,
    bool? vibrationEnabled,
    QuietHours? quietHours,
  });
  NotificationSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NotificationSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationSettings, $Out>
    implements NotificationSettingsCopyWith<$R, NotificationSettings, $Out> {
  _NotificationSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationSettings> $mapper =
      NotificationSettingsMapper.ensureInitialized();
  @override
  QuietHoursCopyWith<$R, QuietHours, QuietHours>? get quietHours =>
      $value.quietHours?.copyWith.$chain((v) => call(quietHours: v));
  @override
  $R call({
    bool? enabled,
    bool? newMatches,
    bool? newMessages,
    bool? likes,
    bool? superLikes,
    bool? profileVisits,
    bool? reminders,
    bool? promotions,
    bool? soundEnabled,
    bool? vibrationEnabled,
    Object? quietHours = $none,
  }) => $apply(
    FieldCopyWithData({
      if (enabled != null) #enabled: enabled,
      if (newMatches != null) #newMatches: newMatches,
      if (newMessages != null) #newMessages: newMessages,
      if (likes != null) #likes: likes,
      if (superLikes != null) #superLikes: superLikes,
      if (profileVisits != null) #profileVisits: profileVisits,
      if (reminders != null) #reminders: reminders,
      if (promotions != null) #promotions: promotions,
      if (soundEnabled != null) #soundEnabled: soundEnabled,
      if (vibrationEnabled != null) #vibrationEnabled: vibrationEnabled,
      if (quietHours != $none) #quietHours: quietHours,
    }),
  );
  @override
  NotificationSettings $make(CopyWithData data) => NotificationSettings(
    enabled: data.get(#enabled, or: $value.enabled),
    newMatches: data.get(#newMatches, or: $value.newMatches),
    newMessages: data.get(#newMessages, or: $value.newMessages),
    likes: data.get(#likes, or: $value.likes),
    superLikes: data.get(#superLikes, or: $value.superLikes),
    profileVisits: data.get(#profileVisits, or: $value.profileVisits),
    reminders: data.get(#reminders, or: $value.reminders),
    promotions: data.get(#promotions, or: $value.promotions),
    soundEnabled: data.get(#soundEnabled, or: $value.soundEnabled),
    vibrationEnabled: data.get(#vibrationEnabled, or: $value.vibrationEnabled),
    quietHours: data.get(#quietHours, or: $value.quietHours),
  );

  @override
  NotificationSettingsCopyWith<$R2, NotificationSettings, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NotificationSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class QuietHoursMapper extends ClassMapperBase<QuietHours> {
  QuietHoursMapper._();

  static QuietHoursMapper? _instance;
  static QuietHoursMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuietHoursMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'QuietHours';

  static bool _$enabled(QuietHours v) => v.enabled;
  static const Field<QuietHours, bool> _f$enabled = Field(
    'enabled',
    _$enabled,
    opt: true,
    def: false,
  );
  static String _$startTime(QuietHours v) => v.startTime;
  static const Field<QuietHours, String> _f$startTime = Field(
    'startTime',
    _$startTime,
    opt: true,
    def: '22:00',
  );
  static String _$endTime(QuietHours v) => v.endTime;
  static const Field<QuietHours, String> _f$endTime = Field(
    'endTime',
    _$endTime,
    opt: true,
    def: '08:00',
  );

  @override
  final MappableFields<QuietHours> fields = const {
    #enabled: _f$enabled,
    #startTime: _f$startTime,
    #endTime: _f$endTime,
  };

  static QuietHours _instantiate(DecodingData data) {
    return QuietHours(
      enabled: data.dec(_f$enabled),
      startTime: data.dec(_f$startTime),
      endTime: data.dec(_f$endTime),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuietHours fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuietHours>(map);
  }

  static QuietHours fromJson(String json) {
    return ensureInitialized().decodeJson<QuietHours>(json);
  }
}

mixin QuietHoursMappable {
  String toJson() {
    return QuietHoursMapper.ensureInitialized().encodeJson<QuietHours>(
      this as QuietHours,
    );
  }

  Map<String, dynamic> toMap() {
    return QuietHoursMapper.ensureInitialized().encodeMap<QuietHours>(
      this as QuietHours,
    );
  }

  QuietHoursCopyWith<QuietHours, QuietHours, QuietHours> get copyWith =>
      _QuietHoursCopyWithImpl<QuietHours, QuietHours>(
        this as QuietHours,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QuietHoursMapper.ensureInitialized().stringifyValue(
      this as QuietHours,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuietHoursMapper.ensureInitialized().equalsValue(
      this as QuietHours,
      other,
    );
  }

  @override
  int get hashCode {
    return QuietHoursMapper.ensureInitialized().hashValue(this as QuietHours);
  }
}

extension QuietHoursValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuietHours, $Out> {
  QuietHoursCopyWith<$R, QuietHours, $Out> get $asQuietHours =>
      $base.as((v, t, t2) => _QuietHoursCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuietHoursCopyWith<$R, $In extends QuietHours, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? enabled, String? startTime, String? endTime});
  QuietHoursCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuietHoursCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuietHours, $Out>
    implements QuietHoursCopyWith<$R, QuietHours, $Out> {
  _QuietHoursCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuietHours> $mapper =
      QuietHoursMapper.ensureInitialized();
  @override
  $R call({bool? enabled, String? startTime, String? endTime}) => $apply(
    FieldCopyWithData({
      if (enabled != null) #enabled: enabled,
      if (startTime != null) #startTime: startTime,
      if (endTime != null) #endTime: endTime,
    }),
  );
  @override
  QuietHours $make(CopyWithData data) => QuietHours(
    enabled: data.get(#enabled, or: $value.enabled),
    startTime: data.get(#startTime, or: $value.startTime),
    endTime: data.get(#endTime, or: $value.endTime),
  );

  @override
  QuietHoursCopyWith<$R2, QuietHours, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuietHoursCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PrivacySettingsMapper extends ClassMapperBase<PrivacySettings> {
  PrivacySettingsMapper._();

  static PrivacySettingsMapper? _instance;
  static PrivacySettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PrivacySettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PrivacySettings';

  static bool _$showOnlineStatus(PrivacySettings v) => v.showOnlineStatus;
  static const Field<PrivacySettings, bool> _f$showOnlineStatus = Field(
    'showOnlineStatus',
    _$showOnlineStatus,
    opt: true,
    def: true,
  );
  static bool _$showLastSeen(PrivacySettings v) => v.showLastSeen;
  static const Field<PrivacySettings, bool> _f$showLastSeen = Field(
    'showLastSeen',
    _$showLastSeen,
    opt: true,
    def: true,
  );
  static bool _$showReadReceipts(PrivacySettings v) => v.showReadReceipts;
  static const Field<PrivacySettings, bool> _f$showReadReceipts = Field(
    'showReadReceipts',
    _$showReadReceipts,
    opt: true,
    def: true,
  );
  static bool _$showTypingIndicator(PrivacySettings v) => v.showTypingIndicator;
  static const Field<PrivacySettings, bool> _f$showTypingIndicator = Field(
    'showTypingIndicator',
    _$showTypingIndicator,
    opt: true,
    def: true,
  );
  static bool _$showProfileInSearch(PrivacySettings v) => v.showProfileInSearch;
  static const Field<PrivacySettings, bool> _f$showProfileInSearch = Field(
    'showProfileInSearch',
    _$showProfileInSearch,
    opt: true,
    def: true,
  );
  static bool _$allowLocationSharing(PrivacySettings v) =>
      v.allowLocationSharing;
  static const Field<PrivacySettings, bool> _f$allowLocationSharing = Field(
    'allowLocationSharing',
    _$allowLocationSharing,
    opt: true,
    def: true,
  );
  static ProfileVisibility _$profileVisibility(PrivacySettings v) =>
      v.profileVisibility;
  static const Field<PrivacySettings, ProfileVisibility> _f$profileVisibility =
      Field(
        'profileVisibility',
        _$profileVisibility,
        opt: true,
        def: ProfileVisibility.everyone,
      );
  static List<String> _$blockedUsers(PrivacySettings v) => v.blockedUsers;
  static const Field<PrivacySettings, List<String>> _f$blockedUsers = Field(
    'blockedUsers',
    _$blockedUsers,
    opt: true,
    def: const [],
  );
  static bool _$allowDataSharing(PrivacySettings v) => v.allowDataSharing;
  static const Field<PrivacySettings, bool> _f$allowDataSharing = Field(
    'allowDataSharing',
    _$allowDataSharing,
    opt: true,
    def: false,
  );
  static bool _$allowAnalytics(PrivacySettings v) => v.allowAnalytics;
  static const Field<PrivacySettings, bool> _f$allowAnalytics = Field(
    'allowAnalytics',
    _$allowAnalytics,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<PrivacySettings> fields = const {
    #showOnlineStatus: _f$showOnlineStatus,
    #showLastSeen: _f$showLastSeen,
    #showReadReceipts: _f$showReadReceipts,
    #showTypingIndicator: _f$showTypingIndicator,
    #showProfileInSearch: _f$showProfileInSearch,
    #allowLocationSharing: _f$allowLocationSharing,
    #profileVisibility: _f$profileVisibility,
    #blockedUsers: _f$blockedUsers,
    #allowDataSharing: _f$allowDataSharing,
    #allowAnalytics: _f$allowAnalytics,
  };

  static PrivacySettings _instantiate(DecodingData data) {
    return PrivacySettings(
      showOnlineStatus: data.dec(_f$showOnlineStatus),
      showLastSeen: data.dec(_f$showLastSeen),
      showReadReceipts: data.dec(_f$showReadReceipts),
      showTypingIndicator: data.dec(_f$showTypingIndicator),
      showProfileInSearch: data.dec(_f$showProfileInSearch),
      allowLocationSharing: data.dec(_f$allowLocationSharing),
      profileVisibility: data.dec(_f$profileVisibility),
      blockedUsers: data.dec(_f$blockedUsers),
      allowDataSharing: data.dec(_f$allowDataSharing),
      allowAnalytics: data.dec(_f$allowAnalytics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PrivacySettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PrivacySettings>(map);
  }

  static PrivacySettings fromJson(String json) {
    return ensureInitialized().decodeJson<PrivacySettings>(json);
  }
}

mixin PrivacySettingsMappable {
  String toJson() {
    return PrivacySettingsMapper.ensureInitialized()
        .encodeJson<PrivacySettings>(this as PrivacySettings);
  }

  Map<String, dynamic> toMap() {
    return PrivacySettingsMapper.ensureInitialized().encodeMap<PrivacySettings>(
      this as PrivacySettings,
    );
  }

  PrivacySettingsCopyWith<PrivacySettings, PrivacySettings, PrivacySettings>
  get copyWith =>
      _PrivacySettingsCopyWithImpl<PrivacySettings, PrivacySettings>(
        this as PrivacySettings,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PrivacySettingsMapper.ensureInitialized().stringifyValue(
      this as PrivacySettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return PrivacySettingsMapper.ensureInitialized().equalsValue(
      this as PrivacySettings,
      other,
    );
  }

  @override
  int get hashCode {
    return PrivacySettingsMapper.ensureInitialized().hashValue(
      this as PrivacySettings,
    );
  }
}

extension PrivacySettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PrivacySettings, $Out> {
  PrivacySettingsCopyWith<$R, PrivacySettings, $Out> get $asPrivacySettings =>
      $base.as((v, t, t2) => _PrivacySettingsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PrivacySettingsCopyWith<$R, $In extends PrivacySettings, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get blockedUsers;
  $R call({
    bool? showOnlineStatus,
    bool? showLastSeen,
    bool? showReadReceipts,
    bool? showTypingIndicator,
    bool? showProfileInSearch,
    bool? allowLocationSharing,
    ProfileVisibility? profileVisibility,
    List<String>? blockedUsers,
    bool? allowDataSharing,
    bool? allowAnalytics,
  });
  PrivacySettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PrivacySettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PrivacySettings, $Out>
    implements PrivacySettingsCopyWith<$R, PrivacySettings, $Out> {
  _PrivacySettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PrivacySettings> $mapper =
      PrivacySettingsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get blockedUsers => ListCopyWith(
    $value.blockedUsers,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(blockedUsers: v),
  );
  @override
  $R call({
    bool? showOnlineStatus,
    bool? showLastSeen,
    bool? showReadReceipts,
    bool? showTypingIndicator,
    bool? showProfileInSearch,
    bool? allowLocationSharing,
    ProfileVisibility? profileVisibility,
    List<String>? blockedUsers,
    bool? allowDataSharing,
    bool? allowAnalytics,
  }) => $apply(
    FieldCopyWithData({
      if (showOnlineStatus != null) #showOnlineStatus: showOnlineStatus,
      if (showLastSeen != null) #showLastSeen: showLastSeen,
      if (showReadReceipts != null) #showReadReceipts: showReadReceipts,
      if (showTypingIndicator != null)
        #showTypingIndicator: showTypingIndicator,
      if (showProfileInSearch != null)
        #showProfileInSearch: showProfileInSearch,
      if (allowLocationSharing != null)
        #allowLocationSharing: allowLocationSharing,
      if (profileVisibility != null) #profileVisibility: profileVisibility,
      if (blockedUsers != null) #blockedUsers: blockedUsers,
      if (allowDataSharing != null) #allowDataSharing: allowDataSharing,
      if (allowAnalytics != null) #allowAnalytics: allowAnalytics,
    }),
  );
  @override
  PrivacySettings $make(CopyWithData data) => PrivacySettings(
    showOnlineStatus: data.get(#showOnlineStatus, or: $value.showOnlineStatus),
    showLastSeen: data.get(#showLastSeen, or: $value.showLastSeen),
    showReadReceipts: data.get(#showReadReceipts, or: $value.showReadReceipts),
    showTypingIndicator: data.get(
      #showTypingIndicator,
      or: $value.showTypingIndicator,
    ),
    showProfileInSearch: data.get(
      #showProfileInSearch,
      or: $value.showProfileInSearch,
    ),
    allowLocationSharing: data.get(
      #allowLocationSharing,
      or: $value.allowLocationSharing,
    ),
    profileVisibility: data.get(
      #profileVisibility,
      or: $value.profileVisibility,
    ),
    blockedUsers: data.get(#blockedUsers, or: $value.blockedUsers),
    allowDataSharing: data.get(#allowDataSharing, or: $value.allowDataSharing),
    allowAnalytics: data.get(#allowAnalytics, or: $value.allowAnalytics),
  );

  @override
  PrivacySettingsCopyWith<$R2, PrivacySettings, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PrivacySettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DiscoverySettingsMapper extends ClassMapperBase<DiscoverySettings> {
  DiscoverySettingsMapper._();

  static DiscoverySettingsMapper? _instance;
  static DiscoverySettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DiscoverySettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DiscoverySettings';

  static int _$maxDistance(DiscoverySettings v) => v.maxDistance;
  static const Field<DiscoverySettings, int> _f$maxDistance = Field(
    'maxDistance',
    _$maxDistance,
    opt: true,
    def: 50,
  );
  static int _$minAge(DiscoverySettings v) => v.minAge;
  static const Field<DiscoverySettings, int> _f$minAge = Field(
    'minAge',
    _$minAge,
    opt: true,
    def: 18,
  );
  static int _$maxAge(DiscoverySettings v) => v.maxAge;
  static const Field<DiscoverySettings, int> _f$maxAge = Field(
    'maxAge',
    _$maxAge,
    opt: true,
    def: 99,
  );
  static List<String> _$interestedIn(DiscoverySettings v) => v.interestedIn;
  static const Field<DiscoverySettings, List<String>> _f$interestedIn = Field(
    'interestedIn',
    _$interestedIn,
    opt: true,
    def: const [],
  );
  static bool _$showMe(DiscoverySettings v) => v.showMe;
  static const Field<DiscoverySettings, bool> _f$showMe = Field(
    'showMe',
    _$showMe,
    opt: true,
    def: true,
  );
  static bool _$globalMode(DiscoverySettings v) => v.globalMode;
  static const Field<DiscoverySettings, bool> _f$globalMode = Field(
    'globalMode',
    _$globalMode,
    opt: true,
    def: false,
  );
  static String? _$location(DiscoverySettings v) => v.location;
  static const Field<DiscoverySettings, String> _f$location = Field(
    'location',
    _$location,
    opt: true,
  );
  static List<String> _$dealBreakers(DiscoverySettings v) => v.dealBreakers;
  static const Field<DiscoverySettings, List<String>> _f$dealBreakers = Field(
    'dealBreakers',
    _$dealBreakers,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<DiscoverySettings> fields = const {
    #maxDistance: _f$maxDistance,
    #minAge: _f$minAge,
    #maxAge: _f$maxAge,
    #interestedIn: _f$interestedIn,
    #showMe: _f$showMe,
    #globalMode: _f$globalMode,
    #location: _f$location,
    #dealBreakers: _f$dealBreakers,
  };

  static DiscoverySettings _instantiate(DecodingData data) {
    return DiscoverySettings(
      maxDistance: data.dec(_f$maxDistance),
      minAge: data.dec(_f$minAge),
      maxAge: data.dec(_f$maxAge),
      interestedIn: data.dec(_f$interestedIn),
      showMe: data.dec(_f$showMe),
      globalMode: data.dec(_f$globalMode),
      location: data.dec(_f$location),
      dealBreakers: data.dec(_f$dealBreakers),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DiscoverySettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DiscoverySettings>(map);
  }

  static DiscoverySettings fromJson(String json) {
    return ensureInitialized().decodeJson<DiscoverySettings>(json);
  }
}

mixin DiscoverySettingsMappable {
  String toJson() {
    return DiscoverySettingsMapper.ensureInitialized()
        .encodeJson<DiscoverySettings>(this as DiscoverySettings);
  }

  Map<String, dynamic> toMap() {
    return DiscoverySettingsMapper.ensureInitialized()
        .encodeMap<DiscoverySettings>(this as DiscoverySettings);
  }

  DiscoverySettingsCopyWith<
    DiscoverySettings,
    DiscoverySettings,
    DiscoverySettings
  >
  get copyWith =>
      _DiscoverySettingsCopyWithImpl<DiscoverySettings, DiscoverySettings>(
        this as DiscoverySettings,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DiscoverySettingsMapper.ensureInitialized().stringifyValue(
      this as DiscoverySettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return DiscoverySettingsMapper.ensureInitialized().equalsValue(
      this as DiscoverySettings,
      other,
    );
  }

  @override
  int get hashCode {
    return DiscoverySettingsMapper.ensureInitialized().hashValue(
      this as DiscoverySettings,
    );
  }
}

extension DiscoverySettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DiscoverySettings, $Out> {
  DiscoverySettingsCopyWith<$R, DiscoverySettings, $Out>
  get $asDiscoverySettings => $base.as(
    (v, t, t2) => _DiscoverySettingsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DiscoverySettingsCopyWith<
  $R,
  $In extends DiscoverySettings,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get interestedIn;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get dealBreakers;
  $R call({
    int? maxDistance,
    int? minAge,
    int? maxAge,
    List<String>? interestedIn,
    bool? showMe,
    bool? globalMode,
    String? location,
    List<String>? dealBreakers,
  });
  DiscoverySettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DiscoverySettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DiscoverySettings, $Out>
    implements DiscoverySettingsCopyWith<$R, DiscoverySettings, $Out> {
  _DiscoverySettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DiscoverySettings> $mapper =
      DiscoverySettingsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get interestedIn => ListCopyWith(
    $value.interestedIn,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(interestedIn: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get dealBreakers => ListCopyWith(
    $value.dealBreakers,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(dealBreakers: v),
  );
  @override
  $R call({
    int? maxDistance,
    int? minAge,
    int? maxAge,
    List<String>? interestedIn,
    bool? showMe,
    bool? globalMode,
    Object? location = $none,
    List<String>? dealBreakers,
  }) => $apply(
    FieldCopyWithData({
      if (maxDistance != null) #maxDistance: maxDistance,
      if (minAge != null) #minAge: minAge,
      if (maxAge != null) #maxAge: maxAge,
      if (interestedIn != null) #interestedIn: interestedIn,
      if (showMe != null) #showMe: showMe,
      if (globalMode != null) #globalMode: globalMode,
      if (location != $none) #location: location,
      if (dealBreakers != null) #dealBreakers: dealBreakers,
    }),
  );
  @override
  DiscoverySettings $make(CopyWithData data) => DiscoverySettings(
    maxDistance: data.get(#maxDistance, or: $value.maxDistance),
    minAge: data.get(#minAge, or: $value.minAge),
    maxAge: data.get(#maxAge, or: $value.maxAge),
    interestedIn: data.get(#interestedIn, or: $value.interestedIn),
    showMe: data.get(#showMe, or: $value.showMe),
    globalMode: data.get(#globalMode, or: $value.globalMode),
    location: data.get(#location, or: $value.location),
    dealBreakers: data.get(#dealBreakers, or: $value.dealBreakers),
  );

  @override
  DiscoverySettingsCopyWith<$R2, DiscoverySettings, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DiscoverySettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CommunicationSettingsMapper
    extends ClassMapperBase<CommunicationSettings> {
  CommunicationSettingsMapper._();

  static CommunicationSettingsMapper? _instance;
  static CommunicationSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CommunicationSettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CommunicationSettings';

  static bool _$autoReplyEnabled(CommunicationSettings v) => v.autoReplyEnabled;
  static const Field<CommunicationSettings, bool> _f$autoReplyEnabled = Field(
    'autoReplyEnabled',
    _$autoReplyEnabled,
    opt: true,
    def: false,
  );
  static String? _$autoReplyMessage(CommunicationSettings v) =>
      v.autoReplyMessage;
  static const Field<CommunicationSettings, String> _f$autoReplyMessage = Field(
    'autoReplyMessage',
    _$autoReplyMessage,
    opt: true,
  );
  static bool _$allowVoiceCalls(CommunicationSettings v) => v.allowVoiceCalls;
  static const Field<CommunicationSettings, bool> _f$allowVoiceCalls = Field(
    'allowVoiceCalls',
    _$allowVoiceCalls,
    opt: true,
    def: true,
  );
  static bool _$allowVideoCalls(CommunicationSettings v) => v.allowVideoCalls;
  static const Field<CommunicationSettings, bool> _f$allowVideoCalls = Field(
    'allowVideoCalls',
    _$allowVideoCalls,
    opt: true,
    def: true,
  );
  static bool _$allowVoiceMessages(CommunicationSettings v) =>
      v.allowVoiceMessages;
  static const Field<CommunicationSettings, bool> _f$allowVoiceMessages = Field(
    'allowVoiceMessages',
    _$allowVoiceMessages,
    opt: true,
    def: true,
  );
  static bool _$filterExplicitContent(CommunicationSettings v) =>
      v.filterExplicitContent;
  static const Field<CommunicationSettings, bool> _f$filterExplicitContent =
      Field(
        'filterExplicitContent',
        _$filterExplicitContent,
        opt: true,
        def: true,
      );
  static MessagePreference _$messagePreference(CommunicationSettings v) =>
      v.messagePreference;
  static const Field<CommunicationSettings, MessagePreference>
  _f$messagePreference = Field(
    'messagePreference',
    _$messagePreference,
    opt: true,
    def: MessagePreference.everyone,
  );

  @override
  final MappableFields<CommunicationSettings> fields = const {
    #autoReplyEnabled: _f$autoReplyEnabled,
    #autoReplyMessage: _f$autoReplyMessage,
    #allowVoiceCalls: _f$allowVoiceCalls,
    #allowVideoCalls: _f$allowVideoCalls,
    #allowVoiceMessages: _f$allowVoiceMessages,
    #filterExplicitContent: _f$filterExplicitContent,
    #messagePreference: _f$messagePreference,
  };

  static CommunicationSettings _instantiate(DecodingData data) {
    return CommunicationSettings(
      autoReplyEnabled: data.dec(_f$autoReplyEnabled),
      autoReplyMessage: data.dec(_f$autoReplyMessage),
      allowVoiceCalls: data.dec(_f$allowVoiceCalls),
      allowVideoCalls: data.dec(_f$allowVideoCalls),
      allowVoiceMessages: data.dec(_f$allowVoiceMessages),
      filterExplicitContent: data.dec(_f$filterExplicitContent),
      messagePreference: data.dec(_f$messagePreference),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CommunicationSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CommunicationSettings>(map);
  }

  static CommunicationSettings fromJson(String json) {
    return ensureInitialized().decodeJson<CommunicationSettings>(json);
  }
}

mixin CommunicationSettingsMappable {
  String toJson() {
    return CommunicationSettingsMapper.ensureInitialized()
        .encodeJson<CommunicationSettings>(this as CommunicationSettings);
  }

  Map<String, dynamic> toMap() {
    return CommunicationSettingsMapper.ensureInitialized()
        .encodeMap<CommunicationSettings>(this as CommunicationSettings);
  }

  CommunicationSettingsCopyWith<
    CommunicationSettings,
    CommunicationSettings,
    CommunicationSettings
  >
  get copyWith =>
      _CommunicationSettingsCopyWithImpl<
        CommunicationSettings,
        CommunicationSettings
      >(this as CommunicationSettings, $identity, $identity);
  @override
  String toString() {
    return CommunicationSettingsMapper.ensureInitialized().stringifyValue(
      this as CommunicationSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return CommunicationSettingsMapper.ensureInitialized().equalsValue(
      this as CommunicationSettings,
      other,
    );
  }

  @override
  int get hashCode {
    return CommunicationSettingsMapper.ensureInitialized().hashValue(
      this as CommunicationSettings,
    );
  }
}

extension CommunicationSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CommunicationSettings, $Out> {
  CommunicationSettingsCopyWith<$R, CommunicationSettings, $Out>
  get $asCommunicationSettings => $base.as(
    (v, t, t2) => _CommunicationSettingsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CommunicationSettingsCopyWith<
  $R,
  $In extends CommunicationSettings,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    bool? autoReplyEnabled,
    String? autoReplyMessage,
    bool? allowVoiceCalls,
    bool? allowVideoCalls,
    bool? allowVoiceMessages,
    bool? filterExplicitContent,
    MessagePreference? messagePreference,
  });
  CommunicationSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CommunicationSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CommunicationSettings, $Out>
    implements CommunicationSettingsCopyWith<$R, CommunicationSettings, $Out> {
  _CommunicationSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CommunicationSettings> $mapper =
      CommunicationSettingsMapper.ensureInitialized();
  @override
  $R call({
    bool? autoReplyEnabled,
    Object? autoReplyMessage = $none,
    bool? allowVoiceCalls,
    bool? allowVideoCalls,
    bool? allowVoiceMessages,
    bool? filterExplicitContent,
    MessagePreference? messagePreference,
  }) => $apply(
    FieldCopyWithData({
      if (autoReplyEnabled != null) #autoReplyEnabled: autoReplyEnabled,
      if (autoReplyMessage != $none) #autoReplyMessage: autoReplyMessage,
      if (allowVoiceCalls != null) #allowVoiceCalls: allowVoiceCalls,
      if (allowVideoCalls != null) #allowVideoCalls: allowVideoCalls,
      if (allowVoiceMessages != null) #allowVoiceMessages: allowVoiceMessages,
      if (filterExplicitContent != null)
        #filterExplicitContent: filterExplicitContent,
      if (messagePreference != null) #messagePreference: messagePreference,
    }),
  );
  @override
  CommunicationSettings $make(CopyWithData data) => CommunicationSettings(
    autoReplyEnabled: data.get(#autoReplyEnabled, or: $value.autoReplyEnabled),
    autoReplyMessage: data.get(#autoReplyMessage, or: $value.autoReplyMessage),
    allowVoiceCalls: data.get(#allowVoiceCalls, or: $value.allowVoiceCalls),
    allowVideoCalls: data.get(#allowVideoCalls, or: $value.allowVideoCalls),
    allowVoiceMessages: data.get(
      #allowVoiceMessages,
      or: $value.allowVoiceMessages,
    ),
    filterExplicitContent: data.get(
      #filterExplicitContent,
      or: $value.filterExplicitContent,
    ),
    messagePreference: data.get(
      #messagePreference,
      or: $value.messagePreference,
    ),
  );

  @override
  CommunicationSettingsCopyWith<$R2, CommunicationSettings, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CommunicationSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AppearanceSettingsMapper extends ClassMapperBase<AppearanceSettings> {
  AppearanceSettingsMapper._();

  static AppearanceSettingsMapper? _instance;
  static AppearanceSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppearanceSettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AppearanceSettings';

  static ThemeMode _$themeMode(AppearanceSettings v) => v.themeMode;
  static const Field<AppearanceSettings, ThemeMode> _f$themeMode = Field(
    'themeMode',
    _$themeMode,
    opt: true,
    def: ThemeMode.system,
  );
  static String _$language(AppearanceSettings v) => v.language;
  static const Field<AppearanceSettings, String> _f$language = Field(
    'language',
    _$language,
    opt: true,
    def: 'pt-BR',
  );
  static bool _$compactMode(AppearanceSettings v) => v.compactMode;
  static const Field<AppearanceSettings, bool> _f$compactMode = Field(
    'compactMode',
    _$compactMode,
    opt: true,
    def: false,
  );
  static double _$fontSize(AppearanceSettings v) => v.fontSize;
  static const Field<AppearanceSettings, double> _f$fontSize = Field(
    'fontSize',
    _$fontSize,
    opt: true,
    def: 1.0,
  );
  static bool _$showAnimations(AppearanceSettings v) => v.showAnimations;
  static const Field<AppearanceSettings, bool> _f$showAnimations = Field(
    'showAnimations',
    _$showAnimations,
    opt: true,
    def: true,
  );
  static ColorScheme _$colorScheme(AppearanceSettings v) => v.colorScheme;
  static const Field<AppearanceSettings, ColorScheme> _f$colorScheme = Field(
    'colorScheme',
    _$colorScheme,
    opt: true,
    def: ColorScheme.default_,
  );

  @override
  final MappableFields<AppearanceSettings> fields = const {
    #themeMode: _f$themeMode,
    #language: _f$language,
    #compactMode: _f$compactMode,
    #fontSize: _f$fontSize,
    #showAnimations: _f$showAnimations,
    #colorScheme: _f$colorScheme,
  };

  static AppearanceSettings _instantiate(DecodingData data) {
    return AppearanceSettings(
      themeMode: data.dec(_f$themeMode),
      language: data.dec(_f$language),
      compactMode: data.dec(_f$compactMode),
      fontSize: data.dec(_f$fontSize),
      showAnimations: data.dec(_f$showAnimations),
      colorScheme: data.dec(_f$colorScheme),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppearanceSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppearanceSettings>(map);
  }

  static AppearanceSettings fromJson(String json) {
    return ensureInitialized().decodeJson<AppearanceSettings>(json);
  }
}

mixin AppearanceSettingsMappable {
  String toJson() {
    return AppearanceSettingsMapper.ensureInitialized()
        .encodeJson<AppearanceSettings>(this as AppearanceSettings);
  }

  Map<String, dynamic> toMap() {
    return AppearanceSettingsMapper.ensureInitialized()
        .encodeMap<AppearanceSettings>(this as AppearanceSettings);
  }

  AppearanceSettingsCopyWith<
    AppearanceSettings,
    AppearanceSettings,
    AppearanceSettings
  >
  get copyWith =>
      _AppearanceSettingsCopyWithImpl<AppearanceSettings, AppearanceSettings>(
        this as AppearanceSettings,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AppearanceSettingsMapper.ensureInitialized().stringifyValue(
      this as AppearanceSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return AppearanceSettingsMapper.ensureInitialized().equalsValue(
      this as AppearanceSettings,
      other,
    );
  }

  @override
  int get hashCode {
    return AppearanceSettingsMapper.ensureInitialized().hashValue(
      this as AppearanceSettings,
    );
  }
}

extension AppearanceSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AppearanceSettings, $Out> {
  AppearanceSettingsCopyWith<$R, AppearanceSettings, $Out>
  get $asAppearanceSettings => $base.as(
    (v, t, t2) => _AppearanceSettingsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AppearanceSettingsCopyWith<
  $R,
  $In extends AppearanceSettings,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    ThemeMode? themeMode,
    String? language,
    bool? compactMode,
    double? fontSize,
    bool? showAnimations,
    ColorScheme? colorScheme,
  });
  AppearanceSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AppearanceSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppearanceSettings, $Out>
    implements AppearanceSettingsCopyWith<$R, AppearanceSettings, $Out> {
  _AppearanceSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppearanceSettings> $mapper =
      AppearanceSettingsMapper.ensureInitialized();
  @override
  $R call({
    ThemeMode? themeMode,
    String? language,
    bool? compactMode,
    double? fontSize,
    bool? showAnimations,
    ColorScheme? colorScheme,
  }) => $apply(
    FieldCopyWithData({
      if (themeMode != null) #themeMode: themeMode,
      if (language != null) #language: language,
      if (compactMode != null) #compactMode: compactMode,
      if (fontSize != null) #fontSize: fontSize,
      if (showAnimations != null) #showAnimations: showAnimations,
      if (colorScheme != null) #colorScheme: colorScheme,
    }),
  );
  @override
  AppearanceSettings $make(CopyWithData data) => AppearanceSettings(
    themeMode: data.get(#themeMode, or: $value.themeMode),
    language: data.get(#language, or: $value.language),
    compactMode: data.get(#compactMode, or: $value.compactMode),
    fontSize: data.get(#fontSize, or: $value.fontSize),
    showAnimations: data.get(#showAnimations, or: $value.showAnimations),
    colorScheme: data.get(#colorScheme, or: $value.colorScheme),
  );

  @override
  AppearanceSettingsCopyWith<$R2, AppearanceSettings, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppearanceSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AccessibilitySettingsMapper
    extends ClassMapperBase<AccessibilitySettings> {
  AccessibilitySettingsMapper._();

  static AccessibilitySettingsMapper? _instance;
  static AccessibilitySettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AccessibilitySettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AccessibilitySettings';

  static bool _$screenReader(AccessibilitySettings v) => v.screenReader;
  static const Field<AccessibilitySettings, bool> _f$screenReader = Field(
    'screenReader',
    _$screenReader,
    opt: true,
    def: false,
  );
  static bool _$highContrast(AccessibilitySettings v) => v.highContrast;
  static const Field<AccessibilitySettings, bool> _f$highContrast = Field(
    'highContrast',
    _$highContrast,
    opt: true,
    def: false,
  );
  static bool _$reducedMotion(AccessibilitySettings v) => v.reducedMotion;
  static const Field<AccessibilitySettings, bool> _f$reducedMotion = Field(
    'reducedMotion',
    _$reducedMotion,
    opt: true,
    def: false,
  );
  static bool _$largeText(AccessibilitySettings v) => v.largeText;
  static const Field<AccessibilitySettings, bool> _f$largeText = Field(
    'largeText',
    _$largeText,
    opt: true,
    def: false,
  );
  static bool _$hapticFeedback(AccessibilitySettings v) => v.hapticFeedback;
  static const Field<AccessibilitySettings, bool> _f$hapticFeedback = Field(
    'hapticFeedback',
    _$hapticFeedback,
    opt: true,
    def: true,
  );
  static bool _$voiceGuidance(AccessibilitySettings v) => v.voiceGuidance;
  static const Field<AccessibilitySettings, bool> _f$voiceGuidance = Field(
    'voiceGuidance',
    _$voiceGuidance,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<AccessibilitySettings> fields = const {
    #screenReader: _f$screenReader,
    #highContrast: _f$highContrast,
    #reducedMotion: _f$reducedMotion,
    #largeText: _f$largeText,
    #hapticFeedback: _f$hapticFeedback,
    #voiceGuidance: _f$voiceGuidance,
  };

  static AccessibilitySettings _instantiate(DecodingData data) {
    return AccessibilitySettings(
      screenReader: data.dec(_f$screenReader),
      highContrast: data.dec(_f$highContrast),
      reducedMotion: data.dec(_f$reducedMotion),
      largeText: data.dec(_f$largeText),
      hapticFeedback: data.dec(_f$hapticFeedback),
      voiceGuidance: data.dec(_f$voiceGuidance),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AccessibilitySettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AccessibilitySettings>(map);
  }

  static AccessibilitySettings fromJson(String json) {
    return ensureInitialized().decodeJson<AccessibilitySettings>(json);
  }
}

mixin AccessibilitySettingsMappable {
  String toJson() {
    return AccessibilitySettingsMapper.ensureInitialized()
        .encodeJson<AccessibilitySettings>(this as AccessibilitySettings);
  }

  Map<String, dynamic> toMap() {
    return AccessibilitySettingsMapper.ensureInitialized()
        .encodeMap<AccessibilitySettings>(this as AccessibilitySettings);
  }

  AccessibilitySettingsCopyWith<
    AccessibilitySettings,
    AccessibilitySettings,
    AccessibilitySettings
  >
  get copyWith =>
      _AccessibilitySettingsCopyWithImpl<
        AccessibilitySettings,
        AccessibilitySettings
      >(this as AccessibilitySettings, $identity, $identity);
  @override
  String toString() {
    return AccessibilitySettingsMapper.ensureInitialized().stringifyValue(
      this as AccessibilitySettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return AccessibilitySettingsMapper.ensureInitialized().equalsValue(
      this as AccessibilitySettings,
      other,
    );
  }

  @override
  int get hashCode {
    return AccessibilitySettingsMapper.ensureInitialized().hashValue(
      this as AccessibilitySettings,
    );
  }
}

extension AccessibilitySettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AccessibilitySettings, $Out> {
  AccessibilitySettingsCopyWith<$R, AccessibilitySettings, $Out>
  get $asAccessibilitySettings => $base.as(
    (v, t, t2) => _AccessibilitySettingsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AccessibilitySettingsCopyWith<
  $R,
  $In extends AccessibilitySettings,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    bool? screenReader,
    bool? highContrast,
    bool? reducedMotion,
    bool? largeText,
    bool? hapticFeedback,
    bool? voiceGuidance,
  });
  AccessibilitySettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AccessibilitySettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AccessibilitySettings, $Out>
    implements AccessibilitySettingsCopyWith<$R, AccessibilitySettings, $Out> {
  _AccessibilitySettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AccessibilitySettings> $mapper =
      AccessibilitySettingsMapper.ensureInitialized();
  @override
  $R call({
    bool? screenReader,
    bool? highContrast,
    bool? reducedMotion,
    bool? largeText,
    bool? hapticFeedback,
    bool? voiceGuidance,
  }) => $apply(
    FieldCopyWithData({
      if (screenReader != null) #screenReader: screenReader,
      if (highContrast != null) #highContrast: highContrast,
      if (reducedMotion != null) #reducedMotion: reducedMotion,
      if (largeText != null) #largeText: largeText,
      if (hapticFeedback != null) #hapticFeedback: hapticFeedback,
      if (voiceGuidance != null) #voiceGuidance: voiceGuidance,
    }),
  );
  @override
  AccessibilitySettings $make(CopyWithData data) => AccessibilitySettings(
    screenReader: data.get(#screenReader, or: $value.screenReader),
    highContrast: data.get(#highContrast, or: $value.highContrast),
    reducedMotion: data.get(#reducedMotion, or: $value.reducedMotion),
    largeText: data.get(#largeText, or: $value.largeText),
    hapticFeedback: data.get(#hapticFeedback, or: $value.hapticFeedback),
    voiceGuidance: data.get(#voiceGuidance, or: $value.voiceGuidance),
  );

  @override
  AccessibilitySettingsCopyWith<$R2, AccessibilitySettings, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AccessibilitySettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SecuritySettingsMapper extends ClassMapperBase<SecuritySettings> {
  SecuritySettingsMapper._();

  static SecuritySettingsMapper? _instance;
  static SecuritySettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SecuritySettingsMapper._());
      LoginSessionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SecuritySettings';

  static bool _$biometricEnabled(SecuritySettings v) => v.biometricEnabled;
  static const Field<SecuritySettings, bool> _f$biometricEnabled = Field(
    'biometricEnabled',
    _$biometricEnabled,
    opt: true,
    def: false,
  );
  static bool _$requirePinOnOpen(SecuritySettings v) => v.requirePinOnOpen;
  static const Field<SecuritySettings, bool> _f$requirePinOnOpen = Field(
    'requirePinOnOpen',
    _$requirePinOnOpen,
    opt: true,
    def: false,
  );
  static String? _$pin(SecuritySettings v) => v.pin;
  static const Field<SecuritySettings, String> _f$pin = Field(
    'pin',
    _$pin,
    opt: true,
  );
  static bool _$twoFactorEnabled(SecuritySettings v) => v.twoFactorEnabled;
  static const Field<SecuritySettings, bool> _f$twoFactorEnabled = Field(
    'twoFactorEnabled',
    _$twoFactorEnabled,
    opt: true,
    def: false,
  );
  static bool _$loginAlerts(SecuritySettings v) => v.loginAlerts;
  static const Field<SecuritySettings, bool> _f$loginAlerts = Field(
    'loginAlerts',
    _$loginAlerts,
    opt: true,
    def: true,
  );
  static List<LoginSession> _$activeSessions(SecuritySettings v) =>
      v.activeSessions;
  static const Field<SecuritySettings, List<LoginSession>> _f$activeSessions =
      Field('activeSessions', _$activeSessions, opt: true, def: const []);

  @override
  final MappableFields<SecuritySettings> fields = const {
    #biometricEnabled: _f$biometricEnabled,
    #requirePinOnOpen: _f$requirePinOnOpen,
    #pin: _f$pin,
    #twoFactorEnabled: _f$twoFactorEnabled,
    #loginAlerts: _f$loginAlerts,
    #activeSessions: _f$activeSessions,
  };

  static SecuritySettings _instantiate(DecodingData data) {
    return SecuritySettings(
      biometricEnabled: data.dec(_f$biometricEnabled),
      requirePinOnOpen: data.dec(_f$requirePinOnOpen),
      pin: data.dec(_f$pin),
      twoFactorEnabled: data.dec(_f$twoFactorEnabled),
      loginAlerts: data.dec(_f$loginAlerts),
      activeSessions: data.dec(_f$activeSessions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SecuritySettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SecuritySettings>(map);
  }

  static SecuritySettings fromJson(String json) {
    return ensureInitialized().decodeJson<SecuritySettings>(json);
  }
}

mixin SecuritySettingsMappable {
  String toJson() {
    return SecuritySettingsMapper.ensureInitialized()
        .encodeJson<SecuritySettings>(this as SecuritySettings);
  }

  Map<String, dynamic> toMap() {
    return SecuritySettingsMapper.ensureInitialized()
        .encodeMap<SecuritySettings>(this as SecuritySettings);
  }

  SecuritySettingsCopyWith<SecuritySettings, SecuritySettings, SecuritySettings>
  get copyWith =>
      _SecuritySettingsCopyWithImpl<SecuritySettings, SecuritySettings>(
        this as SecuritySettings,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SecuritySettingsMapper.ensureInitialized().stringifyValue(
      this as SecuritySettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return SecuritySettingsMapper.ensureInitialized().equalsValue(
      this as SecuritySettings,
      other,
    );
  }

  @override
  int get hashCode {
    return SecuritySettingsMapper.ensureInitialized().hashValue(
      this as SecuritySettings,
    );
  }
}

extension SecuritySettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SecuritySettings, $Out> {
  SecuritySettingsCopyWith<$R, SecuritySettings, $Out>
  get $asSecuritySettings =>
      $base.as((v, t, t2) => _SecuritySettingsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SecuritySettingsCopyWith<$R, $In extends SecuritySettings, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    LoginSession,
    LoginSessionCopyWith<$R, LoginSession, LoginSession>
  >
  get activeSessions;
  $R call({
    bool? biometricEnabled,
    bool? requirePinOnOpen,
    String? pin,
    bool? twoFactorEnabled,
    bool? loginAlerts,
    List<LoginSession>? activeSessions,
  });
  SecuritySettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SecuritySettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SecuritySettings, $Out>
    implements SecuritySettingsCopyWith<$R, SecuritySettings, $Out> {
  _SecuritySettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SecuritySettings> $mapper =
      SecuritySettingsMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    LoginSession,
    LoginSessionCopyWith<$R, LoginSession, LoginSession>
  >
  get activeSessions => ListCopyWith(
    $value.activeSessions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(activeSessions: v),
  );
  @override
  $R call({
    bool? biometricEnabled,
    bool? requirePinOnOpen,
    Object? pin = $none,
    bool? twoFactorEnabled,
    bool? loginAlerts,
    List<LoginSession>? activeSessions,
  }) => $apply(
    FieldCopyWithData({
      if (biometricEnabled != null) #biometricEnabled: biometricEnabled,
      if (requirePinOnOpen != null) #requirePinOnOpen: requirePinOnOpen,
      if (pin != $none) #pin: pin,
      if (twoFactorEnabled != null) #twoFactorEnabled: twoFactorEnabled,
      if (loginAlerts != null) #loginAlerts: loginAlerts,
      if (activeSessions != null) #activeSessions: activeSessions,
    }),
  );
  @override
  SecuritySettings $make(CopyWithData data) => SecuritySettings(
    biometricEnabled: data.get(#biometricEnabled, or: $value.biometricEnabled),
    requirePinOnOpen: data.get(#requirePinOnOpen, or: $value.requirePinOnOpen),
    pin: data.get(#pin, or: $value.pin),
    twoFactorEnabled: data.get(#twoFactorEnabled, or: $value.twoFactorEnabled),
    loginAlerts: data.get(#loginAlerts, or: $value.loginAlerts),
    activeSessions: data.get(#activeSessions, or: $value.activeSessions),
  );

  @override
  SecuritySettingsCopyWith<$R2, SecuritySettings, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SecuritySettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LoginSessionMapper extends ClassMapperBase<LoginSession> {
  LoginSessionMapper._();

  static LoginSessionMapper? _instance;
  static LoginSessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginSessionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LoginSession';

  static String _$sessionId(LoginSession v) => v.sessionId;
  static const Field<LoginSession, String> _f$sessionId = Field(
    'sessionId',
    _$sessionId,
  );
  static String _$deviceName(LoginSession v) => v.deviceName;
  static const Field<LoginSession, String> _f$deviceName = Field(
    'deviceName',
    _$deviceName,
  );
  static String _$deviceType(LoginSession v) => v.deviceType;
  static const Field<LoginSession, String> _f$deviceType = Field(
    'deviceType',
    _$deviceType,
  );
  static String _$location(LoginSession v) => v.location;
  static const Field<LoginSession, String> _f$location = Field(
    'location',
    _$location,
  );
  static DateTime _$loginTime(LoginSession v) => v.loginTime;
  static const Field<LoginSession, DateTime> _f$loginTime = Field(
    'loginTime',
    _$loginTime,
  );
  static DateTime _$lastActive(LoginSession v) => v.lastActive;
  static const Field<LoginSession, DateTime> _f$lastActive = Field(
    'lastActive',
    _$lastActive,
  );
  static bool _$isCurrent(LoginSession v) => v.isCurrent;
  static const Field<LoginSession, bool> _f$isCurrent = Field(
    'isCurrent',
    _$isCurrent,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<LoginSession> fields = const {
    #sessionId: _f$sessionId,
    #deviceName: _f$deviceName,
    #deviceType: _f$deviceType,
    #location: _f$location,
    #loginTime: _f$loginTime,
    #lastActive: _f$lastActive,
    #isCurrent: _f$isCurrent,
  };

  static LoginSession _instantiate(DecodingData data) {
    return LoginSession(
      sessionId: data.dec(_f$sessionId),
      deviceName: data.dec(_f$deviceName),
      deviceType: data.dec(_f$deviceType),
      location: data.dec(_f$location),
      loginTime: data.dec(_f$loginTime),
      lastActive: data.dec(_f$lastActive),
      isCurrent: data.dec(_f$isCurrent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoginSession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginSession>(map);
  }

  static LoginSession fromJson(String json) {
    return ensureInitialized().decodeJson<LoginSession>(json);
  }
}

mixin LoginSessionMappable {
  String toJson() {
    return LoginSessionMapper.ensureInitialized().encodeJson<LoginSession>(
      this as LoginSession,
    );
  }

  Map<String, dynamic> toMap() {
    return LoginSessionMapper.ensureInitialized().encodeMap<LoginSession>(
      this as LoginSession,
    );
  }

  LoginSessionCopyWith<LoginSession, LoginSession, LoginSession> get copyWith =>
      _LoginSessionCopyWithImpl<LoginSession, LoginSession>(
        this as LoginSession,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LoginSessionMapper.ensureInitialized().stringifyValue(
      this as LoginSession,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoginSessionMapper.ensureInitialized().equalsValue(
      this as LoginSession,
      other,
    );
  }

  @override
  int get hashCode {
    return LoginSessionMapper.ensureInitialized().hashValue(
      this as LoginSession,
    );
  }
}

extension LoginSessionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginSession, $Out> {
  LoginSessionCopyWith<$R, LoginSession, $Out> get $asLoginSession =>
      $base.as((v, t, t2) => _LoginSessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoginSessionCopyWith<$R, $In extends LoginSession, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? sessionId,
    String? deviceName,
    String? deviceType,
    String? location,
    DateTime? loginTime,
    DateTime? lastActive,
    bool? isCurrent,
  });
  LoginSessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoginSessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginSession, $Out>
    implements LoginSessionCopyWith<$R, LoginSession, $Out> {
  _LoginSessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginSession> $mapper =
      LoginSessionMapper.ensureInitialized();
  @override
  $R call({
    String? sessionId,
    String? deviceName,
    String? deviceType,
    String? location,
    DateTime? loginTime,
    DateTime? lastActive,
    bool? isCurrent,
  }) => $apply(
    FieldCopyWithData({
      if (sessionId != null) #sessionId: sessionId,
      if (deviceName != null) #deviceName: deviceName,
      if (deviceType != null) #deviceType: deviceType,
      if (location != null) #location: location,
      if (loginTime != null) #loginTime: loginTime,
      if (lastActive != null) #lastActive: lastActive,
      if (isCurrent != null) #isCurrent: isCurrent,
    }),
  );
  @override
  LoginSession $make(CopyWithData data) => LoginSession(
    sessionId: data.get(#sessionId, or: $value.sessionId),
    deviceName: data.get(#deviceName, or: $value.deviceName),
    deviceType: data.get(#deviceType, or: $value.deviceType),
    location: data.get(#location, or: $value.location),
    loginTime: data.get(#loginTime, or: $value.loginTime),
    lastActive: data.get(#lastActive, or: $value.lastActive),
    isCurrent: data.get(#isCurrent, or: $value.isCurrent),
  );

  @override
  LoginSessionCopyWith<$R2, LoginSession, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoginSessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SupportTicketMapper extends ClassMapperBase<SupportTicket> {
  SupportTicketMapper._();

  static SupportTicketMapper? _instance;
  static SupportTicketMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SupportTicketMapper._());
      SupportMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SupportTicket';

  static String _$ticketId(SupportTicket v) => v.ticketId;
  static const Field<SupportTicket, String> _f$ticketId = Field(
    'ticketId',
    _$ticketId,
  );
  static String _$userId(SupportTicket v) => v.userId;
  static const Field<SupportTicket, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static TicketCategory _$category(SupportTicket v) => v.category;
  static const Field<SupportTicket, TicketCategory> _f$category = Field(
    'category',
    _$category,
  );
  static TicketPriority _$priority(SupportTicket v) => v.priority;
  static const Field<SupportTicket, TicketPriority> _f$priority = Field(
    'priority',
    _$priority,
    opt: true,
    def: TicketPriority.normal,
  );
  static TicketStatus _$status(SupportTicket v) => v.status;
  static const Field<SupportTicket, TicketStatus> _f$status = Field(
    'status',
    _$status,
  );
  static String _$subject(SupportTicket v) => v.subject;
  static const Field<SupportTicket, String> _f$subject = Field(
    'subject',
    _$subject,
  );
  static String _$description(SupportTicket v) => v.description;
  static const Field<SupportTicket, String> _f$description = Field(
    'description',
    _$description,
  );
  static List<SupportMessage> _$messages(SupportTicket v) => v.messages;
  static const Field<SupportTicket, List<SupportMessage>> _f$messages = Field(
    'messages',
    _$messages,
    opt: true,
    def: const [],
  );
  static List<String> _$attachments(SupportTicket v) => v.attachments;
  static const Field<SupportTicket, List<String>> _f$attachments = Field(
    'attachments',
    _$attachments,
    opt: true,
    def: const [],
  );
  static String? _$assignedTo(SupportTicket v) => v.assignedTo;
  static const Field<SupportTicket, String> _f$assignedTo = Field(
    'assignedTo',
    _$assignedTo,
    opt: true,
  );
  static DateTime _$createdAt(SupportTicket v) => v.createdAt;
  static const Field<SupportTicket, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$updatedAt(SupportTicket v) => v.updatedAt;
  static const Field<SupportTicket, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static DateTime? _$resolvedAt(SupportTicket v) => v.resolvedAt;
  static const Field<SupportTicket, DateTime> _f$resolvedAt = Field(
    'resolvedAt',
    _$resolvedAt,
    opt: true,
  );

  @override
  final MappableFields<SupportTicket> fields = const {
    #ticketId: _f$ticketId,
    #userId: _f$userId,
    #category: _f$category,
    #priority: _f$priority,
    #status: _f$status,
    #subject: _f$subject,
    #description: _f$description,
    #messages: _f$messages,
    #attachments: _f$attachments,
    #assignedTo: _f$assignedTo,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #resolvedAt: _f$resolvedAt,
  };

  static SupportTicket _instantiate(DecodingData data) {
    return SupportTicket(
      ticketId: data.dec(_f$ticketId),
      userId: data.dec(_f$userId),
      category: data.dec(_f$category),
      priority: data.dec(_f$priority),
      status: data.dec(_f$status),
      subject: data.dec(_f$subject),
      description: data.dec(_f$description),
      messages: data.dec(_f$messages),
      attachments: data.dec(_f$attachments),
      assignedTo: data.dec(_f$assignedTo),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      resolvedAt: data.dec(_f$resolvedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SupportTicket fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SupportTicket>(map);
  }

  static SupportTicket fromJson(String json) {
    return ensureInitialized().decodeJson<SupportTicket>(json);
  }
}

mixin SupportTicketMappable {
  String toJson() {
    return SupportTicketMapper.ensureInitialized().encodeJson<SupportTicket>(
      this as SupportTicket,
    );
  }

  Map<String, dynamic> toMap() {
    return SupportTicketMapper.ensureInitialized().encodeMap<SupportTicket>(
      this as SupportTicket,
    );
  }

  SupportTicketCopyWith<SupportTicket, SupportTicket, SupportTicket>
  get copyWith => _SupportTicketCopyWithImpl<SupportTicket, SupportTicket>(
    this as SupportTicket,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SupportTicketMapper.ensureInitialized().stringifyValue(
      this as SupportTicket,
    );
  }

  @override
  bool operator ==(Object other) {
    return SupportTicketMapper.ensureInitialized().equalsValue(
      this as SupportTicket,
      other,
    );
  }

  @override
  int get hashCode {
    return SupportTicketMapper.ensureInitialized().hashValue(
      this as SupportTicket,
    );
  }
}

extension SupportTicketValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SupportTicket, $Out> {
  SupportTicketCopyWith<$R, SupportTicket, $Out> get $asSupportTicket =>
      $base.as((v, t, t2) => _SupportTicketCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SupportTicketCopyWith<$R, $In extends SupportTicket, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    SupportMessage,
    SupportMessageCopyWith<$R, SupportMessage, SupportMessage>
  >
  get messages;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get attachments;
  $R call({
    String? ticketId,
    String? userId,
    TicketCategory? category,
    TicketPriority? priority,
    TicketStatus? status,
    String? subject,
    String? description,
    List<SupportMessage>? messages,
    List<String>? attachments,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  });
  SupportTicketCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SupportTicketCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SupportTicket, $Out>
    implements SupportTicketCopyWith<$R, SupportTicket, $Out> {
  _SupportTicketCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SupportTicket> $mapper =
      SupportTicketMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    SupportMessage,
    SupportMessageCopyWith<$R, SupportMessage, SupportMessage>
  >
  get messages => ListCopyWith(
    $value.messages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(messages: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get attachments => ListCopyWith(
    $value.attachments,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(attachments: v),
  );
  @override
  $R call({
    String? ticketId,
    String? userId,
    TicketCategory? category,
    TicketPriority? priority,
    TicketStatus? status,
    String? subject,
    String? description,
    List<SupportMessage>? messages,
    List<String>? attachments,
    Object? assignedTo = $none,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? resolvedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (ticketId != null) #ticketId: ticketId,
      if (userId != null) #userId: userId,
      if (category != null) #category: category,
      if (priority != null) #priority: priority,
      if (status != null) #status: status,
      if (subject != null) #subject: subject,
      if (description != null) #description: description,
      if (messages != null) #messages: messages,
      if (attachments != null) #attachments: attachments,
      if (assignedTo != $none) #assignedTo: assignedTo,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (resolvedAt != $none) #resolvedAt: resolvedAt,
    }),
  );
  @override
  SupportTicket $make(CopyWithData data) => SupportTicket(
    ticketId: data.get(#ticketId, or: $value.ticketId),
    userId: data.get(#userId, or: $value.userId),
    category: data.get(#category, or: $value.category),
    priority: data.get(#priority, or: $value.priority),
    status: data.get(#status, or: $value.status),
    subject: data.get(#subject, or: $value.subject),
    description: data.get(#description, or: $value.description),
    messages: data.get(#messages, or: $value.messages),
    attachments: data.get(#attachments, or: $value.attachments),
    assignedTo: data.get(#assignedTo, or: $value.assignedTo),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    resolvedAt: data.get(#resolvedAt, or: $value.resolvedAt),
  );

  @override
  SupportTicketCopyWith<$R2, SupportTicket, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SupportTicketCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SupportMessageMapper extends ClassMapperBase<SupportMessage> {
  SupportMessageMapper._();

  static SupportMessageMapper? _instance;
  static SupportMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SupportMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SupportMessage';

  static String _$messageId(SupportMessage v) => v.messageId;
  static const Field<SupportMessage, String> _f$messageId = Field(
    'messageId',
    _$messageId,
  );
  static String _$authorId(SupportMessage v) => v.authorId;
  static const Field<SupportMessage, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(SupportMessage v) => v.authorName;
  static const Field<SupportMessage, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static bool _$isStaff(SupportMessage v) => v.isStaff;
  static const Field<SupportMessage, bool> _f$isStaff = Field(
    'isStaff',
    _$isStaff,
    opt: true,
    def: false,
  );
  static String _$content(SupportMessage v) => v.content;
  static const Field<SupportMessage, String> _f$content = Field(
    'content',
    _$content,
  );
  static DateTime _$createdAt(SupportMessage v) => v.createdAt;
  static const Field<SupportMessage, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<SupportMessage> fields = const {
    #messageId: _f$messageId,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #isStaff: _f$isStaff,
    #content: _f$content,
    #createdAt: _f$createdAt,
  };

  static SupportMessage _instantiate(DecodingData data) {
    return SupportMessage(
      messageId: data.dec(_f$messageId),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      isStaff: data.dec(_f$isStaff),
      content: data.dec(_f$content),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SupportMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SupportMessage>(map);
  }

  static SupportMessage fromJson(String json) {
    return ensureInitialized().decodeJson<SupportMessage>(json);
  }
}

mixin SupportMessageMappable {
  String toJson() {
    return SupportMessageMapper.ensureInitialized().encodeJson<SupportMessage>(
      this as SupportMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return SupportMessageMapper.ensureInitialized().encodeMap<SupportMessage>(
      this as SupportMessage,
    );
  }

  SupportMessageCopyWith<SupportMessage, SupportMessage, SupportMessage>
  get copyWith => _SupportMessageCopyWithImpl<SupportMessage, SupportMessage>(
    this as SupportMessage,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SupportMessageMapper.ensureInitialized().stringifyValue(
      this as SupportMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return SupportMessageMapper.ensureInitialized().equalsValue(
      this as SupportMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return SupportMessageMapper.ensureInitialized().hashValue(
      this as SupportMessage,
    );
  }
}

extension SupportMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SupportMessage, $Out> {
  SupportMessageCopyWith<$R, SupportMessage, $Out> get $asSupportMessage =>
      $base.as((v, t, t2) => _SupportMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SupportMessageCopyWith<$R, $In extends SupportMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? messageId,
    String? authorId,
    String? authorName,
    bool? isStaff,
    String? content,
    DateTime? createdAt,
  });
  SupportMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SupportMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SupportMessage, $Out>
    implements SupportMessageCopyWith<$R, SupportMessage, $Out> {
  _SupportMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SupportMessage> $mapper =
      SupportMessageMapper.ensureInitialized();
  @override
  $R call({
    String? messageId,
    String? authorId,
    String? authorName,
    bool? isStaff,
    String? content,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (messageId != null) #messageId: messageId,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (isStaff != null) #isStaff: isStaff,
      if (content != null) #content: content,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  SupportMessage $make(CopyWithData data) => SupportMessage(
    messageId: data.get(#messageId, or: $value.messageId),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    isStaff: data.get(#isStaff, or: $value.isStaff),
    content: data.get(#content, or: $value.content),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  SupportMessageCopyWith<$R2, SupportMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SupportMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FAQItemMapper extends ClassMapperBase<FAQItem> {
  FAQItemMapper._();

  static FAQItemMapper? _instance;
  static FAQItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FAQItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FAQItem';

  static String _$id(FAQItem v) => v.id;
  static const Field<FAQItem, String> _f$id = Field('id', _$id);
  static FAQCategory _$category(FAQItem v) => v.category;
  static const Field<FAQItem, FAQCategory> _f$category = Field(
    'category',
    _$category,
  );
  static String _$question(FAQItem v) => v.question;
  static const Field<FAQItem, String> _f$question = Field(
    'question',
    _$question,
  );
  static String _$answer(FAQItem v) => v.answer;
  static const Field<FAQItem, String> _f$answer = Field('answer', _$answer);
  static int _$viewCount(FAQItem v) => v.viewCount;
  static const Field<FAQItem, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
    opt: true,
    def: 0,
  );
  static bool _$isHelpful(FAQItem v) => v.isHelpful;
  static const Field<FAQItem, bool> _f$isHelpful = Field(
    'isHelpful',
    _$isHelpful,
    opt: true,
    def: false,
  );
  static List<String> _$relatedQuestions(FAQItem v) => v.relatedQuestions;
  static const Field<FAQItem, List<String>> _f$relatedQuestions = Field(
    'relatedQuestions',
    _$relatedQuestions,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FAQItem> fields = const {
    #id: _f$id,
    #category: _f$category,
    #question: _f$question,
    #answer: _f$answer,
    #viewCount: _f$viewCount,
    #isHelpful: _f$isHelpful,
    #relatedQuestions: _f$relatedQuestions,
  };

  static FAQItem _instantiate(DecodingData data) {
    return FAQItem(
      id: data.dec(_f$id),
      category: data.dec(_f$category),
      question: data.dec(_f$question),
      answer: data.dec(_f$answer),
      viewCount: data.dec(_f$viewCount),
      isHelpful: data.dec(_f$isHelpful),
      relatedQuestions: data.dec(_f$relatedQuestions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FAQItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FAQItem>(map);
  }

  static FAQItem fromJson(String json) {
    return ensureInitialized().decodeJson<FAQItem>(json);
  }
}

mixin FAQItemMappable {
  String toJson() {
    return FAQItemMapper.ensureInitialized().encodeJson<FAQItem>(
      this as FAQItem,
    );
  }

  Map<String, dynamic> toMap() {
    return FAQItemMapper.ensureInitialized().encodeMap<FAQItem>(
      this as FAQItem,
    );
  }

  FAQItemCopyWith<FAQItem, FAQItem, FAQItem> get copyWith =>
      _FAQItemCopyWithImpl<FAQItem, FAQItem>(
        this as FAQItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FAQItemMapper.ensureInitialized().stringifyValue(this as FAQItem);
  }

  @override
  bool operator ==(Object other) {
    return FAQItemMapper.ensureInitialized().equalsValue(
      this as FAQItem,
      other,
    );
  }

  @override
  int get hashCode {
    return FAQItemMapper.ensureInitialized().hashValue(this as FAQItem);
  }
}

extension FAQItemValueCopy<$R, $Out> on ObjectCopyWith<$R, FAQItem, $Out> {
  FAQItemCopyWith<$R, FAQItem, $Out> get $asFAQItem =>
      $base.as((v, t, t2) => _FAQItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FAQItemCopyWith<$R, $In extends FAQItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get relatedQuestions;
  $R call({
    String? id,
    FAQCategory? category,
    String? question,
    String? answer,
    int? viewCount,
    bool? isHelpful,
    List<String>? relatedQuestions,
  });
  FAQItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FAQItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FAQItem, $Out>
    implements FAQItemCopyWith<$R, FAQItem, $Out> {
  _FAQItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FAQItem> $mapper =
      FAQItemMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get relatedQuestions => ListCopyWith(
    $value.relatedQuestions,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(relatedQuestions: v),
  );
  @override
  $R call({
    String? id,
    FAQCategory? category,
    String? question,
    String? answer,
    int? viewCount,
    bool? isHelpful,
    List<String>? relatedQuestions,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (category != null) #category: category,
      if (question != null) #question: question,
      if (answer != null) #answer: answer,
      if (viewCount != null) #viewCount: viewCount,
      if (isHelpful != null) #isHelpful: isHelpful,
      if (relatedQuestions != null) #relatedQuestions: relatedQuestions,
    }),
  );
  @override
  FAQItem $make(CopyWithData data) => FAQItem(
    id: data.get(#id, or: $value.id),
    category: data.get(#category, or: $value.category),
    question: data.get(#question, or: $value.question),
    answer: data.get(#answer, or: $value.answer),
    viewCount: data.get(#viewCount, or: $value.viewCount),
    isHelpful: data.get(#isHelpful, or: $value.isHelpful),
    relatedQuestions: data.get(#relatedQuestions, or: $value.relatedQuestions),
  );

  @override
  FAQItemCopyWith<$R2, FAQItem, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FAQItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MenuItemMapper extends ClassMapperBase<MenuItem> {
  MenuItemMapper._();

  static MenuItemMapper? _instance;
  static MenuItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MenuItemMapper._());
      MenuItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MenuItem';

  static String _$id(MenuItem v) => v.id;
  static const Field<MenuItem, String> _f$id = Field('id', _$id);
  static String _$title(MenuItem v) => v.title;
  static const Field<MenuItem, String> _f$title = Field('title', _$title);
  static String? _$subtitle(MenuItem v) => v.subtitle;
  static const Field<MenuItem, String> _f$subtitle = Field(
    'subtitle',
    _$subtitle,
    opt: true,
  );
  static String? _$icon(MenuItem v) => v.icon;
  static const Field<MenuItem, String> _f$icon = Field(
    'icon',
    _$icon,
    opt: true,
  );
  static String _$route(MenuItem v) => v.route;
  static const Field<MenuItem, String> _f$route = Field('route', _$route);
  static bool _$requiresAuth(MenuItem v) => v.requiresAuth;
  static const Field<MenuItem, bool> _f$requiresAuth = Field(
    'requiresAuth',
    _$requiresAuth,
    opt: true,
    def: false,
  );
  static bool _$requiresPremium(MenuItem v) => v.requiresPremium;
  static const Field<MenuItem, bool> _f$requiresPremium = Field(
    'requiresPremium',
    _$requiresPremium,
    opt: true,
    def: false,
  );
  static List<MenuItem> _$subItems(MenuItem v) => v.subItems;
  static const Field<MenuItem, List<MenuItem>> _f$subItems = Field(
    'subItems',
    _$subItems,
    opt: true,
    def: const [],
  );
  static int? _$badgeCount(MenuItem v) => v.badgeCount;
  static const Field<MenuItem, int> _f$badgeCount = Field(
    'badgeCount',
    _$badgeCount,
    opt: true,
  );

  @override
  final MappableFields<MenuItem> fields = const {
    #id: _f$id,
    #title: _f$title,
    #subtitle: _f$subtitle,
    #icon: _f$icon,
    #route: _f$route,
    #requiresAuth: _f$requiresAuth,
    #requiresPremium: _f$requiresPremium,
    #subItems: _f$subItems,
    #badgeCount: _f$badgeCount,
  };

  static MenuItem _instantiate(DecodingData data) {
    return MenuItem(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      subtitle: data.dec(_f$subtitle),
      icon: data.dec(_f$icon),
      route: data.dec(_f$route),
      requiresAuth: data.dec(_f$requiresAuth),
      requiresPremium: data.dec(_f$requiresPremium),
      subItems: data.dec(_f$subItems),
      badgeCount: data.dec(_f$badgeCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MenuItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MenuItem>(map);
  }

  static MenuItem fromJson(String json) {
    return ensureInitialized().decodeJson<MenuItem>(json);
  }
}

mixin MenuItemMappable {
  String toJson() {
    return MenuItemMapper.ensureInitialized().encodeJson<MenuItem>(
      this as MenuItem,
    );
  }

  Map<String, dynamic> toMap() {
    return MenuItemMapper.ensureInitialized().encodeMap<MenuItem>(
      this as MenuItem,
    );
  }

  MenuItemCopyWith<MenuItem, MenuItem, MenuItem> get copyWith =>
      _MenuItemCopyWithImpl<MenuItem, MenuItem>(
        this as MenuItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MenuItemMapper.ensureInitialized().stringifyValue(this as MenuItem);
  }

  @override
  bool operator ==(Object other) {
    return MenuItemMapper.ensureInitialized().equalsValue(
      this as MenuItem,
      other,
    );
  }

  @override
  int get hashCode {
    return MenuItemMapper.ensureInitialized().hashValue(this as MenuItem);
  }
}

extension MenuItemValueCopy<$R, $Out> on ObjectCopyWith<$R, MenuItem, $Out> {
  MenuItemCopyWith<$R, MenuItem, $Out> get $asMenuItem =>
      $base.as((v, t, t2) => _MenuItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MenuItemCopyWith<$R, $In extends MenuItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, MenuItem, MenuItemCopyWith<$R, MenuItem, MenuItem>>
  get subItems;
  $R call({
    String? id,
    String? title,
    String? subtitle,
    String? icon,
    String? route,
    bool? requiresAuth,
    bool? requiresPremium,
    List<MenuItem>? subItems,
    int? badgeCount,
  });
  MenuItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MenuItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MenuItem, $Out>
    implements MenuItemCopyWith<$R, MenuItem, $Out> {
  _MenuItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MenuItem> $mapper =
      MenuItemMapper.ensureInitialized();
  @override
  ListCopyWith<$R, MenuItem, MenuItemCopyWith<$R, MenuItem, MenuItem>>
  get subItems => ListCopyWith(
    $value.subItems,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(subItems: v),
  );
  @override
  $R call({
    String? id,
    String? title,
    Object? subtitle = $none,
    Object? icon = $none,
    String? route,
    bool? requiresAuth,
    bool? requiresPremium,
    List<MenuItem>? subItems,
    Object? badgeCount = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (subtitle != $none) #subtitle: subtitle,
      if (icon != $none) #icon: icon,
      if (route != null) #route: route,
      if (requiresAuth != null) #requiresAuth: requiresAuth,
      if (requiresPremium != null) #requiresPremium: requiresPremium,
      if (subItems != null) #subItems: subItems,
      if (badgeCount != $none) #badgeCount: badgeCount,
    }),
  );
  @override
  MenuItem $make(CopyWithData data) => MenuItem(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    subtitle: data.get(#subtitle, or: $value.subtitle),
    icon: data.get(#icon, or: $value.icon),
    route: data.get(#route, or: $value.route),
    requiresAuth: data.get(#requiresAuth, or: $value.requiresAuth),
    requiresPremium: data.get(#requiresPremium, or: $value.requiresPremium),
    subItems: data.get(#subItems, or: $value.subItems),
    badgeCount: data.get(#badgeCount, or: $value.badgeCount),
  );

  @override
  MenuItemCopyWith<$R2, MenuItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MenuItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FeatureFlagMapper extends ClassMapperBase<FeatureFlag> {
  FeatureFlagMapper._();

  static FeatureFlagMapper? _instance;
  static FeatureFlagMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FeatureFlagMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FeatureFlag';

  static String _$featureId(FeatureFlag v) => v.featureId;
  static const Field<FeatureFlag, String> _f$featureId = Field(
    'featureId',
    _$featureId,
  );
  static String _$name(FeatureFlag v) => v.name;
  static const Field<FeatureFlag, String> _f$name = Field('name', _$name);
  static bool _$enabled(FeatureFlag v) => v.enabled;
  static const Field<FeatureFlag, bool> _f$enabled = Field(
    'enabled',
    _$enabled,
    opt: true,
    def: false,
  );
  static List<String> _$enabledForUsers(FeatureFlag v) => v.enabledForUsers;
  static const Field<FeatureFlag, List<String>> _f$enabledForUsers = Field(
    'enabledForUsers',
    _$enabledForUsers,
    opt: true,
    def: const [],
  );
  static double _$rolloutPercentage(FeatureFlag v) => v.rolloutPercentage;
  static const Field<FeatureFlag, double> _f$rolloutPercentage = Field(
    'rolloutPercentage',
    _$rolloutPercentage,
    opt: true,
    def: 0,
  );
  static DateTime? _$startDate(FeatureFlag v) => v.startDate;
  static const Field<FeatureFlag, DateTime> _f$startDate = Field(
    'startDate',
    _$startDate,
    opt: true,
  );
  static DateTime? _$endDate(FeatureFlag v) => v.endDate;
  static const Field<FeatureFlag, DateTime> _f$endDate = Field(
    'endDate',
    _$endDate,
    opt: true,
  );

  @override
  final MappableFields<FeatureFlag> fields = const {
    #featureId: _f$featureId,
    #name: _f$name,
    #enabled: _f$enabled,
    #enabledForUsers: _f$enabledForUsers,
    #rolloutPercentage: _f$rolloutPercentage,
    #startDate: _f$startDate,
    #endDate: _f$endDate,
  };

  static FeatureFlag _instantiate(DecodingData data) {
    return FeatureFlag(
      featureId: data.dec(_f$featureId),
      name: data.dec(_f$name),
      enabled: data.dec(_f$enabled),
      enabledForUsers: data.dec(_f$enabledForUsers),
      rolloutPercentage: data.dec(_f$rolloutPercentage),
      startDate: data.dec(_f$startDate),
      endDate: data.dec(_f$endDate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FeatureFlag fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FeatureFlag>(map);
  }

  static FeatureFlag fromJson(String json) {
    return ensureInitialized().decodeJson<FeatureFlag>(json);
  }
}

mixin FeatureFlagMappable {
  String toJson() {
    return FeatureFlagMapper.ensureInitialized().encodeJson<FeatureFlag>(
      this as FeatureFlag,
    );
  }

  Map<String, dynamic> toMap() {
    return FeatureFlagMapper.ensureInitialized().encodeMap<FeatureFlag>(
      this as FeatureFlag,
    );
  }

  FeatureFlagCopyWith<FeatureFlag, FeatureFlag, FeatureFlag> get copyWith =>
      _FeatureFlagCopyWithImpl<FeatureFlag, FeatureFlag>(
        this as FeatureFlag,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FeatureFlagMapper.ensureInitialized().stringifyValue(
      this as FeatureFlag,
    );
  }

  @override
  bool operator ==(Object other) {
    return FeatureFlagMapper.ensureInitialized().equalsValue(
      this as FeatureFlag,
      other,
    );
  }

  @override
  int get hashCode {
    return FeatureFlagMapper.ensureInitialized().hashValue(this as FeatureFlag);
  }
}

extension FeatureFlagValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FeatureFlag, $Out> {
  FeatureFlagCopyWith<$R, FeatureFlag, $Out> get $asFeatureFlag =>
      $base.as((v, t, t2) => _FeatureFlagCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FeatureFlagCopyWith<$R, $In extends FeatureFlag, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get enabledForUsers;
  $R call({
    String? featureId,
    String? name,
    bool? enabled,
    List<String>? enabledForUsers,
    double? rolloutPercentage,
    DateTime? startDate,
    DateTime? endDate,
  });
  FeatureFlagCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FeatureFlagCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FeatureFlag, $Out>
    implements FeatureFlagCopyWith<$R, FeatureFlag, $Out> {
  _FeatureFlagCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FeatureFlag> $mapper =
      FeatureFlagMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get enabledForUsers => ListCopyWith(
    $value.enabledForUsers,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(enabledForUsers: v),
  );
  @override
  $R call({
    String? featureId,
    String? name,
    bool? enabled,
    List<String>? enabledForUsers,
    double? rolloutPercentage,
    Object? startDate = $none,
    Object? endDate = $none,
  }) => $apply(
    FieldCopyWithData({
      if (featureId != null) #featureId: featureId,
      if (name != null) #name: name,
      if (enabled != null) #enabled: enabled,
      if (enabledForUsers != null) #enabledForUsers: enabledForUsers,
      if (rolloutPercentage != null) #rolloutPercentage: rolloutPercentage,
      if (startDate != $none) #startDate: startDate,
      if (endDate != $none) #endDate: endDate,
    }),
  );
  @override
  FeatureFlag $make(CopyWithData data) => FeatureFlag(
    featureId: data.get(#featureId, or: $value.featureId),
    name: data.get(#name, or: $value.name),
    enabled: data.get(#enabled, or: $value.enabled),
    enabledForUsers: data.get(#enabledForUsers, or: $value.enabledForUsers),
    rolloutPercentage: data.get(
      #rolloutPercentage,
      or: $value.rolloutPercentage,
    ),
    startDate: data.get(#startDate, or: $value.startDate),
    endDate: data.get(#endDate, or: $value.endDate),
  );

  @override
  FeatureFlagCopyWith<$R2, FeatureFlag, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FeatureFlagCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

