import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Central de Segurança
class SafetyCenterScreen extends ConsumerWidget {
  const SafetyCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Segurança'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Sua Segurança é Prioridade',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ferramentas e recursos para manter você seguro',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Verificação de Identidade
          FeatureCard(
            icon: Icons.verified_user,
            title: 'Verificação de Identidade',
            description: 'Verifique sua identidade para aumentar a confiança',
            actionText: 'Verificar Agora',
            onTap: () {
              // TODO: Navegar para verificação
            },
          ),
          
          const SizedBox(height: 16),
          
          // Contatos de Emergência
          FeatureCard(
            icon: Icons.contact_emergency,
            title: 'Contatos de Emergência',
            description: 'Adicione contatos para situações de emergência',
            actionText: 'Configurar',
            onTap: () {
              // TODO: Navegar para contatos de emergência
            },
          ),
          
          const SizedBox(height: 16),
          
          // Check-in em Encontros
          FeatureCard(
            icon: Icons.location_on_outlined,
            title: 'Check-in em Encontros',
            description: 'Compartilhe sua localização durante encontros',
            actionText: 'Ativar',
            onTap: () {
              // TODO: Navegar para check-in
            },
          ),
          
          const SizedBox(height: 16),
          
          // Reportar Usuário
          FeatureCard(
            icon: Icons.report_outlined,
            title: 'Reportar Comportamento',
            description: 'Reporte usuários com comportamento inadequado',
            actionText: 'Reportar',
            onTap: () {
              // TODO: Navegar para report
            },
          ),
          
          const SizedBox(height: 16),
          
          // Bloqueados
          FeatureCard(
            icon: Icons.block,
            title: 'Usuários Bloqueados',
            description: 'Gerenciar lista de usuários bloqueados',
            actionText: 'Ver Lista',
            onTap: () {
              // TODO: Navegar para lista de bloqueados
            },
          ),
          
          const SizedBox(height: 24),
          
          // Dicas de Segurança
          Text(
            'Dicas de Segurança',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildTip(
            theme,
            icon: Icons.lightbulb_outline,
            text: 'Nunca compartilhe informações financeiras',
          ),
          _buildTip(
            theme,
            icon: Icons.lightbulb_outline,
            text: 'Encontre-se em locais públicos',
          ),
          _buildTip(
            theme,
            icon: Icons.lightbulb_outline,
            text: 'Avise amigos sobre seus encontros',
          ),
          _buildTip(
            theme,
            icon: Icons.lightbulb_outline,
            text: 'Confie nos seus instintos',
          ),
        ],
      ),
    );
  }

  Widget _buildTip(ThemeData theme, {required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
