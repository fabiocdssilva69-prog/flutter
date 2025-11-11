import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../core/config/api_keys.dart';

/// Serviço para integração com Google Gemini AI
class GeminiService {
  late final GenerativeModel _model;
  late final GenerativeModel _visionModel;

  GeminiService() {
    if (!ApiKeys.isGeminiConfigured) {
      throw Exception('Gemini API Key não configurada! Configure em lib/src/core/config/api_keys.dart');
    }

    // Modelo de texto (gemini-pro)
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: ApiKeys.geminiApiKey,
      generationConfig: GenerationConfig(temperature: 0.7, topK: 40, topP: 0.95, maxOutputTokens: 1024),
    );

    // Modelo de visão (gemini-pro-vision)
    _visionModel = GenerativeModel(
      model: 'gemini-pro-vision',
      apiKey: ApiKeys.geminiApiKey,
      generationConfig: GenerationConfig(temperature: 0.4, topK: 32, topP: 1.0, maxOutputTokens: 2048),
    );
  }

  /// Envia mensagem de texto para o Gemini
  ///
  /// [message] Mensagem do usuário
  /// [context] Contexto adicional (opcional)
  /// [conversationHistory] Histórico da conversa (opcional)
  ///
  /// Retorna a resposta do Gemini
  Future<String> sendMessage({required String message, String? context, List<Content>? conversationHistory}) async {
    try {
      // Construir prompt com contexto
      final prompt = _buildPrompt(message, context);

      // Se há histórico, usar chat
      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        final chat = _model.startChat(history: conversationHistory);
        final response = await chat.sendMessage(Content.text(prompt));
        return response.text ?? 'Desculpe, não consegui gerar uma resposta.';
      }

      // Sem histórico, usar generateContent
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Desculpe, não consegui gerar uma resposta.';
    } catch (e) {
      throw Exception('Erro ao enviar mensagem para Gemini: $e');
    }
  }

  /// Analisa uma imagem de corte de cabelo e sugere melhorias
  ///
  /// [imageBytes] Bytes da imagem
  /// [prompt] Prompt adicional (opcional)
  ///
  /// Retorna sugestões de estilo
  Future<String> analyzeHairstyle({required List<int> imageBytes, String? prompt}) async {
    try {
      final defaultPrompt = '''
Você é um especialista em cortes de cabelo e estilo masculino.
Analise esta imagem e forneça:

1. **Descrição do corte atual**: Descreva o estilo, comprimento, formato
2. **Pontos fortes**: O que está bom no visual atual
3. **Sugestões de melhoria**: 3 sugestões específicas para melhorar o corte
4. **Estilos recomendados**: 3 estilos que ficariam bem nesta pessoa
5. **Dicas de manutenção**: Como manter o corte em casa

Seja específico, prático e amigável. Use emojis quando apropriado.
''';

      final finalPrompt = prompt ?? defaultPrompt;

      final response = await _visionModel.generateContent([
        Content.multi([TextPart(finalPrompt), DataPart('image/jpeg', Uint8List.fromList(imageBytes))]),
      ]);

      return response.text ?? 'Não consegui analisar a imagem.';
    } catch (e) {
      throw Exception('Erro ao analisar imagem: $e');
    }
  }

  /// Busca recomendações de barbearias baseado em critérios
  ///
  /// [location] Localização do usuário
  /// [style] Estilo de corte desejado
  /// [budget] Faixa de preço
  ///
  /// Retorna recomendações
  Future<String> recommendBarbershops({required String location, String? style, String? budget}) async {
    try {
      final prompt =
          '''
Você é um guia local especializado em barbearias.

Localização: $location
${style != null ? 'Estilo desejado: $style' : ''}
${budget != null ? 'Orçamento: $budget' : ''}

Forneça:
1. **Top 3 barbearias recomendadas** nesta região
2. **Especialidades** de cada uma
3. **Faixa de preço** estimada
4. **Diferenciais** de cada barbearia
5. **Dicas**: O que considerar ao escolher

Seja específico e útil. Use emojis.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Não consegui gerar recomendações.';
    } catch (e) {
      throw Exception('Erro ao buscar recomendações: $e');
    }
  }

  /// Fornece dicas de cuidados capilares personalizadas
  ///
  /// [hairType] Tipo de cabelo (liso, cacheado, crespo, etc)
  /// [concern] Preocupação específica (queda, caspa, etc)
  ///
  /// Retorna dicas personalizadas
  Future<String> getHairCareTips({String? hairType, String? concern}) async {
    try {
      final prompt =
          '''
Você é um especialista em cuidados capilares masculinos.

${hairType != null ? 'Tipo de cabelo: $hairType' : ''}
${concern != null ? 'Preocupação: $concern' : ''}

Forneça:
1. **Rotina de cuidados**: Passo a passo diário
2. **Produtos recomendados**: Shampoo, condicionador, finalizadores
3. **Dicas específicas**: Para o tipo de cabelo mencionado
4. **Erros comuns**: O que evitar
5. **Frequência ideal**: Lavagem, cortes, tratamentos

Seja prático e direto. Use emojis.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Não consegui gerar dicas.';
    } catch (e) {
      throw Exception('Erro ao gerar dicas: $e');
    }
  }

  /// Gera sugestões de perguntas para o chat
  ///
  /// Retorna lista de perguntas sugeridas
  Future<List<String>> getSuggestedQuestions() async {
    try {
      final prompt = '''
Você é um assistente de barbearia.

Gere 5 perguntas comuns que usuários fazem sobre:
- Estilos de corte
- Cuidados com cabelo
- Escolha de barbearia
- Tendências

Formato: Uma pergunta por linha, sem numeração.
Seja direto e conciso.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';

      return text.split('\n').where((line) => line.trim().isNotEmpty).take(5).toList();
    } catch (e) {
      // Fallback para perguntas padrão
      return [
        'Qual corte está na moda?',
        'Como escolher uma boa barbearia?',
        'Quais produtos usar no cabelo?',
        'Como cuidar da barba?',
        'Com que frequência devo cortar?',
      ];
    }
  }

  /// Constrói prompt com contexto do BarberGo
  String _buildPrompt(String message, String? context) {
    final systemContext =
        '''
Você é um assistente virtual especializado em barbearias e estilo masculino.
Você faz parte do app BarberGo, um aplicativo tipo Tinder para conectar clientes e barbeiros.

Seu objetivo é:
- Ajudar usuários a encontrar o corte perfeito
- Recomendar barbearias próximas
- Dar dicas de cuidados capilares
- Sugerir estilos baseados em fotos
- Ser amigável, prestativo e informal

Sempre seja específico, prático e use emojis quando apropriado.
${context != null ? '\nContexto adicional: $context' : ''}
''';

    return '$systemContext\n\nUsuário: $message';
  }

  /// Stream de resposta (para exibir texto sendo digitado)
  ///
  /// [message] Mensagem do usuário
  ///
  /// Retorna stream de texto
  Stream<String> sendMessageStream(String message) async* {
    try {
      final prompt = _buildPrompt(message, null);
      final response = _model.generateContentStream([Content.text(prompt)]);

      await for (final chunk in response) {
        final text = chunk.text;
        if (text != null) {
          yield text;
        }
      }
    } catch (e) {
      yield 'Erro ao gerar resposta: $e';
    }
  }
}
