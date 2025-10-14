import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/ai/chat_message.dart';
import 'barber_chatbot_controller.dart';

part 'artistic_chat_controller.g.dart';

/// Controller de chat para o Chatbot Artístico
///
/// Gerencia o histórico de conversação local e integra com o BarberChatbotController
/// para obter respostas da IA sobre técnicas, tendências e arte da barbearia.
@riverpod
class ArtisticChatController extends _$ArtisticChatController {
  @override
  AsyncValue<List<ChatMessage>> build() {
    // Inicia com lista vazia
    return const AsyncValue.data([]);
  }

  /// Envia mensagem do usuário e obtém resposta da IA
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Obter histórico atual
    final current = state.value ?? [];

    // Adicionar mensagem do usuário
    final userMessage = ChatMessage.user(content);
    final updatedWithUser = <ChatMessage>[...current, userMessage];

    // Atualizar estado imediatamente com mensagem do usuário
    state = AsyncValue.data(updatedWithUser);

    try {
      // Converter histórico para formato do AIService
      final conversationHistory = current.map((msg) => msg.toMap()).toList();

      // Obter resposta da IA
      final chatbotController = ref.read(
        barberChatbotControllerProvider.notifier,
      );
      final response = await chatbotController.sendMessage(
        message: content,
        conversationHistory: conversationHistory,
      );

      // Adicionar resposta da IA
      final aiMessage = ChatMessage.assistant(response);
      final finalMessages = <ChatMessage>[...updatedWithUser, aiMessage];

      state = AsyncValue.data(finalMessages);
    } catch (e) {
      // Adicionar mensagem de erro
      final errorMessage = ChatMessage.error(
        'Desculpe, ocorreu um erro ao processar sua mensagem. Tente novamente.',
      );
      final messagesWithError = <ChatMessage>[...updatedWithUser, errorMessage];

      state = AsyncValue.data(messagesWithError);
    }
  }

  /// Limpa o histórico de chat
  void clearChat() {
    state = const AsyncValue.data(<ChatMessage>[]);
  }

  /// Retorna se está aguardando resposta da IA
  bool get isAwaitingResponse => state.when(
    loading: () => true,
    data: (_) => false,
    error: (error, stackTrace) => false,
  );
}
