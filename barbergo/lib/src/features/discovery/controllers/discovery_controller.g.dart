// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeVacanciesStream)
const activeVacanciesStreamProvider = ActiveVacanciesStreamProvider._();

final class ActiveVacanciesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VacancyEntity>>,
          List<VacancyEntity>,
          Stream<List<VacancyEntity>>
        >
    with
        $FutureModifier<List<VacancyEntity>>,
        $StreamProvider<List<VacancyEntity>> {
  const ActiveVacanciesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeVacanciesStreamProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeVacanciesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<VacancyEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<VacancyEntity>> create(Ref ref) {
    return activeVacanciesStream(ref);
  }
}

String _$activeVacanciesStreamHash() =>
    r'b531c6fcd27c816334331aec89524c507247bd5d';

@ProviderFor(discoverProfiles)
const discoverProfilesProvider = DiscoverProfilesProvider._();

final class DiscoverProfilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProfileEntity>>,
          List<ProfileEntity>,
          Stream<List<ProfileEntity>>
        >
    with
        $FutureModifier<List<ProfileEntity>>,
        $StreamProvider<List<ProfileEntity>> {
  const DiscoverProfilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoverProfilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoverProfilesHash();

  @$internal
  @override
  $StreamProviderElement<List<ProfileEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProfileEntity>> create(Ref ref) {
    return discoverProfiles(ref);
  }
}

String _$discoverProfilesHash() => r'c0ae4fed23b8ac4d147320dc611e347c42670a37';
