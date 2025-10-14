import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/entities/vacancy_entity.dart';
import '../providers/multi_ai_provider.dart';

part 'smart_matching_controller.g.dart';

/// Score de compatibilidade entre barbeiro e vaga
class MatchScore {
  final String vacancyId;
  final double score; // 0-100
  final String reason;
  final List<String> pros;
  final List<String> cons;

  MatchScore({
    required this.vacancyId,
    required this.score,
    required this.reason,
    required this.pros,
    required this.cons,
  });

  factory MatchScore.fromJson(Map<String, dynamic> json) {
    return MatchScore(
      vacancyId: json['vacancyId'] as String,
      score: (json['score'] as num).toDouble(),
      reason: json['reason'] as String,
      pros: (json['pros'] as List<dynamic>).cast<String>(),
      cons: (json['cons'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'vacancyId': vacancyId,
        'score': score,
        'reason': reason,
        'pros': pros,
        'cons': cons,
      };
}

/// Controller de Matching Inteligente usando GPT-4
@riverpod
class SmartMatching extends _$SmartMatching {
  @override
  FutureOr<List<MatchScore>> build() async => [];

  /// Analisa e ranqueia as melhores vagas para um barbeiro
  Future<List<MatchScore>> findBestMatches({
    required ProfileEntity barberProfile,
    required List<VacancyEntity> availableVacancies,
    int topN = 5,
  }) async {
    state = const AsyncLoading();

    try {
      final gptService = ref.read(gPTServiceProvider.notifier);

      // Construir prompt detalhado
      final prompt = _buildMatchingPrompt(
        barberProfile,
        availableVacancies,
        topN,
      );

      // Usar GPT-4 para análise profunda
      final response = await gptService.generateJSON(prompt: prompt);

      // Parse da resposta
      final jsonText = response['raw'] as String;
      final parsed = jsonDecode(jsonText) as Map<String, dynamic>;

      final matchesList = parsed['matches'] as List<dynamic>;
      final matches = matchesList
          .map((m) => MatchScore.fromJson(m as Map<String, dynamic>))
          .toList();

      // Ordenar por score
      matches.sort((a, b) => b.score.compareTo(a.score));

      state = AsyncValue.data(matches);
      return matches.take(topN).toList();
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  String _buildMatchingPrompt(
    ProfileEntity barber,
    List<VacancyEntity> vacancies,
    int topN,
  ) {
    final vacanciesJson = vacancies.map((v) => {
          'id': v.vacancyId,
          'title': v.title,
          'type': v.type.name,
          'workHours': v.workHours,
          'commission': v.commissionPercentage,
        }).toList();

    return '''
Você é um especialista em matching de profissionais. Analise o perfil do barbeiro e sugira as $topN melhores vagas.

PERFIL DO BARBEIRO:
        ${jsonEncode({
          'name': barber.name,
          'bio': barber.bio,
          'city': barber.city,
          'neighborhood': barber.neighborhood,
          'specialties': barber.specialties,
        })}VAGAS DISPONÍVEIS:
${jsonEncode(vacanciesJson)}

CRITÉRIOS DE ANÁLISE:
1. Compatibilidade de especialidades
2. Tipo de vaga (CLT, Freelance, Comissão)
3. Localização (mesmo bairro = bonus)
4. Horário de trabalho
5. Nível de experiência requerido vs oferecido

FORMATO DE RESPOSTA (JSON):
{
  "matches": [
    {
      "vacancyId": "id_da_vaga",
      "score": 85.5,
      "reason": "Explicação breve em português",
      "pros": ["Ponto forte 1", "Ponto forte 2"],
      "cons": ["Ponto fraco 1", "Ponto fraco 2"]
    }
  ]
}

Retorne APENAS o JSON, sem markdown ou explicações.
''';
  }

  /// Analisa compatibilidade entre perfil e vaga específica
  Future<MatchScore> analyzeMatch({
    required ProfileEntity barberProfile,
    required VacancyEntity vacancy,
  }) async {
    state = const AsyncLoading();

    try {
      final gptService = ref.read(gPTServiceProvider.notifier);

      final prompt = '''
Analise a compatibilidade entre este barbeiro e esta vaga:

BARBEIRO:
${jsonEncode({
            'name': barberProfile.name,
            'bio': barberProfile.bio,
            'city': barberProfile.city,
            'specialties': barberProfile.specialties,
          })}

VAGA:
${jsonEncode({
            'id': vacancy.vacancyId,
            'title': vacancy.title,
            'type': vacancy.type.name,
            'workHours': vacancy.workHours,
          })}

Retorne JSON no formato:
{
  "vacancyId": "${vacancy.vacancyId}",
  "score": 0-100,
  "reason": "Análise em português",
  "pros": ["Ponto forte 1", "Ponto forte 2"],
  "cons": ["Ponto a considerar 1", "Ponto a considerar 2"]
}
''';

      final response = await gptService.generateJSON(prompt: prompt);
      final jsonText = response['raw'] as String;
      final parsed = jsonDecode(jsonText) as Map<String, dynamic>;

      final match = MatchScore.fromJson(parsed);

      state = AsyncValue.data([match]);
      return match;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera explicação detalhada do porquê do match
  Future<String> explainMatch({
    required MatchScore match,
    required ProfileEntity barber,
    required VacancyEntity vacancy,
  }) async {
    try {
      final gptService = ref.read(gPTServiceProvider.notifier);

      final prompt = '''
Explique em 2-3 parágrafos, de forma amigável e motivadora, porque esta vaga é compatível com o perfil do barbeiro:

MATCH SCORE: ${match.score}/100
BARBEIRO: ${barber.name}
VAGA: ${vacancy.title}

PONTOS FORTES:
${match.pros.map((p) => '- $p').join('\n')}

PONTOS A CONSIDERAR:
${match.cons.map((c) => '- $c').join('\n')}

Tom: Profissional mas encorajador, em português brasileiro.
Máximo: 300 palavras.
''';

      return await gptService.generateText(
        prompt: prompt,
        temperature: 0.8, // Mais criativo para texto motivacional
      );
    } catch (e) {
      return match.reason; // Fallback para reason curto
    }
  }
}
