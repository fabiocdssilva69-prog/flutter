// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_orchestrator_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider para o Orquestrador de IAs

@ProviderFor(AIOrchestrator)
const aIOrchestratorProvider = AIOrchestratorProvider._();

/// Provider para o Orquestrador de IAs
final class AIOrchestratorProvider
    extends $AsyncNotifierProvider<AIOrchestrator, void> {
  /// Provider para o Orquestrador de IAs
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

String _$aIOrchestratorHash() => r'f8d82f9573c55b44b2772ddfb9f6c2bdb9dca145';

/// Provider para o Orquestrador de IAs

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
