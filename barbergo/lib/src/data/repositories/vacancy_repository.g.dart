// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vacancyRepository)
const vacancyRepositoryProvider = VacancyRepositoryProvider._();

final class VacancyRepositoryProvider
    extends
        $FunctionalProvider<
          VacancyRepository,
          VacancyRepository,
          VacancyRepository
        >
    with $Provider<VacancyRepository> {
  const VacancyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vacancyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vacancyRepositoryHash();

  @$internal
  @override
  $ProviderElement<VacancyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VacancyRepository create(Ref ref) {
    return vacancyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VacancyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VacancyRepository>(value),
    );
  }
}

String _$vacancyRepositoryHash() => r'428955e8c3def530c0211fe181114f6b76ed8129';
