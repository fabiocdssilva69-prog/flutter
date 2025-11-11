import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/logger_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../domain/entities/ai/chat_message.dart';
import '../abstractions/ai_persona.dart';
import '../personas/artistic_chatbot_persona.dart';
import '../personas/business_consultant_persona.dart';
import '../personas/writing_assistant_persona.dart';
import 'chat_state.dart'; // Importa o novo estado

part 'chat_controller.g.dart';

const _uuid = Uuid();

/// Provedor auxiliar que mapeia o 'personaKey' (String) para a implementação real de AiPersona.
///
/// Persona Keys disponíveis:
/// - 'business' → BusinessConsultantPersona
/// - 'artistic' → ArtisticChatbotPersona
/// - 'writing' → WritingAssistantPersona
///
/// Provedor auxiliar agora também é assíncrono (FutureProvider).
@riverpod
Future<AiPersona> aiPersona(ref, String personaKey) async {
  switch (personaKey) {
    case 'business':
      // Aguarda o provedor da persona
      return await ref.watch(businessConsultantPersonaProvider);
    case 'artistic':
      return await ref.watch(artisticChatbotPersonaProvider);
    case 'writing':
      return await ref.watch(writingAssistantPersonaProvider);
    default:
      throw Exception('Persona de IA desconhecida: $personaKey');
  }
}

/// O Controlador principal do Chat Unificado usando arquitetura de AsyncNotifier.
///
/// **SPRINT 10 - Mudanças Arquiteturais:**
/// - Migração de StreamNotifier → AsyncNotifier para controle imperativo de paginação
/// - Estado gerenciado via ChatStateData (messages, hasMore, isLoadingMore)
/// - Paginação cursor-based com 30 mensagens por página
/// - Sistema de feedback (Like/Dislike) integrado
/// - Atualização otimista da UI (UX aprimorada)
///
/// **Características:**
/// - Usa `family` para manter estados de chat separados por persona
/// - Paginação eficiente com fetchInitialMessages() e fetchMoreMessages()
/// - Persistência automática de mensagens
/// - Analytics integrado para todas as interações
/// - Separação entre estado dos dados (ChatStateData) e estado da ação (isAwaitingResponse)
///
/// **Uso:**
/// ```dart
/// final chatState = ref.watch(chatControllerProvider('artistic'));
/// ref.read(chatControllerProvider('artistic').notifier).sendMessage('Olá!');
/// ref.read(chatControllerProvider('artistic').notifier).loadMore();
/// final isLoading = ref.read(chatControllerProvider('artistic').notifier).isAwaitingResponse;
/// ```
@riverpod
class ChatController extends _$ChatController {
  late AiPersona _persona;
  late ChatRepository _chatRepository;
  late LoggerService _logger;
  String? _userId;
  late String _personaKey; // Armazena o personaKey para uso nos métodos

  // Flag interna para gerenciar o estado de "esperando resposta da IA" (Estado da Ação).
  // Isso é separado do estado do ChatStateData (Estado dos Dados).
  bool _isAwaitingResponse = false;
  bool get isAwaitingResponse => _isAwaitingResponse;

  @override
  // O build já era assíncrono (Future<ChatStateData>)
  Future<ChatStateData> build(String personaKey) async {
    // Armazena o personaKey para uso em outros métodos
    _personaKey = personaKey;

    // (Inicialização das dependências existentes)
    _chatRepository = ref.watch(chatRepositoryProvider);
    _logger = ref.watch(loggerServiceProvider);
    _userId = ref.watch(authRepositoryProvider).currentUser?.uid;

    if (_userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    // Inicializa a persona. Se a chave de API for inválida (AiService falhou),
    // isso lançará uma exceção e o ChatController entrará em estado de erro.
    _persona = await ref.read(aiPersonaProvider(personaKey).future);

    _logger.logEvent('Chat_Opened', parameters: {'persona': personaKey});

    // (Carregamento da página inicial existente)
    final initialMessages = await _chatRepository.fetchInitialMessages(_userId!, personaKey);
    final hasMore = initialMessages.length == ChatRepository.pageSize;

    return ChatStateData(messages: initialMessages, hasMore: hasMore);
  }

  /// Carrega mais mensagens antigas (Paginação)
  ///
  /// **Uso:** Chamado quando o usuário scrolla para o topo da lista.
  ///
  /// **Fluxo:**
  /// 1. Valida estado (não carrega se já estiver carregando ou sem mais mensagens)
  /// 2. Define isLoadingMore como true
  /// 3. Busca próximas 30 mensagens usando cursor (timestamp da mensagem mais antiga)
  /// 4. Atualiza estado com novas mensagens (prepend)
  /// 5. Atualiza hasMore baseado no tamanho da resposta
  Future<void> loadMore() async {
    if (_userId == null || state.isLoading || !state.hasValue) return;

    final currentState = state.value!;
    if (!currentState.hasMore || currentState.isLoadingMore || currentState.messages.isEmpty) return;

    _logger.logEvent('Chat_LoadMore', parameters: {'persona': _personaKey});

    // Define o estado isLoadingMore como true
    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      // Pega o timestamp da mensagem mais antiga (primeira da lista) como cursor
      final cursor = currentState.messages.first.timestamp;
      final moreMessages = await _chatRepository.fetchMoreMessages(_userId!, _personaKey, cursor);

      // Atualiza o estado com as novas mensagens (inseridas no início) e o novo status de hasMore
      state = AsyncData(
        currentState.copyWith(
          messages: [...moreMessages, ...currentState.messages],
          hasMore: moreMessages.length == ChatRepository.pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e, stack) {
      _logger.logError(e, stack, context: 'ChatController.loadMore failed');
      // Se falhar, mantém o estado anterior e marca isLoadingMore como false
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Envia mensagem do usuário e obtém resposta da IA
  ///
  /// **SPRINT 10 - Atualização Otimista:**
  /// - Adiciona mensagem do usuário na UI imediatamente (UX responsiva)
  /// - Salva no Firestore em background (sem await para não bloquear UI)
  /// - Adiciona resposta da IA na UI imediatamente após receber
  /// - Salva resposta da IA em background
  ///
  /// **Fluxo:**
  /// 1. Valida estado e cria mensagem do usuário
  /// 2. **Atualização Otimista:** Adiciona mensagem na UI imediatamente
  /// 3. Salva mensagem do usuário no Firestore (background)
  /// 4. Chama a IA com histórico completo (incluindo mensagem otimista)
  /// 5. **Atualização Otimista:** Adiciona resposta da IA na UI imediatamente
  /// 6. Salva resposta da IA no Firestore (background)
  /// 7. Registra analytics (duração, sucesso/falha)
  Future<void> sendMessage(String content) async {
    if (_isAwaitingResponse || content.trim().isEmpty || _userId == null || !state.hasValue) return;

    _setLoading(true);
    final stopwatch = Stopwatch()..start();
    final currentState = state.value!;

    // 1. Prepara a mensagem do usuário
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: content.trim(),
      timestamp: DateTime.now(),
    );

    // 2. Atualização Otimista da UI
    state = AsyncData(currentState.copyWith(messages: [...currentState.messages, userMessage]));

    // 3. Salva no Repositório (Background - sem await)
    unawaited(
      _chatRepository.saveMessage(_userId!, _personaKey, userMessage).catchError((e, stack) {
        _logger.logError(e, stack, context: 'Failed to save user message optimistically');
        // TODO: Reverter a UI ou marcar a mensagem como não enviada se falhar.
      }),
    );

    // 4. Chama a IA
    bool success = false;
    try {
      // O histórico para a IA é o estado atualizado (inclui a mensagem otimista)
      final historyForAI = state.value!.messages;

      final responseContent = await _persona.getResponse(historyForAI);

      // 5. Prepara e Atualiza a UI com a resposta da IA
      final aiMessage = ChatMessage(
        id: _uuid.v4(),
        role: MessageRole.assistant,
        content: responseContent,
        timestamp: DateTime.now(),
      );

      state = AsyncData(state.value!.copyWith(messages: [...state.value!.messages, aiMessage]));

      // 6. Salva a resposta da IA no Repositório (Background)
      unawaited(_chatRepository.saveMessage(_userId!, _personaKey, aiMessage));
      success = true;
    } catch (e, stack) {
      // 7. Tratamento de Erro
      _handleError(e, stack, 'AI processing error');
    } finally {
      // 8. Finalização e Analytics
      stopwatch.stop();
      _logger.logAiInteraction(persona: _personaKey, duration: stopwatch.elapsed, success: success);
      _setLoading(false);
    }
  }

  /// Atualiza o feedback de uma mensagem (Like/Dislike)
  ///
  /// **SPRINT 10 - Sistema de Feedback:**
  /// - Suporta toggle: clicar no mesmo feedback novamente remove-o
  /// - Atualização otimista da UI (resposta imediata)
  /// - Salva no Firestore em background
  ///
  /// **Uso:**
  /// ```dart
  /// ref.read(chatControllerProvider('artistic').notifier)
  ///   .updateFeedback(messageId, MessageFeedback.thumbsUp);
  /// ```
  ///
  /// **Fluxo:**
  /// 1. Atualização Otimista da UI com lógica de toggle
  /// 2. Determina feedback final (após toggle)
  /// 3. Salva no Firestore (background)
  /// 4. Registra analytics
  Future<void> updateFeedback(String messageId, MessageFeedback feedback) async {
    if (_userId == null || !state.hasValue) return;

    final currentState = state.value!;

    // 1. Atualização Otimista da UI (com lógica de Toggle)
    final updatedMessages = currentState.messages.map((msg) {
      if (msg.id == messageId) {
        // Se o usuário clicar no mesmo feedback novamente, remove-o (toggle)
        return msg.copyWith(feedback: msg.feedback == feedback ? MessageFeedback.none : feedback);
      }
      return msg;
    }).toList();

    state = AsyncData(currentState.copyWith(messages: updatedMessages));

    // Pega o feedback final (após o toggle) para salvar no banco
    final finalFeedback = updatedMessages.firstWhere((msg) => msg.id == messageId).feedback;

    // 2. Salva no Repositório (Background)
    _logger.logEvent('Chat_Feedback', parameters: {'persona': _personaKey, 'feedback': finalFeedback.name});
    unawaited(
      _chatRepository.updateMessageFeedback(_userId!, _personaKey, messageId, finalFeedback).catchError((e, stack) {
        _logger.logError(e, stack, context: 'Failed to update feedback');
        // TODO (Futuro): Reverter a UI se a atualização falhar
      }),
    );
  }

  /// Limpa todo o histórico de conversação (remove todas as mensagens do Firestore)
  ///
  /// **SPRINT 10 - Clear History:**
  /// - Usa WriteBatch do Firestore para delete eficiente
  /// - Mantém estado anterior visível durante carregamento (boa UX)
  /// - Define estado vazio após sucesso
  ///
  /// **Retorno:** true se sucesso, false se falhar
  ///
  /// **Uso:**
  /// ```dart
  /// final success = await ref.read(chatControllerProvider('business').notifier).clearHistory();
  /// if (success) {
  ///   ScaffoldMessenger.of(context).showSnackBar(
  ///     SnackBar(content: Text('Histórico limpo com sucesso!')),
  ///   );
  /// }
  /// ```
  Future<bool> clearHistory() async {
    if (_userId == null || state.isLoading) return false;

    _logger.logEvent('Chat_HistoryCleared', parameters: {'persona': _personaKey});

    // Define o estado como Loading
    state = const AsyncLoading<ChatStateData>();

    try {
      await _chatRepository.clearChatHistory(_userId!, _personaKey);
      // Define o estado como vazio após a limpeza
      state = AsyncData(ChatStateData(messages: [], hasMore: false));
      return true;
    } catch (e, stack) {
      // Se falhar, mantém o estado atual e loga o erro
      state = AsyncError<ChatStateData>(e, stack);
      _logger.logError(e, stack, context: 'Failed to clear chat history');
      return false;
    }
  }

  // Método auxiliar para definir o estado de loading da Ação
  void _setLoading(bool isLoading) {
    _isAwaitingResponse = isLoading;
  }

  // Método auxiliar para lidar com erros
  void _handleError(dynamic e, StackTrace stack, String context) {
    _logger.logError(e, stack, context: 'ChatController.$context');

    // Se for erro da IA, adiciona a mensagem de erro ao chat
    if (_userId == null || !state.hasValue) return;

    final errorMessage = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.assistant,
      content: 'Desculpe, ocorreu um erro. Tente novamente. Detalhes: ${e.toString()}',
      timestamp: DateTime.now(),
      isError: true,
    );

    state = AsyncData(state.value!.copyWith(messages: [...state.value!.messages, errorMessage]));

    // Tenta salvar a mensagem de erro no repositório (Background)
    unawaited(
      _chatRepository.saveMessage(_userId!, _personaKey, errorMessage).catchError((e, s) {
        _logger.logError(e, s, context: 'Failed to save error message');
      }),
    );
  }

  /// Retorna quantidade de mensagens no histórico
  int get messageCount => state.value?.messages.length ?? 0;
}
