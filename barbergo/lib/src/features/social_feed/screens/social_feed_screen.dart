import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/social_feed_controller.dart';

class SocialFeedScreen extends ConsumerWidget {
  const SocialFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(socialFeedControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria Social'),
        actions: [IconButton(icon: const Icon(Icons.add_a_photo), onPressed: () => _showCreatePost(context, ref))],
      ),
      body: feedState.when(
        data: (posts) => posts.isEmpty
            ? const Center(child: Text('Nenhum post ainda'))
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return _PostCard(post: post);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erro: $e')),
      ),
    );
  }

  void _showCreatePost(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Criar Post', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementar seleção de imagem
                Navigator.pop(context);
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Selecionar Foto'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends ConsumerWidget {
  final SocialPost post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.userAvatar.isNotEmpty ? NetworkImage(post.userAvatar) : null,
              child: post.userAvatar.isEmpty ? const Icon(Icons.person) : null,
            ),
            title: Text(post.userName),
            subtitle: Text(_formatDate(post.createdAt)),
            trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () => _showOptions(context, ref)),
          ),
          // Imagem
          if (post.imageUrl.isNotEmpty)
            Image.network(post.imageUrl, width: double.infinity, height: 300, fit: BoxFit.cover),
          // Caption e Tags
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.caption),
                if (post.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: post.tags
                        .map((tag) => Chip(label: Text('#$tag'), labelStyle: const TextStyle(fontSize: 12)))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          // Ações
          Row(
            children: [
              IconButton(
                icon: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? Colors.red : null,
                ),
                onPressed: () {
                  ref
                      .read(socialFeedControllerProvider.notifier)
                      .toggleLike(post.id, 'current-user-id'); // TODO: User ID real
                },
              ),
              Text('${post.likes}'),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {
                  // TODO: Abrir comentários
                },
              ),
              Text('${post.comments}'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: Compartilhar
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays}d atrás';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h atrás';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}min atrás';
    } else {
      return 'Agora';
    }
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Reportar'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Excluir'),
            onTap: () {
              ref.read(socialFeedControllerProvider.notifier).deletePost(post.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
