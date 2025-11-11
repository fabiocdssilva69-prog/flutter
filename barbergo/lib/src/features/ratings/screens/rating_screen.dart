import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/rating_repository.dart';
import '../../../domain/entities/rating_entity.dart';
import '../widgets/rating_stars.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final String targetUserId;
  final String targetName;

  const RatingScreen({required this.targetUserId, required this.targetName, super.key});

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _selectedStars = 0;
  bool _isLoading = true;
  bool _isSaving = false;
  RatingEntity? _existingRating;

  @override
  void initState() {
    super.initState();
    _checkExistingRating();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _checkExistingRating() async {
    final currentUserId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (currentUserId == null) return;

    try {
      final rating = await ref.read(ratingRepositoryProvider).getRating(currentUserId, widget.targetUserId);

      if (rating != null && mounted) {
        setState(() {
          _existingRating = rating;
          _selectedStars = rating.stars;
          _commentController.text = rating.comment;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar avaliação: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitRating() async {
    if (_selectedStars == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma avaliação de 1 a 5 estrelas')));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentUserId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (currentUserId == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (_existingRating != null) {
        // Atualizar avaliação existente
        await ref
            .read(ratingRepositoryProvider)
            .updateRating(
              ratingId: _existingRating!.ratingId,
              stars: _selectedStars,
              comment: _commentController.text.trim(),
            );
      } else {
        // Criar nova avaliação
        await ref
            .read(ratingRepositoryProvider)
            .createRating(
              fromUserId: currentUserId,
              toUserId: widget.targetUserId,
              stars: _selectedStars,
              comment: _commentController.text.trim(),
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _existingRating != null ? 'Avaliação atualizada com sucesso! ✅' : 'Avaliação enviada com sucesso! ✅',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar avaliação: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _deleteRating() async {
    if (_existingRating == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Avaliação'),
        content: const Text('Tem certeza que deseja deletar sua avaliação?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(ratingRepositoryProvider).deleteRating(_existingRating!.ratingId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avaliação deletada com sucesso!'), backgroundColor: Colors.orange),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao deletar avaliação: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliar ${widget.targetName}'),
        actions: [
          if (_existingRating != null && !_isSaving)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteRating,
              tooltip: 'Deletar avaliação',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue,
                              child: Text(
                                widget.targetName[0].toUpperCase(),
                                style: const TextStyle(fontSize: 32, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(widget.targetName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              _existingRating != null ? 'Edite sua avaliação' : 'Como foi sua experiência?',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Seletor de estrelas
                    const Text('Avaliação *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    RatingSelector(
                      initialRating: _selectedStars,
                      onRatingChanged: (rating) {
                        setState(() {
                          _selectedStars = rating;
                        });
                      },
                      size: 48,
                    ),

                    const SizedBox(height: 32),

                    // Campo de comentário
                    TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Comentário (opcional)',
                        hintText: 'Conte como foi sua experiência...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      maxLength: 500,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty && value.trim().length < 10) {
                          return 'Comentário deve ter pelo menos 10 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Botão de enviar
                    ElevatedButton(
                      onPressed: _isSaving ? null : _submitRating,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              _existingRating != null ? 'Atualizar Avaliação' : 'Enviar Avaliação',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),

                    const SizedBox(height: 16),

                    // Informação adicional
                    if (_existingRating != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 20, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Você já avaliou este usuário. Edite ou delete sua avaliação.',
                                style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
