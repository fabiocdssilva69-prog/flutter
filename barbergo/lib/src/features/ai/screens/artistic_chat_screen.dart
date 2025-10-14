import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/ai/chat_message.dart';
import '../controllers/artistic_chat_controller.dart';

/// Tela de chat com IA sobre o mundo artístico de cabelos e barbas
///
/// Features:
/// - Chat em tempo real com IA
/// - Suporte a Markdown nas respostas
/// - Sugestões de perguntas iniciais
/// - Auto-scroll ao receber mensagens
/// - Visual moderno e responsivo
class ArtisticChatScreen extends ConsumerStatefulWidget {
  const ArtisticChatScreen({super.key});

  @override
  ConsumerState<ArtisticChatScreen> createState() => _ArtisticChatScreenState();
}

class _ArtisticChatScreenState extends ConsumerState<ArtisticChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Auto-scroll para o final quando novas mensagens chegam
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  /// Envia mensagem do usuário
  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    ref.read(artisticChatControllerProvider.notifier).sendMessage(content);
    _messageController.clear();
    _scrollToBottom();
  }

  /// Envia uma pergunta sugerida
  void _sendSuggestedPrompt(String prompt) {
    ref.read(artisticChatControllerProvider.notifier).sendMessage(prompt);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(artisticChatControllerProvider);
    final messages = chatState.value ?? [];
    final isLoading = chatState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💬 Chat Artístico',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Converse sobre técnicas e arte',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: messages.isEmpty
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Limpar Chat'),
                        content: const Text(
                          'Deseja limpar todo o histórico de conversa?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () {
                              ref
                                  .read(artisticChatControllerProvider.notifier)
                                  .clearChat();
                              Navigator.pop(context);
                            },
                            child: const Text('Limpar'),
                          ),
                        ],
                      ),
                    );
                  },
            tooltip: 'Limpar chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Área de mensagens
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : _buildMessageList(messages),
          ),

          // Indicador de "digitando..." quando IA está processando
          if (isLoading && messages.isNotEmpty) _buildTypingIndicator(),

          // Campo de input
          _buildInputField(),
        ],
      ),
    );
  }

  /// Estado vazio com sugestões
  Widget _buildEmptyState() {
    final suggestions = [
      '🎨 Quais são as técnicas de fade mais populares?',
      '✂️ Como fazer um degradê perfeito?',
      '📈 Quais são as tendências atuais de cortes?',
      '🧔 Dicas para cuidar de barba volumosa',
      '💡 História da barbearia tradicional',
      '🎯 Diferença entre pomada e cera',
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone e título
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.1 * 255),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Seu Mentor Artístico',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Converse sobre técnicas, tendências e o mundo artístico da barbearia',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Sugestões
            Text(
              'Perguntas sugeridas:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: suggestions.map((suggestion) {
                return ActionChip(
                  label: Text(suggestion, style: const TextStyle(fontSize: 12)),
                  onPressed: () => _sendSuggestedPrompt(suggestion),
                  avatar: const Icon(Icons.lightbulb_outline, size: 16),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Lista de mensagens
  Widget _buildMessageList(List<ChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  /// Bubble individual de mensagem
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final isError = message.isError;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Bubble
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isError
                    ? Colors.red[100]
                    : isUser
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : null,
                  bottomLeft: !isUser ? const Radius.circular(4) : null,
                ),
              ),
              child: isUser
                  ? Text(
                      message.content,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    )
                  : MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: isError ? Colors.red[900] : Colors.black87,
                          fontSize: 15,
                        ),
                        code: TextStyle(
                          backgroundColor: Colors.grey[300],
                          color: Colors.black87,
                        ),
                      ),
                    ),
            ),
            // Timestamp
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                DateFormat('HH:mm').format(message.createdAt),
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Indicador de "digitando..."
  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.grey[600]),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'IA está pensando...',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Campo de input de mensagem
  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05 * 255),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Digite sua pergunta...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
