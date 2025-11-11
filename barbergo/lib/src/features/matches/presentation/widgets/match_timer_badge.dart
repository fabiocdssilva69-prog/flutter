import 'package:flutter/material.dart';

import '../../../../domain/entities/match_timer.dart';

/// Badge mostrando timer de 72h em matches (Phase 1 - Anti-Ghosting)
class MatchTimerBadge extends StatelessWidget {
  final MatchTimer timer;
  final bool compact;

  const MatchTimerBadge({
    super.key,
    required this.timer,
    this.compact = false,
  });

  Color _getTimerColor() {
    final remaining = timer.hoursRemaining;
    if (remaining <= 6) return Colors.red;
    if (remaining <= 24) return Colors.orange;
    return Colors.green;
  }

  IconData _getTimerIcon() {
    final remaining = timer.hoursRemaining;
    if (remaining <= 6) return Icons.warning_amber;
    if (remaining <= 24) return Icons.schedule;
    return Icons.timer;
  }

  @override
  Widget build(BuildContext context) {
    if (timer.status != TimerStatus.active) return const SizedBox.shrink();
    if (timer.firstMessageAt != null) return const SizedBox.shrink(); // Já conversaram

    final color = _getTimerColor();
    final icon = _getTimerIcon();
    final text = timer.getTimerText();

    if (compact) {
      // Versão compacta para grid
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 3),
            Text(
              text,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    // Versão completa para detalhes
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expire em $text',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Envie uma mensagem antes que o match desapareça!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
