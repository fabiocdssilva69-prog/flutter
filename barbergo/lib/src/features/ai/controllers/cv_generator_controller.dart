import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/ai_service.dart';

part 'cv_generator_controller.g.dart';

/// Controller para geração de currículos profissionais para barbeiros
@riverpod
class CVGeneratorController extends _$CVGeneratorController {
  @override
  FutureOr<void> build() {}

  /// Gera currículo completo em formato de texto
  Future<String> generateCV({
    required String fullName,
    required String phone,
    required String email,
    required String city,
    required List<Map<String, String>> experiences,
    required List<String> skills,
    String? objective,
    String? education,
    String? certifications,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final experienceText = experiences
          .map(
            (exp) =>
                '- ${exp['role']} na ${exp['company']} (${exp['period']}): ${exp['description']}',
          )
          .join('\n');

      final skillsText = skills.map((s) => '- $s').join('\n');

      final objectiveSection = objective != null
          ? '\nObjetivo: $objective'
          : '';
      final educationSection = education != null
          ? '\nFormação: $education'
          : '';
      final certSection = certifications != null
          ? '\nCertificações: $certifications'
          : '';

      final prompt =
          '''
Crie um currículo profissional e atrativo para:

DADOS PESSOAIS:
Nome: $fullName
Telefone: $phone
Email: $email
Cidade: $city$objectiveSection

EXPERIÊNCIAS:
$experienceText

HABILIDADES:
$skillsText$educationSection$certSection

Formate como um currículo profissional completo, bem estruturado e persuasivo.
Use formatação clara com seções bem definidas.
Destaque conquistas e diferenciais.
''';

      final cv = await aiService.generateDocument(
        prompt: prompt,
        temperature: 0.5,
      );

      state = const AsyncData(null);
      return cv;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera currículo em formato moderno/criativo
  Future<String> generateCreativeCV({
    required String fullName,
    required String specialty,
    required String instagram,
    required List<String> topSkills,
    required String portfolio,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final skillsList = topSkills.map((s) => '• $s').join('\n');

      final prompt =
          '''
Crie um currículo CRIATIVO e MODERNO para barbeiro influencer:

👤 $fullName
🎨 Especialidade: $specialty
📸 Instagram: $instagram

✨ TOP SKILLS:
$skillsList

🖼️ Portfólio: $portfolio

Crie um currículo que transmita CRIATIVIDADE e PERSONALIDADE.
Use emojis relevantes, linguagem moderna mas profissional.
Destaque o lado artístico e diferenciado do profissional.
Formato: sobre mim, especialidades, conquistas, portfólio, contato.
''';

      final cv = await aiService.generateText(prompt: prompt, temperature: 0.8);

      state = const AsyncData(null);
      return cv;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Melhora currículo existente
  Future<String> improveCV({required String currentCV, String? focus}) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final focusText = focus != null ? '\nFoco especial: $focus' : '';

      final prompt =
          '''
Analise e MELHORE este currículo de barbeiro:

$currentCV$focusText

Melhore:
1. Clareza e estrutura
2. Destaque de conquistas
3. Linguagem profissional
4. Impacto visual (formatação)
5. Palavras-chave relevantes

Retorne o currículo MELHORADO completo.
''';

      final improved = await aiService.correctSpelling(
        text: currentCV,
        improveWriting: true,
      );

      state = const AsyncData(null);
      return improved;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Sugere melhorias para um currículo
  Future<List<String>> suggestImprovements({required String currentCV}) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final prompt =
          '''
Analise este currículo de barbeiro e liste 5-7 sugestões ESPECÍFICAS de melhoria:

$currentCV

Para cada sugestão, seja ESPECÍFICO sobre O QUE e POR QUE melhorar.
Formate cada sugestão como um item de lista começando com "•".
''';

      final response = await aiService.generateText(
        prompt: prompt,
        temperature: 0.6,
      );

      // Extrair linhas que começam com • ou -
      final suggestions = response
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.startsWith('•') || line.startsWith('-'))
          .map((line) => line.replaceFirst(RegExp(r'^[•\-]\s*'), ''))
          .where((line) => line.isNotEmpty)
          .toList();

      state = const AsyncData(null);
      return suggestions.isEmpty ? [response] : suggestions;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
