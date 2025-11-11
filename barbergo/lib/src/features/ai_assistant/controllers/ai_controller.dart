import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/ai_message_entity.dart';
import '../repositories/ai_repository.dart';
import '../services/gemini_service.dart';

part 'ai_controller.g.dart';

// ========== PROVIDERS ==========

/// Provider do repository
final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository();
});

/// Provider do serviço Gemini
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

/// Stream provider de sessões de chat
@riverpod
Stream<List<AiChatSessionEntity>> chatSessions(ChatSessionsRef ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return repository.watchChatSessions();
}

/// Stream provider de mensagens de uma sessão
@riverpod
Stream<List<AiMessageEntity>> chatMessages(ChatMessagesRef ref, String sessionId) {
  final repository = ref.watch(aiRepositoryProvider);
  return repository.watchMessages(sessionId);
}

/// Stream provider de sugestões salvas
@riverpod
Stream<List<StyleSuggestionEntity>> styleSuggestions(StyleSuggestionsRef ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return repository.watchSuggestions();
}

/// Provider de perguntas sugeridas
@riverpod
Future<List<String>> suggestedQuestions(SuggestedQuestionsRef ref) async {
  final service = ref.watch(geminiServiceProvider);
  return await service.getSuggestedQuestions();
}

// ========== CONTROLLER ==========

@riverpod
class AiController extends _$AiController {
  @override
  FutureOr<void> build() async {
    // Inicialização
  }

  AiRepository get _repository => ref.read(aiRepositoryProvider);
  GeminiService get _service => ref.read(geminiServiceProvider);

  // ========== CHAT SESSIONS ==========

  /// Cria nova sessão de chat
  Future<AiChatSessionEntity?> createChatSession(String title) async {
    state = const AsyncLoading();

    try {
      final session = await _repository.createChatSession(title);
      state = const AsyncData(null);

      // Invalidar lista de sessões
      ref.invalidate(chatSessionsProvider);

      return session;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    }
  }

  /// Deleta sessão de chat
  Future<bool> deleteChatSession(String sessionId) async {
    state = const AsyncLoading();

    try {
      await _repository.deleteChatSession(sessionId);
      state = const AsyncData(null);

      // Invalidar lista
      ref.invalidate(chatSessionsProvider);

      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }

  // ========== MESSAGING ==========

  /// Envia mensagem do usuário e obtém resposta da IA
  Future<bool> sendMessage({required String sessionId, required String message}) async {
    try {
      // 1. Adicionar mensagem do usuário
      await _repository.addMessage(sessionId: sessionId, content: message, isUserMessage: true);

      // 2. Buscar contexto (últimas mensagens)
      final recentMessages = await _repository.getRecentMessages(sessionId);

      // Converter para formato Gemini
      final history = recentMessages.map((msg) {
        return Content.text(msg.content);
      }).toList();

      // 3. Enviar para Gemini
      final aiResponse = await _service.sendMessage(message: message, conversationHistory: history);

      // 4. Salvar resposta da IA
      await _repository.addMessage(sessionId: sessionId, content: aiResponse, isUserMessage: false);

      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  /// Envia mensagem com stream (texto aparece gradualmente)
  Stream<String> sendMessageStream({required String sessionId, required String message}) async* {
    try {
      // 1. Adicionar mensagem do usuário
      await _repository.addMessage(sessionId: sessionId, content: message, isUserMessage: true);

      // 2. Stream da resposta
      final responseStream = _service.sendMessageStream(message);

      String fullResponse = '';

      await for (final chunk in responseStream) {
        fullResponse += chunk;
        yield fullResponse;
      }

      // 3. Salvar resposta completa
      await _repository.addMessage(sessionId: sessionId, content: fullResponse, isUserMessage: false);
    } catch (e) {
      yield 'Erro ao enviar mensagem: $e';
    }
  }

  // ========== STYLE ANALYSIS ==========

  /// Analisa imagem de corte e retorna sugestões
  Future<String?> analyzeHairstyle({required File imageFile, String? sessionId}) async {
    state = const AsyncLoading();

    try {
      // 1. Upload da imagem
      final imageUrl = await _repository.uploadImage(imageFile);

      // 2. Ler bytes da imagem
      final imageBytes = await imageFile.readAsBytes();

      // 3. Analisar com Gemini
      final analysis = await _service.analyzeHairstyle(imageBytes: imageBytes);

      // 4. Se há sessão ativa, adicionar às mensagens
      if (sessionId != null) {
        await _repository.addMessage(
          sessionId: sessionId,
          content: 'Análise de estilo:',
          isUserMessage: true,
          imageUrl: imageUrl,
          type: MessageType.image,
        );

        await _repository.addMessage(sessionId: sessionId, content: analysis, isUserMessage: false);
      }

      // 5. Salvar como sugestão
      await _repository.saveSuggestion(suggestion: analysis, imageUrl: imageUrl);

      state = const AsyncData(null);

      // Invalidar sugestões
      ref.invalidate(styleSuggestionsProvider);

      return analysis;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    }
  }

  // ========== RECOMMENDATIONS ==========

  /// Busca recomendações de barbearias
  Future<String?> recommendBarbershops({
    required String location,
    String? style,
    String? budget,
    String? sessionId,
  }) async {
    state = const AsyncLoading();

    try {
      final recommendation = await _service.recommendBarbershops(location: location, style: style, budget: budget);

      // Se há sessão, adicionar às mensagens
      if (sessionId != null) {
        await _repository.addMessage(
          sessionId: sessionId,
          content: 'Recomende barbearias em $location',
          isUserMessage: true,
        );

        await _repository.addMessage(sessionId: sessionId, content: recommendation, isUserMessage: false);
      }

      state = const AsyncData(null);
      return recommendation;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    }
  }

  /// Obtém dicas de cuidados capilares
  Future<String?> getHairCareTips({String? hairType, String? concern, String? sessionId}) async {
    state = const AsyncLoading();

    try {
      final tips = await _service.getHairCareTips(hairType: hairType, concern: concern);

      // Se há sessão, adicionar às mensagens
      if (sessionId != null) {
        String userMessage = 'Dicas de cuidados';
        if (hairType != null) userMessage += ' para cabelo $hairType';
        if (concern != null) userMessage += ' (preocupação: $concern)';

        await _repository.addMessage(sessionId: sessionId, content: userMessage, isUserMessage: true);

        await _repository.addMessage(sessionId: sessionId, content: tips, isUserMessage: false);
      }

      state = const AsyncData(null);
      return tips;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    }
  }

  // ========== SUGGESTIONS ==========

  /// Toggle favorito em sugestão
  Future<bool> toggleSuggestionFavorite(String suggestionId, bool isFavorite) async {
    try {
      await _repository.toggleSuggestionFavorite(suggestionId, isFavorite);

      // Invalidar lista
      ref.invalidate(styleSuggestionsProvider);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deleta sugestão
  Future<bool> deleteSuggestion(String suggestionId) async {
    try {
      await _repository.deleteSuggestion(suggestionId);

      // Invalidar lista
      ref.invalidate(styleSuggestionsProvider);

      return true;
    } catch (e) {
      return false;
    }
  }

  // ========== QUICK ACTIONS ==========

  /// Ações rápidas para o chat
  Future<void> handleQuickAction({
    required String sessionId,
    required QuickActionType action,
    Map<String, dynamic>? params,
  }) async {
    switch (action) {
      case QuickActionType.analyzeStyle:
        if (params?['imageFile'] != null) {
          await analyzeHairstyle(imageFile: params!['imageFile'], sessionId: sessionId);
        }
        break;

      case QuickActionType.recommendBarbershops:
        await recommendBarbershops(
          location: params?['location'] ?? 'minha localização',
          style: params?['style'],
          budget: params?['budget'],
          sessionId: sessionId,
        );
        break;

      case QuickActionType.hairCareTips:
        await getHairCareTips(hairType: params?['hairType'], concern: params?['concern'], sessionId: sessionId);
        break;

      case QuickActionType.trendingStyles:
        await sendMessage(sessionId: sessionId, message: 'Quais são os cortes de cabelo em alta agora?');
        break;

      case QuickActionType.chooseBarbershop:
        await sendMessage(sessionId: sessionId, message: 'Como escolher uma boa barbearia?');
        break;
    }
  }
}

/// Tipos de ação rápida no chat
enum QuickActionType { analyzeStyle, recommendBarbershops, hairCareTips, trendingStyles, chooseBarbershop, bookingHelp }
