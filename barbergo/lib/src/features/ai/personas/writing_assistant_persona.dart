import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/ai/chat_message.dart';
import '../abstractions/ai_persona.dart';
import '../providers/ai_service.dart';

part 'writing_assistant_persona.g.dart';

/// Provedor para acessar a Persona de Assistente de Escrita
///
/// Especializada em copywriting e redação para barbearias
/// O Provedor da Persona agora também se torna assíncrono (FutureProvider).
@riverpod
Future<WritingAssistantPersona> writingAssistantPersona(ref) async {
  final aiService = ref.watch(aIServiceProvider.notifier);
  // Configuração específica para Escrita (Modelo robusto, temperatura moderada)
  return WritingAssistantPersona(
    aiService: aiService,
    model: 'gpt-4o-mini', // Modelo eficiente para escrita
    temperature: 0.7, // Temperatura equilibrada
  );
}

/// Persona especializada em Copywriting e Redação para Barbearias
///
/// Características:
/// - Tom adaptável ao contexto (profissional, casual, persuasivo)
/// - Foco em clareza e impacto
/// - Otimização para redes sociais e comunicação
/// - Temperatura moderada (0.7) para equilíbrio
class WritingAssistantPersona extends AiPersona {
  WritingAssistantPersona({required super.aiService, required super.model, super.temperature});

  @override
  Future<String> getResponse(List<ChatMessage> history) async {
    // Prepara histórico de mensagens
    final conversationHistory = formatHistoryForOpenAI(history);

    // Pega a última mensagem do usuário
    final lastUserMessage = history
        .lastWhere((msg) => msg.role == MessageRole.user, orElse: () => history.last)
        .content;

    // Prompt customizado com contexto de copywriting
    final enhancedPrompt =
        """
[CONTEXTO: Assistente de Copywriting e Redação para Barbearias]

Como especialista em comunicação para o nicho de barbearias, ajude com:

📝 Criação e revisão de textos
📱 Posts para redes sociais
💼 Comunicação profissional com clientes
📋 Descrições de vagas e serviços
✍️ Correção ortográfica e gramática
🎯 Copywriting persuasivo

Sua abordagem:
- Analise o input e contexto fornecido
- Forneça versões otimizadas, claras e persuasivas
- Adapte tom ao contexto (profissional, casual, criativo)
- Mantenha autenticidade da mensagem
- Use técnicas de copywriting quando aplicável

Solicitação do usuário:
$lastUserMessage

Forneça resposta prática e diretamente aplicável.
""";

    // Chama AIService com contexto
    final response = await aiService.generateTextWithContext(
      conversation: conversationHistory,
      newMessage: enhancedPrompt,
    );

    return response;
  }
}
