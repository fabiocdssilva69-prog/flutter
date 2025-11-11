import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/ai_service.dart';

part 'barber_chatbot_controller.g.dart';

/// Controller para chatbot especializado no mundo artístico de cabelos e barbas
@riverpod
class BarberChatbotController extends _$BarberChatbotController {
  @override
  FutureOr<void> build() {}

  /// Envia mensagem ao chatbot e recebe resposta
  Future<String> sendMessage({required String message, List<Map<String, String>>? conversationHistory}) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final response = await aiService.chatAboutBarberArt(question: message);

      state = const AsyncData(null);
      return response;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Obtém dicas sobre técnicas específicas
  Future<String> getTechniqueTips({required String technique, String? difficulty}) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final difficultyText = difficulty != null ? ' (nível: $difficulty)' : '';

      final message =
          '''
Me dê dicas detalhadas sobre a técnica: $technique$difficultyText

Inclua:
- O que é e quando usar
- Passo a passo básico
- Ferramentas necessárias
- Erros comuns a evitar
- Dicas de profissional
''';

      final response = await aiService.chatAboutBarberArt(question: message);

      state = const AsyncData(null);
      return response;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Sugere tendências atuais de cortes e estilos
  Future<List<String>> getTrends({String? category}) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final categoryText = category != null ? ' na categoria: $category' : '';

      final message =
          '''
Liste as principais tendências atuais de cortes e estilos$categoryText

Para cada tendência, forneça:
- Nome do estilo
- Descrição breve
- Para quem é ideal

Liste 6-8 tendências. Separe cada uma com "---".
''';

      final response = await aiService.chatAboutBarberArt(question: message);

      final trends = response.split('---').map((trend) => trend.trim()).where((trend) => trend.isNotEmpty).toList();

      state = const AsyncData(null);
      return trends.isEmpty ? [response] : trends;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Recomenda produtos para situações específicas
  Future<String> recommendProducts({required String hairType, required String desiredStyle, String? concerns}) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final response = await aiService.recommendProducts(hairType: hairType, desiredStyle: desiredStyle);

      state = const AsyncData(null);
      return response;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Responde dúvidas sobre história da barbearia
  Future<String> askHistoryQuestion({required String question}) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final message =
          '''
Responda esta pergunta sobre história da barbearia: $question

Seja educativo, interessante e conte histórias fascinantes.
Inclua curiosidades quando relevante.
''';

      final response = await aiService.chatAboutBarberArt(question: message);

      state = const AsyncData(null);
      return response;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Dá sugestões criativas de cortes baseado em características do cliente
  Future<String> suggestHaircut({
    required String faceShape,
    required String hairTexture,
    required String lifestyle,
    String? preferences,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final prefsText = preferences != null ? '\nPreferências: $preferences' : '';

      final message =
          '''
Sugira cortes ideais para um cliente com:

👤 Formato do rosto: $faceShape
💇 Textura do cabelo: $hairTexture
🏃 Estilo de vida: $lifestyle$prefsText

Sugira 3-4 opções diferentes explicando por que cada uma funciona bem.
Inclua dicas de manutenção para cada opção.
''';

      final response = await aiService.chatAboutBarberArt(question: message);

      state = const AsyncData(null);
      return response;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
