// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artistic_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller de chat para o Chatbot Artístico
///
/// Gerencia o histórico de conversação local e integra com o BarberChatbotController
/// para obter respostas da IA sobre técnicas, tendências e arte da barbearia.

@ProviderFor(ArtisticChatController)
const artisticChatControllerProvider = ArtisticChatControllerProvider._();

/// Controller de chat para o Chatbot Artístico
///
/// Gerencia o histórico de conversação local e integra com o BarberChatbotController
/// para obter respostas da IA sobre técnicas, tendências e arte da barbearia.
final class ArtisticChatControllerProvider
    extends
        $NotifierProvider<
          ArtisticChatController,
          AsyncValue<List<ChatMessage>>
        > {
  /// Controller de chat para o Chatbot Artístico
  ///
  /// Gerencia o histórico de conversação local e integra com o BarberChatbotController
  /// para obter respostas da IA sobre técnicas, tendências e arte da barbearia.
  const ArtisticChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'artisticChatControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$artisticChatControllerHash();

  @$internal
  @override
  ArtisticChatController create() => ArtisticChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ChatMessage>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<ChatMessage>>>(
        value,
      ),
    );
  }
}

String _$artisticChatControllerHash() =>
    r'9150b12d40f365f65abdde4b143162c697713cc9';

/// Controller de chat para o Chatbot Artístico
///
/// Gerencia o histórico de conversação local e integra com o BarberChatbotController
/// para obter respostas da IA sobre técnicas, tendências e arte da barbearia.

abstract class _$ArtisticChatController
    extends $Notifier<AsyncValue<List<ChatMessage>>> {
  AsyncValue<List<ChatMessage>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ChatMessage>>,
              AsyncValue<List<ChatMessage>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ChatMessage>>,
                AsyncValue<List<ChatMessage>>
              >,
              AsyncValue<List<ChatMessage>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
