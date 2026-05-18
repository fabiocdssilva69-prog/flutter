import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/stripe_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/theme/app_backgrounds.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../profile/controllers/profile_controller.dart';
import '../utils/badge_colors.dart';

/// Nova tela "Conquiste Seu Selo" - Sistema de 2 badges: Silver e Gold
/// Substitui a antiga tela "Torne-se Premium"
class ConquisteSeuSeloScreen extends ConsumerStatefulWidget {
  const ConquisteSeuSeloScreen({super.key});

  @override
  ConsumerState<ConquisteSeuSeloScreen> createState() => _ConquisteSeuSeloScreenState();
}

class _ConquisteSeuSeloScreenState extends ConsumerState<ConquisteSeuSeloScreen> {
  bool _showYearlyPrice = true; // Padrão: mostrar preço anual (melhor economia)

  @override
  void initState() {
    super.initState();

    // Track screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(analyticsServiceProvider)
          .logEvent(name: 'conquiste_seu_selo_viewed', parameters: {'source': 'navigation'});
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentUserProfileProvider);

    return AppBackgrounds.scaffold(
      child: CustomScrollView(
        slivers: [
          // AppBar com gradiente
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            leading: IconButton(
              icon: const Text('←', style: TextStyle(fontSize: 24, color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'Conquiste Seu Selo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFFD700).withOpacity(0.8), // Gold
                      const Color(0xFFC0C0C0).withOpacity(0.8), // Silver
                      const Color(0xFFD4AF37).withOpacity(0.8), // Dark gold
                    ],
                  ),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BadgeIcon(badge: VerificationBadge.silver, size: 60, showShadow: true),
                      SizedBox(width: 16),
                      BadgeIcon(badge: VerificationBadge.gold, size: 60, showShadow: true),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Conteúdo
          SliverToBoxAdapter(
            child: profileAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Erro: $error')),
              data: (profile) => _buildContent(context, profile),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfileEntity? profile) {
    if (profile == null) {
      return const Center(child: Text('Perfil não encontrado'));
    }

    // Se já tem selo ativo, mostrar gerenciamento
    if (profile.verificationBadge == VerificationBadge.silver || profile.verificationBadge == VerificationBadge.gold) {
      return _buildAlreadyHasBadge(profile);
    }

    return Column(
      children: [
        const SizedBox(height: 24),

        // Título
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Destaque-se com um Selo Verificado',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Tenha mais matches, recursos exclusivos e prioridade',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 32),

        // Toggle: Mensal/Anual
        _buildPricingToggle(),

        const SizedBox(height: 24),

        // Cards dos selos
        _buildSilverCard(),
        const SizedBox(height: 20),
        _buildGoldCard(),

        const SizedBox(height: 32),

        // Comparação rápida
        _buildComparisonTable(),

        const SizedBox(height: 32),

        // Benefícios detalhados
        _buildBenefitsList(),

        const SizedBox(height: 32),

        // FAQ
        _buildFAQ(),

        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildAlreadyHasBadge(ProfileEntity profile) {
    final badge = profile.verificationBadge;
    final isSilver = badge == VerificationBadge.silver;
    final isGold = badge == VerificationBadge.gold;

    final expiresAt = profile.premiumExpiresAt;
    final daysRemaining = expiresAt?.difference(DateTime.now()).inDays ?? 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Badge atual
          BadgeIcon(badge: isSilver ? VerificationBadge.silver : VerificationBadge.gold, size: 80, showShadow: true),
          const SizedBox(height: 16),
          Text(
            'Você tem o Selo ${isSilver ? "Silver" : "Gold"}!',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            daysRemaining > 0 ? 'Renova em $daysRemaining dias' : 'Aproveite todos os benefícios',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
          ),

          const SizedBox(height: 32),

          // Benefícios atuais
          Card(
            color: const Color(0xFF1E1E2E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seus Benefícios ${isSilver ? "Silver" : "Gold"}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitRow('✓', 'Likes Ilimitados'),
                  _buildBenefitRow('✓', 'Desfazer Swipes (Rewind)'),
                  _buildBenefitRow('✓', 'Passaporte (mudar cidade)'),
                  _buildBenefitRow('✓', '${isSilver ? "5" : "10"} Super Likes/semana'),
                  _buildBenefitRow('✓', '${isSilver ? "1" : "3"} Boost${isGold ? "s" : ""}/mês'),
                  _buildBenefitRow('✓', 'Sem Anúncios'),
                  _buildBenefitRow('✓', 'Leitura Confirmada'),
                  if (isGold) ...[
                    _buildBenefitRow('✓', 'Ver Quem Curtiu Você', color: Colors.amber),
                    _buildBenefitRow('✓', 'Top Picks Diários (IA)', color: Colors.amber),
                    _buildBenefitRow('✓', 'Modo Invisível', color: Colors.amber),
                    _buildBenefitRow('✓', 'Filtros Avançados', color: Colors.amber),
                    _buildBenefitRow('✓', 'Prioridade no Algoritmo', color: Colors.amber),
                    _buildBenefitRow('✓', 'Analytics Completo', color: Colors.amber),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Upsell: Silver → Gold
          if (isSilver) _buildUpgradeToGoldCard(),

          const SizedBox(height: 16),

          // Gerenciar assinatura
          OutlinedButton.icon(
            onPressed: () async {
              try {
                final stripeService = StripeService();
                final portalUrl = await stripeService.createPortalSession();

                if (portalUrl != null && context.mounted) {
                  // Abrir portal Stripe
                  // TODO: Implementar url_launcher
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🔗 Portal: $portalUrl')));
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Erro ao abrir portal')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
                }
              }
            },
            icon: const Icon(Icons.settings),
            label: const Text('Gerenciar Assinatura'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String check, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(check, style: TextStyle(fontSize: 18, color: color ?? Colors.green)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 15, color: color ?? Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeToGoldCard() {
    return Card(
      color: const Color(0xFFFFD700).withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFFFD700), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '⬆️ Upgrade para Gold',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
            ),
            const SizedBox(height: 12),
            Text(
              'Desbloqueie Ver Quem Curtiu, Top Picks IA, Modo Invisível e mais',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade300),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showUpgradeToGoldModal(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Fazer Upgrade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFF1E1E2E), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showYearlyPrice = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_showYearlyPrice ? Colors.deepPurple : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Mensal',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showYearlyPrice = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _showYearlyPrice ? Colors.deepPurple : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Anual',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6)),
                      child: const Text(
                        '-25%',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSilverCard() {
    final monthlyPrice = 'R\$ 14,90';
    final yearlyPrice = 'R\$ 149,90';
    final yearlyMonthly = 'R\$ 12,49/mês';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFC0C0C0), width: 2),
        ),
        color: const Color(0xFF1E1E2E),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFFC0C0C0).withOpacity(0.1), Colors.transparent],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const BadgeIcon(badge: VerificationBadge.silver, size: 32, showShadow: true),
                    const SizedBox(width: 12),
                    const Text(
                      'SELO SILVER',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFC0C0C0)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.card_giftcard, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        '7 DIAS GRÁTIS',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Preço
                if (_showYearlyPrice) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        yearlyPrice,
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Text('/ano', style: TextStyle(fontSize: 16, color: Colors.white54)),
                    ],
                  ),
                  Text(yearlyMonthly, style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        monthlyPrice,
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Text('/mês', style: TextStyle(fontSize: 16, color: Colors.white54)),
                    ],
                  ),
                ],

                const SizedBox(height: 24),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),

                // Features
                _buildFeature('✓', 'Super Likes/mês', icon: Icons.star, iconColor: Colors.amber, count: '10'),
                _buildFeature('✓', 'Match Mágico/mês', icon: Icons.auto_fix_high, iconColor: Colors.purple, count: '5'),
                _buildFeature('✓', 'Replays/mês', icon: Icons.replay, iconColor: Colors.blue, count: '5'),
                _buildFeature('✓', 'Boosts/mês', icon: Icons.rocket_launch, iconColor: Colors.deepPurple, count: '5'),
                _buildFeature('✓', 'Ver quem curtiu você', icon: Icons.visibility, iconColor: Colors.green),
                _buildFeature('✓', 'Ocultar status online', icon: Icons.visibility_off, iconColor: Colors.grey),
                _buildFeature(
                  '✓',
                  'Ocultar visto por último',
                  icon: Icons.remove_red_eye_outlined,
                  iconColor: Colors.grey,
                ),
                _buildFeature('✓', 'IA Chat 24/7 em tempo real', icon: Icons.chat_bubble, iconColor: Colors.lightBlue),

                const SizedBox(height: 24),

                // CTA
                Builder(builder: (context) {
                  final badge = ref.watch(currentUserProfileProvider).value?.verificationBadge;
                  final isSilver = badge == VerificationBadge.silver;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSilver ? null : () => _subscribeSilver(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSilver ? Colors.grey.shade600 : const Color(0xFFC0C0C0),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isSilver ? '✓ Já é Silver' : 'Começar Teste Grátis',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoldCard() {
    final monthlyPrice = 'R\$ 29,90';
    final yearlyPrice = 'R\$ 249,90';
    final yearlyMonthly = 'R\$ 20,82/mês';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFFFD700), width: 3),
            ),
            color: const Color(0xFF1E1E2E),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFFFD700).withOpacity(0.15), Colors.transparent],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const BadgeIcon(badge: VerificationBadge.gold, size: 32, showShadow: true),
                        const SizedBox(width: 12),
                        const Text(
                          'SELO GOLD',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Preço
                    if (_showYearlyPrice) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            yearlyPrice,
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const Text('/ano', style: TextStyle(fontSize: 16, color: Colors.white54)),
                        ],
                      ),
                      Text(yearlyMonthly, style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                    ] else ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            monthlyPrice,
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const Text('/mês', style: TextStyle(fontSize: 16, color: Colors.white54)),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 16),

                    // Features
                    _buildFeature(
                      '✓',
                      'Filtro internacional',
                      icon: Icons.public,
                      iconColor: Colors.blue,
                      color: const Color(0xFFFFD700),
                    ),
                    _buildFeature(
                      '✓',
                      'Match Mágico/mês',
                      icon: Icons.auto_fix_high,
                      iconColor: Colors.purple,
                      count: '15',
                      color: const Color(0xFFFFD700),
                    ),
                    _buildFeature(
                      '✓',
                      'Super Likes/mês',
                      icon: Icons.star,
                      iconColor: Colors.amber,
                      count: '15',
                      color: const Color(0xFFFFD700),
                    ),
                    _buildFeature(
                      '✓',
                      'Boosts/mês',
                      icon: Icons.rocket_launch,
                      iconColor: Colors.deepPurple,
                      count: '10',
                      color: const Color(0xFFFFD700),
                    ),
                    _buildFeature(
                      '✓',
                      'Replay ILIMITADO',
                      icon: Icons.replay,
                      iconColor: Colors.cyan,
                      color: const Color(0xFFFFD700),
                    ),
                    _buildFeature('✓ 🔍', 'Ver quem curtiu você', color: const Color(0xFFFFD700)),
                    _buildFeature('✓ 👻', 'Ocultar status online', color: const Color(0xFFFFD700)),
                    _buildFeature('✓ 👁️', 'Ocultar visto por último', color: const Color(0xFFFFD700)),
                    _buildFeature('✓ 📸', 'IA análise de fotos', color: const Color(0xFFFFD700)),
                    _buildFeature('✓ ✍️', 'IA bio otimizada', color: const Color(0xFFFFD700)),
                    _buildFeature('✓ 💬', 'IA Chat 24/7 em tempo real', color: const Color(0xFFFFD700)),
                    _buildFeature('✓ 💡', 'IA Coach de relacionamento', color: const Color(0xFFFFD700)),
                    _buildFeature(
                      '✓ 📊',
                      'IA Insights de mercado',
                      iconColor: Colors.orange,
                      color: const Color(0xFFFFD700),
                    ),

                    const SizedBox(height: 24),

                    // CTA
                    Builder(builder: (context) {
                      final badge = ref.watch(currentUserProfileProvider).value?.verificationBadge;
                      final isGold = badge == VerificationBadge.gold;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isGold ? null : () => _subscribeGold(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isGold ? Colors.grey.shade600 : const Color(0xFFFFD700),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: isGold ? 0 : 8,
                          ),
                          child: Text(
                            isGold ? '✓ Já é Gold' : 'Escolher Gold',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Badge "MAIS POPULAR"
          Positioned(
            top: 0,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFD4AF37)]),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('🏆', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 4),
                  Text(
                    'MAIS POPULAR',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String check, String text, {Color? color, IconData? icon, Color? iconColor, String? count}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(check, style: TextStyle(fontSize: 16, color: color ?? Colors.green)),
          const SizedBox(width: 10),
          if (icon != null) ...[
            Icon(icon, size: 20, color: iconColor ?? color ?? Colors.white70),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              count != null ? '$count $text' : text,
              style: TextStyle(fontSize: 14, color: color ?? Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparação Rápida',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E1E2E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(flex: 2, child: SizedBox()),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            BadgeIcon(badge: VerificationBadge.silver, size: 14, showShadow: false),
                            SizedBox(width: 4),
                            Text(
                              'Silver',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0C0C0), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            BadgeIcon(badge: VerificationBadge.gold, size: 14, showShadow: false),
                            SizedBox(width: 4),
                            Text(
                              'Gold',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFD700), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Gold',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFD700), fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildComparisonRow('Likes/dia', '30', '∞', '∞'),
                  _buildComparisonRow('Desfazer', '❌', '✅', '✅'),
                  _buildComparisonRow('Ver quem curtiu', '❌', '❌', '✅'),
                  _buildComparisonRow('Top Picks IA', '❌', '❌', '✅'),
                  _buildComparisonRow('Modo invisível', '❌', '❌', '✅'),
                  _buildComparisonRow('Prioridade', '❌', '❌', '✅'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String feature, String free, String silver, String gold) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(feature, style: const TextStyle(fontSize: 13, color: Colors.white70)),
          ),
          Expanded(
            child: Text(
              free,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              silver,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFFC0C0C0), fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              gold,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
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
          const Text(
            'Por que conquistar um Selo?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildBenefitCard(
            emoji: '💚',
            title: '3x Mais Matches',
            description: 'Usuários com selo recebem até 3x mais matches. Destaque-se!',
          ),
          _buildBenefitCard(
            emoji: '⚡',
            title: 'Respostas Mais Rápidas',
            description: 'Seu perfil aparece primeiro. Boosts e prioridade no algoritmo.',
          ),
          _buildBenefitCard(
            emoji: '🎯',
            title: 'Encontre Exatamente o Que Busca',
            description: 'Filtros avançados: rating, certificações, disponibilidade, etc.',
          ),
          _buildBenefitCard(
            emoji: '🔒',
            title: 'Total Controle e Privacidade',
            description: 'Modo invisível, controle de visibilidade, sem anúncios.',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard({required String emoji, required String title, required String description}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perguntas Frequentes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            icon: Icons.help_outline,
            iconColor: Colors.redAccent,
            question: 'Posso cancelar quando quiser?',
            answer: 'Sim! Cancele a qualquer momento. Você mantém o acesso até o fim do período pago.',
          ),
          _buildFAQItem(
            icon: Icons.credit_card,
            iconColor: Colors.blueAccent,
            question: 'Como funciona o trial de 7 dias?',
            answer: 'Silver tem 7 dias grátis. Após o trial, cobramos automaticamente se não cancelar.',
          ),
          _buildFAQItem(
            icon: Icons.upgrade,
            iconColor: Colors.greenAccent,
            question: 'Posso fazer upgrade de Silver para Gold?',
            answer: 'Sim! Upgrade a qualquer momento. Ajustamos proporcionalmente o valor.',
          ),
          _buildFAQItem(
            icon: Icons.star_border,
            iconColor: Colors.amber,
            question: 'Qual a diferença entre Silver e Gold?',
            answer:
                'Silver: essencial (likes ilimitados, rewind, passaporte). Gold: completo (tudo + ver quem curtiu, top picks, modo invisível, analytics).',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required IconData icon,
    required Color iconColor,
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(icon, size: 32, color: iconColor),
        title: Text(
          question,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white54,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
          ),
        ],
      ),
    );
  }

  // ==================== STRIPE CHECKOUT ====================

  Future<void> _subscribeSilver() async {
    final analytics = ref.read(analyticsServiceProvider);

    await analytics.logEvent(
      name: 'selo_silver_selected',
      parameters: {'pricing_mode': _showYearlyPrice ? 'yearly' : 'monthly'},
    );

    _showLoadingDialog();

    try {
      final stripeService = StripeService();

      // Timeout de 15 segundos para evitar loading infinito
      final url =
          await (_showYearlyPrice ? stripeService.subscribeSilverYearly() : stripeService.subscribeSilverMonthly())
              .timeout(
                const Duration(seconds: 15),
                onTimeout: () {
                  throw TimeoutException('Timeout ao conectar com Stripe');
                },
              );

      if (!mounted) return;
      Navigator.pop(context); // Remove loading

      if (url != null && url.isNotEmpty) {
        // TODO: Abrir URL com url_launcher
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('🛒 Abrindo checkout...'), backgroundColor: Colors.blue));
      } else {
        await analytics.logEvent(name: 'checkout_failed', parameters: {'plan': 'silver', 'error': 'url_null'});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Erro: URL de checkout inválida. Tente novamente.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Remove loading em caso de erro

      await analytics.logEvent(name: 'checkout_error', parameters: {'plan': 'silver', 'error': e.toString()});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ ${e is TimeoutException ? "Timeout: servidor demorou muito" : "Erro ao conectar"}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(label: 'Tentar Novamente', textColor: Colors.white, onPressed: _subscribeSilver),
        ),
      );
    }
  }

  Future<void> _subscribeGold() async {
    final analytics = ref.read(analyticsServiceProvider);

    await analytics.logEvent(
      name: 'selo_gold_selected',
      parameters: {'pricing_mode': _showYearlyPrice ? 'yearly' : 'monthly'},
    );

    _showLoadingDialog();

    try {
      final stripeService = StripeService();

      // Timeout de 15 segundos para evitar loading infinito
      final url = await (_showYearlyPrice ? stripeService.subscribeGoldYearly() : stripeService.subscribeGoldMonthly())
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException('Timeout ao conectar com Stripe');
            },
          );

      if (!mounted) return;
      Navigator.pop(context); // Remove loading

      if (url != null && url.isNotEmpty) {
        await UrlLauncherHelper.openCheckoutUrl(context, url, plan: 'Gold');
      } else {
        await analytics.logEvent(name: 'checkout_failed', parameters: {'plan': 'gold', 'error': 'url_null'});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Erro: URL de checkout inválida. Tente novamente.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Remove loading em caso de erro

      await analytics.logEvent(name: 'checkout_error', parameters: {'plan': 'gold', 'error': e.toString()});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ ${e is TimeoutException ? "Timeout: servidor demorou muito" : "Erro ao conectar"}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(label: 'Tentar Novamente', textColor: Colors.white, onPressed: _subscribeGold),
        ),
      );
    }
  }

  void _showUpgradeToGoldModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Row(
          children: [
            BadgeIcon(badge: VerificationBadge.gold, size: 32, showShadow: true),
            SizedBox(width: 12),
            Text('Upgrade para Gold', style: TextStyle(color: Color(0xFFFFD700))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Desbloqueie os recursos mais poderosos:', style: TextStyle(color: Colors.grey.shade300)),
            const SizedBox(height: 16),
            _buildFeature(
              '✓',
              'Ver Quem Curtiu Você',
              icon: Icons.visibility,
              iconColor: const Color(0xFFFFD700),
              color: const Color(0xFFFFD700),
            ),
            _buildFeature(
              '✓',
              'Top Picks Diários (IA)',
              icon: Icons.stars,
              iconColor: const Color(0xFFFFD700),
              color: const Color(0xFFFFD700),
            ),
            _buildFeature(
              '✓',
              'Modo Invisível',
              icon: Icons.visibility_off,
              iconColor: const Color(0xFFFFD700),
              color: const Color(0xFFFFD700),
            ),
            _buildFeature(
              '✓',
              'Analytics Completo',
              icon: Icons.analytics,
              iconColor: const Color(0xFFFFD700),
              color: const Color(0xFFFFD700),
            ),
            const SizedBox(height: 8),
            Text('Apenas R\$ 30,00 adicionais/mês', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade400)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _subscribeGold();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
            child: const Text('Fazer Upgrade'),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          color: Color(0xFF1E1E2E),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Criando checkout...', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
