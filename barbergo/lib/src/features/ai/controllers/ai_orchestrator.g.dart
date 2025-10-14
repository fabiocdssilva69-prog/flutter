// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_orchestrator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Orquestrador inteligente que decide qual modelo usar

@ProviderFor(AIOrchestrator)
const aIOrchestratorProvider = AIOrchestratorProvider._();

/// Orquestrador inteligente que decide qual modelo usar
final class AIOrchestratorProvider
    extends $AsyncNotifierProvider<AIOrchestrator, void> {
  /// Orquestrador inteligente que decide qual modelo usar
  const AIOrchestratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aIOrchestratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aIOrchestratorHash();

  @$internal
  @override
  AIOrchestrator create() => AIOrchestrator();
}

String _$aIOrchestratorHash() => r'56647ded9cd540a49aadcf5f36628e6cdfb6d237';

/// Orquestrador inteligente que decide qual modelo usar

abstract class _$AIOrchestrator extends $AsyncNotifier<void> {
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
