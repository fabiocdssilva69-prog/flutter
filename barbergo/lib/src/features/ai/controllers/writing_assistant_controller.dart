import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/ai_service.dart';

part 'writing_assistant_controller.g.dart';

/// Controller para correção ortográfica e assistência de escrita
@riverpod
class WritingAssistantController extends _$WritingAssistantController {
  @override
  FutureOr<void> build() {}

  /// Corrige apenas ortografia e gramática
  Future<String> correctSpelling({required String text}) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final corrected = await aiService.correctSpelling(
        text: text,
        improveWriting: false,
      );

      state = const AsyncData(null);
      return corrected;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Corrige e melhora a escrita
  Future<String> improveWriting({required String text}) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final improved = await aiService.correctSpelling(
        text: text,
        improveWriting: true,
      );

      state = const AsyncData(null);
      return improved;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera ideias de posts para redes sociais
  Future<List<String>> generateSocialMediaIdeas({
    required String topic,
    int quantity = 5,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final ideas = await aiService.generateSocialMediaIdeas(
        topic: topic,
        quantity: quantity,
      );

      state = const AsyncData(null);
      return ideas;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Reescreve texto em tom diferente
  Future<String> rewriteInTone({
    required String text,
    required String tone,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final prompt =
          '''
Reescreva este texto no tom: $tone

Texto original:
$text

Mantenha o significado mas ajuste o tom e estilo para ser $tone.
''';

      final rewritten = await aiService.generateText(
        prompt: prompt,
        temperature: 0.7,
      );

      state = const AsyncData(null);
      return rewritten;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera legendas para fotos de portfólio
  Future<List<String>> generateCaptions({
    required String imageDescription,
    required String style,
    int quantity = 3,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final prompt =
          '''
Gere $quantity legendas $style para uma foto de portfólio:

Descrição da foto: $imageDescription

Cada legenda deve:
- Ter entre 1-3 frases
- Ser autêntica e profissional
- Incluir emojis relevantes
- Engajar o público

Separe cada legenda com "---".
''';

      final response = await aiService.generateText(
        prompt: prompt,
        temperature: 0.8,
      );

      final captions = response
          .split('---')
          .map((caption) => caption.trim())
          .where((caption) => caption.isNotEmpty)
          .toList();

      state = const AsyncData(null);
      return captions.isEmpty ? [response] : captions;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Expande texto curto em versão mais detalhada
  Future<String> expandText({
    required String shortText,
    String? additionalContext,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final contextText = additionalContext != null
          ? '\n\nContexto adicional: $additionalContext'
          : '';

      final prompt =
          '''
Expanda este texto curto em uma versão mais detalhada e completa:

$shortText$contextText

Mantenha o tom profissional, adicione detalhes relevantes e exemplos quando apropriado.
Faça o texto fluir naturalmente.
''';

      final expanded = await aiService.generateText(
        prompt: prompt,
        temperature: 0.7,
      );

      state = const AsyncData(null);
      return expanded;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Resume texto longo em versão concisa
  Future<String> summarizeText({
    required String longText,
    int? maxWords,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final wordLimit = maxWords != null
          ? ' em no máximo $maxWords palavras'
          : '';

      final prompt =
          '''
Resuma este texto$wordLimit:

$longText

Mantenha os pontos principais e a essência da mensagem.
''';

      final summary = await aiService.generateText(
        prompt: prompt,
        temperature: 0.5,
      );

      state = const AsyncData(null);
      return summary;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
