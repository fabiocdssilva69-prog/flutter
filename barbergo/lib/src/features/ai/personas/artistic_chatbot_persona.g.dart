// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artistic_chatbot_persona.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provedor para acessar a Persona de Chatbot Artístico
///
/// Especializada em técnicas, tendências e arte da barbearia
/// O Provedor da Persona agora também se torna assíncrono (FutureProvider).

@ProviderFor(artisticChatbotPersona)
const artisticChatbotPersonaProvider = ArtisticChatbotPersonaProvider._();

/// Provedor para acessar a Persona de Chatbot Artístico
///
/// Especializada em técnicas, tendências e arte da barbearia
/// O Provedor da Persona agora também se torna assíncrono (FutureProvider).

final class ArtisticChatbotPersonaProvider
    extends
        $FunctionalProvider<
          AsyncValue<ArtisticChatbotPersona>,
          ArtisticChatbotPersona,
          FutureOr<ArtisticChatbotPersona>
        >
    with
        $FutureModifier<ArtisticChatbotPersona>,
        $FutureProvider<ArtisticChatbotPersona> {
  /// Provedor para acessar a Persona de Chatbot Artístico
  ///
  /// Especializada em técnicas, tendências e arte da barbearia
  /// O Provedor da Persona agora também se torna assíncrono (FutureProvider).
  const ArtisticChatbotPersonaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'artisticChatbotPersonaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$artisticChatbotPersonaHash();

  @$internal
  @override
  $FutureProviderElement<ArtisticChatbotPersona> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ArtisticChatbotPersona> create(Ref ref) {
    return artisticChatbotPersona(ref);
  }
}

String _$artisticChatbotPersonaHash() =>
    r'37ed6074ce64af14f620fd1d702844601c0f7a2d';
