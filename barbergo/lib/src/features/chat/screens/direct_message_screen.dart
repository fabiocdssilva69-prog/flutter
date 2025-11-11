import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/async_value_ui.dart';
import '../../../core/utils/l10n_helper.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/chat/chat_room_entity.dart';
import '../../../domain/entities/chat/direct_message_entity.dart';
import '../controllers/direct_message_controller.dart';
import '../controllers/direct_message_state.dart';

class DirectMessageScreen extends ConsumerStatefulWidget {
  // Recebe o objeto Room completo
  final ChatRoomEntity room;

  const DirectMessageScreen({super.key, required this.room});

  @override
  ConsumerState<DirectMessageScreen> createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends ConsumerState<DirectMessageScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  String? _currentUserId;
  String? _otherUserName;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Define o usuário atual e o nome do outro participante
    _currentUserId = ref.read(authRepositoryProvider).currentUser?.uid;
    _otherUserName = widget.room.participants.entries
        .firstWhere(
          (entry) => entry.key != _currentUserId,
          orElse: () => MapEntry('id', ParticipantInfo(userId: 'id', name: 'Chat')),
        )
        .value
        .name;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Lógica de Paginação (Load More ao rolar para o topo)
  void _scrollListener() {
    if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent + 100) {
      // Chama o notifier passando o objeto Room como argumento do family
      ref.read(directMessageControllerProvider(widget.room).notifier).loadMore();
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final notifier = ref.read(directMessageControllerProvider(widget.room).notifier);
    if (notifier.isSending) return;

    _textController.clear();
    notifier.sendMessage(text);
  }

  // Método auxiliar para scroll automático
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _scrollController.position.hasContentDimensions) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // O provider agora recebe o objeto Room completo
    final provider = directMessageControllerProvider(widget.room);
    final chatState = ref.watch(provider);
    final isSending = ref.watch(provider.notifier).isSending;

    // Listener para erros (ex: falha na paginação)
    ref.listen(provider, (_, state) => state.showAlertDialogOnError(context));

    // Listener para scroll (Lógica complexa para evitar scroll indesejado durante a paginação)
    ref.listen<AsyncValue<DirectMessageState>>(provider, (previous, next) {
      if (next.hasValue && previous?.hasValue == true) {
        final previousMessages = previous!.value!.messages;
        final nextMessages = next.value!.messages;
        // Só rola se a última mensagem mudou (nova mensagem enviada/recebida)
        if (nextMessages.isNotEmpty &&
            (previousMessages.isEmpty || previousMessages.last.messageId != nextMessages.last.messageId)) {
          _scrollToBottom();
        }
      } else if (next.hasValue && (previous == null || !previous.hasValue)) {
        // Scroll no carregamento inicial
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(_otherUserName ?? "Chat")),
      body: Column(
        children: [
          Expanded(
            child: chatState.when(
              data: (data) => _buildChatList(data, _currentUserId),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text("Erro ao carregar chat: $e")),
            ),
          ),
          _buildInputArea(isSending || chatState.isLoading),
        ],
      ),
    );
  }

  Widget _buildChatList(DirectMessageState data, String? currentUserId) {
    if (currentUserId == null) return const Center(child: Text("Erro de autenticação."));
    if (data.messages.isEmpty) return const Center(child: Text("Inicie a conversa!"));

    // Inclui slot para o spinner de paginação
    final itemCount = data.messages.length + (data.isLoadingMore ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Spinner no topo se estiver carregando mais
        if (data.isLoadingMore && index == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
          );
        }

        final messageIndex = index - (data.isLoadingMore ? 1 : 0);
        final message = data.messages[messageIndex];

        return DirectMessageBubble(message: message, isMe: message.senderId == currentUserId);
      },
    );
  }

  // (Método _buildInputArea - Reutilizando UI padrão)
  Widget _buildInputArea(bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: context.l10n.typeMessageHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              enabled: !isLoading,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton.filled(
            // Mostra spinner se estiver enviando (Ação do usuário) e não for o loading inicial do estado.
            icon: (isLoading && ref.watch(directMessageControllerProvider(widget.room).notifier).isSending)
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send),
            onPressed: isLoading ? null : _sendMessage,
            style: IconButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// Widget DirectMessageBubble (com indicador otimista)
class DirectMessageBubble extends StatelessWidget {
  final DirectMessageEntity message;
  final bool isMe;

  const DirectMessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    Color color = isMe
        ? AppColors.primary
        : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[300]!);
    final textColor = isMe
        ? Colors.white
        : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black);

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15.0)),
        // Usamos Row para acomodar o texto e o indicador de status
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(message.content, style: TextStyle(color: textColor)),
            ),
            const SizedBox(width: 8),
            // Indicador de status de envio (Otimista)
            if (isMe)
              Icon(
                message.isSent ? Icons.check_circle_outline : Icons.access_time,
                size: 12,
                color: textColor.withOpacity(0.7),
              ),
          ],
        ),
      ),
    );
  }
}
