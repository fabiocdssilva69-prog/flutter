// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'smart_reminder.dart';

class SmartReminderMapper extends ClassMapperBase<SmartReminder> {
  SmartReminderMapper._();

  static SmartReminderMapper? _instance;
  static SmartReminderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SmartReminderMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SmartReminder';

  static String _$reminderId(SmartReminder v) => v.reminderId;
  static const Field<SmartReminder, String> _f$reminderId = Field(
    'reminderId',
    _$reminderId,
  );
  static String _$userId(SmartReminder v) => v.userId;
  static const Field<SmartReminder, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static ReminderType _$type(SmartReminder v) => v.type;
  static const Field<SmartReminder, ReminderType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$title(SmartReminder v) => v.title;
  static const Field<SmartReminder, String> _f$title = Field('title', _$title);
  static String _$message(SmartReminder v) => v.message;
  static const Field<SmartReminder, String> _f$message = Field(
    'message',
    _$message,
  );
  static DateTime _$scheduledFor(SmartReminder v) => v.scheduledFor;
  static const Field<SmartReminder, DateTime> _f$scheduledFor = Field(
    'scheduledFor',
    _$scheduledFor,
  );
  static Map<String, dynamic>? _$context(SmartReminder v) => v.context;
  static const Field<SmartReminder, Map<String, dynamic>> _f$context = Field(
    'context',
    _$context,
    opt: true,
  );
  static bool _$wasSent(SmartReminder v) => v.wasSent;
  static const Field<SmartReminder, bool> _f$wasSent = Field(
    'wasSent',
    _$wasSent,
    opt: true,
    def: false,
  );
  static bool _$wasActedUpon(SmartReminder v) => v.wasActedUpon;
  static const Field<SmartReminder, bool> _f$wasActedUpon = Field(
    'wasActedUpon',
    _$wasActedUpon,
    opt: true,
    def: false,
  );
  static int _$priority(SmartReminder v) => v.priority;
  static const Field<SmartReminder, int> _f$priority = Field(
    'priority',
    _$priority,
    opt: true,
    def: 3,
  );
  static DateTime _$createdAt(SmartReminder v) => v.createdAt;
  static const Field<SmartReminder, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<SmartReminder> fields = const {
    #reminderId: _f$reminderId,
    #userId: _f$userId,
    #type: _f$type,
    #title: _f$title,
    #message: _f$message,
    #scheduledFor: _f$scheduledFor,
    #context: _f$context,
    #wasSent: _f$wasSent,
    #wasActedUpon: _f$wasActedUpon,
    #priority: _f$priority,
    #createdAt: _f$createdAt,
  };

  static SmartReminder _instantiate(DecodingData data) {
    return SmartReminder(
      reminderId: data.dec(_f$reminderId),
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      title: data.dec(_f$title),
      message: data.dec(_f$message),
      scheduledFor: data.dec(_f$scheduledFor),
      context: data.dec(_f$context),
      wasSent: data.dec(_f$wasSent),
      wasActedUpon: data.dec(_f$wasActedUpon),
      priority: data.dec(_f$priority),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SmartReminder fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SmartReminder>(map);
  }

  static SmartReminder fromJson(String json) {
    return ensureInitialized().decodeJson<SmartReminder>(json);
  }
}

mixin SmartReminderMappable {
  String toJson() {
    return SmartReminderMapper.ensureInitialized().encodeJson<SmartReminder>(
      this as SmartReminder,
    );
  }

  Map<String, dynamic> toMap() {
    return SmartReminderMapper.ensureInitialized().encodeMap<SmartReminder>(
      this as SmartReminder,
    );
  }

  SmartReminderCopyWith<SmartReminder, SmartReminder, SmartReminder>
  get copyWith => _SmartReminderCopyWithImpl<SmartReminder, SmartReminder>(
    this as SmartReminder,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SmartReminderMapper.ensureInitialized().stringifyValue(
      this as SmartReminder,
    );
  }

  @override
  bool operator ==(Object other) {
    return SmartReminderMapper.ensureInitialized().equalsValue(
      this as SmartReminder,
      other,
    );
  }

  @override
  int get hashCode {
    return SmartReminderMapper.ensureInitialized().hashValue(
      this as SmartReminder,
    );
  }
}

extension SmartReminderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SmartReminder, $Out> {
  SmartReminderCopyWith<$R, SmartReminder, $Out> get $asSmartReminder =>
      $base.as((v, t, t2) => _SmartReminderCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SmartReminderCopyWith<$R, $In extends SmartReminder, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get context;
  $R call({
    String? reminderId,
    String? userId,
    ReminderType? type,
    String? title,
    String? message,
    DateTime? scheduledFor,
    Map<String, dynamic>? context,
    bool? wasSent,
    bool? wasActedUpon,
    int? priority,
    DateTime? createdAt,
  });
  SmartReminderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SmartReminderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SmartReminder, $Out>
    implements SmartReminderCopyWith<$R, SmartReminder, $Out> {
  _SmartReminderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SmartReminder> $mapper =
      SmartReminderMapper.ensureInitialized();
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
    String? reminderId,
    String? userId,
    ReminderType? type,
    String? title,
    String? message,
    DateTime? scheduledFor,
    Object? context = $none,
    bool? wasSent,
    bool? wasActedUpon,
    int? priority,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (reminderId != null) #reminderId: reminderId,
      if (userId != null) #userId: userId,
      if (type != null) #type: type,
      if (title != null) #title: title,
      if (message != null) #message: message,
      if (scheduledFor != null) #scheduledFor: scheduledFor,
      if (context != $none) #context: context,
      if (wasSent != null) #wasSent: wasSent,
      if (wasActedUpon != null) #wasActedUpon: wasActedUpon,
      if (priority != null) #priority: priority,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  SmartReminder $make(CopyWithData data) => SmartReminder(
    reminderId: data.get(#reminderId, or: $value.reminderId),
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    title: data.get(#title, or: $value.title),
    message: data.get(#message, or: $value.message),
    scheduledFor: data.get(#scheduledFor, or: $value.scheduledFor),
    context: data.get(#context, or: $value.context),
    wasSent: data.get(#wasSent, or: $value.wasSent),
    wasActedUpon: data.get(#wasActedUpon, or: $value.wasActedUpon),
    priority: data.get(#priority, or: $value.priority),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  SmartReminderCopyWith<$R2, SmartReminder, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SmartReminderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ReminderPreferencesMapper extends ClassMapperBase<ReminderPreferences> {
  ReminderPreferencesMapper._();

  static ReminderPreferencesMapper? _instance;
  static ReminderPreferencesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReminderPreferencesMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ReminderPreferences';

  static Set<ReminderType> _$enabledTypes(ReminderPreferences v) =>
      v.enabledTypes;
  static const Field<ReminderPreferences, Set<ReminderType>> _f$enabledTypes =
      Field(
        'enabledTypes',
        _$enabledTypes,
        opt: true,
        def: const {
          ReminderType.replyToMessage,
          ReminderType.matchExpiringSoon,
          ReminderType.superLikeRenewed,
        },
      );
  static int _$startHour(ReminderPreferences v) => v.startHour;
  static const Field<ReminderPreferences, int> _f$startHour = Field(
    'startHour',
    _$startHour,
    opt: true,
    def: 9,
  );
  static int _$endHour(ReminderPreferences v) => v.endHour;
  static const Field<ReminderPreferences, int> _f$endHour = Field(
    'endHour',
    _$endHour,
    opt: true,
    def: 22,
  );
  static Set<int> _$enabledDays(ReminderPreferences v) => v.enabledDays;
  static const Field<ReminderPreferences, Set<int>> _f$enabledDays = Field(
    'enabledDays',
    _$enabledDays,
    opt: true,
    def: const {1, 2, 3, 4, 5, 6, 0},
  );
  static int _$maxPerDay(ReminderPreferences v) => v.maxPerDay;
  static const Field<ReminderPreferences, int> _f$maxPerDay = Field(
    'maxPerDay',
    _$maxPerDay,
    opt: true,
    def: 5,
  );

  @override
  final MappableFields<ReminderPreferences> fields = const {
    #enabledTypes: _f$enabledTypes,
    #startHour: _f$startHour,
    #endHour: _f$endHour,
    #enabledDays: _f$enabledDays,
    #maxPerDay: _f$maxPerDay,
  };

  static ReminderPreferences _instantiate(DecodingData data) {
    return ReminderPreferences(
      enabledTypes: data.dec(_f$enabledTypes),
      startHour: data.dec(_f$startHour),
      endHour: data.dec(_f$endHour),
      enabledDays: data.dec(_f$enabledDays),
      maxPerDay: data.dec(_f$maxPerDay),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ReminderPreferences fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReminderPreferences>(map);
  }

  static ReminderPreferences fromJson(String json) {
    return ensureInitialized().decodeJson<ReminderPreferences>(json);
  }
}

mixin ReminderPreferencesMappable {
  String toJson() {
    return ReminderPreferencesMapper.ensureInitialized()
        .encodeJson<ReminderPreferences>(this as ReminderPreferences);
  }

  Map<String, dynamic> toMap() {
    return ReminderPreferencesMapper.ensureInitialized()
        .encodeMap<ReminderPreferences>(this as ReminderPreferences);
  }

  ReminderPreferencesCopyWith<
    ReminderPreferences,
    ReminderPreferences,
    ReminderPreferences
  >
  get copyWith =>
      _ReminderPreferencesCopyWithImpl<
        ReminderPreferences,
        ReminderPreferences
      >(this as ReminderPreferences, $identity, $identity);
  @override
  String toString() {
    return ReminderPreferencesMapper.ensureInitialized().stringifyValue(
      this as ReminderPreferences,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReminderPreferencesMapper.ensureInitialized().equalsValue(
      this as ReminderPreferences,
      other,
    );
  }

  @override
  int get hashCode {
    return ReminderPreferencesMapper.ensureInitialized().hashValue(
      this as ReminderPreferences,
    );
  }
}

extension ReminderPreferencesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReminderPreferences, $Out> {
  ReminderPreferencesCopyWith<$R, ReminderPreferences, $Out>
  get $asReminderPreferences => $base.as(
    (v, t, t2) => _ReminderPreferencesCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ReminderPreferencesCopyWith<
  $R,
  $In extends ReminderPreferences,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Set<ReminderType>? enabledTypes,
    int? startHour,
    int? endHour,
    Set<int>? enabledDays,
    int? maxPerDay,
  });
  ReminderPreferencesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ReminderPreferencesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReminderPreferences, $Out>
    implements ReminderPreferencesCopyWith<$R, ReminderPreferences, $Out> {
  _ReminderPreferencesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReminderPreferences> $mapper =
      ReminderPreferencesMapper.ensureInitialized();
  @override
  $R call({
    Set<ReminderType>? enabledTypes,
    int? startHour,
    int? endHour,
    Set<int>? enabledDays,
    int? maxPerDay,
  }) => $apply(
    FieldCopyWithData({
      if (enabledTypes != null) #enabledTypes: enabledTypes,
      if (startHour != null) #startHour: startHour,
      if (endHour != null) #endHour: endHour,
      if (enabledDays != null) #enabledDays: enabledDays,
      if (maxPerDay != null) #maxPerDay: maxPerDay,
    }),
  );
  @override
  ReminderPreferences $make(CopyWithData data) => ReminderPreferences(
    enabledTypes: data.get(#enabledTypes, or: $value.enabledTypes),
    startHour: data.get(#startHour, or: $value.startHour),
    endHour: data.get(#endHour, or: $value.endHour),
    enabledDays: data.get(#enabledDays, or: $value.enabledDays),
    maxPerDay: data.get(#maxPerDay, or: $value.maxPerDay),
  );

  @override
  ReminderPreferencesCopyWith<$R2, ReminderPreferences, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ReminderPreferencesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

