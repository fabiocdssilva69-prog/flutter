import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Conversor necessário para salvar DateTime como Timestamp no Firestore com Freezed
/// 
/// O Firestore armazena datas como Timestamp, mas trabalhamos com DateTime no código.
/// Este conversor faz a tradução automaticamente durante serialização/deserialização.
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

/// Roles possíveis para mensagens no chat
enum MessageRole {
  user,      // Mensagem enviada pelo usuário
  assistant, // Resposta da IA
  system,    // Mensagem do sistema (opcional)
}

/// Entidade que representa uma mensagem individual no chat com IA
/// 
/// Estrutura otimizada para:
/// - Persistência no Firestore
/// - Serialização/deserialização JSON
/// - Ordenação por timestamp
/// - Identificação de erros
/// 
/// Exemplo de uso:
/// ```dart
/// final message = ChatMessage(
///   id: 'msg_123',
///   role: MessageRole.user,
///   content: 'Como fazer um fade perfeito?',
///   timestamp: DateTime.now(),
/// );
/// ```
@freezed
class ChatMessage with _$ChatMessage {
  // Usamos explicitToJson para garantir que o conversor funcione corretamente
  @JsonSerializable(explicitToJson: true)
  const factory ChatMessage({
    /// ID único da mensagem (UUID)
    required String id,
    
    /// Role da mensagem (user/assistant/system)
    required MessageRole role,
    
    /// Conteúdo textual da mensagem
    required String content,
    
    /// Timestamp de quando a mensagem foi criada
    /// Aplica o conversor para Firestore Timestamp
    @TimestampConverter() required DateTime timestamp,
    
    /// Flag para indicar se houve erro ao processar
    @Default(false) bool isError,
    
    /// Metadados opcionais (ex: modelo usado, tokens consumidos)
    @Default({}) Map<String, dynamic> metadata,
  }) = _ChatMessage;

  const ChatMessage._(); // Permite extensões

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  /// Factory para criar mensagem do usuário
  factory ChatMessage.user({
    String? id,
    required String content,
    DateTime? timestamp,
  }) =>
      ChatMessage(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.user,
        content: content,
        timestamp: timestamp ?? DateTime.now(),
      );

  /// Factory para criar mensagem da IA
  factory ChatMessage.assistant({
    String? id,
    required String content,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) =>
      ChatMessage(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        content: content,
        timestamp: timestamp ?? DateTime.now(),
        metadata: metadata ?? {},
      );

  /// Factory para criar mensagem de sistema
  factory ChatMessage.system({
    String? id,
    required String content,
    DateTime? timestamp,
  }) =>
      ChatMessage(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.system,
        content: content,
        timestamp: timestamp ?? DateTime.now(),
      );

  /// Verifica se a mensagem é do usuário
  bool get isUser => role == MessageRole.user;

  /// Verifica se a mensagem é da IA
  bool get isAssistant => role == MessageRole.assistant;

  /// Verifica se a mensagem é do sistema
  bool get isSystem => role == MessageRole.system;

  /// Retorna timestamp formatado (HH:mm)
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Retorna data e hora formatadas (dd/MM/yyyy HH:mm)
  String get formattedDateTime {
    final day = timestamp.day.toString().padLeft(2, '0');
    final month = timestamp.month.toString().padLeft(2, '0');
    final year = timestamp.year;
    return '$day/$month/$year ${formattedTime}';
  }

  /// Estimativa de tokens (aproximada)
  int get estimatedTokens => (content.length / 4).ceil();
}

/// Extensão para listas de mensagens
extension ChatMessageListExtensions on List<ChatMessage> {
  /// Filtra apenas mensagens do usuário
  List<ChatMessage> get userMessages =>
      where((m) => m.isUser).toList();

  /// Filtra apenas mensagens da IA
  List<ChatMessage> get assistantMessages =>
      where((m) => m.isAssistant).toList();

  /// Filtra mensagens sem erro
  List<ChatMessage> get validMessages =>
      where((m) => !m.isError).toList();

  /// Calcula total estimado de tokens
  int get estimatedTokens =>
      fold(0, (sum, msg) => sum + msg.estimatedTokens);

  /// Retorna últimas N mensagens
  List<ChatMessage> takeLast(int count) =>
      length <= count ? this : sublist(length - count);

  /// Converte para formato esperado pela OpenAI API
  List<Map<String, String>> toOpenAIFormat() {
    return where((m) => !m.isError && !m.isSystem)
        .map((m) => {
              'role': m.role.name,
              'content': m.content,
            })
        .toList();
  }
}