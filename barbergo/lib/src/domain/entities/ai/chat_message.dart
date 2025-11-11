import 'package:dart_mappable/dart_mappable.dart';

import '../../../core/infrastructure/mappable_hooks.dart';

part 'chat_message.mapper.dart';

enum MessageRole { user, assistant }

enum MessageFeedback { none, thumbsUp, thumbsDown }

@MappableClass()
class ChatMessage with ChatMessageMappable {
  final String id;
  final MessageRole role;
  final String content;

  @MappableField(hook: TimestampHook())
  final DateTime timestamp;

  final bool isError;
  final MessageFeedback feedback;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isError = false,
    this.feedback = MessageFeedback.none,
  });

  // Factory constructors convenientes
  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.assistant(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.assistant,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.error(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.assistant,
      content: content,
      timestamp: DateTime.now(),
      isError: true,
    );
  }

  // Getters de compatibilidade
  bool get isUser => role == MessageRole.user;
  DateTime get createdAt => timestamp;

  static const fromMap = ChatMessageMapper.fromMap;
}
