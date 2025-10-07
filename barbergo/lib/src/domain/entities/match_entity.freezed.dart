// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchEntity {
  String get matchId;
  List<String> get participants;
  @DateTimeTimestampConverter()
  DateTime get matchedAt;
  Map<String, dynamic>? get contactInfo;

  /// Create a copy of MatchEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MatchEntityCopyWith<MatchEntity> get copyWith =>
      _$MatchEntityCopyWithImpl<MatchEntity>(this as MatchEntity, _$identity);

  /// Serializes this MatchEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MatchEntity &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            const DeepCollectionEquality()
                .equals(other.participants, participants) &&
            (identical(other.matchedAt, matchedAt) ||
                other.matchedAt == matchedAt) &&
            const DeepCollectionEquality()
                .equals(other.contactInfo, contactInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      matchId,
      const DeepCollectionEquality().hash(participants),
      matchedAt,
      const DeepCollectionEquality().hash(contactInfo));

  @override
  String toString() {
    return 'MatchEntity(matchId: $matchId, participants: $participants, matchedAt: $matchedAt, contactInfo: $contactInfo)';
  }
}

/// @nodoc
abstract mixin class $MatchEntityCopyWith<$Res> {
  factory $MatchEntityCopyWith(
          MatchEntity value, $Res Function(MatchEntity) _then) =
      _$MatchEntityCopyWithImpl;
  @useResult
  $Res call(
      {String matchId,
      List<String> participants,
      @DateTimeTimestampConverter() DateTime matchedAt,
      Map<String, dynamic>? contactInfo});
}

/// @nodoc
class _$MatchEntityCopyWithImpl<$Res> implements $MatchEntityCopyWith<$Res> {
  _$MatchEntityCopyWithImpl(this._self, this._then);

  final MatchEntity _self;
  final $Res Function(MatchEntity) _then;

  /// Create a copy of MatchEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? participants = null,
    Object? matchedAt = null,
    Object? contactInfo = freezed,
  }) {
    return _then(_self.copyWith(
      matchId: null == matchId
          ? _self.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _self.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchedAt: null == matchedAt
          ? _self.matchedAt
          : matchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      contactInfo: freezed == contactInfo
          ? _self.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MatchEntity].
extension MatchEntityPatterns on MatchEntity {
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
    TResult Function(_MatchEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MatchEntity() when $default != null:
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
    TResult Function(_MatchEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchEntity():
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
    TResult? Function(_MatchEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchEntity() when $default != null:
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
            String matchId,
            List<String> participants,
            @DateTimeTimestampConverter() DateTime matchedAt,
            Map<String, dynamic>? contactInfo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MatchEntity() when $default != null:
        return $default(_that.matchId, _that.participants, _that.matchedAt,
            _that.contactInfo);
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
            String matchId,
            List<String> participants,
            @DateTimeTimestampConverter() DateTime matchedAt,
            Map<String, dynamic>? contactInfo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchEntity():
        return $default(_that.matchId, _that.participants, _that.matchedAt,
            _that.contactInfo);
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
            String matchId,
            List<String> participants,
            @DateTimeTimestampConverter() DateTime matchedAt,
            Map<String, dynamic>? contactInfo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchEntity() when $default != null:
        return $default(_that.matchId, _that.participants, _that.matchedAt,
            _that.contactInfo);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MatchEntity implements MatchEntity {
  const _MatchEntity(
      {required this.matchId,
      required final List<String> participants,
      @DateTimeTimestampConverter() required this.matchedAt,
      final Map<String, dynamic>? contactInfo})
      : _participants = participants,
        _contactInfo = contactInfo;
  factory _MatchEntity.fromJson(Map<String, dynamic> json) =>
      _$MatchEntityFromJson(json);

  @override
  final String matchId;
  final List<String> _participants;
  @override
  List<String> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  @DateTimeTimestampConverter()
  final DateTime matchedAt;
  final Map<String, dynamic>? _contactInfo;
  @override
  Map<String, dynamic>? get contactInfo {
    final value = _contactInfo;
    if (value == null) return null;
    if (_contactInfo is EqualUnmodifiableMapView) return _contactInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of MatchEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MatchEntityCopyWith<_MatchEntity> get copyWith =>
      __$MatchEntityCopyWithImpl<_MatchEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MatchEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MatchEntity &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.matchedAt, matchedAt) ||
                other.matchedAt == matchedAt) &&
            const DeepCollectionEquality()
                .equals(other._contactInfo, _contactInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      matchId,
      const DeepCollectionEquality().hash(_participants),
      matchedAt,
      const DeepCollectionEquality().hash(_contactInfo));

  @override
  String toString() {
    return 'MatchEntity(matchId: $matchId, participants: $participants, matchedAt: $matchedAt, contactInfo: $contactInfo)';
  }
}

/// @nodoc
abstract mixin class _$MatchEntityCopyWith<$Res>
    implements $MatchEntityCopyWith<$Res> {
  factory _$MatchEntityCopyWith(
          _MatchEntity value, $Res Function(_MatchEntity) _then) =
      __$MatchEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String matchId,
      List<String> participants,
      @DateTimeTimestampConverter() DateTime matchedAt,
      Map<String, dynamic>? contactInfo});
}

/// @nodoc
class __$MatchEntityCopyWithImpl<$Res> implements _$MatchEntityCopyWith<$Res> {
  __$MatchEntityCopyWithImpl(this._self, this._then);

  final _MatchEntity _self;
  final $Res Function(_MatchEntity) _then;

  /// Create a copy of MatchEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? matchId = null,
    Object? participants = null,
    Object? matchedAt = null,
    Object? contactInfo = freezed,
  }) {
    return _then(_MatchEntity(
      matchId: null == matchId
          ? _self.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _self._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchedAt: null == matchedAt
          ? _self.matchedAt
          : matchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      contactInfo: freezed == contactInfo
          ? _self._contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

// dart format on
