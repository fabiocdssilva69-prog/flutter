import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:openai_dart/openai_dart.dart' as openai;
import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart' as anthropic;

part 'multi_ai_provider.g.dart';

/// Enum para identificar qual modelo de IA usar
enum AIModel {
  gemini, // Gemini Ultra - Primário
  gpt4, // GPT-4o - Raciocínio complexo
  claude, // Claude 3.5 Sonnet - Textos longos
}

/// Provider para o cliente OpenAI (GPT-4)
@riverpod
openai.OpenAIClient openAIClient(ref) {
  final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  if (apiKey.isEmpty || apiKey == 'sua_key_aqui') {
    throw Exception(
      'OPENAI_API_KEY não configurada. '
      'Adicione sua chave no arquivo .env na raiz do projeto',
    );
  }

  return openai.OpenAIClient(apiKey: apiKey);
}

/// Provider para o cliente Anthropic (Claude)
@riverpod
anthropic.AnthropicClient anthropicClient(ref) {
  final apiKey = dotenv.env['ANTHROPIC_API_KEY'] ?? '';

  if (apiKey.isEmpty || apiKey == 'sua_key_aqui') {
    throw Exception(
      'ANTHROPIC_API_KEY não configurada. '
      'Adicione sua chave no arquivo .env na raiz do projeto',
    );
  }

  return anthropic.AnthropicClient(apiKey: apiKey);
}

/// Serviço para GPT-4
@riverpod
class GPTService extends _$GPTService {
  @override
  Future<void> build() async {}

  /// Gera texto usando GPT-4o
  Future<String> generateText({
    required String prompt,
    String model = 'gpt-4o', // Melhor custo-benefício
    double temperature = 0.7,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final response = await client.createChatCompletion(
        request: openai.CreateChatCompletionRequest(
          model: openai.ChatCompletionModel.modelId(model),
          messages: [
            openai.ChatCompletionMessage.system(
              content:
                  'Você é um assistente especializado em conectar '
                  'barbeiros e barbearias no Brasil.',
            ),
            openai.ChatCompletionMessage.user(
              content: openai.ChatCompletionUserMessageContent.string(prompt),
            ),
          ],
          temperature: temperature,
          maxTokens: 1000,
        ),
      );

      final text = response.choices.first.message.content?.trim() ?? '';

      if (text.isEmpty) {
        throw Exception('Resposta vazia do GPT-4');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera JSON estruturado usando GPT-4
  Future<Map<String, dynamic>> generateJSON({required String prompt}) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(openAIClientProvider);

      final response = await client.createChatCompletion(
        request: openai.CreateChatCompletionRequest(
          model: openai.ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            openai.ChatCompletionMessage.system(
              content: 'Você retorna APENAS JSON válido, sem explicações.',
            ),
            openai.ChatCompletionMessage.user(
              content: openai.ChatCompletionUserMessageContent.string(prompt),
            ),
          ],
          temperature: 0.3, // Mais determinístico para JSON
          maxTokens: 2000,
        ),
      );

      final jsonText = response.choices.first.message.content ?? '{}';

      state = const AsyncData(null);

      // Parse será feito pelo chamador
      return {'raw': jsonText};
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

/// Serviço para Claude 3.5 Sonnet
/// NÃO ESTÁ SENDO USADO NO MOMENTO - Focando apenas em OpenAI/GPT-4
/*
@riverpod
class ClaudeService extends _$ClaudeService {
  @override
  Future<void> build() async {}

  /// Gera texto longo usando Claude 3.5 Sonnet
  Future<String> generateLongText({
    required String prompt,
    String model = 'claude-3-5-sonnet-20241022',
    int maxTokens = 4096,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(anthropicClientProvider);

      final response = await client.createMessage(
        request: anthropic.CreateMessageRequest(
          model: anthropic.Model.modelId(model),
          maxTokens: maxTokens,
          messages: [
            anthropic.Message(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.text(prompt),
            ),
          ],
        ),
      );

      // Extrair texto da resposta
      final text = response.content.map(
        text: (textBlock) => textBlock.text,
        toolUse: (_) => '',
      );

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera documento estruturado (contrato, termos, etc)
  Future<String> generateDocument({
    required String documentType,
    required Map<String, dynamic> params,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(anthropicClientProvider);

      final paramsText = params.entries
          .map((e) => '- ${e.key}: ${e.value}')
          .join('\n');

      final prompt = '''
Gere um documento profissional de $documentType com base nos seguintes parâmetros:

$paramsText

Requisitos:
- Linguagem jurídica apropriada
- Português brasileiro formal
- Estrutura clara com seções
- Compliance com LGPD quando aplicável
- Formatação em Markdown
''';

      final response = await client.createMessage(
        request: CreateMessageRequest(
          model: Model.modelId('claude-3-5-sonnet-20241022'),
          maxTokens: 8000, // Documentos podem ser longos
          messages: [
            Message(
              role: MessageRole.user,
              content: MessageContent.text(prompt),
            ),
          ],
        ),
      );

      final textBlocks = response.content.whereType<TextBlock>();
      final document = textBlocks.map((b) => b.text).join('\n');

      state = const AsyncData(null);
      return document;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
*/
