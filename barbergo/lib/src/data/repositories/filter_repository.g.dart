// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repositório para gerenciar preferências de filtro no Firestore

@ProviderFor(filterRepository)
const filterRepositoryProvider = FilterRepositoryProvider._();

/// Repositório para gerenciar preferências de filtro no Firestore

final class FilterRepositoryProvider
    extends
        $FunctionalProvider<
          FilterRepository,
          FilterRepository,
          FilterRepository
        >
    with $Provider<FilterRepository> {
  /// Repositório para gerenciar preferências de filtro no Firestore
  const FilterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterRepositoryHash();

  @$internal
  @override
  $ProviderElement<FilterRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FilterRepository create(Ref ref) {
    return filterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FilterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FilterRepository>(value),
    );
  }
}

String _$filterRepositoryHash() => r'e143b2c72dbe8c1bade0d87db960aaae2148516d';
