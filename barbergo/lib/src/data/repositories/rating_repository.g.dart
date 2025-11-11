// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ratingRepository)
const ratingRepositoryProvider = RatingRepositoryProvider._();

final class RatingRepositoryProvider
    extends
        $FunctionalProvider<
          RatingRepository,
          RatingRepository,
          RatingRepository
        >
    with $Provider<RatingRepository> {
  const RatingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ratingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ratingRepositoryHash();

  @$internal
  @override
  $ProviderElement<RatingRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RatingRepository create(Ref ref) {
    return ratingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RatingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RatingRepository>(value),
    );
  }
}

String _$ratingRepositoryHash() => r'743a6b6b4d6356358150f34736e1ed2eaa37f4d3';
