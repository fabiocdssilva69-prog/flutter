import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/date_idea.dart';
import '../../../../domain/entities/profile_entity.dart';
import '../../../data/repositories/compatibility_repository.dart';
import '../../../data/repositories/date_ideas_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'date_ideas_controller.g.dart';

/// Controller para Date Ideas Generator (Phase 3 - FINAL)
@riverpod
class DateIdeasController extends _$DateIdeasController {
  @override
  FutureOr<bool> build() async {
    // Inicializar ideias padrão se necessário
    await _ensureDefaultIdeas();
    return true;
  }

  // ============================================
  // BROWSE & SEARCH
  // ============================================

  /// Obter todas as ideias
  Future<List<DateIdea>> getAllIdeas() async {
    final repo = ref.read(dateIdeasRepositoryProvider);
    return repo.getAllIdeas();
  }

  /// Buscar ideias com filtros
  Future<List<DateIdea>> searchIdeas(DateIdeaFilters filters) async {
    final repo = ref.read(dateIdeasRepositoryProvider);
    return repo.searchIdeas(filters);
  }

  /// Obter ideias por categoria
  Future<List<DateIdea>> getIdeasByCategory(DateCategory category) async {
    final repo = ref.read(dateIdeasRepositoryProvider);
    return repo.getIdeasByCategory(category);
  }

  /// Obter ideias trending
  Future<List<DateIdea>> getTrendingIdeas() async {
    final repo = ref.read(dateIdeasRepositoryProvider);
    return repo.getTrendingIdeas();
  }

  /// Obter ideias top rated
  Future<List<DateIdea>> getTopRatedIdeas() async {
    final repo = ref.read(dateIdeasRepositoryProvider);
    return repo.getTopRatedIdeas();
  }

  // ============================================
  // PERSONALIZED SUGGESTIONS
  // ============================================

  /// Gerar sugestões personalizadas para um match
  Future<List<PersonalizedDateSuggestion>> generateSuggestionsForMatch({
    required String matchUserId,
    DateIdeaFilters? filters,
    int maxSuggestions = 10,
  }) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final repo = ref.read(dateIdeasRepositoryProvider);

      // Verificar se já existem sugestões recentes
      final existing = await repo.getSuggestionsForPair(currentUser.userId, matchUserId);

      if (existing.isNotEmpty) {
        state = const AsyncData(null);
        return existing.take(maxSuggestions).toList();
      }

      // Obter perfis
      final profileRepo = ref.read(profileRepositoryProvider);
      final matchProfile = await profileRepo.getProfileById(matchUserId);

      if (matchProfile == null) {
        throw Exception('Perfil do match não encontrado');
      }

      // Obter score de compatibilidade
      final compatRepo = ref.read(compatibilityRepositoryProvider);
      final compatScore = await compatRepo.getScore(currentUser.userId, matchUserId);

      // Buscar ideias adequadas
      final ideas = await _findSuitableIdeas(currentUser, matchProfile, compatScore, filters);

      // Criar sugestões personalizadas
      final suggestions = <PersonalizedDateSuggestion>[];

      for (var i = 0; i < ideas.length && i < maxSuggestions; i++) {
        final idea = ideas[i];
        final reasons = _generateReasons(idea, currentUser, matchProfile);

        final suggestion = PersonalizedDateSuggestion(
          suggestionId: '',
          userId1: currentUser.userId,
          userId2: matchUserId,
          dateIdea: idea,
          compatibilityScore: compatScore?.overallScore ?? 75.0,
          whyThisWorks: reasons,
          suggestedDate: _suggestDate(idea),
          suggestedTime: _suggestTime(idea),
          isAIGenerated: true,
          createdAt: DateTime.now(),
        );

        await repo.saveSuggestion(suggestion);
        suggestions.add(suggestion);
      }

      state = const AsyncData(null);
      return suggestions;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Obter sugestões salvas
  Future<List<PersonalizedDateSuggestion>> getMySuggestions() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(dateIdeasRepositoryProvider);
    return repo.getUserSuggestions(currentUser.userId);
  }

  // ============================================
  // ITINERARY GENERATION
  // ============================================

  /// Gerar itinerário completo
  Future<DateItinerary> generateItinerary({
    required DateTheme theme,
    required Duration targetDuration,
    PriceRange? maxPriceRange,
  }) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(dateIdeasRepositoryProvider);

      // Selecionar ideias baseadas no tema
      final ideas = await _selectIdeasForTheme(theme, targetDuration, maxPriceRange);

      // Calcular duração total
      final totalDuration = ideas.fold<Duration>(Duration.zero, (sum, idea) => sum + idea.estimatedDuration);

      // Estimar custo
      final costs = ideas.map((i) => _priceRangeToValue(i.priceRange)).toList();
      final avgCost = costs.reduce((a, b) => a + b) / costs.length;
      final estimatedCost = _valueToPriceRange(avgCost);

      // Criar itinerário
      final itinerary = DateItinerary(
        itineraryId: '',
        title: _getThemeName(theme),
        ideas: ideas,
        totalDuration: totalDuration,
        estimatedCost: estimatedCost,
        transportationNotes: 'Use transporte próprio ou app de mobilidade',
        packingList: _generatePackingList(ideas),
        reservations: {},
      );

      await repo.saveItinerary(itinerary);

      state = const AsyncData(null);
      return itinerary;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  // ============================================
  // FEEDBACK & HISTORY
  // ============================================

  /// Submeter feedback sobre uma ideia
  Future<void> submitFeedback({
    required String ideaId,
    required double rating,
    bool wasUsed = false,
    String? review,
    List<String>? pros,
    List<String>? cons,
  }) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final feedback = DateIdeaFeedback(
        feedbackId: '',
        userId: currentUser.userId,
        ideaId: ideaId,
        rating: rating,
        wasUsed: wasUsed,
        review: review,
        pros: pros ?? [],
        cons: cons ?? [],
        createdAt: DateTime.now(),
      );

      final repo = ref.read(dateIdeasRepositoryProvider);
      await repo.submitFeedback(feedback);

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Salvar histórico de encontro realizado
  Future<void> saveToHistory({
    required String matchUserId,
    required String ideaId,
    required DateTime dateTime,
    bool wasSuccessful = true,
    double rating = 0.0,
    String? notes,
  }) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return;

    final repo = ref.read(dateIdeasRepositoryProvider);
    final idea = await repo.getIdea(ideaId);

    if (idea == null) return;

    final history = DateHistory(
      historyId: '',
      userId1: currentUser.userId,
      userId2: matchUserId,
      idea: idea,
      dateTime: dateTime,
      wasSuccessful: wasSuccessful,
      rating: rating,
      notes: notes,
    );

    await repo.saveHistory(history);
  }

  /// Obter histórico de encontros
  Future<List<DateHistory>> getMyHistory() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(dateIdeasRepositoryProvider);
    return repo.getUserHistory(currentUser.userId);
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Obter estatísticas gerais
  Future<DateIdeasStats> getStats() async {
    final repo = ref.read(dateIdeasRepositoryProvider);
    return repo.getStats();
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  Future<void> _ensureDefaultIdeas() async {
    final repo = ref.read(dateIdeasRepositoryProvider);
    final existing = await repo.getAllIdeas();

    if (existing.isEmpty) {
      await _createDefaultIdeas();
    }
  }

  Future<void> _createDefaultIdeas() async {
    final repo = ref.read(dateIdeasRepositoryProvider);

    final defaultIdeas = [
      DateIdea(
        ideaId: '',
        title: 'Café e Conversa',
        description: 'Um encontro clássico em uma cafeteria aconchegante. Perfeito para primeiras datas.',
        category: DateCategory.coffee,
        vibe: DateVibe.lowKey,
        priceRange: PriceRange.budget,
        estimatedDuration: const Duration(hours: 1, minutes: 30),
        bestTimeOfDay: TimeOfDay.afternoon,
        tags: ['primeira data', 'casual', 'conversa'],
        activities: [
          DateActivity(
            activityId: 'a1',
            name: 'Pedir café',
            description: 'Escolher bebidas e encontrar um lugar confortável',
            duration: const Duration(minutes: 15),
            order: 1,
          ),
          DateActivity(
            activityId: 'a2',
            name: 'Conversar',
            description: 'Conhecer melhor um ao outro',
            duration: const Duration(minutes: 75),
            order: 2,
          ),
        ],
        tips: {'dress_code': 'Casual, mas caprichado', 'topics': 'Evite temas polêmicos no primeiro encontro'},
        createdAt: DateTime.now(),
      ),
      DateIdea(
        ideaId: '',
        title: 'Jantar Romântico',
        description: 'Jantar em restaurante com ambiente romântico.',
        category: DateCategory.dinner,
        vibe: DateVibe.romantic,
        priceRange: PriceRange.moderate,
        estimatedDuration: const Duration(hours: 2),
        bestTimeOfDay: TimeOfDay.evening,
        tags: ['romântico', 'jantar', 'especial'],
        activities: [
          DateActivity(
            activityId: 'a1',
            name: 'Aperitivo',
            description: 'Drinks e entradas',
            duration: const Duration(minutes: 30),
            order: 1,
          ),
          DateActivity(
            activityId: 'a2',
            name: 'Prato principal',
            description: 'Jantar',
            duration: const Duration(hours: 1),
            order: 2,
          ),
          DateActivity(
            activityId: 'a3',
            name: 'Sobremesa',
            description: 'Finalizar com algo doce',
            duration: const Duration(minutes: 30),
            order: 3,
          ),
        ],
        tips: {'reservation': 'Faça reserva com antecedência', 'dress_code': 'Traje social'},
        createdAt: DateTime.now(),
      ),
      DateIdea(
        ideaId: '',
        title: 'Caminhada no Parque',
        description: 'Caminhar em um parque bonito, apreciar a natureza.',
        category: DateCategory.outdoor,
        vibe: DateVibe.lowKey,
        priceRange: PriceRange.free,
        estimatedDuration: const Duration(hours: 2),
        bestTimeOfDay: TimeOfDay.morning,
        tags: ['outdoor', 'grátis', 'natureza', 'ativo'],
        activities: [
          DateActivity(
            activityId: 'a1',
            name: 'Caminhada',
            description: 'Explorar o parque juntos',
            duration: const Duration(hours: 1, minutes: 30),
            order: 1,
          ),
          DateActivity(
            activityId: 'a2',
            name: 'Pausa para foto',
            description: 'Tirar fotos em lugares bonitos',
            duration: const Duration(minutes: 30),
            order: 2,
          ),
        ],
        tips: {'weather': 'Verificar previsão do tempo', 'clothing': 'Use roupas e calçados confortáveis'},
        createdAt: DateTime.now(),
      ),
    ];

    for (final idea in defaultIdeas) {
      await repo.createIdea(idea);
    }
  }

  Future<List<DateIdea>> _findSuitableIdeas(
    ProfileEntity user1,
    ProfileEntity user2,
    dynamic compatScore,
    DateIdeaFilters? filters,
  ) async {
    final repo = ref.read(dateIdeasRepositoryProvider);

    // Buscar com filtros se fornecidos
    if (filters != null) {
      return repo.searchIdeas(filters);
    }

    // Usar interesses comuns para sugerir categorias
    final commonInterests = user1.interests.toSet().intersection(user2.interests.toSet());

    // Buscar todas as ideias e filtrar
    final allIdeas = await repo.getAllIdeas();

    // Priorizar ideias que correspondem aos interesses
    final scored = allIdeas.map((idea) {
      var score = idea.popularityScore;

      // Boost para interesses comuns
      for (final interest in commonInterests) {
        if (idea.tags.any((tag) => tag.toLowerCase().contains(interest.toLowerCase()))) {
          score += 20;
        }
      }

      return MapEntry(idea, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));

    return scored.take(15).map((e) => e.key).toList();
  }

  List<String> _generateReasons(DateIdea idea, ProfileEntity user1, ProfileEntity user2) {
    final reasons = <String>[];

    final commonInterests = user1.interests.toSet().intersection(user2.interests.toSet());

    if (commonInterests.isNotEmpty) {
      reasons.add('Combina com seus interesses em comum');
    }

    if (idea.isFirstDateFriendly) {
      reasons.add('Perfeito para primeiras datas');
    }

    if (idea.averageRating >= 4.5) {
      reasons.add('Altamente avaliado por outros casais');
    }

    if (idea.priceRange == PriceRange.budget || idea.priceRange == PriceRange.free) {
      reasons.add('Opção econômica');
    }

    return reasons.take(3).toList();
  }

  DateTime _suggestDate(DateIdea idea) {
    final now = DateTime.now();

    // Sugerir fim de semana
    var daysUntilWeekend = DateTime.saturday - now.weekday;
    if (daysUntilWeekend < 0) daysUntilWeekend += 7;

    return now.add(Duration(days: daysUntilWeekend));
  }

  String _suggestTime(DateIdea idea) {
    switch (idea.bestTimeOfDay) {
      case TimeOfDay.morning:
        return '10:00';
      case TimeOfDay.afternoon:
        return '15:00';
      case TimeOfDay.evening:
        return '19:00';
      case TimeOfDay.lateNight:
        return '22:00';
      case TimeOfDay.anytime:
        return '14:00';
    }
  }

  Future<List<DateIdea>> _selectIdeasForTheme(DateTheme theme, Duration targetDuration, PriceRange? maxPrice) async {
    final repo = ref.read(dateIdeasRepositoryProvider);
    final allIdeas = await repo.getAllIdeas();

    // Filtrar por preço se especificado
    var filtered = maxPrice != null
        ? allIdeas.where((i) => _comparePriceRange(i.priceRange, maxPrice) <= 0).toList()
        : allIdeas;

    // Ordenar por adequação ao tema
    filtered.sort((a, b) => _scoreForTheme(b, theme).compareTo(_scoreForTheme(a, theme)));

    // Selecionar 2-3 ideias que se encaixem na duração
    return filtered.take(3).toList();
  }

  double _scoreForTheme(DateIdea idea, DateTheme theme) {
    switch (theme) {
      case DateTheme.romantic:
        return idea.vibe == DateVibe.romantic ? 100.0 : 50.0;
      case DateTheme.adventurous:
        return idea.vibe == DateVibe.adventurous ? 100.0 : 50.0;
      case DateTheme.cultural:
        return idea.category == DateCategory.cultural ? 100.0 : 50.0;
      case DateTheme.firstDate:
        return idea.isFirstDateFriendly ? 100.0 : 30.0;
      default:
        return 50.0;
    }
  }

  List<String> _generatePackingList(List<DateIdea> ideas) {
    final items = <String>{};

    for (final idea in ideas) {
      if (idea.category == DateCategory.outdoor) {
        items.addAll(['Protetor solar', 'Água', 'Boné']);
      }
      if (idea.category == DateCategory.adventure) {
        items.addAll(['Calçado adequado', 'Mochila']);
      }
    }

    return items.toList();
  }

  String _getThemeName(DateTheme theme) {
    switch (theme) {
      case DateTheme.romantic:
        return 'Encontro Romântico';
      case DateTheme.adventurous:
        return 'Aventura a Dois';
      case DateTheme.cultural:
        return 'Experiência Cultural';
      case DateTheme.firstDate:
        return 'Primeira Data Perfeita';
      case DateTheme.foodie:
        return 'Tour Gastronômico';
      default:
        return 'Encontro Especial';
    }
  }

  double _priceRangeToValue(PriceRange range) {
    switch (range) {
      case PriceRange.free:
        return 0;
      case PriceRange.budget:
        return 25;
      case PriceRange.moderate:
        return 100;
      case PriceRange.expensive:
        return 225;
      case PriceRange.luxury:
        return 400;
    }
  }

  PriceRange _valueToPriceRange(double value) {
    if (value == 0) return PriceRange.free;
    if (value <= 50) return PriceRange.budget;
    if (value <= 150) return PriceRange.moderate;
    if (value <= 300) return PriceRange.expensive;
    return PriceRange.luxury;
  }

  int _comparePriceRange(PriceRange a, PriceRange b) {
    return _priceRangeToValue(a).compareTo(_priceRangeToValue(b));
  }
}

/// Provider para ideias trending
@riverpod
Future<List<DateIdea>> trendingDateIdeas(TrendingDateIdeasRef ref) async {
  final controller = ref.watch(dateIdeasControllerProvider.notifier);
  return controller.getTrendingIdeas();
}

/// Provider para top rated
@riverpod
Future<List<DateIdea>> topRatedDateIdeas(TopRatedDateIdeasRef ref) async {
  final controller = ref.watch(dateIdeasControllerProvider.notifier);
  return controller.getTopRatedIdeas();
}
