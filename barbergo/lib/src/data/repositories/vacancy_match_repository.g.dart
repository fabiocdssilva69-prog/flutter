// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy_match_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vacancyMatchRepository)
const vacancyMatchRepositoryProvider = VacancyMatchRepositoryProvider._();

final class VacancyMatchRepositoryProvider
    extends
        $FunctionalProvider<
          VacancyMatchRepository,
          VacancyMatchRepository,
          VacancyMatchRepository
        >
    with $Provider<VacancyMatchRepository> {
  const VacancyMatchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vacancyMatchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vacancyMatchRepositoryHash();

  @$internal
  @override
  $ProviderElement<VacancyMatchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VacancyMatchRepository create(Ref ref) {
    return vacancyMatchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VacancyMatchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VacancyMatchRepository>(value),
    );
  }
}

String _$vacancyMatchRepositoryHash() =>
    r'579c18c39880d63d5f12559c364adf1c8b1fe4ad';
