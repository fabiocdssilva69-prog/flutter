// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_data_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userDetails)
const userDetailsProvider = UserDetailsFamily._();

final class UserDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserEntity?>,
          UserEntity?,
          FutureOr<UserEntity?>
        >
    with $FutureModifier<UserEntity?>, $FutureProvider<UserEntity?> {
  const UserDetailsProvider._({
    required UserDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userDetailsHash();

  @override
  String toString() {
    return r'userDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return userDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userDetailsHash() => r'1f7481e7670c2a725fd0b1299181dcea1f85b71d';

final class UserDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserEntity?>, String> {
  const UserDetailsFamily._()
    : super(
        retry: null,
        name: r'userDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserDetailsProvider call(String userId) =>
      UserDetailsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userDetailsProvider';
}

@ProviderFor(userProfile)
const userProfileProvider = UserProfileFamily._();

final class UserProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileEntity?>,
          ProfileEntity?,
          FutureOr<ProfileEntity?>
        >
    with $FutureModifier<ProfileEntity?>, $FutureProvider<ProfileEntity?> {
  const UserProfileProvider._({
    required UserProfileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProfileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @override
  String toString() {
    return r'userProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProfileEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProfileEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return userProfile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userProfileHash() => r'670f55f2a37d940b54a5874e8f22d7f5f2658d6f';

final class UserProfileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProfileEntity?>, String> {
  const UserProfileFamily._()
    : super(
        retry: null,
        name: r'userProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserProfileProvider call(String userId) =>
      UserProfileProvider._(argument: userId, from: this);

  @override
  String toString() => r'userProfileProvider';
}
