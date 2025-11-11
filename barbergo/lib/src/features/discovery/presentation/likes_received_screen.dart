import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../screens/premium_screen.dart';
import '../../../data/models/swipe_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../services/stripe_service.dart';
import '../controllers/likes_received_controller.dart';

/// Tela "Ver Quem Curtiu Você" - Premium Feature
/// Free users: veem quantidade + perfis desfocados + CTA para upgrade
/// Premium users: veem perfis completos + botão "Dar Like de Volta"
class LikesReceivedScreen extends ConsumerStatefulWidget {
  const LikesReceivedScreen({super.key});

  @override
  ConsumerState<LikesReceivedScreen> createState() => _LikesReceivedScreenState();
}

class _LikesReceivedScreenState extends ConsumerState<LikesReceivedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💖 Quem Curtiu Você'), backgroundColor: Colors.pink.shade400),
      body: FutureBuilder<bool>(
        future: ref.read(likesReceivedControllerProvider.notifier).canSeeWhoLiked(),
        builder: (context, canSeeSnapshot) {
          if (canSeeSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final canSee = canSeeSnapshot.data ?? false;

          return StreamBuilder<List<SwipeEntity>>(
            stream: ref.read(likesReceivedControllerProvider.notifier).watchLikesReceived(),
            builder: (context, likesSnapshot) {
              if (likesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final likes = likesSnapshot.data ?? [];

              if (likes.isEmpty) {
                return _buildEmptyState(canSee);
              }

              if (canSee) {
                // Premium: mostra perfis completos
                return _buildPremiumView(likes);
              } else {
                // Free: mostra perfis desfocados + CTA
                return _buildFreeView(likes);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isPremium) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              isPremium ? 'Ninguém curtiu você ainda' : 'Comece a dar likes!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isPremium ? 'Continue swipando para encontrar matches!' : 'Quando alguém curtir você, aparecerá aqui',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// View para FREE users: perfis desfocados + CTA
  Widget _buildFreeView(List<SwipeEntity> likes) {
    return Column(
      children: [
        // Header com contagem
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.pink.shade400, Colors.orange.shade400])),
          child: Column(
            children: [
              const Icon(Icons.favorite, size: 48, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                '${likes.length} ${likes.length == 1 ? "pessoa curtiu" : "pessoas curtiram"} você!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Veja quem são e dê match imediatamente',
                style: TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // Grid de perfis desfocados
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: likes.length,
            itemBuilder: (context, index) {
              return _buildBlurredCard(likes[index]);
            },
          ),
        ),

        // CTA fixo no bottom
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Ver Quem Curtiu - Seja Premium',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Card desfocado (free users)
  Widget _buildBlurredCard(SwipeEntity swipe) {
    return FutureBuilder<ProfileEntity?>(
      future: ref.read(likesReceivedControllerProvider.notifier).getProfileFromSwipe(swipe),
      builder: (context, snapshot) {
        final profile = snapshot.data;

        return Stack(
          children: [
            // Imagem desfocada
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
                image: profile?.avatarUrl != null
                    ? DecorationImage(image: NetworkImage(profile!.avatarUrl!), fit: BoxFit.cover)
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              ),
            ),

            // Badge de Super Like (se aplicável)
            if (swipe.isSuperLike)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.star, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'SUPER',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

            // Lock icon
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
                ),
                child: const Icon(Icons.lock, size: 28, color: Colors.pink),
              ),
            ),
          ],
        );
      },
    );
  }

  /// View para PREMIUM users: perfis completos
  Widget _buildPremiumView(List<SwipeEntity> likes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: likes.length,
      itemBuilder: (context, index) {
        return _buildPremiumCard(likes[index]);
      },
    );
  }

  /// Card completo (premium users)
  Widget _buildPremiumCard(SwipeEntity swipe) {
    return FutureBuilder<ProfileEntity?>(
      future: ref.read(likesReceivedControllerProvider.notifier).getProfileFromSwipe(swipe),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            margin: EdgeInsets.only(bottom: 16),
            child: SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
          );
        }

        final profile = snapshot.data;
        if (profile == null) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              // TODO: Navegar para perfil completo
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                        child: profile.avatarUrl == null
                            ? Text(profile.name[0].toUpperCase(), style: const TextStyle(fontSize: 32))
                            : null,
                      ),

                      // Super Like badge
                      if (swipe.isSuperLike)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                            child: const Icon(Icons.star, color: Colors.white, size: 16),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        if (profile.location.isNotEmpty)
                          Text(profile.location, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                        const SizedBox(height: 4),
                        if (swipe.isSuperLike)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.blue, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Te deu Super Like!',
                                  style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Botão "Dar Like de Volta"
                  ElevatedButton(
                    onPressed: () async {
                      final success = await ref.read(likesReceivedControllerProvider.notifier).likeBack(profile.userId);

                      if (success) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('🎉 É um Match!'), backgroundColor: Colors.green),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [Icon(Icons.favorite, size: 18), SizedBox(width: 4), Text('Curtir')],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
