import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/boost_controller.dart';
import '../boost_screen.dart';

/// Botão flutuante de Boost - aparece em discovery/profile
/// Mostra status (ativo/inativo) e boosts restantes
class BoostButton extends ConsumerWidget {
  const BoostButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.read(boostControllerProvider.notifier).watchUserProfile(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final profile = snapshot.data!;
        final isBoosted = profile.isBoosted;
        final boostsRemaining = profile.boostsRemaining;

        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BoostScreen()));
          },
          backgroundColor: isBoosted ? Colors.orange.shade700 : Colors.grey.shade700,
          icon: Icon(isBoosted ? Icons.rocket_launch : Icons.rocket_launch_outlined, color: Colors.white),
          label: Text(
            isBoosted
                ? 'Boost Ativo'
                : boostsRemaining > 0
                ? 'Boost ($boostsRemaining)'
                : 'Boost',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

/// Badge pequeno de Boost para mostrar em cards de perfil
/// Indica quando um usuário está boosted
class BoostBadge extends StatelessWidget {
  final bool isBoosted;
  final double size;

  const BoostBadge({super.key, required this.isBoosted, this.size = 24});

  @override
  Widget build(BuildContext context) {
    if (!isBoosted) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size * 0.4, vertical: size * 0.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange.shade700, Colors.deepOrange.shade900]),
        borderRadius: BorderRadius.circular(size * 0.5),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 8, spreadRadius: 2)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.rocket_launch, color: Colors.white, size: size * 0.8),
          SizedBox(width: size * 0.2),
          Text(
            'BOOST',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: size * 0.5),
          ),
        ],
      ),
    );
  }
}

/// Indicador de Boost ativo - pulsante
/// Pode ser usado em overlays de profile cards
class BoostIndicator extends StatefulWidget {
  final bool isBoosted;

  const BoostIndicator({super.key, required this.isBoosted});

  @override
  State<BoostIndicator> createState() => _BoostIndicatorState();
}

class _BoostIndicatorState extends State<BoostIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isBoosted) return const SizedBox.shrink();

    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Colors.orange.shade700, Colors.deepOrange.shade900]),
          boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.6), blurRadius: 16, spreadRadius: 4)],
        ),
        child: const Icon(Icons.rocket_launch, color: Colors.white, size: 24),
      ),
    );
  }
}
