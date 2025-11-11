// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_verification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository para Identity Verification

@ProviderFor(identityVerificationRepository)
const identityVerificationRepositoryProvider =
    IdentityVerificationRepositoryProvider._();

/// Repository para Identity Verification

final class IdentityVerificationRepositoryProvider
    extends
        $FunctionalProvider<
          IdentityVerificationRepository,
          IdentityVerificationRepository,
          IdentityVerificationRepository
        >
    with $Provider<IdentityVerificationRepository> {
  /// Repository para Identity Verification
  const IdentityVerificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'identityVerificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$identityVerificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<IdentityVerificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IdentityVerificationRepository create(Ref ref) {
    return identityVerificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdentityVerificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdentityVerificationRepository>(
        value,
      ),
    );
  }
}

String _$identityVerificationRepositoryHash() =>
    r'e2b62ee7c6001105915c9e637c6bb12b9a9f57c7';
