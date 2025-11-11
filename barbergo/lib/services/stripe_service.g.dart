// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stripeService)
const stripeServiceProvider = StripeServiceProvider._();

final class StripeServiceProvider
    extends $FunctionalProvider<StripeService, StripeService, StripeService>
    with $Provider<StripeService> {
  const StripeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stripeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stripeServiceHash();

  @$internal
  @override
  $ProviderElement<StripeService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StripeService create(Ref ref) {
    return stripeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StripeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StripeService>(value),
    );
  }
}

String _$stripeServiceHash() => r'e86e4fd87fc756d87ef4fa1ca9277588c40b472b';
