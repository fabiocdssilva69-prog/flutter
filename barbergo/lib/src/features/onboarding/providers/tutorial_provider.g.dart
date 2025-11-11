// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider que verifica se o usuário já completou o tutorial

@ProviderFor(tutorialCompleted)
const tutorialCompletedProvider = TutorialCompletedProvider._();

/// Provider que verifica se o usuário já completou o tutorial

final class TutorialCompletedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider que verifica se o usuário já completou o tutorial
  const TutorialCompletedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tutorialCompletedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tutorialCompletedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return tutorialCompleted(ref);
  }
}

String _$tutorialCompletedHash() => r'961b87973283405743cb0f5076fdbf29230ced74';

/// Provider para marcar o tutorial como completo

@ProviderFor(TutorialController)
const tutorialControllerProvider = TutorialControllerProvider._();

/// Provider para marcar o tutorial como completo
final class TutorialControllerProvider
    extends $AsyncNotifierProvider<TutorialController, bool> {
  /// Provider para marcar o tutorial como completo
  const TutorialControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tutorialControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tutorialControllerHash();

  @$internal
  @override
  TutorialController create() => TutorialController();
}

String _$tutorialControllerHash() =>
    r'b867733d859c583d4ce213e66e24ef86659f708a';

/// Provider para marcar o tutorial como completo

abstract class _$TutorialController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
