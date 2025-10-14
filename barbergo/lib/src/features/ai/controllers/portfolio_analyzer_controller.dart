import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/ai_service.dart';

part 'portfolio_analyzer_controller.g.dart';

/// Análise detalhada de uma foto do portfólio
class PortfolioAnalysis {
  final String imageId;
  final double qualityScore; // 0-10
  final List<String> detectedStyles; // fade, degradê, barba, social, etc
  final List<String> techniques; // tesoura, máquina, navalha
  final List<String> strengths; // Pontos fortes
  final List<String> improvements; // Sugestões de melhoria
  final String detailedFeedback;

  PortfolioAnalysis({
    required this.imageId,
    required this.qualityScore,
    required this.detectedStyles,
    required this.techniques,
    required this.strengths,
    required this.improvements,
    required this.detailedFeedback,
  });
}

/// Análise agregada do portfólio completo
class PortfolioSummary {
  final double overallScore; // Média das fotos
  final Map<String, int> styleDistribution; // Quais estilos aparecem mais
  final List<String> topStrengths; // Principais pontos fortes
  final List<String> topImprovements; // Principais áreas para melhorar
  final String professionalLevel; // Iniciante, Intermediário, Avançado, Expert
  final List<String> recommendedVacancies; // Tipos de vaga recomendados

  PortfolioSummary({
    required this.overallScore,
    required this.styleDistribution,
    required this.topStrengths,
    required this.topImprovements,
    required this.professionalLevel,
    required this.recommendedVacancies,
  });
}

/// Controller para análise de portfólio usando Gemini Pro Vision
@riverpod
class PortfolioAnalyzer extends _$PortfolioAnalyzer {
  @override
  FutureOr<PortfolioSummary?> build() => null;

  /// Analisa uma única foto do portfólio
  Future<PortfolioAnalysis> analyzeImage({
    required Uint8List imageData,
    required String imageId,
  }) async {
    final aiService = ref.read(aiServiceProvider.notifier);

    final prompt = '''
Você é um especialista em cortes de cabelo e barbearia. Analise esta imagem de portfólio profissional.

ANALISE:
1. QUALIDADE TÉCNICA (0-10):
   - Precisão das linhas
   - Degradê suave
   - Simetria
   - Acabamento

2. ESTILOS IDENTIFICADOS:
   - Fade (low, mid, high)
   - Degradê
   - Barba (alinhada, estilizada, completa)
   - Social/Clássico
   - Moderno/Arrojado
   - Afro/Texturizado

3. TÉCNICAS VISÍVEIS:
   - Máquina
   - Tesoura
   - Navalha
   - Pente
   - Desenho artístico

4. PONTOS FORTES (3-5 itens)
5. MELHORIAS SUGERIDAS (2-3 itens)
6. FEEDBACK DETALHADO (2-3 parágrafos)

Retorne APENAS um JSON válido:
{
  "qualityScore": 8.5,
  "detectedStyles": ["fade high", "barba alinhada"],
  "techniques": ["máquina", "navalha"],
  "strengths": ["Degradê muito suave", "Linhas precisas"],
  "improvements": ["Melhorar iluminação da foto"],
  "detailedFeedback": "Excelente trabalho..."
}
''';

    final response = await aiService.analyzeImage(
      imageData: imageData,
      prompt: prompt,
    );

    return _parseAnalysisResponse(response, imageId);
  }

  PortfolioAnalysis _parseAnalysisResponse(String response, String imageId) {
    try {
      // Remove markdown code blocks se existirem
      String cleanJson = response
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Parse manual simplificado (em produção use dart:convert)
      final qualityMatch = RegExp(
        r'"qualityScore":\s*(\d+\.?\d*)',
      ).firstMatch(cleanJson);
      final quality = qualityMatch != null
          ? double.parse(qualityMatch.group(1)!)
          : 7.0;

      // Extrai arrays de strings
      final stylesMatch = RegExp(
        r'"detectedStyles":\s*\[(.*?)\]',
      ).firstMatch(cleanJson);
      final styles = stylesMatch != null
          ? stylesMatch
                .group(1)!
                .split(',')
                .map((s) => s.replaceAll('"', '').trim())
                .toList()
          : ['indefinido'];

      final techniquesMatch = RegExp(
        r'"techniques":\s*\[(.*?)\]',
      ).firstMatch(cleanJson);
      final techniques = techniquesMatch != null
          ? techniquesMatch
                .group(1)!
                .split(',')
                .map((s) => s.replaceAll('"', '').trim())
                .toList()
          : ['não identificado'];

      final strengthsMatch = RegExp(
        r'"strengths":\s*\[(.*?)\]',
      ).firstMatch(cleanJson);
      final strengths = strengthsMatch != null
          ? strengthsMatch
                .group(1)!
                .split(',')
                .map((s) => s.replaceAll('"', '').trim())
                .toList()
          : ['Análise não disponível'];

      final improvementsMatch = RegExp(
        r'"improvements":\s*\[(.*?)\]',
      ).firstMatch(cleanJson);
      final improvements = improvementsMatch != null
          ? improvementsMatch
                .group(1)!
                .split(',')
                .map((s) => s.replaceAll('"', '').trim())
                .toList()
          : ['Nenhuma sugestão'];

      final feedbackMatch = RegExp(
        r'"detailedFeedback":\s*"(.*?)"',
      ).firstMatch(cleanJson);
      final feedback = feedbackMatch?.group(1) ?? 'Análise em andamento...';

      return PortfolioAnalysis(
        imageId: imageId,
        qualityScore: quality,
        detectedStyles: styles,
        techniques: techniques,
        strengths: strengths,
        improvements: improvements,
        detailedFeedback: feedback,
      );
    } catch (e) {
      // Fallback se parsing falhar
      return PortfolioAnalysis(
        imageId: imageId,
        qualityScore: 7.0,
        detectedStyles: ['análise pendente'],
        techniques: ['não identificado'],
        strengths: ['Portfólio enviado com sucesso'],
        improvements: ['Envie mais fotos para análise completa'],
        detailedFeedback:
            'Análise temporariamente indisponível. Tente novamente.',
      );
    }
  }

  /// Analisa múltiplas fotos e gera resumo
  Future<PortfolioSummary> analyzePortfolio({
    required Map<String, Uint8List> images, // imageId -> imageData
  }) async {
    state = const AsyncLoading();

    try {
      // Analisa cada imagem
      final analyses = <PortfolioAnalysis>[];
      for (final entry in images.entries) {
        final analysis = await analyzeImage(
          imageData: entry.value,
          imageId: entry.key,
        );
        analyses.add(analysis);
      }

      // Calcula estatísticas agregadas
      final overallScore = analyses.isEmpty
          ? 0.0
          : analyses.map((a) => a.qualityScore).reduce((a, b) => a + b) /
                analyses.length;

      // Contabiliza estilos
      final styleDistribution = <String, int>{};
      for (final analysis in analyses) {
        for (final style in analysis.detectedStyles) {
          styleDistribution[style] = (styleDistribution[style] ?? 0) + 1;
        }
      }

      // Agrega pontos fortes (top 5)
      final allStrengths = analyses.expand((a) => a.strengths).toList();
      final strengthCounts = <String, int>{};
      for (final strength in allStrengths) {
        strengthCounts[strength] = (strengthCounts[strength] ?? 0) + 1;
      }
      final topStrengths =
          (strengthCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .take(5)
              .map((e) => e.key)
              .toList();

      // Agrega melhorias (top 3)
      final allImprovements = analyses.expand((a) => a.improvements).toList();
      final improvementCounts = <String, int>{};
      for (final improvement in allImprovements) {
        improvementCounts[improvement] =
            (improvementCounts[improvement] ?? 0) + 1;
      }
      final topImprovements =
          (improvementCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .take(3)
              .map((e) => e.key)
              .toList();

      // Determina nível profissional
      String professionalLevel;
      if (overallScore >= 9.0) {
        professionalLevel = 'Expert';
      } else if (overallScore >= 7.5) {
        professionalLevel = 'Avançado';
      } else if (overallScore >= 6.0) {
        professionalLevel = 'Intermediário';
      } else {
        professionalLevel = 'Iniciante';
      }

      // Recomenda tipos de vaga baseado no portfólio
      final recommendedVacancies = <String>[];
      if (styleDistribution.containsKey('fade') ||
          styleDistribution.containsKey('degradê')) {
        recommendedVacancies.add('Barbearia moderna');
      }
      if (styleDistribution.containsKey('barba')) {
        recommendedVacancies.add('Especialista em barbas');
      }
      if (styleDistribution.containsKey('social') ||
          styleDistribution.containsKey('clássico')) {
        recommendedVacancies.add('Barbearia tradicional');
      }
      if (styleDistribution.containsKey('afro') ||
          styleDistribution.containsKey('texturizado')) {
        recommendedVacancies.add('Especialista em cabelos afro');
      }
      if (overallScore >= 8.5) {
        recommendedVacancies.add('Posições de liderança');
      }

      final summary = PortfolioSummary(
        overallScore: overallScore,
        styleDistribution: styleDistribution,
        topStrengths: topStrengths,
        topImprovements: topImprovements,
        professionalLevel: professionalLevel,
        recommendedVacancies: recommendedVacancies,
      );

      state = AsyncValue.data(summary);
      return summary;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Compara dois portfólios (útil para recruiter decidir entre candidatos)
  Future<String> comparePortfolios({
    required PortfolioSummary portfolio1,
    required PortfolioSummary portfolio2,
    required String barber1Name,
    required String barber2Name,
  }) async {
    final aiService = ref.read(aiServiceProvider.notifier);

    final prompt =
        '''
Compare estes dois portfólios de barbeiros profissionais e forneça uma análise comparativa:

BARBEIRO 1: $barber1Name
- Nota Geral: ${portfolio1.overallScore.toStringAsFixed(1)}
- Nível: ${portfolio1.professionalLevel}
- Estilos: ${portfolio1.styleDistribution.keys.join(', ')}
- Pontos Fortes: ${portfolio1.topStrengths.join(', ')}

BARBEIRO 2: $barber2Name
- Nota Geral: ${portfolio2.overallScore.toStringAsFixed(1)}
- Nível: ${portfolio2.professionalLevel}
- Estilos: ${portfolio2.styleDistribution.keys.join(', ')}
- Pontos Fortes: ${portfolio2.topStrengths.join(', ')}

Forneça:
1. Comparação técnica objetiva
2. Qual se destaca em cada categoria
3. Recomendação de contratação baseada no perfil da vaga
4. Considerações sobre versatilidade

Seja profissional e imparcial.
''';

    return await aiService.generateText(prompt: prompt);
  }
}
