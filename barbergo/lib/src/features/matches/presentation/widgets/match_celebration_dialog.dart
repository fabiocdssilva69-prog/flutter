import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/profile_entity.dart';

class MatchCelebrationDialog extends StatefulWidget {
  final ProfileEntity currentUser;
  final ProfileEntity matchedUser;
  final VoidCallback onContinue;
  final VoidCallback onSendMessage;

  const MatchCelebrationDialog({
    super.key,
    required this.currentUser,
    required this.matchedUser,
    required this.onContinue,
    required this.onSendMessage,
  });

  @override
  State<MatchCelebrationDialog> createState() => _MatchCelebrationDialogState();
}

class _MatchCelebrationDialogState extends State<MatchCelebrationDialog> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Confetti
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();

    // Scale animation
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation = CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.1,
            colors: const [Colors.pink, Colors.red, Colors.purple, Colors.orange],
          ),
        ),

        // Dialog
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título
                  const Text('🎉 É um Match!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  // Avatars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAvatar(widget.currentUser.avatarUrl),
                      const SizedBox(width: 16),
                      const Icon(Icons.favorite, color: Colors.pink, size: 40),
                      const SizedBox(width: 16),
                      _buildAvatar(widget.matchedUser.avatarUrl),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Mensagem
                  Text(
                    'Você e ${widget.matchedUser.name} deram match!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 32),

                  // Botões
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(onPressed: widget.onContinue, child: const Text('Continuar explorando')),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onSendMessage,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                          child: const Text('Enviar mensagem'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String? url) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: url != null ? CachedNetworkImageProvider(url) : null,
      child: url == null ? const Icon(Icons.person, size: 50) : null,
    );
  }
}
