// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'writing_assistant_persona.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provedor para acessar a Persona de Assistente de Escrita
///
/// Especializada em copywriting e redação para barbearias
/// O Provedor da Persona agora também se torna assíncrono (FutureProvider).

@ProviderFor(writingAssistantPersona)
const writingAssistantPersonaProvider = WritingAssistantPersonaProvider._();

/// Provedor para acessar a Persona de Assistente de Escrita
///
/// Especializada em copywriting e redação para barbearias
/// O Provedor da Persona agora também se torna assíncrono (FutureProvider).

final class WritingAssistantPersonaProvider
    extends
        $FunctionalProvider<
          AsyncValue<WritingAssistantPersona>,
          WritingAssistantPersona,
          FutureOr<WritingAssistantPersona>
        >
    with
        $FutureModifier<WritingAssistantPersona>,
        $FutureProvider<WritingAssistantPersona> {
  /// Provedor para acessar a Persona de Assistente de Escrita
  ///
  /// Especializada em copywriting e redação para barbearias
  /// O Provedor da Persona agora também se torna assíncrono (FutureProvider).
  const WritingAssistantPersonaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'writingAssistantPersonaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$writingAssistantPersonaHash();

  @$internal
  @override
  $FutureProviderElement<WritingAssistantPersona> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WritingAssistantPersona> create(Ref ref) {
    return writingAssistantPersona(ref);
  }
}

String _$writingAssistantPersonaHash() =>
    r'cf081d1f83da23b578f254a92465561ed5941ff4';
