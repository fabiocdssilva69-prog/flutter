import 'package:flutter/material.dart';

import '../controllers/ai_controller.dart';

class QuickAction {
  final QuickActionType type;
  final String icon;
  final String label;

  const QuickAction({required this.type, required this.icon, required this.label});
}

class QuickActionsBar extends StatelessWidget {
  final Function(QuickActionType) onActionSelected;
  final bool isLoading;

  const QuickActionsBar({super.key, required this.onActionSelected, this.isLoading = false});

  static const List<QuickAction> actions = [
    QuickAction(type: QuickActionType.analyzeStyle, icon: '📸', label: 'Analisar Foto'),
    QuickAction(type: QuickActionType.recommendBarbershops, icon: '🏪', label: 'Recomendar Barbearias'),
    QuickAction(type: QuickActionType.hairCareTips, icon: '💡', label: 'Dicas de Cuidados'),
    QuickAction(type: QuickActionType.trendingStyles, icon: '✂️', label: 'Tendências'),
    QuickAction(type: QuickActionType.bookingHelp, icon: '📅', label: 'Agendar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: actions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final action = actions[index];
          return _QuickActionChip(action: action, isLoading: isLoading, onTap: () => onActionSelected(action.type));
        },
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final QuickAction action;
  final bool isLoading;
  final VoidCallback onTap;

  const _QuickActionChip({required this.action, required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Opacity(
          opacity: isLoading ? 0.5 : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(action.icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  action.label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
