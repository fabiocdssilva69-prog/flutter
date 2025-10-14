// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claude_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Serviço de IA usando Claude da Anthropic
///
/// Especializado em tarefas que requerem:
/// - Análise jurídica e contratos
/// - Documentos formais e profissionais
/// - Respostas mais seguras e éticas
/// - Processamento de textos longos

@ProviderFor(ClaudeService)
const claudeServiceProvider = ClaudeServiceProvider._();

/// Serviço de IA usando Claude da Anthropic
///
/// Especializado em tarefas que requerem:
/// - Análise jurídica e contratos
/// - Documentos formais e profissionais
/// - Respostas mais seguras e éticas
/// - Processamento de textos longos
final class ClaudeServiceProvider
    extends $AsyncNotifierProvider<ClaudeService, void> {
  /// Serviço de IA usando Claude da Anthropic
  ///
  /// Especializado em tarefas que requerem:
  /// - Análise jurídica e contratos
  /// - Documentos formais e profissionais
  /// - Respostas mais seguras e éticas
  /// - Processamento de textos longos
  const ClaudeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'claudeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$claudeServiceHash();

  @$internal
  @override
  ClaudeService create() => ClaudeService();
}

String _$claudeServiceHash() => r'499add66a5e0665f830450ff8455fece0c13c831';

/// Serviço de IA usando Claude da Anthropic
///
/// Especializado em tarefas que requerem:
/// - Análise jurídica e contratos
/// - Documentos formais e profissionais
/// - Respostas mais seguras e éticas
/// - Processamento de textos longos

abstract class _$ClaudeService extends $AsyncNotifier<void> {
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
