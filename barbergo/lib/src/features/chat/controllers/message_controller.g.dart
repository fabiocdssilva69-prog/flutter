// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider para observar mensagens de um chat específico

@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesFamily._();

/// Provider para observar mensagens de um chat específico

final class ChatMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MessageEntity>>,
          List<MessageEntity>,
          Stream<List<MessageEntity>>
        >
    with
        $FutureModifier<List<MessageEntity>>,
        $StreamProvider<List<MessageEntity>> {
  /// Provider para observar mensagens de um chat específico
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
  $StreamProviderElement<List<MessageEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MessageEntity>> create(Ref ref) {
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

String _$chatMessagesHash() => r'344a7f7887038c951c22ac89e2bb8a57e0d71454';

/// Provider para observar mensagens de um chat específico

final class ChatMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MessageEntity>>, String> {
  const ChatMessagesFamily._()
    : super(
        retry: null,
        name: r'chatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider para observar mensagens de um chat específico

  ChatMessagesProvider call(String chatId) =>
      ChatMessagesProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatMessagesProvider';
}

/// Controller para ações de mensagens

@ProviderFor(MessageController)
const messageControllerProvider = MessageControllerProvider._();

/// Controller para ações de mensagens
final class MessageControllerProvider
    extends $AsyncNotifierProvider<MessageController, void> {
  /// Controller para ações de mensagens
  const MessageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messageControllerHash();

  @$internal
  @override
  MessageController create() => MessageController();
}

String _$messageControllerHash() => r'81c3912bc7ef1fc245ff57b42a183a258e5eaeb3';

/// Controller para ações de mensagens

abstract class _$MessageController extends $AsyncNotifier<void> {
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
