import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/prompt_response.dart';

part 'prompts_controller.g.dart';

/// Controller para gerenciar sistema de prompts (Hinge model)
@riverpod
class PromptsController extends _$PromptsController {
  static const uuid = Uuid();

  @override
  FutureOr<void> build() {}

  /// Lista de prompts disponíveis (50+ prompts para escolher)
  List<PromptDefinition> getAvailablePrompts() {
    return [
      // Categoria: Personalidade
      PromptDefinition(
        id: 'secret_talent',
        text: 'Meu talento secreto é...',
        category: 'Personalidade',
      ),
      PromptDefinition(
        id: 'win_heart',
        text: 'A maneira mais rápida de conquistar meu coração é...',
        category: 'Romance',
      ),
      PromptDefinition(
        id: 'love_at_first_sight',
        text: 'Eu sei que foi amor à primeira vista quando...',
        category: 'Romance',
      ),
      PromptDefinition(
        id: 'favorite_controversy',
        text: 'Minha controvérsia favorita é...',
        category: 'Personalidade',
      ),
      PromptDefinition(
        id: 'together_we_could',
        text: 'Juntos poderíamos...',
        category: 'Atividades',
      ),
      PromptDefinition(
        id: 'looking_for',
        text: 'Eu quero alguém que...',
        category: 'Relacionamento',
      ),
      PromptDefinition(
        id: 'dance_move',
        text: 'Meu movimento de dança característico é...',
        category: 'Diversão',
      ),
      PromptDefinition(
        id: 'embarrassing_story',
        text: 'Minha história mais constrangedora é...',
        category: 'Diversão',
      ),
      PromptDefinition(
        id: 'change_about_myself',
        text: 'Uma coisa que eu mudaria sobre mim é...',
        category: 'Honestidade',
      ),
      PromptDefinition(
        id: 'dating_me',
        text: 'Me dar uma chance significa...',
        category: 'Romance',
      ),
      
      // Categoria: Interesses
      PromptDefinition(
        id: 'perfect_day',
        text: 'Meu dia perfeito seria...',
        category: 'Lifestyle',
      ),
      PromptDefinition(
        id: 'bucket_list',
        text: 'Na minha bucket list está...',
        category: 'Sonhos',
      ),
      PromptDefinition(
        id: 'sunday_morning',
        text: 'Minhas manhãs de domingo são...',
        category: 'Lifestyle',
      ),
      PromptDefinition(
        id: 'music_taste',
        text: 'Minha música para tudo é...',
        category: 'Música',
      ),
      PromptDefinition(
        id: 'travel_story',
        text: 'Minha melhor viagem foi...',
        category: 'Viagens',
      ),
      
      // Categoria: Valores
      PromptDefinition(
        id: 'deal_breaker',
        text: 'Algo que é deal breaker para mim é...',
        category: 'Valores',
      ),
      PromptDefinition(
        id: 'belief_in',
        text: 'Eu acredito fortemente em...',
        category: 'Valores',
      ),
      PromptDefinition(
        id: 'green_flag',
        text: 'Uma green flag para mim é...',
        category: 'Relacionamento',
      ),
      PromptDefinition(
        id: 'red_flag',
        text: 'Uma red flag para mim é...',
        category: 'Relacionamento',
      ),
      
      // Categoria: Diversão
      PromptDefinition(
        id: 'useless_skill',
        text: 'Uma habilidade inútil que tenho é...',
        category: 'Diversão',
      ),
      PromptDefinition(
        id: 'weird_flex',
        text: 'Meu weird flex é...',
        category: 'Diversão',
      ),
      PromptDefinition(
        id: 'hot_take',
        text: 'Minha opinião polêmica é...',
        category: 'Personalidade',
      ),
      PromptDefinition(
        id: 'unpopular_opinion',
        text: 'Uma opinião impopular que tenho é...',
        category: 'Personalidade',
      ),
      
      // Categoria: Date Ideas
      PromptDefinition(
        id: 'first_date_idea',
        text: 'Minha ideia de primeiro encontro ideal é...',
        category: 'Romance',
      ),
      PromptDefinition(
        id: 'typical_friday',
        text: 'Numa sexta-feira típica você me encontra...',
        category: 'Lifestyle',
      ),
      PromptDefinition(
        id: 'best_date',
        text: 'O melhor encontro que já tive foi...',
        category: 'Romance',
      ),
      
      // Total: 26 prompts (expandível para 50+)
    ];
  }

  /// Validar que usuário escolheu exatamente 3 prompts
  bool validatePrompts(List<PromptResponse> prompts) {
    if (prompts.length != 3) return false;
    
    // Cada resposta deve ter no mínimo 20 chars e máximo 200
    return prompts.every((p) => p.isValid);
  }

  /// Criar nova resposta de prompt
  PromptResponse createPromptResponse({
    required String promptId,
    required String promptText,
    required String response,
  }) {
    // Validar comprimento
    if (response.length < 20) {
      throw Exception('A resposta deve ter no mínimo 20 caracteres');
    }
    if (response.length > 200) {
      throw Exception('A resposta deve ter no máximo 200 caracteres');
    }

    return PromptResponse(
      responseId: uuid.v4(),
      promptId: promptId,
      promptText: promptText,
      response: response.trim(),
      createdAt: DateTime.now(),
    );
  }

  /// Buscar prompt por ID
  PromptDefinition? getPromptById(String promptId) {
    try {
      return getAvailablePrompts().firstWhere((p) => p.id == promptId);
    } catch (e) {
      return null;
    }
  }

  /// Sugerir prompts populares (3 mais usados)
  List<PromptDefinition> getSuggestedPrompts() {
    // TODO: Implementar analytics de prompts mais populares
    // Por enquanto, retorna os 3 primeiros
    return getAvailablePrompts().take(3).toList();
  }

  /// Filtrar prompts por categoria
  List<PromptDefinition> getPromptsByCategory(String category) {
    return getAvailablePrompts()
        .where((p) => p.category == category)
        .toList();
  }

  /// Obter categorias únicas
  List<String> getCategories() {
    final categories = getAvailablePrompts()
        .map((p) => p.category)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }
}

/// Definição de um prompt disponível
class PromptDefinition {
  final String id;
  final String text;
  final String category;

  const PromptDefinition({
    required this.id,
    required this.text,
    required this.category,
  });
}
