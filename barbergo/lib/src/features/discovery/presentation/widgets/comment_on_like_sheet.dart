import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/profile_entity.dart';
import '../controllers/swipe_controller.dart';

/// Bottom sheet para adicionar comentário ao dar like (Phase 1)
class CommentOnLikeSheet extends ConsumerStatefulWidget {
  final ProfileEntity targetProfile;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const CommentOnLikeSheet({
    super.key,
    required this.targetProfile,
    required this.onCancel,
    required this.onSuccess,
  });

  @override
  ConsumerState<CommentOnLikeSheet> createState() => _CommentOnLikeSheetState();
}

class _CommentOnLikeSheetState extends ConsumerState<CommentOnLikeSheet> {
  final _commentController = TextEditingController();
  String? _selectedPromptId;
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendLikeWithComment() async {
    final comment = _commentController.text.trim();

    // Validar comentário
    if (comment.isEmpty || comment.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O comentário deve ter no mínimo 10 caracteres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Criar swipe com comentário
      final swipeRepo = ref.read(swipeRepositoryProvider);
      final currentUser = ref.read(authRepositoryProvider).currentUser;

      if (currentUser == null) throw Exception('Usuário não autenticado');

      await swipeRepo.createSwipe(
        fromUserId: currentUser.uid,
        toUserId: widget.targetProfile.userId,
        liked: true,
        comment: comment,
        promptResponseId: _selectedPromptId,
      );

      // Sucesso! Fechar sheet
      widget.onSuccess();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❤️ Like enviado para ${widget.targetProfile.name}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar like: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPrompts = widget.targetProfile.prompts.isNotEmpty;
    final charCount = _commentController.text.length;
    final isValid = charCount >= 10 && charCount <= 200;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.comment, color: Colors.pink),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Adicione um Comentário',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Seleção de prompt (se houver)
          if (hasPrompts) ...[
            Text(
              'Comentar sobre:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.targetProfile.prompts.map((prompt) {
              final isSelected = _selectedPromptId == prompt.responseId;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPromptId = isSelected ? null : prompt.responseId;
                  });
                },
                child: Card(
                  color: isSelected ? Colors.pink[50] : Colors.grey[100],
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prompt.promptText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.pink : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prompt.response,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          // Campo de comentário
          TextField(
            controller: _commentController,
            maxLines: 3,
            maxLength: 200,
            autofocus: true,
            decoration: InputDecoration(
              hintText: hasPrompts
                  ? 'Eu também! Conte mais...'
                  : 'Diga algo interessante...',
              border: const OutlineInputBorder(),
              counterText: '$charCount/200',
              helperText: charCount < 10 ? 'Mínimo 10 caracteres' : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // Botões
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : widget.onCancel,
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (_isLoading || !isValid) ? null : _sendLikeWithComment,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.favorite),
                  label: Text(_isLoading ? 'Enviando...' : 'Enviar Like'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
