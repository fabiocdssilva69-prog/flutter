// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'filter_preferences.dart';

class FilterPreferencesMapper extends ClassMapperBase<FilterPreferences> {
  FilterPreferencesMapper._();

  static FilterPreferencesMapper? _instance;
  static FilterPreferencesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FilterPreferencesMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FilterPreferences';

  static double _$maxDistance(FilterPreferences v) => v.maxDistance;
  static const Field<FilterPreferences, double> _f$maxDistance = Field(
    'maxDistance',
    _$maxDistance,
    opt: true,
    def: 50.0,
  );
  static double _$minPrice(FilterPreferences v) => v.minPrice;
  static const Field<FilterPreferences, double> _f$minPrice = Field(
    'minPrice',
    _$minPrice,
    opt: true,
    def: 20.0,
  );
  static double _$maxPrice(FilterPreferences v) => v.maxPrice;
  static const Field<FilterPreferences, double> _f$maxPrice = Field(
    'maxPrice',
    _$maxPrice,
    opt: true,
    def: 200.0,
  );
  static double _$minRating(FilterPreferences v) => v.minRating;
  static const Field<FilterPreferences, double> _f$minRating = Field(
    'minRating',
    _$minRating,
    opt: true,
    def: 3.0,
  );
  static bool _$availableNow(FilterPreferences v) => v.availableNow;
  static const Field<FilterPreferences, bool> _f$availableNow = Field(
    'availableNow',
    _$availableNow,
    opt: true,
    def: false,
  );
  static List<String> _$serviceTypes(FilterPreferences v) => v.serviceTypes;
  static const Field<FilterPreferences, List<String>> _f$serviceTypes = Field(
    'serviceTypes',
    _$serviceTypes,
    opt: true,
    def: const [],
  );
  static bool _$hasActiveFilters(FilterPreferences v) => v.hasActiveFilters;
  static const Field<FilterPreferences, bool> _f$hasActiveFilters = Field(
    'hasActiveFilters',
    _$hasActiveFilters,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<FilterPreferences> fields = const {
    #maxDistance: _f$maxDistance,
    #minPrice: _f$minPrice,
    #maxPrice: _f$maxPrice,
    #minRating: _f$minRating,
    #availableNow: _f$availableNow,
    #serviceTypes: _f$serviceTypes,
    #hasActiveFilters: _f$hasActiveFilters,
  };

  static FilterPreferences _instantiate(DecodingData data) {
    return FilterPreferences(
      maxDistance: data.dec(_f$maxDistance),
      minPrice: data.dec(_f$minPrice),
      maxPrice: data.dec(_f$maxPrice),
      minRating: data.dec(_f$minRating),
      availableNow: data.dec(_f$availableNow),
      serviceTypes: data.dec(_f$serviceTypes),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FilterPreferences fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FilterPreferences>(map);
  }

  static FilterPreferences fromJson(String json) {
    return ensureInitialized().decodeJson<FilterPreferences>(json);
  }
}

mixin FilterPreferencesMappable {
  String toJson() {
    return FilterPreferencesMapper.ensureInitialized()
        .encodeJson<FilterPreferences>(this as FilterPreferences);
  }

  Map<String, dynamic> toMap() {
    return FilterPreferencesMapper.ensureInitialized()
        .encodeMap<FilterPreferences>(this as FilterPreferences);
  }

  FilterPreferencesCopyWith<
    FilterPreferences,
    FilterPreferences,
    FilterPreferences
  >
  get copyWith =>
      _FilterPreferencesCopyWithImpl<FilterPreferences, FilterPreferences>(
        this as FilterPreferences,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FilterPreferencesMapper.ensureInitialized().stringifyValue(
      this as FilterPreferences,
    );
  }

  @override
  bool operator ==(Object other) {
    return FilterPreferencesMapper.ensureInitialized().equalsValue(
      this as FilterPreferences,
      other,
    );
  }

  @override
  int get hashCode {
    return FilterPreferencesMapper.ensureInitialized().hashValue(
      this as FilterPreferences,
    );
  }
}

extension FilterPreferencesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FilterPreferences, $Out> {
  FilterPreferencesCopyWith<$R, FilterPreferences, $Out>
  get $asFilterPreferences => $base.as(
    (v, t, t2) => _FilterPreferencesCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FilterPreferencesCopyWith<
  $R,
  $In extends FilterPreferences,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get serviceTypes;
  $R call({
    double? maxDistance,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? availableNow,
    List<String>? serviceTypes,
  });
  FilterPreferencesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FilterPreferencesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FilterPreferences, $Out>
    implements FilterPreferencesCopyWith<$R, FilterPreferences, $Out> {
  _FilterPreferencesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FilterPreferences> $mapper =
      FilterPreferencesMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get serviceTypes => ListCopyWith(
    $value.serviceTypes,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(serviceTypes: v),
  );
  @override
  $R call({
    double? maxDistance,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? availableNow,
    List<String>? serviceTypes,
  }) => $apply(
    FieldCopyWithData({
      if (maxDistance != null) #maxDistance: maxDistance,
      if (minPrice != null) #minPrice: minPrice,
      if (maxPrice != null) #maxPrice: maxPrice,
      if (minRating != null) #minRating: minRating,
      if (availableNow != null) #availableNow: availableNow,
      if (serviceTypes != null) #serviceTypes: serviceTypes,
    }),
  );
  @override
  FilterPreferences $make(CopyWithData data) => FilterPreferences(
    maxDistance: data.get(#maxDistance, or: $value.maxDistance),
    minPrice: data.get(#minPrice, or: $value.minPrice),
    maxPrice: data.get(#maxPrice, or: $value.maxPrice),
    minRating: data.get(#minRating, or: $value.minRating),
    availableNow: data.get(#availableNow, or: $value.availableNow),
    serviceTypes: data.get(#serviceTypes, or: $value.serviceTypes),
  );

  @override
  FilterPreferencesCopyWith<$R2, FilterPreferences, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FilterPreferencesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

