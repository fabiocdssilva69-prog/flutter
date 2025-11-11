// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'analytics.dart';

class AnalyticsEventMapper extends ClassMapperBase<AnalyticsEvent> {
  AnalyticsEventMapper._();

  static AnalyticsEventMapper? _instance;
  static AnalyticsEventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AnalyticsEventMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AnalyticsEvent';

  static String _$eventId(AnalyticsEvent v) => v.eventId;
  static const Field<AnalyticsEvent, String> _f$eventId = Field(
    'eventId',
    _$eventId,
  );
  static String _$userId(AnalyticsEvent v) => v.userId;
  static const Field<AnalyticsEvent, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static EventCategory _$category(AnalyticsEvent v) => v.category;
  static const Field<AnalyticsEvent, EventCategory> _f$category = Field(
    'category',
    _$category,
  );
  static String _$eventName(AnalyticsEvent v) => v.eventName;
  static const Field<AnalyticsEvent, String> _f$eventName = Field(
    'eventName',
    _$eventName,
  );
  static Map<String, dynamic> _$properties(AnalyticsEvent v) => v.properties;
  static const Field<AnalyticsEvent, Map<String, dynamic>> _f$properties =
      Field('properties', _$properties, opt: true, def: const {});
  static DateTime _$timestamp(AnalyticsEvent v) => v.timestamp;
  static const Field<AnalyticsEvent, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static String? _$sessionId(AnalyticsEvent v) => v.sessionId;
  static const Field<AnalyticsEvent, String> _f$sessionId = Field(
    'sessionId',
    _$sessionId,
    opt: true,
  );
  static String? _$screenName(AnalyticsEvent v) => v.screenName;
  static const Field<AnalyticsEvent, String> _f$screenName = Field(
    'screenName',
    _$screenName,
    opt: true,
  );

  @override
  final MappableFields<AnalyticsEvent> fields = const {
    #eventId: _f$eventId,
    #userId: _f$userId,
    #category: _f$category,
    #eventName: _f$eventName,
    #properties: _f$properties,
    #timestamp: _f$timestamp,
    #sessionId: _f$sessionId,
    #screenName: _f$screenName,
  };

  static AnalyticsEvent _instantiate(DecodingData data) {
    return AnalyticsEvent(
      eventId: data.dec(_f$eventId),
      userId: data.dec(_f$userId),
      category: data.dec(_f$category),
      eventName: data.dec(_f$eventName),
      properties: data.dec(_f$properties),
      timestamp: data.dec(_f$timestamp),
      sessionId: data.dec(_f$sessionId),
      screenName: data.dec(_f$screenName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AnalyticsEvent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AnalyticsEvent>(map);
  }

  static AnalyticsEvent fromJson(String json) {
    return ensureInitialized().decodeJson<AnalyticsEvent>(json);
  }
}

mixin AnalyticsEventMappable {
  String toJson() {
    return AnalyticsEventMapper.ensureInitialized().encodeJson<AnalyticsEvent>(
      this as AnalyticsEvent,
    );
  }

  Map<String, dynamic> toMap() {
    return AnalyticsEventMapper.ensureInitialized().encodeMap<AnalyticsEvent>(
      this as AnalyticsEvent,
    );
  }

  AnalyticsEventCopyWith<AnalyticsEvent, AnalyticsEvent, AnalyticsEvent>
  get copyWith => _AnalyticsEventCopyWithImpl<AnalyticsEvent, AnalyticsEvent>(
    this as AnalyticsEvent,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return AnalyticsEventMapper.ensureInitialized().stringifyValue(
      this as AnalyticsEvent,
    );
  }

  @override
  bool operator ==(Object other) {
    return AnalyticsEventMapper.ensureInitialized().equalsValue(
      this as AnalyticsEvent,
      other,
    );
  }

  @override
  int get hashCode {
    return AnalyticsEventMapper.ensureInitialized().hashValue(
      this as AnalyticsEvent,
    );
  }
}

extension AnalyticsEventValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AnalyticsEvent, $Out> {
  AnalyticsEventCopyWith<$R, AnalyticsEvent, $Out> get $asAnalyticsEvent =>
      $base.as((v, t, t2) => _AnalyticsEventCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AnalyticsEventCopyWith<$R, $In extends AnalyticsEvent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get properties;
  $R call({
    String? eventId,
    String? userId,
    EventCategory? category,
    String? eventName,
    Map<String, dynamic>? properties,
    DateTime? timestamp,
    String? sessionId,
    String? screenName,
  });
  AnalyticsEventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AnalyticsEventCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AnalyticsEvent, $Out>
    implements AnalyticsEventCopyWith<$R, AnalyticsEvent, $Out> {
  _AnalyticsEventCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AnalyticsEvent> $mapper =
      AnalyticsEventMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get properties => MapCopyWith(
    $value.properties,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(properties: v),
  );
  @override
  $R call({
    String? eventId,
    String? userId,
    EventCategory? category,
    String? eventName,
    Map<String, dynamic>? properties,
    DateTime? timestamp,
    Object? sessionId = $none,
    Object? screenName = $none,
  }) => $apply(
    FieldCopyWithData({
      if (eventId != null) #eventId: eventId,
      if (userId != null) #userId: userId,
      if (category != null) #category: category,
      if (eventName != null) #eventName: eventName,
      if (properties != null) #properties: properties,
      if (timestamp != null) #timestamp: timestamp,
      if (sessionId != $none) #sessionId: sessionId,
      if (screenName != $none) #screenName: screenName,
    }),
  );
  @override
  AnalyticsEvent $make(CopyWithData data) => AnalyticsEvent(
    eventId: data.get(#eventId, or: $value.eventId),
    userId: data.get(#userId, or: $value.userId),
    category: data.get(#category, or: $value.category),
    eventName: data.get(#eventName, or: $value.eventName),
    properties: data.get(#properties, or: $value.properties),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    sessionId: data.get(#sessionId, or: $value.sessionId),
    screenName: data.get(#screenName, or: $value.screenName),
  );

  @override
  AnalyticsEventCopyWith<$R2, AnalyticsEvent, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AnalyticsEventCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UserSessionMapper extends ClassMapperBase<UserSession> {
  UserSessionMapper._();

  static UserSessionMapper? _instance;
  static UserSessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserSessionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserSession';

  static String _$sessionId(UserSession v) => v.sessionId;
  static const Field<UserSession, String> _f$sessionId = Field(
    'sessionId',
    _$sessionId,
  );
  static String _$userId(UserSession v) => v.userId;
  static const Field<UserSession, String> _f$userId = Field('userId', _$userId);
  static DateTime _$startTime(UserSession v) => v.startTime;
  static const Field<UserSession, DateTime> _f$startTime = Field(
    'startTime',
    _$startTime,
  );
  static DateTime? _$endTime(UserSession v) => v.endTime;
  static const Field<UserSession, DateTime> _f$endTime = Field(
    'endTime',
    _$endTime,
    opt: true,
  );
  static int _$duration(UserSession v) => v.duration;
  static const Field<UserSession, int> _f$duration = Field(
    'duration',
    _$duration,
    opt: true,
    def: 0,
  );
  static int _$screenViews(UserSession v) => v.screenViews;
  static const Field<UserSession, int> _f$screenViews = Field(
    'screenViews',
    _$screenViews,
    opt: true,
    def: 0,
  );
  static List<String> _$screensVisited(UserSession v) => v.screensVisited;
  static const Field<UserSession, List<String>> _f$screensVisited = Field(
    'screensVisited',
    _$screensVisited,
    opt: true,
    def: const [],
  );
  static Map<String, int> _$actionsPerformed(UserSession v) =>
      v.actionsPerformed;
  static const Field<UserSession, Map<String, int>> _f$actionsPerformed = Field(
    'actionsPerformed',
    _$actionsPerformed,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<UserSession> fields = const {
    #sessionId: _f$sessionId,
    #userId: _f$userId,
    #startTime: _f$startTime,
    #endTime: _f$endTime,
    #duration: _f$duration,
    #screenViews: _f$screenViews,
    #screensVisited: _f$screensVisited,
    #actionsPerformed: _f$actionsPerformed,
  };

  static UserSession _instantiate(DecodingData data) {
    return UserSession(
      sessionId: data.dec(_f$sessionId),
      userId: data.dec(_f$userId),
      startTime: data.dec(_f$startTime),
      endTime: data.dec(_f$endTime),
      duration: data.dec(_f$duration),
      screenViews: data.dec(_f$screenViews),
      screensVisited: data.dec(_f$screensVisited),
      actionsPerformed: data.dec(_f$actionsPerformed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserSession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserSession>(map);
  }

  static UserSession fromJson(String json) {
    return ensureInitialized().decodeJson<UserSession>(json);
  }
}

mixin UserSessionMappable {
  String toJson() {
    return UserSessionMapper.ensureInitialized().encodeJson<UserSession>(
      this as UserSession,
    );
  }

  Map<String, dynamic> toMap() {
    return UserSessionMapper.ensureInitialized().encodeMap<UserSession>(
      this as UserSession,
    );
  }

  UserSessionCopyWith<UserSession, UserSession, UserSession> get copyWith =>
      _UserSessionCopyWithImpl<UserSession, UserSession>(
        this as UserSession,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserSessionMapper.ensureInitialized().stringifyValue(
      this as UserSession,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserSessionMapper.ensureInitialized().equalsValue(
      this as UserSession,
      other,
    );
  }

  @override
  int get hashCode {
    return UserSessionMapper.ensureInitialized().hashValue(this as UserSession);
  }
}

extension UserSessionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserSession, $Out> {
  UserSessionCopyWith<$R, UserSession, $Out> get $asUserSession =>
      $base.as((v, t, t2) => _UserSessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserSessionCopyWith<$R, $In extends UserSession, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get screensVisited;
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>>
  get actionsPerformed;
  $R call({
    String? sessionId,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    int? screenViews,
    List<String>? screensVisited,
    Map<String, int>? actionsPerformed,
  });
  UserSessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserSessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserSession, $Out>
    implements UserSessionCopyWith<$R, UserSession, $Out> {
  _UserSessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserSession> $mapper =
      UserSessionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get screensVisited => ListCopyWith(
    $value.screensVisited,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(screensVisited: v),
  );
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>>
  get actionsPerformed => MapCopyWith(
    $value.actionsPerformed,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(actionsPerformed: v),
  );
  @override
  $R call({
    String? sessionId,
    String? userId,
    DateTime? startTime,
    Object? endTime = $none,
    int? duration,
    int? screenViews,
    List<String>? screensVisited,
    Map<String, int>? actionsPerformed,
  }) => $apply(
    FieldCopyWithData({
      if (sessionId != null) #sessionId: sessionId,
      if (userId != null) #userId: userId,
      if (startTime != null) #startTime: startTime,
      if (endTime != $none) #endTime: endTime,
      if (duration != null) #duration: duration,
      if (screenViews != null) #screenViews: screenViews,
      if (screensVisited != null) #screensVisited: screensVisited,
      if (actionsPerformed != null) #actionsPerformed: actionsPerformed,
    }),
  );
  @override
  UserSession $make(CopyWithData data) => UserSession(
    sessionId: data.get(#sessionId, or: $value.sessionId),
    userId: data.get(#userId, or: $value.userId),
    startTime: data.get(#startTime, or: $value.startTime),
    endTime: data.get(#endTime, or: $value.endTime),
    duration: data.get(#duration, or: $value.duration),
    screenViews: data.get(#screenViews, or: $value.screenViews),
    screensVisited: data.get(#screensVisited, or: $value.screensVisited),
    actionsPerformed: data.get(#actionsPerformed, or: $value.actionsPerformed),
  );

  @override
  UserSessionCopyWith<$R2, UserSession, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserSessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CrashReportMapper extends ClassMapperBase<CrashReport> {
  CrashReportMapper._();

  static CrashReportMapper? _instance;
  static CrashReportMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CrashReportMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CrashReport';

  static String _$crashId(CrashReport v) => v.crashId;
  static const Field<CrashReport, String> _f$crashId = Field(
    'crashId',
    _$crashId,
  );
  static String _$userId(CrashReport v) => v.userId;
  static const Field<CrashReport, String> _f$userId = Field('userId', _$userId);
  static CrashSeverity _$severity(CrashReport v) => v.severity;
  static const Field<CrashReport, CrashSeverity> _f$severity = Field(
    'severity',
    _$severity,
  );
  static String _$errorType(CrashReport v) => v.errorType;
  static const Field<CrashReport, String> _f$errorType = Field(
    'errorType',
    _$errorType,
  );
  static String _$errorMessage(CrashReport v) => v.errorMessage;
  static const Field<CrashReport, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
  );
  static String _$stackTrace(CrashReport v) => v.stackTrace;
  static const Field<CrashReport, String> _f$stackTrace = Field(
    'stackTrace',
    _$stackTrace,
  );
  static Map<String, dynamic> _$deviceInfo(CrashReport v) => v.deviceInfo;
  static const Field<CrashReport, Map<String, dynamic>> _f$deviceInfo = Field(
    'deviceInfo',
    _$deviceInfo,
    opt: true,
    def: const {},
  );
  static Map<String, dynamic> _$appInfo(CrashReport v) => v.appInfo;
  static const Field<CrashReport, Map<String, dynamic>> _f$appInfo = Field(
    'appInfo',
    _$appInfo,
    opt: true,
    def: const {},
  );
  static DateTime _$timestamp(CrashReport v) => v.timestamp;
  static const Field<CrashReport, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static bool _$isFatal(CrashReport v) => v.isFatal;
  static const Field<CrashReport, bool> _f$isFatal = Field(
    'isFatal',
    _$isFatal,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<CrashReport> fields = const {
    #crashId: _f$crashId,
    #userId: _f$userId,
    #severity: _f$severity,
    #errorType: _f$errorType,
    #errorMessage: _f$errorMessage,
    #stackTrace: _f$stackTrace,
    #deviceInfo: _f$deviceInfo,
    #appInfo: _f$appInfo,
    #timestamp: _f$timestamp,
    #isFatal: _f$isFatal,
  };

  static CrashReport _instantiate(DecodingData data) {
    return CrashReport(
      crashId: data.dec(_f$crashId),
      userId: data.dec(_f$userId),
      severity: data.dec(_f$severity),
      errorType: data.dec(_f$errorType),
      errorMessage: data.dec(_f$errorMessage),
      stackTrace: data.dec(_f$stackTrace),
      deviceInfo: data.dec(_f$deviceInfo),
      appInfo: data.dec(_f$appInfo),
      timestamp: data.dec(_f$timestamp),
      isFatal: data.dec(_f$isFatal),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CrashReport fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CrashReport>(map);
  }

  static CrashReport fromJson(String json) {
    return ensureInitialized().decodeJson<CrashReport>(json);
  }
}

mixin CrashReportMappable {
  String toJson() {
    return CrashReportMapper.ensureInitialized().encodeJson<CrashReport>(
      this as CrashReport,
    );
  }

  Map<String, dynamic> toMap() {
    return CrashReportMapper.ensureInitialized().encodeMap<CrashReport>(
      this as CrashReport,
    );
  }

  CrashReportCopyWith<CrashReport, CrashReport, CrashReport> get copyWith =>
      _CrashReportCopyWithImpl<CrashReport, CrashReport>(
        this as CrashReport,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CrashReportMapper.ensureInitialized().stringifyValue(
      this as CrashReport,
    );
  }

  @override
  bool operator ==(Object other) {
    return CrashReportMapper.ensureInitialized().equalsValue(
      this as CrashReport,
      other,
    );
  }

  @override
  int get hashCode {
    return CrashReportMapper.ensureInitialized().hashValue(this as CrashReport);
  }
}

extension CrashReportValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CrashReport, $Out> {
  CrashReportCopyWith<$R, CrashReport, $Out> get $asCrashReport =>
      $base.as((v, t, t2) => _CrashReportCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CrashReportCopyWith<$R, $In extends CrashReport, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get deviceInfo;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get appInfo;
  $R call({
    String? crashId,
    String? userId,
    CrashSeverity? severity,
    String? errorType,
    String? errorMessage,
    String? stackTrace,
    Map<String, dynamic>? deviceInfo,
    Map<String, dynamic>? appInfo,
    DateTime? timestamp,
    bool? isFatal,
  });
  CrashReportCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CrashReportCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CrashReport, $Out>
    implements CrashReportCopyWith<$R, CrashReport, $Out> {
  _CrashReportCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CrashReport> $mapper =
      CrashReportMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get deviceInfo => MapCopyWith(
    $value.deviceInfo,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(deviceInfo: v),
  );
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get appInfo => MapCopyWith(
    $value.appInfo,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(appInfo: v),
  );
  @override
  $R call({
    String? crashId,
    String? userId,
    CrashSeverity? severity,
    String? errorType,
    String? errorMessage,
    String? stackTrace,
    Map<String, dynamic>? deviceInfo,
    Map<String, dynamic>? appInfo,
    DateTime? timestamp,
    bool? isFatal,
  }) => $apply(
    FieldCopyWithData({
      if (crashId != null) #crashId: crashId,
      if (userId != null) #userId: userId,
      if (severity != null) #severity: severity,
      if (errorType != null) #errorType: errorType,
      if (errorMessage != null) #errorMessage: errorMessage,
      if (stackTrace != null) #stackTrace: stackTrace,
      if (deviceInfo != null) #deviceInfo: deviceInfo,
      if (appInfo != null) #appInfo: appInfo,
      if (timestamp != null) #timestamp: timestamp,
      if (isFatal != null) #isFatal: isFatal,
    }),
  );
  @override
  CrashReport $make(CopyWithData data) => CrashReport(
    crashId: data.get(#crashId, or: $value.crashId),
    userId: data.get(#userId, or: $value.userId),
    severity: data.get(#severity, or: $value.severity),
    errorType: data.get(#errorType, or: $value.errorType),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
    stackTrace: data.get(#stackTrace, or: $value.stackTrace),
    deviceInfo: data.get(#deviceInfo, or: $value.deviceInfo),
    appInfo: data.get(#appInfo, or: $value.appInfo),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    isFatal: data.get(#isFatal, or: $value.isFatal),
  );

  @override
  CrashReportCopyWith<$R2, CrashReport, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CrashReportCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PerformanceMetricMapper extends ClassMapperBase<PerformanceMetric> {
  PerformanceMetricMapper._();

  static PerformanceMetricMapper? _instance;
  static PerformanceMetricMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PerformanceMetricMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PerformanceMetric';

  static String _$metricId(PerformanceMetric v) => v.metricId;
  static const Field<PerformanceMetric, String> _f$metricId = Field(
    'metricId',
    _$metricId,
  );
  static String _$userId(PerformanceMetric v) => v.userId;
  static const Field<PerformanceMetric, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static MetricType _$type(PerformanceMetric v) => v.type;
  static const Field<PerformanceMetric, MetricType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$name(PerformanceMetric v) => v.name;
  static const Field<PerformanceMetric, String> _f$name = Field('name', _$name);
  static double _$value(PerformanceMetric v) => v.value;
  static const Field<PerformanceMetric, double> _f$value = Field(
    'value',
    _$value,
  );
  static String _$unit(PerformanceMetric v) => v.unit;
  static const Field<PerformanceMetric, String> _f$unit = Field(
    'unit',
    _$unit,
    opt: true,
    def: 'ms',
  );
  static Map<String, dynamic> _$metadata(PerformanceMetric v) => v.metadata;
  static const Field<PerformanceMetric, Map<String, dynamic>> _f$metadata =
      Field('metadata', _$metadata, opt: true, def: const {});
  static DateTime _$timestamp(PerformanceMetric v) => v.timestamp;
  static const Field<PerformanceMetric, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );

  @override
  final MappableFields<PerformanceMetric> fields = const {
    #metricId: _f$metricId,
    #userId: _f$userId,
    #type: _f$type,
    #name: _f$name,
    #value: _f$value,
    #unit: _f$unit,
    #metadata: _f$metadata,
    #timestamp: _f$timestamp,
  };

  static PerformanceMetric _instantiate(DecodingData data) {
    return PerformanceMetric(
      metricId: data.dec(_f$metricId),
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      name: data.dec(_f$name),
      value: data.dec(_f$value),
      unit: data.dec(_f$unit),
      metadata: data.dec(_f$metadata),
      timestamp: data.dec(_f$timestamp),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PerformanceMetric fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PerformanceMetric>(map);
  }

  static PerformanceMetric fromJson(String json) {
    return ensureInitialized().decodeJson<PerformanceMetric>(json);
  }
}

mixin PerformanceMetricMappable {
  String toJson() {
    return PerformanceMetricMapper.ensureInitialized()
        .encodeJson<PerformanceMetric>(this as PerformanceMetric);
  }

  Map<String, dynamic> toMap() {
    return PerformanceMetricMapper.ensureInitialized()
        .encodeMap<PerformanceMetric>(this as PerformanceMetric);
  }

  PerformanceMetricCopyWith<
    PerformanceMetric,
    PerformanceMetric,
    PerformanceMetric
  >
  get copyWith =>
      _PerformanceMetricCopyWithImpl<PerformanceMetric, PerformanceMetric>(
        this as PerformanceMetric,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PerformanceMetricMapper.ensureInitialized().stringifyValue(
      this as PerformanceMetric,
    );
  }

  @override
  bool operator ==(Object other) {
    return PerformanceMetricMapper.ensureInitialized().equalsValue(
      this as PerformanceMetric,
      other,
    );
  }

  @override
  int get hashCode {
    return PerformanceMetricMapper.ensureInitialized().hashValue(
      this as PerformanceMetric,
    );
  }
}

extension PerformanceMetricValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PerformanceMetric, $Out> {
  PerformanceMetricCopyWith<$R, PerformanceMetric, $Out>
  get $asPerformanceMetric => $base.as(
    (v, t, t2) => _PerformanceMetricCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PerformanceMetricCopyWith<
  $R,
  $In extends PerformanceMetric,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata;
  $R call({
    String? metricId,
    String? userId,
    MetricType? type,
    String? name,
    double? value,
    String? unit,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  });
  PerformanceMetricCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PerformanceMetricCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PerformanceMetric, $Out>
    implements PerformanceMetricCopyWith<$R, PerformanceMetric, $Out> {
  _PerformanceMetricCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PerformanceMetric> $mapper =
      PerformanceMetricMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata => MapCopyWith(
    $value.metadata,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(metadata: v),
  );
  @override
  $R call({
    String? metricId,
    String? userId,
    MetricType? type,
    String? name,
    double? value,
    String? unit,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  }) => $apply(
    FieldCopyWithData({
      if (metricId != null) #metricId: metricId,
      if (userId != null) #userId: userId,
      if (type != null) #type: type,
      if (name != null) #name: name,
      if (value != null) #value: value,
      if (unit != null) #unit: unit,
      if (metadata != null) #metadata: metadata,
      if (timestamp != null) #timestamp: timestamp,
    }),
  );
  @override
  PerformanceMetric $make(CopyWithData data) => PerformanceMetric(
    metricId: data.get(#metricId, or: $value.metricId),
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    name: data.get(#name, or: $value.name),
    value: data.get(#value, or: $value.value),
    unit: data.get(#unit, or: $value.unit),
    metadata: data.get(#metadata, or: $value.metadata),
    timestamp: data.get(#timestamp, or: $value.timestamp),
  );

  @override
  PerformanceMetricCopyWith<$R2, PerformanceMetric, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PerformanceMetricCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BehaviorMetricsMapper extends ClassMapperBase<BehaviorMetrics> {
  BehaviorMetricsMapper._();

  static BehaviorMetricsMapper? _instance;
  static BehaviorMetricsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BehaviorMetricsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BehaviorMetrics';

  static String _$userId(BehaviorMetrics v) => v.userId;
  static const Field<BehaviorMetrics, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static int _$dailyActiveStreak(BehaviorMetrics v) => v.dailyActiveStreak;
  static const Field<BehaviorMetrics, int> _f$dailyActiveStreak = Field(
    'dailyActiveStreak',
    _$dailyActiveStreak,
    opt: true,
    def: 0,
  );
  static int _$totalSessions(BehaviorMetrics v) => v.totalSessions;
  static const Field<BehaviorMetrics, int> _f$totalSessions = Field(
    'totalSessions',
    _$totalSessions,
    opt: true,
    def: 0,
  );
  static double _$averageSessionDuration(BehaviorMetrics v) =>
      v.averageSessionDuration;
  static const Field<BehaviorMetrics, double> _f$averageSessionDuration = Field(
    'averageSessionDuration',
    _$averageSessionDuration,
    opt: true,
    def: 0,
  );
  static int _$profileViews(BehaviorMetrics v) => v.profileViews;
  static const Field<BehaviorMetrics, int> _f$profileViews = Field(
    'profileViews',
    _$profileViews,
    opt: true,
    def: 0,
  );
  static int _$swipes(BehaviorMetrics v) => v.swipes;
  static const Field<BehaviorMetrics, int> _f$swipes = Field(
    'swipes',
    _$swipes,
    opt: true,
    def: 0,
  );
  static int _$likes(BehaviorMetrics v) => v.likes;
  static const Field<BehaviorMetrics, int> _f$likes = Field(
    'likes',
    _$likes,
    opt: true,
    def: 0,
  );
  static int _$matches(BehaviorMetrics v) => v.matches;
  static const Field<BehaviorMetrics, int> _f$matches = Field(
    'matches',
    _$matches,
    opt: true,
    def: 0,
  );
  static int _$messages(BehaviorMetrics v) => v.messages;
  static const Field<BehaviorMetrics, int> _f$messages = Field(
    'messages',
    _$messages,
    opt: true,
    def: 0,
  );
  static double _$engagementScore(BehaviorMetrics v) => v.engagementScore;
  static const Field<BehaviorMetrics, double> _f$engagementScore = Field(
    'engagementScore',
    _$engagementScore,
    opt: true,
    def: 0,
  );
  static DateTime _$lastActive(BehaviorMetrics v) => v.lastActive;
  static const Field<BehaviorMetrics, DateTime> _f$lastActive = Field(
    'lastActive',
    _$lastActive,
  );
  static Map<String, int> _$featureUsage(BehaviorMetrics v) => v.featureUsage;
  static const Field<BehaviorMetrics, Map<String, int>> _f$featureUsage = Field(
    'featureUsage',
    _$featureUsage,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<BehaviorMetrics> fields = const {
    #userId: _f$userId,
    #dailyActiveStreak: _f$dailyActiveStreak,
    #totalSessions: _f$totalSessions,
    #averageSessionDuration: _f$averageSessionDuration,
    #profileViews: _f$profileViews,
    #swipes: _f$swipes,
    #likes: _f$likes,
    #matches: _f$matches,
    #messages: _f$messages,
    #engagementScore: _f$engagementScore,
    #lastActive: _f$lastActive,
    #featureUsage: _f$featureUsage,
  };

  static BehaviorMetrics _instantiate(DecodingData data) {
    return BehaviorMetrics(
      userId: data.dec(_f$userId),
      dailyActiveStreak: data.dec(_f$dailyActiveStreak),
      totalSessions: data.dec(_f$totalSessions),
      averageSessionDuration: data.dec(_f$averageSessionDuration),
      profileViews: data.dec(_f$profileViews),
      swipes: data.dec(_f$swipes),
      likes: data.dec(_f$likes),
      matches: data.dec(_f$matches),
      messages: data.dec(_f$messages),
      engagementScore: data.dec(_f$engagementScore),
      lastActive: data.dec(_f$lastActive),
      featureUsage: data.dec(_f$featureUsage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BehaviorMetrics fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BehaviorMetrics>(map);
  }

  static BehaviorMetrics fromJson(String json) {
    return ensureInitialized().decodeJson<BehaviorMetrics>(json);
  }
}

mixin BehaviorMetricsMappable {
  String toJson() {
    return BehaviorMetricsMapper.ensureInitialized()
        .encodeJson<BehaviorMetrics>(this as BehaviorMetrics);
  }

  Map<String, dynamic> toMap() {
    return BehaviorMetricsMapper.ensureInitialized().encodeMap<BehaviorMetrics>(
      this as BehaviorMetrics,
    );
  }

  BehaviorMetricsCopyWith<BehaviorMetrics, BehaviorMetrics, BehaviorMetrics>
  get copyWith =>
      _BehaviorMetricsCopyWithImpl<BehaviorMetrics, BehaviorMetrics>(
        this as BehaviorMetrics,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BehaviorMetricsMapper.ensureInitialized().stringifyValue(
      this as BehaviorMetrics,
    );
  }

  @override
  bool operator ==(Object other) {
    return BehaviorMetricsMapper.ensureInitialized().equalsValue(
      this as BehaviorMetrics,
      other,
    );
  }

  @override
  int get hashCode {
    return BehaviorMetricsMapper.ensureInitialized().hashValue(
      this as BehaviorMetrics,
    );
  }
}

extension BehaviorMetricsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BehaviorMetrics, $Out> {
  BehaviorMetricsCopyWith<$R, BehaviorMetrics, $Out> get $asBehaviorMetrics =>
      $base.as((v, t, t2) => _BehaviorMetricsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BehaviorMetricsCopyWith<$R, $In extends BehaviorMetrics, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get featureUsage;
  $R call({
    String? userId,
    int? dailyActiveStreak,
    int? totalSessions,
    double? averageSessionDuration,
    int? profileViews,
    int? swipes,
    int? likes,
    int? matches,
    int? messages,
    double? engagementScore,
    DateTime? lastActive,
    Map<String, int>? featureUsage,
  });
  BehaviorMetricsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BehaviorMetricsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BehaviorMetrics, $Out>
    implements BehaviorMetricsCopyWith<$R, BehaviorMetrics, $Out> {
  _BehaviorMetricsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BehaviorMetrics> $mapper =
      BehaviorMetricsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get featureUsage =>
      MapCopyWith(
        $value.featureUsage,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(featureUsage: v),
      );
  @override
  $R call({
    String? userId,
    int? dailyActiveStreak,
    int? totalSessions,
    double? averageSessionDuration,
    int? profileViews,
    int? swipes,
    int? likes,
    int? matches,
    int? messages,
    double? engagementScore,
    DateTime? lastActive,
    Map<String, int>? featureUsage,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (dailyActiveStreak != null) #dailyActiveStreak: dailyActiveStreak,
      if (totalSessions != null) #totalSessions: totalSessions,
      if (averageSessionDuration != null)
        #averageSessionDuration: averageSessionDuration,
      if (profileViews != null) #profileViews: profileViews,
      if (swipes != null) #swipes: swipes,
      if (likes != null) #likes: likes,
      if (matches != null) #matches: matches,
      if (messages != null) #messages: messages,
      if (engagementScore != null) #engagementScore: engagementScore,
      if (lastActive != null) #lastActive: lastActive,
      if (featureUsage != null) #featureUsage: featureUsage,
    }),
  );
  @override
  BehaviorMetrics $make(CopyWithData data) => BehaviorMetrics(
    userId: data.get(#userId, or: $value.userId),
    dailyActiveStreak: data.get(
      #dailyActiveStreak,
      or: $value.dailyActiveStreak,
    ),
    totalSessions: data.get(#totalSessions, or: $value.totalSessions),
    averageSessionDuration: data.get(
      #averageSessionDuration,
      or: $value.averageSessionDuration,
    ),
    profileViews: data.get(#profileViews, or: $value.profileViews),
    swipes: data.get(#swipes, or: $value.swipes),
    likes: data.get(#likes, or: $value.likes),
    matches: data.get(#matches, or: $value.matches),
    messages: data.get(#messages, or: $value.messages),
    engagementScore: data.get(#engagementScore, or: $value.engagementScore),
    lastActive: data.get(#lastActive, or: $value.lastActive),
    featureUsage: data.get(#featureUsage, or: $value.featureUsage),
  );

  @override
  BehaviorMetricsCopyWith<$R2, BehaviorMetrics, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BehaviorMetricsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ABTestMapper extends ClassMapperBase<ABTest> {
  ABTestMapper._();

  static ABTestMapper? _instance;
  static ABTestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ABTestMapper._());
      ABTestVariantMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ABTest';

  static String _$testId(ABTest v) => v.testId;
  static const Field<ABTest, String> _f$testId = Field('testId', _$testId);
  static String _$testName(ABTest v) => v.testName;
  static const Field<ABTest, String> _f$testName = Field(
    'testName',
    _$testName,
  );
  static String _$description(ABTest v) => v.description;
  static const Field<ABTest, String> _f$description = Field(
    'description',
    _$description,
  );
  static bool _$isActive(ABTest v) => v.isActive;
  static const Field<ABTest, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    opt: true,
    def: true,
  );
  static List<ABTestVariant> _$variants(ABTest v) => v.variants;
  static const Field<ABTest, List<ABTestVariant>> _f$variants = Field(
    'variants',
    _$variants,
  );
  static DateTime _$startDate(ABTest v) => v.startDate;
  static const Field<ABTest, DateTime> _f$startDate = Field(
    'startDate',
    _$startDate,
  );
  static DateTime? _$endDate(ABTest v) => v.endDate;
  static const Field<ABTest, DateTime> _f$endDate = Field(
    'endDate',
    _$endDate,
    opt: true,
  );
  static Map<String, int> _$participantCounts(ABTest v) => v.participantCounts;
  static const Field<ABTest, Map<String, int>> _f$participantCounts = Field(
    'participantCounts',
    _$participantCounts,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<ABTest> fields = const {
    #testId: _f$testId,
    #testName: _f$testName,
    #description: _f$description,
    #isActive: _f$isActive,
    #variants: _f$variants,
    #startDate: _f$startDate,
    #endDate: _f$endDate,
    #participantCounts: _f$participantCounts,
  };

  static ABTest _instantiate(DecodingData data) {
    return ABTest(
      testId: data.dec(_f$testId),
      testName: data.dec(_f$testName),
      description: data.dec(_f$description),
      isActive: data.dec(_f$isActive),
      variants: data.dec(_f$variants),
      startDate: data.dec(_f$startDate),
      endDate: data.dec(_f$endDate),
      participantCounts: data.dec(_f$participantCounts),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ABTest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ABTest>(map);
  }

  static ABTest fromJson(String json) {
    return ensureInitialized().decodeJson<ABTest>(json);
  }
}

mixin ABTestMappable {
  String toJson() {
    return ABTestMapper.ensureInitialized().encodeJson<ABTest>(this as ABTest);
  }

  Map<String, dynamic> toMap() {
    return ABTestMapper.ensureInitialized().encodeMap<ABTest>(this as ABTest);
  }

  ABTestCopyWith<ABTest, ABTest, ABTest> get copyWith =>
      _ABTestCopyWithImpl<ABTest, ABTest>(this as ABTest, $identity, $identity);
  @override
  String toString() {
    return ABTestMapper.ensureInitialized().stringifyValue(this as ABTest);
  }

  @override
  bool operator ==(Object other) {
    return ABTestMapper.ensureInitialized().equalsValue(this as ABTest, other);
  }

  @override
  int get hashCode {
    return ABTestMapper.ensureInitialized().hashValue(this as ABTest);
  }
}

extension ABTestValueCopy<$R, $Out> on ObjectCopyWith<$R, ABTest, $Out> {
  ABTestCopyWith<$R, ABTest, $Out> get $asABTest =>
      $base.as((v, t, t2) => _ABTestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ABTestCopyWith<$R, $In extends ABTest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ABTestVariant,
    ABTestVariantCopyWith<$R, ABTestVariant, ABTestVariant>
  >
  get variants;
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>>
  get participantCounts;
  $R call({
    String? testId,
    String? testName,
    String? description,
    bool? isActive,
    List<ABTestVariant>? variants,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, int>? participantCounts,
  });
  ABTestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ABTestCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, ABTest, $Out>
    implements ABTestCopyWith<$R, ABTest, $Out> {
  _ABTestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ABTest> $mapper = ABTestMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ABTestVariant,
    ABTestVariantCopyWith<$R, ABTestVariant, ABTestVariant>
  >
  get variants => ListCopyWith(
    $value.variants,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(variants: v),
  );
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>>
  get participantCounts => MapCopyWith(
    $value.participantCounts,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(participantCounts: v),
  );
  @override
  $R call({
    String? testId,
    String? testName,
    String? description,
    bool? isActive,
    List<ABTestVariant>? variants,
    DateTime? startDate,
    Object? endDate = $none,
    Map<String, int>? participantCounts,
  }) => $apply(
    FieldCopyWithData({
      if (testId != null) #testId: testId,
      if (testName != null) #testName: testName,
      if (description != null) #description: description,
      if (isActive != null) #isActive: isActive,
      if (variants != null) #variants: variants,
      if (startDate != null) #startDate: startDate,
      if (endDate != $none) #endDate: endDate,
      if (participantCounts != null) #participantCounts: participantCounts,
    }),
  );
  @override
  ABTest $make(CopyWithData data) => ABTest(
    testId: data.get(#testId, or: $value.testId),
    testName: data.get(#testName, or: $value.testName),
    description: data.get(#description, or: $value.description),
    isActive: data.get(#isActive, or: $value.isActive),
    variants: data.get(#variants, or: $value.variants),
    startDate: data.get(#startDate, or: $value.startDate),
    endDate: data.get(#endDate, or: $value.endDate),
    participantCounts: data.get(
      #participantCounts,
      or: $value.participantCounts,
    ),
  );

  @override
  ABTestCopyWith<$R2, ABTest, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ABTestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ABTestVariantMapper extends ClassMapperBase<ABTestVariant> {
  ABTestVariantMapper._();

  static ABTestVariantMapper? _instance;
  static ABTestVariantMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ABTestVariantMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ABTestVariant';

  static String _$variantId(ABTestVariant v) => v.variantId;
  static const Field<ABTestVariant, String> _f$variantId = Field(
    'variantId',
    _$variantId,
  );
  static String _$name(ABTestVariant v) => v.name;
  static const Field<ABTestVariant, String> _f$name = Field('name', _$name);
  static double _$weight(ABTestVariant v) => v.weight;
  static const Field<ABTestVariant, double> _f$weight = Field(
    'weight',
    _$weight,
  );
  static Map<String, dynamic> _$config(ABTestVariant v) => v.config;
  static const Field<ABTestVariant, Map<String, dynamic>> _f$config = Field(
    'config',
    _$config,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<ABTestVariant> fields = const {
    #variantId: _f$variantId,
    #name: _f$name,
    #weight: _f$weight,
    #config: _f$config,
  };

  static ABTestVariant _instantiate(DecodingData data) {
    return ABTestVariant(
      variantId: data.dec(_f$variantId),
      name: data.dec(_f$name),
      weight: data.dec(_f$weight),
      config: data.dec(_f$config),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ABTestVariant fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ABTestVariant>(map);
  }

  static ABTestVariant fromJson(String json) {
    return ensureInitialized().decodeJson<ABTestVariant>(json);
  }
}

mixin ABTestVariantMappable {
  String toJson() {
    return ABTestVariantMapper.ensureInitialized().encodeJson<ABTestVariant>(
      this as ABTestVariant,
    );
  }

  Map<String, dynamic> toMap() {
    return ABTestVariantMapper.ensureInitialized().encodeMap<ABTestVariant>(
      this as ABTestVariant,
    );
  }

  ABTestVariantCopyWith<ABTestVariant, ABTestVariant, ABTestVariant>
  get copyWith => _ABTestVariantCopyWithImpl<ABTestVariant, ABTestVariant>(
    this as ABTestVariant,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ABTestVariantMapper.ensureInitialized().stringifyValue(
      this as ABTestVariant,
    );
  }

  @override
  bool operator ==(Object other) {
    return ABTestVariantMapper.ensureInitialized().equalsValue(
      this as ABTestVariant,
      other,
    );
  }

  @override
  int get hashCode {
    return ABTestVariantMapper.ensureInitialized().hashValue(
      this as ABTestVariant,
    );
  }
}

extension ABTestVariantValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ABTestVariant, $Out> {
  ABTestVariantCopyWith<$R, ABTestVariant, $Out> get $asABTestVariant =>
      $base.as((v, t, t2) => _ABTestVariantCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ABTestVariantCopyWith<$R, $In extends ABTestVariant, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get config;
  $R call({
    String? variantId,
    String? name,
    double? weight,
    Map<String, dynamic>? config,
  });
  ABTestVariantCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ABTestVariantCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ABTestVariant, $Out>
    implements ABTestVariantCopyWith<$R, ABTestVariant, $Out> {
  _ABTestVariantCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ABTestVariant> $mapper =
      ABTestVariantMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get config => MapCopyWith(
    $value.config,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(config: v),
  );
  @override
  $R call({
    String? variantId,
    String? name,
    double? weight,
    Map<String, dynamic>? config,
  }) => $apply(
    FieldCopyWithData({
      if (variantId != null) #variantId: variantId,
      if (name != null) #name: name,
      if (weight != null) #weight: weight,
      if (config != null) #config: config,
    }),
  );
  @override
  ABTestVariant $make(CopyWithData data) => ABTestVariant(
    variantId: data.get(#variantId, or: $value.variantId),
    name: data.get(#name, or: $value.name),
    weight: data.get(#weight, or: $value.weight),
    config: data.get(#config, or: $value.config),
  );

  @override
  ABTestVariantCopyWith<$R2, ABTestVariant, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ABTestVariantCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AppLogMapper extends ClassMapperBase<AppLog> {
  AppLogMapper._();

  static AppLogMapper? _instance;
  static AppLogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppLogMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AppLog';

  static String _$logId(AppLog v) => v.logId;
  static const Field<AppLog, String> _f$logId = Field('logId', _$logId);
  static LogLevel _$level(AppLog v) => v.level;
  static const Field<AppLog, LogLevel> _f$level = Field('level', _$level);
  static String _$message(AppLog v) => v.message;
  static const Field<AppLog, String> _f$message = Field('message', _$message);
  static String? _$tag(AppLog v) => v.tag;
  static const Field<AppLog, String> _f$tag = Field('tag', _$tag, opt: true);
  static Map<String, dynamic> _$data(AppLog v) => v.data;
  static const Field<AppLog, Map<String, dynamic>> _f$data = Field(
    'data',
    _$data,
    opt: true,
    def: const {},
  );
  static DateTime _$timestamp(AppLog v) => v.timestamp;
  static const Field<AppLog, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static String? _$userId(AppLog v) => v.userId;
  static const Field<AppLog, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );
  static String? _$sessionId(AppLog v) => v.sessionId;
  static const Field<AppLog, String> _f$sessionId = Field(
    'sessionId',
    _$sessionId,
    opt: true,
  );

  @override
  final MappableFields<AppLog> fields = const {
    #logId: _f$logId,
    #level: _f$level,
    #message: _f$message,
    #tag: _f$tag,
    #data: _f$data,
    #timestamp: _f$timestamp,
    #userId: _f$userId,
    #sessionId: _f$sessionId,
  };

  static AppLog _instantiate(DecodingData data) {
    return AppLog(
      logId: data.dec(_f$logId),
      level: data.dec(_f$level),
      message: data.dec(_f$message),
      tag: data.dec(_f$tag),
      data: data.dec(_f$data),
      timestamp: data.dec(_f$timestamp),
      userId: data.dec(_f$userId),
      sessionId: data.dec(_f$sessionId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppLog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppLog>(map);
  }

  static AppLog fromJson(String json) {
    return ensureInitialized().decodeJson<AppLog>(json);
  }
}

mixin AppLogMappable {
  String toJson() {
    return AppLogMapper.ensureInitialized().encodeJson<AppLog>(this as AppLog);
  }

  Map<String, dynamic> toMap() {
    return AppLogMapper.ensureInitialized().encodeMap<AppLog>(this as AppLog);
  }

  AppLogCopyWith<AppLog, AppLog, AppLog> get copyWith =>
      _AppLogCopyWithImpl<AppLog, AppLog>(this as AppLog, $identity, $identity);
  @override
  String toString() {
    return AppLogMapper.ensureInitialized().stringifyValue(this as AppLog);
  }

  @override
  bool operator ==(Object other) {
    return AppLogMapper.ensureInitialized().equalsValue(this as AppLog, other);
  }

  @override
  int get hashCode {
    return AppLogMapper.ensureInitialized().hashValue(this as AppLog);
  }
}

extension AppLogValueCopy<$R, $Out> on ObjectCopyWith<$R, AppLog, $Out> {
  AppLogCopyWith<$R, AppLog, $Out> get $asAppLog =>
      $base.as((v, t, t2) => _AppLogCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppLogCopyWith<$R, $In extends AppLog, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get data;
  $R call({
    String? logId,
    LogLevel? level,
    String? message,
    String? tag,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    String? userId,
    String? sessionId,
  });
  AppLogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AppLogCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, AppLog, $Out>
    implements AppLogCopyWith<$R, AppLog, $Out> {
  _AppLogCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppLog> $mapper = AppLogMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get data => MapCopyWith(
    $value.data,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(data: v),
  );
  @override
  $R call({
    String? logId,
    LogLevel? level,
    String? message,
    Object? tag = $none,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    Object? userId = $none,
    Object? sessionId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (logId != null) #logId: logId,
      if (level != null) #level: level,
      if (message != null) #message: message,
      if (tag != $none) #tag: tag,
      if (data != null) #data: data,
      if (timestamp != null) #timestamp: timestamp,
      if (userId != $none) #userId: userId,
      if (sessionId != $none) #sessionId: sessionId,
    }),
  );
  @override
  AppLog $make(CopyWithData data) => AppLog(
    logId: data.get(#logId, or: $value.logId),
    level: data.get(#level, or: $value.level),
    message: data.get(#message, or: $value.message),
    tag: data.get(#tag, or: $value.tag),
    data: data.get(#data, or: $value.data),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    userId: data.get(#userId, or: $value.userId),
    sessionId: data.get(#sessionId, or: $value.sessionId),
  );

  @override
  AppLogCopyWith<$R2, AppLog, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AppLogCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AppHealthStatusMapper extends ClassMapperBase<AppHealthStatus> {
  AppHealthStatusMapper._();

  static AppHealthStatusMapper? _instance;
  static AppHealthStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppHealthStatusMapper._());
      HealthCheckMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AppHealthStatus';

  static DateTime _$checkTime(AppHealthStatus v) => v.checkTime;
  static const Field<AppHealthStatus, DateTime> _f$checkTime = Field(
    'checkTime',
    _$checkTime,
  );
  static bool _$isHealthy(AppHealthStatus v) => v.isHealthy;
  static const Field<AppHealthStatus, bool> _f$isHealthy = Field(
    'isHealthy',
    _$isHealthy,
  );
  static List<HealthCheck> _$checks(AppHealthStatus v) => v.checks;
  static const Field<AppHealthStatus, List<HealthCheck>> _f$checks = Field(
    'checks',
    _$checks,
  );
  static Map<String, dynamic> _$metrics(AppHealthStatus v) => v.metrics;
  static const Field<AppHealthStatus, Map<String, dynamic>> _f$metrics = Field(
    'metrics',
    _$metrics,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<AppHealthStatus> fields = const {
    #checkTime: _f$checkTime,
    #isHealthy: _f$isHealthy,
    #checks: _f$checks,
    #metrics: _f$metrics,
  };

  static AppHealthStatus _instantiate(DecodingData data) {
    return AppHealthStatus(
      checkTime: data.dec(_f$checkTime),
      isHealthy: data.dec(_f$isHealthy),
      checks: data.dec(_f$checks),
      metrics: data.dec(_f$metrics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppHealthStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppHealthStatus>(map);
  }

  static AppHealthStatus fromJson(String json) {
    return ensureInitialized().decodeJson<AppHealthStatus>(json);
  }
}

mixin AppHealthStatusMappable {
  String toJson() {
    return AppHealthStatusMapper.ensureInitialized()
        .encodeJson<AppHealthStatus>(this as AppHealthStatus);
  }

  Map<String, dynamic> toMap() {
    return AppHealthStatusMapper.ensureInitialized().encodeMap<AppHealthStatus>(
      this as AppHealthStatus,
    );
  }

  AppHealthStatusCopyWith<AppHealthStatus, AppHealthStatus, AppHealthStatus>
  get copyWith =>
      _AppHealthStatusCopyWithImpl<AppHealthStatus, AppHealthStatus>(
        this as AppHealthStatus,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AppHealthStatusMapper.ensureInitialized().stringifyValue(
      this as AppHealthStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    return AppHealthStatusMapper.ensureInitialized().equalsValue(
      this as AppHealthStatus,
      other,
    );
  }

  @override
  int get hashCode {
    return AppHealthStatusMapper.ensureInitialized().hashValue(
      this as AppHealthStatus,
    );
  }
}

extension AppHealthStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AppHealthStatus, $Out> {
  AppHealthStatusCopyWith<$R, AppHealthStatus, $Out> get $asAppHealthStatus =>
      $base.as((v, t, t2) => _AppHealthStatusCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppHealthStatusCopyWith<$R, $In extends AppHealthStatus, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    HealthCheck,
    HealthCheckCopyWith<$R, HealthCheck, HealthCheck>
  >
  get checks;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metrics;
  $R call({
    DateTime? checkTime,
    bool? isHealthy,
    List<HealthCheck>? checks,
    Map<String, dynamic>? metrics,
  });
  AppHealthStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AppHealthStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppHealthStatus, $Out>
    implements AppHealthStatusCopyWith<$R, AppHealthStatus, $Out> {
  _AppHealthStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppHealthStatus> $mapper =
      AppHealthStatusMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    HealthCheck,
    HealthCheckCopyWith<$R, HealthCheck, HealthCheck>
  >
  get checks => ListCopyWith(
    $value.checks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(checks: v),
  );
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metrics => MapCopyWith(
    $value.metrics,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(metrics: v),
  );
  @override
  $R call({
    DateTime? checkTime,
    bool? isHealthy,
    List<HealthCheck>? checks,
    Map<String, dynamic>? metrics,
  }) => $apply(
    FieldCopyWithData({
      if (checkTime != null) #checkTime: checkTime,
      if (isHealthy != null) #isHealthy: isHealthy,
      if (checks != null) #checks: checks,
      if (metrics != null) #metrics: metrics,
    }),
  );
  @override
  AppHealthStatus $make(CopyWithData data) => AppHealthStatus(
    checkTime: data.get(#checkTime, or: $value.checkTime),
    isHealthy: data.get(#isHealthy, or: $value.isHealthy),
    checks: data.get(#checks, or: $value.checks),
    metrics: data.get(#metrics, or: $value.metrics),
  );

  @override
  AppHealthStatusCopyWith<$R2, AppHealthStatus, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppHealthStatusCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class HealthCheckMapper extends ClassMapperBase<HealthCheck> {
  HealthCheckMapper._();

  static HealthCheckMapper? _instance;
  static HealthCheckMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = HealthCheckMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'HealthCheck';

  static String _$checkName(HealthCheck v) => v.checkName;
  static const Field<HealthCheck, String> _f$checkName = Field(
    'checkName',
    _$checkName,
  );
  static bool _$passed(HealthCheck v) => v.passed;
  static const Field<HealthCheck, bool> _f$passed = Field('passed', _$passed);
  static String? _$message(HealthCheck v) => v.message;
  static const Field<HealthCheck, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
  );
  static double? _$responseTime(HealthCheck v) => v.responseTime;
  static const Field<HealthCheck, double> _f$responseTime = Field(
    'responseTime',
    _$responseTime,
    opt: true,
  );

  @override
  final MappableFields<HealthCheck> fields = const {
    #checkName: _f$checkName,
    #passed: _f$passed,
    #message: _f$message,
    #responseTime: _f$responseTime,
  };

  static HealthCheck _instantiate(DecodingData data) {
    return HealthCheck(
      checkName: data.dec(_f$checkName),
      passed: data.dec(_f$passed),
      message: data.dec(_f$message),
      responseTime: data.dec(_f$responseTime),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static HealthCheck fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<HealthCheck>(map);
  }

  static HealthCheck fromJson(String json) {
    return ensureInitialized().decodeJson<HealthCheck>(json);
  }
}

mixin HealthCheckMappable {
  String toJson() {
    return HealthCheckMapper.ensureInitialized().encodeJson<HealthCheck>(
      this as HealthCheck,
    );
  }

  Map<String, dynamic> toMap() {
    return HealthCheckMapper.ensureInitialized().encodeMap<HealthCheck>(
      this as HealthCheck,
    );
  }

  HealthCheckCopyWith<HealthCheck, HealthCheck, HealthCheck> get copyWith =>
      _HealthCheckCopyWithImpl<HealthCheck, HealthCheck>(
        this as HealthCheck,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return HealthCheckMapper.ensureInitialized().stringifyValue(
      this as HealthCheck,
    );
  }

  @override
  bool operator ==(Object other) {
    return HealthCheckMapper.ensureInitialized().equalsValue(
      this as HealthCheck,
      other,
    );
  }

  @override
  int get hashCode {
    return HealthCheckMapper.ensureInitialized().hashValue(this as HealthCheck);
  }
}

extension HealthCheckValueCopy<$R, $Out>
    on ObjectCopyWith<$R, HealthCheck, $Out> {
  HealthCheckCopyWith<$R, HealthCheck, $Out> get $asHealthCheck =>
      $base.as((v, t, t2) => _HealthCheckCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class HealthCheckCopyWith<$R, $In extends HealthCheck, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? checkName,
    bool? passed,
    String? message,
    double? responseTime,
  });
  HealthCheckCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _HealthCheckCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, HealthCheck, $Out>
    implements HealthCheckCopyWith<$R, HealthCheck, $Out> {
  _HealthCheckCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<HealthCheck> $mapper =
      HealthCheckMapper.ensureInitialized();
  @override
  $R call({
    String? checkName,
    bool? passed,
    Object? message = $none,
    Object? responseTime = $none,
  }) => $apply(
    FieldCopyWithData({
      if (checkName != null) #checkName: checkName,
      if (passed != null) #passed: passed,
      if (message != $none) #message: message,
      if (responseTime != $none) #responseTime: responseTime,
    }),
  );
  @override
  HealthCheck $make(CopyWithData data) => HealthCheck(
    checkName: data.get(#checkName, or: $value.checkName),
    passed: data.get(#passed, or: $value.passed),
    message: data.get(#message, or: $value.message),
    responseTime: data.get(#responseTime, or: $value.responseTime),
  );

  @override
  HealthCheckCopyWith<$R2, HealthCheck, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _HealthCheckCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RemoteConfigMapper extends ClassMapperBase<RemoteConfig> {
  RemoteConfigMapper._();

  static RemoteConfigMapper? _instance;
  static RemoteConfigMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemoteConfigMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RemoteConfig';

  static String _$configId(RemoteConfig v) => v.configId;
  static const Field<RemoteConfig, String> _f$configId = Field(
    'configId',
    _$configId,
  );
  static String _$key(RemoteConfig v) => v.key;
  static const Field<RemoteConfig, String> _f$key = Field('key', _$key);
  static dynamic _$value(RemoteConfig v) => v.value;
  static const Field<RemoteConfig, dynamic> _f$value = Field('value', _$value);
  static ConfigType _$type(RemoteConfig v) => v.type;
  static const Field<RemoteConfig, ConfigType> _f$type = Field('type', _$type);
  static String? _$description(RemoteConfig v) => v.description;
  static const Field<RemoteConfig, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static DateTime _$updatedAt(RemoteConfig v) => v.updatedAt;
  static const Field<RemoteConfig, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );

  @override
  final MappableFields<RemoteConfig> fields = const {
    #configId: _f$configId,
    #key: _f$key,
    #value: _f$value,
    #type: _f$type,
    #description: _f$description,
    #updatedAt: _f$updatedAt,
  };

  static RemoteConfig _instantiate(DecodingData data) {
    return RemoteConfig(
      configId: data.dec(_f$configId),
      key: data.dec(_f$key),
      value: data.dec(_f$value),
      type: data.dec(_f$type),
      description: data.dec(_f$description),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RemoteConfig fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RemoteConfig>(map);
  }

  static RemoteConfig fromJson(String json) {
    return ensureInitialized().decodeJson<RemoteConfig>(json);
  }
}

mixin RemoteConfigMappable {
  String toJson() {
    return RemoteConfigMapper.ensureInitialized().encodeJson<RemoteConfig>(
      this as RemoteConfig,
    );
  }

  Map<String, dynamic> toMap() {
    return RemoteConfigMapper.ensureInitialized().encodeMap<RemoteConfig>(
      this as RemoteConfig,
    );
  }

  RemoteConfigCopyWith<RemoteConfig, RemoteConfig, RemoteConfig> get copyWith =>
      _RemoteConfigCopyWithImpl<RemoteConfig, RemoteConfig>(
        this as RemoteConfig,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RemoteConfigMapper.ensureInitialized().stringifyValue(
      this as RemoteConfig,
    );
  }

  @override
  bool operator ==(Object other) {
    return RemoteConfigMapper.ensureInitialized().equalsValue(
      this as RemoteConfig,
      other,
    );
  }

  @override
  int get hashCode {
    return RemoteConfigMapper.ensureInitialized().hashValue(
      this as RemoteConfig,
    );
  }
}

extension RemoteConfigValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RemoteConfig, $Out> {
  RemoteConfigCopyWith<$R, RemoteConfig, $Out> get $asRemoteConfig =>
      $base.as((v, t, t2) => _RemoteConfigCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RemoteConfigCopyWith<$R, $In extends RemoteConfig, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? configId,
    String? key,
    dynamic value,
    ConfigType? type,
    String? description,
    DateTime? updatedAt,
  });
  RemoteConfigCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RemoteConfigCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RemoteConfig, $Out>
    implements RemoteConfigCopyWith<$R, RemoteConfig, $Out> {
  _RemoteConfigCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RemoteConfig> $mapper =
      RemoteConfigMapper.ensureInitialized();
  @override
  $R call({
    String? configId,
    String? key,
    Object? value = $none,
    ConfigType? type,
    Object? description = $none,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (configId != null) #configId: configId,
      if (key != null) #key: key,
      if (value != $none) #value: value,
      if (type != null) #type: type,
      if (description != $none) #description: description,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  RemoteConfig $make(CopyWithData data) => RemoteConfig(
    configId: data.get(#configId, or: $value.configId),
    key: data.get(#key, or: $value.key),
    value: data.get(#value, or: $value.value),
    type: data.get(#type, or: $value.type),
    description: data.get(#description, or: $value.description),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  RemoteConfigCopyWith<$R2, RemoteConfig, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RemoteConfigCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UserFeedbackMapper extends ClassMapperBase<UserFeedback> {
  UserFeedbackMapper._();

  static UserFeedbackMapper? _instance;
  static UserFeedbackMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserFeedbackMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserFeedback';

  static String _$feedbackId(UserFeedback v) => v.feedbackId;
  static const Field<UserFeedback, String> _f$feedbackId = Field(
    'feedbackId',
    _$feedbackId,
  );
  static String _$userId(UserFeedback v) => v.userId;
  static const Field<UserFeedback, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static FeedbackType _$type(UserFeedback v) => v.type;
  static const Field<UserFeedback, FeedbackType> _f$type = Field(
    'type',
    _$type,
  );
  static int? _$rating(UserFeedback v) => v.rating;
  static const Field<UserFeedback, int> _f$rating = Field(
    'rating',
    _$rating,
    opt: true,
  );
  static String? _$comment(UserFeedback v) => v.comment;
  static const Field<UserFeedback, String> _f$comment = Field(
    'comment',
    _$comment,
    opt: true,
  );
  static String? _$screenshot(UserFeedback v) => v.screenshot;
  static const Field<UserFeedback, String> _f$screenshot = Field(
    'screenshot',
    _$screenshot,
    opt: true,
  );
  static Map<String, dynamic> _$metadata(UserFeedback v) => v.metadata;
  static const Field<UserFeedback, Map<String, dynamic>> _f$metadata = Field(
    'metadata',
    _$metadata,
    opt: true,
    def: const {},
  );
  static DateTime _$createdAt(UserFeedback v) => v.createdAt;
  static const Field<UserFeedback, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static bool _$wasReviewed(UserFeedback v) => v.wasReviewed;
  static const Field<UserFeedback, bool> _f$wasReviewed = Field(
    'wasReviewed',
    _$wasReviewed,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<UserFeedback> fields = const {
    #feedbackId: _f$feedbackId,
    #userId: _f$userId,
    #type: _f$type,
    #rating: _f$rating,
    #comment: _f$comment,
    #screenshot: _f$screenshot,
    #metadata: _f$metadata,
    #createdAt: _f$createdAt,
    #wasReviewed: _f$wasReviewed,
  };

  static UserFeedback _instantiate(DecodingData data) {
    return UserFeedback(
      feedbackId: data.dec(_f$feedbackId),
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      rating: data.dec(_f$rating),
      comment: data.dec(_f$comment),
      screenshot: data.dec(_f$screenshot),
      metadata: data.dec(_f$metadata),
      createdAt: data.dec(_f$createdAt),
      wasReviewed: data.dec(_f$wasReviewed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserFeedback fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserFeedback>(map);
  }

  static UserFeedback fromJson(String json) {
    return ensureInitialized().decodeJson<UserFeedback>(json);
  }
}

mixin UserFeedbackMappable {
  String toJson() {
    return UserFeedbackMapper.ensureInitialized().encodeJson<UserFeedback>(
      this as UserFeedback,
    );
  }

  Map<String, dynamic> toMap() {
    return UserFeedbackMapper.ensureInitialized().encodeMap<UserFeedback>(
      this as UserFeedback,
    );
  }

  UserFeedbackCopyWith<UserFeedback, UserFeedback, UserFeedback> get copyWith =>
      _UserFeedbackCopyWithImpl<UserFeedback, UserFeedback>(
        this as UserFeedback,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserFeedbackMapper.ensureInitialized().stringifyValue(
      this as UserFeedback,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserFeedbackMapper.ensureInitialized().equalsValue(
      this as UserFeedback,
      other,
    );
  }

  @override
  int get hashCode {
    return UserFeedbackMapper.ensureInitialized().hashValue(
      this as UserFeedback,
    );
  }
}

extension UserFeedbackValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserFeedback, $Out> {
  UserFeedbackCopyWith<$R, UserFeedback, $Out> get $asUserFeedback =>
      $base.as((v, t, t2) => _UserFeedbackCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserFeedbackCopyWith<$R, $In extends UserFeedback, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata;
  $R call({
    String? feedbackId,
    String? userId,
    FeedbackType? type,
    int? rating,
    String? comment,
    String? screenshot,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    bool? wasReviewed,
  });
  UserFeedbackCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserFeedbackCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserFeedback, $Out>
    implements UserFeedbackCopyWith<$R, UserFeedback, $Out> {
  _UserFeedbackCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserFeedback> $mapper =
      UserFeedbackMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata => MapCopyWith(
    $value.metadata,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(metadata: v),
  );
  @override
  $R call({
    String? feedbackId,
    String? userId,
    FeedbackType? type,
    Object? rating = $none,
    Object? comment = $none,
    Object? screenshot = $none,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    bool? wasReviewed,
  }) => $apply(
    FieldCopyWithData({
      if (feedbackId != null) #feedbackId: feedbackId,
      if (userId != null) #userId: userId,
      if (type != null) #type: type,
      if (rating != $none) #rating: rating,
      if (comment != $none) #comment: comment,
      if (screenshot != $none) #screenshot: screenshot,
      if (metadata != null) #metadata: metadata,
      if (createdAt != null) #createdAt: createdAt,
      if (wasReviewed != null) #wasReviewed: wasReviewed,
    }),
  );
  @override
  UserFeedback $make(CopyWithData data) => UserFeedback(
    feedbackId: data.get(#feedbackId, or: $value.feedbackId),
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    rating: data.get(#rating, or: $value.rating),
    comment: data.get(#comment, or: $value.comment),
    screenshot: data.get(#screenshot, or: $value.screenshot),
    metadata: data.get(#metadata, or: $value.metadata),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    wasReviewed: data.get(#wasReviewed, or: $value.wasReviewed),
  );

  @override
  UserFeedbackCopyWith<$R2, UserFeedback, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserFeedbackCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

