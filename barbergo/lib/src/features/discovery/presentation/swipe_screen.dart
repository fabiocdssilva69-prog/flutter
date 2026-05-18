import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../providers/consumables_providers.dart';
import '../../../../services/dev_cleanup_service.dart';
import '../../../../services/stripe_service.dart';
import '../../../../services/super_like_service_simple.dart';
import '../../../core/services/swipe_cache.dart';
import '../../../core/theme/app_backgrounds.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../../core/widgets/custom_icons/barber_icons.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/match_repository.dart';
import '../../../data/repositories/swipe_repository.dart';
import '../../../data/services/likes_service.dart'; // 🪄 Added for Magic Match
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/subscription.dart';
import '../../../routing/navigation_lock.dart';
import '../../chat/presentation/chat_screen.dart';
import '../../chat/repositories/chat_repository.dart';
import '../../matches/presentation/widgets/match_celebration_dialog.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/screens/profile_detail_screen.dart';
import '../../subscription/controllers/subscription_controller.dart';
import '../controllers/discovery_controller.dart';
import '../controllers/swipe_controller.dart';
import '../models/discovery_filters.dart';
import 'widgets/boost_button.dart';
import 'widgets/dislike_icon_painter.dart';
import 'widgets/filters_bottom_sheet.dart';
import 'widgets/like_icon_painter.dart';
import 'widgets/magic_match_icon_painter.dart';
import 'widgets/profile_card.dart';
import 'widgets/replay_icon_painter.dart';
import 'widgets/super_like_icon_painter.dart';

// 🪄 Provider para LikesService
final likesServiceProvider = Provider<LikesService>((ref) {
  final currentUser = ref.watch(authRepositoryProvider).currentUser;
  return LikesService(currentUserId: currentUser?.uid ?? '');
});

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen> with WidgetsBindingObserver {
  final CardSwiperController _swiperController = CardSwiperController();
  DateTime? _lastRefreshTime;
  DateTime? _profileViewStartTime; // Para medir tempo em cada perfil
  final int _likeCount = 0; // Removido final para permitir incremento
  final int _dislikeCount = 0; // Removido final para permitir incremento
  int _currentIndex = 0; // Rastreamento manual do índice atual
  int _likesReceivedCount = 0; // NOVO: Contagem de likes recebidos
  final List<String> _swipedProfileIds = []; // Rastreia IDs de perfis que foram swipados (para Replay)
  int _totalSwipedCount = 0; // 🌍 NOVO: Total de perfis swipados nesta sessão
  bool _isProcessingSuperLike = false; // 🔥 Flag para prevenir swipe duplo
  bool _isProcessingClientLike = false; // 🔥 Flag para prevenir swipe duplo quando cliente clica like

  // 💎 CONTADOR LOCAL OTIMISTA de Super Likes (decrementa imediatamente na UI)
  int? _localSuperLikesCount; // null = não carregado ainda

  // 🪄 CONTADOR LOCAL OTIMISTA de Magic Matches (decrementa imediatamente na UI)
  int? _localMagicMatchCount; // null = não carregado ainda

  // ↩️ CONTADOR LOCAL OTIMISTA de Replays (decrementa imediatamente na UI)
  int? _localReplayCount; // null = não carregado ainda

  // 💙 ValueNotifier para controlar overlay azul SEM REBUILD
  final ValueNotifier<bool> _showSuperLikeOverlay = ValueNotifier<bool>(false);
  // 🟠 Overlay laranja para Replay
  final ValueNotifier<bool> _showReplayOverlay = ValueNotifier<bool>(false);
  // 🟣 Overlay roxo para Magic Match
  final ValueNotifier<bool> _showMagicMatchOverlay = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    print('🔥🔥🔥 [INIT STATE] SwipeScreen.initState() CHAMADO - ${DateTime.now()}');
    print('🔥🔥🔥 [INIT STATE] Isso NÃO deveria acontecer durante Super Like!');

    WidgetsBinding.instance.addObserver(this);
    _lastRefreshTime = DateTime.now();
    _profileViewStartTime = DateTime.now();
    _loadLikesReceivedCount(); // Carregar contagem de likes

    // 🗑️ LIMPAR DADOS NO HOT RESTART (apenas em debug)
    // ⚠️ DESABILITADO: Estava causando hot restart ao clicar em Super Like
    // if (kDebugMode) {
    //   _performCleanupOnStart();
    // }
  }

  /// Limpa dados do Firebase a cada hot restart (apenas debug)
  /// ⚠️ DESABILITADO: Causava hot restart não intencional
  Future<void> _performCleanupOnStart() async {
    try {
      debugPrint('🔥 [Hot Restart] Detectado - iniciando limpeza...');
      await DevCleanupService.clearAllTestData();

      // Invalidar cache local também
      SwipeCache.clearCache();
      ref.invalidate(discoverProfilesProvider);

      debugPrint('✅ [Hot Restart] Limpeza concluída - banco limpo!');
    } catch (e) {
      debugPrint('❌ [Hot Restart] Erro na limpeza: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Quando app retorna do background, verifica se precisa atualizar cache
    if (state == AppLifecycleState.resumed && _lastRefreshTime != null) {
      final timeSinceLastRefresh = DateTime.now().difference(_lastRefreshTime!);

      // Se passou mais de 5 minutos, invalida cache para buscar novos perfis
      if (timeSinceLastRefresh.inMinutes >= 5) {
        debugPrint('🔄 [SmartRefresh] App resumed after ${timeSinceLastRefresh.inMinutes}min - invalidating cache');
        SwipeCache.clearCache();
        ref.invalidate(discoverProfilesProvider);
        _lastRefreshTime = DateTime.now();
      } else {
        debugPrint('✅ [SmartRefresh] Cache still valid (${timeSinceLastRefresh.inMinutes}min old)');
      }
    }
  }

  // ⚠️ REMOVIDO: _preloadNextImages causava loop infinito de rebuilds (30+ logs/segundo)
  // CachedNetworkImage já faz cache automático - preload manual é redundante e desnecessário

  Future<void> _loadLikesReceivedCount() async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    final count = await ref.read(swipeRepositoryProvider).countLikesReceived(currentUser.uid);
    if (mounted) {
      setState(() => _likesReceivedCount = count);
    }
  }

  // Verificar se usuário pode ver likes (Elite)
  bool get _canSeeLikes {
    final tierAsync = ref.watch(currentUserTierProvider);
    return tierAsync.when(
      data: (tier) => tier.index >= SubscriptionTier.elite.index,
      loading: () => false,
      error: (_, __) => false,
    );
  }

  // Verificar se usuário tem Selo Gold
  bool get _hasGoldSeal {
    final tierAsync = ref.watch(currentUserTierProvider);
    return tierAsync.when(
      data: (tier) => tier == SubscriptionTier.elite,
      loading: () => false,
      error: (_, __) => false,
    );
  }

  // 🪄 Helper para abrir dialog de compra de Magic Match
  void _showBuyMagicMatchDialog(BuildContext context) {
    _showPurchaseDialog(context, isPurchasingBoosts: false, isMagicMatch: true);
  }

  void _showSwipeLimitModal() {
    final profile = ref.read(currentUserProfileProvider).value;
    final isSilver = profile?.verificationBadge.toString().contains('silver') ?? false;
    final limit = isSilver ? 15 : 5;
    final resetH = isSilver ? 12 : 24;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⏸️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Limite de swipes atingido',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Você usou seus $limit swipes${isSilver ? " (Silver)" : " (Free)"}.\nVolta em $resetH horas ou faça upgrade! 🚀',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white54, side: const BorderSide(color: Colors.white24)),
                  child: const Text('Aguardar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/badges-shop');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
                  child: const Text('Fazer Upgrade', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog(
    BuildContext context, {
    required bool isPurchasingBoosts,
    bool isMagicMatch = false,
    bool isReplay = false,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            if (isPurchasingBoosts)
              const Text('🚀', style: TextStyle(fontSize: 28))
            else if (isMagicMatch)
              const Text('🪄', style: TextStyle(fontSize: 28))
            else if (isReplay)
              const Text('↩️', style: TextStyle(fontSize: 28))
            else
              SizedBox(
                width: 32,
                height: 32,
                child: CustomPaint(size: const Size(32, 32), painter: SuperLikeIconPainter(isPressed: false)),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isPurchasingBoosts
                    ? 'Comprar Boosts'
                    : isMagicMatch
                    ? 'Comprar Magic Match'
                    : isReplay
                    ? 'Comprar Replay'
                    : 'Comprar Super Likes',
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPurchasingBoosts
                  ? 'Escolha um pacote de Boosts para aumentar sua visibilidade:'
                  : isMagicMatch
                  ? 'Escolha um pacote de Magic Match para criar matches instantâneos:'
                  : isReplay
                  ? 'Escolha um pacote de Replay para desfazer dislikes:'
                  : 'Escolha um pacote de Super Likes para se destacar:',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (isPurchasingBoosts) ...[
              _buildPackageOption(ctx, '🚀 5 Boosts', 'R\$ 4,90', () => _purchaseBoosts(ctx, 5), isBoost: true),
              const SizedBox(height: 8),
              _buildPackageOption(ctx, '🚀 10 Boosts', 'R\$ 9,90', () => _purchaseBoosts(ctx, 10), isBoost: true),
              const SizedBox(height: 8),
              _buildPackageOption(ctx, '🚀 20 Boosts', 'R\$ 17,90', () => _purchaseBoosts(ctx, 20), isBoost: true),
            ] else if (isMagicMatch) ...[
              _buildPackageOption(
                ctx,
                '🪄 3 Magic Match',
                'R\$ 4,90',
                () => _purchaseMagicMatch(ctx, 3),
                isMagicMatch: true,
              ),
              const SizedBox(height: 8),
              _buildPackageOption(
                ctx,
                '🪄 10 Magic Match',
                'R\$ 11,90',
                () => _purchaseMagicMatch(ctx, 10),
                isMagicMatch: true,
              ),
              const SizedBox(height: 8),
              _buildPackageOption(
                ctx,
                '🪄 25 Magic Match',
                'R\$ 19,90',
                () => _purchaseMagicMatch(ctx, 25),
                isMagicMatch: true,
              ),
            ] else if (isReplay) ...[
              _buildPackageOption(ctx, '↩️ 10 Replay', 'R\$ 4,90', () => _purchaseReplay(ctx, 10), isReplay: true),
              const SizedBox(height: 8),
              _buildPackageOption(ctx, '↩️ 20 Replay', 'R\$ 9,90', () => _purchaseReplay(ctx, 20), isReplay: true),
              const SizedBox(height: 8),
              _buildPackageOption(ctx, '↩️ 50 Replay', 'R\$ 19,90', () => _purchaseReplay(ctx, 50), isReplay: true),
            ] else ...[
              _buildPackageOption(
                ctx,
                '⚡ 10 Super Likes',
                'R\$ 8,90',
                () => _purchaseSuperLikes(ctx, 10),
                isBoost: false,
              ),
              const SizedBox(height: 8),
              _buildPackageOption(
                ctx,
                '⚡ 20 Super Likes',
                'R\$ 9,90',
                () => _purchaseSuperLikes(ctx, 20),
                isBoost: false,
              ),
              const SizedBox(height: 8),
              _buildPackageOption(
                ctx,
                '⚡ 50 Super Likes',
                'R\$ 19,90',
                () => _purchaseSuperLikes(ctx, 50),
                isBoost: false,
              ),
            ],
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar'))],
      ),
    );
  }

  Widget _buildPackageOption(
    BuildContext ctx,
    String title,
    String price,
    VoidCallback onTap, {
    bool isBoost = false,
    bool isMagicMatch = false,
    bool isReplay = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (isBoost)
                    const Text('🚀', style: TextStyle(fontSize: 20))
                  else if (isMagicMatch)
                    const Text('🪄', style: TextStyle(fontSize: 20))
                  else if (isReplay)
                    const Text('↩️', style: TextStyle(fontSize: 20))
                  else
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CustomPaint(size: const Size(24, 24), painter: SuperLikeIconPainter(isPressed: false)),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title.replaceAll('🚀 ', '').replaceAll('⚡ ', '').replaceAll('🪄 ', '').replaceAll('↩️ ', ''),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchaseBoosts(BuildContext ctx, int quantity) async {
    Navigator.of(ctx).pop(); // Fechar dialog

    try {
      final currentUser = ref.read(authRepositoryProvider).currentUser;
      if (currentUser == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Usuário não autenticado')));
        return;
      }

      // Chamar StripeService baseado na quantidade
      final stripeService = ref.read(stripeServiceProvider);
      String? checkoutUrl;

      if (quantity == 5) {
        checkoutUrl = await stripeService.buyBoosts5().timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw TimeoutException('Timeout: servidor demorou muito'),
        );
      } else if (quantity == 10) {
        checkoutUrl = await stripeService.buyBoosts10().timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw TimeoutException('Timeout: servidor demorou muito'),
        );
      } else if (quantity == 20) {
        checkoutUrl = await stripeService.buyBoosts20().timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw TimeoutException('Timeout: servidor demorou muito'),
        );
      }

      if (!mounted) return;

      if (checkoutUrl != null) {
        await UrlLauncherHelper.openCheckoutUrl(context, checkoutUrl, plan: '$quantity Boosts');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('❌ Erro ao criar sessão de pagamento')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro ao processar compra: $e')));
    }
  }

  Future<void> _purchaseSuperLikes(BuildContext ctx, int quantity) async {
    Navigator.of(ctx).pop(); // Fechar dialog

    try {
      final currentUser = ref.read(authRepositoryProvider).currentUser;
      if (currentUser == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Usuário não autenticado')));
        return;
      }

      // Chamar StripeService baseado na quantidade
      final stripeService = ref.read(stripeServiceProvider);
      String? checkoutUrl;

      if (quantity == 10) {
        checkoutUrl = await stripeService.buySuperLikes10();
      } else if (quantity == 20) {
        checkoutUrl = await stripeService.buySuperLikes20();
      } else if (quantity == 50) {
        checkoutUrl = await stripeService.buySuperLikes50();
      }

      if (!mounted) return;

      if (checkoutUrl != null) {
        final uid = currentUser.uid;
        final productId = 'superLikes$quantity';
        final urlWithRef = '$checkoutUrl?client_reference_id=${uid}_$productId';
        await UrlLauncherHelper.openCheckoutUrl(context, urlWithRef, plan: '$quantity Super Likes');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('❌ Erro ao criar sessão de pagamento')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro ao processar compra: $e')));
    }
  }

  Future<String?> _purchaseMagicMatch(BuildContext ctx, int quantity) async {
    Navigator.of(ctx).pop(); // Fechar dialog

    try {
      final currentUser = ref.read(authRepositoryProvider).currentUser;
      if (currentUser == null) {
        if (!mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Usuário não autenticado')));
        return null;
      }

      // Chamar StripeService baseado na quantidade
      final stripeService = ref.read(stripeServiceProvider);
      String? checkoutUrl;

      if (quantity == 3) {
        checkoutUrl = await stripeService.buyMagicMatch3();
      } else if (quantity == 10) {
        checkoutUrl = await stripeService.buyMagicMatch10();
      } else if (quantity == 25) {
        checkoutUrl = await stripeService.buyMagicMatch25();
      }

      if (checkoutUrl != null && !checkoutUrl.contains('PLACEHOLDER')) {
        final productId = 'magicMatch$quantity';
        checkoutUrl = '$checkoutUrl?client_reference_id=${currentUser.uid}_$productId';
      }

      if (!mounted) return null;

      if (checkoutUrl != null && !checkoutUrl.contains('PLACEHOLDER')) {
        await UrlLauncherHelper.openCheckoutUrl(context, checkoutUrl, plan: '$quantity Magic Match');

        // 🔄 RECARREGAR contadores após 2 segundos (tempo para processar pagamento)
        Future.delayed(const Duration(seconds: 2), () async {
          if (mounted) {
            // Invalidar provider para forçar recarga do Firebase
            ref.invalidate(currentUserProfileProvider);

            // Atualizar contador local
            try {
              final service = ref.read(consumablesServiceV2Provider);
              final consumables = await service.getConsumables();
              if (mounted) {
                setState(() {
                  _localMagicMatchCount = consumables.magicMatches;
                  print('🪄 Contador recarregado: $_localMagicMatchCount Magic Matches');
                });
              }
            } catch (e) {
              print('❌ Erro ao recarregar Magic Matches: $e');
            }
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🪄 Magic Match em breve! Os links do Stripe ainda não foram configurados.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro ao processar compra: $e')));
    }
    return null;
  }

  Future<void> _purchaseReplay(BuildContext ctx, int quantity) async {
    Navigator.of(ctx).pop(); // Fechar dialog

    try {
      final currentUser = ref.read(authRepositoryProvider).currentUser;
      if (currentUser == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Usuário não autenticado')));
        return;
      }

      // Chamar StripeService baseado na quantidade
      final stripeService = ref.read(stripeServiceProvider);
      String? checkoutUrl;

      if (quantity == 10) {
        checkoutUrl = await stripeService.buyReplay10();
      } else if (quantity == 20) {
        checkoutUrl = await stripeService.buyReplay20();
      } else if (quantity == 50) {
        checkoutUrl = await stripeService.buyReplay50();
      }

      if (checkoutUrl != null && !checkoutUrl.contains('PLACEHOLDER')) {
        final productId = 'replay$quantity';
        checkoutUrl = '$checkoutUrl?client_reference_id=${currentUser.uid}_$productId';
      }

      if (!mounted) return;

      if (checkoutUrl != null && !checkoutUrl.contains('PLACEHOLDER')) {
        await UrlLauncherHelper.openCheckoutUrl(context, checkoutUrl, plan: '$quantity Replay');

        // 🔄 RECARREGAR contadores após 2 segundos
        Future.delayed(const Duration(seconds: 2), () async {
          if (mounted) {
            // Invalidar provider para forçar recarga do Firebase
            ref.invalidate(currentUserProfileProvider);

            // Atualizar contador local
            try {
              final service = ref.read(consumablesServiceV2Provider);
              final consumables = await service.getConsumables();
              if (mounted) {
                setState(() {
                  _localReplayCount = consumables.replays;
                  print('↩️ Contador recarregado: $_localReplayCount Replays');
                });
              }
            } catch (e) {
              print('❌ Erro ao recarregar Replays: $e');
            }
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('↩️ Replay em breve! Os links do Stripe ainda não foram configurados.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro ao processar compra: $e')));
    }
  }

  // 🎯 CLIENT LIKE: Match automático para clientes (igual MagicMatch)
  Future<void> _handleClientLike() async {
    print('🎯 [ClientLike] Iniciando...');

    final profilesState = ref.read(discoverProfilesProvider);
    if (!profilesState.hasValue || (profilesState.value?.isEmpty ?? true)) {
      print('❌ [ClientLike] Sem perfis');
      return;
    }

    // Pegar o perfil ATUAL
    final profiles = profilesState.value!;
    if (_currentIndex >= profiles.length) {
      print('❌ [ClientLike] Índice inválido: $_currentIndex >= ${profiles.length}');
      return;
    }

    final profile = profiles[_currentIndex];
    print('🎯 [ClientLike] Target: ${profile.name} (${profile.userId})');

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Usuário não autenticado');

      // 🔥 SETAR FLAG para prevenir processamento duplicado no onSwipe
      _isProcessingClientLike = true;

      // Swipe visual primeiro
      _swiperController.swipe(CardSwiperDirection.right);

      // Criar swipe e match via controller
      final matchUserId = await ref.read(swipeControllerProvider.notifier).swipe(profile.userId, true);

      if (matchUserId != null && mounted) {
        print('🎉 [ClientLike] MATCH AUTOMÁTICO criado! Mostrando modal...');
        // Aguardar um pouco para animação completar
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          await _showMatchModal(profile);
        }
      } else {
        print('⚠️ [ClientLike] Match não criado');
      }
    } catch (e, stack) {
      print('❌ [ClientLike] Exceção: $e');
      print(stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro: $e'), backgroundColor: Colors.red));
      }
    } finally {
      // 🔥 RESET flag ao final
      _isProcessingClientLike = false;
    }
  }

  // 🪄 MAGIC MATCH: Usa a MESMA lógica da tela "Quem Curtiu"
  Future<void> _handleMagicMatch() async {
    print('🪄 [MagicMatch] Iniciando...');

    if (!mounted || (_localMagicMatchCount ?? 0) <= 0) {
      print('❌ [MagicMatch] Sem Magic Matches localmente');
      return;
    }

    final profilesState = ref.read(discoverProfilesProvider);
    if (!profilesState.hasValue || (profilesState.value?.isEmpty ?? true)) {
      print('❌ [MagicMatch] Sem perfis');
      return;
    }

    // Pegar o perfil ATUAL baseado no índice, não o primeiro!
    final profiles = profilesState.value!;
    if (_currentIndex >= profiles.length) {
      print('❌ [MagicMatch] Índice inválido: $_currentIndex >= ${profiles.length}');
      return;
    }

    final profile = profiles[_currentIndex];
    print('🪄 [MagicMatch] Índice atual: $_currentIndex');
    print('🪄 [MagicMatch] Target: ${profile.name} (${profile.userId})');

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Usuário não autenticado');
      print('🪄 [MagicMatch] UserId: $userId');
      print('🪄 [MagicMatch] Contagem local ANTES: $_localMagicMatchCount');

      // 1. Mostrar overlay roxo + decrementar localmente
      _showMagicMatchOverlay.value = true;
      await Future.delayed(const Duration(milliseconds: 700));
      _showMagicMatchOverlay.value = false;
      if (mounted) {
        setState(() => _localMagicMatchCount = (_localMagicMatchCount ?? 1) - 1);
      }
      if (!mounted) return;

      // 2. Criar match diretamente (Magic Match = match garantido)
      final matchRepo = ref.read(matchRepositoryProvider);
      final matchId = await matchRepo.createMatch(user1: userId, user2: profile.userId);
      print('✅ [MagicMatch] Match criado: $matchId');

      if (!mounted) return;

      // 3. Criar MEU swipe para registrar a ação
      final swipeRepo = ref.read(swipeRepositoryProvider);
      try {
        await swipeRepo.createSwipe(fromUserId: userId, toUserId: profile.userId, liked: true, isSuperLike: false);
      } catch (_) {} // Ignora erro se já existe swipe

      if (!mounted) return;

      // Magic Match sempre resulta em match
      const isMatch = true;

      if (isMatch && mounted) {
        print('🎉 [MagicMatch] MATCH DETECTADO! Mostrando modal...');

        // Swipe visual
        _swiperController.swipe(CardSwiperDirection.right);

        // Mostrar modal de match
        await _showMatchModal(profile);
      } else {
        print('⚠️ [MagicMatch] Sem match detectado');
        // Só faz o swipe visual
        _swiperController.swipe(CardSwiperDirection.right);
      }
    } catch (e, stack) {
      print('❌ [MagicMatch] Exceção: $e');
      print(stack);
      if (mounted) {
        setState(() => _localMagicMatchCount = (_localMagicMatchCount ?? 0) + 1);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // ↩️ REPLAY: Desfazer último swipe (Like ou Dislike)
  Future<void> _handleReplay() async {
    print('↩️ [Replay] Iniciando...');

    final effectiveReplayCount = _localReplayCount ?? ref.read(userConsumablesProvider).value?.replays ?? 0;
    if (!mounted || effectiveReplayCount <= 0) {
      _showPurchaseDialog(context, isPurchasingBoosts: false, isReplay: true);
      return;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Usuário não autenticado');

      print('↩️ [Replay] UserId: $userId');
      print('↩️ [Replay] Perfis swipados nesta sessão: ${_swipedProfileIds.length}');

      // 🔥 CORREÇÃO: Buscar último swipe do Firebase SE lista local estiver vazia
      String? lastProfileId;

      if (_swipedProfileIds.isNotEmpty) {
        // Usar lista local (swipes da sessão atual)
        lastProfileId = _swipedProfileIds.removeLast();
        print('↩️ [Replay] Usando swipe local: $lastProfileId');
      } else {
        // Buscar último swipe do Firebase
        print('↩️ [Replay] Lista local vazia, buscando último swipe do Firebase...');
        final swipeRepo = ref.read(swipeRepositoryProvider);
        final recentSwipes = await swipeRepo.getRecentSwipes(userId, limit: 1);

        if (recentSwipes.isEmpty) {
          print('❌ [Replay] Nenhum swipe encontrado no Firebase');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('↩️ Nenhum perfil para desfazer'), backgroundColor: Colors.orange),
            );
          }
          return;
        }

        lastProfileId = recentSwipes.first.toUserId;
        print('↩️ [Replay] Último swipe do Firebase: $lastProfileId');
      }

      print('↩️ [Replay] Desfazendo swipe com: $lastProfileId');

      // 2. Deletar o swipe do Firebase
      final swipeRepo = ref.read(swipeRepositoryProvider);
      await swipeRepo.deleteSwipe(userId, lastProfileId);
      print('✅ [Replay] Swipe deletado!');

      // 3. Decrementar localmente + mostrar overlay laranja
      if (mounted) {
        setState(() => _localReplayCount = (_localReplayCount ?? 1) - 1);
        _showReplayOverlay.value = true;
        await Future.delayed(const Duration(milliseconds: 600));
        _showReplayOverlay.value = false;
      }

      // 5. Tentar voltar card visual (não crashar se falhar)
      if (mounted) {
        try {
          _swiperController.undo();
          print('✅ [Replay] Card voltou visualmente');
          setState(() => _currentIndex = (_currentIndex - 1).clamp(0, 999));
        } catch (e) {
          print('⚠️ [Replay] Card não voltou (normal se pilha vazia): $e');
        }
      }

      // Sem SnackBar — overlay já deu o feedback visual
    } catch (e, stack) {
      print('❌ [Replay] Erro: $e');
      print(stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // 🎉 Mostrar modal de match (usado tanto por swipe normal quanto Magic Match)
  Future<void> _showMatchModal(dynamic matchedProfile) async {
    print('🎉 [Match] Mostrando modal para: ${matchedProfile.name}');

    final currentProfile = ref.read(currentUserProfileProvider).value;
    if (currentProfile == null) {
      print('❌ [Match] Perfil atual não encontrado');
      return;
    }

    print('🎉 [Match] Current User: ${currentProfile.name}');
    print('🎉 [Match] Current User ID: ${currentProfile.userId}');
    print('🎉 [Match] Current User Avatar: ${currentProfile.avatarUrl}');
    print('🎉 [Match] Matched User: ${matchedProfile.name}');
    print('🎉 [Match] Matched User ID: ${matchedProfile.userId}');
    print('🎉 [Match] Matched User Avatar: ${matchedProfile.avatarUrl}');

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => MatchCelebrationDialog(
        currentUser: currentProfile,
        matchedUser: matchedProfile,
        onContinue: () {
          Navigator.of(context).pop();
          print('🎉 [Match] Usuário escolheu continuar deslizando');
        },
        onSendMessage: () async {
          print('💬 [Match] Usuário escolheu enviar mensagem');

          // Navegar para o chat
          try {
            final chatRepo = ref.read(chatRepositoryProvider);
            final chat = await chatRepo.getOrCreateChat(matchedProfile.userId);
            print('💬 [Match] Chat criado/obtido: ${chat.id}');

            if (mounted) {
              // Fechar dialog DEPOIS de criar chat
              Navigator.of(context).pop();

              // Navegar para o chat
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chatId: chat.id, otherUser: matchedProfile),
                ),
              );
              print('💬 [Match] Navegação para chat concluída');
            }
          } catch (e) {
            print('❌ [Match] Erro ao abrir chat: $e');
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('❌ Erro ao abrir chat: $e'), backgroundColor: Colors.red));
            }
          }
        },
        onViewProfile: () {
          Navigator.of(context).pop();
          print('👤 [Match] Usuário escolheu ver perfil: ${matchedProfile.name}');

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProfileDetailScreen(profile: matchedProfile, isCurrentUser: false)),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // Cancelar todos os callbacks pendentes para prevenir setState após dispose
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Callback vazio para cancelar operações pendentes
    });

    // Dispose do controller de forma segura
    try {
      if (mounted) {
        _swiperController.dispose();
      }
    } catch (e) {
      debugPrint('⚠️ CardSwiper dispose warning: $e');
    }

    // 🧹 Dispose dos ValueNotifiers de overlay
    _showSuperLikeOverlay.dispose();
    _showReplayOverlay.dispose();
    _showMagicMatchOverlay.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ [BUILD] SwipeScreen.build() chamado - ${DateTime.now()}');

    // 🎯 VERIFICAR SE USUÁRIO É CLIENTE
    final currentProfile = ref.watch(currentUserProfileProvider);
    final isCustomer = currentProfile.value?.accountType == AccountType.customer;

    // 💎 INICIALIZAR CONTADOR LOCAL de Super Likes (apenas uma vez)
    currentProfile.whenData((profile) {
      if (profile != null && _localSuperLikesCount == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _localSuperLikesCount = profile.superLikesRemaining;
              print('💎 [Build] Contador local inicializado: $_localSuperLikesCount Super Likes');
            });
          }
        });
      }
      // 🪄 INICIALIZAR CONTADOR LOCAL de Magic Matches (apenas uma vez)
      if (profile != null && _localMagicMatchCount == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            try {
              final service = ref.read(consumablesServiceV2Provider);
              final consumables = await service.getConsumables();
              if (mounted) {
                setState(() {
                  _localMagicMatchCount = consumables.magicMatches;
                  print('🪄 [Build] Contador local inicializado: $_localMagicMatchCount Magic Matches');
                });
              }
            } catch (e) {
              print('❌ [Build] Erro ao carregar Magic Matches: $e');
            }
          }
        });
      }
      // ↩️ INICIALIZAR CONTADOR LOCAL de Replays (apenas uma vez)
      if (profile != null && _localReplayCount == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            try {
              print('↩️ [Build] Tentando carregar Replays do Firebase...');
              final service = ref.read(consumablesServiceV2Provider);
              final consumables = await service.getConsumables();
              print(
                '↩️ [Build] Consumables carregados: replays=${consumables.replays}, magicMatches=${consumables.magicMatches}',
              );
              if (mounted) {
                setState(() {
                  _localReplayCount = consumables.replays;
                  print('↩️ [Build] Contador local inicializado: $_localReplayCount Replays');
                });
              }
            } catch (e, stack) {
              print('❌ [Build] Erro ao carregar Replays: $e');
              print('❌ [Build] Stack: $stack');
            }
          }
        });
      }
    });

    final profilesAsync = ref.watch(discoverProfilesProvider);

    return AppBackgrounds.scaffold(
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(color: Color(0xFFB026FF), fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        centerTitle: true,
        leading: _canSeeLikes && _likesReceivedCount > 0
            ? IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.favorite, color: Color(0xFFFF1744), size: 28),
                    if (_likesReceivedCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '$_likesReceivedCount',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                tooltip: 'Ver quem curtiu você',
                onPressed: () async {
                  // Temporarily disabled - LikesYouScreen is disabled
                  // await Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const LikesYouScreen()));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Funcionalidade temporariamente indisponível')));
                  // Recarregar contagem após voltar
                  _loadLikesReceivedCount();
                },
              )
            : null,
        actions: [
          // Super Likes com emoji 💙
          GestureDetector(
            onTap: () => _showPurchaseDialog(context, isPurchasingBoosts: false),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 4),
                  // 💎 Contador com update OTIMISTA usando _localSuperLikesCount
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    child: Text(
                      _localSuperLikesCount == null
                          ? '...'
                          : _localSuperLikesCount == -1
                          ? '∞'
                          : '$_localSuperLikesCount',
                      style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Magic Match com emoji 🪄
          GestureDetector(
            onTap: () => _showPurchaseDialog(context, isPurchasingBoosts: false, isMagicMatch: true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Text('🪄', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 4),
                  // 🪄 Contador com update OTIMISTA usando _localMagicMatchCount
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.pink, width: 1),
                    ),
                    child: Text(
                      _localMagicMatchCount == null
                          ? '...'
                          : _localMagicMatchCount == -1
                          ? '∞'
                          : '$_localMagicMatchCount',
                      style: const TextStyle(color: Colors.pink, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Replay com emoji ↩️
          GestureDetector(
            onTap: () => _showPurchaseDialog(context, isPurchasingBoosts: false, isReplay: true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Text('↩️', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 4),
                  // ↩️ Contador com update OTIMISTA usando _localReplayCount
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber, width: 1),
                    ),
                    child: Text(
                      _localReplayCount == null
                          ? '...'
                          : _localReplayCount == -1
                          ? '∞'
                          : '$_localReplayCount',
                      style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Boosts com emoji
          GestureDetector(
            onTap: () => _showPurchaseDialog(context, isPurchasingBoosts: true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Text('🚀', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 4),
                  Consumer(
                    builder: (context, ref, _) {
                      final profile = ref.watch(currentUserProfileProvider);
                      final boosts = profile.whenOrNull(data: (p) => p?.boostsRemaining) ?? 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB026FF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFB026FF), width: 1),
                        ),
                        child: Text(
                          '$boosts',
                          style: const TextStyle(color: Color(0xFFB026FF), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: BarberIcons.filterSliders(size: 24),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => FiltersBottomSheet(
                  currentFilters: const DiscoveryFilters(),
                  onApply: (filters) {
                    debugPrint('🔍 Filtros aplicados:');
                    debugPrint('  - Raio: ${filters.radiusKm}km');
                    debugPrint('  - Preço: R\$${filters.minPrice}-${filters.maxPrice}');
                    debugPrint('  - Serviços: ${filters.selectedServices}');
                    debugPrint('  - Rating: ${filters.minRating}');
                    debugPrint('  - Tipo: ${filters.accountType}');
                    debugPrint('  - Online: ${filters.onlineOnly}');
                    debugPrint('  - Disponível: ${filters.availableNow}');

                    // TODO: Implementar aplicação de filtros no DiscoveryController
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Filtros aplicados com sucesso!'), duration: Duration(seconds: 2)),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      child: profilesAsync.when(
        // CORREÇÃO 7: Estado de carregamento claro
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Carregando perfis...')],
          ),
        ),
        // CORREÇÃO 4: Error boundary com retry
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Ops, algo deu errado!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Força reload dos dados
                    ref.invalidate(discoverProfilesProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
        data: (profiles) {
          print('📊 [SwipeScreen] Provider DATA received - profiles.length: ${profiles.length}');
          print('📊 [SwipeScreen] Total swipados nesta sessão: $_totalSwipedCount');

          // ✅ MOSTRAR EMPTY STATE: Se não há perfis OU se já swipou todos os perfis disponíveis
          final shouldShowEmptyState = profiles.isEmpty || _totalSwipedCount >= profiles.length;

          if (shouldShowEmptyState) {
            print(
              '✅ [SwipeScreen] MOSTRANDO EMPTY STATE - isEmpty: ${profiles.isEmpty}, swipados: $_totalSwipedCount >= ${profiles.length}',
            );
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BarberIcons.magnifyingGlassWithBarberPole(size: 80),
                  const SizedBox(height: 24),
                  const Text(
                    '🌍 Acabaram os perfis',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Acabaram os perfis da sua região no momento.\nRetorne mais tarde para descobrir novos perfis!',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(discoverProfilesProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Atualizar'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                  ),
                ],
              ),
            );
          }
          return Stack(
            children: [
              // Cards de perfil
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CardSwiper(
                  controller: _swiperController,
                  cardsCount: profiles.length,
                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                    // ⚠️ DESABILITADO: Preload causava loop infinito de rebuilds (30+ rebuilds/segundo)
                    // CachedNetworkImage já faz cache automático - preload é redundante

                    // Swipe feedback overlay
                    final showLikeOverlay = percentThresholdX > 0.1;
                    final showDislikeOverlay = percentThresholdX < -0.1;
                    // 🚫 SUPER LIKE SWIPE UP REMOVIDO - Apenas botão agora
                    final overlayOpacity = (percentThresholdX.abs() * 2).clamp(0.0, 1.0).toDouble();

                    return Stack(
                      children: [
                        ProfileCard(profile: profiles[index]),
                        // Like overlay (right swipe)
                        if (showLikeOverlay)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green.withOpacity(0.2 * overlayOpacity),
                                border: Border.all(color: Colors.green.withOpacity(overlayOpacity), width: 4),
                              ),
                              child: Center(
                                child: Transform.rotate(
                                  angle: -0.3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '❤️ CURTIR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        shadows: [Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4)],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Dislike overlay (left swipe)
                        if (showDislikeOverlay)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red.withOpacity(0.2 * overlayOpacity),
                                border: Border.all(color: Colors.red.withOpacity(overlayOpacity), width: 4),
                              ),
                              child: Center(
                                child: Transform.rotate(
                                  angle: 0.3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '✖️ PULAR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        shadows: [Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4)],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // 🟠 OVERLAY LARANJA "REPLAY"
                        ValueListenableBuilder<bool>(
                          valueListenable: _showReplayOverlay,
                          builder: (context, show, _) {
                            if (!show) return const SizedBox.shrink();
                            return Positioned.fill(
                              child: IgnorePointer(
                                child: Container(
                                  margin: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.orange.withAlpha(77),
                                    border: Border.all(color: Colors.orange, width: 4),
                                  ),
                                  child: const Center(
                                    child: Text('↩️ REPLAY',
                                        style: TextStyle(fontSize: 36, color: Colors.white,
                                            fontWeight: FontWeight.bold, letterSpacing: 2)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // 🟣 OVERLAY ROXO "MAGIC MATCH"
                        ValueListenableBuilder<bool>(
                          valueListenable: _showMagicMatchOverlay,
                          builder: (context, show, _) {
                            if (!show) return const SizedBox.shrink();
                            return Positioned.fill(
                              child: IgnorePointer(
                                child: Container(
                                  margin: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFB026FF).withAlpha(77),
                                    border: Border.all(color: const Color(0xFFB026FF), width: 4),
                                  ),
                                  child: const Center(
                                    child: Text('✨ MAGIC MATCH',
                                        style: TextStyle(fontSize: 32, color: Colors.white,
                                            fontWeight: FontWeight.bold, letterSpacing: 2)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // 💙 OVERLAY AZUL "SUPER LIKE" (aparece por 600ms)
                        ValueListenableBuilder<bool>(
                          valueListenable: _showSuperLikeOverlay,
                          builder: (context, showOverlay, child) {
                            if (!showOverlay) return const SizedBox.shrink();

                            return Positioned.fill(
                              child: IgnorePointer(
                                child: Container(
                                  margin: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.withOpacity(0.3),
                                    border: Border.all(color: Colors.blue, width: 4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '⚡ SUPER LIKE',
                                      style: TextStyle(
                                        fontSize: 36,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.5),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                  // 🧪 TESTE: Comentar onSwipe COMPLETAMENTE para testar se ele causa hot restart
                  onSwipe: (previousIndex, currentIndex, direction) async {
                    print(
                      '🧪 [Swipe] onSwipe chamado - previousIndex: $previousIndex, currentIndex: $currentIndex, direction: $direction',
                    );
                    print('🧪 [Swipe] Total de perfis: ${profiles.length}');

                    // 🔥 PREVENIR swipe duplicado quando for Super Like manual
                    if (_isProcessingSuperLike) {
                      debugPrint('🛑 [Swipe] Ignorando onSwipe - Super Like em progresso');
                      _isProcessingSuperLike = false; // Reset flag
                      return true; // Permitir swipe visual mas não processar novamente
                    }

                    // 🔥 PREVENIR swipe duplicado quando cliente clica botão like
                    if (_isProcessingClientLike) {
                      debugPrint('🛑 [Swipe] Ignorando onSwipe - Cliente like em progresso');
                      _isProcessingClientLike = false; // Reset flag
                      return true; // Permitir swipe visual mas não processar novamente
                    }

                    // Atualizar índice atual (sem setState para evitar rebuild)
                    _currentIndex = currentIndex ?? 0;
                    print('🧪 [Swipe] Atualizando _currentIndex para: $_currentIndex');

                    // ✅ DETECTAR FIM DOS CARDS: Múltiplas condições
                    final isLastCard = previousIndex >= profiles.length - 1;
                    final noMoreCards = currentIndex == null;

                    if (isLastCard || noMoreCards) {
                      print('🌍 [Swipe] ========== FIM DOS CARDS DETECTADO ==========');
                      print(
                        '🌍 [Swipe] isLastCard: $isLastCard (previousIndex=$previousIndex >= ${profiles.length - 1})',
                      );
                      print('🌍 [Swipe] noMoreCards: $noMoreCards (currentIndex=$currentIndex)');
                      print('🌍 [Swipe] Aguardando 200ms e forçando rebuild...');

                      // Aguardar animação completar antes de forçar rebuild
                      Future.delayed(const Duration(milliseconds: 200), () {
                        if (mounted) {
                          print('🌍 [Swipe] Executando setState() + invalidate provider');
                          setState(() {
                            // Forçar rebuild para mostrar empty state
                          });
                          // Invalidar provider para recarregar (vai retornar lista vazia)
                          ref.invalidate(discoverProfilesProvider);
                        }
                      });
                    }

                    // Early exit se widget foi disposed
                    if (!mounted) {
                      print('🧪 [Swipe] Widget não montado - retornando');
                      return true;
                    }

                    print('✅ [Swipe] Processando swipe NORMAL (não Super Like)');

                    // Processar swipe backend
                    final profile = profiles[previousIndex];
                    final liked = direction == CardSwiperDirection.right;
                    _swipedProfileIds.add(profile.userId);

                    // 🌍 INCREMENTAR contador de perfis swipados
                    _totalSwipedCount++;
                    print('🌍 [Swipe] Total swipados agora: $_totalSwipedCount de ${profiles.length}');

                    // Processar swipe no backend (match detection, etc)
                    ref
                        .read(swipeControllerProvider.notifier)
                        .swipe(profile.userId, liked)
                        .then((matchUserId) async {
                          if (!mounted) return;
                          if (matchUserId == '__SWIPE_LIMIT_REACHED__') {
                            _showSwipeLimitModal();
                          } else if (matchUserId != null) {
                            await _showMatchModal(profile);
                          }
                        })
                        .catchError((e) {
                          debugPrint('❌ [Swipe] Erro: $e');
                        });

                    print('✅ [Swipe] onSwipe finalizado');
                    return true;
                  },
                  isLoop: false,
                  numberOfCardsDisplayed: 2,
                  backCardOffset: const Offset(0, 40),
                  padding: const EdgeInsets.all(24.0),
                  scale: 0.9,
                ),
              ),

              // Botões de ação na parte inferior
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botão REPLAY 🔄 (desfazer último swipe) - Consome replaysRemaining
                    // 🚫 DESABILITADO PARA CLIENTES
                    if (!isCustomer)
                      Consumer(
                        builder: (context, ref, _) {
                          final consumablesAsync = ref.watch(userConsumablesProvider);
                          // ↩️ Usar contador local se disponível, senão usar do Firebase
                          final replayCount = _localReplayCount ?? consumablesAsync.value?.replays ?? 0;
                          final hasReplays = replayCount > 0;
                          // 🔥 CORREÇÃO: Replay funciona mesmo sem swipes na sessão (busca do Firebase)
                          final canReplay = hasReplays;

                          return Tooltip(
                            message: hasReplays
                                ? '↩️ Replay ($replayCount) - Desfazer último like/dislike'
                                : 'Sem Replays disponíveis',
                            child: InkWell(
                              onTap: () async {
                                await _handleReplay();
                              },
                              borderRadius: BorderRadius.circular(50),
                              splashColor: canReplay ? Colors.orange.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                              highlightColor: canReplay ? Colors.orange.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: canReplay ? Colors.white : Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: canReplay ? Colors.orange.withOpacity(0.3) : Colors.black12,
                                      blurRadius: canReplay ? 12 : 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CustomPaint(size: const Size(56, 56), painter: ReplayIconPainter()),
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(width: 4),
                    // Botão de dislike ❌ com navalhas cruzadas
                    Tooltip(
                      message: '❌ Pular perfil',
                      child: GestureDetector(
                        onTap: () => _swiperController.swipe(CardSwiperDirection.left),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
                          ),
                          child: CustomPaint(size: const Size(64, 64), painter: DislikeIconPainter(isPressed: false)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Botão de SUPER LIKE ⚡ com tesoura elétrica
                    // 🚫 DESABILITADO PARA CLIENTES
                    if (!isCustomer)
                      Tooltip(
                        message: '⚡ Super Like - Destaque especial',
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // ✅ SUPER LIKE ATIVADO - VERSÃO SIMPLES (sem Riverpod complexo)
                                print('💛 [SuperLike Button] ========== INÍCIO ========== ${DateTime.now()}');
                                print('💛 [SuperLike Button] Rota atual: ${ModalRoute.of(context)?.settings.name}');

                                // � VALIDAR contador antes de enviar Super Like
                                if (_localSuperLikesCount != null && _localSuperLikesCount == 0) {
                                  print('⚠️ [SuperLike Button] Sem Super Likes disponíveis');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('⚠️ Você não tem Super Likes disponíveis!'),
                                      backgroundColor: Colors.orange,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }

                                // �🔒 BLOQUEAR NAVEGAÇÃO durante operação
                                final navigationLock = NavigationLock();
                                navigationLock.lock();
                                print('🔒 [SuperLike Button] Navegação BLOQUEADA');

                                try {
                                  if (profiles.isEmpty) {
                                    print('⚠️ [SuperLike Button] Sem perfis disponíveis');
                                    return;
                                  }

                                  if (!mounted) {
                                    print('⚠️ [SuperLike Button] Widget não montado');
                                    return;
                                  }

                                  // 🔥 ATIVAR flag para prevenir onSwipe duplicado
                                  _isProcessingSuperLike = true;
                                  print('💛 [SuperLike Button] Flag _isProcessingSuperLike = true');

                                  // Guardar índice e perfil atual ANTES da operação assíncrona
                                  final currentIndex = _currentIndex;
                                  final currentProfile = profiles[currentIndex];

                                  print('💛 [SuperLike Button] Clicado! Perfil: ${currentProfile.name}');
                                  print('💛 [SuperLike Button] Index atual: $currentIndex de ${profiles.length}');

                                  // 💙 Mostrar overlay azul "SUPER LIKE" (600ms)
                                  _showSuperLikeOverlay.value = true;
                                  await Future.delayed(const Duration(milliseconds: 600));
                                  _showSuperLikeOverlay.value = false;

                                  // ✅ SUPER LIKE ATIVADO - Envio ao Firebase
                                  try {
                                    print('📡 [SuperLike Button] Enviando Super Like...');

                                    final message = await SuperLikeServiceSimple.sendSuperLike(
                                      targetUserId: currentProfile.userId,
                                      targetUserName: currentProfile.name,
                                    );

                                    print('✅ [SuperLike Button] Super Like enviado: $message');

                                    if (!mounted) {
                                      _isProcessingSuperLike = false;
                                      return;
                                    }

                                    // 💎 DECREMENTAR CONTADOR LOCAL OTIMISTA (UI atualiza imediatamente)
                                    if (_localSuperLikesCount != null && _localSuperLikesCount != -1) {
                                      setState(() {
                                        _localSuperLikesCount = _localSuperLikesCount! - 1;
                                        print(
                                          '💎 [SuperLike Button] Contador local: ${_localSuperLikesCount! + 1} → $_localSuperLikesCount',
                                        );
                                      });
                                    } else if (_localSuperLikesCount == -1) {
                                      print('👑 [SuperLike Button] Contador ILIMITADO (Gold Badge)');
                                    }

                                    // Fazer swipe visual agora
                                    print('🔄 [SuperLike Button] Removendo card...');
                                    _swiperController.swipe(CardSwiperDirection.right);
                                    print('✅ [SuperLike Button] Card removido');
                                  } catch (superLikeError, superLikeStack) {
                                    print('❌ [SuperLike Button] ERRO: $superLikeError');
                                    print('❌ Stack: $superLikeStack');
                                    _isProcessingSuperLike = false;
                                    return;
                                  }

                                  print('💛 [SuperLike Button] ========== FIM ========== ${DateTime.now()}');
                                } catch (e, stackTrace) {
                                  print('❌ [SuperLike Button] ERRO: $e');
                                  print('❌ [SuperLike Button] Stack: $stackTrace');
                                  _isProcessingSuperLike = false;
                                } finally {
                                  // 🔓 SEMPRE desbloquear navegação no final
                                  navigationLock.unlock();
                                  print('🔓 [SuperLike Button] Navegação DESBLOQUEADA');
                                }
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
                                ),
                                child: CustomPaint(
                                  size: const Size(80, 80),
                                  painter: SuperLikeIconPainter(isPressed: false),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 4),
                    // Botão de like 💚 com coração verde sendo cortado
                    // Para CLIENTES: Cria match automático e abre modal
                    Tooltip(
                      message: isCustomer ? '💚 Curtir (Match Automático)' : '💚 Curtir perfil',
                      child: GestureDetector(
                        onTap: () async {
                          print('🔵 [LIKE BUTTON] Clicado! isCustomer=$isCustomer');
                          if (isCustomer) {
                            // 🎯 CLIENTE: Match automático com modal
                            print('🔵 [LIKE BUTTON] Chamando _handleClientLike...');
                            await _handleClientLike();
                            print('🔵 [LIKE BUTTON] _handleClientLike concluído');
                          } else {
                            // Comportamento normal para barbeiros/barbearias
                            print('🔵 [LIKE BUTTON] Swipe normal (não é cliente)');
                            _swiperController.swipe(CardSwiperDirection.right);
                          }
                        },
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: CustomPaint(size: const Size(64, 64), painter: LikeIconPainter(isPressed: false)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Botão MATCH MÁGICO ✨ (match automático + ir pro chat)
                    // 🚫 DESABILITADO PARA CLIENTES
                    if (!isCustomer)
                      Consumer(
                        builder: (context, ref, _) {
                          final consumablesAsync = ref.watch(userConsumablesProvider);
                          // 🪄 Usar contador local se disponível, senão usar do Firebase
                          final magicMatchCount = _localMagicMatchCount ?? consumablesAsync.value?.magicMatches ?? 0;
                          final hasMagicMatch = magicMatchCount > 0;

                          return Tooltip(
                            message: hasMagicMatch
                                ? '✨ Magic Match ($magicMatchCount) - Like e chat instantâneo'
                                : 'Sem Magic Matches disponíveis',
                            child: GestureDetector(
                              onTap: () async {
                                if (!mounted) return;

                                // ✅ Verificar se tem Magic Match disponível
                                if (!hasMagicMatch) {
                                  // Mostrar dialog de compra diretamente
                                  _showBuyMagicMatchDialog(context);
                                  return;
                                }

                                // 🎯 Executar Magic Match
                                await _handleMagicMatch();
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Color(0x99B026FF), blurRadius: 15, offset: Offset(0, 4)),
                                  ],
                                ),
                                child: CustomPaint(
                                  size: const Size(56, 56),
                                  painter: MagicMatchIconPainter(isLocked: false),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              // Botão de Boost no canto superior direito
              // Botão de Boost (timer global fica no overlay da app)
              const Positioned(top: 16, right: 16, child: BoostButton()),
            ],
          );
        },
      ),
    );
  }
}
