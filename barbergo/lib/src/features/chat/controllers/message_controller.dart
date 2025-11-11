import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/message_entity.dart';
import '../repositories/chat_repository.dart';

part 'message_controller.g.dart';

/// Provider para observar mensagens de um chat específico
@riverpod
Stream<List<MessageEntity>> chatMessages(Ref ref, String chatId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchMessages(chatId);
}

/// Controller para ações de mensagens
@riverpod
class MessageController extends _$MessageController {
  @override
  FutureOr<void> build() {}

  /// Send text message
  Future<void> sendMessage({required String chatId, required String text, String? replyToId}) async {
    if (text.trim().isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      await repository.sendMessage(chatId: chatId, text: text.trim(), replyToId: replyToId);
    });
  }

  /// Send image message
  Future<void> sendImageMessage({required String chatId, required File imageFile, String? caption}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      await repository.sendImageMessage(chatId: chatId, imagePath: imageFile.path, caption: caption);
    });
  }

  /// Mark messages as read
  Future<void> markAsRead(String chatId, List<String> messageIds) async {
    if (messageIds.isEmpty) return;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      await repository.markAsRead(chatId, messageIds);
    });
  }

  /// Delete message
  Future<void> deleteMessage(String chatId, String messageId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      await repository.deleteMessage(chatId, messageId);
    });
  }
}
