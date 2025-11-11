import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/common_widgets.dart';

/// Central de Ajuda e FAQ
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Central de Ajuda')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Busca
          SearchBar(
            hintText: 'Buscar ajuda...',
            leading: const Icon(Icons.search),
            onChanged: (value) {
              // TODO: Implementar busca
            },
          ),

          const SizedBox(height: 24),

          // Categorias Populares
          Text('Categorias Populares', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),

          _buildCategoryCard(
            theme,
            icon: Icons.account_circle_outlined,
            title: 'Conta e Perfil',
            questions: 8,
            onTap: () {
              // TODO: Navegar para categoria
            },
          ),

          const SizedBox(height: 12),

          _buildCategoryCard(
            theme,
            icon: Icons.favorite_outline,
            title: 'Matches e Curtidas',
            questions: 12,
            onTap: () {
              // TODO: Navegar para categoria
            },
          ),

          const SizedBox(height: 12),

          _buildCategoryCard(
            theme,
            icon: Icons.chat_bubble_outline,
            title: 'Mensagens e Chat',
            questions: 6,
            onTap: () {
              // TODO: Navegar para categoria
            },
          ),

          const SizedBox(height: 12),

          _buildCategoryCard(
            theme,
            icon: Icons.workspace_premium_outlined,
            title: 'Assinatura e Pagamentos',
            questions: 10,
            onTap: () {
              // TODO: Navegar para categoria
            },
          ),

          const SizedBox(height: 12),

          _buildCategoryCard(
            theme,
            icon: Icons.shield_outlined,
            title: 'Segurança e Privacidade',
            questions: 15,
            onTap: () {
              // TODO: Navegar para categoria
            },
          ),

          const SizedBox(height: 24),

          // Suporte Direto
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.support_agent, size: 48, color: theme.colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  'Não encontrou o que procura?',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Entre em contato com nosso suporte',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Falar com Suporte',
                  icon: Icons.chat,
                  onPressed: () {
                    // TODO: Navegar para contato com suporte
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required int questions,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      '$questions perguntas',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
            ],
          ),
        ),
      ),
    );
  }
}
