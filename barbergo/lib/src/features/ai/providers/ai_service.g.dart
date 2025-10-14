// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Serviço de IA usando exclusivamente OpenAI GPT-4
///
/// Usa GPT-4 para todas as funcionalidades:
/// - Geração de texto (gpt-4o-mini para operações rápidas)
/// - Análise de imagens (GPT-4 Vision)
/// - Conversação contextual
/// - Geração de documentos longos (gpt-4o completo)

@ProviderFor(AIService)
const aIServiceProvider = AIServiceProvider._();

/// Serviço de IA usando exclusivamente OpenAI GPT-4
///
/// Usa GPT-4 para todas as funcionalidades:
/// - Geração de texto (gpt-4o-mini para operações rápidas)
/// - Análise de imagens (GPT-4 Vision)
/// - Conversação contextual
/// - Geração de documentos longos (gpt-4o completo)
final class AIServiceProvider extends $AsyncNotifierProvider<AIService, void> {
  /// Serviço de IA usando exclusivamente OpenAI GPT-4
  ///
  /// Usa GPT-4 para todas as funcionalidades:
  /// - Geração de texto (gpt-4o-mini para operações rápidas)
  /// - Análise de imagens (GPT-4 Vision)
  /// - Conversação contextual
  /// - Geração de documentos longos (gpt-4o completo)
  const AIServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aIServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aIServiceHash();

  @$internal
  @override
  AIService create() => AIService();
}

String _$aIServiceHash() => r'60798d820d41fc3aea9ac92dd3aec727e87be8a0';

/// Serviço de IA usando exclusivamente OpenAI GPT-4
///
/// Usa GPT-4 para todas as funcionalidades:
/// - Geração de texto (gpt-4o-mini para operações rápidas)
/// - Análise de imagens (GPT-4 Vision)
/// - Conversação contextual
/// - Geração de documentos longos (gpt-4o completo)

abstract class _$AIService extends $AsyncNotifier<void> {
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
