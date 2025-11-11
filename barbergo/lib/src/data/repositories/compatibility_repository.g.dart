// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compatibility_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository para Compatibility Scores

@ProviderFor(compatibilityRepository)
const compatibilityRepositoryProvider = CompatibilityRepositoryProvider._();

/// Repository para Compatibility Scores

final class CompatibilityRepositoryProvider
    extends
        $FunctionalProvider<
          CompatibilityRepository,
          CompatibilityRepository,
          CompatibilityRepository
        >
    with $Provider<CompatibilityRepository> {
  /// Repository para Compatibility Scores
  const CompatibilityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compatibilityRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compatibilityRepositoryHash();

  @$internal
  @override
  $ProviderElement<CompatibilityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompatibilityRepository create(Ref ref) {
    return compatibilityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompatibilityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompatibilityRepository>(value),
    );
  }
}

String _$compatibilityRepositoryHash() =>
    r'148a517a9e46db381149451f2c017770e059234c';
