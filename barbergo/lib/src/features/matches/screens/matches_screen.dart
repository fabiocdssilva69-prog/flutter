import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/match_controller.dart';
import '../widgets/match_card.dart';
import '../../chat/screens/chat_screen.dart';
import '../../profile/repositories/profile_repository.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(userMatchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        centerTitle: true,
        actions: [
          // Match counter badge
          matchesAsync.whenOrNull(
                data: (matches) => matches.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${matches.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: matchesAsync.when(
        data: (matches) {
          if (matches.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userMatchesProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                
                // Buscar dados do outro usuário
                return FutureBuilder(
                  future: ref
                      .read(profileRepositoryProvider)
                      .getProfile(match.getOtherUserId(
                          ref.read(profileRepositoryProvider).currentUserId!)),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final otherUser = snapshot.data!;

                    // TODO: Buscar última mensagem do chat
                    // Para simplicidade, usando valores placeholder
                    final hasUnreadMessages = false;
                    final lastMessage = 'Toque para conversar';
                    final lastMessageTime = match.lastInteractionAt;

                    return MatchCard(
                      userId: otherUser.id,
                      name: otherUser.name,
                      photoUrl: otherUser.photos.isNotEmpty
                          ? otherUser.photos.first
                          : '',
                      lastMessage: lastMessage,
                      lastMessageTime: lastMessageTime,
                      hasUnreadMessages: hasUnreadMessages,
                      onTap: () {
                        // Navegar para ChatScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              otherUserId: otherUser.id,
                              otherUserName: otherUser.name,
                              otherUserPhoto: otherUser.photos.isNotEmpty
                                  ? otherUser.photos.first
                                  : '',
                            ),
                          ),
                        );
                      },
                      onUnmatch: () async {
                        final controller =
                            ref.read(matchControllerProvider.notifier);
                        final success = await controller.unmatch(match.id);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Match desfeito'
                                    : 'Erro ao desfazer match',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      },
                      onBlock: () async {
                        final controller =
                            ref.read(matchControllerProvider.notifier);
                        final success =
                            await controller.blockUser(otherUser.id);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Usuário bloqueado'
                                    : 'Erro ao bloquear usuário',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      },
                      onReport: () async {
                        final controller =
                            ref.read(matchControllerProvider.notifier);
                        final success = await controller.reportUser(
                          userId: otherUser.id,
                          reason: 'Comportamento inadequado',
                          details: 'Denúncia feita pelo usuário',
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Denúncia enviada'
                                    : 'Erro ao enviar denúncia',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erro ao carregar matches',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(userMatchesProvider);
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum match ainda',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Continue deslizando para encontrar seu barbeiro perfeito!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Voltar para tela de swipe
                Navigator.pop(context);
              },
              icon: const Icon(Icons.explore),
              label: const Text('Começar a Deslizar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
