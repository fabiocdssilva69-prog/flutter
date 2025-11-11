// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'subscription.dart';

class SubscriptionMapper extends ClassMapperBase<Subscription> {
  SubscriptionMapper._();

  static SubscriptionMapper? _instance;
  static SubscriptionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubscriptionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Subscription';

  static String _$subscriptionId(Subscription v) => v.subscriptionId;
  static const Field<Subscription, String> _f$subscriptionId = Field(
    'subscriptionId',
    _$subscriptionId,
  );
  static String _$userId(Subscription v) => v.userId;
  static const Field<Subscription, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static SubscriptionTier _$tier(Subscription v) => v.tier;
  static const Field<Subscription, SubscriptionTier> _f$tier = Field(
    'tier',
    _$tier,
  );
  static SubscriptionStatus _$status(Subscription v) => v.status;
  static const Field<Subscription, SubscriptionStatus> _f$status = Field(
    'status',
    _$status,
  );
  static String? _$paymentProvider(Subscription v) => v.paymentProvider;
  static const Field<Subscription, String> _f$paymentProvider = Field(
    'paymentProvider',
    _$paymentProvider,
    opt: true,
  );
  static String? _$externalSubscriptionId(Subscription v) =>
      v.externalSubscriptionId;
  static const Field<Subscription, String> _f$externalSubscriptionId = Field(
    'externalSubscriptionId',
    _$externalSubscriptionId,
    opt: true,
  );
  static DateTime _$startDate(Subscription v) => v.startDate;
  static const Field<Subscription, DateTime> _f$startDate = Field(
    'startDate',
    _$startDate,
  );
  static DateTime? _$endDate(Subscription v) => v.endDate;
  static const Field<Subscription, DateTime> _f$endDate = Field(
    'endDate',
    _$endDate,
    opt: true,
  );
  static DateTime? _$trialEndDate(Subscription v) => v.trialEndDate;
  static const Field<Subscription, DateTime> _f$trialEndDate = Field(
    'trialEndDate',
    _$trialEndDate,
    opt: true,
  );
  static bool _$isInTrial(Subscription v) => v.isInTrial;
  static const Field<Subscription, bool> _f$isInTrial = Field(
    'isInTrial',
    _$isInTrial,
    opt: true,
    def: false,
  );
  static bool _$autoRenew(Subscription v) => v.autoRenew;
  static const Field<Subscription, bool> _f$autoRenew = Field(
    'autoRenew',
    _$autoRenew,
    opt: true,
    def: true,
  );
  static DateTime? _$cancelledAt(Subscription v) => v.cancelledAt;
  static const Field<Subscription, DateTime> _f$cancelledAt = Field(
    'cancelledAt',
    _$cancelledAt,
    opt: true,
  );
  static String? _$cancellationReason(Subscription v) => v.cancellationReason;
  static const Field<Subscription, String> _f$cancellationReason = Field(
    'cancellationReason',
    _$cancellationReason,
    opt: true,
  );
  static DateTime _$createdAt(Subscription v) => v.createdAt;
  static const Field<Subscription, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$updatedAt(Subscription v) => v.updatedAt;
  static const Field<Subscription, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static bool _$isActive(Subscription v) => v.isActive;
  static const Field<Subscription, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    mode: FieldMode.member,
  );
  static bool _$isExpired(Subscription v) => v.isExpired;
  static const Field<Subscription, bool> _f$isExpired = Field(
    'isExpired',
    _$isExpired,
    mode: FieldMode.member,
  );
  static int _$daysRemaining(Subscription v) => v.daysRemaining;
  static const Field<Subscription, int> _f$daysRemaining = Field(
    'daysRemaining',
    _$daysRemaining,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<Subscription> fields = const {
    #subscriptionId: _f$subscriptionId,
    #userId: _f$userId,
    #tier: _f$tier,
    #status: _f$status,
    #paymentProvider: _f$paymentProvider,
    #externalSubscriptionId: _f$externalSubscriptionId,
    #startDate: _f$startDate,
    #endDate: _f$endDate,
    #trialEndDate: _f$trialEndDate,
    #isInTrial: _f$isInTrial,
    #autoRenew: _f$autoRenew,
    #cancelledAt: _f$cancelledAt,
    #cancellationReason: _f$cancellationReason,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #isActive: _f$isActive,
    #isExpired: _f$isExpired,
    #daysRemaining: _f$daysRemaining,
  };

  static Subscription _instantiate(DecodingData data) {
    return Subscription(
      subscriptionId: data.dec(_f$subscriptionId),
      userId: data.dec(_f$userId),
      tier: data.dec(_f$tier),
      status: data.dec(_f$status),
      paymentProvider: data.dec(_f$paymentProvider),
      externalSubscriptionId: data.dec(_f$externalSubscriptionId),
      startDate: data.dec(_f$startDate),
      endDate: data.dec(_f$endDate),
      trialEndDate: data.dec(_f$trialEndDate),
      isInTrial: data.dec(_f$isInTrial),
      autoRenew: data.dec(_f$autoRenew),
      cancelledAt: data.dec(_f$cancelledAt),
      cancellationReason: data.dec(_f$cancellationReason),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Subscription fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Subscription>(map);
  }

  static Subscription fromJson(String json) {
    return ensureInitialized().decodeJson<Subscription>(json);
  }
}

mixin SubscriptionMappable {
  String toJson() {
    return SubscriptionMapper.ensureInitialized().encodeJson<Subscription>(
      this as Subscription,
    );
  }

  Map<String, dynamic> toMap() {
    return SubscriptionMapper.ensureInitialized().encodeMap<Subscription>(
      this as Subscription,
    );
  }

  SubscriptionCopyWith<Subscription, Subscription, Subscription> get copyWith =>
      _SubscriptionCopyWithImpl<Subscription, Subscription>(
        this as Subscription,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SubscriptionMapper.ensureInitialized().stringifyValue(
      this as Subscription,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubscriptionMapper.ensureInitialized().equalsValue(
      this as Subscription,
      other,
    );
  }

  @override
  int get hashCode {
    return SubscriptionMapper.ensureInitialized().hashValue(
      this as Subscription,
    );
  }
}

extension SubscriptionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, Subscription, $Out> {
  SubscriptionCopyWith<$R, Subscription, $Out> get $asSubscription =>
      $base.as((v, t, t2) => _SubscriptionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SubscriptionCopyWith<$R, $In extends Subscription, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? subscriptionId,
    String? userId,
    SubscriptionTier? tier,
    SubscriptionStatus? status,
    String? paymentProvider,
    String? externalSubscriptionId,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? trialEndDate,
    bool? isInTrial,
    bool? autoRenew,
    DateTime? cancelledAt,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  SubscriptionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SubscriptionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Subscription, $Out>
    implements SubscriptionCopyWith<$R, Subscription, $Out> {
  _SubscriptionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Subscription> $mapper =
      SubscriptionMapper.ensureInitialized();
  @override
  $R call({
    String? subscriptionId,
    String? userId,
    SubscriptionTier? tier,
    SubscriptionStatus? status,
    Object? paymentProvider = $none,
    Object? externalSubscriptionId = $none,
    DateTime? startDate,
    Object? endDate = $none,
    Object? trialEndDate = $none,
    bool? isInTrial,
    bool? autoRenew,
    Object? cancelledAt = $none,
    Object? cancellationReason = $none,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (subscriptionId != null) #subscriptionId: subscriptionId,
      if (userId != null) #userId: userId,
      if (tier != null) #tier: tier,
      if (status != null) #status: status,
      if (paymentProvider != $none) #paymentProvider: paymentProvider,
      if (externalSubscriptionId != $none)
        #externalSubscriptionId: externalSubscriptionId,
      if (startDate != null) #startDate: startDate,
      if (endDate != $none) #endDate: endDate,
      if (trialEndDate != $none) #trialEndDate: trialEndDate,
      if (isInTrial != null) #isInTrial: isInTrial,
      if (autoRenew != null) #autoRenew: autoRenew,
      if (cancelledAt != $none) #cancelledAt: cancelledAt,
      if (cancellationReason != $none) #cancellationReason: cancellationReason,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  Subscription $make(CopyWithData data) => Subscription(
    subscriptionId: data.get(#subscriptionId, or: $value.subscriptionId),
    userId: data.get(#userId, or: $value.userId),
    tier: data.get(#tier, or: $value.tier),
    status: data.get(#status, or: $value.status),
    paymentProvider: data.get(#paymentProvider, or: $value.paymentProvider),
    externalSubscriptionId: data.get(
      #externalSubscriptionId,
      or: $value.externalSubscriptionId,
    ),
    startDate: data.get(#startDate, or: $value.startDate),
    endDate: data.get(#endDate, or: $value.endDate),
    trialEndDate: data.get(#trialEndDate, or: $value.trialEndDate),
    isInTrial: data.get(#isInTrial, or: $value.isInTrial),
    autoRenew: data.get(#autoRenew, or: $value.autoRenew),
    cancelledAt: data.get(#cancelledAt, or: $value.cancelledAt),
    cancellationReason: data.get(
      #cancellationReason,
      or: $value.cancellationReason,
    ),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  SubscriptionCopyWith<$R2, Subscription, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SubscriptionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TierFeaturesMapper extends ClassMapperBase<TierFeatures> {
  TierFeaturesMapper._();

  static TierFeaturesMapper? _instance;
  static TierFeaturesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TierFeaturesMapper._());
      FeatureAccessMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TierFeatures';

  static SubscriptionTier _$tier(TierFeatures v) => v.tier;
  static const Field<TierFeatures, SubscriptionTier> _f$tier = Field(
    'tier',
    _$tier,
  );
  static String _$name(TierFeatures v) => v.name;
  static const Field<TierFeatures, String> _f$name = Field('name', _$name);
  static String _$description(TierFeatures v) => v.description;
  static const Field<TierFeatures, String> _f$description = Field(
    'description',
    _$description,
  );
  static double _$monthlyPrice(TierFeatures v) => v.monthlyPrice;
  static const Field<TierFeatures, double> _f$monthlyPrice = Field(
    'monthlyPrice',
    _$monthlyPrice,
  );
  static double _$yearlyPrice(TierFeatures v) => v.yearlyPrice;
  static const Field<TierFeatures, double> _f$yearlyPrice = Field(
    'yearlyPrice',
    _$yearlyPrice,
  );
  static int _$trialDays(TierFeatures v) => v.trialDays;
  static const Field<TierFeatures, int> _f$trialDays = Field(
    'trialDays',
    _$trialDays,
    opt: true,
    def: 0,
  );
  static List<FeatureAccess> _$features(TierFeatures v) => v.features;
  static const Field<TierFeatures, List<FeatureAccess>> _f$features = Field(
    'features',
    _$features,
  );
  static List<String> _$highlightedFeatures(TierFeatures v) =>
      v.highlightedFeatures;
  static const Field<TierFeatures, List<String>> _f$highlightedFeatures = Field(
    'highlightedFeatures',
    _$highlightedFeatures,
  );
  static double _$yearlyDiscount(TierFeatures v) => v.yearlyDiscount;
  static const Field<TierFeatures, double> _f$yearlyDiscount = Field(
    'yearlyDiscount',
    _$yearlyDiscount,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<TierFeatures> fields = const {
    #tier: _f$tier,
    #name: _f$name,
    #description: _f$description,
    #monthlyPrice: _f$monthlyPrice,
    #yearlyPrice: _f$yearlyPrice,
    #trialDays: _f$trialDays,
    #features: _f$features,
    #highlightedFeatures: _f$highlightedFeatures,
    #yearlyDiscount: _f$yearlyDiscount,
  };

  static TierFeatures _instantiate(DecodingData data) {
    return TierFeatures(
      tier: data.dec(_f$tier),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      monthlyPrice: data.dec(_f$monthlyPrice),
      yearlyPrice: data.dec(_f$yearlyPrice),
      trialDays: data.dec(_f$trialDays),
      features: data.dec(_f$features),
      highlightedFeatures: data.dec(_f$highlightedFeatures),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TierFeatures fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TierFeatures>(map);
  }

  static TierFeatures fromJson(String json) {
    return ensureInitialized().decodeJson<TierFeatures>(json);
  }
}

mixin TierFeaturesMappable {
  String toJson() {
    return TierFeaturesMapper.ensureInitialized().encodeJson<TierFeatures>(
      this as TierFeatures,
    );
  }

  Map<String, dynamic> toMap() {
    return TierFeaturesMapper.ensureInitialized().encodeMap<TierFeatures>(
      this as TierFeatures,
    );
  }

  TierFeaturesCopyWith<TierFeatures, TierFeatures, TierFeatures> get copyWith =>
      _TierFeaturesCopyWithImpl<TierFeatures, TierFeatures>(
        this as TierFeatures,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TierFeaturesMapper.ensureInitialized().stringifyValue(
      this as TierFeatures,
    );
  }

  @override
  bool operator ==(Object other) {
    return TierFeaturesMapper.ensureInitialized().equalsValue(
      this as TierFeatures,
      other,
    );
  }

  @override
  int get hashCode {
    return TierFeaturesMapper.ensureInitialized().hashValue(
      this as TierFeatures,
    );
  }
}

extension TierFeaturesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TierFeatures, $Out> {
  TierFeaturesCopyWith<$R, TierFeatures, $Out> get $asTierFeatures =>
      $base.as((v, t, t2) => _TierFeaturesCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TierFeaturesCopyWith<$R, $In extends TierFeatures, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FeatureAccess,
    FeatureAccessCopyWith<$R, FeatureAccess, FeatureAccess>
  >
  get features;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get highlightedFeatures;
  $R call({
    SubscriptionTier? tier,
    String? name,
    String? description,
    double? monthlyPrice,
    double? yearlyPrice,
    int? trialDays,
    List<FeatureAccess>? features,
    List<String>? highlightedFeatures,
  });
  TierFeaturesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TierFeaturesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TierFeatures, $Out>
    implements TierFeaturesCopyWith<$R, TierFeatures, $Out> {
  _TierFeaturesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TierFeatures> $mapper =
      TierFeaturesMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FeatureAccess,
    FeatureAccessCopyWith<$R, FeatureAccess, FeatureAccess>
  >
  get features => ListCopyWith(
    $value.features,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(features: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get highlightedFeatures => ListCopyWith(
    $value.highlightedFeatures,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(highlightedFeatures: v),
  );
  @override
  $R call({
    SubscriptionTier? tier,
    String? name,
    String? description,
    double? monthlyPrice,
    double? yearlyPrice,
    int? trialDays,
    List<FeatureAccess>? features,
    List<String>? highlightedFeatures,
  }) => $apply(
    FieldCopyWithData({
      if (tier != null) #tier: tier,
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (monthlyPrice != null) #monthlyPrice: monthlyPrice,
      if (yearlyPrice != null) #yearlyPrice: yearlyPrice,
      if (trialDays != null) #trialDays: trialDays,
      if (features != null) #features: features,
      if (highlightedFeatures != null)
        #highlightedFeatures: highlightedFeatures,
    }),
  );
  @override
  TierFeatures $make(CopyWithData data) => TierFeatures(
    tier: data.get(#tier, or: $value.tier),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    monthlyPrice: data.get(#monthlyPrice, or: $value.monthlyPrice),
    yearlyPrice: data.get(#yearlyPrice, or: $value.yearlyPrice),
    trialDays: data.get(#trialDays, or: $value.trialDays),
    features: data.get(#features, or: $value.features),
    highlightedFeatures: data.get(
      #highlightedFeatures,
      or: $value.highlightedFeatures,
    ),
  );

  @override
  TierFeaturesCopyWith<$R2, TierFeatures, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TierFeaturesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FeatureAccessMapper extends ClassMapperBase<FeatureAccess> {
  FeatureAccessMapper._();

  static FeatureAccessMapper? _instance;
  static FeatureAccessMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FeatureAccessMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FeatureAccess';

  static String _$featureKey(FeatureAccess v) => v.featureKey;
  static const Field<FeatureAccess, String> _f$featureKey = Field(
    'featureKey',
    _$featureKey,
  );
  static String _$featureName(FeatureAccess v) => v.featureName;
  static const Field<FeatureAccess, String> _f$featureName = Field(
    'featureName',
    _$featureName,
  );
  static bool _$isEnabled(FeatureAccess v) => v.isEnabled;
  static const Field<FeatureAccess, bool> _f$isEnabled = Field(
    'isEnabled',
    _$isEnabled,
    opt: true,
    def: true,
  );
  static int? _$limit(FeatureAccess v) => v.limit;
  static const Field<FeatureAccess, int> _f$limit = Field(
    'limit',
    _$limit,
    opt: true,
  );
  static String? _$description(FeatureAccess v) => v.description;
  static const Field<FeatureAccess, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static bool _$isUnlimited(FeatureAccess v) => v.isUnlimited;
  static const Field<FeatureAccess, bool> _f$isUnlimited = Field(
    'isUnlimited',
    _$isUnlimited,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<FeatureAccess> fields = const {
    #featureKey: _f$featureKey,
    #featureName: _f$featureName,
    #isEnabled: _f$isEnabled,
    #limit: _f$limit,
    #description: _f$description,
    #isUnlimited: _f$isUnlimited,
  };

  static FeatureAccess _instantiate(DecodingData data) {
    return FeatureAccess(
      featureKey: data.dec(_f$featureKey),
      featureName: data.dec(_f$featureName),
      isEnabled: data.dec(_f$isEnabled),
      limit: data.dec(_f$limit),
      description: data.dec(_f$description),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FeatureAccess fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FeatureAccess>(map);
  }

  static FeatureAccess fromJson(String json) {
    return ensureInitialized().decodeJson<FeatureAccess>(json);
  }
}

mixin FeatureAccessMappable {
  String toJson() {
    return FeatureAccessMapper.ensureInitialized().encodeJson<FeatureAccess>(
      this as FeatureAccess,
    );
  }

  Map<String, dynamic> toMap() {
    return FeatureAccessMapper.ensureInitialized().encodeMap<FeatureAccess>(
      this as FeatureAccess,
    );
  }

  FeatureAccessCopyWith<FeatureAccess, FeatureAccess, FeatureAccess>
  get copyWith => _FeatureAccessCopyWithImpl<FeatureAccess, FeatureAccess>(
    this as FeatureAccess,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FeatureAccessMapper.ensureInitialized().stringifyValue(
      this as FeatureAccess,
    );
  }

  @override
  bool operator ==(Object other) {
    return FeatureAccessMapper.ensureInitialized().equalsValue(
      this as FeatureAccess,
      other,
    );
  }

  @override
  int get hashCode {
    return FeatureAccessMapper.ensureInitialized().hashValue(
      this as FeatureAccess,
    );
  }
}

extension FeatureAccessValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FeatureAccess, $Out> {
  FeatureAccessCopyWith<$R, FeatureAccess, $Out> get $asFeatureAccess =>
      $base.as((v, t, t2) => _FeatureAccessCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FeatureAccessCopyWith<$R, $In extends FeatureAccess, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? featureKey,
    String? featureName,
    bool? isEnabled,
    int? limit,
    String? description,
  });
  FeatureAccessCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FeatureAccessCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FeatureAccess, $Out>
    implements FeatureAccessCopyWith<$R, FeatureAccess, $Out> {
  _FeatureAccessCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FeatureAccess> $mapper =
      FeatureAccessMapper.ensureInitialized();
  @override
  $R call({
    String? featureKey,
    String? featureName,
    bool? isEnabled,
    Object? limit = $none,
    Object? description = $none,
  }) => $apply(
    FieldCopyWithData({
      if (featureKey != null) #featureKey: featureKey,
      if (featureName != null) #featureName: featureName,
      if (isEnabled != null) #isEnabled: isEnabled,
      if (limit != $none) #limit: limit,
      if (description != $none) #description: description,
    }),
  );
  @override
  FeatureAccess $make(CopyWithData data) => FeatureAccess(
    featureKey: data.get(#featureKey, or: $value.featureKey),
    featureName: data.get(#featureName, or: $value.featureName),
    isEnabled: data.get(#isEnabled, or: $value.isEnabled),
    limit: data.get(#limit, or: $value.limit),
    description: data.get(#description, or: $value.description),
  );

  @override
  FeatureAccessCopyWith<$R2, FeatureAccess, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FeatureAccessCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FeatureUsageMapper extends ClassMapperBase<FeatureUsage> {
  FeatureUsageMapper._();

  static FeatureUsageMapper? _instance;
  static FeatureUsageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FeatureUsageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FeatureUsage';

  static String _$usageId(FeatureUsage v) => v.usageId;
  static const Field<FeatureUsage, String> _f$usageId = Field(
    'usageId',
    _$usageId,
  );
  static String _$userId(FeatureUsage v) => v.userId;
  static const Field<FeatureUsage, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static PremiumFeature _$feature(FeatureUsage v) => v.feature;
  static const Field<FeatureUsage, PremiumFeature> _f$feature = Field(
    'feature',
    _$feature,
  );
  static int _$usedCount(FeatureUsage v) => v.usedCount;
  static const Field<FeatureUsage, int> _f$usedCount = Field(
    'usedCount',
    _$usedCount,
    opt: true,
    def: 0,
  );
  static int? _$limit(FeatureUsage v) => v.limit;
  static const Field<FeatureUsage, int> _f$limit = Field(
    'limit',
    _$limit,
    opt: true,
  );
  static DateTime _$periodStart(FeatureUsage v) => v.periodStart;
  static const Field<FeatureUsage, DateTime> _f$periodStart = Field(
    'periodStart',
    _$periodStart,
  );
  static DateTime _$periodEnd(FeatureUsage v) => v.periodEnd;
  static const Field<FeatureUsage, DateTime> _f$periodEnd = Field(
    'periodEnd',
    _$periodEnd,
  );
  static DateTime _$lastUsedAt(FeatureUsage v) => v.lastUsedAt;
  static const Field<FeatureUsage, DateTime> _f$lastUsedAt = Field(
    'lastUsedAt',
    _$lastUsedAt,
  );
  static bool _$hasUsageAvailable(FeatureUsage v) => v.hasUsageAvailable;
  static const Field<FeatureUsage, bool> _f$hasUsageAvailable = Field(
    'hasUsageAvailable',
    _$hasUsageAvailable,
    mode: FieldMode.member,
  );
  static int _$remainingUsage(FeatureUsage v) => v.remainingUsage;
  static const Field<FeatureUsage, int> _f$remainingUsage = Field(
    'remainingUsage',
    _$remainingUsage,
    mode: FieldMode.member,
  );
  static double _$progress(FeatureUsage v) => v.progress;
  static const Field<FeatureUsage, double> _f$progress = Field(
    'progress',
    _$progress,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<FeatureUsage> fields = const {
    #usageId: _f$usageId,
    #userId: _f$userId,
    #feature: _f$feature,
    #usedCount: _f$usedCount,
    #limit: _f$limit,
    #periodStart: _f$periodStart,
    #periodEnd: _f$periodEnd,
    #lastUsedAt: _f$lastUsedAt,
    #hasUsageAvailable: _f$hasUsageAvailable,
    #remainingUsage: _f$remainingUsage,
    #progress: _f$progress,
  };

  static FeatureUsage _instantiate(DecodingData data) {
    return FeatureUsage(
      usageId: data.dec(_f$usageId),
      userId: data.dec(_f$userId),
      feature: data.dec(_f$feature),
      usedCount: data.dec(_f$usedCount),
      limit: data.dec(_f$limit),
      periodStart: data.dec(_f$periodStart),
      periodEnd: data.dec(_f$periodEnd),
      lastUsedAt: data.dec(_f$lastUsedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FeatureUsage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FeatureUsage>(map);
  }

  static FeatureUsage fromJson(String json) {
    return ensureInitialized().decodeJson<FeatureUsage>(json);
  }
}

mixin FeatureUsageMappable {
  String toJson() {
    return FeatureUsageMapper.ensureInitialized().encodeJson<FeatureUsage>(
      this as FeatureUsage,
    );
  }

  Map<String, dynamic> toMap() {
    return FeatureUsageMapper.ensureInitialized().encodeMap<FeatureUsage>(
      this as FeatureUsage,
    );
  }

  FeatureUsageCopyWith<FeatureUsage, FeatureUsage, FeatureUsage> get copyWith =>
      _FeatureUsageCopyWithImpl<FeatureUsage, FeatureUsage>(
        this as FeatureUsage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FeatureUsageMapper.ensureInitialized().stringifyValue(
      this as FeatureUsage,
    );
  }

  @override
  bool operator ==(Object other) {
    return FeatureUsageMapper.ensureInitialized().equalsValue(
      this as FeatureUsage,
      other,
    );
  }

  @override
  int get hashCode {
    return FeatureUsageMapper.ensureInitialized().hashValue(
      this as FeatureUsage,
    );
  }
}

extension FeatureUsageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FeatureUsage, $Out> {
  FeatureUsageCopyWith<$R, FeatureUsage, $Out> get $asFeatureUsage =>
      $base.as((v, t, t2) => _FeatureUsageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FeatureUsageCopyWith<$R, $In extends FeatureUsage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? usageId,
    String? userId,
    PremiumFeature? feature,
    int? usedCount,
    int? limit,
    DateTime? periodStart,
    DateTime? periodEnd,
    DateTime? lastUsedAt,
  });
  FeatureUsageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FeatureUsageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FeatureUsage, $Out>
    implements FeatureUsageCopyWith<$R, FeatureUsage, $Out> {
  _FeatureUsageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FeatureUsage> $mapper =
      FeatureUsageMapper.ensureInitialized();
  @override
  $R call({
    String? usageId,
    String? userId,
    PremiumFeature? feature,
    int? usedCount,
    Object? limit = $none,
    DateTime? periodStart,
    DateTime? periodEnd,
    DateTime? lastUsedAt,
  }) => $apply(
    FieldCopyWithData({
      if (usageId != null) #usageId: usageId,
      if (userId != null) #userId: userId,
      if (feature != null) #feature: feature,
      if (usedCount != null) #usedCount: usedCount,
      if (limit != $none) #limit: limit,
      if (periodStart != null) #periodStart: periodStart,
      if (periodEnd != null) #periodEnd: periodEnd,
      if (lastUsedAt != null) #lastUsedAt: lastUsedAt,
    }),
  );
  @override
  FeatureUsage $make(CopyWithData data) => FeatureUsage(
    usageId: data.get(#usageId, or: $value.usageId),
    userId: data.get(#userId, or: $value.userId),
    feature: data.get(#feature, or: $value.feature),
    usedCount: data.get(#usedCount, or: $value.usedCount),
    limit: data.get(#limit, or: $value.limit),
    periodStart: data.get(#periodStart, or: $value.periodStart),
    periodEnd: data.get(#periodEnd, or: $value.periodEnd),
    lastUsedAt: data.get(#lastUsedAt, or: $value.lastUsedAt),
  );

  @override
  FeatureUsageCopyWith<$R2, FeatureUsage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FeatureUsageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SubscriptionPlanMapper extends ClassMapperBase<SubscriptionPlan> {
  SubscriptionPlanMapper._();

  static SubscriptionPlanMapper? _instance;
  static SubscriptionPlanMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubscriptionPlanMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubscriptionPlan';

  static String _$planId(SubscriptionPlan v) => v.planId;
  static const Field<SubscriptionPlan, String> _f$planId = Field(
    'planId',
    _$planId,
  );
  static SubscriptionTier _$tier(SubscriptionPlan v) => v.tier;
  static const Field<SubscriptionPlan, SubscriptionTier> _f$tier = Field(
    'tier',
    _$tier,
  );
  static BillingPeriod _$billingPeriod(SubscriptionPlan v) => v.billingPeriod;
  static const Field<SubscriptionPlan, BillingPeriod> _f$billingPeriod = Field(
    'billingPeriod',
    _$billingPeriod,
  );
  static double _$price(SubscriptionPlan v) => v.price;
  static const Field<SubscriptionPlan, double> _f$price = Field(
    'price',
    _$price,
  );
  static String _$currency(SubscriptionPlan v) => v.currency;
  static const Field<SubscriptionPlan, String> _f$currency = Field(
    'currency',
    _$currency,
    opt: true,
    def: 'BRL',
  );
  static String? _$productId(SubscriptionPlan v) => v.productId;
  static const Field<SubscriptionPlan, String> _f$productId = Field(
    'productId',
    _$productId,
    opt: true,
  );
  static bool _$isActive(SubscriptionPlan v) => v.isActive;
  static const Field<SubscriptionPlan, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    opt: true,
    def: true,
  );
  static DateTime _$createdAt(SubscriptionPlan v) => v.createdAt;
  static const Field<SubscriptionPlan, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static double _$monthlyEquivalentPrice(SubscriptionPlan v) =>
      v.monthlyEquivalentPrice;
  static const Field<SubscriptionPlan, double> _f$monthlyEquivalentPrice =
      Field(
        'monthlyEquivalentPrice',
        _$monthlyEquivalentPrice,
        mode: FieldMode.member,
      );

  @override
  final MappableFields<SubscriptionPlan> fields = const {
    #planId: _f$planId,
    #tier: _f$tier,
    #billingPeriod: _f$billingPeriod,
    #price: _f$price,
    #currency: _f$currency,
    #productId: _f$productId,
    #isActive: _f$isActive,
    #createdAt: _f$createdAt,
    #monthlyEquivalentPrice: _f$monthlyEquivalentPrice,
  };

  static SubscriptionPlan _instantiate(DecodingData data) {
    return SubscriptionPlan(
      planId: data.dec(_f$planId),
      tier: data.dec(_f$tier),
      billingPeriod: data.dec(_f$billingPeriod),
      price: data.dec(_f$price),
      currency: data.dec(_f$currency),
      productId: data.dec(_f$productId),
      isActive: data.dec(_f$isActive),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubscriptionPlan fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubscriptionPlan>(map);
  }

  static SubscriptionPlan fromJson(String json) {
    return ensureInitialized().decodeJson<SubscriptionPlan>(json);
  }
}

mixin SubscriptionPlanMappable {
  String toJson() {
    return SubscriptionPlanMapper.ensureInitialized()
        .encodeJson<SubscriptionPlan>(this as SubscriptionPlan);
  }

  Map<String, dynamic> toMap() {
    return SubscriptionPlanMapper.ensureInitialized()
        .encodeMap<SubscriptionPlan>(this as SubscriptionPlan);
  }

  SubscriptionPlanCopyWith<SubscriptionPlan, SubscriptionPlan, SubscriptionPlan>
  get copyWith =>
      _SubscriptionPlanCopyWithImpl<SubscriptionPlan, SubscriptionPlan>(
        this as SubscriptionPlan,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SubscriptionPlanMapper.ensureInitialized().stringifyValue(
      this as SubscriptionPlan,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubscriptionPlanMapper.ensureInitialized().equalsValue(
      this as SubscriptionPlan,
      other,
    );
  }

  @override
  int get hashCode {
    return SubscriptionPlanMapper.ensureInitialized().hashValue(
      this as SubscriptionPlan,
    );
  }
}

extension SubscriptionPlanValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubscriptionPlan, $Out> {
  SubscriptionPlanCopyWith<$R, SubscriptionPlan, $Out>
  get $asSubscriptionPlan =>
      $base.as((v, t, t2) => _SubscriptionPlanCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SubscriptionPlanCopyWith<$R, $In extends SubscriptionPlan, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? planId,
    SubscriptionTier? tier,
    BillingPeriod? billingPeriod,
    double? price,
    String? currency,
    String? productId,
    bool? isActive,
    DateTime? createdAt,
  });
  SubscriptionPlanCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubscriptionPlanCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubscriptionPlan, $Out>
    implements SubscriptionPlanCopyWith<$R, SubscriptionPlan, $Out> {
  _SubscriptionPlanCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubscriptionPlan> $mapper =
      SubscriptionPlanMapper.ensureInitialized();
  @override
  $R call({
    String? planId,
    SubscriptionTier? tier,
    BillingPeriod? billingPeriod,
    double? price,
    String? currency,
    Object? productId = $none,
    bool? isActive,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (planId != null) #planId: planId,
      if (tier != null) #tier: tier,
      if (billingPeriod != null) #billingPeriod: billingPeriod,
      if (price != null) #price: price,
      if (currency != null) #currency: currency,
      if (productId != $none) #productId: productId,
      if (isActive != null) #isActive: isActive,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  SubscriptionPlan $make(CopyWithData data) => SubscriptionPlan(
    planId: data.get(#planId, or: $value.planId),
    tier: data.get(#tier, or: $value.tier),
    billingPeriod: data.get(#billingPeriod, or: $value.billingPeriod),
    price: data.get(#price, or: $value.price),
    currency: data.get(#currency, or: $value.currency),
    productId: data.get(#productId, or: $value.productId),
    isActive: data.get(#isActive, or: $value.isActive),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  SubscriptionPlanCopyWith<$R2, SubscriptionPlan, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SubscriptionPlanCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SubscriptionHistoryMapper extends ClassMapperBase<SubscriptionHistory> {
  SubscriptionHistoryMapper._();

  static SubscriptionHistoryMapper? _instance;
  static SubscriptionHistoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubscriptionHistoryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubscriptionHistory';

  static String _$historyId(SubscriptionHistory v) => v.historyId;
  static const Field<SubscriptionHistory, String> _f$historyId = Field(
    'historyId',
    _$historyId,
  );
  static String _$userId(SubscriptionHistory v) => v.userId;
  static const Field<SubscriptionHistory, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static SubscriptionEvent _$event(SubscriptionHistory v) => v.event;
  static const Field<SubscriptionHistory, SubscriptionEvent> _f$event = Field(
    'event',
    _$event,
  );
  static SubscriptionTier? _$fromTier(SubscriptionHistory v) => v.fromTier;
  static const Field<SubscriptionHistory, SubscriptionTier> _f$fromTier = Field(
    'fromTier',
    _$fromTier,
    opt: true,
  );
  static SubscriptionTier? _$toTier(SubscriptionHistory v) => v.toTier;
  static const Field<SubscriptionHistory, SubscriptionTier> _f$toTier = Field(
    'toTier',
    _$toTier,
    opt: true,
  );
  static String? _$notes(SubscriptionHistory v) => v.notes;
  static const Field<SubscriptionHistory, String> _f$notes = Field(
    'notes',
    _$notes,
    opt: true,
  );
  static DateTime _$createdAt(SubscriptionHistory v) => v.createdAt;
  static const Field<SubscriptionHistory, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<SubscriptionHistory> fields = const {
    #historyId: _f$historyId,
    #userId: _f$userId,
    #event: _f$event,
    #fromTier: _f$fromTier,
    #toTier: _f$toTier,
    #notes: _f$notes,
    #createdAt: _f$createdAt,
  };

  static SubscriptionHistory _instantiate(DecodingData data) {
    return SubscriptionHistory(
      historyId: data.dec(_f$historyId),
      userId: data.dec(_f$userId),
      event: data.dec(_f$event),
      fromTier: data.dec(_f$fromTier),
      toTier: data.dec(_f$toTier),
      notes: data.dec(_f$notes),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubscriptionHistory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubscriptionHistory>(map);
  }

  static SubscriptionHistory fromJson(String json) {
    return ensureInitialized().decodeJson<SubscriptionHistory>(json);
  }
}

mixin SubscriptionHistoryMappable {
  String toJson() {
    return SubscriptionHistoryMapper.ensureInitialized()
        .encodeJson<SubscriptionHistory>(this as SubscriptionHistory);
  }

  Map<String, dynamic> toMap() {
    return SubscriptionHistoryMapper.ensureInitialized()
        .encodeMap<SubscriptionHistory>(this as SubscriptionHistory);
  }

  SubscriptionHistoryCopyWith<
    SubscriptionHistory,
    SubscriptionHistory,
    SubscriptionHistory
  >
  get copyWith =>
      _SubscriptionHistoryCopyWithImpl<
        SubscriptionHistory,
        SubscriptionHistory
      >(this as SubscriptionHistory, $identity, $identity);
  @override
  String toString() {
    return SubscriptionHistoryMapper.ensureInitialized().stringifyValue(
      this as SubscriptionHistory,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubscriptionHistoryMapper.ensureInitialized().equalsValue(
      this as SubscriptionHistory,
      other,
    );
  }

  @override
  int get hashCode {
    return SubscriptionHistoryMapper.ensureInitialized().hashValue(
      this as SubscriptionHistory,
    );
  }
}

extension SubscriptionHistoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubscriptionHistory, $Out> {
  SubscriptionHistoryCopyWith<$R, SubscriptionHistory, $Out>
  get $asSubscriptionHistory => $base.as(
    (v, t, t2) => _SubscriptionHistoryCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SubscriptionHistoryCopyWith<
  $R,
  $In extends SubscriptionHistory,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? historyId,
    String? userId,
    SubscriptionEvent? event,
    SubscriptionTier? fromTier,
    SubscriptionTier? toTier,
    String? notes,
    DateTime? createdAt,
  });
  SubscriptionHistoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubscriptionHistoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubscriptionHistory, $Out>
    implements SubscriptionHistoryCopyWith<$R, SubscriptionHistory, $Out> {
  _SubscriptionHistoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubscriptionHistory> $mapper =
      SubscriptionHistoryMapper.ensureInitialized();
  @override
  $R call({
    String? historyId,
    String? userId,
    SubscriptionEvent? event,
    Object? fromTier = $none,
    Object? toTier = $none,
    Object? notes = $none,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (historyId != null) #historyId: historyId,
      if (userId != null) #userId: userId,
      if (event != null) #event: event,
      if (fromTier != $none) #fromTier: fromTier,
      if (toTier != $none) #toTier: toTier,
      if (notes != $none) #notes: notes,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  SubscriptionHistory $make(CopyWithData data) => SubscriptionHistory(
    historyId: data.get(#historyId, or: $value.historyId),
    userId: data.get(#userId, or: $value.userId),
    event: data.get(#event, or: $value.event),
    fromTier: data.get(#fromTier, or: $value.fromTier),
    toTier: data.get(#toTier, or: $value.toTier),
    notes: data.get(#notes, or: $value.notes),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  SubscriptionHistoryCopyWith<$R2, SubscriptionHistory, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SubscriptionHistoryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SubscriptionOfferMapper extends ClassMapperBase<SubscriptionOffer> {
  SubscriptionOfferMapper._();

  static SubscriptionOfferMapper? _instance;
  static SubscriptionOfferMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubscriptionOfferMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubscriptionOffer';

  static String _$offerId(SubscriptionOffer v) => v.offerId;
  static const Field<SubscriptionOffer, String> _f$offerId = Field(
    'offerId',
    _$offerId,
  );
  static String _$title(SubscriptionOffer v) => v.title;
  static const Field<SubscriptionOffer, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$description(SubscriptionOffer v) => v.description;
  static const Field<SubscriptionOffer, String> _f$description = Field(
    'description',
    _$description,
  );
  static SubscriptionTier _$tier(SubscriptionOffer v) => v.tier;
  static const Field<SubscriptionOffer, SubscriptionTier> _f$tier = Field(
    'tier',
    _$tier,
  );
  static double _$discountPercent(SubscriptionOffer v) => v.discountPercent;
  static const Field<SubscriptionOffer, double> _f$discountPercent = Field(
    'discountPercent',
    _$discountPercent,
    opt: true,
    def: 0,
  );
  static double? _$discountAmount(SubscriptionOffer v) => v.discountAmount;
  static const Field<SubscriptionOffer, double> _f$discountAmount = Field(
    'discountAmount',
    _$discountAmount,
    opt: true,
  );
  static DateTime _$validFrom(SubscriptionOffer v) => v.validFrom;
  static const Field<SubscriptionOffer, DateTime> _f$validFrom = Field(
    'validFrom',
    _$validFrom,
  );
  static DateTime _$validUntil(SubscriptionOffer v) => v.validUntil;
  static const Field<SubscriptionOffer, DateTime> _f$validUntil = Field(
    'validUntil',
    _$validUntil,
  );
  static List<String> _$eligibleUserIds(SubscriptionOffer v) =>
      v.eligibleUserIds;
  static const Field<SubscriptionOffer, List<String>> _f$eligibleUserIds =
      Field('eligibleUserIds', _$eligibleUserIds, opt: true, def: const []);
  static int? _$maxRedemptions(SubscriptionOffer v) => v.maxRedemptions;
  static const Field<SubscriptionOffer, int> _f$maxRedemptions = Field(
    'maxRedemptions',
    _$maxRedemptions,
    opt: true,
  );
  static int _$currentRedemptions(SubscriptionOffer v) => v.currentRedemptions;
  static const Field<SubscriptionOffer, int> _f$currentRedemptions = Field(
    'currentRedemptions',
    _$currentRedemptions,
    opt: true,
    def: 0,
  );
  static bool _$isActive(SubscriptionOffer v) => v.isActive;
  static const Field<SubscriptionOffer, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    opt: true,
    def: true,
  );
  static bool _$isValid(SubscriptionOffer v) => v.isValid;
  static const Field<SubscriptionOffer, bool> _f$isValid = Field(
    'isValid',
    _$isValid,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<SubscriptionOffer> fields = const {
    #offerId: _f$offerId,
    #title: _f$title,
    #description: _f$description,
    #tier: _f$tier,
    #discountPercent: _f$discountPercent,
    #discountAmount: _f$discountAmount,
    #validFrom: _f$validFrom,
    #validUntil: _f$validUntil,
    #eligibleUserIds: _f$eligibleUserIds,
    #maxRedemptions: _f$maxRedemptions,
    #currentRedemptions: _f$currentRedemptions,
    #isActive: _f$isActive,
    #isValid: _f$isValid,
  };

  static SubscriptionOffer _instantiate(DecodingData data) {
    return SubscriptionOffer(
      offerId: data.dec(_f$offerId),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      tier: data.dec(_f$tier),
      discountPercent: data.dec(_f$discountPercent),
      discountAmount: data.dec(_f$discountAmount),
      validFrom: data.dec(_f$validFrom),
      validUntil: data.dec(_f$validUntil),
      eligibleUserIds: data.dec(_f$eligibleUserIds),
      maxRedemptions: data.dec(_f$maxRedemptions),
      currentRedemptions: data.dec(_f$currentRedemptions),
      isActive: data.dec(_f$isActive),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubscriptionOffer fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubscriptionOffer>(map);
  }

  static SubscriptionOffer fromJson(String json) {
    return ensureInitialized().decodeJson<SubscriptionOffer>(json);
  }
}

mixin SubscriptionOfferMappable {
  String toJson() {
    return SubscriptionOfferMapper.ensureInitialized()
        .encodeJson<SubscriptionOffer>(this as SubscriptionOffer);
  }

  Map<String, dynamic> toMap() {
    return SubscriptionOfferMapper.ensureInitialized()
        .encodeMap<SubscriptionOffer>(this as SubscriptionOffer);
  }

  SubscriptionOfferCopyWith<
    SubscriptionOffer,
    SubscriptionOffer,
    SubscriptionOffer
  >
  get copyWith =>
      _SubscriptionOfferCopyWithImpl<SubscriptionOffer, SubscriptionOffer>(
        this as SubscriptionOffer,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SubscriptionOfferMapper.ensureInitialized().stringifyValue(
      this as SubscriptionOffer,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubscriptionOfferMapper.ensureInitialized().equalsValue(
      this as SubscriptionOffer,
      other,
    );
  }

  @override
  int get hashCode {
    return SubscriptionOfferMapper.ensureInitialized().hashValue(
      this as SubscriptionOffer,
    );
  }
}

extension SubscriptionOfferValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubscriptionOffer, $Out> {
  SubscriptionOfferCopyWith<$R, SubscriptionOffer, $Out>
  get $asSubscriptionOffer => $base.as(
    (v, t, t2) => _SubscriptionOfferCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SubscriptionOfferCopyWith<
  $R,
  $In extends SubscriptionOffer,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get eligibleUserIds;
  $R call({
    String? offerId,
    String? title,
    String? description,
    SubscriptionTier? tier,
    double? discountPercent,
    double? discountAmount,
    DateTime? validFrom,
    DateTime? validUntil,
    List<String>? eligibleUserIds,
    int? maxRedemptions,
    int? currentRedemptions,
    bool? isActive,
  });
  SubscriptionOfferCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubscriptionOfferCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubscriptionOffer, $Out>
    implements SubscriptionOfferCopyWith<$R, SubscriptionOffer, $Out> {
  _SubscriptionOfferCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubscriptionOffer> $mapper =
      SubscriptionOfferMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get eligibleUserIds => ListCopyWith(
    $value.eligibleUserIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(eligibleUserIds: v),
  );
  @override
  $R call({
    String? offerId,
    String? title,
    String? description,
    SubscriptionTier? tier,
    double? discountPercent,
    Object? discountAmount = $none,
    DateTime? validFrom,
    DateTime? validUntil,
    List<String>? eligibleUserIds,
    Object? maxRedemptions = $none,
    int? currentRedemptions,
    bool? isActive,
  }) => $apply(
    FieldCopyWithData({
      if (offerId != null) #offerId: offerId,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (tier != null) #tier: tier,
      if (discountPercent != null) #discountPercent: discountPercent,
      if (discountAmount != $none) #discountAmount: discountAmount,
      if (validFrom != null) #validFrom: validFrom,
      if (validUntil != null) #validUntil: validUntil,
      if (eligibleUserIds != null) #eligibleUserIds: eligibleUserIds,
      if (maxRedemptions != $none) #maxRedemptions: maxRedemptions,
      if (currentRedemptions != null) #currentRedemptions: currentRedemptions,
      if (isActive != null) #isActive: isActive,
    }),
  );
  @override
  SubscriptionOffer $make(CopyWithData data) => SubscriptionOffer(
    offerId: data.get(#offerId, or: $value.offerId),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    tier: data.get(#tier, or: $value.tier),
    discountPercent: data.get(#discountPercent, or: $value.discountPercent),
    discountAmount: data.get(#discountAmount, or: $value.discountAmount),
    validFrom: data.get(#validFrom, or: $value.validFrom),
    validUntil: data.get(#validUntil, or: $value.validUntil),
    eligibleUserIds: data.get(#eligibleUserIds, or: $value.eligibleUserIds),
    maxRedemptions: data.get(#maxRedemptions, or: $value.maxRedemptions),
    currentRedemptions: data.get(
      #currentRedemptions,
      or: $value.currentRedemptions,
    ),
    isActive: data.get(#isActive, or: $value.isActive),
  );

  @override
  SubscriptionOfferCopyWith<$R2, SubscriptionOffer, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SubscriptionOfferCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TierComparisonMapper extends ClassMapperBase<TierComparison> {
  TierComparisonMapper._();

  static TierComparisonMapper? _instance;
  static TierComparisonMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TierComparisonMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TierComparison';

  static SubscriptionTier _$tier(TierComparison v) => v.tier;
  static const Field<TierComparison, SubscriptionTier> _f$tier = Field(
    'tier',
    _$tier,
  );
  static Map<String, bool> _$features(TierComparison v) => v.features;
  static const Field<TierComparison, Map<String, bool>> _f$features = Field(
    'features',
    _$features,
  );
  static List<String> _$pros(TierComparison v) => v.pros;
  static const Field<TierComparison, List<String>> _f$pros = Field(
    'pros',
    _$pros,
  );
  static List<String> _$cons(TierComparison v) => v.cons;
  static const Field<TierComparison, List<String>> _f$cons = Field(
    'cons',
    _$cons,
  );

  @override
  final MappableFields<TierComparison> fields = const {
    #tier: _f$tier,
    #features: _f$features,
    #pros: _f$pros,
    #cons: _f$cons,
  };

  static TierComparison _instantiate(DecodingData data) {
    return TierComparison(
      tier: data.dec(_f$tier),
      features: data.dec(_f$features),
      pros: data.dec(_f$pros),
      cons: data.dec(_f$cons),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TierComparison fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TierComparison>(map);
  }

  static TierComparison fromJson(String json) {
    return ensureInitialized().decodeJson<TierComparison>(json);
  }
}

mixin TierComparisonMappable {
  String toJson() {
    return TierComparisonMapper.ensureInitialized().encodeJson<TierComparison>(
      this as TierComparison,
    );
  }

  Map<String, dynamic> toMap() {
    return TierComparisonMapper.ensureInitialized().encodeMap<TierComparison>(
      this as TierComparison,
    );
  }

  TierComparisonCopyWith<TierComparison, TierComparison, TierComparison>
  get copyWith => _TierComparisonCopyWithImpl<TierComparison, TierComparison>(
    this as TierComparison,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return TierComparisonMapper.ensureInitialized().stringifyValue(
      this as TierComparison,
    );
  }

  @override
  bool operator ==(Object other) {
    return TierComparisonMapper.ensureInitialized().equalsValue(
      this as TierComparison,
      other,
    );
  }

  @override
  int get hashCode {
    return TierComparisonMapper.ensureInitialized().hashValue(
      this as TierComparison,
    );
  }
}

extension TierComparisonValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TierComparison, $Out> {
  TierComparisonCopyWith<$R, TierComparison, $Out> get $asTierComparison =>
      $base.as((v, t, t2) => _TierComparisonCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TierComparisonCopyWith<$R, $In extends TierComparison, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, bool, ObjectCopyWith<$R, bool, bool>> get features;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get pros;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get cons;
  $R call({
    SubscriptionTier? tier,
    Map<String, bool>? features,
    List<String>? pros,
    List<String>? cons,
  });
  TierComparisonCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TierComparisonCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TierComparison, $Out>
    implements TierComparisonCopyWith<$R, TierComparison, $Out> {
  _TierComparisonCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TierComparison> $mapper =
      TierComparisonMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, bool, ObjectCopyWith<$R, bool, bool>> get features =>
      MapCopyWith(
        $value.features,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(features: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get pros =>
      ListCopyWith(
        $value.pros,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(pros: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get cons =>
      ListCopyWith(
        $value.cons,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(cons: v),
      );
  @override
  $R call({
    SubscriptionTier? tier,
    Map<String, bool>? features,
    List<String>? pros,
    List<String>? cons,
  }) => $apply(
    FieldCopyWithData({
      if (tier != null) #tier: tier,
      if (features != null) #features: features,
      if (pros != null) #pros: pros,
      if (cons != null) #cons: cons,
    }),
  );
  @override
  TierComparison $make(CopyWithData data) => TierComparison(
    tier: data.get(#tier, or: $value.tier),
    features: data.get(#features, or: $value.features),
    pros: data.get(#pros, or: $value.pros),
    cons: data.get(#cons, or: $value.cons),
  );

  @override
  TierComparisonCopyWith<$R2, TierComparison, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TierComparisonCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SubscriptionStatsMapper extends ClassMapperBase<SubscriptionStats> {
  SubscriptionStatsMapper._();

  static SubscriptionStatsMapper? _instance;
  static SubscriptionStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubscriptionStatsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubscriptionStats';

  static int _$totalSubscribers(SubscriptionStats v) => v.totalSubscribers;
  static const Field<SubscriptionStats, int> _f$totalSubscribers = Field(
    'totalSubscribers',
    _$totalSubscribers,
  );
  static int _$activeSubscribers(SubscriptionStats v) => v.activeSubscribers;
  static const Field<SubscriptionStats, int> _f$activeSubscribers = Field(
    'activeSubscribers',
    _$activeSubscribers,
  );
  static int _$trialUsers(SubscriptionStats v) => v.trialUsers;
  static const Field<SubscriptionStats, int> _f$trialUsers = Field(
    'trialUsers',
    _$trialUsers,
  );
  static Map<SubscriptionTier, int> _$tierDistribution(SubscriptionStats v) =>
      v.tierDistribution;
  static const Field<SubscriptionStats, Map<SubscriptionTier, int>>
  _f$tierDistribution = Field('tierDistribution', _$tierDistribution);
  static double _$averageLifetime(SubscriptionStats v) => v.averageLifetime;
  static const Field<SubscriptionStats, double> _f$averageLifetime = Field(
    'averageLifetime',
    _$averageLifetime,
  );
  static double _$churnRate(SubscriptionStats v) => v.churnRate;
  static const Field<SubscriptionStats, double> _f$churnRate = Field(
    'churnRate',
    _$churnRate,
  );
  static double _$mrr(SubscriptionStats v) => v.mrr;
  static const Field<SubscriptionStats, double> _f$mrr = Field('mrr', _$mrr);
  static double _$arr(SubscriptionStats v) => v.arr;
  static const Field<SubscriptionStats, double> _f$arr = Field('arr', _$arr);
  static DateTime _$generatedAt(SubscriptionStats v) => v.generatedAt;
  static const Field<SubscriptionStats, DateTime> _f$generatedAt = Field(
    'generatedAt',
    _$generatedAt,
  );

  @override
  final MappableFields<SubscriptionStats> fields = const {
    #totalSubscribers: _f$totalSubscribers,
    #activeSubscribers: _f$activeSubscribers,
    #trialUsers: _f$trialUsers,
    #tierDistribution: _f$tierDistribution,
    #averageLifetime: _f$averageLifetime,
    #churnRate: _f$churnRate,
    #mrr: _f$mrr,
    #arr: _f$arr,
    #generatedAt: _f$generatedAt,
  };

  static SubscriptionStats _instantiate(DecodingData data) {
    return SubscriptionStats(
      totalSubscribers: data.dec(_f$totalSubscribers),
      activeSubscribers: data.dec(_f$activeSubscribers),
      trialUsers: data.dec(_f$trialUsers),
      tierDistribution: data.dec(_f$tierDistribution),
      averageLifetime: data.dec(_f$averageLifetime),
      churnRate: data.dec(_f$churnRate),
      mrr: data.dec(_f$mrr),
      arr: data.dec(_f$arr),
      generatedAt: data.dec(_f$generatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubscriptionStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubscriptionStats>(map);
  }

  static SubscriptionStats fromJson(String json) {
    return ensureInitialized().decodeJson<SubscriptionStats>(json);
  }
}

mixin SubscriptionStatsMappable {
  String toJson() {
    return SubscriptionStatsMapper.ensureInitialized()
        .encodeJson<SubscriptionStats>(this as SubscriptionStats);
  }

  Map<String, dynamic> toMap() {
    return SubscriptionStatsMapper.ensureInitialized()
        .encodeMap<SubscriptionStats>(this as SubscriptionStats);
  }

  SubscriptionStatsCopyWith<
    SubscriptionStats,
    SubscriptionStats,
    SubscriptionStats
  >
  get copyWith =>
      _SubscriptionStatsCopyWithImpl<SubscriptionStats, SubscriptionStats>(
        this as SubscriptionStats,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SubscriptionStatsMapper.ensureInitialized().stringifyValue(
      this as SubscriptionStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubscriptionStatsMapper.ensureInitialized().equalsValue(
      this as SubscriptionStats,
      other,
    );
  }

  @override
  int get hashCode {
    return SubscriptionStatsMapper.ensureInitialized().hashValue(
      this as SubscriptionStats,
    );
  }
}

extension SubscriptionStatsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubscriptionStats, $Out> {
  SubscriptionStatsCopyWith<$R, SubscriptionStats, $Out>
  get $asSubscriptionStats => $base.as(
    (v, t, t2) => _SubscriptionStatsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SubscriptionStatsCopyWith<
  $R,
  $In extends SubscriptionStats,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, SubscriptionTier, int, ObjectCopyWith<$R, int, int>>
  get tierDistribution;
  $R call({
    int? totalSubscribers,
    int? activeSubscribers,
    int? trialUsers,
    Map<SubscriptionTier, int>? tierDistribution,
    double? averageLifetime,
    double? churnRate,
    double? mrr,
    double? arr,
    DateTime? generatedAt,
  });
  SubscriptionStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubscriptionStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubscriptionStats, $Out>
    implements SubscriptionStatsCopyWith<$R, SubscriptionStats, $Out> {
  _SubscriptionStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubscriptionStats> $mapper =
      SubscriptionStatsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, SubscriptionTier, int, ObjectCopyWith<$R, int, int>>
  get tierDistribution => MapCopyWith(
    $value.tierDistribution,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(tierDistribution: v),
  );
  @override
  $R call({
    int? totalSubscribers,
    int? activeSubscribers,
    int? trialUsers,
    Map<SubscriptionTier, int>? tierDistribution,
    double? averageLifetime,
    double? churnRate,
    double? mrr,
    double? arr,
    DateTime? generatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (totalSubscribers != null) #totalSubscribers: totalSubscribers,
      if (activeSubscribers != null) #activeSubscribers: activeSubscribers,
      if (trialUsers != null) #trialUsers: trialUsers,
      if (tierDistribution != null) #tierDistribution: tierDistribution,
      if (averageLifetime != null) #averageLifetime: averageLifetime,
      if (churnRate != null) #churnRate: churnRate,
      if (mrr != null) #mrr: mrr,
      if (arr != null) #arr: arr,
      if (generatedAt != null) #generatedAt: generatedAt,
    }),
  );
  @override
  SubscriptionStats $make(CopyWithData data) => SubscriptionStats(
    totalSubscribers: data.get(#totalSubscribers, or: $value.totalSubscribers),
    activeSubscribers: data.get(
      #activeSubscribers,
      or: $value.activeSubscribers,
    ),
    trialUsers: data.get(#trialUsers, or: $value.trialUsers),
    tierDistribution: data.get(#tierDistribution, or: $value.tierDistribution),
    averageLifetime: data.get(#averageLifetime, or: $value.averageLifetime),
    churnRate: data.get(#churnRate, or: $value.churnRate),
    mrr: data.get(#mrr, or: $value.mrr),
    arr: data.get(#arr, or: $value.arr),
    generatedAt: data.get(#generatedAt, or: $value.generatedAt),
  );

  @override
  SubscriptionStatsCopyWith<$R2, SubscriptionStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SubscriptionStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChangeTierRequestMapper extends ClassMapperBase<ChangeTierRequest> {
  ChangeTierRequestMapper._();

  static ChangeTierRequestMapper? _instance;
  static ChangeTierRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChangeTierRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChangeTierRequest';

  static String _$userId(ChangeTierRequest v) => v.userId;
  static const Field<ChangeTierRequest, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static SubscriptionTier _$targetTier(ChangeTierRequest v) => v.targetTier;
  static const Field<ChangeTierRequest, SubscriptionTier> _f$targetTier = Field(
    'targetTier',
    _$targetTier,
  );
  static BillingPeriod _$billingPeriod(ChangeTierRequest v) => v.billingPeriod;
  static const Field<ChangeTierRequest, BillingPeriod> _f$billingPeriod = Field(
    'billingPeriod',
    _$billingPeriod,
  );
  static String? _$offerCode(ChangeTierRequest v) => v.offerCode;
  static const Field<ChangeTierRequest, String> _f$offerCode = Field(
    'offerCode',
    _$offerCode,
    opt: true,
  );

  @override
  final MappableFields<ChangeTierRequest> fields = const {
    #userId: _f$userId,
    #targetTier: _f$targetTier,
    #billingPeriod: _f$billingPeriod,
    #offerCode: _f$offerCode,
  };

  static ChangeTierRequest _instantiate(DecodingData data) {
    return ChangeTierRequest(
      userId: data.dec(_f$userId),
      targetTier: data.dec(_f$targetTier),
      billingPeriod: data.dec(_f$billingPeriod),
      offerCode: data.dec(_f$offerCode),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChangeTierRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChangeTierRequest>(map);
  }

  static ChangeTierRequest fromJson(String json) {
    return ensureInitialized().decodeJson<ChangeTierRequest>(json);
  }
}

mixin ChangeTierRequestMappable {
  String toJson() {
    return ChangeTierRequestMapper.ensureInitialized()
        .encodeJson<ChangeTierRequest>(this as ChangeTierRequest);
  }

  Map<String, dynamic> toMap() {
    return ChangeTierRequestMapper.ensureInitialized()
        .encodeMap<ChangeTierRequest>(this as ChangeTierRequest);
  }

  ChangeTierRequestCopyWith<
    ChangeTierRequest,
    ChangeTierRequest,
    ChangeTierRequest
  >
  get copyWith =>
      _ChangeTierRequestCopyWithImpl<ChangeTierRequest, ChangeTierRequest>(
        this as ChangeTierRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChangeTierRequestMapper.ensureInitialized().stringifyValue(
      this as ChangeTierRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChangeTierRequestMapper.ensureInitialized().equalsValue(
      this as ChangeTierRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return ChangeTierRequestMapper.ensureInitialized().hashValue(
      this as ChangeTierRequest,
    );
  }
}

extension ChangeTierRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChangeTierRequest, $Out> {
  ChangeTierRequestCopyWith<$R, ChangeTierRequest, $Out>
  get $asChangeTierRequest => $base.as(
    (v, t, t2) => _ChangeTierRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ChangeTierRequestCopyWith<
  $R,
  $In extends ChangeTierRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    SubscriptionTier? targetTier,
    BillingPeriod? billingPeriod,
    String? offerCode,
  });
  ChangeTierRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChangeTierRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChangeTierRequest, $Out>
    implements ChangeTierRequestCopyWith<$R, ChangeTierRequest, $Out> {
  _ChangeTierRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChangeTierRequest> $mapper =
      ChangeTierRequestMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    SubscriptionTier? targetTier,
    BillingPeriod? billingPeriod,
    Object? offerCode = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (targetTier != null) #targetTier: targetTier,
      if (billingPeriod != null) #billingPeriod: billingPeriod,
      if (offerCode != $none) #offerCode: offerCode,
    }),
  );
  @override
  ChangeTierRequest $make(CopyWithData data) => ChangeTierRequest(
    userId: data.get(#userId, or: $value.userId),
    targetTier: data.get(#targetTier, or: $value.targetTier),
    billingPeriod: data.get(#billingPeriod, or: $value.billingPeriod),
    offerCode: data.get(#offerCode, or: $value.offerCode),
  );

  @override
  ChangeTierRequestCopyWith<$R2, ChangeTierRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChangeTierRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

