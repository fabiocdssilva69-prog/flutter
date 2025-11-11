// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'profile_entity.dart';

class ProfileEntityMapper extends ClassMapperBase<ProfileEntity> {
  ProfileEntityMapper._();

  static ProfileEntityMapper? _instance;
  static ProfileEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileEntityMapper._());
      AccountTypeMapper.ensureInitialized();
      PromptResponseMapper.ensureInitialized();
      MediaContentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ProfileEntity';

  static String _$userId(ProfileEntity v) => v.userId;
  static const Field<ProfileEntity, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static AccountType _$accountType(ProfileEntity v) => v.accountType;
  static const Field<ProfileEntity, AccountType> _f$accountType = Field(
    'accountType',
    _$accountType,
  );
  static String _$name(ProfileEntity v) => v.name;
  static const Field<ProfileEntity, String> _f$name = Field('name', _$name);
  static String _$email(ProfileEntity v) => v.email;
  static const Field<ProfileEntity, String> _f$email = Field('email', _$email);
  static DateTime _$createdAt(ProfileEntity v) => v.createdAt;
  static const Field<ProfileEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );
  static String _$bio(ProfileEntity v) => v.bio;
  static const Field<ProfileEntity, String> _f$bio = Field(
    'bio',
    _$bio,
    opt: true,
    def: '',
  );
  static String _$location(ProfileEntity v) => v.location;
  static const Field<ProfileEntity, String> _f$location = Field(
    'location',
    _$location,
    opt: true,
    def: '',
  );
  static String _$contactPhone(ProfileEntity v) => v.contactPhone;
  static const Field<ProfileEntity, String> _f$contactPhone = Field(
    'contactPhone',
    _$contactPhone,
    opt: true,
    def: '',
  );
  static String? _$fcmToken(ProfileEntity v) => v.fcmToken;
  static const Field<ProfileEntity, String> _f$fcmToken = Field(
    'fcmToken',
    _$fcmToken,
    opt: true,
  );
  static DateTime? _$updatedAt(ProfileEntity v) => v.updatedAt;
  static const Field<ProfileEntity, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
    hook: TimestampHook(),
  );
  static String? _$avatarUrl(ProfileEntity v) => v.avatarUrl;
  static const Field<ProfileEntity, String> _f$avatarUrl = Field(
    'avatarUrl',
    _$avatarUrl,
    opt: true,
  );
  static List<String> _$portfolioUrls(ProfileEntity v) => v.portfolioUrls;
  static const Field<ProfileEntity, List<String>> _f$portfolioUrls = Field(
    'portfolioUrls',
    _$portfolioUrls,
    opt: true,
    def: const [],
  );
  static List<PromptResponse> _$prompts(ProfileEntity v) => v.prompts;
  static const Field<ProfileEntity, List<PromptResponse>> _f$prompts = Field(
    'prompts',
    _$prompts,
    opt: true,
    def: const [],
  );
  static List<MediaContent> _$mediaContent(ProfileEntity v) => v.mediaContent;
  static const Field<ProfileEntity, List<MediaContent>> _f$mediaContent = Field(
    'mediaContent',
    _$mediaContent,
    opt: true,
    def: const [],
  );
  static Map<String, dynamic>? _$preciseLocation(ProfileEntity v) =>
      v.preciseLocation;
  static const Field<ProfileEntity, Map<String, dynamic>> _f$preciseLocation =
      Field(
        'preciseLocation',
        _$preciseLocation,
        opt: true,
        hook: GeoFirePointHook(),
      );
  static int _$searchRadiusKm(ProfileEntity v) => v.searchRadiusKm;
  static const Field<ProfileEntity, int> _f$searchRadiusKm = Field(
    'searchRadiusKm',
    _$searchRadiusKm,
    opt: true,
    def: 25,
  );
  static double? _$hourlyRate(ProfileEntity v) => v.hourlyRate;
  static const Field<ProfileEntity, double> _f$hourlyRate = Field(
    'hourlyRate',
    _$hourlyRate,
    opt: true,
  );
  static List<String> _$services(ProfileEntity v) => v.services;
  static const Field<ProfileEntity, List<String>> _f$services = Field(
    'services',
    _$services,
    opt: true,
    def: const [],
  );
  static bool _$isAvailable(ProfileEntity v) => v.isAvailable;
  static const Field<ProfileEntity, bool> _f$isAvailable = Field(
    'isAvailable',
    _$isAvailable,
    opt: true,
    def: true,
  );
  static Map<String, String>? _$workingHours(ProfileEntity v) => v.workingHours;
  static const Field<ProfileEntity, Map<String, String>> _f$workingHours =
      Field('workingHours', _$workingHours, opt: true);
  static double _$rating(ProfileEntity v) => v.rating;
  static const Field<ProfileEntity, double> _f$rating = Field(
    'rating',
    _$rating,
    opt: true,
    def: 0.0,
  );
  static int _$reviewCount(ProfileEntity v) => v.reviewCount;
  static const Field<ProfileEntity, int> _f$reviewCount = Field(
    'reviewCount',
    _$reviewCount,
    opt: true,
    def: 0,
  );
  static bool _$isPremium(ProfileEntity v) => v.isPremium;
  static const Field<ProfileEntity, bool> _f$isPremium = Field(
    'isPremium',
    _$isPremium,
    opt: true,
    def: false,
  );
  static DateTime? _$premiumExpiresAt(ProfileEntity v) => v.premiumExpiresAt;
  static const Field<ProfileEntity, DateTime> _f$premiumExpiresAt = Field(
    'premiumExpiresAt',
    _$premiumExpiresAt,
    opt: true,
    hook: TimestampHook(),
  );
  static int _$superLikesRemaining(ProfileEntity v) => v.superLikesRemaining;
  static const Field<ProfileEntity, int> _f$superLikesRemaining = Field(
    'superLikesRemaining',
    _$superLikesRemaining,
    opt: true,
    def: 1,
  );
  static int _$boostsRemaining(ProfileEntity v) => v.boostsRemaining;
  static const Field<ProfileEntity, int> _f$boostsRemaining = Field(
    'boostsRemaining',
    _$boostsRemaining,
    opt: true,
    def: 0,
  );
  static DateTime? _$boostedUntil(ProfileEntity v) => v.boostedUntil;
  static const Field<ProfileEntity, DateTime> _f$boostedUntil = Field(
    'boostedUntil',
    _$boostedUntil,
    opt: true,
    hook: TimestampHook(),
  );
  static bool _$canSeeWhoLiked(ProfileEntity v) => v.canSeeWhoLiked;
  static const Field<ProfileEntity, bool> _f$canSeeWhoLiked = Field(
    'canSeeWhoLiked',
    _$canSeeWhoLiked,
    opt: true,
    def: false,
  );
  static DateTime? _$lastSuperLikeResetAt(ProfileEntity v) =>
      v.lastSuperLikeResetAt;
  static const Field<ProfileEntity, DateTime> _f$lastSuperLikeResetAt = Field(
    'lastSuperLikeResetAt',
    _$lastSuperLikeResetAt,
    opt: true,
    hook: TimestampHook(),
  );
  static GeoFirePoint? _$geoLocation(ProfileEntity v) => v.geoLocation;
  static const Field<ProfileEntity, GeoFirePoint> _f$geoLocation = Field(
    'geoLocation',
    _$geoLocation,
    mode: FieldMode.member,
  );
  static bool _$hasActivePremium(ProfileEntity v) => v.hasActivePremium;
  static const Field<ProfileEntity, bool> _f$hasActivePremium = Field(
    'hasActivePremium',
    _$hasActivePremium,
    mode: FieldMode.member,
  );
  static bool _$isBoosted(ProfileEntity v) => v.isBoosted;
  static const Field<ProfileEntity, bool> _f$isBoosted = Field(
    'isBoosted',
    _$isBoosted,
    mode: FieldMode.member,
  );
  static bool _$canUseSuperLike(ProfileEntity v) => v.canUseSuperLike;
  static const Field<ProfileEntity, bool> _f$canUseSuperLike = Field(
    'canUseSuperLike',
    _$canUseSuperLike,
    mode: FieldMode.member,
  );
  static bool _$canActivateBoost(ProfileEntity v) => v.canActivateBoost;
  static const Field<ProfileEntity, bool> _f$canActivateBoost = Field(
    'canActivateBoost',
    _$canActivateBoost,
    mode: FieldMode.member,
  );
  static bool _$needsSuperLikeReset(ProfileEntity v) => v.needsSuperLikeReset;
  static const Field<ProfileEntity, bool> _f$needsSuperLikeReset = Field(
    'needsSuperLikeReset',
    _$needsSuperLikeReset,
    mode: FieldMode.member,
  );
  static int _$displaySuperLikes(ProfileEntity v) => v.displaySuperLikes;
  static const Field<ProfileEntity, int> _f$displaySuperLikes = Field(
    'displaySuperLikes',
    _$displaySuperLikes,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ProfileEntity> fields = const {
    #userId: _f$userId,
    #accountType: _f$accountType,
    #name: _f$name,
    #email: _f$email,
    #createdAt: _f$createdAt,
    #bio: _f$bio,
    #location: _f$location,
    #contactPhone: _f$contactPhone,
    #fcmToken: _f$fcmToken,
    #updatedAt: _f$updatedAt,
    #avatarUrl: _f$avatarUrl,
    #portfolioUrls: _f$portfolioUrls,
    #prompts: _f$prompts,
    #mediaContent: _f$mediaContent,
    #preciseLocation: _f$preciseLocation,
    #searchRadiusKm: _f$searchRadiusKm,
    #hourlyRate: _f$hourlyRate,
    #services: _f$services,
    #isAvailable: _f$isAvailable,
    #workingHours: _f$workingHours,
    #rating: _f$rating,
    #reviewCount: _f$reviewCount,
    #isPremium: _f$isPremium,
    #premiumExpiresAt: _f$premiumExpiresAt,
    #superLikesRemaining: _f$superLikesRemaining,
    #boostsRemaining: _f$boostsRemaining,
    #boostedUntil: _f$boostedUntil,
    #canSeeWhoLiked: _f$canSeeWhoLiked,
    #lastSuperLikeResetAt: _f$lastSuperLikeResetAt,
    #geoLocation: _f$geoLocation,
    #hasActivePremium: _f$hasActivePremium,
    #isBoosted: _f$isBoosted,
    #canUseSuperLike: _f$canUseSuperLike,
    #canActivateBoost: _f$canActivateBoost,
    #needsSuperLikeReset: _f$needsSuperLikeReset,
    #displaySuperLikes: _f$displaySuperLikes,
  };

  static ProfileEntity _instantiate(DecodingData data) {
    return ProfileEntity(
      userId: data.dec(_f$userId),
      accountType: data.dec(_f$accountType),
      name: data.dec(_f$name),
      email: data.dec(_f$email),
      createdAt: data.dec(_f$createdAt),
      bio: data.dec(_f$bio),
      location: data.dec(_f$location),
      contactPhone: data.dec(_f$contactPhone),
      fcmToken: data.dec(_f$fcmToken),
      updatedAt: data.dec(_f$updatedAt),
      avatarUrl: data.dec(_f$avatarUrl),
      portfolioUrls: data.dec(_f$portfolioUrls),
      prompts: data.dec(_f$prompts),
      mediaContent: data.dec(_f$mediaContent),
      preciseLocation: data.dec(_f$preciseLocation),
      searchRadiusKm: data.dec(_f$searchRadiusKm),
      hourlyRate: data.dec(_f$hourlyRate),
      services: data.dec(_f$services),
      isAvailable: data.dec(_f$isAvailable),
      workingHours: data.dec(_f$workingHours),
      rating: data.dec(_f$rating),
      reviewCount: data.dec(_f$reviewCount),
      isPremium: data.dec(_f$isPremium),
      premiumExpiresAt: data.dec(_f$premiumExpiresAt),
      superLikesRemaining: data.dec(_f$superLikesRemaining),
      boostsRemaining: data.dec(_f$boostsRemaining),
      boostedUntil: data.dec(_f$boostedUntil),
      canSeeWhoLiked: data.dec(_f$canSeeWhoLiked),
      lastSuperLikeResetAt: data.dec(_f$lastSuperLikeResetAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProfileEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProfileEntity>(map);
  }

  static ProfileEntity fromJson(String json) {
    return ensureInitialized().decodeJson<ProfileEntity>(json);
  }
}

mixin ProfileEntityMappable {
  String toJson() {
    return ProfileEntityMapper.ensureInitialized().encodeJson<ProfileEntity>(
      this as ProfileEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return ProfileEntityMapper.ensureInitialized().encodeMap<ProfileEntity>(
      this as ProfileEntity,
    );
  }

  ProfileEntityCopyWith<ProfileEntity, ProfileEntity, ProfileEntity>
  get copyWith => _ProfileEntityCopyWithImpl<ProfileEntity, ProfileEntity>(
    this as ProfileEntity,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ProfileEntityMapper.ensureInitialized().stringifyValue(
      this as ProfileEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProfileEntityMapper.ensureInitialized().equalsValue(
      this as ProfileEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return ProfileEntityMapper.ensureInitialized().hashValue(
      this as ProfileEntity,
    );
  }
}

extension ProfileEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProfileEntity, $Out> {
  ProfileEntityCopyWith<$R, ProfileEntity, $Out> get $asProfileEntity =>
      $base.as((v, t, t2) => _ProfileEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProfileEntityCopyWith<$R, $In extends ProfileEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get portfolioUrls;
  ListCopyWith<
    $R,
    PromptResponse,
    PromptResponseCopyWith<$R, PromptResponse, PromptResponse>
  >
  get prompts;
  ListCopyWith<
    $R,
    MediaContent,
    MediaContentCopyWith<$R, MediaContent, MediaContent>
  >
  get mediaContent;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get preciseLocation;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get services;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get workingHours;
  $R call({
    String? userId,
    AccountType? accountType,
    String? name,
    String? email,
    DateTime? createdAt,
    String? bio,
    String? location,
    String? contactPhone,
    String? fcmToken,
    DateTime? updatedAt,
    String? avatarUrl,
    List<String>? portfolioUrls,
    List<PromptResponse>? prompts,
    List<MediaContent>? mediaContent,
    Map<String, dynamic>? preciseLocation,
    int? searchRadiusKm,
    double? hourlyRate,
    List<String>? services,
    bool? isAvailable,
    Map<String, String>? workingHours,
    double? rating,
    int? reviewCount,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    int? superLikesRemaining,
    int? boostsRemaining,
    DateTime? boostedUntil,
    bool? canSeeWhoLiked,
    DateTime? lastSuperLikeResetAt,
  });
  ProfileEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProfileEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProfileEntity, $Out>
    implements ProfileEntityCopyWith<$R, ProfileEntity, $Out> {
  _ProfileEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProfileEntity> $mapper =
      ProfileEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get portfolioUrls => ListCopyWith(
    $value.portfolioUrls,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(portfolioUrls: v),
  );
  @override
  ListCopyWith<
    $R,
    PromptResponse,
    PromptResponseCopyWith<$R, PromptResponse, PromptResponse>
  >
  get prompts => ListCopyWith(
    $value.prompts,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(prompts: v),
  );
  @override
  ListCopyWith<
    $R,
    MediaContent,
    MediaContentCopyWith<$R, MediaContent, MediaContent>
  >
  get mediaContent => ListCopyWith(
    $value.mediaContent,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mediaContent: v),
  );
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get preciseLocation => $value.preciseLocation != null
      ? MapCopyWith(
          $value.preciseLocation!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(preciseLocation: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get services =>
      ListCopyWith(
        $value.services,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(services: v),
      );
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get workingHours => $value.workingHours != null
      ? MapCopyWith(
          $value.workingHours!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(workingHours: v),
        )
      : null;
  @override
  $R call({
    String? userId,
    AccountType? accountType,
    String? name,
    String? email,
    DateTime? createdAt,
    String? bio,
    String? location,
    String? contactPhone,
    Object? fcmToken = $none,
    Object? updatedAt = $none,
    Object? avatarUrl = $none,
    List<String>? portfolioUrls,
    List<PromptResponse>? prompts,
    List<MediaContent>? mediaContent,
    Object? preciseLocation = $none,
    int? searchRadiusKm,
    Object? hourlyRate = $none,
    List<String>? services,
    bool? isAvailable,
    Object? workingHours = $none,
    double? rating,
    int? reviewCount,
    bool? isPremium,
    Object? premiumExpiresAt = $none,
    int? superLikesRemaining,
    int? boostsRemaining,
    Object? boostedUntil = $none,
    bool? canSeeWhoLiked,
    Object? lastSuperLikeResetAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (accountType != null) #accountType: accountType,
      if (name != null) #name: name,
      if (email != null) #email: email,
      if (createdAt != null) #createdAt: createdAt,
      if (bio != null) #bio: bio,
      if (location != null) #location: location,
      if (contactPhone != null) #contactPhone: contactPhone,
      if (fcmToken != $none) #fcmToken: fcmToken,
      if (updatedAt != $none) #updatedAt: updatedAt,
      if (avatarUrl != $none) #avatarUrl: avatarUrl,
      if (portfolioUrls != null) #portfolioUrls: portfolioUrls,
      if (prompts != null) #prompts: prompts,
      if (mediaContent != null) #mediaContent: mediaContent,
      if (preciseLocation != $none) #preciseLocation: preciseLocation,
      if (searchRadiusKm != null) #searchRadiusKm: searchRadiusKm,
      if (hourlyRate != $none) #hourlyRate: hourlyRate,
      if (services != null) #services: services,
      if (isAvailable != null) #isAvailable: isAvailable,
      if (workingHours != $none) #workingHours: workingHours,
      if (rating != null) #rating: rating,
      if (reviewCount != null) #reviewCount: reviewCount,
      if (isPremium != null) #isPremium: isPremium,
      if (premiumExpiresAt != $none) #premiumExpiresAt: premiumExpiresAt,
      if (superLikesRemaining != null)
        #superLikesRemaining: superLikesRemaining,
      if (boostsRemaining != null) #boostsRemaining: boostsRemaining,
      if (boostedUntil != $none) #boostedUntil: boostedUntil,
      if (canSeeWhoLiked != null) #canSeeWhoLiked: canSeeWhoLiked,
      if (lastSuperLikeResetAt != $none)
        #lastSuperLikeResetAt: lastSuperLikeResetAt,
    }),
  );
  @override
  ProfileEntity $make(CopyWithData data) => ProfileEntity(
    userId: data.get(#userId, or: $value.userId),
    accountType: data.get(#accountType, or: $value.accountType),
    name: data.get(#name, or: $value.name),
    email: data.get(#email, or: $value.email),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    bio: data.get(#bio, or: $value.bio),
    location: data.get(#location, or: $value.location),
    contactPhone: data.get(#contactPhone, or: $value.contactPhone),
    fcmToken: data.get(#fcmToken, or: $value.fcmToken),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    avatarUrl: data.get(#avatarUrl, or: $value.avatarUrl),
    portfolioUrls: data.get(#portfolioUrls, or: $value.portfolioUrls),
    prompts: data.get(#prompts, or: $value.prompts),
    mediaContent: data.get(#mediaContent, or: $value.mediaContent),
    preciseLocation: data.get(#preciseLocation, or: $value.preciseLocation),
    searchRadiusKm: data.get(#searchRadiusKm, or: $value.searchRadiusKm),
    hourlyRate: data.get(#hourlyRate, or: $value.hourlyRate),
    services: data.get(#services, or: $value.services),
    isAvailable: data.get(#isAvailable, or: $value.isAvailable),
    workingHours: data.get(#workingHours, or: $value.workingHours),
    rating: data.get(#rating, or: $value.rating),
    reviewCount: data.get(#reviewCount, or: $value.reviewCount),
    isPremium: data.get(#isPremium, or: $value.isPremium),
    premiumExpiresAt: data.get(#premiumExpiresAt, or: $value.premiumExpiresAt),
    superLikesRemaining: data.get(
      #superLikesRemaining,
      or: $value.superLikesRemaining,
    ),
    boostsRemaining: data.get(#boostsRemaining, or: $value.boostsRemaining),
    boostedUntil: data.get(#boostedUntil, or: $value.boostedUntil),
    canSeeWhoLiked: data.get(#canSeeWhoLiked, or: $value.canSeeWhoLiked),
    lastSuperLikeResetAt: data.get(
      #lastSuperLikeResetAt,
      or: $value.lastSuperLikeResetAt,
    ),
  );

  @override
  ProfileEntityCopyWith<$R2, ProfileEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProfileEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

