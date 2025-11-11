// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'date_idea.dart';

class DateIdeaMapper extends ClassMapperBase<DateIdea> {
  DateIdeaMapper._();

  static DateIdeaMapper? _instance;
  static DateIdeaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateIdeaMapper._());
      DateLocationMapper.ensureInitialized();
      DateActivityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DateIdea';

  static String _$ideaId(DateIdea v) => v.ideaId;
  static const Field<DateIdea, String> _f$ideaId = Field('ideaId', _$ideaId);
  static String _$title(DateIdea v) => v.title;
  static const Field<DateIdea, String> _f$title = Field('title', _$title);
  static String _$description(DateIdea v) => v.description;
  static const Field<DateIdea, String> _f$description = Field(
    'description',
    _$description,
  );
  static DateCategory _$category(DateIdea v) => v.category;
  static const Field<DateIdea, DateCategory> _f$category = Field(
    'category',
    _$category,
  );
  static DateVibe _$vibe(DateIdea v) => v.vibe;
  static const Field<DateIdea, DateVibe> _f$vibe = Field('vibe', _$vibe);
  static PriceRange _$priceRange(DateIdea v) => v.priceRange;
  static const Field<DateIdea, PriceRange> _f$priceRange = Field(
    'priceRange',
    _$priceRange,
  );
  static Duration _$estimatedDuration(DateIdea v) => v.estimatedDuration;
  static const Field<DateIdea, Duration> _f$estimatedDuration = Field(
    'estimatedDuration',
    _$estimatedDuration,
  );
  static TimeOfDay _$bestTimeOfDay(DateIdea v) => v.bestTimeOfDay;
  static const Field<DateIdea, TimeOfDay> _f$bestTimeOfDay = Field(
    'bestTimeOfDay',
    _$bestTimeOfDay,
  );
  static List<String> _$tags(DateIdea v) => v.tags;
  static const Field<DateIdea, List<String>> _f$tags = Field('tags', _$tags);
  static double _$popularityScore(DateIdea v) => v.popularityScore;
  static const Field<DateIdea, double> _f$popularityScore = Field(
    'popularityScore',
    _$popularityScore,
    opt: true,
    def: 50.0,
  );
  static int _$timesBooked(DateIdea v) => v.timesBooked;
  static const Field<DateIdea, int> _f$timesBooked = Field(
    'timesBooked',
    _$timesBooked,
    opt: true,
    def: 0,
  );
  static double _$averageRating(DateIdea v) => v.averageRating;
  static const Field<DateIdea, double> _f$averageRating = Field(
    'averageRating',
    _$averageRating,
    opt: true,
    def: 0.0,
  );
  static String? _$imageUrl(DateIdea v) => v.imageUrl;
  static const Field<DateIdea, String> _f$imageUrl = Field(
    'imageUrl',
    _$imageUrl,
    opt: true,
  );
  static DateLocation? _$location(DateIdea v) => v.location;
  static const Field<DateIdea, DateLocation> _f$location = Field(
    'location',
    _$location,
    opt: true,
  );
  static List<DateActivity> _$activities(DateIdea v) => v.activities;
  static const Field<DateIdea, List<DateActivity>> _f$activities = Field(
    'activities',
    _$activities,
  );
  static Map<String, String> _$tips(DateIdea v) => v.tips;
  static const Field<DateIdea, Map<String, String>> _f$tips = Field(
    'tips',
    _$tips,
    opt: true,
    def: const {},
  );
  static DateTime _$createdAt(DateIdea v) => v.createdAt;
  static const Field<DateIdea, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static bool _$isFirstDateFriendly(DateIdea v) => v.isFirstDateFriendly;
  static const Field<DateIdea, bool> _f$isFirstDateFriendly = Field(
    'isFirstDateFriendly',
    _$isFirstDateFriendly,
    mode: FieldMode.member,
  );
  static bool _$requiresReservation(DateIdea v) => v.requiresReservation;
  static const Field<DateIdea, bool> _f$requiresReservation = Field(
    'requiresReservation',
    _$requiresReservation,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<DateIdea> fields = const {
    #ideaId: _f$ideaId,
    #title: _f$title,
    #description: _f$description,
    #category: _f$category,
    #vibe: _f$vibe,
    #priceRange: _f$priceRange,
    #estimatedDuration: _f$estimatedDuration,
    #bestTimeOfDay: _f$bestTimeOfDay,
    #tags: _f$tags,
    #popularityScore: _f$popularityScore,
    #timesBooked: _f$timesBooked,
    #averageRating: _f$averageRating,
    #imageUrl: _f$imageUrl,
    #location: _f$location,
    #activities: _f$activities,
    #tips: _f$tips,
    #createdAt: _f$createdAt,
    #isFirstDateFriendly: _f$isFirstDateFriendly,
    #requiresReservation: _f$requiresReservation,
  };

  static DateIdea _instantiate(DecodingData data) {
    return DateIdea(
      ideaId: data.dec(_f$ideaId),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      category: data.dec(_f$category),
      vibe: data.dec(_f$vibe),
      priceRange: data.dec(_f$priceRange),
      estimatedDuration: data.dec(_f$estimatedDuration),
      bestTimeOfDay: data.dec(_f$bestTimeOfDay),
      tags: data.dec(_f$tags),
      popularityScore: data.dec(_f$popularityScore),
      timesBooked: data.dec(_f$timesBooked),
      averageRating: data.dec(_f$averageRating),
      imageUrl: data.dec(_f$imageUrl),
      location: data.dec(_f$location),
      activities: data.dec(_f$activities),
      tips: data.dec(_f$tips),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateIdea fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateIdea>(map);
  }

  static DateIdea fromJson(String json) {
    return ensureInitialized().decodeJson<DateIdea>(json);
  }
}

mixin DateIdeaMappable {
  String toJson() {
    return DateIdeaMapper.ensureInitialized().encodeJson<DateIdea>(
      this as DateIdea,
    );
  }

  Map<String, dynamic> toMap() {
    return DateIdeaMapper.ensureInitialized().encodeMap<DateIdea>(
      this as DateIdea,
    );
  }

  DateIdeaCopyWith<DateIdea, DateIdea, DateIdea> get copyWith =>
      _DateIdeaCopyWithImpl<DateIdea, DateIdea>(
        this as DateIdea,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DateIdeaMapper.ensureInitialized().stringifyValue(this as DateIdea);
  }

  @override
  bool operator ==(Object other) {
    return DateIdeaMapper.ensureInitialized().equalsValue(
      this as DateIdea,
      other,
    );
  }

  @override
  int get hashCode {
    return DateIdeaMapper.ensureInitialized().hashValue(this as DateIdea);
  }
}

extension DateIdeaValueCopy<$R, $Out> on ObjectCopyWith<$R, DateIdea, $Out> {
  DateIdeaCopyWith<$R, DateIdea, $Out> get $asDateIdea =>
      $base.as((v, t, t2) => _DateIdeaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DateIdeaCopyWith<$R, $In extends DateIdea, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get tags;
  DateLocationCopyWith<$R, DateLocation, DateLocation>? get location;
  ListCopyWith<
    $R,
    DateActivity,
    DateActivityCopyWith<$R, DateActivity, DateActivity>
  >
  get activities;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>> get tips;
  $R call({
    String? ideaId,
    String? title,
    String? description,
    DateCategory? category,
    DateVibe? vibe,
    PriceRange? priceRange,
    Duration? estimatedDuration,
    TimeOfDay? bestTimeOfDay,
    List<String>? tags,
    double? popularityScore,
    int? timesBooked,
    double? averageRating,
    String? imageUrl,
    DateLocation? location,
    List<DateActivity>? activities,
    Map<String, String>? tips,
    DateTime? createdAt,
  });
  DateIdeaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DateIdeaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateIdea, $Out>
    implements DateIdeaCopyWith<$R, DateIdea, $Out> {
  _DateIdeaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateIdea> $mapper =
      DateIdeaMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get tags =>
      ListCopyWith(
        $value.tags,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(tags: v),
      );
  @override
  DateLocationCopyWith<$R, DateLocation, DateLocation>? get location =>
      $value.location?.copyWith.$chain((v) => call(location: v));
  @override
  ListCopyWith<
    $R,
    DateActivity,
    DateActivityCopyWith<$R, DateActivity, DateActivity>
  >
  get activities => ListCopyWith(
    $value.activities,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(activities: v),
  );
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get tips => MapCopyWith(
    $value.tips,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(tips: v),
  );
  @override
  $R call({
    String? ideaId,
    String? title,
    String? description,
    DateCategory? category,
    DateVibe? vibe,
    PriceRange? priceRange,
    Duration? estimatedDuration,
    TimeOfDay? bestTimeOfDay,
    List<String>? tags,
    double? popularityScore,
    int? timesBooked,
    double? averageRating,
    Object? imageUrl = $none,
    Object? location = $none,
    List<DateActivity>? activities,
    Map<String, String>? tips,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (ideaId != null) #ideaId: ideaId,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (category != null) #category: category,
      if (vibe != null) #vibe: vibe,
      if (priceRange != null) #priceRange: priceRange,
      if (estimatedDuration != null) #estimatedDuration: estimatedDuration,
      if (bestTimeOfDay != null) #bestTimeOfDay: bestTimeOfDay,
      if (tags != null) #tags: tags,
      if (popularityScore != null) #popularityScore: popularityScore,
      if (timesBooked != null) #timesBooked: timesBooked,
      if (averageRating != null) #averageRating: averageRating,
      if (imageUrl != $none) #imageUrl: imageUrl,
      if (location != $none) #location: location,
      if (activities != null) #activities: activities,
      if (tips != null) #tips: tips,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  DateIdea $make(CopyWithData data) => DateIdea(
    ideaId: data.get(#ideaId, or: $value.ideaId),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    category: data.get(#category, or: $value.category),
    vibe: data.get(#vibe, or: $value.vibe),
    priceRange: data.get(#priceRange, or: $value.priceRange),
    estimatedDuration: data.get(
      #estimatedDuration,
      or: $value.estimatedDuration,
    ),
    bestTimeOfDay: data.get(#bestTimeOfDay, or: $value.bestTimeOfDay),
    tags: data.get(#tags, or: $value.tags),
    popularityScore: data.get(#popularityScore, or: $value.popularityScore),
    timesBooked: data.get(#timesBooked, or: $value.timesBooked),
    averageRating: data.get(#averageRating, or: $value.averageRating),
    imageUrl: data.get(#imageUrl, or: $value.imageUrl),
    location: data.get(#location, or: $value.location),
    activities: data.get(#activities, or: $value.activities),
    tips: data.get(#tips, or: $value.tips),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  DateIdeaCopyWith<$R2, DateIdea, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DateIdeaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DateLocationMapper extends ClassMapperBase<DateLocation> {
  DateLocationMapper._();

  static DateLocationMapper? _instance;
  static DateLocationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateLocationMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DateLocation';

  static String _$name(DateLocation v) => v.name;
  static const Field<DateLocation, String> _f$name = Field('name', _$name);
  static String _$address(DateLocation v) => v.address;
  static const Field<DateLocation, String> _f$address = Field(
    'address',
    _$address,
  );
  static LatLng _$coordinates(DateLocation v) => v.coordinates;
  static const Field<DateLocation, LatLng> _f$coordinates = Field(
    'coordinates',
    _$coordinates,
  );
  static String? _$phoneNumber(DateLocation v) => v.phoneNumber;
  static const Field<DateLocation, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
    opt: true,
  );
  static String? _$website(DateLocation v) => v.website;
  static const Field<DateLocation, String> _f$website = Field(
    'website',
    _$website,
    opt: true,
  );
  static Map<String, String> _$openingHours(DateLocation v) => v.openingHours;
  static const Field<DateLocation, Map<String, String>> _f$openingHours = Field(
    'openingHours',
    _$openingHours,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<DateLocation> fields = const {
    #name: _f$name,
    #address: _f$address,
    #coordinates: _f$coordinates,
    #phoneNumber: _f$phoneNumber,
    #website: _f$website,
    #openingHours: _f$openingHours,
  };

  static DateLocation _instantiate(DecodingData data) {
    return DateLocation(
      name: data.dec(_f$name),
      address: data.dec(_f$address),
      coordinates: data.dec(_f$coordinates),
      phoneNumber: data.dec(_f$phoneNumber),
      website: data.dec(_f$website),
      openingHours: data.dec(_f$openingHours),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateLocation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateLocation>(map);
  }

  static DateLocation fromJson(String json) {
    return ensureInitialized().decodeJson<DateLocation>(json);
  }
}

mixin DateLocationMappable {
  String toJson() {
    return DateLocationMapper.ensureInitialized().encodeJson<DateLocation>(
      this as DateLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return DateLocationMapper.ensureInitialized().encodeMap<DateLocation>(
      this as DateLocation,
    );
  }

  DateLocationCopyWith<DateLocation, DateLocation, DateLocation> get copyWith =>
      _DateLocationCopyWithImpl<DateLocation, DateLocation>(
        this as DateLocation,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DateLocationMapper.ensureInitialized().stringifyValue(
      this as DateLocation,
    );
  }

  @override
  bool operator ==(Object other) {
    return DateLocationMapper.ensureInitialized().equalsValue(
      this as DateLocation,
      other,
    );
  }

  @override
  int get hashCode {
    return DateLocationMapper.ensureInitialized().hashValue(
      this as DateLocation,
    );
  }
}

extension DateLocationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DateLocation, $Out> {
  DateLocationCopyWith<$R, DateLocation, $Out> get $asDateLocation =>
      $base.as((v, t, t2) => _DateLocationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DateLocationCopyWith<$R, $In extends DateLocation, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get openingHours;
  $R call({
    String? name,
    String? address,
    LatLng? coordinates,
    String? phoneNumber,
    String? website,
    Map<String, String>? openingHours,
  });
  DateLocationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DateLocationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateLocation, $Out>
    implements DateLocationCopyWith<$R, DateLocation, $Out> {
  _DateLocationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateLocation> $mapper =
      DateLocationMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get openingHours => MapCopyWith(
    $value.openingHours,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(openingHours: v),
  );
  @override
  $R call({
    String? name,
    String? address,
    LatLng? coordinates,
    Object? phoneNumber = $none,
    Object? website = $none,
    Map<String, String>? openingHours,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (address != null) #address: address,
      if (coordinates != null) #coordinates: coordinates,
      if (phoneNumber != $none) #phoneNumber: phoneNumber,
      if (website != $none) #website: website,
      if (openingHours != null) #openingHours: openingHours,
    }),
  );
  @override
  DateLocation $make(CopyWithData data) => DateLocation(
    name: data.get(#name, or: $value.name),
    address: data.get(#address, or: $value.address),
    coordinates: data.get(#coordinates, or: $value.coordinates),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
    website: data.get(#website, or: $value.website),
    openingHours: data.get(#openingHours, or: $value.openingHours),
  );

  @override
  DateLocationCopyWith<$R2, DateLocation, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DateLocationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DateActivityMapper extends ClassMapperBase<DateActivity> {
  DateActivityMapper._();

  static DateActivityMapper? _instance;
  static DateActivityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateActivityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DateActivity';

  static String _$activityId(DateActivity v) => v.activityId;
  static const Field<DateActivity, String> _f$activityId = Field(
    'activityId',
    _$activityId,
  );
  static String _$name(DateActivity v) => v.name;
  static const Field<DateActivity, String> _f$name = Field('name', _$name);
  static String _$description(DateActivity v) => v.description;
  static const Field<DateActivity, String> _f$description = Field(
    'description',
    _$description,
  );
  static Duration _$duration(DateActivity v) => v.duration;
  static const Field<DateActivity, Duration> _f$duration = Field(
    'duration',
    _$duration,
  );
  static int _$order(DateActivity v) => v.order;
  static const Field<DateActivity, int> _f$order = Field('order', _$order);

  @override
  final MappableFields<DateActivity> fields = const {
    #activityId: _f$activityId,
    #name: _f$name,
    #description: _f$description,
    #duration: _f$duration,
    #order: _f$order,
  };

  static DateActivity _instantiate(DecodingData data) {
    return DateActivity(
      activityId: data.dec(_f$activityId),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      duration: data.dec(_f$duration),
      order: data.dec(_f$order),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateActivity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateActivity>(map);
  }

  static DateActivity fromJson(String json) {
    return ensureInitialized().decodeJson<DateActivity>(json);
  }
}

mixin DateActivityMappable {
  String toJson() {
    return DateActivityMapper.ensureInitialized().encodeJson<DateActivity>(
      this as DateActivity,
    );
  }

  Map<String, dynamic> toMap() {
    return DateActivityMapper.ensureInitialized().encodeMap<DateActivity>(
      this as DateActivity,
    );
  }

  DateActivityCopyWith<DateActivity, DateActivity, DateActivity> get copyWith =>
      _DateActivityCopyWithImpl<DateActivity, DateActivity>(
        this as DateActivity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DateActivityMapper.ensureInitialized().stringifyValue(
      this as DateActivity,
    );
  }

  @override
  bool operator ==(Object other) {
    return DateActivityMapper.ensureInitialized().equalsValue(
      this as DateActivity,
      other,
    );
  }

  @override
  int get hashCode {
    return DateActivityMapper.ensureInitialized().hashValue(
      this as DateActivity,
    );
  }
}

extension DateActivityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DateActivity, $Out> {
  DateActivityCopyWith<$R, DateActivity, $Out> get $asDateActivity =>
      $base.as((v, t, t2) => _DateActivityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DateActivityCopyWith<$R, $In extends DateActivity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? activityId,
    String? name,
    String? description,
    Duration? duration,
    int? order,
  });
  DateActivityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DateActivityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateActivity, $Out>
    implements DateActivityCopyWith<$R, DateActivity, $Out> {
  _DateActivityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateActivity> $mapper =
      DateActivityMapper.ensureInitialized();
  @override
  $R call({
    String? activityId,
    String? name,
    String? description,
    Duration? duration,
    int? order,
  }) => $apply(
    FieldCopyWithData({
      if (activityId != null) #activityId: activityId,
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (duration != null) #duration: duration,
      if (order != null) #order: order,
    }),
  );
  @override
  DateActivity $make(CopyWithData data) => DateActivity(
    activityId: data.get(#activityId, or: $value.activityId),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    duration: data.get(#duration, or: $value.duration),
    order: data.get(#order, or: $value.order),
  );

  @override
  DateActivityCopyWith<$R2, DateActivity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DateActivityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PersonalizedDateSuggestionMapper
    extends ClassMapperBase<PersonalizedDateSuggestion> {
  PersonalizedDateSuggestionMapper._();

  static PersonalizedDateSuggestionMapper? _instance;
  static PersonalizedDateSuggestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PersonalizedDateSuggestionMapper._(),
      );
      DateIdeaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PersonalizedDateSuggestion';

  static String _$suggestionId(PersonalizedDateSuggestion v) => v.suggestionId;
  static const Field<PersonalizedDateSuggestion, String> _f$suggestionId =
      Field('suggestionId', _$suggestionId);
  static String _$userId1(PersonalizedDateSuggestion v) => v.userId1;
  static const Field<PersonalizedDateSuggestion, String> _f$userId1 = Field(
    'userId1',
    _$userId1,
  );
  static String _$userId2(PersonalizedDateSuggestion v) => v.userId2;
  static const Field<PersonalizedDateSuggestion, String> _f$userId2 = Field(
    'userId2',
    _$userId2,
  );
  static DateIdea _$dateIdea(PersonalizedDateSuggestion v) => v.dateIdea;
  static const Field<PersonalizedDateSuggestion, DateIdea> _f$dateIdea = Field(
    'dateIdea',
    _$dateIdea,
  );
  static double _$compatibilityScore(PersonalizedDateSuggestion v) =>
      v.compatibilityScore;
  static const Field<PersonalizedDateSuggestion, double> _f$compatibilityScore =
      Field('compatibilityScore', _$compatibilityScore);
  static List<String> _$whyThisWorks(PersonalizedDateSuggestion v) =>
      v.whyThisWorks;
  static const Field<PersonalizedDateSuggestion, List<String>> _f$whyThisWorks =
      Field('whyThisWorks', _$whyThisWorks);
  static DateTime _$suggestedDate(PersonalizedDateSuggestion v) =>
      v.suggestedDate;
  static const Field<PersonalizedDateSuggestion, DateTime> _f$suggestedDate =
      Field('suggestedDate', _$suggestedDate);
  static String? _$suggestedTime(PersonalizedDateSuggestion v) =>
      v.suggestedTime;
  static const Field<PersonalizedDateSuggestion, String> _f$suggestedTime =
      Field('suggestedTime', _$suggestedTime, opt: true);
  static bool _$isAIGenerated(PersonalizedDateSuggestion v) => v.isAIGenerated;
  static const Field<PersonalizedDateSuggestion, bool> _f$isAIGenerated = Field(
    'isAIGenerated',
    _$isAIGenerated,
    opt: true,
    def: false,
  );
  static DateTime _$createdAt(PersonalizedDateSuggestion v) => v.createdAt;
  static const Field<PersonalizedDateSuggestion, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<PersonalizedDateSuggestion> fields = const {
    #suggestionId: _f$suggestionId,
    #userId1: _f$userId1,
    #userId2: _f$userId2,
    #dateIdea: _f$dateIdea,
    #compatibilityScore: _f$compatibilityScore,
    #whyThisWorks: _f$whyThisWorks,
    #suggestedDate: _f$suggestedDate,
    #suggestedTime: _f$suggestedTime,
    #isAIGenerated: _f$isAIGenerated,
    #createdAt: _f$createdAt,
  };

  static PersonalizedDateSuggestion _instantiate(DecodingData data) {
    return PersonalizedDateSuggestion(
      suggestionId: data.dec(_f$suggestionId),
      userId1: data.dec(_f$userId1),
      userId2: data.dec(_f$userId2),
      dateIdea: data.dec(_f$dateIdea),
      compatibilityScore: data.dec(_f$compatibilityScore),
      whyThisWorks: data.dec(_f$whyThisWorks),
      suggestedDate: data.dec(_f$suggestedDate),
      suggestedTime: data.dec(_f$suggestedTime),
      isAIGenerated: data.dec(_f$isAIGenerated),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PersonalizedDateSuggestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PersonalizedDateSuggestion>(map);
  }

  static PersonalizedDateSuggestion fromJson(String json) {
    return ensureInitialized().decodeJson<PersonalizedDateSuggestion>(json);
  }
}

mixin PersonalizedDateSuggestionMappable {
  String toJson() {
    return PersonalizedDateSuggestionMapper.ensureInitialized()
        .encodeJson<PersonalizedDateSuggestion>(
          this as PersonalizedDateSuggestion,
        );
  }

  Map<String, dynamic> toMap() {
    return PersonalizedDateSuggestionMapper.ensureInitialized()
        .encodeMap<PersonalizedDateSuggestion>(
          this as PersonalizedDateSuggestion,
        );
  }

  PersonalizedDateSuggestionCopyWith<
    PersonalizedDateSuggestion,
    PersonalizedDateSuggestion,
    PersonalizedDateSuggestion
  >
  get copyWith =>
      _PersonalizedDateSuggestionCopyWithImpl<
        PersonalizedDateSuggestion,
        PersonalizedDateSuggestion
      >(this as PersonalizedDateSuggestion, $identity, $identity);
  @override
  String toString() {
    return PersonalizedDateSuggestionMapper.ensureInitialized().stringifyValue(
      this as PersonalizedDateSuggestion,
    );
  }

  @override
  bool operator ==(Object other) {
    return PersonalizedDateSuggestionMapper.ensureInitialized().equalsValue(
      this as PersonalizedDateSuggestion,
      other,
    );
  }

  @override
  int get hashCode {
    return PersonalizedDateSuggestionMapper.ensureInitialized().hashValue(
      this as PersonalizedDateSuggestion,
    );
  }
}

extension PersonalizedDateSuggestionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PersonalizedDateSuggestion, $Out> {
  PersonalizedDateSuggestionCopyWith<$R, PersonalizedDateSuggestion, $Out>
  get $asPersonalizedDateSuggestion => $base.as(
    (v, t, t2) => _PersonalizedDateSuggestionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PersonalizedDateSuggestionCopyWith<
  $R,
  $In extends PersonalizedDateSuggestion,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  DateIdeaCopyWith<$R, DateIdea, DateIdea> get dateIdea;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get whyThisWorks;
  $R call({
    String? suggestionId,
    String? userId1,
    String? userId2,
    DateIdea? dateIdea,
    double? compatibilityScore,
    List<String>? whyThisWorks,
    DateTime? suggestedDate,
    String? suggestedTime,
    bool? isAIGenerated,
    DateTime? createdAt,
  });
  PersonalizedDateSuggestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PersonalizedDateSuggestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PersonalizedDateSuggestion, $Out>
    implements
        PersonalizedDateSuggestionCopyWith<
          $R,
          PersonalizedDateSuggestion,
          $Out
        > {
  _PersonalizedDateSuggestionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PersonalizedDateSuggestion> $mapper =
      PersonalizedDateSuggestionMapper.ensureInitialized();
  @override
  DateIdeaCopyWith<$R, DateIdea, DateIdea> get dateIdea =>
      $value.dateIdea.copyWith.$chain((v) => call(dateIdea: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get whyThisWorks => ListCopyWith(
    $value.whyThisWorks,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(whyThisWorks: v),
  );
  @override
  $R call({
    String? suggestionId,
    String? userId1,
    String? userId2,
    DateIdea? dateIdea,
    double? compatibilityScore,
    List<String>? whyThisWorks,
    DateTime? suggestedDate,
    Object? suggestedTime = $none,
    bool? isAIGenerated,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (suggestionId != null) #suggestionId: suggestionId,
      if (userId1 != null) #userId1: userId1,
      if (userId2 != null) #userId2: userId2,
      if (dateIdea != null) #dateIdea: dateIdea,
      if (compatibilityScore != null) #compatibilityScore: compatibilityScore,
      if (whyThisWorks != null) #whyThisWorks: whyThisWorks,
      if (suggestedDate != null) #suggestedDate: suggestedDate,
      if (suggestedTime != $none) #suggestedTime: suggestedTime,
      if (isAIGenerated != null) #isAIGenerated: isAIGenerated,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  PersonalizedDateSuggestion $make(CopyWithData data) =>
      PersonalizedDateSuggestion(
        suggestionId: data.get(#suggestionId, or: $value.suggestionId),
        userId1: data.get(#userId1, or: $value.userId1),
        userId2: data.get(#userId2, or: $value.userId2),
        dateIdea: data.get(#dateIdea, or: $value.dateIdea),
        compatibilityScore: data.get(
          #compatibilityScore,
          or: $value.compatibilityScore,
        ),
        whyThisWorks: data.get(#whyThisWorks, or: $value.whyThisWorks),
        suggestedDate: data.get(#suggestedDate, or: $value.suggestedDate),
        suggestedTime: data.get(#suggestedTime, or: $value.suggestedTime),
        isAIGenerated: data.get(#isAIGenerated, or: $value.isAIGenerated),
        createdAt: data.get(#createdAt, or: $value.createdAt),
      );

  @override
  PersonalizedDateSuggestionCopyWith<$R2, PersonalizedDateSuggestion, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PersonalizedDateSuggestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DateIdeaFiltersMapper extends ClassMapperBase<DateIdeaFilters> {
  DateIdeaFiltersMapper._();

  static DateIdeaFiltersMapper? _instance;
  static DateIdeaFiltersMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateIdeaFiltersMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DateIdeaFilters';

  static Set<DateCategory> _$categories(DateIdeaFilters v) => v.categories;
  static const Field<DateIdeaFilters, Set<DateCategory>> _f$categories = Field(
    'categories',
    _$categories,
    opt: true,
    def: const {},
  );
  static Set<DateVibe> _$vibes(DateIdeaFilters v) => v.vibes;
  static const Field<DateIdeaFilters, Set<DateVibe>> _f$vibes = Field(
    'vibes',
    _$vibes,
    opt: true,
    def: const {},
  );
  static Set<PriceRange> _$priceRanges(DateIdeaFilters v) => v.priceRanges;
  static const Field<DateIdeaFilters, Set<PriceRange>> _f$priceRanges = Field(
    'priceRanges',
    _$priceRanges,
    opt: true,
    def: const {},
  );
  static Set<TimeOfDay> _$timesOfDay(DateIdeaFilters v) => v.timesOfDay;
  static const Field<DateIdeaFilters, Set<TimeOfDay>> _f$timesOfDay = Field(
    'timesOfDay',
    _$timesOfDay,
    opt: true,
    def: const {},
  );
  static double? _$maxDistance(DateIdeaFilters v) => v.maxDistance;
  static const Field<DateIdeaFilters, double> _f$maxDistance = Field(
    'maxDistance',
    _$maxDistance,
    opt: true,
  );
  static bool _$firstDateOnly(DateIdeaFilters v) => v.firstDateOnly;
  static const Field<DateIdeaFilters, bool> _f$firstDateOnly = Field(
    'firstDateOnly',
    _$firstDateOnly,
    opt: true,
    def: false,
  );
  static bool _$outdoorOnly(DateIdeaFilters v) => v.outdoorOnly;
  static const Field<DateIdeaFilters, bool> _f$outdoorOnly = Field(
    'outdoorOnly',
    _$outdoorOnly,
    opt: true,
    def: false,
  );
  static bool _$indoorOnly(DateIdeaFilters v) => v.indoorOnly;
  static const Field<DateIdeaFilters, bool> _f$indoorOnly = Field(
    'indoorOnly',
    _$indoorOnly,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<DateIdeaFilters> fields = const {
    #categories: _f$categories,
    #vibes: _f$vibes,
    #priceRanges: _f$priceRanges,
    #timesOfDay: _f$timesOfDay,
    #maxDistance: _f$maxDistance,
    #firstDateOnly: _f$firstDateOnly,
    #outdoorOnly: _f$outdoorOnly,
    #indoorOnly: _f$indoorOnly,
  };

  static DateIdeaFilters _instantiate(DecodingData data) {
    return DateIdeaFilters(
      categories: data.dec(_f$categories),
      vibes: data.dec(_f$vibes),
      priceRanges: data.dec(_f$priceRanges),
      timesOfDay: data.dec(_f$timesOfDay),
      maxDistance: data.dec(_f$maxDistance),
      firstDateOnly: data.dec(_f$firstDateOnly),
      outdoorOnly: data.dec(_f$outdoorOnly),
      indoorOnly: data.dec(_f$indoorOnly),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateIdeaFilters fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateIdeaFilters>(map);
  }

  static DateIdeaFilters fromJson(String json) {
    return ensureInitialized().decodeJson<DateIdeaFilters>(json);
  }
}

mixin DateIdeaFiltersMappable {
  String toJson() {
    return DateIdeaFiltersMapper.ensureInitialized()
        .encodeJson<DateIdeaFilters>(this as DateIdeaFilters);
  }

  Map<String, dynamic> toMap() {
    return DateIdeaFiltersMapper.ensureInitialized().encodeMap<DateIdeaFilters>(
      this as DateIdeaFilters,
    );
  }

  DateIdeaFiltersCopyWith<DateIdeaFilters, DateIdeaFilters, DateIdeaFilters>
  get copyWith =>
      _DateIdeaFiltersCopyWithImpl<DateIdeaFilters, DateIdeaFilters>(
        this as DateIdeaFilters,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DateIdeaFiltersMapper.ensureInitialized().stringifyValue(
      this as DateIdeaFilters,
    );
  }

  @override
  bool operator ==(Object other) {
    return DateIdeaFiltersMapper.ensureInitialized().equalsValue(
      this as DateIdeaFilters,
      other,
    );
  }

  @override
  int get hashCode {
    return DateIdeaFiltersMapper.ensureInitialized().hashValue(
      this as DateIdeaFilters,
    );
  }
}

extension DateIdeaFiltersValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DateIdeaFilters, $Out> {
  DateIdeaFiltersCopyWith<$R, DateIdeaFilters, $Out> get $asDateIdeaFilters =>
      $base.as((v, t, t2) => _DateIdeaFiltersCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DateIdeaFiltersCopyWith<$R, $In extends DateIdeaFilters, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Set<DateCategory>? categories,
    Set<DateVibe>? vibes,
    Set<PriceRange>? priceRanges,
    Set<TimeOfDay>? timesOfDay,
    double? maxDistance,
    bool? firstDateOnly,
    bool? outdoorOnly,
    bool? indoorOnly,
  });
  DateIdeaFiltersCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DateIdeaFiltersCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateIdeaFilters, $Out>
    implements DateIdeaFiltersCopyWith<$R, DateIdeaFilters, $Out> {
  _DateIdeaFiltersCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateIdeaFilters> $mapper =
      DateIdeaFiltersMapper.ensureInitialized();
  @override
  $R call({
    Set<DateCategory>? categories,
    Set<DateVibe>? vibes,
    Set<PriceRange>? priceRanges,
    Set<TimeOfDay>? timesOfDay,
    Object? maxDistance = $none,
    bool? firstDateOnly,
    bool? outdoorOnly,
    bool? indoorOnly,
  }) => $apply(
    FieldCopyWithData({
      if (categories != null) #categories: categories,
      if (vibes != null) #vibes: vibes,
      if (priceRanges != null) #priceRanges: priceRanges,
      if (timesOfDay != null) #timesOfDay: timesOfDay,
      if (maxDistance != $none) #maxDistance: maxDistance,
      if (firstDateOnly != null) #firstDateOnly: firstDateOnly,
      if (outdoorOnly != null) #outdoorOnly: outdoorOnly,
      if (indoorOnly != null) #indoorOnly: indoorOnly,
    }),
  );
  @override
  DateIdeaFilters $make(CopyWithData data) => DateIdeaFilters(
    categories: data.get(#categories, or: $value.categories),
    vibes: data.get(#vibes, or: $value.vibes),
    priceRanges: data.get(#priceRanges, or: $value.priceRanges),
    timesOfDay: data.get(#timesOfDay, or: $value.timesOfDay),
    maxDistance: data.get(#maxDistance, or: $value.maxDistance),
    firstDateOnly: data.get(#firstDateOnly, or: $value.firstDateOnly),
    outdoorOnly: data.get(#outdoorOnly, or: $value.outdoorOnly),
    indoorOnly: data.get(#indoorOnly, or: $value.indoorOnly),
  );

  @override
  DateIdeaFiltersCopyWith<$R2, DateIdeaFilters, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DateIdeaFiltersCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DateIdeaFeedbackMapper extends ClassMapperBase<DateIdeaFeedback> {
  DateIdeaFeedbackMapper._();

  static DateIdeaFeedbackMapper? _instance;
  static DateIdeaFeedbackMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateIdeaFeedbackMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DateIdeaFeedback';

  static String _$feedbackId(DateIdeaFeedback v) => v.feedbackId;
  static const Field<DateIdeaFeedback, String> _f$feedbackId = Field(
    'feedbackId',
    _$feedbackId,
  );
  static String _$userId(DateIdeaFeedback v) => v.userId;
  static const Field<DateIdeaFeedback, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$ideaId(DateIdeaFeedback v) => v.ideaId;
  static const Field<DateIdeaFeedback, String> _f$ideaId = Field(
    'ideaId',
    _$ideaId,
  );
  static double _$rating(DateIdeaFeedback v) => v.rating;
  static const Field<DateIdeaFeedback, double> _f$rating = Field(
    'rating',
    _$rating,
  );
  static bool _$wasUsed(DateIdeaFeedback v) => v.wasUsed;
  static const Field<DateIdeaFeedback, bool> _f$wasUsed = Field(
    'wasUsed',
    _$wasUsed,
    opt: true,
    def: false,
  );
  static String? _$review(DateIdeaFeedback v) => v.review;
  static const Field<DateIdeaFeedback, String> _f$review = Field(
    'review',
    _$review,
    opt: true,
  );
  static List<String> _$pros(DateIdeaFeedback v) => v.pros;
  static const Field<DateIdeaFeedback, List<String>> _f$pros = Field(
    'pros',
    _$pros,
    opt: true,
    def: const [],
  );
  static List<String> _$cons(DateIdeaFeedback v) => v.cons;
  static const Field<DateIdeaFeedback, List<String>> _f$cons = Field(
    'cons',
    _$cons,
    opt: true,
    def: const [],
  );
  static DateTime _$createdAt(DateIdeaFeedback v) => v.createdAt;
  static const Field<DateIdeaFeedback, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<DateIdeaFeedback> fields = const {
    #feedbackId: _f$feedbackId,
    #userId: _f$userId,
    #ideaId: _f$ideaId,
    #rating: _f$rating,
    #wasUsed: _f$wasUsed,
    #review: _f$review,
    #pros: _f$pros,
    #cons: _f$cons,
    #createdAt: _f$createdAt,
  };

  static DateIdeaFeedback _instantiate(DecodingData data) {
    return DateIdeaFeedback(
      feedbackId: data.dec(_f$feedbackId),
      userId: data.dec(_f$userId),
      ideaId: data.dec(_f$ideaId),
      rating: data.dec(_f$rating),
      wasUsed: data.dec(_f$wasUsed),
      review: data.dec(_f$review),
      pros: data.dec(_f$pros),
      cons: data.dec(_f$cons),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateIdeaFeedback fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateIdeaFeedback>(map);
  }

  static DateIdeaFeedback fromJson(String json) {
    return ensureInitialized().decodeJson<DateIdeaFeedback>(json);
  }
}

mixin DateIdeaFeedbackMappable {
  String toJson() {
    return DateIdeaFeedbackMapper.ensureInitialized()
        .encodeJson<DateIdeaFeedback>(this as DateIdeaFeedback);
  }

  Map<String, dynamic> toMap() {
    return DateIdeaFeedbackMapper.ensureInitialized()
        .encodeMap<DateIdeaFeedback>(this as DateIdeaFeedback);
  }

  DateIdeaFeedbackCopyWith<DateIdeaFeedback, DateIdeaFeedback, DateIdeaFeedback>
  get copyWith =>
      _DateIdeaFeedbackCopyWithImpl<DateIdeaFeedback, DateIdeaFeedback>(
        this as DateIdeaFeedback,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DateIdeaFeedbackMapper.ensureInitialized().stringifyValue(
      this as DateIdeaFeedback,
    );
  }

  @override
  bool operator ==(Object other) {
    return DateIdeaFeedbackMapper.ensureInitialized().equalsValue(
      this as DateIdeaFeedback,
      other,
    );
  }

  @override
  int get hashCode {
    return DateIdeaFeedbackMapper.ensureInitialized().hashValue(
      this as DateIdeaFeedback,
    );
  }
}

extension DateIdeaFeedbackValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DateIdeaFeedback, $Out> {
  DateIdeaFeedbackCopyWith<$R, DateIdeaFeedback, $Out>
  get $asDateIdeaFeedback =>
      $base.as((v, t, t2) => _DateIdeaFeedbackCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DateIdeaFeedbackCopyWith<$R, $In extends DateIdeaFeedback, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get pros;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get cons;
  $R call({
    String? feedbackId,
    String? userId,
    String? ideaId,
    double? rating,
    bool? wasUsed,
    String? review,
    List<String>? pros,
    List<String>? cons,
    DateTime? createdAt,
  });
  DateIdeaFeedbackCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DateIdeaFeedbackCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateIdeaFeedback, $Out>
    implements DateIdeaFeedbackCopyWith<$R, DateIdeaFeedback, $Out> {
  _DateIdeaFeedbackCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateIdeaFeedback> $mapper =
      DateIdeaFeedbackMapper.ensureInitialized();
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
    String? feedbackId,
    String? userId,
    String? ideaId,
    double? rating,
    bool? wasUsed,
    Object? review = $none,
    List<String>? pros,
    List<String>? cons,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (feedbackId != null) #feedbackId: feedbackId,
      if (userId != null) #userId: userId,
      if (ideaId != null) #ideaId: ideaId,
      if (rating != null) #rating: rating,
      if (wasUsed != null) #wasUsed: wasUsed,
      if (review != $none) #review: review,
      if (pros != null) #pros: pros,
      if (cons != null) #cons: cons,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  DateIdeaFeedback $make(CopyWithData data) => DateIdeaFeedback(
    feedbackId: data.get(#feedbackId, or: $value.feedbackId),
    userId: data.get(#userId, or: $value.userId),
    ideaId: data.get(#ideaId, or: $value.ideaId),
    rating: data.get(#rating, or: $value.rating),
    wasUsed: data.get(#wasUsed, or: $value.wasUsed),
    review: data.get(#review, or: $value.review),
    pros: data.get(#pros, or: $value.pros),
    cons: data.get(#cons, or: $value.cons),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  DateIdeaFeedbackCopyWith<$R2, DateIdeaFeedback, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DateIdeaFeedbackCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DateItineraryMapper extends ClassMapperBase<DateItinerary> {
  DateItineraryMapper._();

  static DateItineraryMapper? _instance;
  static DateItineraryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateItineraryMapper._());
      DateIdeaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DateItinerary';

  static String _$itineraryId(DateItinerary v) => v.itineraryId;
  static const Field<DateItinerary, String> _f$itineraryId = Field(
    'itineraryId',
    _$itineraryId,
  );
  static String _$title(DateItinerary v) => v.title;
  static const Field<DateItinerary, String> _f$title = Field('title', _$title);
  static List<DateIdea> _$ideas(DateItinerary v) => v.ideas;
  static const Field<DateItinerary, List<DateIdea>> _f$ideas = Field(
    'ideas',
    _$ideas,
  );
  static Duration _$totalDuration(DateItinerary v) => v.totalDuration;
  static const Field<DateItinerary, Duration> _f$totalDuration = Field(
    'totalDuration',
    _$totalDuration,
  );
  static PriceRange _$estimatedCost(DateItinerary v) => v.estimatedCost;
  static const Field<DateItinerary, PriceRange> _f$estimatedCost = Field(
    'estimatedCost',
    _$estimatedCost,
  );
  static String? _$transportationNotes(DateItinerary v) =>
      v.transportationNotes;
  static const Field<DateItinerary, String> _f$transportationNotes = Field(
    'transportationNotes',
    _$transportationNotes,
    opt: true,
  );
  static List<String> _$packingList(DateItinerary v) => v.packingList;
  static const Field<DateItinerary, List<String>> _f$packingList = Field(
    'packingList',
    _$packingList,
    opt: true,
    def: const [],
  );
  static Map<String, String> _$reservations(DateItinerary v) => v.reservations;
  static const Field<DateItinerary, Map<String, String>> _f$reservations =
      Field('reservations', _$reservations, opt: true, def: const {});

  @override
  final MappableFields<DateItinerary> fields = const {
    #itineraryId: _f$itineraryId,
    #title: _f$title,
    #ideas: _f$ideas,
    #totalDuration: _f$totalDuration,
    #estimatedCost: _f$estimatedCost,
    #transportationNotes: _f$transportationNotes,
    #packingList: _f$packingList,
    #reservations: _f$reservations,
  };

  static DateItinerary _instantiate(DecodingData data) {
    return DateItinerary(
      itineraryId: data.dec(_f$itineraryId),
      title: data.dec(_f$title),
      ideas: data.dec(_f$ideas),
      totalDuration: data.dec(_f$totalDuration),
      estimatedCost: data.dec(_f$estimatedCost),
      transportationNotes: data.dec(_f$transportationNotes),
      packingList: data.dec(_f$packingList),
      reservations: data.dec(_f$reservations),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateItinerary fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateItinerary>(map);
  }

  static DateItinerary fromJson(String json) {
    return ensureInitialized().decodeJson<DateItinerary>(json);
  }
}

mixin DateItineraryMappable {
  String toJson() {
    return DateItineraryMapper.ensureInitialized().encodeJson<DateItinerary>(
      this as DateItinerary,
    );
  }

  Map<String, dynamic> toMap() {
    return DateItineraryMapper.ensureInitialized().encodeMap<DateItinerary>(
      this as DateItinerary,
    );
  }

  DateItineraryCopyWith<DateItinerary, DateItinerary, DateItinerary>
  get copyWith => _DateItineraryCopyWithImpl<DateItinerary, DateItinerary>(
    this as DateItinerary,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return DateItineraryMapper.ensureInitialized().stringifyValue(
      this as DateItinerary,
    );
  }

  @override
  bool operator ==(Object other) {
    return DateItineraryMapper.ensureInitialized().equalsValue(
      this as DateItinerary,
      other,
    );
  }

  @override
  int get hashCode {
    return DateItineraryMapper.ensureInitialized().hashValue(
      this as DateItinerary,
    );
  }
}

extension DateItineraryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DateItinerary, $Out> {
  DateItineraryCopyWith<$R, DateItinerary, $Out> get $asDateItinerary =>
      $base.as((v, t, t2) => _DateItineraryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DateItineraryCopyWith<$R, $In extends DateItinerary, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, DateIdea, DateIdeaCopyWith<$R, DateIdea, DateIdea>>
  get ideas;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get packingList;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get reservations;
  $R call({
    String? itineraryId,
    String? title,
    List<DateIdea>? ideas,
    Duration? totalDuration,
    PriceRange? estimatedCost,
    String? transportationNotes,
    List<String>? packingList,
    Map<String, String>? reservations,
  });
  DateItineraryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DateItineraryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateItinerary, $Out>
    implements DateItineraryCopyWith<$R, DateItinerary, $Out> {
  _DateItineraryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateItinerary> $mapper =
      DateItineraryMapper.ensureInitialized();
  @override
  ListCopyWith<$R, DateIdea, DateIdeaCopyWith<$R, DateIdea, DateIdea>>
  get ideas => ListCopyWith(
    $value.ideas,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(ideas: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get packingList => ListCopyWith(
    $value.packingList,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(packingList: v),
  );
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get reservations => MapCopyWith(
    $value.reservations,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(reservations: v),
  );
  @override
  $R call({
    String? itineraryId,
    String? title,
    List<DateIdea>? ideas,
    Duration? totalDuration,
    PriceRange? estimatedCost,
    Object? transportationNotes = $none,
    List<String>? packingList,
    Map<String, String>? reservations,
  }) => $apply(
    FieldCopyWithData({
      if (itineraryId != null) #itineraryId: itineraryId,
      if (title != null) #title: title,
      if (ideas != null) #ideas: ideas,
      if (totalDuration != null) #totalDuration: totalDuration,
      if (estimatedCost != null) #estimatedCost: estimatedCost,
      if (transportationNotes != $none)
        #transportationNotes: transportationNotes,
      if (packingList != null) #packingList: packingList,
      if (reservations != null) #reservations: reservations,
    }),
  );
  @override
  DateItinerary $make(CopyWithData data) => DateItinerary(
    itineraryId: data.get(#itineraryId, or: $value.itineraryId),
    title: data.get(#title, or: $value.title),
    ideas: data.get(#ideas, or: $value.ideas),
    totalDuration: data.get(#totalDuration, or: $value.totalDuration),
    estimatedCost: data.get(#estimatedCost, or: $value.estimatedCost),
    transportationNotes: data.get(
      #transportationNotes,
      or: $value.transportationNotes,
    ),
    packingList: data.get(#packingList, or: $value.packingList),
    reservations: data.get(#reservations, or: $value.reservations),
  );

  @override
  DateItineraryCopyWith<$R2, DateItinerary, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DateItineraryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DateTemplateMapper extends ClassMapperBase<DateTemplate> {
  DateTemplateMapper._();

  static DateTemplateMapper? _instance;
  static DateTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateTemplateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DateTemplate';

  static String _$templateId(DateTemplate v) => v.templateId;
  static const Field<DateTemplate, String> _f$templateId = Field(
    'templateId',
    _$templateId,
  );
  static String _$name(DateTemplate v) => v.name;
  static const Field<DateTemplate, String> _f$name = Field('name', _$name);
  static String _$description(DateTemplate v) => v.description;
  static const Field<DateTemplate, String> _f$description = Field(
    'description',
    _$description,
  );
  static DateTheme _$theme(DateTemplate v) => v.theme;
  static const Field<DateTemplate, DateTheme> _f$theme = Field(
    'theme',
    _$theme,
  );
  static List<String> _$requiredCategories(DateTemplate v) =>
      v.requiredCategories;
  static const Field<DateTemplate, List<String>> _f$requiredCategories = Field(
    'requiredCategories',
    _$requiredCategories,
  );
  static int _$minActivities(DateTemplate v) => v.minActivities;
  static const Field<DateTemplate, int> _f$minActivities = Field(
    'minActivities',
    _$minActivities,
    opt: true,
    def: 2,
  );
  static int _$maxActivities(DateTemplate v) => v.maxActivities;
  static const Field<DateTemplate, int> _f$maxActivities = Field(
    'maxActivities',
    _$maxActivities,
    opt: true,
    def: 4,
  );
  static Duration _$targetDuration(DateTemplate v) => v.targetDuration;
  static const Field<DateTemplate, Duration> _f$targetDuration = Field(
    'targetDuration',
    _$targetDuration,
  );

  @override
  final MappableFields<DateTemplate> fields = const {
    #templateId: _f$templateId,
    #name: _f$name,
    #description: _f$description,
    #theme: _f$theme,
    #requiredCategories: _f$requiredCategories,
    #minActivities: _f$minActivities,
    #maxActivities: _f$maxActivities,
    #targetDuration: _f$targetDuration,
  };

  static DateTemplate _instantiate(DecodingData data) {
    return DateTemplate(
      templateId: data.dec(_f$templateId),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      theme: data.dec(_f$theme),
      requiredCategories: data.dec(_f$requiredCategories),
      minActivities: data.dec(_f$minActivities),
      maxActivities: data.dec(_f$maxActivities),
      targetDuration: data.dec(_f$targetDuration),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateTemplate>(map);
  }

  static DateTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<DateTemplate>(json);
  }
}

mixin DateTemplateMappable {
  String toJson() {
    return DateTemplateMapper.ensureInitialized().encodeJson<DateTemplate>(
      this as DateTemplate,
    );
  }

  Map<String, dynamic> toMap() {
    return DateTemplateMapper.ensureInitialized().encodeMap<DateTemplate>(
      this as DateTemplate,
    );
  }

  DateTemplateCopyWith<DateTemplate, DateTemplate, DateTemplate> get copyWith =>
      _DateTemplateCopyWithImpl<DateTemplate, DateTemplate>(
        this as DateTemplate,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DateTemplateMapper.ensureInitialized().stringifyValue(
      this as DateTemplate,
    );
  }

  @override
  bool operator ==(Object other) {
    return DateTemplateMapper.ensureInitialized().equalsValue(
      this as DateTemplate,
      other,
    );
  }

  @override
  int get hashCode {
    return DateTemplateMapper.ensureInitialized().hashValue(
      this as DateTemplate,
    );
  }
}

extension DateTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DateTemplate, $Out> {
  DateTemplateCopyWith<$R, DateTemplate, $Out> get $asDateTemplate =>
      $base.as((v, t, t2) => _DateTemplateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DateTemplateCopyWith<$R, $In extends DateTemplate, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get requiredCategories;
  $R call({
    String? templateId,
    String? name,
    String? description,
    DateTheme? theme,
    List<String>? requiredCategories,
    int? minActivities,
    int? maxActivities,
    Duration? targetDuration,
  });
  DateTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DateTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateTemplate, $Out>
    implements DateTemplateCopyWith<$R, DateTemplate, $Out> {
  _DateTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateTemplate> $mapper =
      DateTemplateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get requiredCategories => ListCopyWith(
    $value.requiredCategories,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(requiredCategories: v),
  );
  @override
  $R call({
    String? templateId,
    String? name,
    String? description,
    DateTheme? theme,
    List<String>? requiredCategories,
    int? minActivities,
    int? maxActivities,
    Duration? targetDuration,
  }) => $apply(
    FieldCopyWithData({
      if (templateId != null) #templateId: templateId,
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (theme != null) #theme: theme,
      if (requiredCategories != null) #requiredCategories: requiredCategories,
      if (minActivities != null) #minActivities: minActivities,
      if (maxActivities != null) #maxActivities: maxActivities,
      if (targetDuration != null) #targetDuration: targetDuration,
    }),
  );
  @override
  DateTemplate $make(CopyWithData data) => DateTemplate(
    templateId: data.get(#templateId, or: $value.templateId),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    theme: data.get(#theme, or: $value.theme),
    requiredCategories: data.get(
      #requiredCategories,
      or: $value.requiredCategories,
    ),
    minActivities: data.get(#minActivities, or: $value.minActivities),
    maxActivities: data.get(#maxActivities, or: $value.maxActivities),
    targetDuration: data.get(#targetDuration, or: $value.targetDuration),
  );

  @override
  DateTemplateCopyWith<$R2, DateTemplate, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DateTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DateIdeasStatsMapper extends ClassMapperBase<DateIdeasStats> {
  DateIdeasStatsMapper._();

  static DateIdeasStatsMapper? _instance;
  static DateIdeasStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateIdeasStatsMapper._());
      DateIdeaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DateIdeasStats';

  static int _$totalIdeas(DateIdeasStats v) => v.totalIdeas;
  static const Field<DateIdeasStats, int> _f$totalIdeas = Field(
    'totalIdeas',
    _$totalIdeas,
  );
  static int _$usedIdeas(DateIdeasStats v) => v.usedIdeas;
  static const Field<DateIdeasStats, int> _f$usedIdeas = Field(
    'usedIdeas',
    _$usedIdeas,
  );
  static double _$averageRating(DateIdeasStats v) => v.averageRating;
  static const Field<DateIdeasStats, double> _f$averageRating = Field(
    'averageRating',
    _$averageRating,
  );
  static Map<DateCategory, int> _$categoryCounts(DateIdeasStats v) =>
      v.categoryCounts;
  static const Field<DateIdeasStats, Map<DateCategory, int>> _f$categoryCounts =
      Field('categoryCounts', _$categoryCounts);
  static Map<PriceRange, int> _$priceDistribution(DateIdeasStats v) =>
      v.priceDistribution;
  static const Field<DateIdeasStats, Map<PriceRange, int>>
  _f$priceDistribution = Field('priceDistribution', _$priceDistribution);
  static List<DateIdea> _$trendingIdeas(DateIdeasStats v) => v.trendingIdeas;
  static const Field<DateIdeasStats, List<DateIdea>> _f$trendingIdeas = Field(
    'trendingIdeas',
    _$trendingIdeas,
  );
  static List<DateIdea> _$topRated(DateIdeasStats v) => v.topRated;
  static const Field<DateIdeasStats, List<DateIdea>> _f$topRated = Field(
    'topRated',
    _$topRated,
  );
  static DateTime _$generatedAt(DateIdeasStats v) => v.generatedAt;
  static const Field<DateIdeasStats, DateTime> _f$generatedAt = Field(
    'generatedAt',
    _$generatedAt,
  );

  @override
  final MappableFields<DateIdeasStats> fields = const {
    #totalIdeas: _f$totalIdeas,
    #usedIdeas: _f$usedIdeas,
    #averageRating: _f$averageRating,
    #categoryCounts: _f$categoryCounts,
    #priceDistribution: _f$priceDistribution,
    #trendingIdeas: _f$trendingIdeas,
    #topRated: _f$topRated,
    #generatedAt: _f$generatedAt,
  };

  static DateIdeasStats _instantiate(DecodingData data) {
    return DateIdeasStats(
      totalIdeas: data.dec(_f$totalIdeas),
      usedIdeas: data.dec(_f$usedIdeas),
      averageRating: data.dec(_f$averageRating),
      categoryCounts: data.dec(_f$categoryCounts),
      priceDistribution: data.dec(_f$priceDistribution),
      trendingIdeas: data.dec(_f$trendingIdeas),
      topRated: data.dec(_f$topRated),
      generatedAt: data.dec(_f$generatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateIdeasStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateIdeasStats>(map);
  }

  static DateIdeasStats fromJson(String json) {
    return ensureInitialized().decodeJson<DateIdeasStats>(json);
  }
}

mixin DateIdeasStatsMappable {
  String toJson() {
    return DateIdeasStatsMapper.ensureInitialized().encodeJson<DateIdeasStats>(
      this as DateIdeasStats,
    );
  }

  Map<String, dynamic> toMap() {
    return DateIdeasStatsMapper.ensureInitialized().encodeMap<DateIdeasStats>(
      this as DateIdeasStats,
    );
  }

  DateIdeasStatsCopyWith<DateIdeasStats, DateIdeasStats, DateIdeasStats>
  get copyWith => _DateIdeasStatsCopyWithImpl<DateIdeasStats, DateIdeasStats>(
    this as DateIdeasStats,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return DateIdeasStatsMapper.ensureInitialized().stringifyValue(
      this as DateIdeasStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return DateIdeasStatsMapper.ensureInitialized().equalsValue(
      this as DateIdeasStats,
      other,
    );
  }

  @override
  int get hashCode {
    return DateIdeasStatsMapper.ensureInitialized().hashValue(
      this as DateIdeasStats,
    );
  }
}

extension DateIdeasStatsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DateIdeasStats, $Out> {
  DateIdeasStatsCopyWith<$R, DateIdeasStats, $Out> get $asDateIdeasStats =>
      $base.as((v, t, t2) => _DateIdeasStatsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DateIdeasStatsCopyWith<$R, $In extends DateIdeasStats, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, DateCategory, int, ObjectCopyWith<$R, int, int>>
  get categoryCounts;
  MapCopyWith<$R, PriceRange, int, ObjectCopyWith<$R, int, int>>
  get priceDistribution;
  ListCopyWith<$R, DateIdea, DateIdeaCopyWith<$R, DateIdea, DateIdea>>
  get trendingIdeas;
  ListCopyWith<$R, DateIdea, DateIdeaCopyWith<$R, DateIdea, DateIdea>>
  get topRated;
  $R call({
    int? totalIdeas,
    int? usedIdeas,
    double? averageRating,
    Map<DateCategory, int>? categoryCounts,
    Map<PriceRange, int>? priceDistribution,
    List<DateIdea>? trendingIdeas,
    List<DateIdea>? topRated,
    DateTime? generatedAt,
  });
  DateIdeasStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DateIdeasStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateIdeasStats, $Out>
    implements DateIdeasStatsCopyWith<$R, DateIdeasStats, $Out> {
  _DateIdeasStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateIdeasStats> $mapper =
      DateIdeasStatsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, DateCategory, int, ObjectCopyWith<$R, int, int>>
  get categoryCounts => MapCopyWith(
    $value.categoryCounts,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryCounts: v),
  );
  @override
  MapCopyWith<$R, PriceRange, int, ObjectCopyWith<$R, int, int>>
  get priceDistribution => MapCopyWith(
    $value.priceDistribution,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(priceDistribution: v),
  );
  @override
  ListCopyWith<$R, DateIdea, DateIdeaCopyWith<$R, DateIdea, DateIdea>>
  get trendingIdeas => ListCopyWith(
    $value.trendingIdeas,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(trendingIdeas: v),
  );
  @override
  ListCopyWith<$R, DateIdea, DateIdeaCopyWith<$R, DateIdea, DateIdea>>
  get topRated => ListCopyWith(
    $value.topRated,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(topRated: v),
  );
  @override
  $R call({
    int? totalIdeas,
    int? usedIdeas,
    double? averageRating,
    Map<DateCategory, int>? categoryCounts,
    Map<PriceRange, int>? priceDistribution,
    List<DateIdea>? trendingIdeas,
    List<DateIdea>? topRated,
    DateTime? generatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (totalIdeas != null) #totalIdeas: totalIdeas,
      if (usedIdeas != null) #usedIdeas: usedIdeas,
      if (averageRating != null) #averageRating: averageRating,
      if (categoryCounts != null) #categoryCounts: categoryCounts,
      if (priceDistribution != null) #priceDistribution: priceDistribution,
      if (trendingIdeas != null) #trendingIdeas: trendingIdeas,
      if (topRated != null) #topRated: topRated,
      if (generatedAt != null) #generatedAt: generatedAt,
    }),
  );
  @override
  DateIdeasStats $make(CopyWithData data) => DateIdeasStats(
    totalIdeas: data.get(#totalIdeas, or: $value.totalIdeas),
    usedIdeas: data.get(#usedIdeas, or: $value.usedIdeas),
    averageRating: data.get(#averageRating, or: $value.averageRating),
    categoryCounts: data.get(#categoryCounts, or: $value.categoryCounts),
    priceDistribution: data.get(
      #priceDistribution,
      or: $value.priceDistribution,
    ),
    trendingIdeas: data.get(#trendingIdeas, or: $value.trendingIdeas),
    topRated: data.get(#topRated, or: $value.topRated),
    generatedAt: data.get(#generatedAt, or: $value.generatedAt),
  );

  @override
  DateIdeasStatsCopyWith<$R2, DateIdeasStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DateIdeasStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class GenerateDateSuggestionsRequestMapper
    extends ClassMapperBase<GenerateDateSuggestionsRequest> {
  GenerateDateSuggestionsRequestMapper._();

  static GenerateDateSuggestionsRequestMapper? _instance;
  static GenerateDateSuggestionsRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = GenerateDateSuggestionsRequestMapper._(),
      );
      DateIdeaFiltersMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'GenerateDateSuggestionsRequest';

  static String _$userId1(GenerateDateSuggestionsRequest v) => v.userId1;
  static const Field<GenerateDateSuggestionsRequest, String> _f$userId1 = Field(
    'userId1',
    _$userId1,
  );
  static String _$userId2(GenerateDateSuggestionsRequest v) => v.userId2;
  static const Field<GenerateDateSuggestionsRequest, String> _f$userId2 = Field(
    'userId2',
    _$userId2,
  );
  static DateIdeaFilters? _$filters(GenerateDateSuggestionsRequest v) =>
      v.filters;
  static const Field<GenerateDateSuggestionsRequest, DateIdeaFilters>
  _f$filters = Field('filters', _$filters, opt: true);
  static int _$maxSuggestions(GenerateDateSuggestionsRequest v) =>
      v.maxSuggestions;
  static const Field<GenerateDateSuggestionsRequest, int> _f$maxSuggestions =
      Field('maxSuggestions', _$maxSuggestions, opt: true, def: 10);
  static bool _$includeAIGenerated(GenerateDateSuggestionsRequest v) =>
      v.includeAIGenerated;
  static const Field<GenerateDateSuggestionsRequest, bool>
  _f$includeAIGenerated = Field(
    'includeAIGenerated',
    _$includeAIGenerated,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<GenerateDateSuggestionsRequest> fields = const {
    #userId1: _f$userId1,
    #userId2: _f$userId2,
    #filters: _f$filters,
    #maxSuggestions: _f$maxSuggestions,
    #includeAIGenerated: _f$includeAIGenerated,
  };

  static GenerateDateSuggestionsRequest _instantiate(DecodingData data) {
    return GenerateDateSuggestionsRequest(
      userId1: data.dec(_f$userId1),
      userId2: data.dec(_f$userId2),
      filters: data.dec(_f$filters),
      maxSuggestions: data.dec(_f$maxSuggestions),
      includeAIGenerated: data.dec(_f$includeAIGenerated),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GenerateDateSuggestionsRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GenerateDateSuggestionsRequest>(map);
  }

  static GenerateDateSuggestionsRequest fromJson(String json) {
    return ensureInitialized().decodeJson<GenerateDateSuggestionsRequest>(json);
  }
}

mixin GenerateDateSuggestionsRequestMappable {
  String toJson() {
    return GenerateDateSuggestionsRequestMapper.ensureInitialized()
        .encodeJson<GenerateDateSuggestionsRequest>(
          this as GenerateDateSuggestionsRequest,
        );
  }

  Map<String, dynamic> toMap() {
    return GenerateDateSuggestionsRequestMapper.ensureInitialized()
        .encodeMap<GenerateDateSuggestionsRequest>(
          this as GenerateDateSuggestionsRequest,
        );
  }

  GenerateDateSuggestionsRequestCopyWith<
    GenerateDateSuggestionsRequest,
    GenerateDateSuggestionsRequest,
    GenerateDateSuggestionsRequest
  >
  get copyWith =>
      _GenerateDateSuggestionsRequestCopyWithImpl<
        GenerateDateSuggestionsRequest,
        GenerateDateSuggestionsRequest
      >(this as GenerateDateSuggestionsRequest, $identity, $identity);
  @override
  String toString() {
    return GenerateDateSuggestionsRequestMapper.ensureInitialized()
        .stringifyValue(this as GenerateDateSuggestionsRequest);
  }

  @override
  bool operator ==(Object other) {
    return GenerateDateSuggestionsRequestMapper.ensureInitialized().equalsValue(
      this as GenerateDateSuggestionsRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return GenerateDateSuggestionsRequestMapper.ensureInitialized().hashValue(
      this as GenerateDateSuggestionsRequest,
    );
  }
}

extension GenerateDateSuggestionsRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GenerateDateSuggestionsRequest, $Out> {
  GenerateDateSuggestionsRequestCopyWith<
    $R,
    GenerateDateSuggestionsRequest,
    $Out
  >
  get $asGenerateDateSuggestionsRequest => $base.as(
    (v, t, t2) =>
        _GenerateDateSuggestionsRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class GenerateDateSuggestionsRequestCopyWith<
  $R,
  $In extends GenerateDateSuggestionsRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  DateIdeaFiltersCopyWith<$R, DateIdeaFilters, DateIdeaFilters>? get filters;
  $R call({
    String? userId1,
    String? userId2,
    DateIdeaFilters? filters,
    int? maxSuggestions,
    bool? includeAIGenerated,
  });
  GenerateDateSuggestionsRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _GenerateDateSuggestionsRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GenerateDateSuggestionsRequest, $Out>
    implements
        GenerateDateSuggestionsRequestCopyWith<
          $R,
          GenerateDateSuggestionsRequest,
          $Out
        > {
  _GenerateDateSuggestionsRequestCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<GenerateDateSuggestionsRequest> $mapper =
      GenerateDateSuggestionsRequestMapper.ensureInitialized();
  @override
  DateIdeaFiltersCopyWith<$R, DateIdeaFilters, DateIdeaFilters>? get filters =>
      $value.filters?.copyWith.$chain((v) => call(filters: v));
  @override
  $R call({
    String? userId1,
    String? userId2,
    Object? filters = $none,
    int? maxSuggestions,
    bool? includeAIGenerated,
  }) => $apply(
    FieldCopyWithData({
      if (userId1 != null) #userId1: userId1,
      if (userId2 != null) #userId2: userId2,
      if (filters != $none) #filters: filters,
      if (maxSuggestions != null) #maxSuggestions: maxSuggestions,
      if (includeAIGenerated != null) #includeAIGenerated: includeAIGenerated,
    }),
  );
  @override
  GenerateDateSuggestionsRequest $make(CopyWithData data) =>
      GenerateDateSuggestionsRequest(
        userId1: data.get(#userId1, or: $value.userId1),
        userId2: data.get(#userId2, or: $value.userId2),
        filters: data.get(#filters, or: $value.filters),
        maxSuggestions: data.get(#maxSuggestions, or: $value.maxSuggestions),
        includeAIGenerated: data.get(
          #includeAIGenerated,
          or: $value.includeAIGenerated,
        ),
      );

  @override
  GenerateDateSuggestionsRequestCopyWith<
    $R2,
    GenerateDateSuggestionsRequest,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _GenerateDateSuggestionsRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SeasonalDateIdeaMapper extends ClassMapperBase<SeasonalDateIdea> {
  SeasonalDateIdeaMapper._();

  static SeasonalDateIdeaMapper? _instance;
  static SeasonalDateIdeaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SeasonalDateIdeaMapper._());
      DateIdeaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SeasonalDateIdea';

  static String _$ideaId(SeasonalDateIdea v) => v.ideaId;
  static const Field<SeasonalDateIdea, String> _f$ideaId = Field(
    'ideaId',
    _$ideaId,
  );
  static DateIdea _$baseIdea(SeasonalDateIdea v) => v.baseIdea;
  static const Field<SeasonalDateIdea, DateIdea> _f$baseIdea = Field(
    'baseIdea',
    _$baseIdea,
  );
  static Season _$season(SeasonalDateIdea v) => v.season;
  static const Field<SeasonalDateIdea, Season> _f$season = Field(
    'season',
    _$season,
  );
  static DateTime _$startDate(SeasonalDateIdea v) => v.startDate;
  static const Field<SeasonalDateIdea, DateTime> _f$startDate = Field(
    'startDate',
    _$startDate,
  );
  static DateTime _$endDate(SeasonalDateIdea v) => v.endDate;
  static const Field<SeasonalDateIdea, DateTime> _f$endDate = Field(
    'endDate',
    _$endDate,
  );
  static String _$seasonalTwist(SeasonalDateIdea v) => v.seasonalTwist;
  static const Field<SeasonalDateIdea, String> _f$seasonalTwist = Field(
    'seasonalTwist',
    _$seasonalTwist,
  );
  static bool _$isInSeason(SeasonalDateIdea v) => v.isInSeason;
  static const Field<SeasonalDateIdea, bool> _f$isInSeason = Field(
    'isInSeason',
    _$isInSeason,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<SeasonalDateIdea> fields = const {
    #ideaId: _f$ideaId,
    #baseIdea: _f$baseIdea,
    #season: _f$season,
    #startDate: _f$startDate,
    #endDate: _f$endDate,
    #seasonalTwist: _f$seasonalTwist,
    #isInSeason: _f$isInSeason,
  };

  static SeasonalDateIdea _instantiate(DecodingData data) {
    return SeasonalDateIdea(
      ideaId: data.dec(_f$ideaId),
      baseIdea: data.dec(_f$baseIdea),
      season: data.dec(_f$season),
      startDate: data.dec(_f$startDate),
      endDate: data.dec(_f$endDate),
      seasonalTwist: data.dec(_f$seasonalTwist),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SeasonalDateIdea fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SeasonalDateIdea>(map);
  }

  static SeasonalDateIdea fromJson(String json) {
    return ensureInitialized().decodeJson<SeasonalDateIdea>(json);
  }
}

mixin SeasonalDateIdeaMappable {
  String toJson() {
    return SeasonalDateIdeaMapper.ensureInitialized()
        .encodeJson<SeasonalDateIdea>(this as SeasonalDateIdea);
  }

  Map<String, dynamic> toMap() {
    return SeasonalDateIdeaMapper.ensureInitialized()
        .encodeMap<SeasonalDateIdea>(this as SeasonalDateIdea);
  }

  SeasonalDateIdeaCopyWith<SeasonalDateIdea, SeasonalDateIdea, SeasonalDateIdea>
  get copyWith =>
      _SeasonalDateIdeaCopyWithImpl<SeasonalDateIdea, SeasonalDateIdea>(
        this as SeasonalDateIdea,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SeasonalDateIdeaMapper.ensureInitialized().stringifyValue(
      this as SeasonalDateIdea,
    );
  }

  @override
  bool operator ==(Object other) {
    return SeasonalDateIdeaMapper.ensureInitialized().equalsValue(
      this as SeasonalDateIdea,
      other,
    );
  }

  @override
  int get hashCode {
    return SeasonalDateIdeaMapper.ensureInitialized().hashValue(
      this as SeasonalDateIdea,
    );
  }
}

extension SeasonalDateIdeaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SeasonalDateIdea, $Out> {
  SeasonalDateIdeaCopyWith<$R, SeasonalDateIdea, $Out>
  get $asSeasonalDateIdea =>
      $base.as((v, t, t2) => _SeasonalDateIdeaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SeasonalDateIdeaCopyWith<$R, $In extends SeasonalDateIdea, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  DateIdeaCopyWith<$R, DateIdea, DateIdea> get baseIdea;
  $R call({
    String? ideaId,
    DateIdea? baseIdea,
    Season? season,
    DateTime? startDate,
    DateTime? endDate,
    String? seasonalTwist,
  });
  SeasonalDateIdeaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SeasonalDateIdeaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SeasonalDateIdea, $Out>
    implements SeasonalDateIdeaCopyWith<$R, SeasonalDateIdea, $Out> {
  _SeasonalDateIdeaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SeasonalDateIdea> $mapper =
      SeasonalDateIdeaMapper.ensureInitialized();
  @override
  DateIdeaCopyWith<$R, DateIdea, DateIdea> get baseIdea =>
      $value.baseIdea.copyWith.$chain((v) => call(baseIdea: v));
  @override
  $R call({
    String? ideaId,
    DateIdea? baseIdea,
    Season? season,
    DateTime? startDate,
    DateTime? endDate,
    String? seasonalTwist,
  }) => $apply(
    FieldCopyWithData({
      if (ideaId != null) #ideaId: ideaId,
      if (baseIdea != null) #baseIdea: baseIdea,
      if (season != null) #season: season,
      if (startDate != null) #startDate: startDate,
      if (endDate != null) #endDate: endDate,
      if (seasonalTwist != null) #seasonalTwist: seasonalTwist,
    }),
  );
  @override
  SeasonalDateIdea $make(CopyWithData data) => SeasonalDateIdea(
    ideaId: data.get(#ideaId, or: $value.ideaId),
    baseIdea: data.get(#baseIdea, or: $value.baseIdea),
    season: data.get(#season, or: $value.season),
    startDate: data.get(#startDate, or: $value.startDate),
    endDate: data.get(#endDate, or: $value.endDate),
    seasonalTwist: data.get(#seasonalTwist, or: $value.seasonalTwist),
  );

  @override
  SeasonalDateIdeaCopyWith<$R2, SeasonalDateIdea, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SeasonalDateIdeaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DateHistoryMapper extends ClassMapperBase<DateHistory> {
  DateHistoryMapper._();

  static DateHistoryMapper? _instance;
  static DateHistoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DateHistoryMapper._());
      DateIdeaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DateHistory';

  static String _$historyId(DateHistory v) => v.historyId;
  static const Field<DateHistory, String> _f$historyId = Field(
    'historyId',
    _$historyId,
  );
  static String _$userId1(DateHistory v) => v.userId1;
  static const Field<DateHistory, String> _f$userId1 = Field(
    'userId1',
    _$userId1,
  );
  static String _$userId2(DateHistory v) => v.userId2;
  static const Field<DateHistory, String> _f$userId2 = Field(
    'userId2',
    _$userId2,
  );
  static DateIdea _$idea(DateHistory v) => v.idea;
  static const Field<DateHistory, DateIdea> _f$idea = Field('idea', _$idea);
  static DateTime _$dateTime(DateHistory v) => v.dateTime;
  static const Field<DateHistory, DateTime> _f$dateTime = Field(
    'dateTime',
    _$dateTime,
  );
  static bool _$wasSuccessful(DateHistory v) => v.wasSuccessful;
  static const Field<DateHistory, bool> _f$wasSuccessful = Field(
    'wasSuccessful',
    _$wasSuccessful,
    opt: true,
    def: true,
  );
  static double _$rating(DateHistory v) => v.rating;
  static const Field<DateHistory, double> _f$rating = Field(
    'rating',
    _$rating,
    opt: true,
    def: 0.0,
  );
  static String? _$notes(DateHistory v) => v.notes;
  static const Field<DateHistory, String> _f$notes = Field(
    'notes',
    _$notes,
    opt: true,
  );

  @override
  final MappableFields<DateHistory> fields = const {
    #historyId: _f$historyId,
    #userId1: _f$userId1,
    #userId2: _f$userId2,
    #idea: _f$idea,
    #dateTime: _f$dateTime,
    #wasSuccessful: _f$wasSuccessful,
    #rating: _f$rating,
    #notes: _f$notes,
  };

  static DateHistory _instantiate(DecodingData data) {
    return DateHistory(
      historyId: data.dec(_f$historyId),
      userId1: data.dec(_f$userId1),
      userId2: data.dec(_f$userId2),
      idea: data.dec(_f$idea),
      dateTime: data.dec(_f$dateTime),
      wasSuccessful: data.dec(_f$wasSuccessful),
      rating: data.dec(_f$rating),
      notes: data.dec(_f$notes),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DateHistory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DateHistory>(map);
  }

  static DateHistory fromJson(String json) {
    return ensureInitialized().decodeJson<DateHistory>(json);
  }
}

mixin DateHistoryMappable {
  String toJson() {
    return DateHistoryMapper.ensureInitialized().encodeJson<DateHistory>(
      this as DateHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return DateHistoryMapper.ensureInitialized().encodeMap<DateHistory>(
      this as DateHistory,
    );
  }

  DateHistoryCopyWith<DateHistory, DateHistory, DateHistory> get copyWith =>
      _DateHistoryCopyWithImpl<DateHistory, DateHistory>(
        this as DateHistory,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DateHistoryMapper.ensureInitialized().stringifyValue(
      this as DateHistory,
    );
  }

  @override
  bool operator ==(Object other) {
    return DateHistoryMapper.ensureInitialized().equalsValue(
      this as DateHistory,
      other,
    );
  }

  @override
  int get hashCode {
    return DateHistoryMapper.ensureInitialized().hashValue(this as DateHistory);
  }
}

extension DateHistoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DateHistory, $Out> {
  DateHistoryCopyWith<$R, DateHistory, $Out> get $asDateHistory =>
      $base.as((v, t, t2) => _DateHistoryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DateHistoryCopyWith<$R, $In extends DateHistory, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  DateIdeaCopyWith<$R, DateIdea, DateIdea> get idea;
  $R call({
    String? historyId,
    String? userId1,
    String? userId2,
    DateIdea? idea,
    DateTime? dateTime,
    bool? wasSuccessful,
    double? rating,
    String? notes,
  });
  DateHistoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DateHistoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DateHistory, $Out>
    implements DateHistoryCopyWith<$R, DateHistory, $Out> {
  _DateHistoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DateHistory> $mapper =
      DateHistoryMapper.ensureInitialized();
  @override
  DateIdeaCopyWith<$R, DateIdea, DateIdea> get idea =>
      $value.idea.copyWith.$chain((v) => call(idea: v));
  @override
  $R call({
    String? historyId,
    String? userId1,
    String? userId2,
    DateIdea? idea,
    DateTime? dateTime,
    bool? wasSuccessful,
    double? rating,
    Object? notes = $none,
  }) => $apply(
    FieldCopyWithData({
      if (historyId != null) #historyId: historyId,
      if (userId1 != null) #userId1: userId1,
      if (userId2 != null) #userId2: userId2,
      if (idea != null) #idea: idea,
      if (dateTime != null) #dateTime: dateTime,
      if (wasSuccessful != null) #wasSuccessful: wasSuccessful,
      if (rating != null) #rating: rating,
      if (notes != $none) #notes: notes,
    }),
  );
  @override
  DateHistory $make(CopyWithData data) => DateHistory(
    historyId: data.get(#historyId, or: $value.historyId),
    userId1: data.get(#userId1, or: $value.userId1),
    userId2: data.get(#userId2, or: $value.userId2),
    idea: data.get(#idea, or: $value.idea),
    dateTime: data.get(#dateTime, or: $value.dateTime),
    wasSuccessful: data.get(#wasSuccessful, or: $value.wasSuccessful),
    rating: data.get(#rating, or: $value.rating),
    notes: data.get(#notes, or: $value.notes),
  );

  @override
  DateHistoryCopyWith<$R2, DateHistory, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DateHistoryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

