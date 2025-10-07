// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vacancy_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VacancyEntity {
  String get vacancyId;
  String get barbershopId;
  String get title;
  VacancyType get type;
  double? get commissionPercentage;
  String get workHours;
  bool get isActive;
  @DateTimeTimestampConverter()
  DateTime get createdAt;

  /// Create a copy of VacancyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VacancyEntityCopyWith<VacancyEntity> get copyWith =>
      _$VacancyEntityCopyWithImpl<VacancyEntity>(
          this as VacancyEntity, _$identity);

  /// Serializes this VacancyEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VacancyEntity &&
            (identical(other.vacancyId, vacancyId) ||
                other.vacancyId == vacancyId) &&
            (identical(other.barbershopId, barbershopId) ||
                other.barbershopId == barbershopId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.commissionPercentage, commissionPercentage) ||
                other.commissionPercentage == commissionPercentage) &&
            (identical(other.workHours, workHours) ||
                other.workHours == workHours) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vacancyId, barbershopId, title,
      type, commissionPercentage, workHours, isActive, createdAt);

  @override
  String toString() {
    return 'VacancyEntity(vacancyId: $vacancyId, barbershopId: $barbershopId, title: $title, type: $type, commissionPercentage: $commissionPercentage, workHours: $workHours, isActive: $isActive, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $VacancyEntityCopyWith<$Res> {
  factory $VacancyEntityCopyWith(
          VacancyEntity value, $Res Function(VacancyEntity) _then) =
      _$VacancyEntityCopyWithImpl;
  @useResult
  $Res call(
      {String vacancyId,
      String barbershopId,
      String title,
      VacancyType type,
      double? commissionPercentage,
      String workHours,
      bool isActive,
      @DateTimeTimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$VacancyEntityCopyWithImpl<$Res>
    implements $VacancyEntityCopyWith<$Res> {
  _$VacancyEntityCopyWithImpl(this._self, this._then);

  final VacancyEntity _self;
  final $Res Function(VacancyEntity) _then;

  /// Create a copy of VacancyEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vacancyId = null,
    Object? barbershopId = null,
    Object? title = null,
    Object? type = null,
    Object? commissionPercentage = freezed,
    Object? workHours = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      vacancyId: null == vacancyId
          ? _self.vacancyId
          : vacancyId // ignore: cast_nullable_to_non_nullable
              as String,
      barbershopId: null == barbershopId
          ? _self.barbershopId
          : barbershopId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as VacancyType,
      commissionPercentage: freezed == commissionPercentage
          ? _self.commissionPercentage
          : commissionPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      workHours: null == workHours
          ? _self.workHours
          : workHours // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [VacancyEntity].
extension VacancyEntityPatterns on VacancyEntity {
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
    TResult Function(_VacancyEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VacancyEntity() when $default != null:
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
    TResult Function(_VacancyEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VacancyEntity():
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
    TResult? Function(_VacancyEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VacancyEntity() when $default != null:
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
            String vacancyId,
            String barbershopId,
            String title,
            VacancyType type,
            double? commissionPercentage,
            String workHours,
            bool isActive,
            @DateTimeTimestampConverter() DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VacancyEntity() when $default != null:
        return $default(
            _that.vacancyId,
            _that.barbershopId,
            _that.title,
            _that.type,
            _that.commissionPercentage,
            _that.workHours,
            _that.isActive,
            _that.createdAt);
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
            String vacancyId,
            String barbershopId,
            String title,
            VacancyType type,
            double? commissionPercentage,
            String workHours,
            bool isActive,
            @DateTimeTimestampConverter() DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VacancyEntity():
        return $default(
            _that.vacancyId,
            _that.barbershopId,
            _that.title,
            _that.type,
            _that.commissionPercentage,
            _that.workHours,
            _that.isActive,
            _that.createdAt);
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
            String vacancyId,
            String barbershopId,
            String title,
            VacancyType type,
            double? commissionPercentage,
            String workHours,
            bool isActive,
            @DateTimeTimestampConverter() DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VacancyEntity() when $default != null:
        return $default(
            _that.vacancyId,
            _that.barbershopId,
            _that.title,
            _that.type,
            _that.commissionPercentage,
            _that.workHours,
            _that.isActive,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VacancyEntity implements VacancyEntity {
  const _VacancyEntity(
      {required this.vacancyId,
      required this.barbershopId,
      required this.title,
      required this.type,
      this.commissionPercentage,
      required this.workHours,
      required this.isActive,
      @DateTimeTimestampConverter() required this.createdAt});
  factory _VacancyEntity.fromJson(Map<String, dynamic> json) =>
      _$VacancyEntityFromJson(json);

  @override
  final String vacancyId;
  @override
  final String barbershopId;
  @override
  final String title;
  @override
  final VacancyType type;
  @override
  final double? commissionPercentage;
  @override
  final String workHours;
  @override
  final bool isActive;
  @override
  @DateTimeTimestampConverter()
  final DateTime createdAt;

  /// Create a copy of VacancyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VacancyEntityCopyWith<_VacancyEntity> get copyWith =>
      __$VacancyEntityCopyWithImpl<_VacancyEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VacancyEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VacancyEntity &&
            (identical(other.vacancyId, vacancyId) ||
                other.vacancyId == vacancyId) &&
            (identical(other.barbershopId, barbershopId) ||
                other.barbershopId == barbershopId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.commissionPercentage, commissionPercentage) ||
                other.commissionPercentage == commissionPercentage) &&
            (identical(other.workHours, workHours) ||
                other.workHours == workHours) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vacancyId, barbershopId, title,
      type, commissionPercentage, workHours, isActive, createdAt);

  @override
  String toString() {
    return 'VacancyEntity(vacancyId: $vacancyId, barbershopId: $barbershopId, title: $title, type: $type, commissionPercentage: $commissionPercentage, workHours: $workHours, isActive: $isActive, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$VacancyEntityCopyWith<$Res>
    implements $VacancyEntityCopyWith<$Res> {
  factory _$VacancyEntityCopyWith(
          _VacancyEntity value, $Res Function(_VacancyEntity) _then) =
      __$VacancyEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String vacancyId,
      String barbershopId,
      String title,
      VacancyType type,
      double? commissionPercentage,
      String workHours,
      bool isActive,
      @DateTimeTimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$VacancyEntityCopyWithImpl<$Res>
    implements _$VacancyEntityCopyWith<$Res> {
  __$VacancyEntityCopyWithImpl(this._self, this._then);

  final _VacancyEntity _self;
  final $Res Function(_VacancyEntity) _then;

  /// Create a copy of VacancyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? vacancyId = null,
    Object? barbershopId = null,
    Object? title = null,
    Object? type = null,
    Object? commissionPercentage = freezed,
    Object? workHours = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_VacancyEntity(
      vacancyId: null == vacancyId
          ? _self.vacancyId
          : vacancyId // ignore: cast_nullable_to_non_nullable
              as String,
      barbershopId: null == barbershopId
          ? _self.barbershopId
          : barbershopId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as VacancyType,
      commissionPercentage: freezed == commissionPercentage
          ? _self.commissionPercentage
          : commissionPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      workHours: null == workHours
          ? _self.workHours
          : workHours // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
