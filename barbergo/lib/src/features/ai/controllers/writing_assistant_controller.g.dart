// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'writing_assistant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para correção ortográfica e assistência de escrita

@ProviderFor(WritingAssistantController)
const writingAssistantControllerProvider =
    WritingAssistantControllerProvider._();

/// Controller para correção ortográfica e assistência de escrita
final class WritingAssistantControllerProvider
    extends $AsyncNotifierProvider<WritingAssistantController, void> {
  /// Controller para correção ortográfica e assistência de escrita
  const WritingAssistantControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'writingAssistantControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$writingAssistantControllerHash();

  @$internal
  @override
  WritingAssistantController create() => WritingAssistantController();
}

String _$writingAssistantControllerHash() =>
    r'5ad21d505608a3a75655146d53fc331a49b391bf';

/// Controller para correção ortográfica e assistência de escrita

abstract class _$WritingAssistantController extends $AsyncNotifier<void> {
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
