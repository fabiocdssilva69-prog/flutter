// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatRoomRepository)
const chatRoomRepositoryProvider = ChatRoomRepositoryProvider._();

final class ChatRoomRepositoryProvider
    extends
        $FunctionalProvider<
          ChatRoomRepository,
          ChatRoomRepository,
          ChatRoomRepository
        >
    with $Provider<ChatRoomRepository> {
  const ChatRoomRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRoomRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRoomRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRoomRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatRoomRepository create(Ref ref) {
    return chatRoomRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRoomRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRoomRepository>(value),
    );
  }
}

String _$chatRoomRepositoryHash() =>
    r'fd446eff65da69d98fbf10b5edb266bb99c0ab52';
