// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'boost_and_gifts.dart';

class ProfileBoostMapper extends ClassMapperBase<ProfileBoost> {
  ProfileBoostMapper._();

  static ProfileBoostMapper? _instance;
  static ProfileBoostMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileBoostMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProfileBoost';

  static String _$boostId(ProfileBoost v) => v.boostId;
  static const Field<ProfileBoost, String> _f$boostId = Field(
    'boostId',
    _$boostId,
  );
  static String _$userId(ProfileBoost v) => v.userId;
  static const Field<ProfileBoost, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static BoostType _$type(ProfileBoost v) => v.type;
  static const Field<ProfileBoost, BoostType> _f$type = Field('type', _$type);
  static BoostStatus _$status(ProfileBoost v) => v.status;
  static const Field<ProfileBoost, BoostStatus> _f$status = Field(
    'status',
    _$status,
  );
  static DateTime _$startTime(ProfileBoost v) => v.startTime;
  static const Field<ProfileBoost, DateTime> _f$startTime = Field(
    'startTime',
    _$startTime,
  );
  static DateTime _$endTime(ProfileBoost v) => v.endTime;
  static const Field<ProfileBoost, DateTime> _f$endTime = Field(
    'endTime',
    _$endTime,
  );
  static int _$impressions(ProfileBoost v) => v.impressions;
  static const Field<ProfileBoost, int> _f$impressions = Field(
    'impressions',
    _$impressions,
    opt: true,
    def: 0,
  );
  static int _$profileViews(ProfileBoost v) => v.profileViews;
  static const Field<ProfileBoost, int> _f$profileViews = Field(
    'profileViews',
    _$profileViews,
    opt: true,
    def: 0,
  );
  static int _$likesReceived(ProfileBoost v) => v.likesReceived;
  static const Field<ProfileBoost, int> _f$likesReceived = Field(
    'likesReceived',
    _$likesReceived,
    opt: true,
    def: 0,
  );
  static int _$matchesReceived(ProfileBoost v) => v.matchesReceived;
  static const Field<ProfileBoost, int> _f$matchesReceived = Field(
    'matchesReceived',
    _$matchesReceived,
    opt: true,
    def: 0,
  );
  static double _$ctr(ProfileBoost v) => v.ctr;
  static const Field<ProfileBoost, double> _f$ctr = Field(
    'ctr',
    _$ctr,
    opt: true,
    def: 0,
  );
  static DateTime _$createdAt(ProfileBoost v) => v.createdAt;
  static const Field<ProfileBoost, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static bool _$isActive(ProfileBoost v) => v.isActive;
  static const Field<ProfileBoost, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    mode: FieldMode.member,
  );
  static Duration _$duration(ProfileBoost v) => v.duration;
  static const Field<ProfileBoost, Duration> _f$duration = Field(
    'duration',
    _$duration,
    mode: FieldMode.member,
  );
  static Duration _$timeRemaining(ProfileBoost v) => v.timeRemaining;
  static const Field<ProfileBoost, Duration> _f$timeRemaining = Field(
    'timeRemaining',
    _$timeRemaining,
    mode: FieldMode.member,
  );
  static double _$conversionRate(ProfileBoost v) => v.conversionRate;
  static const Field<ProfileBoost, double> _f$conversionRate = Field(
    'conversionRate',
    _$conversionRate,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ProfileBoost> fields = const {
    #boostId: _f$boostId,
    #userId: _f$userId,
    #type: _f$type,
    #status: _f$status,
    #startTime: _f$startTime,
    #endTime: _f$endTime,
    #impressions: _f$impressions,
    #profileViews: _f$profileViews,
    #likesReceived: _f$likesReceived,
    #matchesReceived: _f$matchesReceived,
    #ctr: _f$ctr,
    #createdAt: _f$createdAt,
    #isActive: _f$isActive,
    #duration: _f$duration,
    #timeRemaining: _f$timeRemaining,
    #conversionRate: _f$conversionRate,
  };

  static ProfileBoost _instantiate(DecodingData data) {
    return ProfileBoost(
      boostId: data.dec(_f$boostId),
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      status: data.dec(_f$status),
      startTime: data.dec(_f$startTime),
      endTime: data.dec(_f$endTime),
      impressions: data.dec(_f$impressions),
      profileViews: data.dec(_f$profileViews),
      likesReceived: data.dec(_f$likesReceived),
      matchesReceived: data.dec(_f$matchesReceived),
      ctr: data.dec(_f$ctr),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProfileBoost fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProfileBoost>(map);
  }

  static ProfileBoost fromJson(String json) {
    return ensureInitialized().decodeJson<ProfileBoost>(json);
  }
}

mixin ProfileBoostMappable {
  String toJson() {
    return ProfileBoostMapper.ensureInitialized().encodeJson<ProfileBoost>(
      this as ProfileBoost,
    );
  }

  Map<String, dynamic> toMap() {
    return ProfileBoostMapper.ensureInitialized().encodeMap<ProfileBoost>(
      this as ProfileBoost,
    );
  }

  ProfileBoostCopyWith<ProfileBoost, ProfileBoost, ProfileBoost> get copyWith =>
      _ProfileBoostCopyWithImpl<ProfileBoost, ProfileBoost>(
        this as ProfileBoost,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ProfileBoostMapper.ensureInitialized().stringifyValue(
      this as ProfileBoost,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProfileBoostMapper.ensureInitialized().equalsValue(
      this as ProfileBoost,
      other,
    );
  }

  @override
  int get hashCode {
    return ProfileBoostMapper.ensureInitialized().hashValue(
      this as ProfileBoost,
    );
  }
}

extension ProfileBoostValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProfileBoost, $Out> {
  ProfileBoostCopyWith<$R, ProfileBoost, $Out> get $asProfileBoost =>
      $base.as((v, t, t2) => _ProfileBoostCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProfileBoostCopyWith<$R, $In extends ProfileBoost, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? boostId,
    String? userId,
    BoostType? type,
    BoostStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    int? impressions,
    int? profileViews,
    int? likesReceived,
    int? matchesReceived,
    double? ctr,
    DateTime? createdAt,
  });
  ProfileBoostCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProfileBoostCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProfileBoost, $Out>
    implements ProfileBoostCopyWith<$R, ProfileBoost, $Out> {
  _ProfileBoostCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProfileBoost> $mapper =
      ProfileBoostMapper.ensureInitialized();
  @override
  $R call({
    String? boostId,
    String? userId,
    BoostType? type,
    BoostStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    int? impressions,
    int? profileViews,
    int? likesReceived,
    int? matchesReceived,
    double? ctr,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (boostId != null) #boostId: boostId,
      if (userId != null) #userId: userId,
      if (type != null) #type: type,
      if (status != null) #status: status,
      if (startTime != null) #startTime: startTime,
      if (endTime != null) #endTime: endTime,
      if (impressions != null) #impressions: impressions,
      if (profileViews != null) #profileViews: profileViews,
      if (likesReceived != null) #likesReceived: likesReceived,
      if (matchesReceived != null) #matchesReceived: matchesReceived,
      if (ctr != null) #ctr: ctr,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  ProfileBoost $make(CopyWithData data) => ProfileBoost(
    boostId: data.get(#boostId, or: $value.boostId),
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    status: data.get(#status, or: $value.status),
    startTime: data.get(#startTime, or: $value.startTime),
    endTime: data.get(#endTime, or: $value.endTime),
    impressions: data.get(#impressions, or: $value.impressions),
    profileViews: data.get(#profileViews, or: $value.profileViews),
    likesReceived: data.get(#likesReceived, or: $value.likesReceived),
    matchesReceived: data.get(#matchesReceived, or: $value.matchesReceived),
    ctr: data.get(#ctr, or: $value.ctr),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  ProfileBoostCopyWith<$R2, ProfileBoost, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProfileBoostCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BoostConfigMapper extends ClassMapperBase<BoostConfig> {
  BoostConfigMapper._();

  static BoostConfigMapper? _instance;
  static BoostConfigMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BoostConfigMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BoostConfig';

  static BoostType _$type(BoostConfig v) => v.type;
  static const Field<BoostConfig, BoostType> _f$type = Field('type', _$type);
  static String _$name(BoostConfig v) => v.name;
  static const Field<BoostConfig, String> _f$name = Field('name', _$name);
  static String _$description(BoostConfig v) => v.description;
  static const Field<BoostConfig, String> _f$description = Field(
    'description',
    _$description,
  );
  static Duration _$duration(BoostConfig v) => v.duration;
  static const Field<BoostConfig, Duration> _f$duration = Field(
    'duration',
    _$duration,
  );
  static int _$multiplier(BoostConfig v) => v.multiplier;
  static const Field<BoostConfig, int> _f$multiplier = Field(
    'multiplier',
    _$multiplier,
  );
  static double _$price(BoostConfig v) => v.price;
  static const Field<BoostConfig, double> _f$price = Field('price', _$price);
  static List<String> _$benefits(BoostConfig v) => v.benefits;
  static const Field<BoostConfig, List<String>> _f$benefits = Field(
    'benefits',
    _$benefits,
  );
  static bool _$isPrimeTime(BoostConfig v) => v.isPrimeTime;
  static const Field<BoostConfig, bool> _f$isPrimeTime = Field(
    'isPrimeTime',
    _$isPrimeTime,
    opt: true,
    def: false,
  );
  static String? _$targetAudience(BoostConfig v) => v.targetAudience;
  static const Field<BoostConfig, String> _f$targetAudience = Field(
    'targetAudience',
    _$targetAudience,
    opt: true,
  );

  @override
  final MappableFields<BoostConfig> fields = const {
    #type: _f$type,
    #name: _f$name,
    #description: _f$description,
    #duration: _f$duration,
    #multiplier: _f$multiplier,
    #price: _f$price,
    #benefits: _f$benefits,
    #isPrimeTime: _f$isPrimeTime,
    #targetAudience: _f$targetAudience,
  };

  static BoostConfig _instantiate(DecodingData data) {
    return BoostConfig(
      type: data.dec(_f$type),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      duration: data.dec(_f$duration),
      multiplier: data.dec(_f$multiplier),
      price: data.dec(_f$price),
      benefits: data.dec(_f$benefits),
      isPrimeTime: data.dec(_f$isPrimeTime),
      targetAudience: data.dec(_f$targetAudience),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BoostConfig fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BoostConfig>(map);
  }

  static BoostConfig fromJson(String json) {
    return ensureInitialized().decodeJson<BoostConfig>(json);
  }
}

mixin BoostConfigMappable {
  String toJson() {
    return BoostConfigMapper.ensureInitialized().encodeJson<BoostConfig>(
      this as BoostConfig,
    );
  }

  Map<String, dynamic> toMap() {
    return BoostConfigMapper.ensureInitialized().encodeMap<BoostConfig>(
      this as BoostConfig,
    );
  }

  BoostConfigCopyWith<BoostConfig, BoostConfig, BoostConfig> get copyWith =>
      _BoostConfigCopyWithImpl<BoostConfig, BoostConfig>(
        this as BoostConfig,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BoostConfigMapper.ensureInitialized().stringifyValue(
      this as BoostConfig,
    );
  }

  @override
  bool operator ==(Object other) {
    return BoostConfigMapper.ensureInitialized().equalsValue(
      this as BoostConfig,
      other,
    );
  }

  @override
  int get hashCode {
    return BoostConfigMapper.ensureInitialized().hashValue(this as BoostConfig);
  }
}

extension BoostConfigValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BoostConfig, $Out> {
  BoostConfigCopyWith<$R, BoostConfig, $Out> get $asBoostConfig =>
      $base.as((v, t, t2) => _BoostConfigCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BoostConfigCopyWith<$R, $In extends BoostConfig, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get benefits;
  $R call({
    BoostType? type,
    String? name,
    String? description,
    Duration? duration,
    int? multiplier,
    double? price,
    List<String>? benefits,
    bool? isPrimeTime,
    String? targetAudience,
  });
  BoostConfigCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BoostConfigCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BoostConfig, $Out>
    implements BoostConfigCopyWith<$R, BoostConfig, $Out> {
  _BoostConfigCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BoostConfig> $mapper =
      BoostConfigMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get benefits =>
      ListCopyWith(
        $value.benefits,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(benefits: v),
      );
  @override
  $R call({
    BoostType? type,
    String? name,
    String? description,
    Duration? duration,
    int? multiplier,
    double? price,
    List<String>? benefits,
    bool? isPrimeTime,
    Object? targetAudience = $none,
  }) => $apply(
    FieldCopyWithData({
      if (type != null) #type: type,
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (duration != null) #duration: duration,
      if (multiplier != null) #multiplier: multiplier,
      if (price != null) #price: price,
      if (benefits != null) #benefits: benefits,
      if (isPrimeTime != null) #isPrimeTime: isPrimeTime,
      if (targetAudience != $none) #targetAudience: targetAudience,
    }),
  );
  @override
  BoostConfig $make(CopyWithData data) => BoostConfig(
    type: data.get(#type, or: $value.type),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    duration: data.get(#duration, or: $value.duration),
    multiplier: data.get(#multiplier, or: $value.multiplier),
    price: data.get(#price, or: $value.price),
    benefits: data.get(#benefits, or: $value.benefits),
    isPrimeTime: data.get(#isPrimeTime, or: $value.isPrimeTime),
    targetAudience: data.get(#targetAudience, or: $value.targetAudience),
  );

  @override
  BoostConfigCopyWith<$R2, BoostConfig, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BoostConfigCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BoostStatsMapper extends ClassMapperBase<BoostStats> {
  BoostStatsMapper._();

  static BoostStatsMapper? _instance;
  static BoostStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BoostStatsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BoostStats';

  static String _$userId(BoostStats v) => v.userId;
  static const Field<BoostStats, String> _f$userId = Field('userId', _$userId);
  static int _$totalBoostsUsed(BoostStats v) => v.totalBoostsUsed;
  static const Field<BoostStats, int> _f$totalBoostsUsed = Field(
    'totalBoostsUsed',
    _$totalBoostsUsed,
  );
  static Duration _$totalBoostTime(BoostStats v) => v.totalBoostTime;
  static const Field<BoostStats, Duration> _f$totalBoostTime = Field(
    'totalBoostTime',
    _$totalBoostTime,
  );
  static int _$totalImpressions(BoostStats v) => v.totalImpressions;
  static const Field<BoostStats, int> _f$totalImpressions = Field(
    'totalImpressions',
    _$totalImpressions,
  );
  static int _$totalProfileViews(BoostStats v) => v.totalProfileViews;
  static const Field<BoostStats, int> _f$totalProfileViews = Field(
    'totalProfileViews',
    _$totalProfileViews,
  );
  static int _$totalLikesReceived(BoostStats v) => v.totalLikesReceived;
  static const Field<BoostStats, int> _f$totalLikesReceived = Field(
    'totalLikesReceived',
    _$totalLikesReceived,
  );
  static int _$totalMatchesReceived(BoostStats v) => v.totalMatchesReceived;
  static const Field<BoostStats, int> _f$totalMatchesReceived = Field(
    'totalMatchesReceived',
    _$totalMatchesReceived,
  );
  static double _$averageCTR(BoostStats v) => v.averageCTR;
  static const Field<BoostStats, double> _f$averageCTR = Field(
    'averageCTR',
    _$averageCTR,
  );
  static double _$averageConversionRate(BoostStats v) =>
      v.averageConversionRate;
  static const Field<BoostStats, double> _f$averageConversionRate = Field(
    'averageConversionRate',
    _$averageConversionRate,
  );
  static DateTime? _$lastBoostDate(BoostStats v) => v.lastBoostDate;
  static const Field<BoostStats, DateTime> _f$lastBoostDate = Field(
    'lastBoostDate',
    _$lastBoostDate,
    opt: true,
  );
  static BoostType? _$mostEffectiveBoost(BoostStats v) => v.mostEffectiveBoost;
  static const Field<BoostStats, BoostType> _f$mostEffectiveBoost = Field(
    'mostEffectiveBoost',
    _$mostEffectiveBoost,
    opt: true,
  );
  static double _$averageMatchesPerBoost(BoostStats v) =>
      v.averageMatchesPerBoost;
  static const Field<BoostStats, double> _f$averageMatchesPerBoost = Field(
    'averageMatchesPerBoost',
    _$averageMatchesPerBoost,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<BoostStats> fields = const {
    #userId: _f$userId,
    #totalBoostsUsed: _f$totalBoostsUsed,
    #totalBoostTime: _f$totalBoostTime,
    #totalImpressions: _f$totalImpressions,
    #totalProfileViews: _f$totalProfileViews,
    #totalLikesReceived: _f$totalLikesReceived,
    #totalMatchesReceived: _f$totalMatchesReceived,
    #averageCTR: _f$averageCTR,
    #averageConversionRate: _f$averageConversionRate,
    #lastBoostDate: _f$lastBoostDate,
    #mostEffectiveBoost: _f$mostEffectiveBoost,
    #averageMatchesPerBoost: _f$averageMatchesPerBoost,
  };

  static BoostStats _instantiate(DecodingData data) {
    return BoostStats(
      userId: data.dec(_f$userId),
      totalBoostsUsed: data.dec(_f$totalBoostsUsed),
      totalBoostTime: data.dec(_f$totalBoostTime),
      totalImpressions: data.dec(_f$totalImpressions),
      totalProfileViews: data.dec(_f$totalProfileViews),
      totalLikesReceived: data.dec(_f$totalLikesReceived),
      totalMatchesReceived: data.dec(_f$totalMatchesReceived),
      averageCTR: data.dec(_f$averageCTR),
      averageConversionRate: data.dec(_f$averageConversionRate),
      lastBoostDate: data.dec(_f$lastBoostDate),
      mostEffectiveBoost: data.dec(_f$mostEffectiveBoost),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BoostStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BoostStats>(map);
  }

  static BoostStats fromJson(String json) {
    return ensureInitialized().decodeJson<BoostStats>(json);
  }
}

mixin BoostStatsMappable {
  String toJson() {
    return BoostStatsMapper.ensureInitialized().encodeJson<BoostStats>(
      this as BoostStats,
    );
  }

  Map<String, dynamic> toMap() {
    return BoostStatsMapper.ensureInitialized().encodeMap<BoostStats>(
      this as BoostStats,
    );
  }

  BoostStatsCopyWith<BoostStats, BoostStats, BoostStats> get copyWith =>
      _BoostStatsCopyWithImpl<BoostStats, BoostStats>(
        this as BoostStats,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BoostStatsMapper.ensureInitialized().stringifyValue(
      this as BoostStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return BoostStatsMapper.ensureInitialized().equalsValue(
      this as BoostStats,
      other,
    );
  }

  @override
  int get hashCode {
    return BoostStatsMapper.ensureInitialized().hashValue(this as BoostStats);
  }
}

extension BoostStatsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BoostStats, $Out> {
  BoostStatsCopyWith<$R, BoostStats, $Out> get $asBoostStats =>
      $base.as((v, t, t2) => _BoostStatsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BoostStatsCopyWith<$R, $In extends BoostStats, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    int? totalBoostsUsed,
    Duration? totalBoostTime,
    int? totalImpressions,
    int? totalProfileViews,
    int? totalLikesReceived,
    int? totalMatchesReceived,
    double? averageCTR,
    double? averageConversionRate,
    DateTime? lastBoostDate,
    BoostType? mostEffectiveBoost,
  });
  BoostStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BoostStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BoostStats, $Out>
    implements BoostStatsCopyWith<$R, BoostStats, $Out> {
  _BoostStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BoostStats> $mapper =
      BoostStatsMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    int? totalBoostsUsed,
    Duration? totalBoostTime,
    int? totalImpressions,
    int? totalProfileViews,
    int? totalLikesReceived,
    int? totalMatchesReceived,
    double? averageCTR,
    double? averageConversionRate,
    Object? lastBoostDate = $none,
    Object? mostEffectiveBoost = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (totalBoostsUsed != null) #totalBoostsUsed: totalBoostsUsed,
      if (totalBoostTime != null) #totalBoostTime: totalBoostTime,
      if (totalImpressions != null) #totalImpressions: totalImpressions,
      if (totalProfileViews != null) #totalProfileViews: totalProfileViews,
      if (totalLikesReceived != null) #totalLikesReceived: totalLikesReceived,
      if (totalMatchesReceived != null)
        #totalMatchesReceived: totalMatchesReceived,
      if (averageCTR != null) #averageCTR: averageCTR,
      if (averageConversionRate != null)
        #averageConversionRate: averageConversionRate,
      if (lastBoostDate != $none) #lastBoostDate: lastBoostDate,
      if (mostEffectiveBoost != $none) #mostEffectiveBoost: mostEffectiveBoost,
    }),
  );
  @override
  BoostStats $make(CopyWithData data) => BoostStats(
    userId: data.get(#userId, or: $value.userId),
    totalBoostsUsed: data.get(#totalBoostsUsed, or: $value.totalBoostsUsed),
    totalBoostTime: data.get(#totalBoostTime, or: $value.totalBoostTime),
    totalImpressions: data.get(#totalImpressions, or: $value.totalImpressions),
    totalProfileViews: data.get(
      #totalProfileViews,
      or: $value.totalProfileViews,
    ),
    totalLikesReceived: data.get(
      #totalLikesReceived,
      or: $value.totalLikesReceived,
    ),
    totalMatchesReceived: data.get(
      #totalMatchesReceived,
      or: $value.totalMatchesReceived,
    ),
    averageCTR: data.get(#averageCTR, or: $value.averageCTR),
    averageConversionRate: data.get(
      #averageConversionRate,
      or: $value.averageConversionRate,
    ),
    lastBoostDate: data.get(#lastBoostDate, or: $value.lastBoostDate),
    mostEffectiveBoost: data.get(
      #mostEffectiveBoost,
      or: $value.mostEffectiveBoost,
    ),
  );

  @override
  BoostStatsCopyWith<$R2, BoostStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BoostStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VirtualGiftMapper extends ClassMapperBase<VirtualGift> {
  VirtualGiftMapper._();

  static VirtualGiftMapper? _instance;
  static VirtualGiftMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VirtualGiftMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VirtualGift';

  static String _$giftId(VirtualGift v) => v.giftId;
  static const Field<VirtualGift, String> _f$giftId = Field('giftId', _$giftId);
  static String _$name(VirtualGift v) => v.name;
  static const Field<VirtualGift, String> _f$name = Field('name', _$name);
  static String _$description(VirtualGift v) => v.description;
  static const Field<VirtualGift, String> _f$description = Field(
    'description',
    _$description,
  );
  static GiftCategory _$category(VirtualGift v) => v.category;
  static const Field<VirtualGift, GiftCategory> _f$category = Field(
    'category',
    _$category,
  );
  static int _$coinPrice(VirtualGift v) => v.coinPrice;
  static const Field<VirtualGift, int> _f$coinPrice = Field(
    'coinPrice',
    _$coinPrice,
  );
  static String? _$imageUrl(VirtualGift v) => v.imageUrl;
  static const Field<VirtualGift, String> _f$imageUrl = Field(
    'imageUrl',
    _$imageUrl,
    opt: true,
  );
  static String? _$animationUrl(VirtualGift v) => v.animationUrl;
  static const Field<VirtualGift, String> _f$animationUrl = Field(
    'animationUrl',
    _$animationUrl,
    opt: true,
  );
  static GiftRarity _$rarity(VirtualGift v) => v.rarity;
  static const Field<VirtualGift, GiftRarity> _f$rarity = Field(
    'rarity',
    _$rarity,
    opt: true,
    def: GiftRarity.common,
  );
  static bool _$isAvailable(VirtualGift v) => v.isAvailable;
  static const Field<VirtualGift, bool> _f$isAvailable = Field(
    'isAvailable',
    _$isAvailable,
    opt: true,
    def: true,
  );
  static DateTime _$createdAt(VirtualGift v) => v.createdAt;
  static const Field<VirtualGift, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<VirtualGift> fields = const {
    #giftId: _f$giftId,
    #name: _f$name,
    #description: _f$description,
    #category: _f$category,
    #coinPrice: _f$coinPrice,
    #imageUrl: _f$imageUrl,
    #animationUrl: _f$animationUrl,
    #rarity: _f$rarity,
    #isAvailable: _f$isAvailable,
    #createdAt: _f$createdAt,
  };

  static VirtualGift _instantiate(DecodingData data) {
    return VirtualGift(
      giftId: data.dec(_f$giftId),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      category: data.dec(_f$category),
      coinPrice: data.dec(_f$coinPrice),
      imageUrl: data.dec(_f$imageUrl),
      animationUrl: data.dec(_f$animationUrl),
      rarity: data.dec(_f$rarity),
      isAvailable: data.dec(_f$isAvailable),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VirtualGift fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VirtualGift>(map);
  }

  static VirtualGift fromJson(String json) {
    return ensureInitialized().decodeJson<VirtualGift>(json);
  }
}

mixin VirtualGiftMappable {
  String toJson() {
    return VirtualGiftMapper.ensureInitialized().encodeJson<VirtualGift>(
      this as VirtualGift,
    );
  }

  Map<String, dynamic> toMap() {
    return VirtualGiftMapper.ensureInitialized().encodeMap<VirtualGift>(
      this as VirtualGift,
    );
  }

  VirtualGiftCopyWith<VirtualGift, VirtualGift, VirtualGift> get copyWith =>
      _VirtualGiftCopyWithImpl<VirtualGift, VirtualGift>(
        this as VirtualGift,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VirtualGiftMapper.ensureInitialized().stringifyValue(
      this as VirtualGift,
    );
  }

  @override
  bool operator ==(Object other) {
    return VirtualGiftMapper.ensureInitialized().equalsValue(
      this as VirtualGift,
      other,
    );
  }

  @override
  int get hashCode {
    return VirtualGiftMapper.ensureInitialized().hashValue(this as VirtualGift);
  }
}

extension VirtualGiftValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VirtualGift, $Out> {
  VirtualGiftCopyWith<$R, VirtualGift, $Out> get $asVirtualGift =>
      $base.as((v, t, t2) => _VirtualGiftCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VirtualGiftCopyWith<$R, $In extends VirtualGift, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? giftId,
    String? name,
    String? description,
    GiftCategory? category,
    int? coinPrice,
    String? imageUrl,
    String? animationUrl,
    GiftRarity? rarity,
    bool? isAvailable,
    DateTime? createdAt,
  });
  VirtualGiftCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VirtualGiftCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VirtualGift, $Out>
    implements VirtualGiftCopyWith<$R, VirtualGift, $Out> {
  _VirtualGiftCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VirtualGift> $mapper =
      VirtualGiftMapper.ensureInitialized();
  @override
  $R call({
    String? giftId,
    String? name,
    String? description,
    GiftCategory? category,
    int? coinPrice,
    Object? imageUrl = $none,
    Object? animationUrl = $none,
    GiftRarity? rarity,
    bool? isAvailable,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (giftId != null) #giftId: giftId,
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (category != null) #category: category,
      if (coinPrice != null) #coinPrice: coinPrice,
      if (imageUrl != $none) #imageUrl: imageUrl,
      if (animationUrl != $none) #animationUrl: animationUrl,
      if (rarity != null) #rarity: rarity,
      if (isAvailable != null) #isAvailable: isAvailable,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  VirtualGift $make(CopyWithData data) => VirtualGift(
    giftId: data.get(#giftId, or: $value.giftId),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    category: data.get(#category, or: $value.category),
    coinPrice: data.get(#coinPrice, or: $value.coinPrice),
    imageUrl: data.get(#imageUrl, or: $value.imageUrl),
    animationUrl: data.get(#animationUrl, or: $value.animationUrl),
    rarity: data.get(#rarity, or: $value.rarity),
    isAvailable: data.get(#isAvailable, or: $value.isAvailable),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  VirtualGiftCopyWith<$R2, VirtualGift, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VirtualGiftCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class GiftTransactionMapper extends ClassMapperBase<GiftTransaction> {
  GiftTransactionMapper._();

  static GiftTransactionMapper? _instance;
  static GiftTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GiftTransactionMapper._());
      VirtualGiftMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'GiftTransaction';

  static String _$transactionId(GiftTransaction v) => v.transactionId;
  static const Field<GiftTransaction, String> _f$transactionId = Field(
    'transactionId',
    _$transactionId,
  );
  static String _$senderId(GiftTransaction v) => v.senderId;
  static const Field<GiftTransaction, String> _f$senderId = Field(
    'senderId',
    _$senderId,
  );
  static String _$recipientId(GiftTransaction v) => v.recipientId;
  static const Field<GiftTransaction, String> _f$recipientId = Field(
    'recipientId',
    _$recipientId,
  );
  static VirtualGift _$gift(GiftTransaction v) => v.gift;
  static const Field<GiftTransaction, VirtualGift> _f$gift = Field(
    'gift',
    _$gift,
  );
  static String? _$message(GiftTransaction v) => v.message;
  static const Field<GiftTransaction, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
  );
  static bool _$isAnonymous(GiftTransaction v) => v.isAnonymous;
  static const Field<GiftTransaction, bool> _f$isAnonymous = Field(
    'isAnonymous',
    _$isAnonymous,
    opt: true,
    def: false,
  );
  static DateTime _$sentAt(GiftTransaction v) => v.sentAt;
  static const Field<GiftTransaction, DateTime> _f$sentAt = Field(
    'sentAt',
    _$sentAt,
  );
  static DateTime? _$viewedAt(GiftTransaction v) => v.viewedAt;
  static const Field<GiftTransaction, DateTime> _f$viewedAt = Field(
    'viewedAt',
    _$viewedAt,
    opt: true,
  );
  static bool _$wasViewed(GiftTransaction v) => v.wasViewed;
  static const Field<GiftTransaction, bool> _f$wasViewed = Field(
    'wasViewed',
    _$wasViewed,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<GiftTransaction> fields = const {
    #transactionId: _f$transactionId,
    #senderId: _f$senderId,
    #recipientId: _f$recipientId,
    #gift: _f$gift,
    #message: _f$message,
    #isAnonymous: _f$isAnonymous,
    #sentAt: _f$sentAt,
    #viewedAt: _f$viewedAt,
    #wasViewed: _f$wasViewed,
  };

  static GiftTransaction _instantiate(DecodingData data) {
    return GiftTransaction(
      transactionId: data.dec(_f$transactionId),
      senderId: data.dec(_f$senderId),
      recipientId: data.dec(_f$recipientId),
      gift: data.dec(_f$gift),
      message: data.dec(_f$message),
      isAnonymous: data.dec(_f$isAnonymous),
      sentAt: data.dec(_f$sentAt),
      viewedAt: data.dec(_f$viewedAt),
      wasViewed: data.dec(_f$wasViewed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GiftTransaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GiftTransaction>(map);
  }

  static GiftTransaction fromJson(String json) {
    return ensureInitialized().decodeJson<GiftTransaction>(json);
  }
}

mixin GiftTransactionMappable {
  String toJson() {
    return GiftTransactionMapper.ensureInitialized()
        .encodeJson<GiftTransaction>(this as GiftTransaction);
  }

  Map<String, dynamic> toMap() {
    return GiftTransactionMapper.ensureInitialized().encodeMap<GiftTransaction>(
      this as GiftTransaction,
    );
  }

  GiftTransactionCopyWith<GiftTransaction, GiftTransaction, GiftTransaction>
  get copyWith =>
      _GiftTransactionCopyWithImpl<GiftTransaction, GiftTransaction>(
        this as GiftTransaction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return GiftTransactionMapper.ensureInitialized().stringifyValue(
      this as GiftTransaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return GiftTransactionMapper.ensureInitialized().equalsValue(
      this as GiftTransaction,
      other,
    );
  }

  @override
  int get hashCode {
    return GiftTransactionMapper.ensureInitialized().hashValue(
      this as GiftTransaction,
    );
  }
}

extension GiftTransactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GiftTransaction, $Out> {
  GiftTransactionCopyWith<$R, GiftTransaction, $Out> get $asGiftTransaction =>
      $base.as((v, t, t2) => _GiftTransactionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GiftTransactionCopyWith<$R, $In extends GiftTransaction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  VirtualGiftCopyWith<$R, VirtualGift, VirtualGift> get gift;
  $R call({
    String? transactionId,
    String? senderId,
    String? recipientId,
    VirtualGift? gift,
    String? message,
    bool? isAnonymous,
    DateTime? sentAt,
    DateTime? viewedAt,
    bool? wasViewed,
  });
  GiftTransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _GiftTransactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GiftTransaction, $Out>
    implements GiftTransactionCopyWith<$R, GiftTransaction, $Out> {
  _GiftTransactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GiftTransaction> $mapper =
      GiftTransactionMapper.ensureInitialized();
  @override
  VirtualGiftCopyWith<$R, VirtualGift, VirtualGift> get gift =>
      $value.gift.copyWith.$chain((v) => call(gift: v));
  @override
  $R call({
    String? transactionId,
    String? senderId,
    String? recipientId,
    VirtualGift? gift,
    Object? message = $none,
    bool? isAnonymous,
    DateTime? sentAt,
    Object? viewedAt = $none,
    bool? wasViewed,
  }) => $apply(
    FieldCopyWithData({
      if (transactionId != null) #transactionId: transactionId,
      if (senderId != null) #senderId: senderId,
      if (recipientId != null) #recipientId: recipientId,
      if (gift != null) #gift: gift,
      if (message != $none) #message: message,
      if (isAnonymous != null) #isAnonymous: isAnonymous,
      if (sentAt != null) #sentAt: sentAt,
      if (viewedAt != $none) #viewedAt: viewedAt,
      if (wasViewed != null) #wasViewed: wasViewed,
    }),
  );
  @override
  GiftTransaction $make(CopyWithData data) => GiftTransaction(
    transactionId: data.get(#transactionId, or: $value.transactionId),
    senderId: data.get(#senderId, or: $value.senderId),
    recipientId: data.get(#recipientId, or: $value.recipientId),
    gift: data.get(#gift, or: $value.gift),
    message: data.get(#message, or: $value.message),
    isAnonymous: data.get(#isAnonymous, or: $value.isAnonymous),
    sentAt: data.get(#sentAt, or: $value.sentAt),
    viewedAt: data.get(#viewedAt, or: $value.viewedAt),
    wasViewed: data.get(#wasViewed, or: $value.wasViewed),
  );

  @override
  GiftTransactionCopyWith<$R2, GiftTransaction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _GiftTransactionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class GiftStatsMapper extends ClassMapperBase<GiftStats> {
  GiftStatsMapper._();

  static GiftStatsMapper? _instance;
  static GiftStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GiftStatsMapper._());
      VirtualGiftMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'GiftStats';

  static String _$userId(GiftStats v) => v.userId;
  static const Field<GiftStats, String> _f$userId = Field('userId', _$userId);
  static int _$giftsSent(GiftStats v) => v.giftsSent;
  static const Field<GiftStats, int> _f$giftsSent = Field(
    'giftsSent',
    _$giftsSent,
  );
  static int _$giftsReceived(GiftStats v) => v.giftsReceived;
  static const Field<GiftStats, int> _f$giftsReceived = Field(
    'giftsReceived',
    _$giftsReceived,
  );
  static int _$coinsSpent(GiftStats v) => v.coinsSpent;
  static const Field<GiftStats, int> _f$coinsSpent = Field(
    'coinsSpent',
    _$coinsSpent,
  );
  static Map<GiftCategory, int> _$sentByCategory(GiftStats v) =>
      v.sentByCategory;
  static const Field<GiftStats, Map<GiftCategory, int>> _f$sentByCategory =
      Field('sentByCategory', _$sentByCategory);
  static Map<GiftCategory, int> _$receivedByCategory(GiftStats v) =>
      v.receivedByCategory;
  static const Field<GiftStats, Map<GiftCategory, int>> _f$receivedByCategory =
      Field('receivedByCategory', _$receivedByCategory);
  static List<VirtualGift> _$mostSentGifts(GiftStats v) => v.mostSentGifts;
  static const Field<GiftStats, List<VirtualGift>> _f$mostSentGifts = Field(
    'mostSentGifts',
    _$mostSentGifts,
  );
  static List<VirtualGift> _$mostReceivedGifts(GiftStats v) =>
      v.mostReceivedGifts;
  static const Field<GiftStats, List<VirtualGift>> _f$mostReceivedGifts = Field(
    'mostReceivedGifts',
    _$mostReceivedGifts,
  );

  @override
  final MappableFields<GiftStats> fields = const {
    #userId: _f$userId,
    #giftsSent: _f$giftsSent,
    #giftsReceived: _f$giftsReceived,
    #coinsSpent: _f$coinsSpent,
    #sentByCategory: _f$sentByCategory,
    #receivedByCategory: _f$receivedByCategory,
    #mostSentGifts: _f$mostSentGifts,
    #mostReceivedGifts: _f$mostReceivedGifts,
  };

  static GiftStats _instantiate(DecodingData data) {
    return GiftStats(
      userId: data.dec(_f$userId),
      giftsSent: data.dec(_f$giftsSent),
      giftsReceived: data.dec(_f$giftsReceived),
      coinsSpent: data.dec(_f$coinsSpent),
      sentByCategory: data.dec(_f$sentByCategory),
      receivedByCategory: data.dec(_f$receivedByCategory),
      mostSentGifts: data.dec(_f$mostSentGifts),
      mostReceivedGifts: data.dec(_f$mostReceivedGifts),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GiftStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GiftStats>(map);
  }

  static GiftStats fromJson(String json) {
    return ensureInitialized().decodeJson<GiftStats>(json);
  }
}

mixin GiftStatsMappable {
  String toJson() {
    return GiftStatsMapper.ensureInitialized().encodeJson<GiftStats>(
      this as GiftStats,
    );
  }

  Map<String, dynamic> toMap() {
    return GiftStatsMapper.ensureInitialized().encodeMap<GiftStats>(
      this as GiftStats,
    );
  }

  GiftStatsCopyWith<GiftStats, GiftStats, GiftStats> get copyWith =>
      _GiftStatsCopyWithImpl<GiftStats, GiftStats>(
        this as GiftStats,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return GiftStatsMapper.ensureInitialized().stringifyValue(
      this as GiftStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return GiftStatsMapper.ensureInitialized().equalsValue(
      this as GiftStats,
      other,
    );
  }

  @override
  int get hashCode {
    return GiftStatsMapper.ensureInitialized().hashValue(this as GiftStats);
  }
}

extension GiftStatsValueCopy<$R, $Out> on ObjectCopyWith<$R, GiftStats, $Out> {
  GiftStatsCopyWith<$R, GiftStats, $Out> get $asGiftStats =>
      $base.as((v, t, t2) => _GiftStatsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GiftStatsCopyWith<$R, $In extends GiftStats, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, GiftCategory, int, ObjectCopyWith<$R, int, int>>
  get sentByCategory;
  MapCopyWith<$R, GiftCategory, int, ObjectCopyWith<$R, int, int>>
  get receivedByCategory;
  ListCopyWith<
    $R,
    VirtualGift,
    VirtualGiftCopyWith<$R, VirtualGift, VirtualGift>
  >
  get mostSentGifts;
  ListCopyWith<
    $R,
    VirtualGift,
    VirtualGiftCopyWith<$R, VirtualGift, VirtualGift>
  >
  get mostReceivedGifts;
  $R call({
    String? userId,
    int? giftsSent,
    int? giftsReceived,
    int? coinsSpent,
    Map<GiftCategory, int>? sentByCategory,
    Map<GiftCategory, int>? receivedByCategory,
    List<VirtualGift>? mostSentGifts,
    List<VirtualGift>? mostReceivedGifts,
  });
  GiftStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GiftStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GiftStats, $Out>
    implements GiftStatsCopyWith<$R, GiftStats, $Out> {
  _GiftStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GiftStats> $mapper =
      GiftStatsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, GiftCategory, int, ObjectCopyWith<$R, int, int>>
  get sentByCategory => MapCopyWith(
    $value.sentByCategory,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(sentByCategory: v),
  );
  @override
  MapCopyWith<$R, GiftCategory, int, ObjectCopyWith<$R, int, int>>
  get receivedByCategory => MapCopyWith(
    $value.receivedByCategory,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(receivedByCategory: v),
  );
  @override
  ListCopyWith<
    $R,
    VirtualGift,
    VirtualGiftCopyWith<$R, VirtualGift, VirtualGift>
  >
  get mostSentGifts => ListCopyWith(
    $value.mostSentGifts,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mostSentGifts: v),
  );
  @override
  ListCopyWith<
    $R,
    VirtualGift,
    VirtualGiftCopyWith<$R, VirtualGift, VirtualGift>
  >
  get mostReceivedGifts => ListCopyWith(
    $value.mostReceivedGifts,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mostReceivedGifts: v),
  );
  @override
  $R call({
    String? userId,
    int? giftsSent,
    int? giftsReceived,
    int? coinsSpent,
    Map<GiftCategory, int>? sentByCategory,
    Map<GiftCategory, int>? receivedByCategory,
    List<VirtualGift>? mostSentGifts,
    List<VirtualGift>? mostReceivedGifts,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (giftsSent != null) #giftsSent: giftsSent,
      if (giftsReceived != null) #giftsReceived: giftsReceived,
      if (coinsSpent != null) #coinsSpent: coinsSpent,
      if (sentByCategory != null) #sentByCategory: sentByCategory,
      if (receivedByCategory != null) #receivedByCategory: receivedByCategory,
      if (mostSentGifts != null) #mostSentGifts: mostSentGifts,
      if (mostReceivedGifts != null) #mostReceivedGifts: mostReceivedGifts,
    }),
  );
  @override
  GiftStats $make(CopyWithData data) => GiftStats(
    userId: data.get(#userId, or: $value.userId),
    giftsSent: data.get(#giftsSent, or: $value.giftsSent),
    giftsReceived: data.get(#giftsReceived, or: $value.giftsReceived),
    coinsSpent: data.get(#coinsSpent, or: $value.coinsSpent),
    sentByCategory: data.get(#sentByCategory, or: $value.sentByCategory),
    receivedByCategory: data.get(
      #receivedByCategory,
      or: $value.receivedByCategory,
    ),
    mostSentGifts: data.get(#mostSentGifts, or: $value.mostSentGifts),
    mostReceivedGifts: data.get(
      #mostReceivedGifts,
      or: $value.mostReceivedGifts,
    ),
  );

  @override
  GiftStatsCopyWith<$R2, GiftStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _GiftStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ProfileAnalyticsMapper extends ClassMapperBase<ProfileAnalytics> {
  ProfileAnalyticsMapper._();

  static ProfileAnalyticsMapper? _instance;
  static ProfileAnalyticsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileAnalyticsMapper._());
      ViewerDemographicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ProfileAnalytics';

  static String _$userId(ProfileAnalytics v) => v.userId;
  static const Field<ProfileAnalytics, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static DateTime _$periodStart(ProfileAnalytics v) => v.periodStart;
  static const Field<ProfileAnalytics, DateTime> _f$periodStart = Field(
    'periodStart',
    _$periodStart,
  );
  static DateTime _$periodEnd(ProfileAnalytics v) => v.periodEnd;
  static const Field<ProfileAnalytics, DateTime> _f$periodEnd = Field(
    'periodEnd',
    _$periodEnd,
  );
  static int _$profileViews(ProfileAnalytics v) => v.profileViews;
  static const Field<ProfileAnalytics, int> _f$profileViews = Field(
    'profileViews',
    _$profileViews,
  );
  static int _$profileViewsGrowth(ProfileAnalytics v) => v.profileViewsGrowth;
  static const Field<ProfileAnalytics, int> _f$profileViewsGrowth = Field(
    'profileViewsGrowth',
    _$profileViewsGrowth,
    opt: true,
    def: 0,
  );
  static List<ViewerDemographic> _$viewerDemographics(ProfileAnalytics v) =>
      v.viewerDemographics;
  static const Field<ProfileAnalytics, List<ViewerDemographic>>
  _f$viewerDemographics = Field('viewerDemographics', _$viewerDemographics);
  static int _$likesReceived(ProfileAnalytics v) => v.likesReceived;
  static const Field<ProfileAnalytics, int> _f$likesReceived = Field(
    'likesReceived',
    _$likesReceived,
  );
  static int _$likesSent(ProfileAnalytics v) => v.likesSent;
  static const Field<ProfileAnalytics, int> _f$likesSent = Field(
    'likesSent',
    _$likesSent,
  );
  static int _$superLikesReceived(ProfileAnalytics v) => v.superLikesReceived;
  static const Field<ProfileAnalytics, int> _f$superLikesReceived = Field(
    'superLikesReceived',
    _$superLikesReceived,
  );
  static int _$matchesCreated(ProfileAnalytics v) => v.matchesCreated;
  static const Field<ProfileAnalytics, int> _f$matchesCreated = Field(
    'matchesCreated',
    _$matchesCreated,
  );
  static double _$matchRate(ProfileAnalytics v) => v.matchRate;
  static const Field<ProfileAnalytics, double> _f$matchRate = Field(
    'matchRate',
    _$matchRate,
  );
  static int _$messagesReceived(ProfileAnalytics v) => v.messagesReceived;
  static const Field<ProfileAnalytics, int> _f$messagesReceived = Field(
    'messagesReceived',
    _$messagesReceived,
  );
  static int _$messagesSent(ProfileAnalytics v) => v.messagesSent;
  static const Field<ProfileAnalytics, int> _f$messagesSent = Field(
    'messagesSent',
    _$messagesSent,
  );
  static double _$responseRate(ProfileAnalytics v) => v.responseRate;
  static const Field<ProfileAnalytics, double> _f$responseRate = Field(
    'responseRate',
    _$responseRate,
  );
  static Duration _$averageResponseTime(ProfileAnalytics v) =>
      v.averageResponseTime;
  static const Field<ProfileAnalytics, Duration> _f$averageResponseTime = Field(
    'averageResponseTime',
    _$averageResponseTime,
  );
  static int _$popularityScore(ProfileAnalytics v) => v.popularityScore;
  static const Field<ProfileAnalytics, int> _f$popularityScore = Field(
    'popularityScore',
    _$popularityScore,
  );
  static ProfileRanking _$ranking(ProfileAnalytics v) => v.ranking;
  static const Field<ProfileAnalytics, ProfileRanking> _f$ranking = Field(
    'ranking',
    _$ranking,
  );
  static int _$percentileTier(ProfileAnalytics v) => v.percentileTier;
  static const Field<ProfileAnalytics, int> _f$percentileTier = Field(
    'percentileTier',
    _$percentileTier,
  );
  static DateTime _$generatedAt(ProfileAnalytics v) => v.generatedAt;
  static const Field<ProfileAnalytics, DateTime> _f$generatedAt = Field(
    'generatedAt',
    _$generatedAt,
  );

  @override
  final MappableFields<ProfileAnalytics> fields = const {
    #userId: _f$userId,
    #periodStart: _f$periodStart,
    #periodEnd: _f$periodEnd,
    #profileViews: _f$profileViews,
    #profileViewsGrowth: _f$profileViewsGrowth,
    #viewerDemographics: _f$viewerDemographics,
    #likesReceived: _f$likesReceived,
    #likesSent: _f$likesSent,
    #superLikesReceived: _f$superLikesReceived,
    #matchesCreated: _f$matchesCreated,
    #matchRate: _f$matchRate,
    #messagesReceived: _f$messagesReceived,
    #messagesSent: _f$messagesSent,
    #responseRate: _f$responseRate,
    #averageResponseTime: _f$averageResponseTime,
    #popularityScore: _f$popularityScore,
    #ranking: _f$ranking,
    #percentileTier: _f$percentileTier,
    #generatedAt: _f$generatedAt,
  };

  static ProfileAnalytics _instantiate(DecodingData data) {
    return ProfileAnalytics(
      userId: data.dec(_f$userId),
      periodStart: data.dec(_f$periodStart),
      periodEnd: data.dec(_f$periodEnd),
      profileViews: data.dec(_f$profileViews),
      profileViewsGrowth: data.dec(_f$profileViewsGrowth),
      viewerDemographics: data.dec(_f$viewerDemographics),
      likesReceived: data.dec(_f$likesReceived),
      likesSent: data.dec(_f$likesSent),
      superLikesReceived: data.dec(_f$superLikesReceived),
      matchesCreated: data.dec(_f$matchesCreated),
      matchRate: data.dec(_f$matchRate),
      messagesReceived: data.dec(_f$messagesReceived),
      messagesSent: data.dec(_f$messagesSent),
      responseRate: data.dec(_f$responseRate),
      averageResponseTime: data.dec(_f$averageResponseTime),
      popularityScore: data.dec(_f$popularityScore),
      ranking: data.dec(_f$ranking),
      percentileTier: data.dec(_f$percentileTier),
      generatedAt: data.dec(_f$generatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProfileAnalytics fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProfileAnalytics>(map);
  }

  static ProfileAnalytics fromJson(String json) {
    return ensureInitialized().decodeJson<ProfileAnalytics>(json);
  }
}

mixin ProfileAnalyticsMappable {
  String toJson() {
    return ProfileAnalyticsMapper.ensureInitialized()
        .encodeJson<ProfileAnalytics>(this as ProfileAnalytics);
  }

  Map<String, dynamic> toMap() {
    return ProfileAnalyticsMapper.ensureInitialized()
        .encodeMap<ProfileAnalytics>(this as ProfileAnalytics);
  }

  ProfileAnalyticsCopyWith<ProfileAnalytics, ProfileAnalytics, ProfileAnalytics>
  get copyWith =>
      _ProfileAnalyticsCopyWithImpl<ProfileAnalytics, ProfileAnalytics>(
        this as ProfileAnalytics,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ProfileAnalyticsMapper.ensureInitialized().stringifyValue(
      this as ProfileAnalytics,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProfileAnalyticsMapper.ensureInitialized().equalsValue(
      this as ProfileAnalytics,
      other,
    );
  }

  @override
  int get hashCode {
    return ProfileAnalyticsMapper.ensureInitialized().hashValue(
      this as ProfileAnalytics,
    );
  }
}

extension ProfileAnalyticsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProfileAnalytics, $Out> {
  ProfileAnalyticsCopyWith<$R, ProfileAnalytics, $Out>
  get $asProfileAnalytics =>
      $base.as((v, t, t2) => _ProfileAnalyticsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProfileAnalyticsCopyWith<$R, $In extends ProfileAnalytics, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ViewerDemographic,
    ViewerDemographicCopyWith<$R, ViewerDemographic, ViewerDemographic>
  >
  get viewerDemographics;
  $R call({
    String? userId,
    DateTime? periodStart,
    DateTime? periodEnd,
    int? profileViews,
    int? profileViewsGrowth,
    List<ViewerDemographic>? viewerDemographics,
    int? likesReceived,
    int? likesSent,
    int? superLikesReceived,
    int? matchesCreated,
    double? matchRate,
    int? messagesReceived,
    int? messagesSent,
    double? responseRate,
    Duration? averageResponseTime,
    int? popularityScore,
    ProfileRanking? ranking,
    int? percentileTier,
    DateTime? generatedAt,
  });
  ProfileAnalyticsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProfileAnalyticsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProfileAnalytics, $Out>
    implements ProfileAnalyticsCopyWith<$R, ProfileAnalytics, $Out> {
  _ProfileAnalyticsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProfileAnalytics> $mapper =
      ProfileAnalyticsMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ViewerDemographic,
    ViewerDemographicCopyWith<$R, ViewerDemographic, ViewerDemographic>
  >
  get viewerDemographics => ListCopyWith(
    $value.viewerDemographics,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(viewerDemographics: v),
  );
  @override
  $R call({
    String? userId,
    DateTime? periodStart,
    DateTime? periodEnd,
    int? profileViews,
    int? profileViewsGrowth,
    List<ViewerDemographic>? viewerDemographics,
    int? likesReceived,
    int? likesSent,
    int? superLikesReceived,
    int? matchesCreated,
    double? matchRate,
    int? messagesReceived,
    int? messagesSent,
    double? responseRate,
    Duration? averageResponseTime,
    int? popularityScore,
    ProfileRanking? ranking,
    int? percentileTier,
    DateTime? generatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (periodStart != null) #periodStart: periodStart,
      if (periodEnd != null) #periodEnd: periodEnd,
      if (profileViews != null) #profileViews: profileViews,
      if (profileViewsGrowth != null) #profileViewsGrowth: profileViewsGrowth,
      if (viewerDemographics != null) #viewerDemographics: viewerDemographics,
      if (likesReceived != null) #likesReceived: likesReceived,
      if (likesSent != null) #likesSent: likesSent,
      if (superLikesReceived != null) #superLikesReceived: superLikesReceived,
      if (matchesCreated != null) #matchesCreated: matchesCreated,
      if (matchRate != null) #matchRate: matchRate,
      if (messagesReceived != null) #messagesReceived: messagesReceived,
      if (messagesSent != null) #messagesSent: messagesSent,
      if (responseRate != null) #responseRate: responseRate,
      if (averageResponseTime != null)
        #averageResponseTime: averageResponseTime,
      if (popularityScore != null) #popularityScore: popularityScore,
      if (ranking != null) #ranking: ranking,
      if (percentileTier != null) #percentileTier: percentileTier,
      if (generatedAt != null) #generatedAt: generatedAt,
    }),
  );
  @override
  ProfileAnalytics $make(CopyWithData data) => ProfileAnalytics(
    userId: data.get(#userId, or: $value.userId),
    periodStart: data.get(#periodStart, or: $value.periodStart),
    periodEnd: data.get(#periodEnd, or: $value.periodEnd),
    profileViews: data.get(#profileViews, or: $value.profileViews),
    profileViewsGrowth: data.get(
      #profileViewsGrowth,
      or: $value.profileViewsGrowth,
    ),
    viewerDemographics: data.get(
      #viewerDemographics,
      or: $value.viewerDemographics,
    ),
    likesReceived: data.get(#likesReceived, or: $value.likesReceived),
    likesSent: data.get(#likesSent, or: $value.likesSent),
    superLikesReceived: data.get(
      #superLikesReceived,
      or: $value.superLikesReceived,
    ),
    matchesCreated: data.get(#matchesCreated, or: $value.matchesCreated),
    matchRate: data.get(#matchRate, or: $value.matchRate),
    messagesReceived: data.get(#messagesReceived, or: $value.messagesReceived),
    messagesSent: data.get(#messagesSent, or: $value.messagesSent),
    responseRate: data.get(#responseRate, or: $value.responseRate),
    averageResponseTime: data.get(
      #averageResponseTime,
      or: $value.averageResponseTime,
    ),
    popularityScore: data.get(#popularityScore, or: $value.popularityScore),
    ranking: data.get(#ranking, or: $value.ranking),
    percentileTier: data.get(#percentileTier, or: $value.percentileTier),
    generatedAt: data.get(#generatedAt, or: $value.generatedAt),
  );

  @override
  ProfileAnalyticsCopyWith<$R2, ProfileAnalytics, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProfileAnalyticsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ViewerDemographicMapper extends ClassMapperBase<ViewerDemographic> {
  ViewerDemographicMapper._();

  static ViewerDemographicMapper? _instance;
  static ViewerDemographicMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ViewerDemographicMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ViewerDemographic';

  static String _$ageRange(ViewerDemographic v) => v.ageRange;
  static const Field<ViewerDemographic, String> _f$ageRange = Field(
    'ageRange',
    _$ageRange,
  );
  static int _$count(ViewerDemographic v) => v.count;
  static const Field<ViewerDemographic, int> _f$count = Field('count', _$count);
  static double _$percentage(ViewerDemographic v) => v.percentage;
  static const Field<ViewerDemographic, double> _f$percentage = Field(
    'percentage',
    _$percentage,
  );

  @override
  final MappableFields<ViewerDemographic> fields = const {
    #ageRange: _f$ageRange,
    #count: _f$count,
    #percentage: _f$percentage,
  };

  static ViewerDemographic _instantiate(DecodingData data) {
    return ViewerDemographic(
      ageRange: data.dec(_f$ageRange),
      count: data.dec(_f$count),
      percentage: data.dec(_f$percentage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ViewerDemographic fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ViewerDemographic>(map);
  }

  static ViewerDemographic fromJson(String json) {
    return ensureInitialized().decodeJson<ViewerDemographic>(json);
  }
}

mixin ViewerDemographicMappable {
  String toJson() {
    return ViewerDemographicMapper.ensureInitialized()
        .encodeJson<ViewerDemographic>(this as ViewerDemographic);
  }

  Map<String, dynamic> toMap() {
    return ViewerDemographicMapper.ensureInitialized()
        .encodeMap<ViewerDemographic>(this as ViewerDemographic);
  }

  ViewerDemographicCopyWith<
    ViewerDemographic,
    ViewerDemographic,
    ViewerDemographic
  >
  get copyWith =>
      _ViewerDemographicCopyWithImpl<ViewerDemographic, ViewerDemographic>(
        this as ViewerDemographic,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ViewerDemographicMapper.ensureInitialized().stringifyValue(
      this as ViewerDemographic,
    );
  }

  @override
  bool operator ==(Object other) {
    return ViewerDemographicMapper.ensureInitialized().equalsValue(
      this as ViewerDemographic,
      other,
    );
  }

  @override
  int get hashCode {
    return ViewerDemographicMapper.ensureInitialized().hashValue(
      this as ViewerDemographic,
    );
  }
}

extension ViewerDemographicValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ViewerDemographic, $Out> {
  ViewerDemographicCopyWith<$R, ViewerDemographic, $Out>
  get $asViewerDemographic => $base.as(
    (v, t, t2) => _ViewerDemographicCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ViewerDemographicCopyWith<
  $R,
  $In extends ViewerDemographic,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? ageRange, int? count, double? percentage});
  ViewerDemographicCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ViewerDemographicCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ViewerDemographic, $Out>
    implements ViewerDemographicCopyWith<$R, ViewerDemographic, $Out> {
  _ViewerDemographicCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ViewerDemographic> $mapper =
      ViewerDemographicMapper.ensureInitialized();
  @override
  $R call({String? ageRange, int? count, double? percentage}) => $apply(
    FieldCopyWithData({
      if (ageRange != null) #ageRange: ageRange,
      if (count != null) #count: count,
      if (percentage != null) #percentage: percentage,
    }),
  );
  @override
  ViewerDemographic $make(CopyWithData data) => ViewerDemographic(
    ageRange: data.get(#ageRange, or: $value.ageRange),
    count: data.get(#count, or: $value.count),
    percentage: data.get(#percentage, or: $value.percentage),
  );

  @override
  ViewerDemographicCopyWith<$R2, ViewerDemographic, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ViewerDemographicCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RevenueRecordMapper extends ClassMapperBase<RevenueRecord> {
  RevenueRecordMapper._();

  static RevenueRecordMapper? _instance;
  static RevenueRecordMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RevenueRecordMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RevenueRecord';

  static String _$recordId(RevenueRecord v) => v.recordId;
  static const Field<RevenueRecord, String> _f$recordId = Field(
    'recordId',
    _$recordId,
  );
  static String _$userId(RevenueRecord v) => v.userId;
  static const Field<RevenueRecord, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static RevenueSource _$source(RevenueRecord v) => v.source;
  static const Field<RevenueRecord, RevenueSource> _f$source = Field(
    'source',
    _$source,
  );
  static double _$amount(RevenueRecord v) => v.amount;
  static const Field<RevenueRecord, double> _f$amount = Field(
    'amount',
    _$amount,
  );
  static String _$currency(RevenueRecord v) => v.currency;
  static const Field<RevenueRecord, String> _f$currency = Field(
    'currency',
    _$currency,
    opt: true,
    def: 'BRL',
  );
  static String? _$transactionId(RevenueRecord v) => v.transactionId;
  static const Field<RevenueRecord, String> _f$transactionId = Field(
    'transactionId',
    _$transactionId,
    opt: true,
  );
  static DateTime _$recordedAt(RevenueRecord v) => v.recordedAt;
  static const Field<RevenueRecord, DateTime> _f$recordedAt = Field(
    'recordedAt',
    _$recordedAt,
  );

  @override
  final MappableFields<RevenueRecord> fields = const {
    #recordId: _f$recordId,
    #userId: _f$userId,
    #source: _f$source,
    #amount: _f$amount,
    #currency: _f$currency,
    #transactionId: _f$transactionId,
    #recordedAt: _f$recordedAt,
  };

  static RevenueRecord _instantiate(DecodingData data) {
    return RevenueRecord(
      recordId: data.dec(_f$recordId),
      userId: data.dec(_f$userId),
      source: data.dec(_f$source),
      amount: data.dec(_f$amount),
      currency: data.dec(_f$currency),
      transactionId: data.dec(_f$transactionId),
      recordedAt: data.dec(_f$recordedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RevenueRecord fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RevenueRecord>(map);
  }

  static RevenueRecord fromJson(String json) {
    return ensureInitialized().decodeJson<RevenueRecord>(json);
  }
}

mixin RevenueRecordMappable {
  String toJson() {
    return RevenueRecordMapper.ensureInitialized().encodeJson<RevenueRecord>(
      this as RevenueRecord,
    );
  }

  Map<String, dynamic> toMap() {
    return RevenueRecordMapper.ensureInitialized().encodeMap<RevenueRecord>(
      this as RevenueRecord,
    );
  }

  RevenueRecordCopyWith<RevenueRecord, RevenueRecord, RevenueRecord>
  get copyWith => _RevenueRecordCopyWithImpl<RevenueRecord, RevenueRecord>(
    this as RevenueRecord,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return RevenueRecordMapper.ensureInitialized().stringifyValue(
      this as RevenueRecord,
    );
  }

  @override
  bool operator ==(Object other) {
    return RevenueRecordMapper.ensureInitialized().equalsValue(
      this as RevenueRecord,
      other,
    );
  }

  @override
  int get hashCode {
    return RevenueRecordMapper.ensureInitialized().hashValue(
      this as RevenueRecord,
    );
  }
}

extension RevenueRecordValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RevenueRecord, $Out> {
  RevenueRecordCopyWith<$R, RevenueRecord, $Out> get $asRevenueRecord =>
      $base.as((v, t, t2) => _RevenueRecordCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RevenueRecordCopyWith<$R, $In extends RevenueRecord, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? recordId,
    String? userId,
    RevenueSource? source,
    double? amount,
    String? currency,
    String? transactionId,
    DateTime? recordedAt,
  });
  RevenueRecordCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RevenueRecordCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RevenueRecord, $Out>
    implements RevenueRecordCopyWith<$R, RevenueRecord, $Out> {
  _RevenueRecordCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RevenueRecord> $mapper =
      RevenueRecordMapper.ensureInitialized();
  @override
  $R call({
    String? recordId,
    String? userId,
    RevenueSource? source,
    double? amount,
    String? currency,
    Object? transactionId = $none,
    DateTime? recordedAt,
  }) => $apply(
    FieldCopyWithData({
      if (recordId != null) #recordId: recordId,
      if (userId != null) #userId: userId,
      if (source != null) #source: source,
      if (amount != null) #amount: amount,
      if (currency != null) #currency: currency,
      if (transactionId != $none) #transactionId: transactionId,
      if (recordedAt != null) #recordedAt: recordedAt,
    }),
  );
  @override
  RevenueRecord $make(CopyWithData data) => RevenueRecord(
    recordId: data.get(#recordId, or: $value.recordId),
    userId: data.get(#userId, or: $value.userId),
    source: data.get(#source, or: $value.source),
    amount: data.get(#amount, or: $value.amount),
    currency: data.get(#currency, or: $value.currency),
    transactionId: data.get(#transactionId, or: $value.transactionId),
    recordedAt: data.get(#recordedAt, or: $value.recordedAt),
  );

  @override
  RevenueRecordCopyWith<$R2, RevenueRecord, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RevenueRecordCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RevenueReportMapper extends ClassMapperBase<RevenueReport> {
  RevenueReportMapper._();

  static RevenueReportMapper? _instance;
  static RevenueReportMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RevenueReportMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RevenueReport';

  static DateTime _$periodStart(RevenueReport v) => v.periodStart;
  static const Field<RevenueReport, DateTime> _f$periodStart = Field(
    'periodStart',
    _$periodStart,
  );
  static DateTime _$periodEnd(RevenueReport v) => v.periodEnd;
  static const Field<RevenueReport, DateTime> _f$periodEnd = Field(
    'periodEnd',
    _$periodEnd,
  );
  static double _$totalRevenue(RevenueReport v) => v.totalRevenue;
  static const Field<RevenueReport, double> _f$totalRevenue = Field(
    'totalRevenue',
    _$totalRevenue,
  );
  static double _$subscriptionRevenue(RevenueReport v) => v.subscriptionRevenue;
  static const Field<RevenueReport, double> _f$subscriptionRevenue = Field(
    'subscriptionRevenue',
    _$subscriptionRevenue,
  );
  static double _$purchaseRevenue(RevenueReport v) => v.purchaseRevenue;
  static const Field<RevenueReport, double> _f$purchaseRevenue = Field(
    'purchaseRevenue',
    _$purchaseRevenue,
  );
  static double _$boostRevenue(RevenueReport v) => v.boostRevenue;
  static const Field<RevenueReport, double> _f$boostRevenue = Field(
    'boostRevenue',
    _$boostRevenue,
  );
  static double _$giftRevenue(RevenueReport v) => v.giftRevenue;
  static const Field<RevenueReport, double> _f$giftRevenue = Field(
    'giftRevenue',
    _$giftRevenue,
  );
  static int _$totalTransactions(RevenueReport v) => v.totalTransactions;
  static const Field<RevenueReport, int> _f$totalTransactions = Field(
    'totalTransactions',
    _$totalTransactions,
  );
  static double _$averageTransactionValue(RevenueReport v) =>
      v.averageTransactionValue;
  static const Field<RevenueReport, double> _f$averageTransactionValue = Field(
    'averageTransactionValue',
    _$averageTransactionValue,
  );
  static int _$uniquePayers(RevenueReport v) => v.uniquePayers;
  static const Field<RevenueReport, int> _f$uniquePayers = Field(
    'uniquePayers',
    _$uniquePayers,
  );
  static double _$revenueGrowth(RevenueReport v) => v.revenueGrowth;
  static const Field<RevenueReport, double> _f$revenueGrowth = Field(
    'revenueGrowth',
    _$revenueGrowth,
    opt: true,
    def: 0,
  );
  static Map<RevenueSource, double> _$revenueBySource(RevenueReport v) =>
      v.revenueBySource;
  static const Field<RevenueReport, Map<RevenueSource, double>>
  _f$revenueBySource = Field('revenueBySource', _$revenueBySource);
  static Map<String, double> _$revenueByRegion(RevenueReport v) =>
      v.revenueByRegion;
  static const Field<RevenueReport, Map<String, double>> _f$revenueByRegion =
      Field('revenueByRegion', _$revenueByRegion);
  static double _$projectedMRR(RevenueReport v) => v.projectedMRR;
  static const Field<RevenueReport, double> _f$projectedMRR = Field(
    'projectedMRR',
    _$projectedMRR,
  );
  static double _$projectedARR(RevenueReport v) => v.projectedARR;
  static const Field<RevenueReport, double> _f$projectedARR = Field(
    'projectedARR',
    _$projectedARR,
  );
  static DateTime _$generatedAt(RevenueReport v) => v.generatedAt;
  static const Field<RevenueReport, DateTime> _f$generatedAt = Field(
    'generatedAt',
    _$generatedAt,
  );

  @override
  final MappableFields<RevenueReport> fields = const {
    #periodStart: _f$periodStart,
    #periodEnd: _f$periodEnd,
    #totalRevenue: _f$totalRevenue,
    #subscriptionRevenue: _f$subscriptionRevenue,
    #purchaseRevenue: _f$purchaseRevenue,
    #boostRevenue: _f$boostRevenue,
    #giftRevenue: _f$giftRevenue,
    #totalTransactions: _f$totalTransactions,
    #averageTransactionValue: _f$averageTransactionValue,
    #uniquePayers: _f$uniquePayers,
    #revenueGrowth: _f$revenueGrowth,
    #revenueBySource: _f$revenueBySource,
    #revenueByRegion: _f$revenueByRegion,
    #projectedMRR: _f$projectedMRR,
    #projectedARR: _f$projectedARR,
    #generatedAt: _f$generatedAt,
  };

  static RevenueReport _instantiate(DecodingData data) {
    return RevenueReport(
      periodStart: data.dec(_f$periodStart),
      periodEnd: data.dec(_f$periodEnd),
      totalRevenue: data.dec(_f$totalRevenue),
      subscriptionRevenue: data.dec(_f$subscriptionRevenue),
      purchaseRevenue: data.dec(_f$purchaseRevenue),
      boostRevenue: data.dec(_f$boostRevenue),
      giftRevenue: data.dec(_f$giftRevenue),
      totalTransactions: data.dec(_f$totalTransactions),
      averageTransactionValue: data.dec(_f$averageTransactionValue),
      uniquePayers: data.dec(_f$uniquePayers),
      revenueGrowth: data.dec(_f$revenueGrowth),
      revenueBySource: data.dec(_f$revenueBySource),
      revenueByRegion: data.dec(_f$revenueByRegion),
      projectedMRR: data.dec(_f$projectedMRR),
      projectedARR: data.dec(_f$projectedARR),
      generatedAt: data.dec(_f$generatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RevenueReport fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RevenueReport>(map);
  }

  static RevenueReport fromJson(String json) {
    return ensureInitialized().decodeJson<RevenueReport>(json);
  }
}

mixin RevenueReportMappable {
  String toJson() {
    return RevenueReportMapper.ensureInitialized().encodeJson<RevenueReport>(
      this as RevenueReport,
    );
  }

  Map<String, dynamic> toMap() {
    return RevenueReportMapper.ensureInitialized().encodeMap<RevenueReport>(
      this as RevenueReport,
    );
  }

  RevenueReportCopyWith<RevenueReport, RevenueReport, RevenueReport>
  get copyWith => _RevenueReportCopyWithImpl<RevenueReport, RevenueReport>(
    this as RevenueReport,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return RevenueReportMapper.ensureInitialized().stringifyValue(
      this as RevenueReport,
    );
  }

  @override
  bool operator ==(Object other) {
    return RevenueReportMapper.ensureInitialized().equalsValue(
      this as RevenueReport,
      other,
    );
  }

  @override
  int get hashCode {
    return RevenueReportMapper.ensureInitialized().hashValue(
      this as RevenueReport,
    );
  }
}

extension RevenueReportValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RevenueReport, $Out> {
  RevenueReportCopyWith<$R, RevenueReport, $Out> get $asRevenueReport =>
      $base.as((v, t, t2) => _RevenueReportCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RevenueReportCopyWith<$R, $In extends RevenueReport, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, RevenueSource, double, ObjectCopyWith<$R, double, double>>
  get revenueBySource;
  MapCopyWith<$R, String, double, ObjectCopyWith<$R, double, double>>
  get revenueByRegion;
  $R call({
    DateTime? periodStart,
    DateTime? periodEnd,
    double? totalRevenue,
    double? subscriptionRevenue,
    double? purchaseRevenue,
    double? boostRevenue,
    double? giftRevenue,
    int? totalTransactions,
    double? averageTransactionValue,
    int? uniquePayers,
    double? revenueGrowth,
    Map<RevenueSource, double>? revenueBySource,
    Map<String, double>? revenueByRegion,
    double? projectedMRR,
    double? projectedARR,
    DateTime? generatedAt,
  });
  RevenueReportCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RevenueReportCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RevenueReport, $Out>
    implements RevenueReportCopyWith<$R, RevenueReport, $Out> {
  _RevenueReportCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RevenueReport> $mapper =
      RevenueReportMapper.ensureInitialized();
  @override
  MapCopyWith<$R, RevenueSource, double, ObjectCopyWith<$R, double, double>>
  get revenueBySource => MapCopyWith(
    $value.revenueBySource,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(revenueBySource: v),
  );
  @override
  MapCopyWith<$R, String, double, ObjectCopyWith<$R, double, double>>
  get revenueByRegion => MapCopyWith(
    $value.revenueByRegion,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(revenueByRegion: v),
  );
  @override
  $R call({
    DateTime? periodStart,
    DateTime? periodEnd,
    double? totalRevenue,
    double? subscriptionRevenue,
    double? purchaseRevenue,
    double? boostRevenue,
    double? giftRevenue,
    int? totalTransactions,
    double? averageTransactionValue,
    int? uniquePayers,
    double? revenueGrowth,
    Map<RevenueSource, double>? revenueBySource,
    Map<String, double>? revenueByRegion,
    double? projectedMRR,
    double? projectedARR,
    DateTime? generatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (periodStart != null) #periodStart: periodStart,
      if (periodEnd != null) #periodEnd: periodEnd,
      if (totalRevenue != null) #totalRevenue: totalRevenue,
      if (subscriptionRevenue != null)
        #subscriptionRevenue: subscriptionRevenue,
      if (purchaseRevenue != null) #purchaseRevenue: purchaseRevenue,
      if (boostRevenue != null) #boostRevenue: boostRevenue,
      if (giftRevenue != null) #giftRevenue: giftRevenue,
      if (totalTransactions != null) #totalTransactions: totalTransactions,
      if (averageTransactionValue != null)
        #averageTransactionValue: averageTransactionValue,
      if (uniquePayers != null) #uniquePayers: uniquePayers,
      if (revenueGrowth != null) #revenueGrowth: revenueGrowth,
      if (revenueBySource != null) #revenueBySource: revenueBySource,
      if (revenueByRegion != null) #revenueByRegion: revenueByRegion,
      if (projectedMRR != null) #projectedMRR: projectedMRR,
      if (projectedARR != null) #projectedARR: projectedARR,
      if (generatedAt != null) #generatedAt: generatedAt,
    }),
  );
  @override
  RevenueReport $make(CopyWithData data) => RevenueReport(
    periodStart: data.get(#periodStart, or: $value.periodStart),
    periodEnd: data.get(#periodEnd, or: $value.periodEnd),
    totalRevenue: data.get(#totalRevenue, or: $value.totalRevenue),
    subscriptionRevenue: data.get(
      #subscriptionRevenue,
      or: $value.subscriptionRevenue,
    ),
    purchaseRevenue: data.get(#purchaseRevenue, or: $value.purchaseRevenue),
    boostRevenue: data.get(#boostRevenue, or: $value.boostRevenue),
    giftRevenue: data.get(#giftRevenue, or: $value.giftRevenue),
    totalTransactions: data.get(
      #totalTransactions,
      or: $value.totalTransactions,
    ),
    averageTransactionValue: data.get(
      #averageTransactionValue,
      or: $value.averageTransactionValue,
    ),
    uniquePayers: data.get(#uniquePayers, or: $value.uniquePayers),
    revenueGrowth: data.get(#revenueGrowth, or: $value.revenueGrowth),
    revenueBySource: data.get(#revenueBySource, or: $value.revenueBySource),
    revenueByRegion: data.get(#revenueByRegion, or: $value.revenueByRegion),
    projectedMRR: data.get(#projectedMRR, or: $value.projectedMRR),
    projectedARR: data.get(#projectedARR, or: $value.projectedARR),
    generatedAt: data.get(#generatedAt, or: $value.generatedAt),
  );

  @override
  RevenueReportCopyWith<$R2, RevenueReport, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RevenueReportCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ActivateBoostRequestMapper extends ClassMapperBase<ActivateBoostRequest> {
  ActivateBoostRequestMapper._();

  static ActivateBoostRequestMapper? _instance;
  static ActivateBoostRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ActivateBoostRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ActivateBoostRequest';

  static String _$userId(ActivateBoostRequest v) => v.userId;
  static const Field<ActivateBoostRequest, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static BoostType _$type(ActivateBoostRequest v) => v.type;
  static const Field<ActivateBoostRequest, BoostType> _f$type = Field(
    'type',
    _$type,
  );
  static DateTime? _$scheduledTime(ActivateBoostRequest v) => v.scheduledTime;
  static const Field<ActivateBoostRequest, DateTime> _f$scheduledTime = Field(
    'scheduledTime',
    _$scheduledTime,
    opt: true,
  );

  @override
  final MappableFields<ActivateBoostRequest> fields = const {
    #userId: _f$userId,
    #type: _f$type,
    #scheduledTime: _f$scheduledTime,
  };

  static ActivateBoostRequest _instantiate(DecodingData data) {
    return ActivateBoostRequest(
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      scheduledTime: data.dec(_f$scheduledTime),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ActivateBoostRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ActivateBoostRequest>(map);
  }

  static ActivateBoostRequest fromJson(String json) {
    return ensureInitialized().decodeJson<ActivateBoostRequest>(json);
  }
}

mixin ActivateBoostRequestMappable {
  String toJson() {
    return ActivateBoostRequestMapper.ensureInitialized()
        .encodeJson<ActivateBoostRequest>(this as ActivateBoostRequest);
  }

  Map<String, dynamic> toMap() {
    return ActivateBoostRequestMapper.ensureInitialized()
        .encodeMap<ActivateBoostRequest>(this as ActivateBoostRequest);
  }

  ActivateBoostRequestCopyWith<
    ActivateBoostRequest,
    ActivateBoostRequest,
    ActivateBoostRequest
  >
  get copyWith =>
      _ActivateBoostRequestCopyWithImpl<
        ActivateBoostRequest,
        ActivateBoostRequest
      >(this as ActivateBoostRequest, $identity, $identity);
  @override
  String toString() {
    return ActivateBoostRequestMapper.ensureInitialized().stringifyValue(
      this as ActivateBoostRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return ActivateBoostRequestMapper.ensureInitialized().equalsValue(
      this as ActivateBoostRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return ActivateBoostRequestMapper.ensureInitialized().hashValue(
      this as ActivateBoostRequest,
    );
  }
}

extension ActivateBoostRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ActivateBoostRequest, $Out> {
  ActivateBoostRequestCopyWith<$R, ActivateBoostRequest, $Out>
  get $asActivateBoostRequest => $base.as(
    (v, t, t2) => _ActivateBoostRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ActivateBoostRequestCopyWith<
  $R,
  $In extends ActivateBoostRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? userId, BoostType? type, DateTime? scheduledTime});
  ActivateBoostRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ActivateBoostRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ActivateBoostRequest, $Out>
    implements ActivateBoostRequestCopyWith<$R, ActivateBoostRequest, $Out> {
  _ActivateBoostRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ActivateBoostRequest> $mapper =
      ActivateBoostRequestMapper.ensureInitialized();
  @override
  $R call({String? userId, BoostType? type, Object? scheduledTime = $none}) =>
      $apply(
        FieldCopyWithData({
          if (userId != null) #userId: userId,
          if (type != null) #type: type,
          if (scheduledTime != $none) #scheduledTime: scheduledTime,
        }),
      );
  @override
  ActivateBoostRequest $make(CopyWithData data) => ActivateBoostRequest(
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    scheduledTime: data.get(#scheduledTime, or: $value.scheduledTime),
  );

  @override
  ActivateBoostRequestCopyWith<$R2, ActivateBoostRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ActivateBoostRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

