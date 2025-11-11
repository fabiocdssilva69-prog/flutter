import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Tela de configurações do app
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          // Conta
          _buildSection(
            context,
            theme,
            title: 'Conta',
            items: [
              _buildTile(
                context,
                icon: Icons.person_outline,
                title: 'Editar Perfil',
                onTap: () => context.push('/profile/edit'),
              ),
              _buildTile(
                context,
                icon: Icons.photo_library_outlined,
                title: 'Fotos e Vídeos',
                onTap: () => context.push('/profile/photos'),
              ),
              _buildTile(
                context,
                icon: Icons.verified_user_outlined,
                title: 'Verificação',
                onTap: () => context.push('/verification'),
              ),
            ],
          ),

          // Preferências
          _buildSection(
            context,
            theme,
            title: 'Preferências',
            items: [
              _buildTile(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notificações',
                onTap: () => context.push('/settings/notifications'),
              ),
              _buildTile(
                context,
                icon: Icons.lock_outline,
                title: 'Privacidade',
                onTap: () => context.push('/settings/privacy'),
              ),
              _buildTile(
                context,
                icon: Icons.security_outlined,
                title: 'Segurança',
                onTap: () => context.push('/settings/security'),
              ),
              _buildTile(
                context,
                icon: Icons.filter_list,
                title: 'Filtros de Descoberta',
                onTap: () {
                  // TODO: Navegar para filtros
                },
              ),
            ],
          ),

          // Premium
          _buildSection(
            context,
            theme,
            title: 'Premium',
            items: [
              _buildTile(
                context,
                icon: Icons.workspace_premium,
                title: 'Assinar Premium',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'VIP',
                    style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () => context.push('/subscription'),
              ),
              _buildTile(
                context,
                icon: Icons.shopping_bag_outlined,
                title: 'Minhas Compras',
                onTap: () => context.push('/subscription/plans'),
              ),
            ],
          ),

          // Suporte
          _buildSection(
            context,
            theme,
            title: 'Suporte',
            items: [
              _buildTile(
                context,
                icon: Icons.help_outline,
                title: 'Central de Ajuda',
                onTap: () => context.push('/help'),
              ),
              _buildTile(
                context,
                icon: Icons.shield_outlined,
                title: 'Central de Segurança',
                onTap: () => context.push('/safety'),
              ),
              _buildTile(
                context,
                icon: Icons.info_outline,
                title: 'Sobre',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'BarberGO',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(Icons.favorite),
                  );
                },
              ),
            ],
          ),

          // Sair
          _buildSection(
            context,
            theme,
            items: [
              _buildTile(
                context,
                icon: Icons.logout,
                title: 'Sair',
                textColor: theme.colorScheme.error,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sair'),
                      content: const Text('Tem certeza que deseja sair?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                        TextButton(
                          onPressed: () {
                            // TODO: Fazer logout
                            context.go('/login');
                          },
                          child: const Text('Sair'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, ThemeData theme, {String? title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        ...items,
      ],
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: textColor ?? theme.colorScheme.onSurface),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: trailing ?? Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
      onTap: onTap,
    );
  }
}
