// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocation_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(geolocationService)
const geolocationServiceProvider = GeolocationServiceProvider._();

final class GeolocationServiceProvider
    extends
        $FunctionalProvider<
          GeolocationService,
          GeolocationService,
          GeolocationService
        >
    with $Provider<GeolocationService> {
  const GeolocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geolocationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geolocationServiceHash();

  @$internal
  @override
  $ProviderElement<GeolocationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GeolocationService create(Ref ref) {
    return geolocationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeolocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeolocationService>(value),
    );
  }
}

String _$geolocationServiceHash() =>
    r'a28ba01a6e9c9b52bf3b4047bf70d53252edeeaa';
