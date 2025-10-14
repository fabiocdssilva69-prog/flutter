import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:openai_dart/openai_dart.dart';
import 'multi_ai_provider.dart';

part 'ai_service.g.dart';

/// Serviço de IA usando exclusivamente OpenAI GPT-4
///
/// Usa GPT-4 para todas as funcionalidades:
/// - Geração de texto (gpt-4o-mini para operações rápidas)
/// - Análise de imagens (GPT-4 Vision)
/// - Conversação contextual
/// - Geração de documentos longos (gpt-4o completo)
@riverpod
class AIService extends _$AIService {
  @override
  Future<void> build() async {}

  /// Gera texto usando GPT-4o-mini com retry automático
  ///
  /// Ideal para: biografias, descrições rápidas, sugestões
  Future<String> generateText({
    required String prompt,
    int maxRetries = 2,
    double temperature = 0.7,
  }) async {
    state = const AsyncLoading();

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final client = ref.read(openAIClientProvider);

        final response = await client.createChatCompletion(
          request: CreateChatCompletionRequest(
            model: ChatCompletionModel.modelId('gpt-4o-mini'),
            messages: [
              ChatCompletionMessage.system(
                content:
                    'Você é um assistente profissional especializado em conteúdo para barbeiros e barbearias.',
              ),
              ChatCompletionMessage.user(
                content: ChatCompletionUserMessageContent.string(prompt),
              ),
            ],
            temperature: temperature,
            maxTokens: 500,
          ),
        );

        final text = response.choices.first.message.content?.trim();
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

  /// Gera texto com contexto de conversação usando GPT-4o-mini
  ///
  /// Ideal para: chat contextual, perguntas e respostas em série
  Future<String> generateTextWithContext({
    required List<Map<String, String>> conversation,
    required String newMessage,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      // Construir histórico de conversação
      final messages = <ChatCompletionMessage>[
        ChatCompletionMessage.system(
          content:
              'Você é um assistente profissional especializado em conteúdo para barbeiros e barbearias.',
        ),
      ];

      // Adicionar histórico
      for (final msg in conversation) {
        if (msg['role'] == 'user') {
          messages.add(
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(msg['content']!),
            ),
          );
        } else {
          messages.add(
            ChatCompletionMessage.assistant(content: msg['content']),
          );
        }
      }

      // Adicionar nova mensagem
      messages.add(
        ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(newMessage),
        ),
      );

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o-mini'),
          messages: messages,
          temperature: 0.7,
          maxTokens: 800,
        ),
      );

      final text = response.choices.first.message.content?.trim();
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

  /// Analisa uma imagem usando GPT-4 Vision
  ///
  /// Ideal para: análise de cortes, avaliação de qualidade
  /// Nota: imageUrl deve ser URL pública ou data URI (base64)
  Future<String> analyzeImage({
    required String imageUrl,
    required String prompt,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o-mini'),
          messages: [
            ChatCompletionMessage.system(
              content:
                  'Você é um especialista em análise de cortes de cabelo e estilos de barbearia.',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.parts([
                ChatCompletionMessageContentPart.text(text: prompt),
                ChatCompletionMessageContentPart.image(
                  imageUrl: ChatCompletionMessageImageUrl(url: imageUrl),
                ),
              ]),
            ),
          ],
          temperature: 0.4,
          maxTokens: 1000,
        ),
      );

      final text = response.choices.first.message.content?.trim();
      if (text == null || text.isEmpty) {
        throw Exception('Não foi possível analisar a imagem');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Analisa múltiplas imagens usando GPT-4 Vision
  ///
  /// Ideal para: análise de portfólio, comparação de estilos
  /// Nota: imageUrls devem ser URLs públicas ou data URIs (base64)
  Future<String> analyzeMultipleImages({
    required List<String> imageUrls,
    required String prompt,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final contentParts = <ChatCompletionMessageContentPart>[
        ChatCompletionMessageContentPart.text(text: prompt),
        ...imageUrls.map(
          (url) => ChatCompletionMessageContentPart.image(
            imageUrl: ChatCompletionMessageImageUrl(url: url),
          ),
        ),
      ];

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o-mini'),
          messages: [
            ChatCompletionMessage.system(
              content:
                  'Você é um especialista em análise de portfólios de barbeiros e estilos de cortes.',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.parts(contentParts),
            ),
          ],
          temperature: 0.4,
          maxTokens: 1500,
        ),
      );

      final text = response.choices.first.message.content?.trim();
      if (text == null || text.isEmpty) {
        throw Exception('Não foi possível analisar as imagens');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera documentos longos e detalhados usando GPT-4o completo
  ///
  /// Ideal para: contratos, termos de serviço, documentos formais
  /// Usa modelo completo para melhor qualidade em textos longos
  Future<String> generateDocument({
    required String prompt,
    double temperature = 0.3,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            ChatCompletionMessage.system(
              content:
                  'Você é um especialista em documentação legal e contratos para o setor de serviços de barbearia.',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(prompt),
            ),
          ],
          temperature: temperature,
          maxTokens: 4000,
        ),
      );

      final text = response.choices.first.message.content?.trim();
      if (text == null || text.isEmpty) {
        throw Exception('Não foi possível gerar o documento');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Corrige ortografia e gramática de textos
  ///
  /// Ideal para: posts, descrições, mensagens profissionais
  Future<String> correctSpelling({
    required String text,
    bool improveWriting = false,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final systemPrompt = improveWriting
          ? 'Você é um revisor profissional. Corrija ortografia, gramática e MELHORE a clareza e fluidez do texto, mantendo o tom profissional.'
          : 'Você é um corretor ortográfico. Corrija APENAS erros de ortografia e gramática, mantendo o texto original o mais próximo possível.';

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o-mini'),
          messages: [
            ChatCompletionMessage.system(content: systemPrompt),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(
                'Texto para corrigir:\n\n$text',
              ),
            ),
          ],
          temperature: 0.3,
          maxTokens: 1000,
        ),
      );

      final corrected = response.choices.first.message.content?.trim();
      if (corrected == null || corrected.isEmpty) {
        throw Exception('Não foi possível corrigir o texto');
      }

      state = const AsyncData(null);
      return corrected;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera sugestões de formatação para currículos
  ///
  /// Retorna lista de sugestões em formato JSON
  Future<Map<String, dynamic>> suggestResumeFormat({
    required String experience,
    required String targetRole,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o-mini'),
          messages: [
            ChatCompletionMessage.system(
              content:
                  'Você é um especialista em currículos para profissionais de barbearia. Responda APENAS com JSON válido.',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(
                'Sugira formatação de currículo para:\nExperiência: $experience\nCargo desejado: $targetRole\n\nRetorne JSON com: sections (array de strings), highlights (array de strings), tips (array de strings)',
              ),
            ),
          ],
          temperature: 0.5,
          maxTokens: 800,
        ),
      );

      final jsonText = response.choices.first.message.content?.trim();
      if (jsonText == null || jsonText.isEmpty) {
        throw Exception('Não foi possível gerar sugestões');
      }

      // Parse JSON (assumindo resposta válida)
      state = const AsyncData(null);
      return {'raw': jsonText}; // Controller irá fazer parse
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Analisa locais ideais para abrir barbearia
  ///
  /// Considera: demografia, concorrência, custos, potencial
  Future<String> analyzeBusinessLocation({
    required String city,
    required String neighborhood,
    String? budget,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final budgetInfo = budget != null ? '\nOrçamento: $budget' : '';

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            ChatCompletionMessage.system(
              content:
                  'Você é um consultor especializado em abertura de negócios no setor de barbearias. Forneça análises detalhadas com dados relevantes.',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(
                'Analise a viabilidade de abrir uma barbearia:\nCidade: $city\nBairro: $neighborhood$budgetInfo\n\nForneça análise de: 1) Perfil demográfico, 2) Concorrência estimada, 3) Precificação sugerida, 4) Pontos de atenção, 5) Potencial de lucro',
              ),
            ),
          ],
          temperature: 0.6,
          maxTokens: 2000,
        ),
      );

      final analysis = response.choices.first.message.content?.trim();
      if (analysis == null || analysis.isEmpty) {
        throw Exception('Não foi possível analisar a localização');
      }

      state = const AsyncData(null);
      return analysis;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Chatbot conversacional sobre o mundo artístico de cabelos e barbas
  ///
  /// Mantém contexto da conversa para respostas mais naturais
  Future<String> chatAboutBarberArt({
    required String userMessage,
    List<Map<String, String>>? conversationHistory,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final messages = <ChatCompletionMessage>[
        ChatCompletionMessage.system(
          content:
              'Você é um especialista apaixonado pelo mundo artístico de cabelos e barbas. Você conhece: técnicas de corte (fade, degradê, undercut, pompadour), produtos (pomadas, óleos, bálsamos), tendências (cortes modernos, barbas estilosas), história da barbearia, cuidados com cabelo e barba, e o lado criativo/artístico da profissão. Seja conversacional, inspirador e educativo.',
        ),
      ];

      // Adicionar histórico se existir
      if (conversationHistory != null) {
        for (final msg in conversationHistory) {
          if (msg['role'] == 'user') {
            messages.add(
              ChatCompletionMessage.user(
                content: ChatCompletionUserMessageContent.string(
                  msg['content'] as String,
                ),
              ),
            );
          } else {
            messages.add(
              ChatCompletionMessage.assistant(
                content: msg['content'] as String,
              ),
            );
          }
        }
      }

      // Adicionar mensagem atual
      messages.add(
        ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(userMessage),
        ),
      );

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o-mini'),
          messages: messages,
          temperature: 0.8,
          maxTokens: 800,
        ),
      );

      final reply = response.choices.first.message.content?.trim();
      if (reply == null || reply.isEmpty) {
        throw Exception('Não foi possível gerar resposta');
      }

      state = const AsyncData(null);
      return reply;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera ideias criativas de posts para redes sociais
  ///
  /// Ideal para: Instagram, Facebook, marketing de conteúdo
  Future<List<String>> generateSocialMediaIdeas({
    required String topic,
    int quantity = 5,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o-mini'),
          messages: [
            ChatCompletionMessage.system(
              content:
                  'Você é um especialista em marketing digital para barbearias. Gere ideias criativas e engajadoras para posts.',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(
                'Gere $quantity ideias de posts sobre: $topic\n\nCada ideia deve ter: título/gancho + descrição curta. Separe com ---',
              ),
            ),
          ],
          temperature: 0.9,
          maxTokens: 1000,
        ),
      );

      final text = response.choices.first.message.content?.trim();
      if (text == null || text.isEmpty) {
        throw Exception('Não foi possível gerar ideias');
      }

      // Dividir por separador
      final ideas = text
          .split('---')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      state = const AsyncData(null);
      return ideas;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Sugere produtos e técnicas baseado em tipo de cabelo/barba
  ///
  /// Ideal para: recomendações personalizadas, consultoria
  Future<String> recommendProducts({
    required String hairType,
    required String style,
    String? concerns,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final concernsText = concerns != null ? '\nPreocupações: $concerns' : '';

      final response = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o-mini'),
          messages: [
            ChatCompletionMessage.system(
              content:
                  'Você é um especialista em produtos e técnicas de barbearia. Recomende produtos específicos e técnicas profissionais.',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(
                'Recomende produtos e técnicas para:\nTipo de cabelo: $hairType\nEstilo desejado: $style$concernsText\n\nInclua: produtos essenciais, técnicas de aplicação, dicas de manutenção',
              ),
            ),
          ],
          temperature: 0.6,
          maxTokens: 1200,
        ),
      );

      final recommendations = response.choices.first.message.content?.trim();
      if (recommendations == null || recommendations.isEmpty) {
        throw Exception('Não foi possível gerar recomendações');
      }

      state = const AsyncData(null);
      return recommendations;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
