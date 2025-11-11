import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/analytics_service.dart';
import '../../../services/stripe_service.dart';
import '../../profile/controllers/profile_controller.dart';

/// Tela de assinatura Premium com planos mensal/anual
/// Mostra benefícios, comparação Free vs Premium, e integração Stripe
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  @override
  void initState() {
    super.initState();

    // Track premium screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logPremiumScreenViewed(source: 'navigation');
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar com gradiente
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                '✨ Premium',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.amber.shade700, Colors.orange.shade700, Colors.deepOrange.shade800],
                  ),
                ),
                child: const Center(child: Icon(Icons.workspace_premium, size: 80, color: Colors.white70)),
              ),
            ),
          ),

          // Conteúdo
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Título
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Desbloqueie Todos os Recursos',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Encontre mais matches e aproveite ao máximo',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 32),

                // Comparação Free vs Premium
                _buildComparisonTable(),

                const SizedBox(height: 32),

                // Planos
                _buildPlansSection(context, profileAsync),

                const SizedBox(height: 32),

                // Lista de benefícios detalhada
                _buildBenefitsList(),

                const SizedBox(height: 32),

                // FAQ
                _buildFAQ(),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(flex: 2, child: SizedBox()),
                  Expanded(
                    child: Text(
                      'Free',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Premium',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildComparisonRow('Super Likes', '1/dia', 'Ilimitado'),
              _buildComparisonRow('Ver Quem Curtiu', '❌', '✅'),
              _buildComparisonRow('Prioridade na Busca', '❌', '✅'),
              _buildComparisonRow('Filtros Avançados', '❌', '✅'),
              _buildComparisonRow('Sem Anúncios', '❌', '✅'),
              _buildComparisonRow('Badge Premium', '❌', '✅'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String feature, String free, String premium) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(feature, style: const TextStyle(fontSize: 14))),
          Expanded(
            child: Text(
              free,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              premium,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansSection(BuildContext context, AsyncValue profileAsync) {
    return profileAsync.when(
      data: (profile) {
        final isPremium = profile?.hasActivePremium ?? false;

        if (isPremium) {
          return _buildAlreadyPremiumCard(profile!);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Escolha seu plano',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              context: context,
              title: 'Premium Anual',
              price: 'R\$ 191,04',
              period: '/ano',
              savings: 'Economize 20%',
              features: ['R\$ 15,92/mês', 'Cobrança anual', 'Melhor custo-benefício'],
              isPopular: true,
              onTap: () => _subscribeToPremiumYearly(context),
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              context: context,
              title: 'Premium Mensal',
              price: 'R\$ 19,90',
              period: '/mês',
              features: ['Cobrança mensal', 'Cancele quando quiser', 'Sem compromisso'],
              isPopular: false,
              onTap: () => _subscribeToPremiumMonthly(context),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Erro: $e')),
    );
  }

  Widget _buildAlreadyPremiumCard(profile) {
    final expiresAt = profile.premiumExpiresAt;
    final daysRemaining = expiresAt?.difference(DateTime.now()).inDays ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        color: Colors.amber.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.workspace_premium, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              const Text('Você já é Premium!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                daysRemaining > 0 ? 'Sua assinatura renova em $daysRemaining dias' : 'Aproveite todos os benefícios',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              const Text(
                '✨ Super Likes Ilimitados\n'
                '💝 Veja Quem Curtiu Você\n'
                '🚀 Prioridade na Busca\n'
                '🎯 Filtros Avançados',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required String period,
    String? savings,
    required List<String> features,
    required bool isPopular,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          Card(
            elevation: isPopular ? 8 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isPopular ? BorderSide(color: Colors.orange.shade700, width: 2) : BorderSide.none,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        if (savings != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              savings,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        Text(period, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...features.map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 20, color: Colors.green.shade600),
                            const SizedBox(width: 8),
                            Text(feature, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPopular ? Colors.orange.shade700 : Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          isPopular ? 'Escolher Plano' : 'Assinar',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isPopular)
            Positioned(
              top: 0,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700]),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  '🔥 MAIS POPULAR',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O que você ganha com Premium?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 16),
          _buildBenefitItem(
            icon: Icons.auto_awesome,
            title: 'Super Likes Ilimitados',
            description: 'Mostre interesse especial sem limites. Usuários premium se destacam!',
            color: Colors.blue,
          ),
          _buildBenefitItem(
            icon: Icons.favorite,
            title: 'Veja Quem Curtiu Você',
            description: 'Veja exatamente quem te curtiu e dê like de volta para match instantâneo',
            color: Colors.pink,
          ),
          _buildBenefitItem(
            icon: Icons.trending_up,
            title: 'Prioridade na Busca',
            description: 'Seu perfil aparece primeiro. Até 3x mais visualizações!',
            color: Colors.orange,
          ),
          _buildBenefitItem(
            icon: Icons.filter_list,
            title: 'Filtros Avançados',
            description: 'Filtre por distância, avaliação, disponibilidade e mais',
            color: Colors.purple,
          ),
          _buildBenefitItem(
            icon: Icons.block,
            title: 'Sem Anúncios',
            description: 'Experiência premium sem interrupções',
            color: Colors.green,
          ),
          _buildBenefitItem(
            icon: Icons.workspace_premium,
            title: 'Badge Premium',
            description: 'Badge dourado no seu perfil. Destaque-se!',
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perguntas Frequentes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            question: 'Posso cancelar a qualquer momento?',
            answer:
                'Sim! Você pode cancelar sua assinatura quando quiser. Você continuará com acesso Premium até o fim do período pago.',
          ),
          _buildFAQItem(
            question: 'Como funciona a cobrança?',
            answer:
                'A cobrança é feita automaticamente no cartão de crédito todo mês (plano mensal) ou todo ano (plano anual).',
          ),
          _buildFAQItem(
            question: 'Posso mudar de plano?',
            answer: 'Sim! Você pode fazer upgrade ou downgrade do seu plano a qualquer momento.',
          ),
          _buildFAQItem(
            question: 'Tem garantia?',
            answer: 'Sim! Se não ficar satisfeito nos primeiros 7 dias, devolvemos 100% do seu dinheiro.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }

  Future<void> _subscribeToPremiumMonthly(BuildContext context) async {
    final analytics = ref.read(analyticsServiceProvider);

    // Track checkout start
    await analytics.logCheckoutStarted(plan: 'monthly', price: 19.90);

    _showLoadingDialog(context);

    final stripeService = StripeService();
    final url = await stripeService.subscribeToPremiumMonthly();

    Navigator.pop(context); // Remove loading dialog

    if (url != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('🛒 Abrindo checkout...'), backgroundColor: Colors.blue));
      // TODO: Abrir URL com url_launcher
      // await launchUrl(Uri.parse(url));
    } else {
      // Track checkout failed
      await analytics.logCheckoutFailed(
        plan: 'monthly',
        errorCode: 'url_null',
        errorMessage: 'Stripe checkout URL is null',
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Erro ao criar sessão de checkout'), backgroundColor: Colors.red));
    }
  }

  Future<void> _subscribeToPremiumYearly(BuildContext context) async {
    final analytics = ref.read(analyticsServiceProvider);

    // Track checkout start
    await analytics.logCheckoutStarted(plan: 'yearly', price: 191.04);

    _showLoadingDialog(context);

    final stripeService = StripeService();
    final url = await stripeService.subscribeToPremiumYearly();

    Navigator.pop(context); // Remove loading dialog

    if (url != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('🛒 Abrindo checkout...'), backgroundColor: Colors.blue));
      // TODO: Abrir URL com url_launcher
      // await launchUrl(Uri.parse(url));
    } else {
      // Track checkout failed
      await analytics.logCheckoutFailed(
        plan: 'yearly',
        errorCode: 'url_null',
        errorMessage: 'Stripe checkout URL is null',
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Erro ao criar sessão de checkout'), backgroundColor: Colors.red));
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Criando sessão de checkout...')],
            ),
          ),
        ),
      ),
    );
  }
}
