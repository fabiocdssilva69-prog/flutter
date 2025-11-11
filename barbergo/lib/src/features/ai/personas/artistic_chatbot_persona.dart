import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/ai/chat_message.dart';
import '../abstractions/ai_persona.dart';
import '../providers/ai_service.dart';

part 'artistic_chatbot_persona.g.dart';

/// Provedor para acessar a Persona de Chatbot Artístico
///
/// Especializada em técnicas, tendências e arte da barbearia
/// O Provedor da Persona agora também se torna assíncrono (FutureProvider).
@riverpod
Future<ArtisticChatbotPersona> artisticChatbotPersona(ref) async {
  final aiService = ref.watch(aIServiceProvider.notifier);
  // Configuração específica para Arte (Modelo capaz, temperatura alta para criatividade)
  return ArtisticChatbotPersona(
    aiService: aiService,
    model: 'gpt-4o-mini', // Modelo rápido e criativo
    temperature: 0.9, // Alta temperatura = mais criatividade e inspiração
  );
}

/// Persona especializada em Mundo Artístico de Cabelos e Barbas
///
/// Características:
/// - Tom criativo, inspirador e apaixonado
/// - Foco em técnicas, estilos e tendências
/// - Linguagem descritiva e visual
/// - Temperatura alta (0.9) para respostas criativas
class ArtisticChatbotPersona extends AiPersona {
  ArtisticChatbotPersona({required super.aiService, required super.model, super.temperature});

  @override
  Future<String> getResponse(List<ChatMessage> history) async {
    // Pega a última mensagem do usuário
    final lastUserMessage = history
        .lastWhere((msg) => msg.role == MessageRole.user, orElse: () => history.last)
        .content;

    // Prompt customizado com contexto artístico
    final enhancedPrompt =
        """
[CONTEXTO: Mentor de Estilo e Tendências de Barbearia]

Como especialista apaixonado pelo mundo artístico de cabelos e barbas, responda sobre:

🎨 Técnicas de corte (fade, degradê, undercut, pompadour, etc.)
✂️ Produtos (pomadas, óleos, bálsamos, ceras)
📈 Tendências atuais e estilos em alta
🧔 Cuidados com cabelo e barba
💡 História e evolução da barbearia
🎯 Lado criativo e artístico da profissão

Sua personalidade:
- Criativa e inspiradora
- Visual e descritiva
- Encoraja experimentação
- Compartilha paixão pela arte

Pergunta do barbeiro/cliente:
$lastUserMessage

Responda de forma envolvente, educativa e inspiradora.
""";

    // Usa método chatAboutBarberArt que já existe no AIService
    final response = await aiService.chatAboutBarberArt(question: enhancedPrompt);

    return response;
  }
}
