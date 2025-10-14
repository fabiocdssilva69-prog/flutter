import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart' as anthropic;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'multi_ai_provider.dart';

part 'claude_service.g.dart';

/// Serviço de IA usando Claude da Anthropic
///
/// Especializado em tarefas que requerem:
/// - Análise jurídica e contratos
/// - Documentos formais e profissionais
/// - Respostas mais seguras e éticas
/// - Processamento de textos longos
@riverpod
class ClaudeService extends _$ClaudeService {
  @override
  Future<void> build() async {}

  /// Gera contratos e documentos legais usando Claude
  ///
  /// Ideal para: contratos de trabalho, termos de serviço, acordos formais
  Future<String> generateContract({
    required String contractType,
    required Map<String, dynamic> parameters,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(anthropicClientProvider);

      final prompt = _buildContractPrompt(contractType, parameters);

      final response = await client.createMessage(
        request: anthropic.CreateMessageRequest(
          model: anthropic.Model.modelId('claude-3-5-sonnet-20241022'),
          maxTokens: 4000,
          messages: [
            anthropic.Message(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.text(prompt),
            ),
          ],
        ),
      );

      // Extrair texto da resposta
      final text = response.content.toString().trim();

      if (text.isEmpty) {
        throw Exception('Resposta vazia do Claude');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Analisa contratos existentes usando Claude
  ///
  /// Ideal para: revisão de contratos, identificação de cláusulas importantes
  Future<String> analyzeContract({
    required String contractText,
    String? focusAreas,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(anthropicClientProvider);

      final focus = focusAreas != null ? '\nÁreas de foco: $focusAreas' : '';

      final prompt =
          '''
Analise o seguinte contrato de barbearia e forneça uma análise detalhada:

CONTRATO:
$contractText

$focus

Forneça análise incluindo:
1. Pontos positivos do contrato
2. Riscos e preocupações identificados
3. Sugestões de melhoria
4. Cláusulas importantes destacadas
5. Recomendações gerais

Seja específico e profissional na análise.
''';

      final response = await client.createMessage(
        request: anthropic.CreateMessageRequest(
          model: anthropic.Model.modelId('claude-3-5-sonnet-20241022'),
          maxTokens: 3000,
          messages: [
            anthropic.Message(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.text(prompt),
            ),
          ],
        ),
      );

      final text = response.content.toString().trim();

      if (text.isEmpty) {
        throw Exception('Não foi possível analisar o contrato');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera termos de responsabilidade usando Claude
  ///
  /// Ideal para: termos de responsabilidade, waivers, documentos legais simples
  Future<String> generateLiabilityTerms({
    required String serviceType,
    required String businessName,
    String? additionalClauses,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(anthropicClientProvider);

      final additional = additionalClauses != null
          ? '\nCláusulas adicionais: $additionalClauses'
          : '';

      final prompt =
          '''
Gere um termo de responsabilidade profissional para o seguinte serviço:

SERVIÇO: $serviceType
EMPRESA: $businessName
$additional

O termo deve incluir:
1. Reconhecimento de riscos
2. Assunção de responsabilidade
3. Isenção de responsabilidade da empresa
4. Cláusula de consentimento informado
5. Data e assinatura

Use linguagem jurídica apropriada mas acessível.
''';

      final response = await client.createMessage(
        request: anthropic.CreateMessageRequest(
          model: anthropic.Model.modelId('claude-3-5-sonnet-20241022'),
          maxTokens: 2000,
          messages: [
            anthropic.Message(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.text(prompt),
            ),
          ],
        ),
      );

      final text = response.content.toString().trim();

      if (text.isEmpty) {
        throw Exception('Não foi possível gerar os termos');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera políticas de cancelamento usando Claude
  ///
  /// Ideal para: políticas de agendamento, regras de cancelamento
  Future<String> generateCancellationPolicy({
    required String businessType,
    required Map<String, dynamic> rules,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(anthropicClientProvider);

      final prompt =
          '''
Gere uma política de cancelamento clara e justa para:

TIPO DE NEGÓCIO: $businessType
REGRAS: ${rules.entries.map((e) => '${e.key}: ${e.value}').join(', ')}

A política deve incluir:
1. Prazo mínimo para cancelamento
2. Penalidades por cancelamento tardio
3. Reembolso ou créditos
4. Exceções (emergências)
5. Procedimento de cancelamento

Seja justo mas proteja os interesses do negócio.
''';

      final response = await client.createMessage(
        request: anthropic.CreateMessageRequest(
          model: anthropic.Model.modelId('claude-3-5-sonnet-20241022'),
          maxTokens: 1500,
          messages: [
            anthropic.Message(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.text(prompt),
            ),
          ],
        ),
      );

      final text = response.content.toString().trim();

      if (text.isEmpty) {
        throw Exception('Não foi possível gerar a política');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Analisa riscos legais usando Claude
  ///
  /// Ideal para: avaliação de riscos, compliance, consultoria jurídica básica
  Future<String> analyzeLegalRisks({
    required String scenario,
    required String businessContext,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(anthropicClientProvider);

      final prompt =
          '''
Analise os riscos legais no seguinte cenário:

CONTEXTO: $businessContext
CENÁRIO: $scenario

Forneça análise incluindo:
1. Riscos legais identificados
2. Probabilidade de ocorrência
3. Impacto potencial
4. Medidas preventivas recomendadas
5. Ações corretivas se necessário

Considere leis trabalhistas, consumeristas e sanitárias relevantes para barbearias.
''';

      final response = await client.createMessage(
        request: anthropic.CreateMessageRequest(
          model: anthropic.Model.modelId('claude-3-5-sonnet-20241022'),
          maxTokens: 2500,
          messages: [
            anthropic.Message(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.text(prompt),
            ),
          ],
        ),
      );

      final text = response.content.toString().trim();

      if (text.isEmpty) {
        throw Exception('Não foi possível analisar os riscos');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera texto longo usando Claude (método genérico)
  ///
  /// Ideal para: documentos extensos, contratos, textos longos
  Future<String> generateLongText({
    required String prompt,
    int maxTokens = 4000,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(anthropicClientProvider);

      final response = await client.createMessage(
        request: anthropic.CreateMessageRequest(
          model: anthropic.Model.modelId('claude-3-5-sonnet-20241022'),
          maxTokens: maxTokens,
          messages: [
            anthropic.Message(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.text(prompt),
            ),
          ],
        ),
      );

      final text = response.content.toString().trim();

      if (text.isEmpty) {
        throw Exception('Resposta vazia do Claude');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera documentos usando Claude (método genérico)
  ///
  /// Ideal para: contratos, termos, políticas, documentos formais
  Future<String> generateDocument({
    required String documentType,
    required Map<String, dynamic> params,
  }) async {
    state = const AsyncLoading();

    try {
      final client = ref.read(anthropicClientProvider);

      final prompt = _buildGenericDocumentPrompt(documentType, params);

      final response = await client.createMessage(
        request: anthropic.CreateMessageRequest(
          model: anthropic.Model.modelId('claude-3-5-sonnet-20241022'),
          maxTokens: 4000,
          messages: [
            anthropic.Message(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.text(prompt),
            ),
          ],
        ),
      );

      final text = response.content.toString().trim();

      if (text.isEmpty) {
        throw Exception('Não foi possível gerar o documento');
      }

      state = const AsyncData(null);
      return text;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  String _buildContractPrompt(
    String contractType,
    Map<String, dynamic> parameters,
  ) {
    final basePrompts = {
      'employment':
          '''
Gere um contrato de trabalho para barbeiro/barbeira com os seguintes parâmetros:

PARÂMETROS: ${parameters.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

O contrato deve incluir:
1. Identificação das partes
2. Cargo e responsabilidades
3. Remuneração e benefícios
4. Jornada de trabalho
5. Férias e licenças
6. Cláusulas de confidencialidade
7. Rescisão contratual
8. Disposições gerais

Use linguagem jurídica apropriada.
''',
      'service':
          '''
Gere um contrato de prestação de serviços para barbearia com os seguintes parâmetros:

PARÂMETROS: ${parameters.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

O contrato deve incluir:
1. Identificação das partes
2. Descrição dos serviços
3. Prazo de execução
4. Valor e forma de pagamento
5. Obrigações das partes
6. Responsabilidades
7. Cláusulas de rescisão
8. Foro competente

Use linguagem jurídica apropriada.
''',
      'partnership':
          '''
Gere um contrato de sociedade para barbearia com os seguintes parâmetros:

PARÂMETROS: ${parameters.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

O contrato deve incluir:
1. Identificação dos sócios
2. Objeto social
3. Capital social e contribuições
4. Distribuição de lucros/prejuízos
5. Administração e representação
6. Direitos e deveres dos sócios
7. Resolução de conflitos
8. Dissolução da sociedade

Use linguagem jurídica apropriada.
''',
    };

    return basePrompts[contractType] ??
        '''
Gere um contrato do tipo "$contractType" com os seguintes parâmetros:

PARÂMETROS: ${parameters.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

Inclua todas as cláusulas essenciais para este tipo de contrato.
''';
  }

  String _buildGenericDocumentPrompt(
    String documentType,
    Map<String, dynamic> params,
  ) {
    return '''
Gere um documento do tipo "$documentType" profissional e juridicamente adequado para o Brasil:

PARÂMETROS:
${params.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

REQUISITOS:
1. Linguagem jurídica apropriada
2. Estrutura formal e organizada
3. Compliance com legislações brasileiras relevantes
4. Formatação clara em Markdown
5. Cláusulas essenciais para o tipo de documento

IMPORTANTE:
- Documento completo e detalhado
- Linguagem acessível mas profissional
- Considerar contexto brasileiro
''';
  }
}
