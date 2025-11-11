// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'match_timer.dart';

class MatchTimerMapper extends ClassMapperBase<MatchTimer> {
  MatchTimerMapper._();

  static MatchTimerMapper? _instance;
  static MatchTimerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchTimerMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MatchTimer';

  static String _$timerId(MatchTimer v) => v.timerId;
  static const Field<MatchTimer, String> _f$timerId = Field(
    'timerId',
    _$timerId,
  );
  static String _$matchId(MatchTimer v) => v.matchId;
  static const Field<MatchTimer, String> _f$matchId = Field(
    'matchId',
    _$matchId,
  );
  static String _$user1Id(MatchTimer v) => v.user1Id;
  static const Field<MatchTimer, String> _f$user1Id = Field(
    'user1Id',
    _$user1Id,
  );
  static String _$user2Id(MatchTimer v) => v.user2Id;
  static const Field<MatchTimer, String> _f$user2Id = Field(
    'user2Id',
    _$user2Id,
  );
  static DateTime _$matchCreatedAt(MatchTimer v) => v.matchCreatedAt;
  static const Field<MatchTimer, DateTime> _f$matchCreatedAt = Field(
    'matchCreatedAt',
    _$matchCreatedAt,
  );
  static DateTime _$expiresAt(MatchTimer v) => v.expiresAt;
  static const Field<MatchTimer, DateTime> _f$expiresAt = Field(
    'expiresAt',
    _$expiresAt,
  );
  static TimerStatus _$status(MatchTimer v) => v.status;
  static const Field<MatchTimer, TimerStatus> _f$status = Field(
    'status',
    _$status,
  );
  static DateTime? _$firstMessageAt(MatchTimer v) => v.firstMessageAt;
  static const Field<MatchTimer, DateTime> _f$firstMessageAt = Field(
    'firstMessageAt',
    _$firstMessageAt,
    opt: true,
  );
  static DateTime? _$lastNotificationAt(MatchTimer v) => v.lastNotificationAt;
  static const Field<MatchTimer, DateTime> _f$lastNotificationAt = Field(
    'lastNotificationAt',
    _$lastNotificationAt,
    opt: true,
  );
  static bool _$isExpired(MatchTimer v) => v.isExpired;
  static const Field<MatchTimer, bool> _f$isExpired = Field(
    'isExpired',
    _$isExpired,
    mode: FieldMode.member,
  );
  static int _$hoursRemaining(MatchTimer v) => v.hoursRemaining;
  static const Field<MatchTimer, int> _f$hoursRemaining = Field(
    'hoursRemaining',
    _$hoursRemaining,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<MatchTimer> fields = const {
    #timerId: _f$timerId,
    #matchId: _f$matchId,
    #user1Id: _f$user1Id,
    #user2Id: _f$user2Id,
    #matchCreatedAt: _f$matchCreatedAt,
    #expiresAt: _f$expiresAt,
    #status: _f$status,
    #firstMessageAt: _f$firstMessageAt,
    #lastNotificationAt: _f$lastNotificationAt,
    #isExpired: _f$isExpired,
    #hoursRemaining: _f$hoursRemaining,
  };

  static MatchTimer _instantiate(DecodingData data) {
    return MatchTimer(
      timerId: data.dec(_f$timerId),
      matchId: data.dec(_f$matchId),
      user1Id: data.dec(_f$user1Id),
      user2Id: data.dec(_f$user2Id),
      matchCreatedAt: data.dec(_f$matchCreatedAt),
      expiresAt: data.dec(_f$expiresAt),
      status: data.dec(_f$status),
      firstMessageAt: data.dec(_f$firstMessageAt),
      lastNotificationAt: data.dec(_f$lastNotificationAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MatchTimer fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchTimer>(map);
  }

  static MatchTimer fromJson(String json) {
    return ensureInitialized().decodeJson<MatchTimer>(json);
  }
}

mixin MatchTimerMappable {
  String toJson() {
    return MatchTimerMapper.ensureInitialized().encodeJson<MatchTimer>(
      this as MatchTimer,
    );
  }

  Map<String, dynamic> toMap() {
    return MatchTimerMapper.ensureInitialized().encodeMap<MatchTimer>(
      this as MatchTimer,
    );
  }

  MatchTimerCopyWith<MatchTimer, MatchTimer, MatchTimer> get copyWith =>
      _MatchTimerCopyWithImpl<MatchTimer, MatchTimer>(
        this as MatchTimer,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MatchTimerMapper.ensureInitialized().stringifyValue(
      this as MatchTimer,
    );
  }

  @override
  bool operator ==(Object other) {
    return MatchTimerMapper.ensureInitialized().equalsValue(
      this as MatchTimer,
      other,
    );
  }

  @override
  int get hashCode {
    return MatchTimerMapper.ensureInitialized().hashValue(this as MatchTimer);
  }
}

extension MatchTimerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchTimer, $Out> {
  MatchTimerCopyWith<$R, MatchTimer, $Out> get $asMatchTimer =>
      $base.as((v, t, t2) => _MatchTimerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchTimerCopyWith<$R, $In extends MatchTimer, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? timerId,
    String? matchId,
    String? user1Id,
    String? user2Id,
    DateTime? matchCreatedAt,
    DateTime? expiresAt,
    TimerStatus? status,
    DateTime? firstMessageAt,
    DateTime? lastNotificationAt,
  });
  MatchTimerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MatchTimerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchTimer, $Out>
    implements MatchTimerCopyWith<$R, MatchTimer, $Out> {
  _MatchTimerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchTimer> $mapper =
      MatchTimerMapper.ensureInitialized();
  @override
  $R call({
    String? timerId,
    String? matchId,
    String? user1Id,
    String? user2Id,
    DateTime? matchCreatedAt,
    DateTime? expiresAt,
    TimerStatus? status,
    Object? firstMessageAt = $none,
    Object? lastNotificationAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (timerId != null) #timerId: timerId,
      if (matchId != null) #matchId: matchId,
      if (user1Id != null) #user1Id: user1Id,
      if (user2Id != null) #user2Id: user2Id,
      if (matchCreatedAt != null) #matchCreatedAt: matchCreatedAt,
      if (expiresAt != null) #expiresAt: expiresAt,
      if (status != null) #status: status,
      if (firstMessageAt != $none) #firstMessageAt: firstMessageAt,
      if (lastNotificationAt != $none) #lastNotificationAt: lastNotificationAt,
    }),
  );
  @override
  MatchTimer $make(CopyWithData data) => MatchTimer(
    timerId: data.get(#timerId, or: $value.timerId),
    matchId: data.get(#matchId, or: $value.matchId),
    user1Id: data.get(#user1Id, or: $value.user1Id),
    user2Id: data.get(#user2Id, or: $value.user2Id),
    matchCreatedAt: data.get(#matchCreatedAt, or: $value.matchCreatedAt),
    expiresAt: data.get(#expiresAt, or: $value.expiresAt),
    status: data.get(#status, or: $value.status),
    firstMessageAt: data.get(#firstMessageAt, or: $value.firstMessageAt),
    lastNotificationAt: data.get(
      #lastNotificationAt,
      or: $value.lastNotificationAt,
    ),
  );

  @override
  MatchTimerCopyWith<$R2, MatchTimer, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MatchTimerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

