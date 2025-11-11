// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interactionRepository)
const interactionRepositoryProvider = InteractionRepositoryProvider._();

final class InteractionRepositoryProvider
    extends
        $FunctionalProvider<
          InteractionRepository,
          InteractionRepository,
          InteractionRepository
        >
    with $Provider<InteractionRepository> {
  const InteractionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interactionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interactionRepositoryHash();

  @$internal
  @override
  $ProviderElement<InteractionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InteractionRepository create(Ref ref) {
    return interactionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InteractionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InteractionRepository>(value),
    );
  }
}

String _$interactionRepositoryHash() =>
    r'50d972cbcd10890d671c65e598d29b60dd905dc3';
