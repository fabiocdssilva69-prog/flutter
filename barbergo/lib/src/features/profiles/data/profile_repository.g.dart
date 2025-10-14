// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provedor de uma instância singleton do FirebaseFirestore.

@ProviderFor(firestore)
const firestoreProvider = FirestoreProvider._();

/// Provedor de uma instância singleton do FirebaseFirestore.

final class FirestoreProvider
    extends
        $FunctionalProvider<
          FirebaseFirestore,
          FirebaseFirestore,
          FirebaseFirestore
        >
    with $Provider<FirebaseFirestore> {
  /// Provedor de uma instância singleton do FirebaseFirestore.
  const FirestoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFirestore create(Ref ref) {
    return firestore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestore>(value),
    );
  }
}

String _$firestoreHash() => r'0e25e335c5657f593fc1baf3d9fd026e70bca7fa';

/// Provedor do ProfileRepository.

@ProviderFor(profileRepository)
const profileRepositoryProvider = ProfileRepositoryProvider._();

/// Provedor do ProfileRepository.

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  /// Provedor do ProfileRepository.
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

String _$profileRepositoryHash() => r'57d5a0263c28770b67bc9a598d0e1be7d4690e2b';

/// Provedor futuro que retorna o perfil do usuário logado.
/// Observa o estado de autenticação e busca o documento correspondente.
/// Retorna null se o usuário não estiver logado ou se o perfil não existir.

@ProviderFor(userProfile)
const userProfileProvider = UserProfileProvider._();

/// Provedor futuro que retorna o perfil do usuário logado.
/// Observa o estado de autenticação e busca o documento correspondente.
/// Retorna null se o usuário não estiver logado ou se o perfil não existir.

final class UserProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileEntity?>,
          ProfileEntity?,
          FutureOr<ProfileEntity?>
        >
    with $FutureModifier<ProfileEntity?>, $FutureProvider<ProfileEntity?> {
  /// Provedor futuro que retorna o perfil do usuário logado.
  /// Observa o estado de autenticação e busca o documento correspondente.
  /// Retorna null se o usuário não estiver logado ou se o perfil não existir.
  const UserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @$internal
  @override
  $FutureProviderElement<ProfileEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProfileEntity?> create(Ref ref) {
    return userProfile(ref);
  }
}

String _$userProfileHash() => r'327218cf60293c8ff39204e5129dd341b03fa952';
