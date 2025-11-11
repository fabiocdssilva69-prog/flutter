import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/controllers/profile_controller.dart';
import '../controllers/message_controller.dart';
import '../models/message_entity.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String text) {
    ref.read(messageControllerProvider.notifier).sendMessage(
          chatId: widget.chatId,
          text: text,
        );
    _scrollToBottom();
  }

  void _sendImage(File imageFile) {
    ref.read(messageControllerProvider.notifier).sendImageMessage(
          chatId: widget.chatId,
          imageFile: imageFile,
        );
    _scrollToBottom();
  }

  void _markMessagesAsRead(List<MessageEntity> messages) {
    final currentUserId = ref.read(currentUserProfileProvider).value?.userId;
    if (currentUserId == null) return;

    final unreadMessageIds = messages
        .where((msg) =>
            msg.senderId != currentUserId && !msg.isReadBy(currentUserId))
        .map((msg) => msg.id)
        .toList();

    if (unreadMessageIds.isNotEmpty) {
      ref.read(messageControllerProvider.notifier).markAsRead(
            widget.chatId,
            unreadMessageIds,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final currentUser = ref.watch(currentUserProfileProvider).value;
    final messageState = ref.watch(messageControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              child: Icon(Icons.person, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuário', // TODO: Get name from profile
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Online', // TODO: Implement presence
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma mensagem ainda',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Envie uma mensagem para começar',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Mark messages as read
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _markMessagesAsRead(messages);
                });

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUser?.userId;
                    
                    // Check if we should show avatar (different sender than next message)
                    final showAvatar = index == 0 ||
                        messages[index - 1].senderId != message.senderId;

                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                      showAvatar: showAvatar,
                      senderName: isMe ? null : 'Usuário', // TODO: Get name
                      onLongPress: () {
                        if (isMe) {
                          _showDeleteDialog(message);
                        }
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text('Erro ao carregar mensagens'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(chatMessagesProvider(widget.chatId)),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Input
          ChatInput(
            onSendMessage: _sendMessage,
            onSendImage: _sendImage,
            enabled: !messageState.isLoading,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(MessageEntity message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir mensagem'),
        content: const Text('Deseja realmente excluir esta mensagem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref.read(messageControllerProvider.notifier).deleteMessage(
                    widget.chatId,
                    message.id,
                  );
              Navigator.pop(context);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
