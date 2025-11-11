import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/swipe_repository.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../profile/screens/profile_detail_screen.dart';
import '../controllers/swipe_controller.dart';

/// Tela "Ver Quem Curtiu" (Feature Premium)
/// Mostra grid de perfis que deram like no usuário
class WhoLikedMeScreen extends ConsumerStatefulWidget {
  const WhoLikedMeScreen({super.key});

  @override
  ConsumerState<WhoLikedMeScreen> createState() => _WhoLikedMeScreenState();
}

class _WhoLikedMeScreenState extends ConsumerState<WhoLikedMeScreen> {
  List<ProfileEntity> _profilesWhoLikedMe = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfilesWhoLikedMe();
  }

  Future<void> _loadProfilesWhoLikedMe() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUserId = ref.read(authRepositoryProvider).currentUser?.uid;
      if (currentUserId == null) {
        setState(() {
          _errorMessage = 'Usuário não autenticado';
          _isLoading = false;
        });
        return;
      }

      // Verificar se o usuário é premium
      final userProfile = await ref.read(profileRepositoryProvider).getProfile(currentUserId);
      if (userProfile == null || !userProfile.hasActivePremium) {
        setState(() {
          _errorMessage = 'Feature exclusiva para usuários Premium';
          _isLoading = false;
        });
        return;
      }

      // Buscar swipes onde toUserId == currentUser && liked == true
      final swipes = await ref.read(swipeRepositoryProvider).getSwipesReceivedByUser(currentUserId);

      // Filtrar apenas likes
      final likesReceived = swipes.where((swipe) => swipe.liked).toList();

      // Buscar perfis dos usuários que curtiram
      final profiles = <ProfileEntity>[];
      for (final swipe in likesReceived) {
        final profile = await ref.read(profileRepositoryProvider).getProfile(swipe.fromUserId);
        if (profile != null) {
          profiles.add(profile);
        }
      }

      setState(() {
        _profilesWhoLikedMe = profiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar perfis: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ver Quem Curtiu'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorState()
          : _profilesWhoLikedMe.isEmpty
          ? _buildEmptyState()
          : _buildGridView(),
    );
  }

  Widget _buildErrorState() {
    final isPremiumError = _errorMessage!.contains('Premium');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPremiumError ? Icons.workspace_premium : Icons.error_outline,
              size: 80,
              color: isPremiumError ? Colors.amber : Colors.red,
            ),
            const SizedBox(height: 24),
            Text(
              isPremiumError ? 'Feature Premium' : 'Ops!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (isPremiumError)
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navegar para tela Premium
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Navegue para a tela Premium no menu!')));
                },
                icon: const Icon(Icons.workspace_premium),
                label: const Text('Assinar Premium'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              )
            else
              ElevatedButton(onPressed: _loadProfilesWhoLikedMe, child: const Text('Tentar Novamente')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            const Text('Ninguém te curtiu ainda', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text(
              'Continue explorando perfis e dando likes!\nQuando alguém te curtir, aparecerá aqui.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.explore),
              label: const Text('Voltar ao Discovery'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return CustomScrollView(
      slivers: [
        // Header com contador
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.workspace_premium, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Feature Premium',
                            style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${_profilesWhoLikedMe.length} ${_profilesWhoLikedMe.length == 1 ? "pessoa curtiu" : "pessoas curtiram"} você',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Toque em um perfil para ver detalhes ou dê like de volta para match instantâneo!',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Grid de perfis
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final profile = _profilesWhoLikedMe[index];
              return _buildProfileCard(profile);
            }, childCount: _profilesWhoLikedMe.length),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildProfileCard(ProfileEntity profile) {
    return GestureDetector(
      onTap: () => _onProfileTap(profile),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagem de fundo
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: profile.portfolioUrls.isNotEmpty
                  ? Image.network(
                      profile.portfolioUrls.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                    )
                  : profile.avatarUrl != null
                  ? Image.network(
                      profile.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),

            // Gradiente
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),

            // Badge Premium
            if (profile.hasActivePremium)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                ),
              ),

            // Informações
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.name}, ${_calculateAge(profile.birthDate)}',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile.city}, ${profile.state}',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _onLikeBack(profile),
                        icon: const Icon(Icons.favorite, size: 16),
                        label: const Text('Match!', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(Icons.person, size: 64, color: Colors.grey.shade600),
    );
  }

  int _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return 0;
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _onProfileTap(ProfileEntity profile) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileDetailScreen(userId: profile.userId)));
  }

  Future<void> _onLikeBack(ProfileEntity profile) async {
    // Dar like de volta para match instantâneo
    final success = await ref.read(swipeControllerProvider.notifier).swipe(profile.userId, true);

    if (!mounted) return;

    if (success) {
      setState(() {
        _profilesWhoLikedMe.remove(profile);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('É um match com ${profile.name}! 💚🎉'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao dar like. Tente novamente.'), backgroundColor: Colors.red));
    }
  }
}
