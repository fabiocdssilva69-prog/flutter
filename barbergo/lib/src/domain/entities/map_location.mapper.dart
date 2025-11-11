// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'map_location.dart';

class MapLocationMapper extends ClassMapperBase<MapLocation> {
  MapLocationMapper._();

  static MapLocationMapper? _instance;
  static MapLocationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MapLocationMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MapLocation';

  static String _$locationId(MapLocation v) => v.locationId;
  static const Field<MapLocation, String> _f$locationId = Field(
    'locationId',
    _$locationId,
  );
  static LocationType _$type(MapLocation v) => v.type;
  static const Field<MapLocation, LocationType> _f$type = Field('type', _$type);
  static String _$name(MapLocation v) => v.name;
  static const Field<MapLocation, String> _f$name = Field('name', _$name);
  static String _$address(MapLocation v) => v.address;
  static const Field<MapLocation, String> _f$address = Field(
    'address',
    _$address,
  );
  static double _$latitude(MapLocation v) => v.latitude;
  static const Field<MapLocation, double> _f$latitude = Field(
    'latitude',
    _$latitude,
  );
  static double _$longitude(MapLocation v) => v.longitude;
  static const Field<MapLocation, double> _f$longitude = Field(
    'longitude',
    _$longitude,
  );
  static double _$rating(MapLocation v) => v.rating;
  static const Field<MapLocation, double> _f$rating = Field('rating', _$rating);
  static int _$reviewCount(MapLocation v) => v.reviewCount;
  static const Field<MapLocation, int> _f$reviewCount = Field(
    'reviewCount',
    _$reviewCount,
  );
  static String _$category(MapLocation v) => v.category;
  static const Field<MapLocation, String> _f$category = Field(
    'category',
    _$category,
  );
  static int _$priceLevel(MapLocation v) => v.priceLevel;
  static const Field<MapLocation, int> _f$priceLevel = Field(
    'priceLevel',
    _$priceLevel,
    opt: true,
    def: 2,
  );
  static Map<String, String>? _$openingHours(MapLocation v) => v.openingHours;
  static const Field<MapLocation, Map<String, String>> _f$openingHours = Field(
    'openingHours',
    _$openingHours,
    opt: true,
  );
  static String? _$phoneNumber(MapLocation v) => v.phoneNumber;
  static const Field<MapLocation, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
    opt: true,
  );
  static String? _$website(MapLocation v) => v.website;
  static const Field<MapLocation, String> _f$website = Field(
    'website',
    _$website,
    opt: true,
  );
  static List<String> _$photoUrls(MapLocation v) => v.photoUrls;
  static const Field<MapLocation, List<String>> _f$photoUrls = Field(
    'photoUrls',
    _$photoUrls,
    opt: true,
    def: const [],
  );
  static bool _$isOpenNow(MapLocation v) => v.isOpenNow;
  static const Field<MapLocation, bool> _f$isOpenNow = Field(
    'isOpenNow',
    _$isOpenNow,
    opt: true,
    def: true,
  );
  static double? _$distanceMeters(MapLocation v) => v.distanceMeters;
  static const Field<MapLocation, double> _f$distanceMeters = Field(
    'distanceMeters',
    _$distanceMeters,
    opt: true,
  );
  static LatLng _$latLng(MapLocation v) => v.latLng;
  static const Field<MapLocation, LatLng> _f$latLng = Field(
    'latLng',
    _$latLng,
    mode: FieldMode.member,
  );
  static String _$distanceText(MapLocation v) => v.distanceText;
  static const Field<MapLocation, String> _f$distanceText = Field(
    'distanceText',
    _$distanceText,
    mode: FieldMode.member,
  );
  static String _$priceText(MapLocation v) => v.priceText;
  static const Field<MapLocation, String> _f$priceText = Field(
    'priceText',
    _$priceText,
    mode: FieldMode.member,
  );
  static String _$iconEmoji(MapLocation v) => v.iconEmoji;
  static const Field<MapLocation, String> _f$iconEmoji = Field(
    'iconEmoji',
    _$iconEmoji,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<MapLocation> fields = const {
    #locationId: _f$locationId,
    #type: _f$type,
    #name: _f$name,
    #address: _f$address,
    #latitude: _f$latitude,
    #longitude: _f$longitude,
    #rating: _f$rating,
    #reviewCount: _f$reviewCount,
    #category: _f$category,
    #priceLevel: _f$priceLevel,
    #openingHours: _f$openingHours,
    #phoneNumber: _f$phoneNumber,
    #website: _f$website,
    #photoUrls: _f$photoUrls,
    #isOpenNow: _f$isOpenNow,
    #distanceMeters: _f$distanceMeters,
    #latLng: _f$latLng,
    #distanceText: _f$distanceText,
    #priceText: _f$priceText,
    #iconEmoji: _f$iconEmoji,
  };

  static MapLocation _instantiate(DecodingData data) {
    return MapLocation(
      locationId: data.dec(_f$locationId),
      type: data.dec(_f$type),
      name: data.dec(_f$name),
      address: data.dec(_f$address),
      latitude: data.dec(_f$latitude),
      longitude: data.dec(_f$longitude),
      rating: data.dec(_f$rating),
      reviewCount: data.dec(_f$reviewCount),
      category: data.dec(_f$category),
      priceLevel: data.dec(_f$priceLevel),
      openingHours: data.dec(_f$openingHours),
      phoneNumber: data.dec(_f$phoneNumber),
      website: data.dec(_f$website),
      photoUrls: data.dec(_f$photoUrls),
      isOpenNow: data.dec(_f$isOpenNow),
      distanceMeters: data.dec(_f$distanceMeters),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MapLocation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MapLocation>(map);
  }

  static MapLocation fromJson(String json) {
    return ensureInitialized().decodeJson<MapLocation>(json);
  }
}

mixin MapLocationMappable {
  String toJson() {
    return MapLocationMapper.ensureInitialized().encodeJson<MapLocation>(
      this as MapLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return MapLocationMapper.ensureInitialized().encodeMap<MapLocation>(
      this as MapLocation,
    );
  }

  MapLocationCopyWith<MapLocation, MapLocation, MapLocation> get copyWith =>
      _MapLocationCopyWithImpl<MapLocation, MapLocation>(
        this as MapLocation,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MapLocationMapper.ensureInitialized().stringifyValue(
      this as MapLocation,
    );
  }

  @override
  bool operator ==(Object other) {
    return MapLocationMapper.ensureInitialized().equalsValue(
      this as MapLocation,
      other,
    );
  }

  @override
  int get hashCode {
    return MapLocationMapper.ensureInitialized().hashValue(this as MapLocation);
  }
}

extension MapLocationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MapLocation, $Out> {
  MapLocationCopyWith<$R, MapLocation, $Out> get $asMapLocation =>
      $base.as((v, t, t2) => _MapLocationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MapLocationCopyWith<$R, $In extends MapLocation, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get openingHours;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get photoUrls;
  $R call({
    String? locationId,
    LocationType? type,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewCount,
    String? category,
    int? priceLevel,
    Map<String, String>? openingHours,
    String? phoneNumber,
    String? website,
    List<String>? photoUrls,
    bool? isOpenNow,
    double? distanceMeters,
  });
  MapLocationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MapLocationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MapLocation, $Out>
    implements MapLocationCopyWith<$R, MapLocation, $Out> {
  _MapLocationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MapLocation> $mapper =
      MapLocationMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get openingHours => $value.openingHours != null
      ? MapCopyWith(
          $value.openingHours!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(openingHours: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get photoUrls =>
      ListCopyWith(
        $value.photoUrls,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(photoUrls: v),
      );
  @override
  $R call({
    String? locationId,
    LocationType? type,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewCount,
    String? category,
    int? priceLevel,
    Object? openingHours = $none,
    Object? phoneNumber = $none,
    Object? website = $none,
    List<String>? photoUrls,
    bool? isOpenNow,
    Object? distanceMeters = $none,
  }) => $apply(
    FieldCopyWithData({
      if (locationId != null) #locationId: locationId,
      if (type != null) #type: type,
      if (name != null) #name: name,
      if (address != null) #address: address,
      if (latitude != null) #latitude: latitude,
      if (longitude != null) #longitude: longitude,
      if (rating != null) #rating: rating,
      if (reviewCount != null) #reviewCount: reviewCount,
      if (category != null) #category: category,
      if (priceLevel != null) #priceLevel: priceLevel,
      if (openingHours != $none) #openingHours: openingHours,
      if (phoneNumber != $none) #phoneNumber: phoneNumber,
      if (website != $none) #website: website,
      if (photoUrls != null) #photoUrls: photoUrls,
      if (isOpenNow != null) #isOpenNow: isOpenNow,
      if (distanceMeters != $none) #distanceMeters: distanceMeters,
    }),
  );
  @override
  MapLocation $make(CopyWithData data) => MapLocation(
    locationId: data.get(#locationId, or: $value.locationId),
    type: data.get(#type, or: $value.type),
    name: data.get(#name, or: $value.name),
    address: data.get(#address, or: $value.address),
    latitude: data.get(#latitude, or: $value.latitude),
    longitude: data.get(#longitude, or: $value.longitude),
    rating: data.get(#rating, or: $value.rating),
    reviewCount: data.get(#reviewCount, or: $value.reviewCount),
    category: data.get(#category, or: $value.category),
    priceLevel: data.get(#priceLevel, or: $value.priceLevel),
    openingHours: data.get(#openingHours, or: $value.openingHours),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
    website: data.get(#website, or: $value.website),
    photoUrls: data.get(#photoUrls, or: $value.photoUrls),
    isOpenNow: data.get(#isOpenNow, or: $value.isOpenNow),
    distanceMeters: data.get(#distanceMeters, or: $value.distanceMeters),
  );

  @override
  MapLocationCopyWith<$R2, MapLocation, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MapLocationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DateLocationSuggestionMapper
    extends ClassMapperBase<DateLocationSuggestion> {
  DateLocationSuggestionMapper._();

  static DateLocationSuggestionMapper? _instance;
  static DateLocationSuggestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateLocationSuggestionMapper._());
      MapLocationMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DateLocationSuggestion';

  static String _$suggestionId(DateLocationSuggestion v) => v.suggestionId;
  static const Field<DateLocationSuggestion, String> _f$suggestionId = Field(
    'suggestionId',
    _$suggestionId,
  );
  static String _$matchId(DateLocationSuggestion v) => v.matchId;
  static const Field<DateLocationSuggestion, String> _f$matchId = Field(
    'matchId',
    _$matchId,
  );
  static MapLocation _$location(DateLocationSuggestion v) => v.location;
  static const Field<DateLocationSuggestion, MapLocation> _f$location = Field(
    'location',
    _$location,
  );
  static String _$reason(DateLocationSuggestion v) => v.reason;
  static const Field<DateLocationSuggestion, String> _f$reason = Field(
    'reason',
    _$reason,
  );
  static double _$compatibilityScore(DateLocationSuggestion v) =>
      v.compatibilityScore;
  static const Field<DateLocationSuggestion, double> _f$compatibilityScore =
      Field('compatibilityScore', _$compatibilityScore);
  static String? _$suggestedTime(DateLocationSuggestion v) => v.suggestedTime;
  static const Field<DateLocationSuggestion, String> _f$suggestedTime = Field(
    'suggestedTime',
    _$suggestedTime,
    opt: true,
  );
  static List<String> _$tips(DateLocationSuggestion v) => v.tips;
  static const Field<DateLocationSuggestion, List<String>> _f$tips = Field(
    'tips',
    _$tips,
    opt: true,
    def: const [],
  );
  static DateTime _$createdAt(DateLocationSuggestion v) => v.createdAt;
  static const Field<DateLocationSuggestion, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<DateLocationSuggestion> fields = const {
    #suggestionId: _f$suggestionId,
    #matchId: _f$matchId,
    #location: _f$location,
    #reason: _f$reason,
    #compatibilityScore: _f$compatibilityScore,
    #suggestedTime: _f$suggestedTime,
    #tips: _f$tips,
    #createdAt: _f$createdAt,
  };

  static DateLocationSuggestion _instantiate(DecodingData data) {
    return DateLocationSuggestion(
      suggestionId: data.dec(_f$suggestionId),
      matchId: data.dec(_f$matchId),
      location: data.dec(_f$location),
      reason: data.dec(_f$reason),
      compatibilityScore: data.dec(_f$compatibilityScore),
      suggestedTime: data.dec(_f$suggestedTime),
      tips: data.dec(_f$tips),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateLocationSuggestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateLocationSuggestion>(map);
  }

  static DateLocationSuggestion fromJson(String json) {
    return ensureInitialized().decodeJson<DateLocationSuggestion>(json);
  }
}

mixin DateLocationSuggestionMappable {
  String toJson() {
    return DateLocationSuggestionMapper.ensureInitialized()
        .encodeJson<DateLocationSuggestion>(this as DateLocationSuggestion);
  }

  Map<String, dynamic> toMap() {
    return DateLocationSuggestionMapper.ensureInitialized()
        .encodeMap<DateLocationSuggestion>(this as DateLocationSuggestion);
  }

  DateLocationSuggestionCopyWith<
    DateLocationSuggestion,
    DateLocationSuggestion,
    DateLocationSuggestion
  >
  get copyWith =>
      _DateLocationSuggestionCopyWithImpl<
        DateLocationSuggestion,
        DateLocationSuggestion
      >(this as DateLocationSuggestion, $identity, $identity);
  @override
  String toString() {
    return DateLocationSuggestionMapper.ensureInitialized().stringifyValue(
      this as DateLocationSuggestion,
    );
  }

  @override
  bool operator ==(Object other) {
    return DateLocationSuggestionMapper.ensureInitialized().equalsValue(
      this as DateLocationSuggestion,
      other,
    );
  }

  @override
  int get hashCode {
    return DateLocationSuggestionMapper.ensureInitialized().hashValue(
      this as DateLocationSuggestion,
    );
  }
}

extension DateLocationSuggestionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DateLocationSuggestion, $Out> {
  DateLocationSuggestionCopyWith<$R, DateLocationSuggestion, $Out>
  get $asDateLocationSuggestion => $base.as(
    (v, t, t2) => _DateLocationSuggestionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DateLocationSuggestionCopyWith<
  $R,
  $In extends DateLocationSuggestion,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapLocationCopyWith<$R, MapLocation, MapLocation> get location;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get tips;
  $R call({
    String? suggestionId,
    String? matchId,
    MapLocation? location,
    String? reason,
    double? compatibilityScore,
    String? suggestedTime,
    List<String>? tips,
    DateTime? createdAt,
  });
  DateLocationSuggestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DateLocationSuggestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateLocationSuggestion, $Out>
    implements
        DateLocationSuggestionCopyWith<$R, DateLocationSuggestion, $Out> {
  _DateLocationSuggestionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateLocationSuggestion> $mapper =
      DateLocationSuggestionMapper.ensureInitialized();
  @override
  MapLocationCopyWith<$R, MapLocation, MapLocation> get location =>
      $value.location.copyWith.$chain((v) => call(location: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get tips =>
      ListCopyWith(
        $value.tips,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(tips: v),
      );
  @override
  $R call({
    String? suggestionId,
    String? matchId,
    MapLocation? location,
    String? reason,
    double? compatibilityScore,
    Object? suggestedTime = $none,
    List<String>? tips,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (suggestionId != null) #suggestionId: suggestionId,
      if (matchId != null) #matchId: matchId,
      if (location != null) #location: location,
      if (reason != null) #reason: reason,
      if (compatibilityScore != null) #compatibilityScore: compatibilityScore,
      if (suggestedTime != $none) #suggestedTime: suggestedTime,
      if (tips != null) #tips: tips,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  DateLocationSuggestion $make(CopyWithData data) => DateLocationSuggestion(
    suggestionId: data.get(#suggestionId, or: $value.suggestionId),
    matchId: data.get(#matchId, or: $value.matchId),
    location: data.get(#location, or: $value.location),
    reason: data.get(#reason, or: $value.reason),
    compatibilityScore: data.get(
      #compatibilityScore,
      or: $value.compatibilityScore,
    ),
    suggestedTime: data.get(#suggestedTime, or: $value.suggestedTime),
    tips: data.get(#tips, or: $value.tips),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  DateLocationSuggestionCopyWith<$R2, DateLocationSuggestion, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DateLocationSuggestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LocationSearchFiltersMapper
    extends ClassMapperBase<LocationSearchFilters> {
  LocationSearchFiltersMapper._();

  static LocationSearchFiltersMapper? _instance;
  static LocationSearchFiltersMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LocationSearchFiltersMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LocationSearchFilters';

  static Set<String> _$categories(LocationSearchFilters v) => v.categories;
  static const Field<LocationSearchFilters, Set<String>> _f$categories = Field(
    'categories',
    _$categories,
    opt: true,
    def: const {'restaurante', 'café', 'bar', 'parque'},
  );
  static int _$maxPriceLevel(LocationSearchFilters v) => v.maxPriceLevel;
  static const Field<LocationSearchFilters, int> _f$maxPriceLevel = Field(
    'maxPriceLevel',
    _$maxPriceLevel,
    opt: true,
    def: 3,
  );
  static double _$minRating(LocationSearchFilters v) => v.minRating;
  static const Field<LocationSearchFilters, double> _f$minRating = Field(
    'minRating',
    _$minRating,
    opt: true,
    def: 3.5,
  );
  static double _$radiusMeters(LocationSearchFilters v) => v.radiusMeters;
  static const Field<LocationSearchFilters, double> _f$radiusMeters = Field(
    'radiusMeters',
    _$radiusMeters,
    opt: true,
    def: 5000,
  );
  static bool _$openNowOnly(LocationSearchFilters v) => v.openNowOnly;
  static const Field<LocationSearchFilters, bool> _f$openNowOnly = Field(
    'openNowOnly',
    _$openNowOnly,
    opt: true,
    def: false,
  );
  static String _$sortBy(LocationSearchFilters v) => v.sortBy;
  static const Field<LocationSearchFilters, String> _f$sortBy = Field(
    'sortBy',
    _$sortBy,
    opt: true,
    def: 'distance',
  );

  @override
  final MappableFields<LocationSearchFilters> fields = const {
    #categories: _f$categories,
    #maxPriceLevel: _f$maxPriceLevel,
    #minRating: _f$minRating,
    #radiusMeters: _f$radiusMeters,
    #openNowOnly: _f$openNowOnly,
    #sortBy: _f$sortBy,
  };

  static LocationSearchFilters _instantiate(DecodingData data) {
    return LocationSearchFilters(
      categories: data.dec(_f$categories),
      maxPriceLevel: data.dec(_f$maxPriceLevel),
      minRating: data.dec(_f$minRating),
      radiusMeters: data.dec(_f$radiusMeters),
      openNowOnly: data.dec(_f$openNowOnly),
      sortBy: data.dec(_f$sortBy),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LocationSearchFilters fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LocationSearchFilters>(map);
  }

  static LocationSearchFilters fromJson(String json) {
    return ensureInitialized().decodeJson<LocationSearchFilters>(json);
  }
}

mixin LocationSearchFiltersMappable {
  String toJson() {
    return LocationSearchFiltersMapper.ensureInitialized()
        .encodeJson<LocationSearchFilters>(this as LocationSearchFilters);
  }

  Map<String, dynamic> toMap() {
    return LocationSearchFiltersMapper.ensureInitialized()
        .encodeMap<LocationSearchFilters>(this as LocationSearchFilters);
  }

  LocationSearchFiltersCopyWith<
    LocationSearchFilters,
    LocationSearchFilters,
    LocationSearchFilters
  >
  get copyWith =>
      _LocationSearchFiltersCopyWithImpl<
        LocationSearchFilters,
        LocationSearchFilters
      >(this as LocationSearchFilters, $identity, $identity);
  @override
  String toString() {
    return LocationSearchFiltersMapper.ensureInitialized().stringifyValue(
      this as LocationSearchFilters,
    );
  }

  @override
  bool operator ==(Object other) {
    return LocationSearchFiltersMapper.ensureInitialized().equalsValue(
      this as LocationSearchFilters,
      other,
    );
  }

  @override
  int get hashCode {
    return LocationSearchFiltersMapper.ensureInitialized().hashValue(
      this as LocationSearchFilters,
    );
  }
}

extension LocationSearchFiltersValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LocationSearchFilters, $Out> {
  LocationSearchFiltersCopyWith<$R, LocationSearchFilters, $Out>
  get $asLocationSearchFilters => $base.as(
    (v, t, t2) => _LocationSearchFiltersCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class LocationSearchFiltersCopyWith<
  $R,
  $In extends LocationSearchFilters,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Set<String>? categories,
    int? maxPriceLevel,
    double? minRating,
    double? radiusMeters,
    bool? openNowOnly,
    String? sortBy,
  });
  LocationSearchFiltersCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LocationSearchFiltersCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LocationSearchFilters, $Out>
    implements LocationSearchFiltersCopyWith<$R, LocationSearchFilters, $Out> {
  _LocationSearchFiltersCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LocationSearchFilters> $mapper =
      LocationSearchFiltersMapper.ensureInitialized();
  @override
  $R call({
    Set<String>? categories,
    int? maxPriceLevel,
    double? minRating,
    double? radiusMeters,
    bool? openNowOnly,
    String? sortBy,
  }) => $apply(
    FieldCopyWithData({
      if (categories != null) #categories: categories,
      if (maxPriceLevel != null) #maxPriceLevel: maxPriceLevel,
      if (minRating != null) #minRating: minRating,
      if (radiusMeters != null) #radiusMeters: radiusMeters,
      if (openNowOnly != null) #openNowOnly: openNowOnly,
      if (sortBy != null) #sortBy: sortBy,
    }),
  );
  @override
  LocationSearchFilters $make(CopyWithData data) => LocationSearchFilters(
    categories: data.get(#categories, or: $value.categories),
    maxPriceLevel: data.get(#maxPriceLevel, or: $value.maxPriceLevel),
    minRating: data.get(#minRating, or: $value.minRating),
    radiusMeters: data.get(#radiusMeters, or: $value.radiusMeters),
    openNowOnly: data.get(#openNowOnly, or: $value.openNowOnly),
    sortBy: data.get(#sortBy, or: $value.sortBy),
  );

  @override
  LocationSearchFiltersCopyWith<$R2, LocationSearchFilters, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LocationSearchFiltersCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

