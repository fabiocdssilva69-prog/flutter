import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/stripe_service.dart';
import '../../../core/theme/app_backgrounds.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../../domain/entities/enums.dart';
import '../../profile/controllers/profile_controller.dart';
import '../utils/badge_colors.dart';

class BadgesShopScreen extends ConsumerStatefulWidget {
  const BadgesShopScreen({super.key});

  @override
  ConsumerState<BadgesShopScreen> createState() => _BadgesShopScreenState();
}

class _BadgesShopScreenState extends ConsumerState<BadgesShopScreen> {
  bool _showYearlyPrice = true;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentUserProfileProvider);

    return AppBackgrounds.scaffold(
      child: CustomScrollView(
        slivers: [
          // AppBar
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFFD700).withOpacity(0.8),
                      const Color(0xFFC0C0C0).withOpacity(0.8),
                      const Color(0xFFD4AF37).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BadgeIcon(badge: VerificationBadge.silver, size: 60, showShadow: true),
                      const SizedBox(width: 16),
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

  Widget _buildContent(BuildContext context, profile) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Destaque-se com um Selo Verificado',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Tenha mais matches, recursos exclusivos e prioridade',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Toggle Mensal/Anual
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPriceToggle('Mensal', !_showYearlyPrice, () {
                setState(() => _showYearlyPrice = false);
              }),
              const SizedBox(width: 16),
              _buildPriceToggle('Anual', _showYearlyPrice, () {
                setState(() => _showYearlyPrice = true);
              }, badge: '-25%'),
            ],
          ),
          const SizedBox(height: 32),

          // Card Silver
          _buildSilverCard(),
          const SizedBox(height: 24),

          // Card Gold
          _buildGoldCard(),
          const SizedBox(height: 40),

          // FAQ
          _buildFAQ(),
        ],
      ),
    );
  }

  Widget _buildPriceToggle(String label, bool isSelected, VoidCallback onTap, {String? badge}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  badge,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSilverCard() {
    final monthlyPrice = 'R\$ 14,90';
    final yearlyPrice = 'R\$ 149,90';
    final yearlyMonthly = 'R\$ 12,49/mês';

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFC0C0C0), width: 2),
      ),
      color: const Color(0xFF1E1E2E),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                BadgeIcon(badge: VerificationBadge.silver, size: 40, showShadow: true),
                const SizedBox(width: 12),
                const Text(
                  'SELO SILVER',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFC0C0C0)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Badge 7 dias grátis
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('🎁', style: TextStyle(fontSize: 14)),
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
            _buildFeature('⭐', '10 Super Likes/mês'),
            _buildFeature('🔮', '5 Match Mágico/mês'),
            _buildFeature('🔄', '5 Replays/mês'),
            _buildFeature('🚀', '5 Boosts/mês'),

            const SizedBox(height: 24),

            // Botão
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleSilverCheckout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC0C0C0),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Escolher Silver', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldCard() {
    final monthlyPrice = 'R\$ 29,90';
    final yearlyPrice = 'R\$ 249,90';
    final yearlyMonthly = 'R\$ 20,82/mês';

    return Stack(
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
                  // Header
                  Row(
                    children: [
                      BadgeIcon(badge: VerificationBadge.gold, size: 40, showShadow: true),
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
                  _buildFeature('🌎', 'Filtro internacional', isGold: true),
                  _buildFeature('🔮', '15 Match Mágico/mês', isGold: true),
                  _buildFeature('⭐', '15 Super Likes/mês', isGold: true),
                  _buildFeature('🚀', '10 Boosts/mês', isGold: true),
                  _buildFeature('🔄', 'Replay ILIMITADO', isGold: true),
                  _buildFeature('🔍', 'Ver quem curtiu você', isGold: true),
                  _buildFeature('👻', 'Ocultar status online', isGold: true),
                  _buildFeature('👁️', 'Ocultar visto por último', isGold: true),
                  _buildFeature('📸', 'IA análise de fotos', isGold: true),
                  _buildFeature('✍️', 'IA bio otimizada', isGold: true),
                  _buildFeature('💬', 'IA Chat 24/7 em tempo real', isGold: true),
                  _buildFeature('💡', 'IA Coach de relacionamento', isGold: true),
                  _buildFeature('📊', 'IA Insights de mercado', isGold: true),

                  const SizedBox(height: 24),

                  // Botão
                  Builder(builder: (ctx) {
                    final badge = ref.watch(currentUserProfileProvider).value?.verificationBadge;
                    final alreadyGold = badge == VerificationBadge.gold;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: alreadyGold ? null : () => _handleGoldCheckout(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: alreadyGold ? Colors.grey.shade600 : const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: alreadyGold ? 0 : 8,
                        ),
                        child: Text(
                          alreadyGold ? '✓ Já é Gold' : 'Escolher Gold',
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
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
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
    );
  }

  Widget _buildFeature(String emoji, String text, {bool isGold = false, IconData? icon, Color? iconBgColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Text(
            '✓',
            style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          if (icon != null && iconBgColor != null)
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
              child: Center(child: Icon(icon, size: 16, color: Colors.white)),
            )
          else
            Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isGold ? const Color(0xFFFFD700) : Colors.white70,
                fontWeight: isGold ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perguntas Frequentes',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
          '❓',
          Colors.redAccent,
          'Posso cancelar quando quiser?',
          'Sim! Cancele a qualquer momento. Você mantém o acesso até o fim do período pago.',
        ),
        _buildFAQItem(
          '💳',
          Colors.blueAccent,
          'Como funciona o trial de 7 dias?',
          'Silver tem 7 dias grátis. Após o trial, cobramos automaticamente se não cancelar.',
        ),
        _buildFAQItem(
          '⬆️',
          Colors.greenAccent,
          'Posso fazer upgrade de Silver para Gold?',
          'Sim! Upgrade a qualquer momento. Ajustamos proporcionalmente o valor.',
        ),
        _buildFAQItem(
          '⭐',
          Colors.amber,
          'Qual a diferença entre Silver e Gold?',
          'Silver: essencial (likes ilimitados, rewind, passaporte). Gold: completo (tudo + ver quem curtiu, top picks, modo invisível, analytics).',
        ),
      ],
    );
  }

  Widget _buildFAQItem(String emoji, Color iconColor, String question, String answer) {
    return _FAQItemWidget(emoji: emoji, iconColor: iconColor, question: question, answer: answer);
  }

  Future<void> _handleSilverCheckout(BuildContext context) async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Criando checkout...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final stripeService = ref.read(stripeServiceProvider);
      final url = _showYearlyPrice
          ? await stripeService.subscribeSilverYearly().timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Timeout: servidor demorou mais de 30 segundos'),
            )
          : await stripeService.subscribeSilverMonthly().timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Timeout: servidor demorou mais de 30 segundos'),
            );

      if (mounted) Navigator.pop(context); // Fechar loading

      if (url != null && mounted) {
        await UrlLauncherHelper.openCheckoutUrl(context, url, plan: 'Selo Silver');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '❌ Erro: URL de checkout não foi criada. Verifique se a extensão Firebase Stripe está instalada.',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Fechar loading em caso de erro

      if (mounted) {
        String errorMsg = '❌ Erro ao processar compra';
        if (e is TimeoutException) {
          errorMsg =
              '❌ Timeout: O servidor demorou mais de 30 segundos.\n\nPossíveis causas:\n- Extensão Firebase Stripe não instalada\n- Conexão lenta\n- Firestore sem regras corretas';
        } else if (e.toString().contains('Usuário não autenticado')) {
          errorMsg = '❌ Você precisa estar logado para fazer uma compra';
        }

        print('❌ [badges_shop_screen] Erro no checkout Silver: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Tentar Novamente',
              textColor: Colors.white,
              onPressed: () => _handleSilverCheckout(context),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleGoldCheckout(BuildContext context) async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Criando checkout...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final stripeService = ref.read(stripeServiceProvider);
      final url = _showYearlyPrice
          ? await stripeService.subscribeGoldYearly().timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Timeout: servidor demorou mais de 30 segundos'),
            )
          : await stripeService.subscribeGoldMonthly().timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Timeout: servidor demorou mais de 30 segundos'),
            );

      if (mounted) Navigator.pop(context); // Fechar loading

      if (url != null && mounted) {
        await UrlLauncherHelper.openCheckoutUrl(context, url, plan: 'Selo Gold');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '❌ Erro: URL de checkout não foi criada. Verifique se a extensão Firebase Stripe está instalada.',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Fechar loading em caso de erro

      if (mounted) {
        String errorMsg = '❌ Erro ao processar compra';
        if (e is TimeoutException) {
          errorMsg =
              '❌ Timeout: O servidor demorou mais de 30 segundos.\n\nPossíveis causas:\n- Extensão Firebase Stripe não instalada\n- Conexão lenta\n- Firestore sem regras corretas';
        } else if (e.toString().contains('Usuário não autenticado')) {
          errorMsg = '❌ Você precisa estar logado para fazer uma compra';
        }

        print('❌ [badges_shop_screen] Erro no checkout Gold: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Tentar Novamente',
              textColor: Colors.white,
              onPressed: () => _handleGoldCheckout(context),
            ),
          ),
        );
      }
    }
  }
}

class _FAQItemWidget extends StatefulWidget {
  final String emoji;
  final Color iconColor;
  final String question;
  final String answer;

  const _FAQItemWidget({required this.emoji, required this.iconColor, required this.question, required this.answer});

  @override
  State<_FAQItemWidget> createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<_FAQItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: widget.iconColor.withOpacity(0.2), shape: BoxShape.circle),
          child: Center(child: Text(widget.emoji, style: const TextStyle(fontSize: 24))),
        ),
        title: Text(
          widget.question,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        trailing: Text(_isExpanded ? '➖' : '➕', style: const TextStyle(fontSize: 20, color: Colors.white)),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(widget.answer, style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
          ),
        ],
      ),
    );
  }
}
