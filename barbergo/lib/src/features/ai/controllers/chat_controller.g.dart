// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provedor auxiliar que mapeia o 'personaKey' (String) para a implementação real de AiPersona.
///
/// Persona Keys disponíveis:
/// - 'business' → BusinessConsultantPersona
/// - 'artistic' → ArtisticChatbotPersona
/// - 'writing' → WritingAssistantPersona
///
/// Provedor auxiliar agora também é assíncrono (FutureProvider).

@ProviderFor(aiPersona)
const aiPersonaProvider = AiPersonaFamily._();

/// Provedor auxiliar que mapeia o 'personaKey' (String) para a implementação real de AiPersona.
///
/// Persona Keys disponíveis:
/// - 'business' → BusinessConsultantPersona
/// - 'artistic' → ArtisticChatbotPersona
/// - 'writing' → WritingAssistantPersona
///
/// Provedor auxiliar agora também é assíncrono (FutureProvider).

final class AiPersonaProvider
    extends
        $FunctionalProvider<
          AsyncValue<AiPersona>,
          AiPersona,
          FutureOr<AiPersona>
        >
    with $FutureModifier<AiPersona>, $FutureProvider<AiPersona> {
  /// Provedor auxiliar que mapeia o 'personaKey' (String) para a implementação real de AiPersona.
  ///
  /// Persona Keys disponíveis:
  /// - 'business' → BusinessConsultantPersona
  /// - 'artistic' → ArtisticChatbotPersona
  /// - 'writing' → WritingAssistantPersona
  ///
  /// Provedor auxiliar agora também é assíncrono (FutureProvider).
  const AiPersonaProvider._({
    required AiPersonaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'aiPersonaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aiPersonaHash();

  @override
  String toString() {
    return r'aiPersonaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AiPersona> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AiPersona> create(Ref ref) {
    final argument = this.argument as String;
    return aiPersona(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AiPersonaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiPersonaHash() => r'daf3ab3684dac316b77b34075bc451232ed856d4';

/// Provedor auxiliar que mapeia o 'personaKey' (String) para a implementação real de AiPersona.
///
/// Persona Keys disponíveis:
/// - 'business' → BusinessConsultantPersona
/// - 'artistic' → ArtisticChatbotPersona
/// - 'writing' → WritingAssistantPersona
///
/// Provedor auxiliar agora também é assíncrono (FutureProvider).

final class AiPersonaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AiPersona>, String> {
  const AiPersonaFamily._()
    : super(
        retry: null,
        name: r'aiPersonaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provedor auxiliar que mapeia o 'personaKey' (String) para a implementação real de AiPersona.
  ///
  /// Persona Keys disponíveis:
  /// - 'business' → BusinessConsultantPersona
  /// - 'artistic' → ArtisticChatbotPersona
  /// - 'writing' → WritingAssistantPersona
  ///
  /// Provedor auxiliar agora também é assíncrono (FutureProvider).

  AiPersonaProvider call(String personaKey) =>
      AiPersonaProvider._(argument: personaKey, from: this);

  @override
  String toString() => r'aiPersonaProvider';
}

/// O Controlador principal do Chat Unificado usando arquitetura de AsyncNotifier.
///
/// **SPRINT 10 - Mudanças Arquiteturais:**
/// - Migração de StreamNotifier → AsyncNotifier para controle imperativo de paginação
/// - Estado gerenciado via ChatStateData (messages, hasMore, isLoadingMore)
/// - Paginação cursor-based com 30 mensagens por página
/// - Sistema de feedback (Like/Dislike) integrado
/// - Atualização otimista da UI (UX aprimorada)
///
/// **Características:**
/// - Usa `family` para manter estados de chat separados por persona
/// - Paginação eficiente com fetchInitialMessages() e fetchMoreMessages()
/// - Persistência automática de mensagens
/// - Analytics integrado para todas as interações
/// - Separação entre estado dos dados (ChatStateData) e estado da ação (isAwaitingResponse)
///
/// **Uso:**
/// ```dart
/// final chatState = ref.watch(chatControllerProvider('artistic'));
/// ref.read(chatControllerProvider('artistic').notifier).sendMessage('Olá!');
/// ref.read(chatControllerProvider('artistic').notifier).loadMore();
/// final isLoading = ref.read(chatControllerProvider('artistic').notifier).isAwaitingResponse;
/// ```

@ProviderFor(ChatController)
const chatControllerProvider = ChatControllerFamily._();

/// O Controlador principal do Chat Unificado usando arquitetura de AsyncNotifier.
///
/// **SPRINT 10 - Mudanças Arquiteturais:**
/// - Migração de StreamNotifier → AsyncNotifier para controle imperativo de paginação
/// - Estado gerenciado via ChatStateData (messages, hasMore, isLoadingMore)
/// - Paginação cursor-based com 30 mensagens por página
/// - Sistema de feedback (Like/Dislike) integrado
/// - Atualização otimista da UI (UX aprimorada)
///
/// **Características:**
/// - Usa `family` para manter estados de chat separados por persona
/// - Paginação eficiente com fetchInitialMessages() e fetchMoreMessages()
/// - Persistência automática de mensagens
/// - Analytics integrado para todas as interações
/// - Separação entre estado dos dados (ChatStateData) e estado da ação (isAwaitingResponse)
///
/// **Uso:**
/// ```dart
/// final chatState = ref.watch(chatControllerProvider('artistic'));
/// ref.read(chatControllerProvider('artistic').notifier).sendMessage('Olá!');
/// ref.read(chatControllerProvider('artistic').notifier).loadMore();
/// final isLoading = ref.read(chatControllerProvider('artistic').notifier).isAwaitingResponse;
/// ```
final class ChatControllerProvider
    extends $AsyncNotifierProvider<ChatController, ChatStateData> {
  /// O Controlador principal do Chat Unificado usando arquitetura de AsyncNotifier.
  ///
  /// **SPRINT 10 - Mudanças Arquiteturais:**
  /// - Migração de StreamNotifier → AsyncNotifier para controle imperativo de paginação
  /// - Estado gerenciado via ChatStateData (messages, hasMore, isLoadingMore)
  /// - Paginação cursor-based com 30 mensagens por página
  /// - Sistema de feedback (Like/Dislike) integrado
  /// - Atualização otimista da UI (UX aprimorada)
  ///
  /// **Características:**
  /// - Usa `family` para manter estados de chat separados por persona
  /// - Paginação eficiente com fetchInitialMessages() e fetchMoreMessages()
  /// - Persistência automática de mensagens
  /// - Analytics integrado para todas as interações
  /// - Separação entre estado dos dados (ChatStateData) e estado da ação (isAwaitingResponse)
  ///
  /// **Uso:**
  /// ```dart
  /// final chatState = ref.watch(chatControllerProvider('artistic'));
  /// ref.read(chatControllerProvider('artistic').notifier).sendMessage('Olá!');
  /// ref.read(chatControllerProvider('artistic').notifier).loadMore();
  /// final isLoading = ref.read(chatControllerProvider('artistic').notifier).isAwaitingResponse;
  /// ```
  const ChatControllerProvider._({
    required ChatControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @override
  String toString() {
    return r'chatControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatController create() => ChatController();

  @override
  bool operator ==(Object other) {
    return other is ChatControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatControllerHash() => r'ae33d3294feb2219cf8dc42f5aa612d5e13830a4';

/// O Controlador principal do Chat Unificado usando arquitetura de AsyncNotifier.
///
/// **SPRINT 10 - Mudanças Arquiteturais:**
/// - Migração de StreamNotifier → AsyncNotifier para controle imperativo de paginação
/// - Estado gerenciado via ChatStateData (messages, hasMore, isLoadingMore)
/// - Paginação cursor-based com 30 mensagens por página
/// - Sistema de feedback (Like/Dislike) integrado
/// - Atualização otimista da UI (UX aprimorada)
///
/// **Características:**
/// - Usa `family` para manter estados de chat separados por persona
/// - Paginação eficiente com fetchInitialMessages() e fetchMoreMessages()
/// - Persistência automática de mensagens
/// - Analytics integrado para todas as interações
/// - Separação entre estado dos dados (ChatStateData) e estado da ação (isAwaitingResponse)
///
/// **Uso:**
/// ```dart
/// final chatState = ref.watch(chatControllerProvider('artistic'));
/// ref.read(chatControllerProvider('artistic').notifier).sendMessage('Olá!');
/// ref.read(chatControllerProvider('artistic').notifier).loadMore();
/// final isLoading = ref.read(chatControllerProvider('artistic').notifier).isAwaitingResponse;
/// ```

final class ChatControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatController,
          AsyncValue<ChatStateData>,
          ChatStateData,
          FutureOr<ChatStateData>,
          String
        > {
  const ChatControllerFamily._()
    : super(
        retry: null,
        name: r'chatControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// O Controlador principal do Chat Unificado usando arquitetura de AsyncNotifier.
  ///
  /// **SPRINT 10 - Mudanças Arquiteturais:**
  /// - Migração de StreamNotifier → AsyncNotifier para controle imperativo de paginação
  /// - Estado gerenciado via ChatStateData (messages, hasMore, isLoadingMore)
  /// - Paginação cursor-based com 30 mensagens por página
  /// - Sistema de feedback (Like/Dislike) integrado
  /// - Atualização otimista da UI (UX aprimorada)
  ///
  /// **Características:**
  /// - Usa `family` para manter estados de chat separados por persona
  /// - Paginação eficiente com fetchInitialMessages() e fetchMoreMessages()
  /// - Persistência automática de mensagens
  /// - Analytics integrado para todas as interações
  /// - Separação entre estado dos dados (ChatStateData) e estado da ação (isAwaitingResponse)
  ///
  /// **Uso:**
  /// ```dart
  /// final chatState = ref.watch(chatControllerProvider('artistic'));
  /// ref.read(chatControllerProvider('artistic').notifier).sendMessage('Olá!');
  /// ref.read(chatControllerProvider('artistic').notifier).loadMore();
  /// final isLoading = ref.read(chatControllerProvider('artistic').notifier).isAwaitingResponse;
  /// ```

  ChatControllerProvider call(String personaKey) =>
      ChatControllerProvider._(argument: personaKey, from: this);

  @override
  String toString() => r'chatControllerProvider';
}

/// O Controlador principal do Chat Unificado usando arquitetura de AsyncNotifier.
///
/// **SPRINT 10 - Mudanças Arquiteturais:**
/// - Migração de StreamNotifier → AsyncNotifier para controle imperativo de paginação
/// - Estado gerenciado via ChatStateData (messages, hasMore, isLoadingMore)
/// - Paginação cursor-based com 30 mensagens por página
/// - Sistema de feedback (Like/Dislike) integrado
/// - Atualização otimista da UI (UX aprimorada)
///
/// **Características:**
/// - Usa `family` para manter estados de chat separados por persona
/// - Paginação eficiente com fetchInitialMessages() e fetchMoreMessages()
/// - Persistência automática de mensagens
/// - Analytics integrado para todas as interações
/// - Separação entre estado dos dados (ChatStateData) e estado da ação (isAwaitingResponse)
///
/// **Uso:**
/// ```dart
/// final chatState = ref.watch(chatControllerProvider('artistic'));
/// ref.read(chatControllerProvider('artistic').notifier).sendMessage('Olá!');
/// ref.read(chatControllerProvider('artistic').notifier).loadMore();
/// final isLoading = ref.read(chatControllerProvider('artistic').notifier).isAwaitingResponse;
/// ```

abstract class _$ChatController extends $AsyncNotifier<ChatStateData> {
  late final _$args = ref.$arg as String;
  String get personaKey => _$args;

  FutureOr<ChatStateData> build(String personaKey);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<ChatStateData>, ChatStateData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatStateData>, ChatStateData>,
              AsyncValue<ChatStateData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
