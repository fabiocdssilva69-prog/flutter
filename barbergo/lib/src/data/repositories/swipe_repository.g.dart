// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swipe_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(swipeRepository)
const swipeRepositoryProvider = SwipeRepositoryProvider._();

final class SwipeRepositoryProvider
    extends
        $FunctionalProvider<SwipeRepository, SwipeRepository, SwipeRepository>
    with $Provider<SwipeRepository> {
  const SwipeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swipeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swipeRepositoryHash();

  @$internal
  @override
  $ProviderElement<SwipeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SwipeRepository create(Ref ref) {
    return swipeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwipeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwipeRepository>(value),
    );
  }
}

String _$swipeRepositoryHash() => r'0ae4d26f76ff0325f1990d23926d65684818d95a';
