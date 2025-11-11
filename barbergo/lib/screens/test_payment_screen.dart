import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/stripe_config.dart';
import '../services/stripe_service.dart';

/// Tela de teste para validar integração Stripe
/// USAR APENAS EM DESENVOLVIMENTO/TESTE
class TestPaymentScreen extends StatefulWidget {
  const TestPaymentScreen({super.key});

  @override
  State<TestPaymentScreen> createState() => _TestPaymentScreenState();
}

class _TestPaymentScreenState extends State<TestPaymentScreen> {
  final StripeService _stripeService = StripeService();
  bool _loading = false;
  String _statusMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧪 Teste de Pagamentos'), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Status message
            if (_statusMessage.isNotEmpty) ...[_buildStatusCard(), const SizedBox(height: 16)],

            // Subscription status
            _buildSubscriptionStatus(),
            const SizedBox(height: 24),

            // Products
            const Text('📋 PRODUTOS DISPONÍVEIS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildProductCard(
              icon: '👑',
              title: 'Premium Mensal',
              price: 'R\$ 19,90/mês',
              description: 'Teste assinatura recorrente',
              color: Colors.amber,
              onPressed: () =>
                  _testProduct(priceId: StripeConfig.premiumMonthly, mode: 'subscription', name: 'Premium Mensal'),
            ),

            _buildProductCard(
              icon: '💎',
              title: 'Premium Anual',
              price: 'R\$ 191,04/ano',
              description: 'Economize 16% ao ano',
              color: Colors.purple,
              onPressed: () =>
                  _testProduct(priceId: StripeConfig.premiumYearly, mode: 'subscription', name: 'Premium Anual'),
            ),

            _buildProductCard(
              icon: '🚀',
              title: '5 Boosts',
              price: 'R\$ 9,90',
              description: 'Compra única (payment mode)',
              color: Colors.orange,
              onPressed: () => _testProduct(priceId: StripeConfig.boosts5, mode: 'payment', name: '5 Boosts'),
            ),

            _buildProductCard(
              icon: '💫',
              title: '10 Super Likes',
              price: 'R\$ 8,90',
              description: 'Compra única (payment mode)',
              color: Colors.blue,
              onPressed: () =>
                  _testProduct(priceId: StripeConfig.superLikes10, mode: 'payment', name: '10 Super Likes'),
            ),

            const SizedBox(height: 24),

            // Test cards info
            _buildTestCardsInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.science, size: 48, color: Colors.deepPurple),
            const SizedBox(height: 8),
            const Text('Ambiente de Teste', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Todos os pagamentos são simulados.\nNenhum cartão real será cobrado.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: _statusMessage.startsWith('✅') ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          _statusMessage,
          style: TextStyle(
            fontSize: 14,
            color: _statusMessage.startsWith('✅') ? Colors.green.shade900 : Colors.red.shade900,
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionStatus() {
    return StreamBuilder<bool>(
      stream: _stripeService.subscriptionStatusStream(),
      builder: (context, snapshot) {
        final isPremium = snapshot.data ?? false;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return Card(
          color: isPremium ? Colors.amber.shade50 : Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  isPremium ? Icons.star : Icons.star_border,
                  color: isPremium ? Colors.amber : Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoading ? 'Verificando...' : (isPremium ? '✅ Assinatura Premium Ativa' : '❌ Sem assinatura'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (!isLoading)
                        Text(
                          isPremium ? 'Todos os recursos premium desbloqueados' : 'Teste uma assinatura abaixo',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard({
    required String icon,
    required String title,
    required String price,
    required String description,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _loading ? null : onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(icon, style: const TextStyle(fontSize: 32))),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),

              // Button
              Icon(Icons.arrow_forward_ios, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCardsInfo() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Cartões de Teste',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTestCardRow('✅ Sucesso', '4242 4242 4242 4242'),
            _buildTestCardRow('✅ BR válido', '4000 0076 4000 0002'),
            _buildTestCardRow('❌ Recusado', '4000 0000 0000 0002'),
            _buildTestCardRow('🔐 3D Secure', '4000 0025 0000 3155'),
            const SizedBox(height: 8),
            Text(
              'Validade: 12/34 • CVV: 123 • CEP: 12345',
              style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCardRow(String label, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: Text(
              number,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _testProduct({required String priceId, required String mode, required String name}) async {
    setState(() {
      _loading = true;
      _statusMessage = '⏳ Criando sessão de checkout para $name...';
    });

    try {
      // Create checkout session
      final url = await _stripeService.createCheckoutSession(priceId: priceId, mode: mode);

      if (url != null) {
        setState(() {
          _statusMessage = '✅ Checkout criado! Abrindo navegador...';
        });

        // Open checkout URL
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);

          setState(() {
            _statusMessage =
                '✅ $name: Checkout aberto!\n\nComplete o pagamento no navegador.\n\nUse: 4242 4242 4242 4242';
          });
        } else {
          setState(() {
            _statusMessage = '❌ Não foi possível abrir o navegador.\n\nURL:\n$url';
          });
        }
      } else {
        setState(() {
          _statusMessage = '❌ Erro ao criar sessão de checkout.\n\nVerifique os logs.';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erro: ${e.toString()}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
