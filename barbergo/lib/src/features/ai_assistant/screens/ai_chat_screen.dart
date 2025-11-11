import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/ai_controller.dart';
import '../widgets/ai_chat_input.dart';
import '../widgets/ai_message_bubble.dart';
import '../widgets/quick_actions_bar.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String title;

  const AiChatScreen({super.key, required this.sessionId, required this.title});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() => _isLoading = true);
    _textController.clear();

    // Scroll para o final
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final success = await ref
        .read(aiControllerProvider.notifier)
        .sendMessage(sessionId: widget.sessionId, message: message);

    setState(() => _isLoading = false);

    if (!success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao enviar mensagem'), backgroundColor: Colors.red));
    }

    // Scroll após resposta
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _handleQuickAction(QuickActionType action) async {
    setState(() => _isLoading = true);

    await ref.read(aiControllerProvider.notifier).handleQuickAction(sessionId: widget.sessionId, action: action);

    setState(() => _isLoading = false);

    // Scroll após ação
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.sessionId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            const Text('Assistente IA', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick actions bar
          QuickActionsBar(onActionSelected: _handleQuickAction, isLoading: _isLoading),

          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      // Loading indicator
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final message = messages[index];
                    return AiMessageBubble(
                      message: message,
                      showAvatar: index == 0 || messages[index - 1].isUserMessage != message.isUserMessage,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Erro ao carregar mensagens'),
                    const SizedBox(height: 8),
                    Text(error.toString(), style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),

          // Chat input
          AiChatInput(
            controller: _textController,
            onSend: () => _sendMessage(_textController.text),
            isLoading: _isLoading,
            onImagePicked: (imageFile) async {
              setState(() => _isLoading = true);

              await ref
                  .read(aiControllerProvider.notifier)
                  .analyzeHairstyle(imageFile: imageFile, sessionId: widget.sessionId);

              setState(() => _isLoading = false);

              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome, size: 60, color: Colors.purple),
            ),
            const SizedBox(height: 24),
            Text(
              'Olá! Sou seu assistente de estilo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Posso te ajudar com:\n\n'
              '✂️ Sugestões de cortes\n'
              '📸 Análise de fotos\n'
              '🏪 Recomendações de barbearias\n'
              '💡 Dicas de cuidados',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text(
              'Comece perguntando algo ou use as ações rápidas acima!',
              style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),

              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Deletar conversa', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Sobre o assistente'),
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancelar'),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deletar conversa?'),
          content: const Text('Esta ação não pode ser desfeita. Todas as mensagens serão perdidas.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                final success = await ref.read(aiControllerProvider.notifier).deleteChatSession(widget.sessionId);

                if (mounted) {
                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Conversa deletada'), backgroundColor: Colors.green));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Erro ao deletar conversa'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purple),
              SizedBox(width: 8),
              Text('Assistente IA'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Powered by Google Gemini', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text(
                'Este assistente usa inteligência artificial para:\n\n'
                '• Analisar fotos de cortes\n'
                '• Sugerir estilos personalizados\n'
                '• Recomendar barbearias\n'
                '• Dar dicas de cuidados capilares\n\n'
                'As respostas são geradas por IA e podem não ser 100% precisas.',
              ),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))],
        );
      },
    );
  }
}
