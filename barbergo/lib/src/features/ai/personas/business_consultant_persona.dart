import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/ai/chat_message.dart';
import '../abstractions/ai_persona.dart';
import '../providers/ai_service.dart';

part 'business_consultant_persona.g.dart';

/// Provedor para acessar a Persona de Consultoria de Negócios
///
/// O Provedor da Persona agora também se torna assíncrono (FutureProvider).
@riverpod
Future<BusinessConsultantPersona> businessConsultantPersona(ref) async {
  final aiService = ref.watch(aIServiceProvider.notifier);
  // Configuração específica para Negócios (Modelo robusto, temperatura moderada)
  return BusinessConsultantPersona(
    aiService: aiService,
    model: 'gpt-4o', // Modelo completo para consultoria estratégica
    temperature: 0.6, // Moderada - equilibra criatividade e precisão
  );
}

/// Persona especializada em Consultoria de Negócios para Barbearias
///
/// Características:
/// - Tom profissional e estratégico
/// - Foco em viabilidade e resultados práticos
/// - Análise de mercado, finanças e crescimento
/// - Temperatura moderada (0.6) para respostas equilibradas
class BusinessConsultantPersona extends AiPersona {
  BusinessConsultantPersona({required super.aiService, required super.model, super.temperature});

  @override
  Future<String> getResponse(List<ChatMessage> history) async {
    // Prepara histórico de mensagens para contexto
    final conversationHistory = formatHistoryForOpenAI(history);

    // Pega a última mensagem do usuário
    final lastUserMessage = history
        .lastWhere((msg) => msg.role == MessageRole.user, orElse: () => history.last)
        .content;

    // Cria prompt customizado com contexto de consultoria
    final enhancedPrompt =
        """
[CONTEXTO: Consultoria de Negócios para Barbearias no Brasil]

Como consultor especializado em barbearias, responda considerando:
- Viabilidade prática e financeira
- Realidade do mercado brasileiro
- Estratégias de baixo custo quando aplicável
- Dados concretos e exemplos reais

Pergunta do cliente:
$lastUserMessage

Forneça resposta profissional, objetiva e acionável.
""";

    // Chama AIService com contexto completo
    final response = await aiService.generateTextWithContext(
      conversation: conversationHistory,
      newMessage: enhancedPrompt,
    );

    return response;
  }
}
