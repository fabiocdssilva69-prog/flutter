// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cv_generator_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para geração de currículos profissionais para barbeiros

@ProviderFor(CVGeneratorController)
const cVGeneratorControllerProvider = CVGeneratorControllerProvider._();

/// Controller para geração de currículos profissionais para barbeiros
final class CVGeneratorControllerProvider
    extends $AsyncNotifierProvider<CVGeneratorController, void> {
  /// Controller para geração de currículos profissionais para barbeiros
  const CVGeneratorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cVGeneratorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cVGeneratorControllerHash();

  @$internal
  @override
  CVGeneratorController create() => CVGeneratorController();
}

String _$cVGeneratorControllerHash() =>
    r'f2cb99addd2700cfd7a04f1943f1f2a9556b7e25';

/// Controller para geração de currículos profissionais para barbeiros

abstract class _$CVGeneratorController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
