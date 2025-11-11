import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_orchestrator_service.g.dart';

/// 🎯 Serviço de IA usando APENAS GEMINI 2.0
///
/// 🟢 GEMINI 2.0 Flash (Google - 100% GRÁTIS):
///    ✅ Velocidade + Custo Zero
///    ✅ Multimodal: Texto + Imagens
///    ✅ Raciocínio avançado
///    ✅ JSON estruturado
///    ✅ Excelente em português
///    ✅ 1 milhão de tokens de contexto
///
/// ⚡ Modelo: gemini-2.0-flash-exp
/// 📦 Substitui: OpenAI GPT-4, Perplexity, Claude
/// 💰 Custo: $0 (grátis com Google One)

enum AITask {
  // Tarefas de geração de conteúdo
  bioGeneration, // Gerar bio de barbeiro
  chatResponse, // Chat casual/profissional
  contractGeneration, // Contratos e documentos
  // Tarefas multimodais (texto + imagem)
  portfolioAnalysis, // Analisar fotos de cortes
  imageDescription, // Descrever imagens
  // Tarefas estruturadas
  smartMatching, // Score de compatibilidade
  jsonGeneration, // Gerar dados estruturados
  // Pesquisa e análise
  trendSearch, // Buscar tendências
  marketResearch, // Pesquisa de mercado
}

/// Provider para o Orquestrador de IAs
@riverpod
class AIOrchestrator extends _$AIOrchestrator {
  @override
  Future<void> build() async {}

  /// 🎯 Executa uma tarefa usando Gemini 2.0
  Future<String> executeTask({required AITask task, required String prompt, Map<String, dynamic>? context}) async {
    state = const AsyncLoading();

    try {
      final result = switch (task) {
        AITask.bioGeneration => await _generateBio(prompt, context),
        AITask.portfolioAnalysis => await _analyzePortfolio(prompt, context),
        AITask.chatResponse => await _chatResponse(prompt, context),
        AITask.imageDescription => await _describeImage(prompt, context),
        AITask.smartMatching => await _smartMatching(prompt, context),
        AITask.jsonGeneration => await _generateJSON(prompt, context),
        AITask.contractGeneration => await _generateContract(prompt, context),
        AITask.trendSearch => await _searchTrends(prompt, context),
        AITask.marketResearch => await _marketResearch(prompt, context),
      };

      state = const AsyncData(null);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Cria uma instância do modelo Gemini
  GenerativeModel _getModel({double temperature = 0.7}) {
    final apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      throw Exception('GOOGLE_GEMINI_API_KEY não configurada no .env');
    }

    return GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
      generationConfig: GenerationConfig(temperature: temperature, topK: 40, topP: 0.95, maxOutputTokens: 8192),
    );
  }

  // ============================================================
  // 🟢 MÉTODOS GEMINI 2.0 - Todas as funcionalidades
  // ============================================================

  Future<String> _generateBio(String prompt, Map<String, dynamic>? context) async {
    final model = _getModel(temperature: 0.8); // Criativo para bios

    final enhancedPrompt =
        '''
Crie uma bio profissional e atraente para um barbeiro com base nestas informações:

$prompt

Contexto adicional: ${context ?? 'Nenhum'}

Requisitos:
- Máximo 2-3 linhas
- Tom profissional mas descontraído
- Destaque especialidades e experiência
- Português brasileiro natural
- Sem emojis excessivos
''';

    final response = await model.generateContent([Content.text(enhancedPrompt)]);
    return response.text ?? 'Erro ao gerar bio';
  }

  Future<String> _analyzePortfolio(String prompt, Map<String, dynamic>? context) async {
    final model = _getModel();

    final enhancedPrompt =
        '''
Analise o portfólio do barbeiro e forneça insights detalhados:

$prompt

Contexto: ${context ?? 'Nenhum'}

Avalie:
- Qualidade técnica dos trabalhos
- Variedade de estilos
- Consistência
- Pontos fortes e áreas de melhoria
- Sugestões de desenvolvimento
''';

    final response = await model.generateContent([Content.text(enhancedPrompt)]);
    return response.text ?? 'Erro ao analisar portfólio';
  }

  Future<String> _chatResponse(String prompt, Map<String, dynamic>? context) async {
    final model = _getModel(temperature: 0.9); // Mais natural para conversas

    final enhancedPrompt =
        '''
Você é um assistente criativo especializado em barbearias.
Seja amigável, prestativo e use linguagem natural brasileira.

Usuário: $prompt

Contexto: ${context ?? 'Nenhum'}
''';

    final response = await model.generateContent([Content.text(enhancedPrompt)]);
    return response.text ?? 'Desculpe, não consegui processar sua mensagem.';
  }

  Future<String> _describeImage(String prompt, Map<String, dynamic>? context) async {
    final model = _getModel();

    // TODO: Adicionar suporte a imagens quando necessário usando Content.multi()
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? 'Erro ao descrever imagem';
  }

  Future<String> _smartMatching(String prompt, Map<String, dynamic>? context) async {
    final model = _getModel(temperature: 0.3); // Mais determinístico para análise

    final enhancedPrompt =
        '''
Analise a compatibilidade entre barbeiro e cliente com base nos dados:

$prompt

Contexto: ${context ?? 'Nenhum'}

Retorne um JSON com:
{
  "compatibilityScore": 0-100,
  "strengths": ["ponto forte 1", "ponto forte 2"],
  "concerns": ["preocupação 1", "preocupação 2"],
  "recommendation": "recomendação personalizada",
  "reasoning": "explicação lógica do score"
}

IMPORTANTE: Retorne APENAS o JSON, sem explicações adicionais.
''';

    final response = await model.generateContent([Content.text(enhancedPrompt)]);
    return response.text ?? '{}';
  }

  Future<String> _generateJSON(String prompt, Map<String, dynamic>? context) async {
    final model = _getModel(temperature: 0.2); // Máxima precisão para JSON

    final enhancedPrompt =
        '''
$prompt

IMPORTANTE: Retorne APENAS JSON válido, sem explicações, markdown ou formatação adicional.
''';

    final response = await model.generateContent([Content.text(enhancedPrompt)]);
    return response.text ?? '{}';
  }

  Future<String> _generateContract(String prompt, Map<String, dynamic>? context) async {
    final model = _getModel(temperature: 0.3); // Formal e preciso

    final enhancedPrompt =
        '''
Gere um documento formal/contrato com base nestas especificações:

$prompt

Contexto: ${context ?? 'Nenhum'}

Requisitos:
- Linguagem jurídica apropriada
- Português brasileiro formal
- Estrutura clara com seções numeradas
- Compliance com LGPD quando aplicável
- Formato Markdown
''';

    final response = await model.generateContent([Content.text(enhancedPrompt)]);
    return response.text ?? 'Erro ao gerar documento';
  }

  Future<String> _searchTrends(String prompt, Map<String, dynamic>? context) async {
    final model = _getModel(temperature: 0.5);

    final enhancedPrompt =
        '''
Com base no seu conhecimento, analise tendências sobre: $prompt

Foque em:
- Tendências gerais do mercado
- Padrões observados historicamente
- Aplicabilidade no mercado de barbearias brasileiro
- Insights práticos

Contexto: ${context ?? 'Nenhum'}

NOTA: Esta é uma análise baseada em conhecimento geral, não em busca web em tempo real.
''';

    final response = await model.generateContent([Content.text(enhancedPrompt)]);
    return response.text ?? 'Não foi possível analisar tendências';
  }

  Future<String> _marketResearch(String prompt, Map<String, dynamic>? context) async {
    final model = _getModel(temperature: 0.4);

    final enhancedPrompt =
        '''
Faça uma análise de mercado sobre: $prompt

Incluir:
- Características gerais do mercado
- Dinâmicas competitivas
- Oportunidades e desafios típicos
- Considerações demográficas
- Foco no contexto brasileiro

Contexto adicional: ${context ?? 'Nenhum'}

NOTA: Esta é uma análise baseada em conhecimento geral do setor.
''';

    final response = await model.generateContent([Content.text(enhancedPrompt)]);
    return response.text ?? 'Não foi possível realizar análise';
  }

  // ============================================================
  // 🎯 Métodos Helper - Combinações Inteligentes
  // ============================================================

  /// 💡 Smart Bio: Usa Gemini (rápido) + Perplexity (tendências)
  Future<String> generateSmartBio({
    required String barberName,
    required List<String> specialties,
    required int yearsExperience,
    String? city,
  }) async {
    // 1. Buscar tendências atuais (Perplexity)
    final trendsPrompt = 'Tendências de especialidades de barbeiro em 2024';
    final trends = await executeTask(task: AITask.trendSearch, prompt: trendsPrompt);

    // 2. Gerar bio personalizada (Gemini)
    final bioPrompt =
        '''
Nome: $barberName
Especialidades: ${specialties.join(', ')}
Experiência: $yearsExperience anos
Cidade: ${city ?? 'Brasil'}

Tendências atuais para considerar:
$trends
''';

    return executeTask(task: AITask.bioGeneration, prompt: bioPrompt, context: {'trends': trends});
  }

  /// 🎯 Smart Matching: Usa GPT-4 (precisão) + contexto rico
  Future<Map<String, dynamic>> calculateSmartMatch({
    required Map<String, dynamic> barberProfile,
    required Map<String, dynamic> clientPreferences,
  }) async {
    final matchPrompt =
        '''
BARBEIRO:
${barberProfile.entries.map((e) => '- ${e.key}: ${e.value}').join('\n')}

CLIENTE:
${clientPreferences.entries.map((e) => '- ${e.key}: ${e.value}').join('\n')}
''';

    final result = await executeTask(
      task: AITask.smartMatching,
      prompt: matchPrompt,
      context: {'barber': barberProfile, 'client': clientPreferences},
    );

    // Parse JSON (GPT-4 sempre retorna JSON válido)
    return {'result': result}; // TODO: Parse real JSON
  }
}
