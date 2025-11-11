// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider para observar todos os chats do usuário

@ProviderFor(userChats)
const userChatsProvider = UserChatsProvider._();

/// Provider para observar todos os chats do usuário

final class UserChatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatEntity>>,
          List<ChatEntity>,
          Stream<List<ChatEntity>>
        >
    with $FutureModifier<List<ChatEntity>>, $StreamProvider<List<ChatEntity>> {
  /// Provider para observar todos os chats do usuário
  const UserChatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userChatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userChatsHash();

  @$internal
  @override
  $StreamProviderElement<List<ChatEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatEntity>> create(Ref ref) {
    return userChats(ref);
  }
}

String _$userChatsHash() => r'd56d677e3820aca3e79de8251536768c4ac473f0';

/// Controller para ações de chat

@ProviderFor(ChatController)
const chatControllerProvider = ChatControllerProvider._();

/// Controller para ações de chat
final class ChatControllerProvider
    extends $AsyncNotifierProvider<ChatController, void> {
  /// Controller para ações de chat
  const ChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @$internal
  @override
  ChatController create() => ChatController();
}

String _$chatControllerHash() => r'851e6ea4ca0eaedec4aa2c33abfd33c03aaeb772';

/// Controller para ações de chat

abstract class _$ChatController extends $AsyncNotifier<void> {
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
