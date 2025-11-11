import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/chat_entity.dart';
import '../repositories/chat_repository.dart';

part 'chat_controller.g.dart';

/// Provider para observar todos os chats do usuário
@riverpod
Stream<List<ChatEntity>> userChats(Ref ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchUserChats();
}

/// Controller para ações de chat
@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<void> build() {}

  /// Get or create chat with another user
  Future<ChatEntity?> getOrCreateChat(String otherUserId) async {
    ChatEntity? result;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      result = await repository.getOrCreateChat(otherUserId);
    });

    return result;
  }

  /// Delete chat
  Future<void> deleteChat(String chatId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      await repository.deleteChat(chatId);
    });
  }
}
