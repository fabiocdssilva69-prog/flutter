// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para gerenciar sistema de prompts (Hinge model)

@ProviderFor(PromptsController)
const promptsControllerProvider = PromptsControllerProvider._();

/// Controller para gerenciar sistema de prompts (Hinge model)
final class PromptsControllerProvider
    extends $AsyncNotifierProvider<PromptsController, void> {
  /// Controller para gerenciar sistema de prompts (Hinge model)
  const PromptsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'promptsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$promptsControllerHash();

  @$internal
  @override
  PromptsController create() => PromptsController();
}

String _$promptsControllerHash() => r'15eebef405b81fc8233bc71b9aad857d3d6ab774';

/// Controller para gerenciar sistema de prompts (Hinge model)

abstract class _$PromptsController extends $AsyncNotifier<void> {
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
