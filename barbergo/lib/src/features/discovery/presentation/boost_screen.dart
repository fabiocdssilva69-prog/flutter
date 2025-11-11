import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/profile_entity.dart';
import '../../../../services/stripe_service.dart';
import '../controllers/boost_controller.dart';

/// Tela de Boost - Permite ativar boost ou comprar mais boosts
/// Boost: aparecer no topo dos resultados por 30 minutos
class BoostScreen extends ConsumerStatefulWidget {
  const BoostScreen({super.key});

  @override
  ConsumerState<BoostScreen> createState() => _BoostScreenState();
}

class _BoostScreenState extends ConsumerState<BoostScreen> {
  Timer? _timer;
  int _timeRemaining = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateTimeRemaining();
      }
    });
  }

  Future<void> _updateTimeRemaining() async {
    final timeRemaining = await ref.read(boostControllerProvider.notifier).getBoostTimeRemaining();
    if (mounted) {
      setState(() {
        _timeRemaining = timeRemaining;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🚀 Boost'), backgroundColor: Colors.orange.shade700),
      body: StreamBuilder<ProfileEntity?>(
        stream: ref.read(boostControllerProvider.notifier).watchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: Text('Erro ao carregar perfil'));
          }

          final isBoosted = profile.isBoosted;
          final boostsRemaining = profile.boostsRemaining;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Status do Boost
                _buildBoostStatus(isBoosted),

                // Info sobre Boost
                _buildBoostInfo(),

                // Botão de Ação
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: isBoosted
                      ? _buildActiveBoostCard()
                      : boostsRemaining > 0
                      ? _buildActivateButton(boostsRemaining)
                      : _buildBuyBoostsButton(),
                ),

                // Como funciona
                _buildHowItWorks(),

                // Estatísticas (se boosted)
                if (isBoosted) _buildStats(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBoostStatus(bool isBoosted) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isBoosted
              ? [Colors.orange.shade700, Colors.deepOrange.shade900]
              : [Colors.grey.shade600, Colors.grey.shade800],
        ),
      ),
      child: Column(
        children: [
          Icon(isBoosted ? Icons.rocket_launch : Icons.rocket_launch_outlined, size: 80, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            isBoosted ? 'Boost Ativo!' : 'Boost Inativo',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          if (isBoosted) ...[
            Text('Você está em destaque', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              ),
              child: Text(
                '⏱️ $_timeRemaining minutos restantes',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ] else
            Text(
              'Ative o boost e apareça no topo!',
              style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
            ),
        ],
      ),
    );
  }

  Widget _buildBoostInfo() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  const Text('O que é o Boost?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.trending_up, 'Apareça no topo dos resultados'),
              _buildInfoRow(Icons.visibility, 'Até 10x mais visualizações'),
              _buildInfoRow(Icons.favorite, 'Mais likes e matches'),
              _buildInfoRow(Icons.timer, 'Duração: 30 minutos'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildActiveBoostCard() {
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 48, color: Colors.orange.shade700),
            const SizedBox(height: 12),
            const Text(
              'Seu perfil está em destaque!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Aproveite os próximos $_timeRemaining minutos para conseguir mais matches',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivateButton(int boostsRemaining) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () async {
              final success = await ref.read(boostControllerProvider.notifier).activateBoost();

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🚀 Boost ativado! Seu perfil está em destaque por 30 minutos'),
                    backgroundColor: Colors.orange,
                  ),
                );
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('❌ Não foi possível ativar o boost'), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.rocket_launch, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Ativar Boost ($boostsRemaining disponíveis)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            // Navegar para compra de boosts
            _showBuyBoostsDialog();
          },
          child: const Text('Comprar mais boosts'),
        ),
      ],
    );
  }

  Widget _buildBuyBoostsButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _showBuyBoostsDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade700,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_cart, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Comprar Boosts - R\$ 9,90',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Como funciona?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildStep(1, 'Ative o Boost', 'Clique no botão para ativar um dos seus boosts'),
          _buildStep(2, 'Apareça no topo', 'Seu perfil será priorizado nos resultados por 30 minutos'),
          _buildStep(3, 'Consiga mais matches', 'Receba até 10x mais visualizações e likes'),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: Colors.orange.shade700, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
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

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        color: Colors.green.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('📊 Durante o Boost', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(Icons.visibility, '???', 'Visualizações'),
                  _buildStatItem(Icons.favorite, '???', 'Likes'),
                  _buildStatItem(Icons.star, '???', 'Super Likes'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Estatísticas disponíveis em breve',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  void _showBuyBoostsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.shopping_cart, color: Colors.orange),
            SizedBox(width: 8),
            Text('Comprar Boosts'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('5 Boosts por R\$ 9,90', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Cada boost dura 30 minutos', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Boosts não expiram. Use quando quiser!', style: TextStyle(fontSize: 13))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Integração com Stripe
              final stripeService = ref.read(stripeServiceProvider);
              final url = await stripeService.buyBoosts5();

              if (url != null && mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('🛒 Abrindo checkout...'), backgroundColor: Colors.blue));
                // TODO: Abrir URL com url_launcher
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('❌ Erro ao criar sessão de checkout'), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700),
            child: const Text('Comprar Agora'),
          ),
        ],
      ),
    );
  }
}
