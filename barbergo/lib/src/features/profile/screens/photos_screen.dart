import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/common_widgets.dart';
import '../controllers/media_controller.dart';
import '../controllers/profile_controller.dart';

/// Tela para gerenciar fotos e vídeos do perfil
class PhotosScreen extends ConsumerWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentUserProfileProvider);
    final uploadState = ref.watch(mediaControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotos e Vídeos'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Salvar alterações
              context.pop();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Dica
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Adicione pelo menos 2 fotos para começar. Perfis com 6+ fotos recebem mais matches!',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Grid de fotos com dados reais
          profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Erro: $error')),
            data: (profile) {
              if (profile == null) return const SizedBox();

              final photos = profile.portfolioUrls;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final hasPhoto = index < photos.length;
                  final photoUrl = hasPhoto ? photos[index] : null;

                  return GestureDetector(
                    onTap: uploadState.isLoading
                        ? null
                        : () => hasPhoto ? _showDeleteDialog(context, ref, index, photos[index]) : _uploadPhoto(ref),
                    child: Container(
                      decoration: BoxDecoration(
                        color: hasPhoto
                            ? theme.colorScheme.surfaceContainerHighest
                            : theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
                      ),
                      child: Stack(
                        children: [
                          if (hasPhoto && photoUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 48,
                                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            )
                          else
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 32,
                                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                                  ),
                                  if (index == 0) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Principal',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                          // Loading overlay
                          if (uploadState.isLoading)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 24),

          // Adicionar Vídeo
          FeatureCard(
            icon: Icons.videocam,
            title: 'Adicionar Vídeo de Perfil',
            description: 'Destaque-se com um vídeo curto (até 30s)',
            badge: Badge(text: 'Premium', color: theme.colorScheme.tertiary),
            onTap: () {
              // TODO: Adicionar vídeo
            },
          ),

          const SizedBox(height: 16),

          // Dicas de Fotos
          Text('Dicas para fotos de perfil', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),

          _buildTip(theme, 'Use fotos recentes e claras'),
          _buildTip(theme, 'Mostre seu rosto claramente'),
          _buildTip(theme, 'Inclua fotos de corpo inteiro'),
          _buildTip(theme, 'Evite filtros excessivos'),
          _buildTip(theme, 'Mostre seus hobbies e interesses'),
        ],
      ),
    );
  }

  Widget _buildTip(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Future<void> _uploadPhoto(WidgetRef ref) async {
    final success = await ref.read(mediaControllerProvider.notifier).uploadImage(false); // false = portfolio
    // Feedback automático via AsyncValue UI
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref, int index, String photoUrl) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Foto'),
        content: const Text('Tem certeza que deseja remover esta foto?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(mediaControllerProvider.notifier).removePortfolioImage(photoUrl);
    }
  }
}
