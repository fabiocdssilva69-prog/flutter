import 'package:dart_mappable/dart_mappable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'date_idea.g.dart';

/// Entity para Date Ideas Generator (Phase 3 - FINAL)
/// Sistema de sugestões personalizadas de encontros
@MappableClass()
class DateIdea with DateIdeaMappable {
  final String ideaId;
  final String title;
  final String description;
  final DateCategory category;
  final DateVibe vibe;
  final PriceRange priceRange;
  final Duration estimatedDuration;
  final TimeOfDay bestTimeOfDay;
  final List<String> tags;
  final double popularityScore; // 0-100
  final int timesBooked;
  final double averageRating;
  final String? imageUrl;
  final DateLocation? location;
  final List<DateActivity> activities;
  final Map<String, String> tips; // Dicas úteis
  final DateTime createdAt;

  const DateIdea({
    required this.ideaId,
    required this.title,
    required this.description,
    required this.category,
    required this.vibe,
    required this.priceRange,
    required this.estimatedDuration,
    required this.bestTimeOfDay,
    required this.tags,
    this.popularityScore = 50.0,
    this.timesBooked = 0,
    this.averageRating = 0.0,
    this.imageUrl,
    this.location,
    required this.activities,
    this.tips = const {},
    required this.createdAt,
  });

  /// Verificar se é adequado para primeira data
  bool get isFirstDateFriendly =>
      category == DateCategory.casual || category == DateCategory.coffee || vibe == DateVibe.lowKey;

  /// Verificar se requer reserva
  bool get requiresReservation => category == DateCategory.fineDining || category == DateCategory.events;
}

/// Categorias de encontro
enum DateCategory {
  casual, // Casual
  coffee, // Café
  dinner, // Jantar
  fineDining, // Jantar fino
  drinks, // Drinks
  outdoor, // Ao ar livre
  adventure, // Aventura
  cultural, // Cultural (museu, teatro)
  sports, // Esportes
  entertainment, // Entretenimento
  romantic, // Romântico
  creative, // Criativo (pintura, cerâmica)
  events, // Eventos
  nightlife, // Vida noturna
  relaxing, // Relaxante (spa, massagem)
}

/// Vibe do encontro
enum DateVibe {
  romantic, // Romântico
  fun, // Divertido
  adventurous, // Aventureiro
  intellectual, // Intelectual
  lowKey, // Tranquilo
  energetic, // Energético
  intimate, // Íntimo
  social, // Social
}

/// Faixa de preço
enum PriceRange {
  free, // Grátis
  budget, // $ (R$ 0-50)
  moderate, // $$ (R$ 50-150)
  expensive, // $$$ (R$ 150-300)
  luxury, // $$$$ (R$ 300+)
}

/// Período do dia
enum TimeOfDay {
  morning, // Manhã (6h-12h)
  afternoon, // Tarde (12h-18h)
  evening, // Noite (18h-22h)
  lateNight, // Madrugada (22h-6h)
  anytime, // Qualquer hora
}

/// Localização do encontro
@MappableClass()
class DateLocation with DateLocationMappable {
  final String name;
  final String address;
  final LatLng coordinates;
  final String? phoneNumber;
  final String? website;
  final Map<String, String> openingHours; // day -> hours

  const DateLocation({
    required this.name,
    required this.address,
    required this.coordinates,
    this.phoneNumber,
    this.website,
    this.openingHours = const {},
  });
}

/// Atividade dentro do encontro
@MappableClass()
class DateActivity with DateActivityMappable {
  final String activityId;
  final String name;
  final String description;
  final Duration duration;
  final int order; // Ordem na sequência

  const DateActivity({
    required this.activityId,
    required this.name,
    required this.description,
    required this.duration,
    required this.order,
  });
}

/// Sugestão personalizada de encontro
@MappableClass()
class PersonalizedDateSuggestion with PersonalizedDateSuggestionMappable {
  final String suggestionId;
  final String userId1;
  final String userId2;
  final DateIdea dateIdea;
  final double compatibilityScore; // 0-100 (baseado em perfis)
  final List<String> whyThisWorks; // Razões da sugestão
  final DateTime suggestedDate;
  final String? suggestedTime;
  final bool isAIGenerated;
  final DateTime createdAt;

  const PersonalizedDateSuggestion({
    required this.suggestionId,
    required this.userId1,
    required this.userId2,
    required this.dateIdea,
    required this.compatibilityScore,
    required this.whyThisWorks,
    required this.suggestedDate,
    this.suggestedTime,
    this.isAIGenerated = false,
    required this.createdAt,
  });
}

/// Filtros para busca de ideias
@MappableClass()
class DateIdeaFilters with DateIdeaFiltersMappable {
  final Set<DateCategory> categories;
  final Set<DateVibe> vibes;
  final Set<PriceRange> priceRanges;
  final Set<TimeOfDay> timesOfDay;
  final double? maxDistance; // km
  final bool firstDateOnly;
  final bool outdoorOnly;
  final bool indoorOnly;

  const DateIdeaFilters({
    this.categories = const {},
    this.vibes = const {},
    this.priceRanges = const {},
    this.timesOfDay = const {},
    this.maxDistance,
    this.firstDateOnly = false,
    this.outdoorOnly = false,
    this.indoorOnly = false,
  });
}

/// Feedback sobre uma ideia de encontro
@MappableClass()
class DateIdeaFeedback with DateIdeaFeedbackMappable {
  final String feedbackId;
  final String userId;
  final String ideaId;
  final double rating; // 1-5
  final bool wasUsed; // Se realmente saiu neste encontro
  final String? review;
  final List<String> pros;
  final List<String> cons;
  final DateTime createdAt;

  const DateIdeaFeedback({
    required this.feedbackId,
    required this.userId,
    required this.ideaId,
    required this.rating,
    this.wasUsed = false,
    this.review,
    this.pros = const [],
    this.cons = const [],
    required this.createdAt,
  });
}

/// Itinerário completo de encontro
@MappableClass()
class DateItinerary with DateItineraryMappable {
  final String itineraryId;
  final String title;
  final List<DateIdea> ideas;
  final Duration totalDuration;
  final PriceRange estimatedCost;
  final String? transportationNotes;
  final List<String> packingList;
  final Map<String, String> reservations; // place -> reservation info

  const DateItinerary({
    required this.itineraryId,
    required this.title,
    required this.ideas,
    required this.totalDuration,
    required this.estimatedCost,
    this.transportationNotes,
    this.packingList = const [],
    this.reservations = const {},
  });
}

/// Template de encontro
@MappableClass()
class DateTemplate with DateTemplateMappable {
  final String templateId;
  final String name;
  final String description;
  final DateTheme theme;
  final List<String> requiredCategories; // Categorias que devem estar presentes
  final int minActivities;
  final int maxActivities;
  final Duration targetDuration;

  const DateTemplate({
    required this.templateId,
    required this.name,
    required this.description,
    required this.theme,
    required this.requiredCategories,
    this.minActivities = 2,
    this.maxActivities = 4,
    required this.targetDuration,
  });
}

/// Temas de encontro
enum DateTheme {
  firstDate, // Primeira data
  romantic, // Romântico
  adventurous, // Aventureiro
  cultural, // Cultural
  foodie, // Gastronômico
  active, // Ativo
  relaxed, // Relaxado
  unique, // Único/Inusitado
  seasonal, // Sazonal
  surprise, // Surpresa
}

/// Estatísticas de ideias de encontro
@MappableClass()
class DateIdeasStats with DateIdeasStatsMappable {
  final int totalIdeas;
  final int usedIdeas;
  final double averageRating;
  final Map<DateCategory, int> categoryCounts;
  final Map<PriceRange, int> priceDistribution;
  final List<DateIdea> trendingIdeas;
  final List<DateIdea> topRated;
  final DateTime generatedAt;

  const DateIdeasStats({
    required this.totalIdeas,
    required this.usedIdeas,
    required this.averageRating,
    required this.categoryCounts,
    required this.priceDistribution,
    required this.trendingIdeas,
    required this.topRated,
    required this.generatedAt,
  });
}

/// Request para gerar sugestões
@MappableClass()
class GenerateDateSuggestionsRequest with GenerateDateSuggestionsRequestMappable {
  final String userId1;
  final String userId2;
  final DateIdeaFilters? filters;
  final int maxSuggestions;
  final bool includeAIGenerated;

  const GenerateDateSuggestionsRequest({
    required this.userId1,
    required this.userId2,
    this.filters,
    this.maxSuggestions = 10,
    this.includeAIGenerated = true,
  });
}

/// Seasonal date idea (datas sazonais)
@MappableClass()
class SeasonalDateIdea with SeasonalDateIdeaMappable {
  final String ideaId;
  final DateIdea baseIdea;
  final Season season;
  final DateTime startDate;
  final DateTime endDate;
  final String seasonalTwist; // O que torna especial nesta época

  const SeasonalDateIdea({
    required this.ideaId,
    required this.baseIdea,
    required this.season,
    required this.startDate,
    required this.endDate,
    required this.seasonalTwist,
  });

  /// Verificar se está na temporada
  bool get isInSeason {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }
}

/// Estações do ano
enum Season {
  spring, // Primavera
  summer, // Verão
  fall, // Outono
  winter, // Inverno
  holiday, // Feriados especiais
}

/// Histórico de encontros realizados
@MappableClass()
class DateHistory with DateHistoryMappable {
  final String historyId;
  final String userId1;
  final String userId2;
  final DateIdea idea;
  final DateTime dateTime;
  final bool wasSuccessful;
  final double rating;
  final String? notes;

  const DateHistory({
    required this.historyId,
    required this.userId1,
    required this.userId2,
    required this.idea,
    required this.dateTime,
    this.wasSuccessful = true,
    this.rating = 0.0,
    this.notes,
  });
}
