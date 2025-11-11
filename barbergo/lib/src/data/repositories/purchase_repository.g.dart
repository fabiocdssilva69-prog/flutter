// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository para In-App Purchases

@ProviderFor(purchaseRepository)
const purchaseRepositoryProvider = PurchaseRepositoryProvider._();

/// Repository para In-App Purchases

final class PurchaseRepositoryProvider
    extends
        $FunctionalProvider<
          PurchaseRepository,
          PurchaseRepository,
          PurchaseRepository
        >
    with $Provider<PurchaseRepository> {
  /// Repository para In-App Purchases
  const PurchaseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseRepositoryHash();

  @$internal
  @override
  $ProviderElement<PurchaseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PurchaseRepository create(Ref ref) {
    return purchaseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseRepository>(value),
    );
  }
}

String _$purchaseRepositoryHash() =>
    r'e5bb033ab43199fef11de0b4991b969a1158323f';
