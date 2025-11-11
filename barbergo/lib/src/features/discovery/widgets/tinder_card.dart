import 'dart:math';

import 'package:flutter/material.dart';

import '../../../domain/entities/profile_entity.dart';

/// Widget de card estilo Tinder com animações de swipe
/// Suporta arrastar para esquerda (dislike), direita (like) e cima (super like)
class TinderCard extends StatefulWidget {
  const TinderCard({
    required this.profile,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onSwipeUp,
    required this.onTap,
    this.isTop = false,
    super.key,
  });

  final ProfileEntity profile;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeUp;
  final VoidCallback onTap;
  final bool isTop;

  @override
  State<TinderCard> createState() => TinderCardState();
}

class TinderCardState extends State<TinderCard> with SingleTickerProviderStateMixin {
  Offset _position = Offset.zero;
  bool _isDragging = false;
  double _angle = 0;
  Size _screenSize = Size.zero;

  // Limiares para swipe
  static const double _swipeThreshold = 100.0;
  static const double _superLikeThreshold = -80.0;

  // Animação de retorno
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: widget.isTop ? widget.onTap : null,
      onPanStart: widget.isTop ? _onPanStart : null,
      onPanUpdate: widget.isTop ? _onPanUpdate : null,
      onPanEnd: widget.isTop ? _onPanEnd : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Interpolar posição durante animação de retorno
          final position = _isDragging ? _position : Offset.zero;

          return Transform.translate(
            offset: position,
            child: Transform.rotate(angle: _angle, child: child),
          );
        },
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    // Calcular opacidade dos overlays baseado na posição
    final likeOpacity = _position.dx > 0 ? (_position.dx / _swipeThreshold).clamp(0.0, 1.0) : 0.0;
    final dislikeOpacity = _position.dx < 0 ? (-_position.dx / _swipeThreshold).clamp(0.0, 1.0) : 0.0;
    final superLikeOpacity = _position.dy < 0 ? (-_position.dy / -_superLikeThreshold).clamp(0.0, 1.0) : 0.0;

    return Container(
      height: _screenSize.height * 0.65,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo
          _buildProfileImage(),

          // Gradiente para melhorar legibilidade
          _buildGradientOverlay(),

          // Overlay de LIKE (direita)
          if (likeOpacity > 0)
            _buildOverlay(
              opacity: likeOpacity,
              color: Colors.green,
              icon: Icons.favorite,
              label: 'LIKE',
              alignment: Alignment.topLeft,
            ),

          // Overlay de NOPE (esquerda)
          if (dislikeOpacity > 0)
            _buildOverlay(
              opacity: dislikeOpacity,
              color: Colors.red,
              icon: Icons.close,
              label: 'NOPE',
              alignment: Alignment.topRight,
            ),

          // Overlay de SUPER LIKE (cima)
          if (superLikeOpacity > 0)
            _buildOverlay(
              opacity: superLikeOpacity,
              color: Colors.blue,
              icon: Icons.star,
              label: 'SUPER LIKE',
              alignment: Alignment.bottomCenter,
            ),

          // Informações do perfil
          _buildProfileInfo(),

          // Badge Premium (se aplicável)
          if (widget.profile.hasActivePremium) _buildPremiumBadge(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: widget.profile.portfolioUrls.isNotEmpty
          ? Image.network(
              widget.profile.portfolioUrls.first,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
            )
          : widget.profile.avatarUrl != null
          ? Image.network(
              widget.profile.avatarUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(Icons.person, size: 100, color: Colors.grey.shade600),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.transparent, Colors.black.withOpacity(0.7)],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildOverlay({
    required double opacity,
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Opacity(
          opacity: opacity,
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.profile.name}, ${_calculateAge(widget.profile.birthDate)}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.profile.hasActivePremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Premium',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.profile.bio.isNotEmpty)
              Text(
                widget.profile.bio,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white.withOpacity(0.8), size: 20),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${widget.profile.city}, ${widget.profile.state}',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.profile.accountType == 'barber') ...[
                  const SizedBox(width: 16),
                  Icon(Icons.content_cut, color: Colors.white.withOpacity(0.8), size: 20),
                  const SizedBox(width: 4),
                  Text('Barbeiro', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium, color: Colors.white, size: 20),
            SizedBox(width: 4),
            Text(
              'PREMIUM',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
      ),
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

  // Gesture handlers
  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;

      // Calcular ângulo de rotação baseado na posição horizontal
      const maxAngle = 20 * pi / 180; // 20 graus em radianos
      _angle = (_position.dx / _screenSize.width) * maxAngle;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    // Verificar se passou do threshold
    final isSwipedRight = _position.dx > _swipeThreshold;
    final isSwipedLeft = _position.dx < -_swipeThreshold;
    final isSwipedUp = _position.dy < _superLikeThreshold;

    if (isSwipedRight) {
      // Swipe para direita = LIKE
      _animateCardOffScreen(direction: 1);
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onSwipeRight();
      });
    } else if (isSwipedLeft) {
      // Swipe para esquerda = DISLIKE
      _animateCardOffScreen(direction: -1);
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onSwipeLeft();
      });
    } else if (isSwipedUp) {
      // Swipe para cima = SUPER LIKE
      _animateCardOffScreen(direction: 0, isUp: true);
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onSwipeUp();
      });
    } else {
      // Não passou do threshold - voltar para posição original
      _resetPosition();
    }
  }

  void _animateCardOffScreen({required int direction, bool isUp = false}) {
    final endX = isUp ? 0.0 : _screenSize.width * 1.5 * direction;
    final endY = isUp ? -_screenSize.height * 1.5 : _position.dy;

    setState(() {
      _position = Offset(endX, endY);
    });
  }

  void _resetPosition() {
    setState(() {
      _position = Offset.zero;
      _angle = 0;
    });

    _animationController.forward(from: 0);
  }

  /// Método público para programaticamente swipe o card
  void swipe(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.left:
        _animateCardOffScreen(direction: -1);
        Future.delayed(const Duration(milliseconds: 300), widget.onSwipeLeft);
      case SwipeDirection.right:
        _animateCardOffScreen(direction: 1);
        Future.delayed(const Duration(milliseconds: 300), widget.onSwipeRight);
      case SwipeDirection.up:
        _animateCardOffScreen(direction: 0, isUp: true);
        Future.delayed(const Duration(milliseconds: 300), widget.onSwipeUp);
    }
  }
}

enum SwipeDirection { left, right, up }
