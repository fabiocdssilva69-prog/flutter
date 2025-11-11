import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/async_value_ui.dart'; // Importar utilitário de erro
import '../../../domain/entities/ai/chat_message.dart';
import '../controllers/chat_controller.dart';
import '../controllers/chat_state.dart'; // Importar o novo estado

class GenericChatScreen extends ConsumerStatefulWidget {
  final String title;
  final String personaDescription;
  final String personaKey;
  final List<String> suggestedPrompts;

  const GenericChatScreen({
    super.key,
    required this.title,
    required this.personaDescription,
    required this.personaKey,
    this.suggestedPrompts = const [],
  });

  @override
  ConsumerState<GenericChatScreen> createState() => _GenericChatScreenState();
}

class _GenericChatScreenState extends ConsumerState<GenericChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Adiciona o listener para detectar quando o usuário rola para o topo
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Lógica de Paginação (Load More)
  void _scrollListener() {
    // Verifica se o usuário rolou próximo ao topo (início da lista)
    if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent + 100) {
      // Chama o método loadMore no controlador (ele gerencia se deve ou não carregar)
      ref.read(chatControllerProvider(widget.personaKey).notifier).loadMore();
    }
  }

  // Método unificado para enviar mensagens (do input ou sugestões)
  Future<void> _sendMessage({String? content}) async {
    final text = content ?? _textController.text.trim();
    if (text.isEmpty) return;

    final notifier = ref.read(chatControllerProvider(widget.personaKey).notifier);
    if (notifier.isAwaitingResponse) return;

    if (content == null) {
      _textController.clear();
    }

    notifier.sendMessage(text);
  }

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

  // Método para limpar o histórico com confirmação
  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar Histórico"),
        content: const Text("Tem certeza que deseja apagar toda a conversa? Esta ação não pode ser desfeita."),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancelar")),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Apagar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref.read(chatControllerProvider(widget.personaKey).notifier).clearHistory();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Histórico apagado com sucesso.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = chatControllerProvider(widget.personaKey);

    // 1. Observa o estado principal (Dados - AsyncValue<ChatStateData>)
    final chatState = ref.watch(provider);

    // 2. Observa o estado do Notifier (Ação Loading - bool)
    final isLoadingAction = ref.watch(provider.notifier).isAwaitingResponse;

    // Listener para mostrar erros gerais (ex: falha ao limpar histórico ou carregar mais)
    ref.listen<AsyncValue<ChatStateData>>(provider, (_, state) {
      // Mostra AlertDialog se houver erro e não for um erro durante o loading inicial
      if (!state.isLoading) {
        state.showAlertDialogOnError(context);
      }
    });

    // Listener para scroll (Lógica complexa para evitar scroll indesejado durante a paginação)
    ref.listen<AsyncValue<ChatStateData>>(provider, (previous, next) {
      if (next.hasValue && previous?.hasValue == true) {
        final previousMessages = previous!.value!.messages;
        final nextMessages = next.value!.messages;
        // Só rola se a última mensagem mudou (nova mensagem enviada/recebida) e se a lista não estiver vazia
        if (nextMessages.isNotEmpty && (previousMessages.isEmpty || previousMessages.last.id != nextMessages.last.id)) {
          _scrollToBottom();
        }
      } else if (next.hasValue && (previous == null || !previous.hasValue)) {
        // Scroll no carregamento inicial
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Botão de Limpar Histórico
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: "Limpar Histórico",
            onPressed: (isLoadingAction || chatState.isLoading) ? null : _clearHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          // Área de Chat (Gerenciada pelo .when)
          Expanded(
            child: chatState.when(
              data: (data) {
                if (data.messages.isEmpty) {
                  return _buildInitialView(isLoadingAction);
                }
                return _buildChatList(data);
              },
              // Loading inicial
              loading: () => const Center(child: CircularProgressIndicator()),
              // Erro inicial (Ex: autenticação)
              error: (e, s) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Erro ao carregar o chat: $e", textAlign: TextAlign.center),
                ),
              ),
            ),
          ),

          // Indicador de "Digitando..."
          if (isLoadingAction && chatState.hasValue && chatState.value!.messages.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("A IA está processando...", style: TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
          // Área de Input
          _buildInputArea(isLoadingAction || chatState.isLoading),
        ],
      ),
    );
  }

  // Widget para a lista de chat com suporte a paginação
  Widget _buildChatList(ChatStateData data) {
    // O itemCount inclui um slot extra para o spinner de paginação se estiver carregando mais.
    final itemCount = data.messages.length + (data.isLoadingMore ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Se estiver carregando mais E for o primeiro item (topo), mostra o spinner
        if (data.isLoadingMore && index == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
          );
        }

        // Ajusta o índice para buscar a mensagem correta (descontando o spinner se presente)
        final messageIndex = index - (data.isLoadingMore ? 1 : 0);
        final message = data.messages[messageIndex];

        // Passa o notifier para o ChatBubble para ações de feedback
        final notifier = ref.read(chatControllerProvider(widget.personaKey).notifier);

        return ChatBubble(message: message, onFeedback: (feedback) => notifier.updateFeedback(message.id, feedback));
      },
    );
  }

  // Visualização inicial com descrição e sugestões
  Widget _buildInitialView(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.personaDescription, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 32),
          if (widget.suggestedPrompts.isNotEmpty) ...[
            Text("Tente uma dessas sugestões:", style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.center,
              children: widget.suggestedPrompts.map((prompt) {
                return ActionChip(
                  label: Text(prompt, maxLines: 2, overflow: TextOverflow.ellipsis),
                  avatar: const Icon(Icons.bolt_outlined, size: 16),
                  onPressed: isLoading ? null : () => _sendMessage(content: prompt),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

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
                hintText: "Digite sua mensagem...",
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
            icon: const Icon(Icons.send),
            onPressed: isLoading ? null : () => _sendMessage(),
            style: IconButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// Widget ChatBubble atualizado com Markdown e Feedback
// Widget ChatBubble atualizado com Feedback UI
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  // Callback para enviar o feedback ao controlador
  final Function(MessageFeedback feedback)? onFeedback;

  const ChatBubble({super.key, required this.message, this.onFeedback});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    // Ajustamos o alinhamento da coluna para alinhar o balão e os botões corretamente
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    // Cores (mesma lógica da Sprint 9)
    Color color = isUser
        ? AppColors.primary
        : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[300]!);
    if (message.isError) color = Colors.red[700]!;
    final textColor = (isUser || message.isError)
        ? Colors.white
        : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black);

    // Estilo Markdown (mesma lógica da Sprint 9)
    final markdownStyleSheet = MarkdownStyleSheet(
      p: TextStyle(color: textColor, fontSize: 14.0),
      listBullet: TextStyle(color: textColor, fontSize: 14.0),
      strong: const TextStyle(fontWeight: FontWeight.bold),
      code: TextStyle(backgroundColor: Colors.black.withOpacity(0.1), fontFamily: 'monospace', color: textColor),
      codeblockDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );

    // O Widget principal agora é uma Coluna para acomodar o balão e o feedback abaixo
    return Padding(
      // Adiciona padding extra na parte inferior para espaçamento
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          // O Balão (Container)
          Align(
            // Alinha o container dentro da coluna
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15.0)),
              child: MarkdownBody(data: message.content, styleSheet: markdownStyleSheet, selectable: true),
            ),
          ),
          // Ações de Feedback (Apenas para IA, não erros e se o callback estiver presente)
          if (!isUser && !message.isError && onFeedback != null) _buildFeedbackActions(context),
        ],
      ),
    );
  }

  Widget _buildFeedbackActions(BuildContext context) {
    // Cores para os ícones de feedback
    final Color defaultColor = Colors.grey[500]!;
    final Color activeColor = AppColors.primary;

    return Padding(
      // Padding ajustado para alinhar com o balão
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thumbs Up
          InkWell(
            onTap: () => onFeedback!(MessageFeedback.thumbsUp),
            borderRadius: BorderRadius.circular(15.0),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                // Usa o ícone preenchido se estiver ativo (Toggle)
                message.feedback == MessageFeedback.thumbsUp ? Icons.thumb_up : Icons.thumb_up_outlined,
                size: 16.0,
                color: message.feedback == MessageFeedback.thumbsUp ? activeColor : defaultColor,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          // Thumbs Down
          InkWell(
            onTap: () => onFeedback!(MessageFeedback.thumbsDown),
            borderRadius: BorderRadius.circular(15.0),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                message.feedback == MessageFeedback.thumbsDown ? Icons.thumb_down : Icons.thumb_down_outlined,
                size: 16.0,
                color: message.feedback == MessageFeedback.thumbsDown ? activeColor : defaultColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
