import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../config/stripe_config.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/gemini_service.dart';
import '../../../../../services/stripe_service.dart';
import '../../../../core/theme/app_backgrounds.dart';
import '../../../../core/widgets/custom_icons/barber_icons.dart';
import '../../../../domain/entities/enums.dart';
import '../../../premium/utils/badge_colors.dart';
import '../../../../domain/entities/profile_entity.dart';
import '../../../profile/controllers/profile_controller.dart';
import '../../../profile/widgets/daily_message_modal.dart';
import 'referral_card.dart';
import '../../controllers/layout_preferences_controller.dart';
import '../../providers/boosted_profiles_provider.dart';
import '../../providers/motivational_messages_provider.dart';
import 'ads_banner_carousel.dart';
import 'ads_carousel_modal.dart';
import 'ai_features_card.dart';
import 'profile_completion_card.dart';

/// Tela inicial (feed) do app com conteúdo inspiracional e educativo
class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends ConsumerState<HomeFeedScreen> {
  // Shuffled once per session, not on every build
  late final List<Map<String, String>> _selectedTutorialVideos;
  late final List<Map<String, String>> _selectedShopVideos;

  @override
  void initState() {
    super.initState();
    final tutShuffle = List<Map<String, String>>.from(_allTutorialVideos)..shuffle();
    _selectedTutorialVideos = tutShuffle.toList(); // mostra todos
    final shopShuffle = List<Map<String, String>>.from(_allShopVideos)..shuffle();
    _selectedShopVideos = shopShuffle.take(5).toList();

    // Sequência de modais no startup — delay para UI estar pronta
    Future.delayed(const Duration(milliseconds: 1200), () async {
      if (!mounted) return;
      // 1. Mensagem do dia (1x/dia)
      await DailyMessageModal.showIfNeeded(context);
      if (!mounted) return;
      // 2. Anúncios premium (indicação agora é card fixo na home)
      await Future.delayed(const Duration(milliseconds: 200));
      await AdsCarouselModal.showIfNeeded(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgrounds.scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a1a),
        elevation: 0,
        title: const Text(
          'BARBERGO',
          style: TextStyle(color: Color(0xFFB026FF), fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        actions: [
          // Botão de ofertas especiais
          IconButton(
            icon: const Text('🎁', style: TextStyle(fontSize: 24)),
            tooltip: 'Ofertas Especiais',
            onPressed: () => AdsCarouselModal.show(context),
          ),
        ],
      ),
      floatingActionButton: _buildAiFloatingButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: _buildDynamicFeed(),
    );
  }

  /// Constrói o feed dinamicamente baseado nas preferências do usuário
  Widget _buildDynamicFeed() {
    final prefsAsync = ref.watch(layoutPreferencesProvider);

    return prefsAsync.when(
      data: (prefs) {
        // Mapa de seções disponíveis (sem 'sponsored' pois é fixo)
        final allSections = {
          'motivational': Column(
            children: [
              _buildMotivationalCard(),
              const SizedBox(height: 16),
              const AdsBannerCarousel(), // Banner fixo de anúncios
            ],
          ),
          'tutorials': _buildSection(title: 'Aprimore Sua Técnica', child: _buildTutorialVideos()),
          'boosted': _buildSection(title: 'Perfis em Destaque (Boost)', child: _buildBoostedProfiles()),
          'business': _buildSection(title: 'Potencialize Seu Negócio', child: _buildBusinessBoost()),
          'gallery': _buildSection(title: 'Anunciantes da Semana', child: _buildWorkGallery()),
        };

        // Lista de seções na ordem configurada
        final orderedSections = <Widget>[];

        // Adicionar banner de completar perfil no início (se perfil não completo)
        final currentProfile = ref.watch(currentUserProfileProvider).value;
        if (currentProfile != null) {
          orderedSections.add(const SizedBox(height: 16)); // Espaço antes do banner

          // Profile Completion Card (estilo Badoo com requisitos corretos)
          orderedSections.add(const ProfileCompletionCard());
          orderedSections.add(const SizedBox(height: 16));

          // Card de IA Features
          orderedSections.add(
            AiFeaturesCard(isPremium: currentProfile.isPremium, hasGoldBadge: currentProfile.hasGoldBadge),
          );
          orderedSections.add(const SizedBox(height: 16));

          // Card de Indicação — fixo abaixo dos selos
          orderedSections.add(ReferralCard(userId: currentProfile.userId));
          orderedSections.add(const SizedBox(height: 16));

          // Card IMPULSIONE sempre visível (não depende de preferências)
          orderedSections.add(_buildSponsoredAd());
          orderedSections.add(const SizedBox(height: 16));
        }

        // Processar seções dinâmicas usando IDs em vez de índices
        final sectionKeys = allSections.keys.toList();
        print('🔍 [HomeFeed] sectionKeys: $sectionKeys');
        print('🔍 [HomeFeed] sectionOrder: ${prefs.sectionOrder}');
        print('🔍 [HomeFeed] visibleSections: ${prefs.visibleSections}');

        for (final index in prefs.sectionOrder) {
          if (index < sectionKeys.length) {
            final sectionId = sectionKeys[index];
            print('🔍 [HomeFeed] Processando index=$index → sectionId=$sectionId');
            if (prefs.visibleSections.contains(sectionId)) {
              print('✅ [HomeFeed] Adicionando seção: $sectionId');
              orderedSections.add(allSections[sectionId]!);
              orderedSections.add(const SizedBox(height: 24));
            } else {
              print('❌ [HomeFeed] Seção $sectionId NÃO está em visibleSections');
            }
          }
        }

        return ListView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
          children: [
            ...orderedSections,
            const SizedBox(height: 56), // Espaço para bottom nav
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) {
        final currentProfile = ref.watch(currentUserProfileProvider).value;
        return ListView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
          children: [
            if (currentProfile != null) ...[
              AiFeaturesCard(isPremium: currentProfile.isPremium, hasGoldBadge: currentProfile.hasGoldBadge),
              const SizedBox(height: 16),
              _buildSponsoredAd(),
              const SizedBox(height: 16),
            ],
            _buildMotivationalCard(),
            const SizedBox(height: 16),
            const AdsBannerCarousel(),
            const SizedBox(height: 24),
            _buildSection(title: 'Aprimore Sua Técnica', child: _buildTutorialVideos()),
            const SizedBox(height: 24),
            _buildSection(title: 'Perfis em Destaque (Boost)', child: _buildBoostedProfiles()),
            const SizedBox(height: 24),
            _buildSection(title: 'Potencialize Seu Negócio', child: _buildBusinessBoost()),
            const SizedBox(height: 24),
            _buildSection(title: 'Anunciantes da Semana', child: _buildWorkGallery()),
            const SizedBox(height: 24),
            _buildSection(title: '🛒 Lojas & Equipamentos', child: _buildPremiumShopVideos()),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }

  /// Card com frase motivacional do dia
  Widget _buildMotivationalCard() {
    return Consumer(
      builder: (context, ref, _) {
        final messageAsync = ref.watch(motivationalMessagesProviderProvider);

        return messageAsync.when(
          data: (message) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFB026FF).withOpacity(0.4),
                        const Color(0xFF9C27B0).withOpacity(0.3),
                        const Color(0xFF7B2CBF).withOpacity(0.2),
                      ],
                    ),
                    border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.6), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB026FF).withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: const Color(0xFF9C27B0).withOpacity(0.2),
                        blurRadius: 35,
                        spreadRadius: 0,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Ícones de compartilhamento
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconButton(
                          icon: const Text('🔗', style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            // TODO: Compartilhar frase
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: IconButton(
                          icon: const Text('📤', style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            // TODO: Compartilhar frase
                          },
                        ),
                      ),
                      // Conteúdo central com mensagem sincronizada
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (message.emoji.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(message.emoji, style: const TextStyle(fontSize: 32)),
                                ),
                              Text(
                                message.message.toUpperCase(),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                  shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 8)],
                                ),
                              ),
                              if (message.authorName != null && message.authorName!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    '- ${message.authorName}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFB026FF).withOpacity(0.4),
                      const Color(0xFF9C27B0).withOpacity(0.3),
                      const Color(0xFF7B2CBF).withOpacity(0.2),
                    ],
                  ),
                  border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.6), width: 2),
                ),
                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
            ),
          ),
          error: (_, __) => ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFB026FF).withOpacity(0.4),
                      const Color(0xFF9C27B0).withOpacity(0.3),
                      const Color(0xFF7B2CBF).withOpacity(0.2),
                    ],
                  ),
                  border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.6), width: 2),
                ),
                child: Center(child: Icon(Icons.error_outline, color: Colors.white.withOpacity(0.6), size: 48)),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Vídeos tutoriais com conteúdo real
  // Lista curada de vídeos populares de técnicas de barbearia
  // Vídeos reais do YouTube — títulos e canais verificados
  static final List<Map<String, String>> _allTutorialVideos = [
    {
      'title': 'O que precisa mudar\npara CRESCER como BARBEIRO',
      'author': 'Seu Elias',
      'emoji': '📈',
      'url': 'https://www.youtube.com/watch?v=frhoAgEIPfg',
    },
    {
      'title': 'A PRIMEIRA Técnica\nque TODO barbeiro deve aprender!',
      'author': 'Barbeiro Educador',
      'emoji': '✂️',
      'url': 'https://www.youtube.com/watch?v=FdCD8_5HGas',
    },
    {
      'title': 'Guia de Separações\npara QUALQUER tipo de Corte',
      'author': 'Barbeiro Educador',
      'emoji': '📐',
      'url': 'https://www.youtube.com/watch?v=OsC7WpBt4mM',
    },
    {
      'title': 'Como usar a tesoura\nem 27 minutos | Tutorial',
      'author': 'Barber Tutorial',
      'emoji': '✂️',
      'url': 'https://www.youtube.com/watch?v=Q7_pmf7vuok',
    },
    {
      'title': 'CORTE NA TESOURA\nRÁPIDO E FÁCIL 💈',
      'author': 'Barbeiro Pro',
      'emoji': '💈',
      'url': 'https://www.youtube.com/watch?v=OcDy9D3Y-fY',
    },
    {
      'title': 'CORTE PLATINADO FLORIDO\nTécnica Avançada',
      'author': 'NOBRU BARBEIRO',
      'emoji': '🌸',
      'url': 'https://www.youtube.com/watch?v=HKBQ4QwEyRk',
    },
  ];

  Widget _buildTutorialVideos() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: _selectedTutorialVideos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final v = _selectedTutorialVideos[i];
          return _buildVideoCard(
            v['title']!,
            Icons.play_circle_outline,
            v['emoji']!,
            author: v['author'],
            duration: v['duration'],
            videoUrl: v['url'],
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(
    String title,
    IconData iconData,
    String iconEmoji, {
    String? author,
    String? duration,
    String? videoUrl,
  }) {
    // Extrair video ID do YouTube para thumbnail
    String? videoId;
    if (videoUrl != null) {
      final match = RegExp(r'(?:v=|\/)([\w-]{11})').firstMatch(videoUrl);
      videoId = match?.group(1);
    }

    return GestureDetector(
      onTap: () => _showVideoModal(title: title, author: author ?? '', videoUrl: videoUrl),
      child: Container(
        width: 260,
        margin: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Thumbnail do YouTube como background
              if (videoId != null)
                CachedNetworkImage(
                  imageUrl: 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[800]),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [const Color(0xFF9C27B0).withOpacity(0.3), const Color(0xFF6A1B9A).withOpacity(0.2)],
                      ),
                    ),
                  ),
                ),
              // Overlay escuro para legibilidade
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.8)],
                  ),
                  border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.5), width: 2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB026FF).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: const Color(0xFF9C27B0).withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB026FF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(iconEmoji, style: const TextStyle(fontSize: 36)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Author and play button
                      if (author != null)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB026FF).withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Text('👤', style: TextStyle(fontSize: 14)),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(author, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: Color(0xFFB026FF), shape: BoxShape.circle),
                              child: const Text('▶️', style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB026FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Assistir',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (duration != null)
                              Text('• $duration', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Perfis em destaque (boost) - Dados reais do Firebase
  Widget _buildBoostedProfiles() {
    final boostedProfiles = ref.watch(boostedProfilesProviderProvider);

    return boostedProfiles.when(
      data: (profiles) {
        if (profiles.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              // Não navegar para perfis fallback (evita erro de rota)
              final shouldNavigate = !profile.userId.startsWith('fallback');
              return _buildProfileCircle(
                profile.name,
                profile.avatarUrl ?? 'https://i.pravatar.cc/150?img=${index + 10}',
                shouldNavigate ? profile.userId : null,
                profile.verificationBadge,
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildProfileCircle(String name, String avatarUrl, String? profileId, VerificationBadge badge) {
    final hasBadge = badge == VerificationBadge.silver || badge == VerificationBadge.gold;
    print('🔍 [_buildProfileCircle] name=$name, profileId=$profileId, badge=${badge.name}, hasBadge=$hasBadge');

    return GestureDetector(
      onTap: profileId != null
          ? () {
              print('👆 Clicado em perfil: $name (ID: $profileId)');
              context.push('/profile/$profileId');
            }
          : () {
              print('⚠️ Perfil sem ID: $name');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Perfil não disponível'), duration: Duration(seconds: 1)));
            },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: hasBadge
                          ? BadgeColors.getColor(badge).withOpacity(0.5)
                          : const Color(0xFFB026FF).withOpacity(0.8),
                      width: 2.5,
                    ),
                    boxShadow: hasBadge
                        ? [
                            BoxShadow(
                              color: BadgeColors.getColor(badge).withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: const Color(0xFFB026FF).withOpacity(0.6),
                              blurRadius: 25,
                              spreadRadius: 3,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: const Color(0xFF9C27B0).withOpacity(0.4),
                              blurRadius: 35,
                              spreadRadius: 0,
                              offset: const Offset(0, 6),
                            ),
                          ],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => BarberIcons.beardedManBust(size: 40),
                    ),
                  ),
                ),
                // Selo Badge no canto superior direito - MAIOR e VISÍVEL
                if (hasBadge)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: BadgeIcon(
                      key: ValueKey('badge_${badge.name}_$name'),
                      badge: badge,
                      size: 28,
                      showShadow: true,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 80,
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card promocional de recursos premium
  // Lista curada de vídeos de lojas e equipamentos para barbearia
  static final List<Map<String, String>> _allShopVideos = [
    {'title': 'Máquina Wahl Senior\nReview Completo', 'author': 'Loja do Barbeiro BR', 'emoji': '⚙️', 'duration': '12:30', 'url': 'https://www.youtube.com/watch?v=B7j3wfijjpM'},
    {'title': 'Kit Profissional BaByliss\nVale a Pena?', 'author': 'Equipamentos Barber', 'emoji': '💈', 'duration': '10:15', 'url': 'https://www.youtube.com/watch?v=WHuS55XB5JQ'},
    {'title': 'Melhores Tesouras\nde 2025', 'author': 'GS Loja do Barbeiro', 'emoji': '✂️', 'duration': '8:45', 'url': 'https://www.youtube.com/watch?v=mk_3Egg3cEs'},
    {'title': 'Produtos Importados\npara Barba', 'author': 'Wahl Brasil Oficial', 'emoji': '🪒', 'duration': '14:20', 'url': 'https://www.youtube.com/watch?v=ADcKJl_PRxk'},
    {'title': 'Cadeira Hidráulica\nComo Escolher', 'author': 'Barber Supply SC', 'emoji': '🪑', 'duration': '11:00', 'url': 'https://www.youtube.com/watch?v=VBogbvSPcD4'},
    {'title': 'Pomadas e Finalizadores\nTop 10', 'author': 'Man Cave Store', 'emoji': '🧴', 'duration': '9:30', 'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'},
    {'title': 'Montando sua Barbearia\ncom Pouco', 'author': 'Barber Business BR', 'emoji': '🏪', 'duration': '16:45', 'url': 'https://www.youtube.com/watch?v=jNQXAC9IVRw'},
    {'title': 'Gama Italy vs BaByliss\nComparação', 'author': 'Review Barber', 'emoji': '🔬', 'duration': '13:00', 'url': 'https://www.youtube.com/watch?v=9bZkp7q19f0'},
  ];

  Widget _buildPremiumShopVideos() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: _selectedShopVideos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final v = _selectedShopVideos[i];
          return _buildVideoCard(
            v['title']!,
            Icons.store,
            v['emoji']!,
            author: v['author'],
            duration: v['duration'],
            videoUrl: v['url'],
          );
        },
      ),
    );
  }

  void _showVideoModal({required String title, required String author, String? videoUrl}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🎬 Aprimore sua Técnica',
                style: TextStyle(color: Color(0xFFB026FF), fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(title.replaceAll('\n', ' '),
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            if (author.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('por $author', style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📣 Benefícios de anunciar aqui:', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('• Seu conteúdo visto por barbeiros e barbearias do app', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  Text('• Destaque na aba "Aprimore sua Técnica"', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  Text('• Aumenta seguidores e autoridade no nicho', style: TextStyle(color: Colors.white60, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (videoUrl != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        final uri = Uri.parse(videoUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: const Text('▶️'),
                      label: const Text('Assistir'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                if (videoUrl != null) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      const msg = 'Olá! Quero anunciar meu conteúdo na aba "Aprimore sua Técnica" do BarberGO!';
                      final uri = Uri.parse('https://wa.me/5548999746918?text=${Uri.encodeComponent(msg)}');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Text('💬'),
                    label: const Text('Anuncie também'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB026FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsoredAd() {
    return GestureDetector(
      onTap: () {
        // Mostrar modal de compra de boosts
        _showBoostPurchaseModal();
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8B2CAB), Color(0xFF5B1A79)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🚀 IMPULSIONE\nSEU PERFIL',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Apareça primeiro com Boosts\ne Super Likes',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Ícone
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                child: const Center(child: Text('⚡', style: TextStyle(fontSize: 60))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Cards de potencialização do negócio
  Widget _buildBusinessBoost() {
    return Column(
      children: [
        // Primeira linha - Boosts e Super Likes
        Row(
          children: [
            Expanded(
              child: _buildBoostCard(
                icon: '🚀',
                title: 'Boosts',
                subtitle: 'Destaque por 1h',
                onTap: _showBoostPurchaseModal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBoostCard(
                icon: '✨',
                title: 'Magic Match',
                subtitle: 'Match garantido!',
                onTap: _showMagicMatchPurchaseModal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Segunda linha - IAs e Selos
        Row(
          children: [
            Expanded(
              child: _buildBoostCard(
                icon: '🤖',
                title: 'IA - Melhore Perfil',
                subtitle: 'Otimize com IA',
                onTap: _showAIProfileHelp,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildSelosCarouselCard()),
          ],
        ),
        const SizedBox(height: 12),
        // Terceira linha - Clima e Insights com carrossel automático
        Row(
          children: [
            Expanded(child: _buildClimaCarouselCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildInsightsCarouselCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildBoostCard({required String icon, required String title, required String subtitle, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 145,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFB026FF).withOpacity(0.35),
                  const Color(0xFF9C27B0).withOpacity(0.25),
                  const Color(0xFF7B2CBF).withOpacity(0.15),
                ],
              ),
              border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB026FF).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Card de Clima com mini-carrossel automático
  Widget _buildClimaCarouselCard() {
    final climaSlides = [
      {
        'emoji': '⚽',
        'headline': '🔥 VIROU FEBRE!',
        'title': 'Corte Neymar Jr.',
        'subtitle': '+45% buscas',
        'color': '0xFFFF6B35',
      },
      {
        'emoji': '🎨',
        'headline': '⚡ EXPLOSÃO DE PEDIDOS',
        'title': 'Shadow Fade',
        'subtitle': '12M TikTok',
        'color': '0xFF9B59B6',
      },
      {
        'emoji': '👔',
        'headline': '💼 DOMINA DEZEMBRO',
        'title': 'Business Cut',
        'subtitle': 'Top 1 Corp',
        'color': '0xFF3498DB',
      },
      {
        'emoji': '🔥',
        'headline': '🎸 VOLTOU COM TUDO',
        'title': 'Mullet 2025',
        'subtitle': '+120% pedidos',
        'color': '0xFFE74C3C',
      },
      {
        'emoji': '💰',
        'headline': '❄️ ÉPOCA DE BRILHAR',
        'title': 'Platinado Natal',
        'subtitle': r'R$ 250-400',
        'color': '0xFFFFD700',
      },
    ];

    return GestureDetector(
      onTap: _showClimaModal,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 145,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFB026FF).withOpacity(0.35),
                  const Color(0xFF9C27B0).withOpacity(0.25),
                  const Color(0xFF7B2CBF).withOpacity(0.15),
                ],
              ),
              border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB026FF).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: climaSlides.length,
                  options: CarouselOptions(
                    height: 145,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final slide = climaSlides[index];
                    final color = Color(int.parse(slide['color']!));

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Emoji com borda colorida
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: color.withOpacity(0.6), width: 2),
                            ),
                            child: Text(slide['emoji']!, style: const TextStyle(fontSize: 28)),
                          ),
                          const SizedBox(height: 4),
                          // Headline bombástico
                          Text(
                            slide['headline']!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Nome do corte
                          Text(
                            slide['title']!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold, height: 1.1),
                          ),
                          const SizedBox(height: 2),
                          // Estatística
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              slide['subtitle']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.5), blurRadius: 6, spreadRadius: 1),
                      ],
                    ),
                    child: const Icon(Icons.check, size: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Card de Insights com mini-carrossel automático
  Widget _buildInsightsCarouselCard() {
    final insightsSlides = [
      {
        'emoji': '✂️',
        'headline': '💰 FATURAMENTO TOP',
        'service': 'Corte Masculino',
        'price': r'R$ 35-50',
        'trend': '+8%',
        'color': '0xFF2196F3',
      },
      {
        'emoji': '🧔',
        'headline': '📈 MARGEM ALTA 70%',
        'service': 'Barba Completa',
        'price': r'R$ 25-40',
        'trend': '+10%',
        'color': '0xFF8D6E63',
      },
      {
        'emoji': '🔥',
        'headline': '⚡ MAIS RÁPIDO 15MIN',
        'service': 'Degradê Express',
        'price': r'R$ 40-60',
        'trend': '+25%',
        'color': '0xFFFF5722',
      },
      {
        'emoji': '⭐',
        'headline': '💎 PREMIUM GOLD',
        'service': 'Platinado Luxo',
        'price': r'R$ 80-120',
        'trend': '+35%',
        'color': '0xFFFFD700',
      },
      {
        'emoji': '💼',
        'headline': '🎯 VENDA CERTA',
        'service': 'Combo VIP',
        'price': r'R$ 55-80',
        'trend': '+15%',
        'color': '0xFF9C27B0',
      },
    ];

    return GestureDetector(
      onTap: _showPricingInsights,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 145,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFB026FF).withOpacity(0.35),
                  const Color(0xFF9C27B0).withOpacity(0.25),
                  const Color(0xFF7B2CBF).withOpacity(0.15),
                ],
              ),
              border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB026FF).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: insightsSlides.length,
                  options: CarouselOptions(
                    height: 145,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final slide = insightsSlides[index];
                    final color = Color(int.parse(slide['color']!));

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Emoji com borda colorida
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: color.withOpacity(0.6), width: 2),
                            ),
                            child: Text(slide['emoji']!, style: const TextStyle(fontSize: 26)),
                          ),
                          const SizedBox(height: 3),
                          // Headline bombástico
                          Text(
                            slide['headline']!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Nome do serviço
                          Text(
                            slide['service']!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 1),
                          // Preço grande
                          Text(
                            slide['price']!,
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                              height: 1.1,
                            ),
                          ),
                          // Tendência
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('📈 ', style: TextStyle(fontSize: 6)),
                                Text(
                                  slide['trend']!,
                                  style: const TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.5), blurRadius: 6, spreadRadius: 1),
                      ],
                    ),
                    child: const Icon(Icons.check, size: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Card de Selos Premium com mini-carrossel automático
  Widget _buildSelosCarouselCard() {
    final List<Map<String, dynamic>> selosSlides = [
      {
        'badge': 'GOLD',
        'title': 'Gold Badge',
        'price': 'R\$ 29,90/mês',
        'color': '0xFFFFD700',
        'gradient': ['0xFFFFD700', '0xFFFFA500'],
        'features': ['Clima e Insights IA', 'Analytics avançado', 'Prioridade máxima'],
      },
      {
        'badge': 'SILVER',
        'title': 'Silver Badge',
        'price': 'R\$ 14,90/mês',
        'color': '0xFFC0C0C0',
        'gradient': ['0xFFE8E8E8', '0xFFC0C0C0'],
        'features': ['Boost semanal', 'Estatísticas básicas', 'Destaque no feed'],
      },
    ];

    return GestureDetector(
      onTap: _showBadgePurchaseModal,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 145,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFB026FF).withOpacity(0.35),
                  const Color(0xFF9C27B0).withOpacity(0.25),
                  const Color(0xFF7B2CBF).withOpacity(0.15),
                ],
              ),
              border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB026FF).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 145,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: false,
              ),
              items: selosSlides.map((slide) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Badge Icon
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(int.parse((slide['gradient'] as List)[0] as String)),
                                  Color(int.parse((slide['gradient'] as List)[1] as String)),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(int.parse(slide['color'] as String)).withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(child: Icon(Icons.check, size: 20, color: Colors.black)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            slide['title'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(int.parse(slide['color'] as String)),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            slide['price'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70, fontSize: 9),
                          ),
                          const SizedBox(height: 4),
                          ...((slide['features'] as List)
                              .take(3)
                              .map(
                                (feature) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1),
                                  child: Text(
                                    '• ${feature as String}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white70, fontSize: 8, height: 1.2),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Galeria de trabalhos (grid 2x2) - Cards promocionais com exemplos visuais
  Widget _buildWorkGallery() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: [
        _buildRealWorkCard(
          'https://firebasestorage.googleapis.com/v0/b/barbergo-38c21.firebasestorage.app/o/gallery%2Fcorteanuncio3nobrus.jpeg?alt=media',
          'Degradê + Freestyle',
          '@nobrubarbeiro',
          Colors.purple,
          showBadge: true,
          adType: 'corte_premium',
        ),
        _buildRealWorkCard(
          'https://firebasestorage.googleapis.com/v0/b/barbergo-38c21.firebasestorage.app/o/gallery%2Fcorteanuncio4nobrus.jpeg?alt=media',
          'Degradê + Color Freestyle',
          '@nobrubarbeiro',
          Colors.blue,
          showBadge: true,
          adType: 'degrade_profissional',
        ),
        _buildRealWorkCard(
          'https://firebasestorage.googleapis.com/v0/b/barbergo-38c21.firebasestorage.app/o/gallery%2Fanunciobarbearia1.jpeg?alt=media',
          'Barbearia Premium',
          '@nobrusbarbershopp',
          Colors.orange,
          showBadge: true,
          adType: 'barbearia_premium',
        ),
        _buildRealWorkCard(
          'https://firebasestorage.googleapis.com/v0/b/barbergo-38c21.firebasestorage.app/o/gallery%2Fanunciocorte.jpg?alt=media',
          'Degradê MID FADE',
          '@edbarber_013',
          Colors.pink,
          showBadge: true,
          adType: 'corte_artistico',
        ),
        _buildRealWorkCard(
          'https://firebasestorage.googleapis.com/v0/b/barbergo-38c21.firebasestorage.app/o/gallery%2Fanunciobarbearia2.png?alt=media',
          'Kid Degradê + Freestyle',
          '@isac_nobrusbarber',
          Colors.teal,
          showBadge: true,
          adType: 'espaco_premium',
        ),
        _buildRealWorkCard(
          'https://firebasestorage.googleapis.com/v0/b/barbergo-38c21.firebasestorage.app/o/gallery%2Fanunciocorte2.jpg?alt=media',
          'Degradê + Freestyle',
          '@wsouza_corte',
          Colors.cyan,
          showBadge: true,
          adType: 'degrade_moderno',
        ),
      ],
    );
  }

  Widget _buildRealWorkCard(
    String imageUrl,
    String title,
    String barber,
    Color accentColor, {
    bool showBadge = false,
    String? productUrl,
    String? profileId,
    String? adType,
  }) {
    return GestureDetector(
      onTap: () {
        if (productUrl != null) {
          // Se for produto, abrir URL
          _openProductUrl(productUrl);
        } else if (adType != null) {
          // Se tiver adType, mostrar modal específico do anúncio
          _showAdModal(adType, title, barber);
        } else {
          // Caso padrão - modal genérico
          _showGalleryPromoModal(title, 'Trabalho de $barber');
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Imagem de fundo
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[800],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accentColor.withOpacity(0.3), accentColor.withOpacity(0.15)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('✂️', style: TextStyle(fontSize: 40, color: Colors.white.withOpacity(0.5))),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Overlay escuro
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
            // Badge "ANÚNCIO" no topo
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: const Text(
                  'ANÚNCIO',
                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ),
            ),
            // Informações na parte inferior
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 1))],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('👤', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          barber,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            shadows: const [Shadow(color: Colors.black, blurRadius: 3, offset: Offset(0, 1))],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Modal explicativo sobre galeria de trabalhos e anúncios
  void _showGalleryPromoModal(String title, String description) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFB026FF), Color(0xFF8B1FE8)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('📸', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(description, style: const TextStyle(color: Colors.white60, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Benefícios
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2a2a2a),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✨ Benefícios de Anunciar',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem('🎯', 'Alcance Premium', 'Apareça em destaque para milhares de usuários'),
                    const SizedBox(height: 12),
                    _buildBenefitItem('📈', 'Mais Visibilidade', 'Seu trabalho visto por quem procura qualidade'),
                    const SizedBox(height: 12),
                    _buildBenefitItem('💼', 'Novos Clientes', 'Aumente sua carteira de clientes'),
                    const SizedBox(height: 12),
                    _buildBenefitItem('⭐', 'Credibilidade', 'Mostre seu profissionalismo'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Como Funciona
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF2a2a2a), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 Como Contratar',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildStepItem('1', 'Clique no botão WhatsApp abaixo'),
                    const SizedBox(height: 10),
                    _buildStepItem('2', 'Fale com nossa equipe comercial'),
                    const SizedBox(height: 10),
                    _buildStepItem('3', 'Escolha seu plano de anúncio'),
                    const SizedBox(height: 10),
                    _buildStepItem('4', 'Envie suas melhores fotos'),
                    const SizedBox(height: 10),
                    _buildStepItem('5', 'Pronto! Seu trabalho em destaque'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Destaque comercial
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF25D366).withOpacity(0.2), const Color(0xFF128C7E).withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF25D366).withOpacity(0.5)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('💎', style: TextStyle(fontSize: 40)),
                    SizedBox(height: 12),
                    Text(
                      'Planos Personalizados',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Entre em contato com nossa equipe para conhecer os planos disponíveis e condições especiais!',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Botões de Ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFB026FF)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Voltar',
                        style: TextStyle(color: Color(0xFFB026FF), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _openWhatsAppContact();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('💬', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text(
                            'Contratar via WhatsApp',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(description, style: const TextStyle(color: Colors.white60, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFB026FF), Color(0xFF8B1FE8)]),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildPlanItem(String emoji, String name, String duration, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFF1a1a1a), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(duration, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(color: Color(0xFF25D366), fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Abre URL de produto em navegador externo
  Future<void> _openProductUrl(String productUrl) async {
    try {
      final uri = Uri.parse(productUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Não foi possível abrir o link';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Erro ao abrir link: $e'), backgroundColor: Colors.red));
      }
    }
  }

  /// Modal específico para cada tipo de anúncio
  void _showAdModal(String adType, String title, String barber) {
    // Define conteúdo específico para cada tipo de anúncio
    String emoji;
    String subtitle;
    List<Map<String, String>> benefits;

    switch (adType) {
      case 'corte_premium':
        emoji = '✂️';
        subtitle = 'Corte Profissional Premium';
        benefits = [
          {'icon': '🎯', 'title': 'Técnica Apurada', 'desc': 'Cortes com precision e acabamento perfeito'},
          {'icon': '⭐', 'title': 'Estilo Único', 'desc': 'Personalização total do seu visual'},
          {'icon': '💎', 'title': 'Produtos Premium', 'desc': 'Utilizamos apenas produtos de alta qualidade'},
        ];
        break;
      case 'degrade_profissional':
        emoji = '🔥';
        subtitle = 'Degradê Profissional';
        benefits = [
          {'icon': '🎨', 'title': 'Arte no Degradê', 'desc': 'Transições perfeitas e simétricas'},
          {'icon': '⚡', 'title': 'Estilo Moderno', 'desc': 'As tendências mais atuais'},
          {'icon': '✨', 'title': 'Resultado Impecável', 'desc': 'Aprovado por quem entende'},
        ];
        break;
      case 'barbearia_premium':
        emoji = '🏆';
        subtitle = 'Barbearia Premium';
        benefits = [
          {'icon': '🏅', 'title': 'Ambiente Exclusivo', 'desc': 'Espaço moderno e confortável'},
          {'icon': '👔', 'title': 'Atendimento VIP', 'desc': 'Experiência completa de barbearia'},
          {'icon': '🎯', 'title': 'Profissionais Qualificados', 'desc': 'Equipe experiente e dedicada'},
        ];
        break;
      case 'corte_artistico':
        emoji = '🎨';
        subtitle = 'Corte Artístico';
        benefits = [
          {'icon': '✏️', 'title': 'Desenhos Personalizados', 'desc': 'Arte capilbar exclusiva'},
          {'icon': '🌟', 'title': 'Criatividade', 'desc': 'Transforme seu visual em obra de arte'},
          {'icon': '📸', 'title': 'Instagram-Worthy', 'desc': 'Cortes que viralizam'},
        ];
        break;
      case 'espaco_premium':
        emoji = '💈';
        subtitle = 'Espaço Premium';
        benefits = [
          {'icon': '🛋️', 'title': 'Conforto Total', 'desc': 'Ambiente climatizado e relaxante'},
          {'icon': '🎵', 'title': 'Experiência Completa', 'desc': 'Música ambiente e drinks'},
          {'icon': '🏅', 'title': 'Localização Privilegiada', 'desc': 'Fácil acesso e estacionamento'},
        ];
        break;
      case 'degrade_moderno':
        emoji = '⚡';
        subtitle = 'Degradê Moderno';
        benefits = [
          {'icon': '🔝', 'title': 'Tendência Atual', 'desc': 'Os estilos mais modernos'},
          {'icon': '💪', 'title': 'Versatilidade', 'desc': 'Adapta-se a qualquer estilo'},
          {'icon': '🎯', 'title': 'Precisão Técnica', 'desc': 'Execução impecável'},
        ];
        break;
      default:
        emoji = '📸';
        subtitle = 'Anúncio Premium';
        benefits = [
          {'icon': '⭐', 'title': 'Qualidade', 'desc': 'Serviço de excelência'},
          {'icon': '🎯', 'title': 'Profissionalismo', 'desc': 'Equipe qualificada'},
          {'icon': '💼', 'title': 'Confiança', 'desc': 'Resultados garantidos'},
        ];
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFB026FF), Color(0xFF8B1FE8)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(barber, style: const TextStyle(color: Colors.white60, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Subtítulo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF2a2a2a), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Benefícios específicos
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2a2a2a),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✨ Destaques',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...benefits.map(
                      (benefit) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildBenefitItem(benefit['icon']!, benefit['title']!, benefit['desc']!),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Call to Action
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF25D366).withOpacity(0.2), const Color(0xFF128C7E).withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF25D366).withOpacity(0.5)),
                ),
                child: const Column(
                  children: [
                    Text('💼', style: TextStyle(fontSize: 32)),
                    SizedBox(height: 8),
                    Text(
                      'Quer anunciar também?',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Entre em contato e conheça nossos planos!',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFB026FF)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Fechar',
                        style: TextStyle(color: Color(0xFFB026FF), fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _openWhatsAppContact();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('💬', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 6),
                          Text(
                            'Anunciar Agora',
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget de seção com título
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  /// Modal de personalização de layout (exclusivo Silver/Gold)
  // ignore: unused_element
  void _showLayoutCustomization(BuildContext context) {
    final currentProfile = ref.read(currentUserProfileProvider).value;
    final tier = currentProfile?.verificationBadge ?? VerificationBadge.none;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com badge
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: tier == VerificationBadge.gold
                            ? [const Color(0xFFFFD700), const Color(0xFFFFB300)]
                            : [const Color(0xFFC0C0C0), const Color(0xFF909090)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (tier == VerificationBadge.gold ? const Color(0xFFFFD700) : const Color(0xFFC0C0C0))
                              .withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(child: Text('🎨', style: TextStyle(fontSize: 28))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personalizar Layout',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          tier == VerificationBadge.gold ? 'Selo Gold' : 'Selo Silver',
                          style: TextStyle(
                            color: tier == VerificationBadge.gold ? const Color(0xFFFFD700) : const Color(0xFFC0C0C0),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lista de opções de customização
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildCustomizationTile(
                      icon: '📱',
                      title: 'Seções Visíveis',
                      subtitle: 'Escolha quais seções exibir no feed',
                      onTap: () => _showSectionToggle(context),
                    ),
                    _buildCustomizationTile(
                      icon: '🔄',
                      title: 'Reordenar Seções',
                      subtitle: 'Arraste para reorganizar a ordem',
                      onTap: () => _showSectionReorder(context),
                    ),
                    _buildCustomizationTile(
                      icon: '📏',
                      title: 'Tamanho dos Cards',
                      subtitle: 'Compacto, Normal ou Expandido',
                      onTap: () => _showCardSizeOptions(context),
                    ),
                    if (tier == VerificationBadge.gold) ...[
                      const Divider(color: Color(0xFF333333), height: 32),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            BadgeIcon(badge: VerificationBadge.gold, size: 16, showShadow: false),
                            SizedBox(width: 8),
                            Text(
                              'Exclusivo Gold',
                              style: TextStyle(color: Color(0xFFFFD700), fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      _buildCustomizationTile(
                        icon: '🎨',
                        title: 'Temas de Cor',
                        subtitle: 'Personalize as cores do app',
                        onTap: () => _showThemeCustomization(context),
                        isGold: true,
                      ),
                      _buildCustomizationTile(
                        icon: '✨',
                        title: 'Animações',
                        subtitle: 'Ajuste velocidade e efeitos',
                        onTap: () => _showAnimationSettings(context),
                        isGold: true,
                      ),
                    ],
                  ],
                ),
              ),

              // Footer com info
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: tier == VerificationBadge.gold
                        ? [
                            const Color(0xFFFFD700).withValues(alpha: 0.15),
                            const Color(0xFFFFB300).withValues(alpha: 0.05),
                          ]
                        : [
                            const Color(0xFFB026FF).withValues(alpha: 0.15),
                            const Color(0xFF9C27B0).withValues(alpha: 0.05),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: tier == VerificationBadge.gold ? const Color(0xFFFFD700) : const Color(0xFFB026FF),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (tier == VerificationBadge.gold ? const Color(0xFFFFD700) : const Color(0xFFB026FF))
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          tier == VerificationBadge.gold ? '💾' : '🎖️',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tier == VerificationBadge.gold
                            ? 'Personalizações Gold salvam automaticamente'
                            : 'Upgrade para Gold e desbloqueie temas e animações!',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isGold = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGold ? const Color(0xFFFFD700).withValues(alpha: 0.3) : Colors.transparent,
          width: isGold ? 2 : 0,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: isGold
                  ? [const Color(0xFFFFD700).withValues(alpha: 0.2), const Color(0xFFFFD700).withValues(alpha: 0.05)]
                  : [const Color(0xFFB026FF).withValues(alpha: 0.15), const Color(0xFFB026FF).withValues(alpha: 0.03)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isGold
                  ? const Color(0xFFFFD700).withValues(alpha: 0.3)
                  : const Color(0xFFB026FF).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 13)),
        trailing: Icon(
          Icons.chevron_right,
          color: isGold ? const Color(0xFFFFD700).withValues(alpha: 0.6) : Colors.white54,
        ),
        onTap: onTap,
      ),
    );
  }

  // Métodos de customização
  void _showSectionToggle(BuildContext context) {
    final prefsAsync = ref.read(layoutPreferencesProvider);

    if (!prefsAsync.hasValue) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Carregando preferências...')));
      return;
    }

    final prefs = prefsAsync.value!;
    final sections = {
      'motivational': '💬 Frase Motivacional',
      'tutorials': '🎬 Vídeos Tutoriais',
      'boosted': '⭐ Perfis em Destaque',
      'sponsored': '📰 Anúncios Patrocinados',
      'business': '💼 Potencialize Seu Negócio',
      'gallery': '🖼️ Anunciantes da Semana',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '📱 Seções Visíveis',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Escolha quais seções exibir no feed',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
                const SizedBox(height: 24),
                ...sections.entries.map((entry) {
                  final isVisible = prefs.visibleSections.contains(entry.key);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(color: const Color(0xFF2a2a2a), borderRadius: BorderRadius.circular(12)),
                    child: SwitchListTile(
                      title: Text(entry.value, style: const TextStyle(color: Colors.white)),
                      value: isVisible,
                      activeThumbColor: const Color(0xFFB026FF),
                      onChanged: (value) {
                        final newSections = List<String>.from(prefs.visibleSections);
                        if (value) {
                          newSections.add(entry.key);
                        } else {
                          newSections.remove(entry.key);
                        }
                        ref.read(layoutPreferencesProvider.notifier).updateVisibleSections(newSections);
                        setState(() {}); // Atualiza UI local
                      },
                    ),
                  );
                }),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB026FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Salvar', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSectionReorder(BuildContext context) {
    final prefsAsync = ref.read(layoutPreferencesProvider);

    if (!prefsAsync.hasValue) return;

    final prefs = prefsAsync.value!;
    final sections = [
      {'id': 'motivational', 'icon': '💬', 'name': 'Frase Motivacional'},
      {'id': 'tutorials', 'icon': '🎬', 'name': 'Vídeos Tutoriais'},
      {'id': 'boosted', 'icon': '⭐', 'name': 'Perfis em Destaque'},
      {'id': 'sponsored', 'icon': '📰', 'name': 'Anúncios'},
      {'id': 'business', 'icon': '💼', 'name': 'Potencialize'},
      {'id': 'gallery', 'icon': '🖼️', 'name': 'Galeria'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          var currentOrder = List<int>.from(prefs.sectionOrder);

          return Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '🔄 Reordenar Seções',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Arraste para reorganizar a ordem', style: TextStyle(color: Colors.white60, fontSize: 14)),
                const SizedBox(height: 24),
                Expanded(
                  child: ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = currentOrder.removeAt(oldIndex);
                        currentOrder.insert(newIndex, item);
                      });
                    },
                    children: currentOrder.map((index) {
                      final section = sections[index];
                      return Container(
                        key: ValueKey(section['id']),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2a2a2a),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Text(section['icon']!, style: const TextStyle(fontSize: 24)),
                          title: Text(section['name']!, style: const TextStyle(color: Colors.white)),
                          trailing: const Icon(Icons.drag_handle, color: Colors.white54),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ref.read(layoutPreferencesProvider.notifier).resetToDefault();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white30),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Resetar', style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(layoutPreferencesProvider.notifier).updateSectionOrder(currentOrder);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB026FF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Salvar Ordem', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCardSizeOptions(BuildContext context) {
    final prefsAsync = ref.read(layoutPreferencesProvider);

    if (!prefsAsync.hasValue) return;

    final prefs = prefsAsync.value!;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          var selectedSize = prefs.cardSize;

          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '📏 Tamanho dos Cards',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Escolha o tamanho ideal para você', style: TextStyle(color: Colors.white60, fontSize: 14)),
                const SizedBox(height: 24),
                ...CardSize.values.map((size) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2a2a2a),
                      borderRadius: BorderRadius.circular(12),
                      border: selectedSize == size ? Border.all(color: const Color(0xFFB026FF), width: 2) : null,
                    ),
                    child: RadioListTile<CardSize>(
                      title: Text(
                        size.label,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(size.description, style: const TextStyle(color: Colors.white60, fontSize: 13)),
                      value: size,
                      groupValue: selectedSize,
                      activeColor: const Color(0xFFB026FF),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedSize = value);
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(layoutPreferencesProvider.notifier).updateCardSize(selectedSize);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB026FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Aplicar Tamanho', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showThemeCustomization(BuildContext context) {
    final prefsAsync = ref.read(layoutPreferencesProvider);

    if (!prefsAsync.hasValue) return;

    final prefs = prefsAsync.value!;

    final themes = {
      '#B026FF': {'name': 'Roxo Original', 'emoji': '💜'},
      '#0077FF': {'name': 'Azul Oceano', 'emoji': '🌊'},
      '#00C853': {'name': 'Verde Esmeralda', 'emoji': '💚'},
      '#FF1744': {'name': 'Vermelho Rubi', 'emoji': '❤️'},
      '#FFD700': {'name': 'Dourado Real', 'emoji': '🎖️'},
      '#FF6B35': {'name': 'Laranja Sunset', 'emoji': '🌅'},
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          var selectedTheme = prefs.themeColor;

          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '🎨 Temas de Cor',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFD700)),
                      ),
                      child: const Text(
                        '🥇 Gold',
                        style: TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Escolha a paleta de cores do app', style: TextStyle(color: Colors.white60, fontSize: 14)),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: themes.entries.map((entry) {
                    final color = Color(int.parse(entry.key.substring(1), radix: 16) + 0xFF000000);
                    final isSelected = selectedTheme == entry.key;

                    return GestureDetector(
                      onTap: () => setState(() => selectedTheme = entry.key),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                          boxShadow: isSelected
                              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 12, spreadRadius: 2)]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(entry.value['emoji']!, style: const TextStyle(fontSize: 32)),
                            const SizedBox(height: 8),
                            Text(
                              entry.value['name']!,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            if (isSelected)
                              const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Icon(Icons.check_circle, color: Colors.white, size: 20),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFFFFD700), size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'O tema será aplicado em todo o aplicativo',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(layoutPreferencesProvider.notifier).updateThemeColor(selectedTheme);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎨 Tema aplicado! Recarregue o app para ver as mudanças.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(int.parse(selectedTheme.substring(1), radix: 16) + 0xFF000000),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Aplicar Tema', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAnimationSettings(BuildContext context) {
    final prefsAsync = ref.read(layoutPreferencesProvider);

    if (!prefsAsync.hasValue) return;

    final prefs = prefsAsync.value!;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          var animationDuration = prefs.animationDuration.toDouble();
          var animationsEnabled = animationDuration > 0;

          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '✨ Animações',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFD700)),
                      ),
                      child: const Text(
                        'Gold',
                        style: TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Controle de velocidade e efeitos', style: TextStyle(color: Colors.white60, fontSize: 14)),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF2a2a2a), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.motion_photos_on, color: Colors.white70),
                          const SizedBox(width: 12),
                          const Text('Habilitar Animações', style: TextStyle(color: Colors.white, fontSize: 16)),
                          const Spacer(),
                          Switch(
                            value: animationsEnabled,
                            activeThumbColor: const Color(0xFFB026FF),
                            onChanged: (value) {
                              setState(() {
                                animationsEnabled = value;
                                animationDuration = value ? 300 : 0;
                              });
                            },
                          ),
                        ],
                      ),
                      if (animationsEnabled) ...[
                        const SizedBox(height: 24),
                        const Divider(color: Color(0xFF3a3a3a)),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.speed, color: Colors.white70, size: 20),
                            const SizedBox(width: 12),
                            const Text('Velocidade', style: TextStyle(color: Colors.white70, fontSize: 14)),
                            const Spacer(),
                            Text(
                              '${animationDuration.toInt()}ms',
                              style: const TextStyle(
                                color: Color(0xFFB026FF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: const Color(0xFFB026FF),
                            inactiveTrackColor: const Color(0xFF3a3a3a),
                            thumbColor: const Color(0xFFB026FF),
                            overlayColor: const Color(0xFFB026FF).withOpacity(0.2),
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: animationDuration,
                            min: 100,
                            max: 800,
                            divisions: 14,
                            onChanged: (value) {
                              setState(() => animationDuration = value);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '🚀 Rápido',
                              style: TextStyle(
                                color: animationDuration < 250 ? const Color(0xFFB026FF) : Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '🎯 Normal',
                              style: TextStyle(
                                color: animationDuration >= 250 && animationDuration <= 350
                                    ? const Color(0xFFB026FF)
                                    : Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '🤍 Suave',
                              style: TextStyle(
                                color: animationDuration > 350 ? const Color(0xFFB026FF) : Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.tips_and_updates, color: Color(0xFFFFD700), size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Animações mais lentas podem economizar bateria',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(layoutPreferencesProvider.notifier).updateAnimationDuration(animationDuration.toInt());
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            animationsEnabled
                                ? '✨ Animações configuradas: ${animationDuration.toInt()}ms'
                                : '✨ Animações desabilitadas',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB026FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Aplicar Configurações', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Modal de compra de boosts
  void _showBoostPurchaseModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🚀 Boosts',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Seu perfil fica em destaque por 1 hora na tela inicial!',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildPurchaseOption('5 Boosts', 'R\$ 4,90', () => _handleBoostPurchase('boosts5')),
            const SizedBox(height: 12),
            _buildPurchaseOption('10 Boosts', 'R\$ 9,90', () => _handleBoostPurchase('boosts10')),
            const SizedBox(height: 12),
            _buildPurchaseOption('20 Boosts', 'R\$ 17,90', () => _handleBoostPurchase('boosts20')),
          ],
        ),
      ),
    );
  }

  /// Modal de compra de super likes
  void _showSuperLikesPurchaseModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '💕 Super Likes',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mostre interesse especial! Notificação destacada para quem você curtir.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildPurchaseOption('10 Super Likes', 'R\$ 8,90', () => _handleSuperLikePurchase('superLikes10')),
            const SizedBox(height: 12),
            _buildPurchaseOption('20 Super Likes', 'R\$ 9,90', () => _handleSuperLikePurchase('superLikes20')),
            const SizedBox(height: 12),
            _buildPurchaseOption('50 Super Likes', 'R\$ 19,90', () => _handleSuperLikePurchase('superLikes50')),
          ],
        ),
      ),
    );
  }

  /// Modal de compra de Magic Match
  void _showMagicMatchPurchaseModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✨ Magic Match', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Conecte-se diretamente com quem você escolher!', style: TextStyle(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            _buildPurchaseOption('3 Magic Match', 'R\$ 4,90', () => _handleMagicMatchPurchase('magicMatch3')),
            const SizedBox(height: 12),
            _buildPurchaseOption('10 Magic Match', 'R\$ 11,90', () => _handleMagicMatchPurchase('magicMatch10')),
            const SizedBox(height: 12),
            _buildPurchaseOption('25 Magic Match', 'R\$ 19,90', () => _handleMagicMatchPurchase('magicMatch25')),
          ],
        ),
      ),
    );
  }

  Future<void> _handleMagicMatchPurchase(String productId) async {
    if (!mounted) return;
    Navigator.pop(context);
    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      final uid = ref.read(authStateChangesProvider).value?.uid ?? '';
      String? baseUrl;
      switch (productId) {
        case 'magicMatch3':  baseUrl = StripeConfig.paymentLinkMagicMatch3;  break;
        case 'magicMatch10': baseUrl = StripeConfig.paymentLinkMagicMatch10; break;
        case 'magicMatch25': baseUrl = StripeConfig.paymentLinkMagicMatch25; break;
      }

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      if (baseUrl != null) {
        final url = uid.isNotEmpty ? '$baseUrl?client_reference_id=$uid' : baseUrl;
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        try { Navigator.of(context, rootNavigator: true).pop(); } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
      }
    }
  }

  /// Navega para tela de edição de perfil (botão "Melhorar com IA" no Home)
  void _showAIProfileHelp() {
    context.push('/profile/edit');
  }

  /// Redirecionar para tela de compra de badges
  /// Modal de preview dos selos (externo) - Carrossel antes de ir para tela completa
  void _showBadgePurchaseModal() {
    final List<Map<String, dynamic>> badgeSlides = [
      {
        'badge': 'GOLD',
        'title': 'Gold Badge',
        'subtitle': 'Selo Premium Ouro',
        'price': 'R\$ 29,90/mês',
        'features': ['🎯 Super Likes ilimitados', '🌟 Clima e Insights IA', '📊 Analytics avançado'],
        'color': '0xFFFFD700',
        'gradient': ['0xFFFFD700', '0xFFFFA500'],
      },
      {
        'badge': 'SILVER',
        'title': 'Silver Badge',
        'subtitle': 'Selo Premium Prata',
        'price': 'R\$ 14,90/mês',
        'features': ['💝 Super Likes diários', '🚀 Boost semanal', '📈 Estatísticas básicas'],
        'color': '0xFFC0C0C0',
        'gradient': ['0xFFE8E8E8', '0xFFC0C0C0'],
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '🎖️ Selos Premium',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Destaque-se e tenha recursos exclusivos',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 500,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  enlargeCenterPage: false,
                ),
                items: badgeSlides.map((slide) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(int.parse(slide['gradient']![0])).withOpacity(0.3),
                              Color(int.parse(slide['gradient']![1])).withOpacity(0.2),
                            ],
                          ),
                          border: Border.all(color: Color(int.parse(slide['color']!)).withOpacity(0.5), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Color(int.parse(slide['color']!)).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Badge Icon - Círculo com Check
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(int.parse(slide['gradient']![0])),
                                      Color(int.parse(slide['gradient']![1])),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(int.parse(slide['color']!)).withOpacity(0.6),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(Icons.check, size: 50, color: Colors.black, weight: 700),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Title
                              Text(
                                slide['title']!,
                                style: TextStyle(
                                  color: Color(int.parse(slide['color']!)),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(slide['subtitle']!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                              const SizedBox(height: 16),
                              // Price
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Color(int.parse(slide['color']!)).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Color(int.parse(slide['color']!)).withOpacity(0.5)),
                                ),
                                child: Text(
                                  slide['price']!,
                                  style: TextStyle(
                                    color: Color(int.parse(slide['color']!)),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Features
                              ...slide['features']!.map(
                                (feature) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Color(int.parse(slide['color']!)), size: 18),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(feature, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Buy Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.push('/badges-shop');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(int.parse(slide['color']!)),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                    'Assinar ${slide['badge']}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Modal de suporte IA no chat
  void _showAIChatSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💬 Assistente BarberGO',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Suporte inteligente 24/7 para suas dúvidas:',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildAIFeatureItem('❓', 'Tire dúvidas sobre o app'),
            _buildAIFeatureItem('💼', 'Ajuda com negociações'),
            _buildAIFeatureItem('📊', 'Insights de mercado'),
            _buildAIFeatureItem('🎯', 'Estratégias de crescimento'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Redirecionar para compra de badges em vez de /ai-support
                  _showBadgePurchaseModal();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB026FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Desbloquear com Badge', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Verifica se usuário tem Gold Badge e navega para tela correspondente
  void _handleGoldFeature(Widget screen) {
    final currentProfile = ref.read(currentUserProfileProvider).value;
    if (currentProfile?.hasGoldBadge == true) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    } else {
      _showBadgePurchaseModal();
    }
  }

  /// Modal de Clima com carrossel de tendências (apenas Gold)
  void _showClimaModal() async {
    final profile = ref.read(currentUserProfileProvider).value;
    final isGold = profile?.verificationBadge == VerificationBadge.gold;

    if (!isGold) {
      _showLockedFeature('Clima');
      return;
    }

    // Buscar múltiplas tendências para o carrossel
    final climaSlides = [
      {
        'title': '🔥 TRENDING #1',
        'subtitle': 'Corte Neymar',
        'content': '• Franja lateral assimétrica\n• Degradê baixo desconectado\n• Finalização com texturizador',
        'stats': '+45% buscas em 2025',
        'price': 'R\$ 50-80',
        'emoji': '⚽',
        'color': '0xFFFF6B35',
      },
      {
        'title': '✨ TÉCNICA VIRAL',
        'subtitle': 'Shadow Fade',
        'content': '• Degradê invisível premium\n• Esfumado perfeito\n• 3 níveis de profundidade',
        'stats': '12M views no TikTok',
        'price': 'R\$ 60-100',
        'emoji': '🎨',
        'color': '0xFF9B59B6',
      },
      {
        'title': '💼 EXECUTIVE STYLE',
        'subtitle': 'Business Cut',
        'content': '• Clássico moderno refinado\n• Risco lateral preciso\n• Volume controlado no topo',
        'stats': 'Top 1 em corporações',
        'price': 'R\$ 55-90',
        'emoji': '👔',
        'color': '0xFF3498DB',
      },
      {
        'title': '🎯 ALTA DEMANDA',
        'subtitle': 'Mullet Moderno',
        'content': '• Retro reinventado 2025\n• Laterais curtas + nuca longa\n• Público jovem 18-25 anos',
        'stats': '+120% em pedidos',
        'price': 'R\$ 45-75',
        'emoji': '🔥',
        'color': '0xFFE74C3C',
      },
      {
        'title': '💎 PREMIUM MASTER',
        'subtitle': 'Platinado Total',
        'content': '• Descoloração completa\n• Matização profissional\n• Hidratação intensiva',
        'stats': 'Margem 3x maior',
        'price': 'R\$ 250-400',
        'emoji': '💰',
        'color': '0xFFFFD700',
      },
    ];

    _showClimaCarousel(climaSlides);
  }

  void _showClimaCarousel(List<Map<String, String>> slides) {
    int currentSlideIndex = 0; // Rastrear slide atual

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '🌟 Clima',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.5), blurRadius: 8, spreadRadius: 1),
                      ],
                    ),
                    child: const Icon(Icons.check, size: 16, color: Colors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Tendências em tempo real do mercado', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 24),
              Expanded(
                child: CarouselSlider.builder(
                  itemCount: slides.length,
                  options: CarouselOptions(
                    height: 380,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    viewportFraction: 0.85,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentSlideIndex = index; // Atualizar índice quando slide muda
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final slide = slides[index];
                    final color = Color(int.parse(slide['color']!));

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color.withOpacity(0.4), color.withOpacity(0.2), color.withOpacity(0.1)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.6), width: 2),
                        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Emoji grande
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: color.withOpacity(0.5), width: 2),
                              ),
                              child: Text(slide['emoji']!, style: const TextStyle(fontSize: 42)),
                            ),
                            const SizedBox(height: 12),
                            // Título
                            Text(
                              slide['title']!,
                              style: TextStyle(
                                color: color,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            // Subtítulo
                            Text(
                              slide['subtitle']!,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            // Conteúdo
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: color.withOpacity(0.3)),
                              ),
                              child: Text(
                                slide['content']!,
                                style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Stats e Preço
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text('📊 STATS', style: TextStyle(color: Colors.white60, fontSize: 9)),
                                    const SizedBox(height: 3),
                                    Text(
                                      slide['stats']!,
                                      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Container(width: 1, height: 25, color: Colors.white24),
                                Column(
                                  children: [
                                    const Text('💰 PREÇO', style: TextStyle(color: Colors.white60, fontSize: 9)),
                                    const SizedBox(height: 3),
                                    Text(
                                      slide['price']!,
                                      style: const TextStyle(
                                        color: Color(0xFF4CAF50),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentSlideIndex
                          ? const Color(0xFFB026FF)
                          : const Color(0xFFB026FF).withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final currentSlide = slides[currentSlideIndex];
                    Navigator.pop(context);
                    _showAIInsight(
                      topic: currentSlide['subtitle'] ?? currentSlide['title'] ?? '',
                      contextData: currentSlide,
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Saiba mais...'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB026FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mostra insight de IA sobre tendência/clima sem expor o prompt.
  /// Chama Claude com contexto da região e exibe só o resultado.
  Future<void> _showAIInsight({
    required String topic,
    required Map<String, dynamic> contextData,
  }) async {
    // Usa this.context (State's context) — sempre válido quando mounted é true
    final profile = ref.read(currentUserProfileProvider).value;
    final location = profile?.location.isNotEmpty == true ? profile!.location : 'Florianópolis, SC';

    // Usa OverlayEntry — independe de navigator, funciona em qualquer contexto
    OverlayEntry? loadingOverlay;
    loadingOverlay = OverlayEntry(
      builder: (_) => const Material(
        color: Colors.black54,
        child: Center(child: CircularProgressIndicator(color: Color(0xFFB026FF))),
      ),
    );
    Overlay.of(context).insert(loadingOverlay);

    void closeLoading() {
      try { loadingOverlay?.remove(); } catch (_) {}
      loadingOverlay = null;
    }

    try {
      final gemini = GeminiService.create();
      final prompt =
          'Você é consultor de mercado de barbearia no Brasil, especialista em $location.\n\n'
          'Tópico: $topic\n'
          'Contexto: ${contextData['content'] ?? contextData['desc'] ?? ''}\n'
          'Dados: ${contextData['stats'] ?? ''}\n\n'
          'Gere 3 insights práticos e diferentes sobre este tópico para um barbeiro/barbearia.\n'
          'Cada insight: título curto + 2-3 frases diretas, dados reais quando possível.\n\n'
          'Retorne APENAS JSON válido (sem markdown):\n'
          '[{"titulo":"...","conteudo":"...","dica":"ação concreta em 1 frase"},'
          '{"titulo":"...","conteudo":"...","dica":"..."},'
          '{"titulo":"...","conteudo":"...","dica":"..."}]';

      final raw = await gemini.supportChat(prompt).timeout(
        const Duration(seconds: 20),
        onTimeout: () => '[]',
      );

      closeLoading();
      if (!mounted) return;

      // Parsear os insights do JSON
      List<Map<String, dynamic>> insights = [];
      try {
        final jsonStart = raw.indexOf('[');
        final jsonEnd = raw.lastIndexOf(']');
        if (jsonStart >= 0 && jsonEnd > jsonStart) {
          final parsed = jsonDecode(raw.substring(jsonStart, jsonEnd + 1)) as List;
          insights = parsed.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      } catch (_) {}

      if (insights.isEmpty) {
        insights = [{'titulo': topic, 'conteudo': raw.isNotEmpty ? raw : 'Análise indisponível no momento.', 'dica': ''}];
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF1A1A2E),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _InsightCarouselSheet(
          topic: topic,
          location: location,
          insights: insights,
        ),
      );
    } catch (e) {
      closeLoading();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro IA: ${e.toString().substring(0, e.toString().length.clamp(0, 80))}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ));
      }
    }
  }

  /// Modal de insights de preços com carrossel (apenas Gold)
  void _showPricingInsights() {
    final profile = ref.read(currentUserProfileProvider).value;
    final isGold = profile?.verificationBadge == VerificationBadge.gold;

    if (!isGold) {
      _showLockedFeature('Insights de Preços');
      return;
    }

    final insights = [
      {
        'title': 'Corte Masculino',
        'priceRange': 'R\$ 35-50',
        'insight': 'Média regional 2025',
        'emoji': '✂️',
        'demand': 'Alta',
        'trend': '+8%',
        'duration': '30-45 min',
        'margin': '75%',
        'color': '0xFF2196F3',
      },
      {
        'title': 'Barba Completa',
        'priceRange': 'R\$ 25-40',
        'insight': 'Crescimento sólido',
        'emoji': '🧔',
        'demand': 'Média',
        'trend': '+10%',
        'duration': '20-30 min',
        'margin': '70%',
        'color': '0xFF8D6E63',
      },
      {
        'title': 'Degradê Premium',
        'priceRange': 'R\$ 40-60',
        'insight': 'Altíssima procura',
        'emoji': '🔥',
        'demand': 'Muito Alta',
        'trend': '+25%',
        'duration': '40-60 min',
        'margin': '80%',
        'color': '0xFFFF5722',
      },
      {
        'title': 'Platinado Master',
        'priceRange': 'R\$ 80-120',
        'insight': 'Tendência Premium',
        'emoji': '⭐',
        'demand': 'Alta',
        'trend': '+35%',
        'duration': '90-120 min',
        'margin': '85%',
        'color': '0xFFFFD700',
      },
      {
        'title': 'Combo VIP',
        'priceRange': 'R\$ 55-80',
        'insight': 'Mais vendido 2025',
        'emoji': '💼',
        'demand': 'Muito Alta',
        'trend': '+15%',
        'duration': '60-75 min',
        'margin': '78%',
        'color': '0xFF9C27B0',
      },
    ];

    int currentInsightIndex = 0; // 🎯 Rastrear insight atual

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '📊 Insights de Preços',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.5), blurRadius: 8, spreadRadius: 1),
                      ],
                    ),
                    child: const Icon(Icons.check, size: 16, color: Colors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Deslize para ver análises reais do mercado',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: CarouselSlider.builder(
                  itemCount: insights.length,
                  options: CarouselOptions(
                    height: 360,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    viewportFraction: 0.85,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentInsightIndex = index; // 🎯 Atualizar quando muda de slide
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final insight = insights[index];
                    final color = Color(int.parse(insight['color'] as String));

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color.withOpacity(0.4), color.withOpacity(0.2), color.withOpacity(0.1)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.6), width: 2),
                        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Emoji + Badge de demanda
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: color.withOpacity(0.5), width: 1.5),
                                  ),
                                  child: Text(insight['emoji'] as String, style: const TextStyle(fontSize: 34)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF5722),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(color: const Color(0xFFFF5722).withOpacity(0.4), blurRadius: 6),
                                    ],
                                  ),
                                  child: Text(
                                    insight['demand'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 6,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Título do serviço
                            Text(
                              insight['title'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            // Faixa de preço grande
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.1)]),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: color.withOpacity(0.5)),
                              ),
                              child: Text(
                                insight['priceRange'] as String,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Grid de informações
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: color.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildInsightStat('📈', 'Tendência', insight['trend'] as String, color),
                                      _buildInsightStat('⏱️', 'Duração', insight['duration'] as String, color),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildInsightStat('💰', 'Margem', insight['margin'] as String, color),
                                      _buildInsightStat('✨', 'Status', insight['insight'] as String, color),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: List.generate(
                  insights.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentInsightIndex
                          ? const Color(0xFFB026FF)
                          : const Color(0xFFB026FF).withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 🎯 Pegar APENAS o insight atual
                    final currentInsight = insights[currentInsightIndex];
                    Navigator.pop(context);
                    _showAIInsight(
                      topic: '${currentInsight['title']} — ${currentInsight['priceRange']}',
                      contextData: {
                        'content': currentInsight['insight'],
                        'stats': 'Tendência: ${currentInsight['trend']} | Margem: ${currentInsight['margin']} | Demanda: ${currentInsight['demand']}',
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB026FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Saiba mais...', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper para criar estatísticas nos cards de insights
  Widget _buildInsightStat(String emoji, String label, String value, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Modal para features bloqueadas (apenas Gold)
  void _showLockedFeature(String featureName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BadgeIcon(badge: VerificationBadge.gold, size: 100, showShadow: true),
            const SizedBox(height: 24),
            Text(
              'Exclusivo Gold',
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '$featureName está disponível apenas para membros Gold',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showBadgePurchaseModal();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BadgeIcon(badge: VerificationBadge.gold, size: 24, showShadow: false),
                    SizedBox(width: 12),
                    Text('Upgrade para Gold', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseOption(String title, String price, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFB026FF).withOpacity(0.2), const Color(0xFF9C27B0).withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              price,
              style: const TextStyle(color: Color(0xFFB026FF), fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIFeatureItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingInsightItem(String service, String price, String insight) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB026FF).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(insight, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(color: Color(0xFFB026FF), fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Abre WhatsApp para contato com os desenvolvedores sobre anúncios
  Future<void> _openWhatsAppContact() async {
    const phone = '5548999746918'; // Número da equipe comercial BarberGO
    const message = '''
🎯 Olá! Vim pelo app BarberGO e gostaria de anunciar meu trabalho na galeria premium!

📋 Tenho interesse em saber mais sobre:
• Planos disponíveis e valores
• Duração dos anúncios
• Como enviar minhas fotos
• Formas de pagamento

Aguardo retorno! 💈✨
''';
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Não foi possível abrir o WhatsApp';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Erro ao abrir WhatsApp. Verifique se está instalado.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Processa compra de boosts via Stripe
  Future<void> _handleBoostPurchase(String productId) async {
    if (!mounted) return;

    // Fecha o modal de forma segura
    try {
      Navigator.of(context, rootNavigator: false).pop();
    } catch (e) {
      debugPrint('⚠️ Erro ao fechar modal: $e');
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final stripeService = ref.read(stripeServiceProvider);
      String? checkoutUrl;

      switch (productId) {
        case 'boosts5':
          checkoutUrl = await stripeService.buyBoosts5().timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Timeout: servidor demorou muito'),
          );
          break;
        case 'boosts10':
          checkoutUrl = await stripeService.buyBoosts10().timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Timeout: servidor demorou muito'),
          );
          break;
        case 'boosts20':
          checkoutUrl = await stripeService.buyBoosts20().timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Timeout: servidor demorou muito'),
          );
          break;
      }

      if (!mounted) return;

      // Fecha o loading de forma segura
      try {
        Navigator.of(context, rootNavigator: true).pop();
      } catch (e) {
        debugPrint('⚠️ Erro ao fechar loading: $e');
      }

      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
        final url = uid.isNotEmpty ? '$checkoutUrl?client_reference_id=$uid' : checkoutUrl;
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Não foi possível abrir o checkout')));
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Erro ao criar sessão de pagamento')));
      }
    } catch (e) {
      if (mounted) {
        try { Navigator.of(context, rootNavigator: true).pop(); } catch (popError) { debugPrint('⚠️ $popError'); }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
      }
    }
  }

  /// Processa compra de super likes via Stripe
  Future<void> _handleSuperLikePurchase(String productId) async {
    if (!mounted) return;
    Navigator.pop(context); // Fecha o modal

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final stripeService = ref.read(stripeServiceProvider);
      String? checkoutUrl;

      switch (productId) {
        case 'superLikes10':
          checkoutUrl = await stripeService.buySuperLikes10();
          break;
        case 'superLikes20':
          checkoutUrl = await stripeService.buySuperLikes20();
          break;
        case 'superLikes50':
          checkoutUrl = await stripeService.buySuperLikes50();
          break;
      }

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Fecha o loading

      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        final uri = Uri.parse(checkoutUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('❌ Não foi possível abrir o checkout')));
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('❌ Erro ao criar sessão de pagamento')));
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fecha o loading
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
      }
    }
  }

  /// Processa compra de badges/selos via Stripe
  Future<void> _handleBadgePurchase(String productId) async {
    if (!mounted) return;
    Navigator.pop(context); // Fecha o modal

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final stripeService = ref.read(stripeServiceProvider);
      String? checkoutUrl;

      switch (productId) {
        case 'silverMonthly':
          checkoutUrl = await stripeService.subscribeSilverMonthly().timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Timeout: servidor demorou muito'),
          );
          break;
        case 'silverYearly':
          checkoutUrl = await stripeService.subscribeSilverYearly().timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Timeout: servidor demorou muito'),
          );
          break;
        case 'goldMonthly':
          checkoutUrl = await stripeService.subscribeGoldMonthly().timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Timeout: servidor demorou muito'),
          );
          break;
        case 'goldYearly':
          checkoutUrl = await stripeService.subscribeGoldYearly().timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Timeout: servidor demorou muito'),
          );
          break;
      }

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Fecha o loading

      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        final uri = Uri.parse(checkoutUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('❌ Não foi possível abrir o checkout')));
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('❌ Erro ao criar sessão de pagamento')));
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fecha o loading
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
      }
    }
  }

  /// Botão flutuante de Assistente de IA (estilo BarberGO - roxo neon)
  Widget _buildAiFloatingButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB026FF), Color(0xFF8B2CAB)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFFB026FF).withOpacity(0.6), blurRadius: 24, spreadRadius: 3)],
      ),
      child: FloatingActionButton.extended(
        heroTag: 'home_ai_fab', // Tag única para evitar conflito
        onPressed: () {
          // Navegar para AI Support usando go_router
          context.push('/ai-support');
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        label: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Text('🤖', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 8),
            const Text(
              'IA',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Modal de carrossel de sugestões de BIO ──────────────────────────────────

class _BioBioCarouselModal extends StatefulWidget {
  final ProfileEntity profile;
  final int maxSuggestions;
  final void Function(String bio) onConfirm;

  const _BioBioCarouselModal({
    required this.profile,
    required this.maxSuggestions,
    required this.onConfirm,
  });

  @override
  State<_BioBioCarouselModal> createState() => _BioBioCarouselModalState();
}

class _BioBioCarouselModalState extends State<_BioBioCarouselModal> {
  final List<String> _suggestions = [];
  bool _isGenerating = false;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _generate(); // gera a primeira sugestão automaticamente
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_isGenerating) return;
    if (_suggestions.length >= widget.maxSuggestions) return;

    setState(() => _isGenerating = true);
    try {
      final gemini = GeminiService.create();
      final result = await gemini.improveProfile(
        currentBio: widget.profile.bio.isNotEmpty ? widget.profile.bio : '',
        specialties: widget.profile.services.take(5).toList(),
        yearsExperience: 3,
        name: widget.profile.name,
        location: widget.profile.location,
        isBarbershop: widget.profile.accountType == AccountType.barbershop,
      ).timeout(const Duration(seconds: 25));

      // Se não tem serviços cadastrados, avisa o usuário
      if (result['needs_services'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✂️ Adicione seus serviços antes de gerar a bio — ela fica muito melhor!'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      // Pega todas as bios retornadas de uma vez
      final bios = (result['bios'] as List<dynamic>?)
          ?.map((b) => (b as String).trim())
          .where((b) => b.isNotEmpty)
          .take(widget.maxSuggestions - _suggestions.length)
          .toList() ?? [];

      // Fallback para campo legado
      if (bios.isEmpty) {
        final legacy = (result['improved_bio'] as String? ?? '').trim();
        if (legacy.isNotEmpty) bios.add(legacy);
      }

      if (bios.isNotEmpty) {
        setState(() {
          _suggestions.addAll(bios);
          _currentIndex = _suggestions.length - 1;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao gerar bio: ${e.toString().substring(0, e.toString().length.clamp(0, 60))}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canGenerate = _suggestions.length < widget.maxSuggestions && !_isGenerating;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                const Text('✨ Sugestões de Bio com IA',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (_suggestions.isNotEmpty)
                  Text(
                    '${_currentIndex + 1} / ${_suggestions.length}${widget.maxSuggestions > _suggestions.length ? " (máx ${widget.maxSuggestions})" : ""}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.maxSuggestions == 5
                  ? 'Gold: até 5 sugestões geradas pela IA'
                  : 'Silver: até 2 sugestões geradas pela IA',
              style: const TextStyle(color: Color(0xFFB026FF), fontSize: 12),
            ),
            const SizedBox(height: 16),

            // Carrossel de sugestões
            Expanded(
              child: _isGenerating && _suggestions.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xFFB026FF)),
                          SizedBox(height: 12),
                          Text('Gerando sua bio personalizada...',
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      itemCount: _suggestions.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: i == _currentIndex
                                  ? const Color(0xFFB026FF)
                                  : Colors.white12,
                              width: i == _currentIndex ? 1.5 : 1,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _suggestions[i],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),

            // Indicadores de página
            if (_suggestions.length > 1) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_suggestions.length, (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _currentIndex ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _currentIndex
                        ? const Color(0xFFB026FF)
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                )),
              ),
            ],

            const SizedBox(height: 16),

            // Botões
            Row(
              children: [
                // Gerar outra
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: canGenerate ? _generate : null,
                    icon: _isGenerating
                        ? const SizedBox(
                            width: 14, height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFB026FF)))
                        : const Icon(Icons.refresh, size: 16),
                    label: Text(
                      canGenerate
                          ? 'Gerar outra (${widget.maxSuggestions - _suggestions.length} restantes)'
                          : 'Limite atingido',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB026FF),
                      side: const BorderSide(color: Color(0xFFB026FF)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Confirmar
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _suggestions.isEmpty ? null : () {
                      final selected = _suggestions[_currentIndex];
                      Navigator.pop(context);
                      widget.onConfirm(selected);
                    },
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Confirmar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB026FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Carrossel de Insights da IA ──────────────────────────────────────────────

class _InsightCarouselSheet extends StatefulWidget {
  final String topic;
  final String location;
  final List<Map<String, dynamic>> insights;

  const _InsightCarouselSheet({
    required this.topic,
    required this.location,
    required this.insights,
  });

  @override
  State<_InsightCarouselSheet> createState() => _InsightCarouselSheetState();
}

class _InsightCarouselSheetState extends State<_InsightCarouselSheet> {
  int _current = 0;
  final PageController _pc = PageController();

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.9,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: Text(widget.topic,
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
              ),
              Text('${_current + 1}/${widget.insights.length}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ]),
            Text(widget.location, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 16),
            Expanded(
              child: PageView.builder(
                controller: _pc,
                itemCount: widget.insights.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) {
                  final ins = widget.insights[i];
                  return SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(13),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withAlpha(30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ins['titulo']?.toString() ?? '',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text(ins['conteudo']?.toString() ?? '',
                              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
                          if ((ins['dica']?.toString() ?? '').isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB026FF).withAlpha(40),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('💡 ', style: TextStyle(fontSize: 14)),
                                  Expanded(
                                    child: Text(ins['dica']!.toString(),
                                        style: const TextStyle(color: Colors.white, fontSize: 13)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.insights.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _current == i ? 20 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: _current == i ? const Color(0xFFB026FF) : Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
