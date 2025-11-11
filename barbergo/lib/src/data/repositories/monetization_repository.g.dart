// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monetization_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository para Boosts, Gifts, Analytics e Revenue

@ProviderFor(monetizationRepository)
const monetizationRepositoryProvider = MonetizationRepositoryProvider._();

/// Repository para Boosts, Gifts, Analytics e Revenue

final class MonetizationRepositoryProvider
    extends
        $FunctionalProvider<
          MonetizationRepository,
          MonetizationRepository,
          MonetizationRepository
        >
    with $Provider<MonetizationRepository> {
  /// Repository para Boosts, Gifts, Analytics e Revenue
  const MonetizationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monetizationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monetizationRepositoryHash();

  @$internal
  @override
  $ProviderElement<MonetizationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MonetizationRepository create(Ref ref) {
    return monetizationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonetizationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonetizationRepository>(value),
    );
  }
}

String _$monetizationRepositoryHash() =>
    r'4c6072144cc813c762cf38289b68a0774b34c995';
