// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userRepository)
const userRepositoryProvider = UserRepositoryProvider._();

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  const UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'645be9ab672cb405fbcf5809456cae805d733ae8';

@ProviderFor(currentUserData)
const currentUserDataProvider = CurrentUserDataProvider._();

final class CurrentUserDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserEntity?>,
          UserEntity?,
          Stream<UserEntity?>
        >
    with $FutureModifier<UserEntity?>, $StreamProvider<UserEntity?> {
  const CurrentUserDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserDataHash();

  @$internal
  @override
  $StreamProviderElement<UserEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UserEntity?> create(Ref ref) {
    return currentUserData(ref);
  }
}

String _$currentUserDataHash() => r'3cccf5c77d48327dd66c5f3bdb26f368612b838e';

@ProviderFor(currentAccountType)
const currentAccountTypeProvider = CurrentAccountTypeProvider._();

final class CurrentAccountTypeProvider
    extends $FunctionalProvider<AccountType?, AccountType?, AccountType?>
    with $Provider<AccountType?> {
  const CurrentAccountTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAccountTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAccountTypeHash();

  @$internal
  @override
  $ProviderElement<AccountType?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountType? create(Ref ref) {
    return currentAccountType(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountType? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountType?>(value),
    );
  }
}

String _$currentAccountTypeHash() =>
    r'0b18626b6ee211dfd14d2a6259244dec67986894';
