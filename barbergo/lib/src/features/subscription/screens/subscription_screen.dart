import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/common_widgets.dart';

/// Tela de planos de assinatura
class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int _selectedPlanIndex = 1; // Plano mensal selecionado por padrão

  final _plans = [
    {
      'name': 'Semanal',
      'price': 'R\$ 19,90',
      'period': '/semana',
      'features': ['Curtidas ilimitadas', '5 Super Likes por dia', '1 Boost por semana'],
    },
    {
      'name': 'Mensal',
      'price': 'R\$ 49,90',
      'period': '/mês',
      'badge': 'POPULAR',
      'features': [
        'Curtidas ilimitadas',
        '10 Super Likes por dia',
        '5 Boosts por mês',
        'Ver quem curtiu você',
        'Mensagens prioritárias',
      ],
    },
    {
      'name': 'Anual',
      'price': 'R\$ 399,90',
      'period': '/ano',
      'badge': 'MELHOR VALOR',
      'discount': 'Economize 33%',
      'features': [
        'Curtidas ilimitadas',
        '20 Super Likes por dia',
        'Boosts ilimitados',
        'Ver quem curtiu você',
        'Mensagens prioritárias',
        'Acesso ao AI Coach',
        'Verificação gratuita',
        'Suporte VIP',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('BarberGO Premium')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.workspace_premium, size: 64, color: theme.colorScheme.onPrimary),
                      const SizedBox(height: 16),
                      Text(
                        'Destaque-se e Encontre Mais Matches',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aumente suas chances com recursos premium',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Planos
                ..._plans.asMap().entries.map((entry) {
                  final index = entry.key;
                  final plan = entry.value;
                  final isSelected = _selectedPlanIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildPlanCard(
                      theme,
                      plan: plan,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedPlanIndex = index),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Termos
                Text(
                  'Ao assinar, você concorda com nossos Termos de Serviço e Política de Privacidade. A assinatura será renovada automaticamente.',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Botão de Assinatura
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: PrimaryButton(
                text: 'Assinar ${_plans[_selectedPlanIndex]['name']}',
                onPressed: () {
                  // TODO: Processar assinatura
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sucesso!'),
                      content: Text('Você assinou o plano ${_plans[_selectedPlanIndex]['name']}!'),
                      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    ThemeData theme, {
    required Map<String, dynamic> plan,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected ? BorderSide(color: theme.colorScheme.primary, width: 2) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan['name'] as String,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (plan['badge'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        plan['badge'] as String,
                        style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan['price'] as String,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    plan['period'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),

              if (plan['discount'] != null) ...[
                const SizedBox(height: 4),
                Text(
                  plan['discount'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],

              const SizedBox(height: 16),

              ...((plan['features'] as List<String>).map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
