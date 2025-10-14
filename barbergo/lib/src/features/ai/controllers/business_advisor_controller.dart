import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/ai_service.dart';

part 'business_advisor_controller.g.dart';

/// Controller para consultoria de negócios e análise de mercado
@riverpod
class BusinessAdvisorController extends _$BusinessAdvisorController {
  @override
  FutureOr<void> build() {}

  /// Analisa viabilidade de localização para nova barbearia
  Future<String> analyzeLocation({
    required String city,
    required String neighborhood,
    String? budget,
    String? targetAudience,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final analysis = await aiService.analyzeBusinessLocation(
        city: city,
        neighborhood: neighborhood,
        budget: budget,
      );

      state = const AsyncData(null);
      return analysis;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Sugere estratégias de precificação
  Future<String> suggestPricing({
    required String city,
    required String targetAudience,
    required List<String> services,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final servicesList = services.map((s) => '- $s').join('\n');

      final prompt =
          '''
Sugira estratégia de precificação para barbearia:

📍 Localização: $city
🎯 Público-alvo: $targetAudience

Serviços oferecidos:
$servicesList

Forneça:
1. Faixa de preço sugerida para cada serviço
2. Estratégias de combos/pacotes
3. Preços competitivos vs premium
4. Dicas de promoções
5. Como justificar valor ao cliente
''';

      final pricing = await aiService.generateText(
        prompt: prompt,
        temperature: 0.6,
      );

      state = const AsyncData(null);
      return pricing;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera plano de marketing para barbearia
  Future<String> createMarketingPlan({
    required String barbershopName,
    required String targetAudience,
    required String budget,
    required List<String> channels,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final channelsList = channels.map((c) => '- $c').join('\n');

      final prompt =
          '''
Crie um plano de marketing para:

🏪 Barbearia: $barbershopName
🎯 Público: $targetAudience
💰 Orçamento: $budget

Canais disponíveis:
$channelsList

Inclua:
1. Estratégia principal (posicionamento)
2. Táticas específicas por canal
3. Cronograma de ações (90 dias)
4. Métricas de sucesso
5. Dicas práticas de execução
6. Como otimizar investimento
''';

      final plan = await aiService.generateDocument(
        prompt: prompt,
        temperature: 0.6,
      );

      state = const AsyncData(null);
      return plan;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Analisa concorrência na região
  Future<String> analyzeCompetition({
    required String city,
    required String neighborhood,
    String? differentials,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final diffText = differentials != null
          ? '\n\nNossos diferenciais: $differentials'
          : '';

      final prompt =
          '''
Faça análise de concorrência para barbearia em:

📍 $city - $neighborhood$diffText

Forneça insights sobre:
1. Perfil típico de barbearias na região
2. Faixas de preço praticadas
3. Serviços mais comuns
4. Oportunidades de diferenciação
5. Ameaças competitivas
6. Como se destacar no mercado local

Seja específico e prático.
''';

      final analysis = await aiService.generateText(
        prompt: prompt,
        temperature: 0.6,
      );

      state = const AsyncData(null);
      return analysis;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Sugere ideias de expansão/crescimento
  Future<List<String>> suggestGrowthIdeas({
    required String currentSituation,
    required String goals,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final prompt =
          '''
Sugira ideias de crescimento para esta barbearia:

Situação atual: $currentSituation
Objetivos: $goals

Liste 8-10 ideias PRÁTICAS e VIÁVEIS de crescimento/expansão.
Cada ideia deve ter: título + descrição breve + benefício esperado.
Separe cada ideia com "---".
''';

      final response = await aiService.generateText(
        prompt: prompt,
        temperature: 0.7,
      );

      final ideas = response
          .split('---')
          .map((idea) => idea.trim())
          .where((idea) => idea.isNotEmpty)
          .toList();

      state = const AsyncData(null);
      return ideas;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera análise SWOT (Forças, Fraquezas, Oportunidades, Ameaças)
  Future<Map<String, List<String>>> generateSWOTAnalysis({
    required String businessDescription,
    required String location,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final prompt =
          '''
Faça análise SWOT completa para:

Negócio: $businessDescription
Localização: $location

Formate como:

FORÇAS:
- [item]
- [item]

FRAQUEZAS:
- [item]
- [item]

OPORTUNIDADES:
- [item]
- [item]

AMEAÇAS:
- [item]
- [item]

Seja específico e realista. 3-5 itens por categoria.
''';

      final response = await aiService.generateText(
        prompt: prompt,
        temperature: 0.6,
      );

      // Parse básico da resposta
      final swot = <String, List<String>>{
        'strengths': [],
        'weaknesses': [],
        'opportunities': [],
        'threats': [],
      };

      String? currentSection;
      for (final line in response.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.toUpperCase().contains('FORÇAS') ||
            trimmed.toUpperCase().contains('STRENGTHS')) {
          currentSection = 'strengths';
        } else if (trimmed.toUpperCase().contains('FRAQUEZAS') ||
            trimmed.toUpperCase().contains('WEAKNESSES')) {
          currentSection = 'weaknesses';
        } else if (trimmed.toUpperCase().contains('OPORTUNIDADES') ||
            trimmed.toUpperCase().contains('OPPORTUNITIES')) {
          currentSection = 'opportunities';
        } else if (trimmed.toUpperCase().contains('AMEAÇAS') ||
            trimmed.toUpperCase().contains('THREATS')) {
          currentSection = 'threats';
        } else if (currentSection != null &&
            (trimmed.startsWith('-') || trimmed.startsWith('•'))) {
          final item = trimmed.replaceFirst(RegExp(r'^[•\-]\s*'), '');
          if (item.isNotEmpty) {
            swot[currentSection]!.add(item);
          }
        }
      }

      state = const AsyncData(null);
      return swot;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
