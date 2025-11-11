import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'multi_ai_provider.g.dart';

/// Serviço unificado usando apenas Google Gemini 2.0
@riverpod
class GeminiService extends _$GeminiService {
  @override
  Future<void> build() async {}

  /// Cria um modelo Gemini configurado
  GenerativeModel _getModel({double temperature = 0.7}) {
    final apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty || apiKey.contains('YOUR_') || apiKey.contains('HERE')) {
      throw Exception(
        'GOOGLE_GEMINI_API_KEY não configurada. '
        'Adicione sua chave no arquivo .env na raiz do projeto',
      );
    }

    return GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
      generationConfig: GenerationConfig(temperature: temperature, maxOutputTokens: 8192),
    );
  }

  /// Gera texto usando Gemini
  Future<String> generateText({required String prompt, String? systemInstruction, double temperature = 0.7}) async {
    state = const AsyncLoading();

    try {
      final model = _getModel(temperature: temperature);

      final enhancedPrompt = systemInstruction != null ? '$systemInstruction\n\n$prompt' : prompt;

      final response = await model.generateContent([Content.text(enhancedPrompt)]);

      final text = response.text?.trim() ?? '';

      if (text.isEmpty) {
        throw Exception('Resposta vazia do Gemini');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera JSON estruturado usando Gemini
  Future<String> generateJSON({required String prompt}) async {
    state = const AsyncLoading();

    try {
      final model = _getModel(temperature: 0.2); // Mais determinístico

      final enhancedPrompt =
          '''
$prompt

IMPORTANTE: Retorne APENAS JSON válido, sem explicações, markdown ou formatação adicional.
''';

      final response = await model.generateContent([Content.text(enhancedPrompt)]);

      final jsonText = response.text ?? '{}';

      state = const AsyncData(null);
      return jsonText.trim();
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera documento estruturado (contrato, termos, etc)
  Future<String> generateDocument({required String documentType, required Map<String, dynamic> params}) async {
    state = const AsyncLoading();

    try {
      final paramsText = params.entries.map((e) => '- ${e.key}: ${e.value}').join('\n');

      final prompt =
          '''
Gere um documento profissional de $documentType com base nos seguintes parâmetros:

$paramsText

Requisitos:
- Linguagem jurídica apropriada
- Português brasileiro formal
- Estrutura clara com seções numeradas
- Compliance com LGPD quando aplicável
- Formatação em Markdown
''';

      final model = _getModel(temperature: 0.3); // Formal e preciso

      final response = await model.generateContent([Content.text(prompt)]);

      final document = response.text ?? '';

      state = const AsyncData(null);
      return document;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
