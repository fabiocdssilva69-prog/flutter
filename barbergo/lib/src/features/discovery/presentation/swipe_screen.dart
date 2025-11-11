import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../matches/presentation/widgets/match_celebration_dialog.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/discovery_controller.dart';
import '../controllers/swipe_controller.dart';
import '../models/discovery_filters.dart';
import 'widgets/boost_button.dart';
import 'widgets/filters_bottom_sheet.dart';
import 'widgets/profile_card.dart';

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen> with WidgetsBindingObserver {
  final CardSwiperController _swiperController = CardSwiperController();
  DateTime? _lastRefreshTime;
  DateTime? _profileViewStartTime; // Para medir tempo em cada perfil
  int _likeCount = 0; // Removido final para permitir incremento
  int _dislikeCount = 0; // Removido final para permitir incremento

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastRefreshTime = DateTime.now();
    _profileViewStartTime = DateTime.now();
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
        ref.invalidate(discoverProfilesProvider);
        _lastRefreshTime = DateTime.now();
      } else {
        debugPrint('✅ [SmartRefresh] Cache still valid (${timeSinceLastRefresh.inMinutes}min old)');
      }
    }
  }

  // Preload próximas 3 imagens para melhorar performance
  void _preloadNextImages(BuildContext context, List<dynamic> profiles, int currentIndex) {
    final int preloadCount = 3;
    for (int i = 1; i <= preloadCount; i++) {
      final int nextIndex = currentIndex + i;
      if (nextIndex < profiles.length) {
        final profile = profiles[nextIndex];
        if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
          try {
            precacheImage(CachedNetworkImageProvider(profile.avatarUrl!), context);
            debugPrint('🖼️ [Preload] Preloading image for profile at index $nextIndex');
          } catch (e) {
            debugPrint('⚠️ [Preload] Failed to preload image at index $nextIndex: $e');
          }
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // NEW: Cancelar callbacks pendentes do addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Vazio - cancela callbacks pendentes que poderiam chamar setState
    });

    // NEW: Usar microtask para dar tempo das animações completarem
    // Isso previne o bug do flutter_card_swiper onde _reset() chama setState após dispose
    Future.microtask(() {
      try {
        _swiperController.dispose();
      } catch (e) {
        debugPrint('⚠️ CardSwiper dispose warning: $e');
      }
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(discoverProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (context) => FiltersBottomSheet(
                  currentFilters: const DiscoveryFilters(),
                  onApply: (filters) {
                    // TODO: Implementar filtros no DiscoveryController
                    debugPrint(
                      'Filtros aplicados: raio=${filters.radiusKm}km, '
                      'tipo=${filters.accountType}, online=${filters.onlineOnly}',
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erro ao carregar perfis', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(error.toString(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            ],
          ),
        ),
        data: (profiles) {
          if (profiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Nenhum perfil disponível', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text('Tente aumentar o raio de busca', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(discoverProfilesProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Atualizar'),
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
                    // Preload próximas 3 imagens quando card aparece
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && context.mounted) {
                        _preloadNextImages(context, profiles, index);
                      }
                    });

                    // Swipe feedback overlay
                    final showLikeOverlay = percentThresholdX > 0.1;
                    final showDislikeOverlay = percentThresholdX < -0.1;
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
                                        shadows: [Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)],
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
                                        shadows: [Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  onSwipe: (previousIndex, currentIndex, direction) async {
                    // Early exit se widget foi disposed
                    if (!mounted) return true;

                    final profile = profiles[previousIndex];
                    final liked = direction == CardSwiperDirection.right;

                    // 📊 Analytics: Tempo gasto no perfil
                    if (_profileViewStartTime != null) {
                      final viewDuration = DateTime.now().difference(_profileViewStartTime!);
                      debugPrint('📊 [Analytics] Profile viewed for ${viewDuration.inSeconds}s');
                    }
                    _profileViewStartTime = DateTime.now(); // Reset timer para próximo perfil

                    // 📊 Analytics: Contar likes/dislikes
                    if (liked) {
                      _likeCount++;
                      debugPrint(
                        '📊 [Analytics] Like #$_likeCount - Ratio: ${(_likeCount / (_likeCount + _dislikeCount) * 100).toStringAsFixed(1)}%',
                      );
                    } else {
                      _dislikeCount++;
                      debugPrint(
                        '📊 [Analytics] Dislike #$_dislikeCount - Ratio: ${(_dislikeCount / (_likeCount + _dislikeCount) * 100).toStringAsFixed(1)}%',
                      );
                    }

                    // Registrar swipe no backend
                    if (!mounted) return true;
                    await ref.read(swipeControllerProvider.notifier).swipe(profile.userId, liked);

                    // Se deu like, verificar se houve match
                    if (liked && mounted) {
                      // Aguardar Cloud Function processar (2 segundos)
                      await Future.delayed(const Duration(seconds: 2));

                      // Check again if mounted after async operation
                      if (!mounted) return true;

                      final currentUserProfile = ref.read(currentUserProfileProvider).value;
                      if (currentUserProfile == null) return true;

                      // Verificar se match foi criado
                      final currentUserId = currentUserProfile.userId;
                      final matchId = [currentUserId, profile.userId]..sort();
                      final matchIdStr = matchId.join('_');

                      // Query collection instead of direct doc read (Firestore Rules compliant)
                      final matchQuery = await FirebaseFirestore.instance
                          .collection('matches')
                          .where('matchId', isEqualTo: matchIdStr)
                          .where('userIds', arrayContains: currentUserId)
                          .limit(1)
                          .get();

                      if (matchQuery.docs.isNotEmpty && mounted) {
                        // 🎉 É um match! Mostrar animação
                        await showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => MatchCelebrationDialog(
                            currentUser: currentUserProfile,
                            matchedUser: profile,
                            onContinue: () => Navigator.pop(context),
                            onSendMessage: () {
                              Navigator.pop(context);
                              context.push('/chat/$matchIdStr', extra: profile);
                            },
                          ),
                        );
                      } else if (mounted) {
                        // Apenas curtida, sem match
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❤️ Você curtiu ${profile.name}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    }

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
                  children: [
                    // Botão de dislike
                    FloatingActionButton(
                      heroTag: 'dislike',
                      onPressed: () => _swiperController.swipe(CardSwiperDirection.left),
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.close, color: Colors.red, size: 32),
                    ),
                    const SizedBox(width: 40),
                    // Botão de like
                    FloatingActionButton(
                      heroTag: 'like',
                      onPressed: () => _swiperController.swipe(CardSwiperDirection.right),
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.favorite, color: Colors.green, size: 32),
                    ),
                  ],
                ),
              ),

              // Botão de Boost no canto superior direito
              const Positioned(top: 16, right: 16, child: BoostButton()),
            ],
          );
        },
      ),
    );
  }
}
