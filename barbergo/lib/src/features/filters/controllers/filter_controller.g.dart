// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider que observa as preferências de filtro do usuário atual

@ProviderFor(userFilterPreferences)
const userFilterPreferencesProvider = UserFilterPreferencesProvider._();

/// Provider que observa as preferências de filtro do usuário atual

final class UserFilterPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<FilterPreferences>,
          FilterPreferences,
          Stream<FilterPreferences>
        >
    with
        $FutureModifier<FilterPreferences>,
        $StreamProvider<FilterPreferences> {
  /// Provider que observa as preferências de filtro do usuário atual
  const UserFilterPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userFilterPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userFilterPreferencesHash();

  @$internal
  @override
  $StreamProviderElement<FilterPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<FilterPreferences> create(Ref ref) {
    return userFilterPreferences(ref);
  }
}

String _$userFilterPreferencesHash() =>
    r'6914db8acff5e5027d9eacee22d8697508c9f99c';

/// Controller para gerenciar preferências de filtro

@ProviderFor(FilterController)
const filterControllerProvider = FilterControllerProvider._();

/// Controller para gerenciar preferências de filtro
final class FilterControllerProvider
    extends $AsyncNotifierProvider<FilterController, FilterPreferences> {
  /// Controller para gerenciar preferências de filtro
  const FilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterControllerHash();

  @$internal
  @override
  FilterController create() => FilterController();
}

String _$filterControllerHash() => r'6359298b90aeacc0222a4b07797c112b787dbc73';

/// Controller para gerenciar preferências de filtro

abstract class _$FilterController extends $AsyncNotifier<FilterPreferences> {
  FutureOr<FilterPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<FilterPreferences>, FilterPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FilterPreferences>, FilterPreferences>,
              AsyncValue<FilterPreferences>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
