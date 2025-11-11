// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Serviço de IA usando exclusivamente Google Gemini 2.0
///
/// Usa Gemini para todas as funcionalidades:
/// - Geração de texto rápida e eficiente
/// - Análise de imagens (multimodal)
/// - Conversação contextual
/// - Geração de documentos longos

@ProviderFor(AIService)
const aIServiceProvider = AIServiceProvider._();

/// Serviço de IA usando exclusivamente Google Gemini 2.0
///
/// Usa Gemini para todas as funcionalidades:
/// - Geração de texto rápida e eficiente
/// - Análise de imagens (multimodal)
/// - Conversação contextual
/// - Geração de documentos longos
final class AIServiceProvider extends $AsyncNotifierProvider<AIService, void> {
  /// Serviço de IA usando exclusivamente Google Gemini 2.0
  ///
  /// Usa Gemini para todas as funcionalidades:
  /// - Geração de texto rápida e eficiente
  /// - Análise de imagens (multimodal)
  /// - Conversação contextual
  /// - Geração de documentos longos
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

String _$aIServiceHash() => r'3d6e401b4dd84d8fedb01d410bf24f743c84f362';

/// Serviço de IA usando exclusivamente Google Gemini 2.0
///
/// Usa Gemini para todas as funcionalidades:
/// - Geração de texto rápida e eficiente
/// - Análise de imagens (multimodal)
/// - Conversação contextual
/// - Geração de documentos longos

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
