import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tela de Admin Dashboard
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Atualizar dados
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  theme,
                  icon: Icons.people,
                  title: 'Usuários Ativos',
                  value: '12.5K',
                  change: '+12.3%',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  theme,
                  icon: Icons.favorite,
                  title: 'Matches Hoje',
                  value: '3.2K',
                  change: '+8.1%',
                  isPositive: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  theme,
                  icon: Icons.attach_money,
                  title: 'Receita Mensal',
                  value: 'R\$ 45K',
                  change: '+15.7%',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  theme,
                  icon: Icons.star,
                  title: 'Premium',
                  value: '2.1K',
                  change: '+5.2%',
                  isPositive: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Ações Rápidas
          Text('Ações Rápidas', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),

          _buildActionCard(
            theme,
            icon: Icons.people_outline,
            title: 'Gerenciar Usuários',
            subtitle: 'Ver, editar e suspender usuários',
            onTap: () {
              // TODO: Navegar para gerenciamento de usuários
            },
          ),

          const SizedBox(height: 8),

          _buildActionCard(
            theme,
            icon: Icons.analytics_outlined,
            title: 'Analytics',
            subtitle: 'Visualizar métricas e relatórios',
            onTap: () {
              // TODO: Navegar para analytics
            },
          ),

          const SizedBox(height: 8),

          _buildActionCard(
            theme,
            icon: Icons.attach_money,
            title: 'Receita',
            subtitle: 'Acompanhar pagamentos e assinaturas',
            onTap: () {
              // TODO: Navegar para receita
            },
          ),

          const SizedBox(height: 8),

          _buildActionCard(
            theme,
            icon: Icons.flag_outlined,
            title: 'Moderação de Conteúdo',
            subtitle: 'Revisar reportes e conteúdo',
            badge: '12',
            onTap: () {
              // TODO: Navegar para moderação
            },
          ),

          const SizedBox(height: 24),

          // Atividade Recente
          Text('Atividade Recente', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),

          _buildActivityItem(
            theme,
            icon: Icons.person_add,
            title: 'Novo usuário registrado',
            subtitle: 'João Silva - há 5 minutos',
          ),

          _buildActivityItem(
            theme,
            icon: Icons.report,
            title: 'Novo reporte recebido',
            subtitle: 'Perfil reportado - há 12 minutos',
          ),

          _buildActivityItem(
            theme,
            icon: Icons.credit_card,
            title: 'Nova assinatura Premium',
            subtitle: 'R\$ 49,90 - há 25 minutos',
          ),

          _buildActivityItem(
            theme,
            icon: Icons.verified,
            title: 'Verificação aprovada',
            subtitle: 'Maria Santos - há 1 hora',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      fontSize: 11,
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
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
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: theme.colorScheme.error, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    badge,
                    style: TextStyle(color: theme.colorScheme.onError, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
