// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream provider de sessões de chat

@ProviderFor(chatSessions)
const chatSessionsProvider = ChatSessionsProvider._();

/// Stream provider de sessões de chat

final class ChatSessionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AiChatSessionEntity>>,
          List<AiChatSessionEntity>,
          Stream<List<AiChatSessionEntity>>
        >
    with
        $FutureModifier<List<AiChatSessionEntity>>,
        $StreamProvider<List<AiChatSessionEntity>> {
  /// Stream provider de sessões de chat
  const ChatSessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSessionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSessionsHash();

  @$internal
  @override
  $StreamProviderElement<List<AiChatSessionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AiChatSessionEntity>> create(Ref ref) {
    return chatSessions(ref);
  }
}

String _$chatSessionsHash() => r'253e7aba518e94ee2be9515b6ef48d87dab9ef14';

/// Stream provider de mensagens de uma sessão

@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesFamily._();

/// Stream provider de mensagens de uma sessão

final class ChatMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AiMessageEntity>>,
          List<AiMessageEntity>,
          Stream<List<AiMessageEntity>>
        >
    with
        $FutureModifier<List<AiMessageEntity>>,
        $StreamProvider<List<AiMessageEntity>> {
  /// Stream provider de mensagens de uma sessão
  const ChatMessagesProvider._({
    required ChatMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @override
  String toString() {
    return r'chatMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<AiMessageEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AiMessageEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return chatMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessagesHash() => r'71ee6772527a99d20cad0f1f43700a9fc3154017';

/// Stream provider de mensagens de uma sessão

final class ChatMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<AiMessageEntity>>, String> {
  const ChatMessagesFamily._()
    : super(
        retry: null,
        name: r'chatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Stream provider de mensagens de uma sessão

  ChatMessagesProvider call(String sessionId) =>
      ChatMessagesProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'chatMessagesProvider';
}

/// Stream provider de sugestões salvas

@ProviderFor(styleSuggestions)
const styleSuggestionsProvider = StyleSuggestionsProvider._();

/// Stream provider de sugestões salvas

final class StyleSuggestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StyleSuggestionEntity>>,
          List<StyleSuggestionEntity>,
          Stream<List<StyleSuggestionEntity>>
        >
    with
        $FutureModifier<List<StyleSuggestionEntity>>,
        $StreamProvider<List<StyleSuggestionEntity>> {
  /// Stream provider de sugestões salvas
  const StyleSuggestionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'styleSuggestionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$styleSuggestionsHash();

  @$internal
  @override
  $StreamProviderElement<List<StyleSuggestionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<StyleSuggestionEntity>> create(Ref ref) {
    return styleSuggestions(ref);
  }
}

String _$styleSuggestionsHash() => r'e1bd80a9c65c2249e2e261e9f65500b2460e81c4';

/// Provider de perguntas sugeridas

@ProviderFor(suggestedQuestions)
const suggestedQuestionsProvider = SuggestedQuestionsProvider._();

/// Provider de perguntas sugeridas

final class SuggestedQuestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Provider de perguntas sugeridas
  const SuggestedQuestionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suggestedQuestionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suggestedQuestionsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return suggestedQuestions(ref);
  }
}

String _$suggestedQuestionsHash() =>
    r'e120c6f08b41bd6748d1909fa02ebe4b3af2ece5';

@ProviderFor(AiController)
const aiControllerProvider = AiControllerProvider._();

final class AiControllerProvider
    extends $AsyncNotifierProvider<AiController, void> {
  const AiControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiControllerHash();

  @$internal
  @override
  AiController create() => AiController();
}

String _$aiControllerHash() => r'2a2829c2c46f3ac133aa0ce530ed83d428cc2619';

abstract class _$AiController extends $AsyncNotifier<void> {
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
