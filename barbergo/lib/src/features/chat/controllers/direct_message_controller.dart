import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/logger_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/chat_room_repository.dart';
import '../../../domain/entities/chat/chat_room_entity.dart';
import '../../../domain/entities/chat/direct_message_entity.dart';
import 'direct_message_state.dart';

part 'direct_message_controller.g.dart';

const _uuid = Uuid();

// Controlador para as mensagens dentro de uma sala. Usamos AsyncNotifier para paginação.
// Usamos 'family' para ter um estado separado por sala.
@riverpod
class DirectMessageController extends _$DirectMessageController {
  late ChatRoomRepository _repository;
  late LoggerService _logger;
  String? _userId;
  late ChatRoomEntity _room; // Armazena a entidade da sala

  // Flag para estado de "enviando mensagem" (Estado da Ação).
  bool _isSending = false;
  bool get isSending => _isSending;

  @override
  // O build recebe o ChatRoomEntity completo como argumento (passado via GoRouter extra).
  Future<DirectMessageState> build(ChatRoomEntity room) async {
    _repository = ref.watch(chatRoomRepositoryProvider);
    _logger = ref.watch(loggerServiceProvider);
    _userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    _room = room;

    if (_userId == null) throw Exception("Usuário não autenticado.");

    _logger.logEvent("DirectChat_Opened", parameters: {"roomId": room.roomId});

    // Marca como lido ao entrar (em background)
    _markAsRead();

    // Carrega a página inicial
    final initialMessages = await _repository.fetchInitialMessages(room.roomId);
    final hasMore = initialMessages.length == ChatRoomRepository.pageSize;

    return DirectMessageState(messages: initialMessages, hasMore: hasMore);
  }

  // Método para carregar mais mensagens (Paginação)
  Future<void> loadMore() async {
    if (_userId == null || state.isLoading || !state.hasValue) return;

    final currentState = state.value!;
    if (!currentState.hasMore || currentState.isLoadingMore || currentState.messages.isEmpty) {
      return;
    }

    // Define isLoadingMore como true
    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      // Pega o timestamp da mensagem mais antiga (primeira da lista) como cursor
      final cursor = currentState.messages.first.timestamp;
      final moreMessages = await _repository.fetchMoreMessages(_room.roomId, cursor);

      // Atualiza o estado
      if (ref.mounted) {
        state = AsyncData(
          currentState.copyWith(
            messages: [...moreMessages, ...currentState.messages],
            hasMore: moreMessages.length == ChatRoomRepository.pageSize,
            isLoadingMore: false,
          ),
        );
      }
    } catch (e, stack) {
      _logger.logError(e, stack, context: "DirectMessageController.loadMore failed");
      if (ref.mounted) {
        state = AsyncError<DirectMessageState>(e, stack);
        if (state.hasValue) {
          state = AsyncData(state.value!.copyWith(isLoadingMore: false));
        }
      }
    }
  }

  // Método para enviar mensagem (com Atualização Otimista)
  Future<void> sendMessage(String content) async {
    if (_isSending || content.trim().isEmpty || _userId == null || !state.hasValue) return;

    _setLoading(true);
    final currentState = state.value!;

    // 1. Prepara a mensagem (isSent: false inicialmente)
    final message = DirectMessageEntity(
      messageId: _uuid.v4(),
      senderId: _userId!,
      content: content.trim(),
      timestamp: DateTime.now(),
      isSent: false,
    );

    // 2. Atualização Otimista da UI
    state = AsyncData(currentState.copyWith(messages: [...currentState.messages, message]));

    // 3. Envia para o Repositório
    try {
      // O repositório salva a mensagem, atualiza a sala e incrementa contadores atomicamente.
      // Passamos os IDs dos participantes para a lógica de incremento.
      await _repository.sendMessage(_room.roomId, message, _room.participantIds);

      // 4. Confirmação de envio na UI (Atualiza isSent para true)
      if (ref.mounted) {
        final updatedMessages = state.value!.messages.map((m) {
          return m.messageId == message.messageId ? m.copyWith(isSent: true) : m;
        }).toList();
        state = AsyncData(state.value!.copyWith(messages: updatedMessages));
      }
      _logger.logEvent("DirectChat_MessageSent", parameters: {"roomId": _room.roomId});
    } catch (e, stack) {
      _logger.logError(e, stack, context: "Failed to send direct message");
      // TODO: Implementar rollback ou marcar a mensagem como falha na UI.
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool isLoading) {
    _isSending = isLoading;
    if (ref.mounted) {
      ref.notifyListeners(); // Notifica a UI sobre a mudança no estado da Ação
    }
  }

  // Marca como lido se houver mensagens não lidas para o usuário atual
  void _markAsRead() {
    if (_userId != null && (_room.unreadCounts[_userId!] ?? 0) > 0) {
      unawaited(
        _repository.markAsRead(_room.roomId, _userId!).catchError((e, stack) {
          _logger.logError(e, stack, context: "Failed to mark room as read");
        }),
      );
    }
  }
}
