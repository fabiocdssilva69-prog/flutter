import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../profile/screens/profile_detail_screen.dart';
import '../controllers/swipe_controller.dart';
import '../widgets/tinder_card.dart';

/// Tela principal de Discovery (Tinder-like)
/// Mostra stack de cards de perfis para o usuário dar swipe
class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final List<ProfileEntity> _profiles = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Controllers para swipe programático
  final List<GlobalKey<TinderCardState>> _cardKeys = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
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

      // Buscar perfis disponíveis (TODO: implementar lógica de filtros e já visto)
      final allProfiles = await ref.read(profileRepositoryProvider).getAllProfiles();

      // Filtrar: remover perfil próprio
      final filteredProfiles = allProfiles.where((p) => p.userId != currentUserId).toList();

      // TODO: Filtrar perfis já visualizados (swipes já feitos)
      // TODO: Aplicar filtros de distância, tipo de serviço, etc

      setState(() {
        _profiles.clear();
        _profiles.addAll(filteredProfiles);
        _cardKeys.clear();
        for (int i = 0; i < _profiles.length; i++) {
          _cardKeys.add(GlobalKey<_TinderCardState>());
        }
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
      appBar: AppBar(
        title: const Text('Descobrir'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Abrir tela de filtros
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filtros em breve!')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // TODO: Abrir tela "Ver Quem Curtiu" (premium feature)
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Ver Quem Curtiu - Feature Premium!')));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorState()
          : _profiles.isEmpty
          ? _buildEmptyState()
          : _buildCardStack(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(_errorMessage!, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _loadProfiles, child: const Text('Tentar Novamente')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Não há mais perfis por aqui!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Que tal ajustar seus filtros ou voltar mais tarde?',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadProfiles,
            icon: const Icon(Icons.refresh),
            label: const Text('Recarregar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    return Column(
      children: [
        // Stack de cards
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Mostrar até 3 cards por vez para efeito de profundidade
              for (int i = _profiles.length - 1; i >= 0 && i >= _profiles.length - 3; i--) _buildCard(i),
            ],
          ),
        ),

        // Botões de ação
        _buildActionButtons(),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCard(int index) {
    final profile = _profiles[index];
    final isTop = index == _profiles.length - 1;

    // Efeito de profundidade: cards de trás ficam menores e mais embaixo
    final offset = (_profiles.length - 1 - index) * 8.0;
    final scale = 1.0 - ((_profiles.length - 1 - index) * 0.05);

    return Positioned(
      top: offset,
      left: 0,
      right: 0,
      child: Transform.scale(
        scale: scale,
        child: TinderCard(
          key: isTop ? _cardKeys[index] : null,
          profile: profile,
          isTop: isTop,
          onSwipeLeft: () => _onSwipeLeft(profile),
          onSwipeRight: () => _onSwipeRight(profile),
          onSwipeUp: () => _onSwipeUp(profile),
          onTap: () => _onCardTap(profile),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final canSwipe = _profiles.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Botão PASS (Dislike)
          _buildActionButton(
            icon: Icons.close,
            color: Colors.red,
            size: 60,
            iconSize: 32,
            enabled: canSwipe,
            onTap: () => _onPassButtonTap(),
          ),

          // Botão SUPER LIKE
          _buildActionButton(
            icon: Icons.star,
            color: Colors.blue,
            size: 50,
            iconSize: 28,
            enabled: canSwipe,
            onTap: () => _onSuperLikeButtonTap(),
          ),

          // Botão LIKE
          _buildActionButton(
            icon: Icons.favorite,
            color: Colors.green,
            size: 60,
            iconSize: 32,
            enabled: canSwipe,
            onTap: () => _onLikeButtonTap(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required double iconSize,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade300,
          shape: BoxShape.circle,
          boxShadow: enabled
              ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]
              : null,
        ),
        child: Icon(icon, color: enabled ? color : Colors.grey, size: iconSize),
      ),
    );
  }

  // Swipe handlers
  void _onSwipeLeft(ProfileEntity profile) {
    _handleSwipe(profile, liked: false, isSuperLike: false);
  }

  void _onSwipeRight(ProfileEntity profile) {
    _handleSwipe(profile, liked: true, isSuperLike: false);
  }

  void _onSwipeUp(ProfileEntity profile) {
    _handleSwipe(profile, liked: true, isSuperLike: true);
  }

  Future<void> _handleSwipe(ProfileEntity profile, {required bool liked, required bool isSuperLike}) async {
    // Remover card da lista
    setState(() {
      _profiles.removeLast();
      _cardKeys.removeLast();
    });

    // Executar lógica de swipe
    if (isSuperLike) {
      final success = await ref.read(swipeControllerProvider.notifier).superLike(profile.userId);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Super Like enviado para ${profile.name}! ⭐'), backgroundColor: Colors.blue),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você não tem Super Likes disponíveis. Assine Premium!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      final success = await ref.read(swipeControllerProvider.notifier).swipe(profile.userId, liked);

      if (!mounted) return;

      if (success && liked) {
        // Verificar se deu match (isso é feito automaticamente no controller)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Você curtiu ${profile.name}! 💚'), backgroundColor: Colors.green));
      }
    }

    // Recarregar se acabaram os perfis
    if (_profiles.isEmpty) {
      _loadProfiles();
    }
  }

  void _onCardTap(ProfileEntity profile) {
    // Abrir perfil detalhado
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileDetailScreen(userId: profile.userId)));
  }

  // Button tap handlers (swipe programático)
  void _onPassButtonTap() {
    if (_profiles.isEmpty) return;

    final lastIndex = _profiles.length - 1;
    final key = _cardKeys[lastIndex];

    // Trigger swipe animation
    key.currentState?.swipe(SwipeDirection.left);
  }

  void _onLikeButtonTap() {
    if (_profiles.isEmpty) return;

    final lastIndex = _profiles.length - 1;
    final key = _cardKeys[lastIndex];

    // Trigger swipe animation
    key.currentState?.swipe(SwipeDirection.right);
  }

  void _onSuperLikeButtonTap() {
    if (_profiles.isEmpty) return;

    final lastIndex = _profiles.length - 1;
    final key = _cardKeys[lastIndex];

    // Trigger swipe animation
    key.currentState?.swipe(SwipeDirection.up);
  }
}
