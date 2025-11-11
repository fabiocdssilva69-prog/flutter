import '../../../domain/entities/ai/chat_message.dart';
import '../providers/ai_service.dart';

/// Classe abstrata que define a interface para todas as personas de IA de chat.
///
/// Uma Persona encapsula:
/// - System prompt específico
/// - Configuração de modelo (GPT-4, temperatura, etc.)
/// - Lógica de formatação de mensagens
/// - Comportamento de conversação
abstract class AiPersona {
  final AIService aiService;
  final String model;
  final double temperature;

  AiPersona({required this.aiService, required this.model, this.temperature = 0.7});

  /// Método principal que as subclasses devem implementar.
  ///
  /// Recebe histórico de mensagens e retorna resposta da IA.
  /// Cada persona implementa sua própria lógica de prompt engineering.
  Future<String> getResponse(List<ChatMessage> history);

  /// Método auxiliar para converter ChatMessage (nosso domínio) para o formato da OpenAI.
  ///
  /// Inclui lógica para limitar o histórico enviado (economia de tokens).
  /// - Filtra mensagens de erro (não devem ser enviadas à API)
  /// - Limita quantidade de mensagens (parâmetro `limit`)
  /// - Converte para formato Map compatível com AIService
  List<Map<String, String>> formatHistoryForOpenAI(List<ChatMessage> history, {int limit = 15}) {
    // Pega apenas as últimas 'limit' mensagens que não são de erro
    final relevantHistory = history.where((m) => !m.isError).toList();
    final limitedHistory = relevantHistory.length > limit
        ? relevantHistory.sublist(relevantHistory.length - limit)
        : relevantHistory;

    return limitedHistory.map((msg) {
      return {
        'role': msg.role.name, // 'user' ou 'assistant'
        'content': msg.content,
      };
    }).toList();
  }

  /// Helper para criar system prompt
  ///
  /// Algumas personas podem precisar de system prompts dinâmicos
  String getSystemPrompt() {
    throw UnimplementedError('Subclasse deve implementar getSystemPrompt() ou sobrescrever getResponse()');
  }
}
