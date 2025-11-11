import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_service.g.dart';

/// Serviço de IA usando exclusivamente Google Gemini 2.0
///
/// Usa Gemini para todas as funcionalidades:
/// - Geração de texto rápida e eficiente
/// - Análise de imagens (multimodal)
/// - Conversação contextual
/// - Geração de documentos longos
@riverpod
class AIService extends _$AIService {
  @override
  Future<void> build() async {}

  /// Cria um modelo Gemini configurado
  GenerativeModel _getModel({double temperature = 0.7}) {
    final apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'] ?? '';
    return GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
      generationConfig: GenerationConfig(temperature: temperature, maxOutputTokens: 8192),
    );
  }

  /// Gera texto usando Gemini com retry automático
  ///
  /// Ideal para: biografias, descrições rápidas, sugestões
  Future<String> generateText({required String prompt, int maxRetries = 2, double temperature = 0.7}) async {
    state = const AsyncLoading();

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final model = _getModel(temperature: temperature);

        final enhancedPrompt =
            '''
Você é um assistente profissional especializado em conteúdo para barbeiros e barbearias.

$prompt
''';

        final response = await model.generateContent([Content.text(enhancedPrompt)]);

        final text = response.text?.trim();
        if (text == null || text.isEmpty) {
          throw Exception('Resposta vazia da IA');
        }

        state = const AsyncData(null);
        return text;
      } catch (e, st) {
        if (attempt == maxRetries) {
          state = AsyncError(e, st);
          rethrow;
        }
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }

    throw Exception('Falha após todas as tentativas');
  }

  /// Gera texto com contexto de conversação usando Gemini
  ///
  /// Ideal para: chat contextual, perguntas e respostas em série
  Future<String> generateTextWithContext({
    required List<Map<String, String>> conversation,
    required String newMessage,
  }) async {
    state = const AsyncLoading();

    try {
      final model = _getModel();

      // Construir histórico de conversação
      final conversationText = conversation.map((msg) => '${msg['role']}: ${msg['content']}').join('\n');

      final prompt =
          '''
Você é um assistente profissional especializado em conteúdo para barbeiros e barbearias.

Histórico da conversação:
$conversationText

Usuário: $newMessage

Responda de forma natural e útil:
''';

      final response = await model.generateContent([Content.text(prompt)]);

      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        throw Exception('Resposta vazia da IA');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Analisa uma imagem usando Gemini Vision
  ///
  /// Ideal para: análise de cortes, identificação de estilos
  Future<String> analyzeImage({required String imageUrl, String? context}) async {
    state = const AsyncLoading();

    try {
      final model = _getModel();

      final prompt = context ?? 'Descreva esta imagem em detalhes, focando em aspectos relevantes para barbearia.';

      // TODO: Implementar upload de imagem quando necessário
      // Por agora, apenas análise textual
      final response = await model.generateContent([Content.text('$prompt\n\nImagem em: $imageUrl')]);

      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        throw Exception('Falha ao analisar imagem');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Analisa múltiplas imagens usando Gemini Vision
  ///
  /// Ideal para: portfólios, comparações de antes/depois
  Future<String> analyzeMultipleImages({required List<String> imageUrls, String? context}) async {
    state = const AsyncLoading();

    try {
      final model = _getModel();

      final prompt =
          context ??
          'Analise estas ${imageUrls.length} imagens em conjunto, focando em aspectos relevantes para barbearia.';

      final imagesList = imageUrls.map((url) => '- $url').join('\n');

      // TODO: Implementar upload múltiplo quando necessário
      final response = await model.generateContent([Content.text('$prompt\n\nImagens:\n$imagesList')]);

      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        throw Exception('Falha ao analisar imagens');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera um documento longo usando Gemini
  ///
  /// Ideal para: termos de serviço, contratos, políticas
  Future<String> generateDocument({
    required String documentType,
    required Map<String, dynamic> params,
    int? maxTokens,
  }) async {
    state = const AsyncLoading();

    try {
      final model = _getModel(temperature: 0.3); // Mais formal

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

      final response = await model.generateContent([Content.text(prompt)]);

      final document = response.text?.trim();
      if (document == null || document.isEmpty) {
        throw Exception('Falha ao gerar documento');
      }

      state = const AsyncData(null);
      return document;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Corrige ortografia e gramática
  ///
  /// Ideal para: textos de perfil, descrições de serviços
  Future<String> correctSpelling({required String text, bool preserveStyle = true}) async {
    state = const AsyncLoading();

    try {
      final model = _getModel(temperature: 0.2); // Preciso

      final prompt =
          '''
Corrija ortografia e gramática do seguinte texto em português brasileiro:

"""
$text
"""

${preserveStyle ? 'Preserve o estilo e tom original do texto.' : ''}
Retorne APENAS o texto corrigido, sem explicações.
''';

      final response = await model.generateContent([Content.text(prompt)]);

      final corrected = response.text?.trim();
      if (corrected == null || corrected.isEmpty) {
        return text; // Retorna original se falhar
      }

      state = const AsyncData(null);
      return corrected;
    } catch (e, st) {
      state = AsyncError(e, st);
      return text; // Retorna original em caso de erro
    }
  }

  /// Analisa localização de negócio
  ///
  /// Ideal para: sugestões de melhorias, análise de mercado local
  Future<String> analyzeBusinessLocation({
    required String address,
    required String neighborhood,
    required String city,
  }) async {
    state = const AsyncLoading();

    try {
      final model = _getModel();

      final prompt =
          '''
Analise esta localização para uma barbearia:

Endereço: $address
Bairro: $neighborhood
Cidade: $city

Forneça:
1. Análise do potencial do local
2. Público-alvo típico da região
3. Sugestões de posicionamento
4. Diferenciais a explorar
5. Desafios potenciais

Foque no contexto brasileiro.
''';

      final response = await model.generateContent([Content.text(prompt)]);

      final analysis = response.text?.trim();
      if (analysis == null || analysis.isEmpty) {
        throw Exception('Falha ao analisar localização');
      }

      state = const AsyncData(null);
      return analysis;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Chat sobre arte de barbeiro
  ///
  /// Ideal para: dicas técnicas, tendências, aprendizado
  Future<String> chatAboutBarberArt({required String question, String? style}) async {
    state = const AsyncLoading();

    try {
      final model = _getModel(temperature: 0.8); // Mais criativo

      final prompt =
          '''
Você é um mestre barbeiro experiente com 20 anos de profissão.

${style != null ? 'Estilo de resposta: $style' : ''}

Pergunta: $question

Responda de forma profissional mas acessível, compartilhando conhecimento prático.
''';

      final response = await model.generateContent([Content.text(prompt)]);

      final answer = response.text?.trim();
      if (answer == null || answer.isEmpty) {
        throw Exception('Falha ao gerar resposta');
      }

      state = const AsyncData(null);
      return answer;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Recomenda produtos
  ///
  /// Ideal para: sugestões personalizadas, upsell
  Future<String> recommendProducts({
    required String hairType,
    required String desiredStyle,
    List<String>? currentProducts,
  }) async {
    state = const AsyncLoading();

    try {
      final model = _getModel();

      final currentProductsText = currentProducts != null && currentProducts.isNotEmpty
          ? '\nProdutos já usados: ${currentProducts.join(', ')}'
          : '';

      final prompt =
          '''
Recomende produtos profissionais de barbearia para:

Tipo de cabelo: $hairType
Estilo desejado: $desiredStyle$currentProductsText

Forneça:
1. 3-5 produtos específicos (pomadas, óleos, etc)
2. Justificativa para cada recomendação
3. Ordem de aplicação
4. Dicas de uso

Foque em produtos disponíveis no mercado brasileiro.
''';

      final response = await model.generateContent([Content.text(prompt)]);

      final recommendations = response.text?.trim();
      if (recommendations == null || recommendations.isEmpty) {
        throw Exception('Falha ao gerar recomendações');
      }

      state = const AsyncData(null);
      return recommendations;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
