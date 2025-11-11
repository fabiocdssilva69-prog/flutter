import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/common_widgets.dart';
import '../../matches/controllers/match_controller.dart';
import '../../profile/controllers/profile_controller.dart';

/// Tela principal com bottom navigation
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [_DiscoveryTab(), _MatchesTab(), _MessagesTab(), _ProfileTab()],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Descobrir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _DiscoveryTab extends ConsumerWidget {
  const _DiscoveryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Redirecionar para a tela de discovery completa
    return const DiscoveryScreenWidget();
  }
}

// Importar a DiscoveryScreen original
class DiscoveryScreenWidget extends StatelessWidget {
  const DiscoveryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder - a tela real discovery_screen.dart já existe
    return Scaffold(
      appBar: AppBar(title: const Text('Descobrir')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text('Swipe Cards em Desenvolvimento'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navegar para /discovery completo
              },
              icon: const Icon(Icons.swipe),
              label: const Text('Começar a Deslizar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchesTab extends ConsumerWidget {
  const _MatchesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matches')),
      body: EmptyState(
        icon: Icons.favorite_outline,
        title: 'Nenhum match ainda',
        description: 'Quando você der match com alguém, eles aparecerão aqui',
        actionText: 'Começar a Deslizar',
        onAction: () {
          // TODO: Ir para discovery
        },
      ),
    );
  }
}

class _MessagesTab extends ConsumerWidget {
  const _MessagesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mensagens')),
      body: EmptyState(
        icon: Icons.chat_bubble_outline,
        title: 'Nenhuma mensagem',
        description: 'Quando você tiver um match e conversar, as mensagens aparecerão aqui',
      ),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentUserProfileProvider);
    final matchesCountAsync = ref.watch(matchesCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () => context.push('/settings'))],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erro ao carregar perfil: $error')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Perfil não encontrado'));
          }

          final matchesCount = matchesCountAsync.asData?.value ?? 0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Avatar e Nome
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Avatar(imageUrl: profile.avatarUrl, size: 100),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                            child: Icon(Icons.edit, size: 20, color: theme.colorScheme.onPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(profile.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      profile.location,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Ações Rápidas
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      theme,
                      icon: Icons.favorite,
                      label: 'Matches',
                      value: matchesCount.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(theme, icon: Icons.visibility, label: 'Visualizações', value: '0'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(theme, icon: Icons.star, label: 'Super Likes', value: '0'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Menu
              FeatureCard(
                icon: Icons.edit,
                title: 'Editar Perfil',
                description: 'Atualize suas fotos e informações',
                onTap: () => context.push('/profile/edit'),
              ),

              const SizedBox(height: 12),

              FeatureCard(
                icon: Icons.workspace_premium,
                title: 'Assinar Premium',
                description: 'Destaque-se com recursos exclusivos',
                onTap: () => context.push('/subscription'),
              ),

              const SizedBox(height: 12),

              FeatureCard(
                icon: Icons.verified_user,
                title: 'Verificação',
                description: 'Verifique sua identidade',
                onTap: () => context.push('/verification'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, {required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }
}
