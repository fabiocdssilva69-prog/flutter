// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_entity.dart';

class UserEntityMapper extends ClassMapperBase<UserEntity> {
  UserEntityMapper._();

  static UserEntityMapper? _instance;
  static UserEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserEntityMapper._());
      AccountTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserEntity';

  static String _$userId(UserEntity v) => v.userId;
  static const Field<UserEntity, String> _f$userId = Field('userId', _$userId);
  static AccountType _$accountType(UserEntity v) => v.accountType;
  static const Field<UserEntity, AccountType> _f$accountType = Field(
    'accountType',
    _$accountType,
  );
  static String _$name(UserEntity v) => v.name;
  static const Field<UserEntity, String> _f$name = Field('name', _$name);
  static String _$email(UserEntity v) => v.email;
  static const Field<UserEntity, String> _f$email = Field('email', _$email);
  static String? _$avatarUrl(UserEntity v) => v.avatarUrl;
  static const Field<UserEntity, String> _f$avatarUrl = Field(
    'avatarUrl',
    _$avatarUrl,
    opt: true,
  );
  static DateTime _$createdAt(UserEntity v) => v.createdAt;
  static const Field<UserEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime? _$updatedAt(UserEntity v) => v.updatedAt;
  static const Field<UserEntity, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
  );

  @override
  final MappableFields<UserEntity> fields = const {
    #userId: _f$userId,
    #accountType: _f$accountType,
    #name: _f$name,
    #email: _f$email,
    #avatarUrl: _f$avatarUrl,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static UserEntity _instantiate(DecodingData data) {
    return UserEntity(
      userId: data.dec(_f$userId),
      accountType: data.dec(_f$accountType),
      name: data.dec(_f$name),
      email: data.dec(_f$email),
      avatarUrl: data.dec(_f$avatarUrl),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserEntity>(map);
  }

  static UserEntity fromJson(String json) {
    return ensureInitialized().decodeJson<UserEntity>(json);
  }
}

mixin UserEntityMappable {
  String toJson() {
    return UserEntityMapper.ensureInitialized().encodeJson<UserEntity>(
      this as UserEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return UserEntityMapper.ensureInitialized().encodeMap<UserEntity>(
      this as UserEntity,
    );
  }

  UserEntityCopyWith<UserEntity, UserEntity, UserEntity> get copyWith =>
      _UserEntityCopyWithImpl<UserEntity, UserEntity>(
        this as UserEntity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserEntityMapper.ensureInitialized().stringifyValue(
      this as UserEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserEntityMapper.ensureInitialized().equalsValue(
      this as UserEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return UserEntityMapper.ensureInitialized().hashValue(this as UserEntity);
  }
}

extension UserEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserEntity, $Out> {
  UserEntityCopyWith<$R, UserEntity, $Out> get $asUserEntity =>
      $base.as((v, t, t2) => _UserEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserEntityCopyWith<$R, $In extends UserEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    AccountType? accountType,
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  UserEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserEntity, $Out>
    implements UserEntityCopyWith<$R, UserEntity, $Out> {
  _UserEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserEntity> $mapper =
      UserEntityMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    AccountType? accountType,
    String? name,
    String? email,
    Object? avatarUrl = $none,
    DateTime? createdAt,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (accountType != null) #accountType: accountType,
      if (name != null) #name: name,
      if (email != null) #email: email,
      if (avatarUrl != $none) #avatarUrl: avatarUrl,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  UserEntity $make(CopyWithData data) => UserEntity(
    userId: data.get(#userId, or: $value.userId),
    accountType: data.get(#accountType, or: $value.accountType),
    name: data.get(#name, or: $value.name),
    email: data.get(#email, or: $value.email),
    avatarUrl: data.get(#avatarUrl, or: $value.avatarUrl),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  UserEntityCopyWith<$R2, UserEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

