// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileRepository)
const profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  const ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'4391bfdbf79110347a2a16b6aae330116bab7030';

@ProviderFor(currentProfileData)
const currentProfileDataProvider = CurrentProfileDataProvider._();

final class CurrentProfileDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileEntity?>,
          ProfileEntity?,
          Stream<ProfileEntity?>
        >
    with $FutureModifier<ProfileEntity?>, $StreamProvider<ProfileEntity?> {
  const CurrentProfileDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProfileDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProfileDataHash();

  @$internal
  @override
  $StreamProviderElement<ProfileEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ProfileEntity?> create(Ref ref) {
    return currentProfileData(ref);
  }
}

String _$currentProfileDataHash() =>
    r'cec3d8adb32df86aec1858402258b5ea4ba75075';
