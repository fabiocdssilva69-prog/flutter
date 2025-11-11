import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/date_idea.dart';

part 'date_ideas_repository.g.dart';

/// Repository para Date Ideas
@riverpod
DateIdeasRepository dateIdeasRepository(DateIdeasRepositoryRef ref) {
  return DateIdeasRepository(FirebaseFirestore.instance);
}

class DateIdeasRepository {
  final FirebaseFirestore _firestore;

  DateIdeasRepository(this._firestore);

  CollectionReference get _ideasCollection => _firestore.collection('date_ideas');
  CollectionReference get _suggestionsCollection => _firestore.collection('date_suggestions');
  CollectionReference get _feedbackCollection => _firestore.collection('date_feedback');
  CollectionReference get _historyCollection => _firestore.collection('date_history');
  CollectionReference get _itinerariesCollection => _firestore.collection('date_itineraries');

  // ============================================
  // DATE IDEAS
  // ============================================

  /// Criar nova ideia
  Future<String> createIdea(DateIdea idea) async {
    final docRef = await _ideasCollection.add(idea.toMap());
    return docRef.id;
  }

  /// Obter ideia por ID
  Future<DateIdea?> getIdea(String ideaId) async {
    final doc = await _ideasCollection.doc(ideaId).get();
    if (!doc.exists) return null;

    return DateIdeaMapper.fromMap({...doc.data() as Map<String, dynamic>, 'ideaId': doc.id});
  }

  /// Obter todas as ideias
  Future<List<DateIdea>> getAllIdeas() async {
    final snapshot = await _ideasCollection.orderBy('popularityScore', descending: true).get();

    return snapshot.docs
        .map((doc) => DateIdeaMapper.fromMap({...doc.data() as Map<String, dynamic>, 'ideaId': doc.id}))
        .toList();
  }

  /// Buscar ideias com filtros
  Future<List<DateIdea>> searchIdeas(DateIdeaFilters filters) async {
    Query query = _ideasCollection;

    // Aplicar filtros básicos
    if (filters.categories.isNotEmpty) {
      query = query.where('category', whereIn: filters.categories.map((c) => c.name).toList());
    }

    if (filters.priceRanges.isNotEmpty) {
      query = query.where('priceRange', whereIn: filters.priceRanges.map((p) => p.name).toList());
    }

    final snapshot = await query.get();
    var ideas = snapshot.docs
        .map((doc) => DateIdeaMapper.fromMap({...doc.data() as Map<String, dynamic>, 'ideaId': doc.id}))
        .toList();

    // Filtros adicionais (client-side)
    if (filters.vibes.isNotEmpty) {
      ideas = ideas.where((i) => filters.vibes.contains(i.vibe)).toList();
    }

    if (filters.timesOfDay.isNotEmpty) {
      ideas = ideas.where((i) => filters.timesOfDay.contains(i.bestTimeOfDay)).toList();
    }

    if (filters.firstDateOnly) {
      ideas = ideas.where((i) => i.isFirstDateFriendly).toList();
    }

    return ideas;
  }

  /// Obter ideias por categoria
  Future<List<DateIdea>> getIdeasByCategory(DateCategory category) async {
    final snapshot = await _ideasCollection
        .where('category', isEqualTo: category.name)
        .orderBy('popularityScore', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => DateIdeaMapper.fromMap({...doc.data() as Map<String, dynamic>, 'ideaId': doc.id}))
        .toList();
  }

  /// Obter ideias trending
  Future<List<DateIdea>> getTrendingIdeas({int limit = 10}) async {
    final snapshot = await _ideasCollection
        .orderBy('timesBooked', descending: true)
        .orderBy('popularityScore', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => DateIdeaMapper.fromMap({...doc.data() as Map<String, dynamic>, 'ideaId': doc.id}))
        .toList();
  }

  /// Obter ideias top rated
  Future<List<DateIdea>> getTopRatedIdeas({int limit = 10}) async {
    final snapshot = await _ideasCollection
        .where('averageRating', isGreaterThan: 4.0)
        .orderBy('averageRating', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => DateIdeaMapper.fromMap({...doc.data() as Map<String, dynamic>, 'ideaId': doc.id}))
        .toList();
  }

  /// Atualizar estatísticas da ideia
  Future<void> updateIdeaStats({required String ideaId, double? rating, bool? incrementBookings}) async {
    final updates = <String, dynamic>{};

    if (rating != null) {
      final idea = await getIdea(ideaId);
      if (idea != null) {
        final newCount = idea.timesBooked + 1;
        final newAverage = ((idea.averageRating * idea.timesBooked) + rating) / newCount;
        updates['averageRating'] = newAverage;
      }
    }

    if (incrementBookings == true) {
      updates['timesBooked'] = FieldValue.increment(1);
      updates['popularityScore'] = FieldValue.increment(5);
    }

    if (updates.isNotEmpty) {
      await _ideasCollection.doc(ideaId).update(updates);
    }
  }

  // ============================================
  // PERSONALIZED SUGGESTIONS
  // ============================================

  /// Salvar sugestão personalizada
  Future<String> saveSuggestion(PersonalizedDateSuggestion suggestion) async {
    final docRef = await _suggestionsCollection.add(suggestion.toMap());
    return docRef.id;
  }

  /// Obter sugestões para um par de usuários
  Future<List<PersonalizedDateSuggestion>> getSuggestionsForPair(String userId1, String userId2) async {
    // Normalizar ordem dos IDs
    final users = [userId1, userId2]..sort();

    final snapshot = await _suggestionsCollection
        .where('userId1', isEqualTo: users[0])
        .where('userId2', isEqualTo: users[1])
        .orderBy('compatibilityScore', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              PersonalizedDateSuggestionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'suggestionId': doc.id}),
        )
        .toList();
  }

  /// Obter sugestões do usuário
  Future<List<PersonalizedDateSuggestion>> getUserSuggestions(String userId) async {
    final snapshot1 = await _suggestionsCollection
        .where('userId1', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    final snapshot2 = await _suggestionsCollection
        .where('userId2', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    final suggestions = <PersonalizedDateSuggestion>[];

    for (final doc in snapshot1.docs) {
      suggestions.add(
        PersonalizedDateSuggestionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'suggestionId': doc.id}),
      );
    }

    for (final doc in snapshot2.docs) {
      suggestions.add(
        PersonalizedDateSuggestionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'suggestionId': doc.id}),
      );
    }

    return suggestions;
  }

  // ============================================
  // FEEDBACK
  // ============================================

  /// Submeter feedback
  Future<String> submitFeedback(DateIdeaFeedback feedback) async {
    final docRef = await _feedbackCollection.add(feedback.toMap());

    // Atualizar estatísticas da ideia
    await updateIdeaStats(ideaId: feedback.ideaId, rating: feedback.rating, incrementBookings: feedback.wasUsed);

    return docRef.id;
  }

  /// Obter feedback de uma ideia
  Future<List<DateIdeaFeedback>> getIdeaFeedback(String ideaId) async {
    final snapshot = await _feedbackCollection
        .where('ideaId', isEqualTo: ideaId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => DateIdeaFeedbackMapper.fromMap({...doc.data() as Map<String, dynamic>, 'feedbackId': doc.id}))
        .toList();
  }

  // ============================================
  // HISTORY
  // ============================================

  /// Salvar histórico de encontro
  Future<String> saveHistory(DateHistory history) async {
    final docRef = await _historyCollection.add(history.toMap());
    return docRef.id;
  }

  /// Obter histórico de encontros de um usuário
  Future<List<DateHistory>> getUserHistory(String userId) async {
    final snapshot1 = await _historyCollection
        .where('userId1', isEqualTo: userId)
        .orderBy('dateTime', descending: true)
        .get();

    final snapshot2 = await _historyCollection
        .where('userId2', isEqualTo: userId)
        .orderBy('dateTime', descending: true)
        .get();

    final history = <DateHistory>[];

    for (final doc in snapshot1.docs) {
      history.add(DateHistoryMapper.fromMap({...doc.data() as Map<String, dynamic>, 'historyId': doc.id}));
    }

    for (final doc in snapshot2.docs) {
      history.add(DateHistoryMapper.fromMap({...doc.data() as Map<String, dynamic>, 'historyId': doc.id}));
    }

    history.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return history;
  }

  // ============================================
  // ITINERARIES
  // ============================================

  /// Salvar itinerário
  Future<String> saveItinerary(DateItinerary itinerary) async {
    final docRef = await _itinerariesCollection.add(itinerary.toMap());
    return docRef.id;
  }

  /// Obter itinerário por ID
  Future<DateItinerary?> getItinerary(String itineraryId) async {
    final doc = await _itinerariesCollection.doc(itineraryId).get();
    if (!doc.exists) return null;

    return DateItineraryMapper.fromMap({...doc.data() as Map<String, dynamic>, 'itineraryId': doc.id});
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Obter estatísticas gerais
  Future<DateIdeasStats> getStats() async {
    final ideasSnapshot = await _ideasCollection.get();
    final ideas = ideasSnapshot.docs
        .map((doc) => DateIdeaMapper.fromMap({...doc.data() as Map<String, dynamic>, 'ideaId': doc.id}))
        .toList();

    final usedIdeas = ideas.where((i) => i.timesBooked > 0).length;
    final avgRating = ideas.isEmpty ? 0.0 : ideas.map((i) => i.averageRating).reduce((a, b) => a + b) / ideas.length;

    final categoryCounts = <DateCategory, int>{};
    for (final idea in ideas) {
      categoryCounts[idea.category] = (categoryCounts[idea.category] ?? 0) + 1;
    }

    final priceDistribution = <PriceRange, int>{};
    for (final idea in ideas) {
      priceDistribution[idea.priceRange] = (priceDistribution[idea.priceRange] ?? 0) + 1;
    }

    final trending = await getTrendingIdeas(limit: 5);
    final topRated = await getTopRatedIdeas(limit: 5);

    return DateIdeasStats(
      totalIdeas: ideas.length,
      usedIdeas: usedIdeas,
      averageRating: avgRating,
      categoryCounts: categoryCounts,
      priceDistribution: priceDistribution,
      trendingIdeas: trending,
      topRated: topRated,
      generatedAt: DateTime.now(),
    );
  }

  /// Stream de ideias trending
  Stream<List<DateIdea>> watchTrendingIdeas() {
    return _ideasCollection
        .orderBy('popularityScore', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DateIdeaMapper.fromMap({...doc.data() as Map<String, dynamic>, 'ideaId': doc.id}))
              .toList(),
        );
  }
}
