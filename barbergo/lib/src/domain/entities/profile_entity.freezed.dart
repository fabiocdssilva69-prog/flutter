// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileEntity {
  String get profileId;
  AccountType get accountType;
  String get name;
  String? get bio;
  String get city;
  String get neighborhood;
  List<String>? get specialties;
  List<String>? get portfolioUrls;
  List<String>? get amenities;
  List<String>? get galleryUrls;

  /// Create a copy of ProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileEntityCopyWith<ProfileEntity> get copyWith =>
      _$ProfileEntityCopyWithImpl<ProfileEntity>(
          this as ProfileEntity, _$identity);

  /// Serializes this ProfileEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileEntity &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood) &&
            const DeepCollectionEquality()
                .equals(other.specialties, specialties) &&
            const DeepCollectionEquality()
                .equals(other.portfolioUrls, portfolioUrls) &&
            const DeepCollectionEquality().equals(other.amenities, amenities) &&
            const DeepCollectionEquality()
                .equals(other.galleryUrls, galleryUrls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      profileId,
      accountType,
      name,
      bio,
      city,
      neighborhood,
      const DeepCollectionEquality().hash(specialties),
      const DeepCollectionEquality().hash(portfolioUrls),
      const DeepCollectionEquality().hash(amenities),
      const DeepCollectionEquality().hash(galleryUrls));

  @override
  String toString() {
    return 'ProfileEntity(profileId: $profileId, accountType: $accountType, name: $name, bio: $bio, city: $city, neighborhood: $neighborhood, specialties: $specialties, portfolioUrls: $portfolioUrls, amenities: $amenities, galleryUrls: $galleryUrls)';
  }
}

/// @nodoc
abstract mixin class $ProfileEntityCopyWith<$Res> {
  factory $ProfileEntityCopyWith(
          ProfileEntity value, $Res Function(ProfileEntity) _then) =
      _$ProfileEntityCopyWithImpl;
  @useResult
  $Res call(
      {String profileId,
      AccountType accountType,
      String name,
      String? bio,
      String city,
      String neighborhood,
      List<String>? specialties,
      List<String>? portfolioUrls,
      List<String>? amenities,
      List<String>? galleryUrls});
}

/// @nodoc
class _$ProfileEntityCopyWithImpl<$Res>
    implements $ProfileEntityCopyWith<$Res> {
  _$ProfileEntityCopyWithImpl(this._self, this._then);

  final ProfileEntity _self;
  final $Res Function(ProfileEntity) _then;

  /// Create a copy of ProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? accountType = null,
    Object? name = null,
    Object? bio = freezed,
    Object? city = null,
    Object? neighborhood = null,
    Object? specialties = freezed,
    Object? portfolioUrls = freezed,
    Object? amenities = freezed,
    Object? galleryUrls = freezed,
  }) {
    return _then(_self.copyWith(
      profileId: null == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _self.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as AccountType,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      neighborhood: null == neighborhood
          ? _self.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String,
      specialties: freezed == specialties
          ? _self.specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      portfolioUrls: freezed == portfolioUrls
          ? _self.portfolioUrls
          : portfolioUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      amenities: freezed == amenities
          ? _self.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      galleryUrls: freezed == galleryUrls
          ? _self.galleryUrls
          : galleryUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfileEntity].
extension ProfileEntityPatterns on ProfileEntity {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProfileEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProfileEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProfileEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String profileId,
            AccountType accountType,
            String name,
            String? bio,
            String city,
            String neighborhood,
            List<String>? specialties,
            List<String>? portfolioUrls,
            List<String>? amenities,
            List<String>? galleryUrls)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity() when $default != null:
        return $default(
            _that.profileId,
            _that.accountType,
            _that.name,
            _that.bio,
            _that.city,
            _that.neighborhood,
            _that.specialties,
            _that.portfolioUrls,
            _that.amenities,
            _that.galleryUrls);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String profileId,
            AccountType accountType,
            String name,
            String? bio,
            String city,
            String neighborhood,
            List<String>? specialties,
            List<String>? portfolioUrls,
            List<String>? amenities,
            List<String>? galleryUrls)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity():
        return $default(
            _that.profileId,
            _that.accountType,
            _that.name,
            _that.bio,
            _that.city,
            _that.neighborhood,
            _that.specialties,
            _that.portfolioUrls,
            _that.amenities,
            _that.galleryUrls);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String profileId,
            AccountType accountType,
            String name,
            String? bio,
            String city,
            String neighborhood,
            List<String>? specialties,
            List<String>? portfolioUrls,
            List<String>? amenities,
            List<String>? galleryUrls)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity() when $default != null:
        return $default(
            _that.profileId,
            _that.accountType,
            _that.name,
            _that.bio,
            _that.city,
            _that.neighborhood,
            _that.specialties,
            _that.portfolioUrls,
            _that.amenities,
            _that.galleryUrls);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProfileEntity implements ProfileEntity {
  const _ProfileEntity(
      {required this.profileId,
      required this.accountType,
      required this.name,
      this.bio,
      required this.city,
      required this.neighborhood,
      final List<String>? specialties,
      final List<String>? portfolioUrls,
      final List<String>? amenities,
      final List<String>? galleryUrls})
      : _specialties = specialties,
        _portfolioUrls = portfolioUrls,
        _amenities = amenities,
        _galleryUrls = galleryUrls;
  factory _ProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileEntityFromJson(json);

  @override
  final String profileId;
  @override
  final AccountType accountType;
  @override
  final String name;
  @override
  final String? bio;
  @override
  final String city;
  @override
  final String neighborhood;
  final List<String>? _specialties;
  @override
  List<String>? get specialties {
    final value = _specialties;
    if (value == null) return null;
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _portfolioUrls;
  @override
  List<String>? get portfolioUrls {
    final value = _portfolioUrls;
    if (value == null) return null;
    if (_portfolioUrls is EqualUnmodifiableListView) return _portfolioUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _amenities;
  @override
  List<String>? get amenities {
    final value = _amenities;
    if (value == null) return null;
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _galleryUrls;
  @override
  List<String>? get galleryUrls {
    final value = _galleryUrls;
    if (value == null) return null;
    if (_galleryUrls is EqualUnmodifiableListView) return _galleryUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of ProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileEntityCopyWith<_ProfileEntity> get copyWith =>
      __$ProfileEntityCopyWithImpl<_ProfileEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfileEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfileEntity &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood) &&
            const DeepCollectionEquality()
                .equals(other._specialties, _specialties) &&
            const DeepCollectionEquality()
                .equals(other._portfolioUrls, _portfolioUrls) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            const DeepCollectionEquality()
                .equals(other._galleryUrls, _galleryUrls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      profileId,
      accountType,
      name,
      bio,
      city,
      neighborhood,
      const DeepCollectionEquality().hash(_specialties),
      const DeepCollectionEquality().hash(_portfolioUrls),
      const DeepCollectionEquality().hash(_amenities),
      const DeepCollectionEquality().hash(_galleryUrls));

  @override
  String toString() {
    return 'ProfileEntity(profileId: $profileId, accountType: $accountType, name: $name, bio: $bio, city: $city, neighborhood: $neighborhood, specialties: $specialties, portfolioUrls: $portfolioUrls, amenities: $amenities, galleryUrls: $galleryUrls)';
  }
}

/// @nodoc
abstract mixin class _$ProfileEntityCopyWith<$Res>
    implements $ProfileEntityCopyWith<$Res> {
  factory _$ProfileEntityCopyWith(
          _ProfileEntity value, $Res Function(_ProfileEntity) _then) =
      __$ProfileEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String profileId,
      AccountType accountType,
      String name,
      String? bio,
      String city,
      String neighborhood,
      List<String>? specialties,
      List<String>? portfolioUrls,
      List<String>? amenities,
      List<String>? galleryUrls});
}

/// @nodoc
class __$ProfileEntityCopyWithImpl<$Res>
    implements _$ProfileEntityCopyWith<$Res> {
  __$ProfileEntityCopyWithImpl(this._self, this._then);

  final _ProfileEntity _self;
  final $Res Function(_ProfileEntity) _then;

  /// Create a copy of ProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? profileId = null,
    Object? accountType = null,
    Object? name = null,
    Object? bio = freezed,
    Object? city = null,
    Object? neighborhood = null,
    Object? specialties = freezed,
    Object? portfolioUrls = freezed,
    Object? amenities = freezed,
    Object? galleryUrls = freezed,
  }) {
    return _then(_ProfileEntity(
      profileId: null == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _self.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as AccountType,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      neighborhood: null == neighborhood
          ? _self.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String,
      specialties: freezed == specialties
          ? _self._specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      portfolioUrls: freezed == portfolioUrls
          ? _self._portfolioUrls
          : portfolioUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      amenities: freezed == amenities
          ? _self._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      galleryUrls: freezed == galleryUrls
          ? _self._galleryUrls
          : galleryUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

// dart format on
