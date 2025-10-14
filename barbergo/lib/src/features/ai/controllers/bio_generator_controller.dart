import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/ai_service.dart';

part 'bio_generator_controller.g.dart';

/// Controller para geração automática de Bio profissional usando IA
@riverpod
class BioGenerator extends _$BioGenerator {
  @override
  FutureOr<String?> build() => null;

  /// Gera uma bio profissional baseada nas informações do barbeiro
  Future<String> generateBio({
    required String name,
    required List<String> specialties,
    int? experienceYears,
    String? city,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final specialtiesText = specialties.isNotEmpty
          ? specialties.join(', ')
          : 'cortes em geral';

      final experienceText = experienceYears != null && experienceYears > 0
          ? '$experienceYears anos de experiência'
          : 'profissional da área';

      final locationText = city != null && city.isNotEmpty ? ' em $city' : '';

      final prompt =
          '''
Crie uma bio profissional e atraente para um barbeiro:

INFORMAÇÕES:
- Nome: $name
- Especialidades: $specialtiesText
- Experiência: $experienceText
- Localização: ${city ?? 'Não informada'}

REQUISITOS:
- Máximo 120 caracteres
- Em português brasileiro
- Tom profissional mas amigável
- Destacar expertise e diferencial
- Sem usar emojis
- Focar nas especialidades principais
- Incluir um toque de personalidade

EXEMPLOS DE ESTILO:
- "Especialista em fade e degradê$locationText. $experienceText transformando visual e autoestima."
- "Barbeiro apaixonado por detalhes. Destaque em $specialtiesText. Seu estilo merece atenção profissional."

Gere APENAS a bio, sem explicações adicionais.
''';

      final bio = await aiService.generateText(prompt: prompt);

      // Garantir que não ultrapasse 150 caracteres
      final trimmedBio = bio.trim();
      final finalBio = trimmedBio.length > 150
          ? '${trimmedBio.substring(0, 147)}...'
          : trimmedBio;

      state = AsyncValue.data(finalBio);
      return finalBio;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera múltiplas opções de bio para o usuário escolher
  Future<List<String>> generateMultipleOptions({
    required String name,
    required List<String> specialties,
    int? experienceYears,
    String? city,
    int count = 3,
  }) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final specialtiesText = specialties.isNotEmpty
          ? specialties.join(', ')
          : 'cortes em geral';

      final experienceText = experienceYears != null && experienceYears > 0
          ? '$experienceYears anos de experiência'
          : 'profissional da área';

      final prompt =
          '''
Crie $count opções diferentes de bio profissional para um barbeiro:

INFORMAÇÕES:
- Nome: $name
- Especialidades: $specialtiesText
- Experiência: $experienceText
- Localização: ${city ?? 'Não informada'}

REQUISITOS PARA CADA BIO:
- Máximo 120 caracteres
- Em português brasileiro
- Tom profissional mas amigável
- Sem emojis
- Estilos variados (formal, casual-profissional, focado em especialidades)

FORMATO DE RESPOSTA:
Retorne APENAS as bios, uma por linha, numeradas:
1. [primeira bio]
2. [segunda bio]
3. [terceira bio]
''';

      final response = await aiService.generateText(prompt: prompt);

      // Parse das opções
      final lines = response.split('\n');
      final options = <String>[];

      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;

        // Remover numeração se existir
        final bioText = trimmed.replaceFirst(RegExp(r'^\d+\.\s*'), '');
        if (bioText.isNotEmpty && bioText.length > 10) {
          // Garantir limite de caracteres
          final finalBio = bioText.length > 150
              ? '${bioText.substring(0, 147)}...'
              : bioText;
          options.add(finalBio);
        }
      }

      // Se não conseguiu parsear corretamente, gerar opção padrão
      if (options.isEmpty) {
        options.add('$name - $specialtiesText | $experienceText');
      }

      state = AsyncValue.data(options.first);
      return options.take(count).toList();
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Melhora uma bio existente
  Future<String> improveBio(String currentBio) async {
    state = const AsyncLoading();

    try {
      final aiService = ref.read(aIServiceProvider.notifier);

      final prompt =
          '''
Melhore esta bio de barbeiro mantendo as informações principais mas tornando-a mais profissional e atraente:

BIO ATUAL:
"$currentBio"

REQUISITOS:
- Máximo 120 caracteres
- Em português brasileiro
- Tom profissional mas amigável
- Manter as especialidades mencionadas
- Sem emojis
- Mais impactante e memorável

Retorne APENAS a bio melhorada, sem explicações.
''';

      final improvedBio = await aiService.generateText(prompt: prompt);

      final trimmed = improvedBio.trim();
      final finalBio = trimmed.length > 150
          ? '${trimmed.substring(0, 147)}...'
          : trimmed;

      state = AsyncValue.data(finalBio);
      return finalBio;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
