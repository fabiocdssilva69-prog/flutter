/// Entidade simples para mensagens de chat com IA
class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime createdAt;
  final bool isError;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.createdAt,
    this.isError = false,
  });

  /// Cria mensagem do usuário
  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}_user',
      content: content,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );
  }

  /// Cria mensagem do assistente
  factory ChatMessage.assistant(String content) {
    return ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}_assistant',
      content: content,
      role: MessageRole.assistant,
      createdAt: DateTime.now(),
    );
  }

  /// Cria mensagem de erro
  factory ChatMessage.error(String content) {
    return ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}_error',
      content: content,
      role: MessageRole.assistant,
      createdAt: DateTime.now(),
      isError: true,
    );
  }

  /// Helpers
  bool get isUser => role == MessageRole.user;
  bool get isAssistant => role == MessageRole.assistant;

  /// Converte para Map (para passar ao AIService)
  Map<String, String> toMap() {
    return {
      'role': role == MessageRole.user ? 'user' : 'assistant',
      'content': content,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? createdAt,
    bool? isError,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isError: isError ?? this.isError,
    );
  }
}

enum MessageRole { user, assistant }
