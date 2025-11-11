import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/gamification_controller.dart';

class GamificationScreen extends ConsumerWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(gamificationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conquistas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {
              // TODO: Abrir ranking
            },
          ),
        ],
      ),
      body: stats.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _LevelCard(level: data.level),
            const SizedBox(height: 16),
            _StatsCard(totalPoints: data.totalPoints, rank: data.rank, streak: data.streak),
            const SizedBox(height: 24),
            const Text('Badges Desbloqueadas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _BadgesGrid(badges: data.badges.where((b) => b.unlocked).toList()),
            const SizedBox(height: 24),
            const Text('Badges Bloqueadas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _BadgesGrid(badges: data.badges.where((b) => !b.unlocked).toList()),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final UserLevel level;

  const _LevelCard({required this.level});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level ${level.level}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    Text(level.title, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber.withOpacity(0.2)),
                  child: const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('${level.currentXP} XP'), Text('${level.xpToNextLevel} XP')],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: level.progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int totalPoints;
  final int rank;
  final int streak;

  const _StatsCard({required this.totalPoints, required this.rank, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(icon: Icons.star, label: 'Pontos', value: totalPoints.toString(), color: Colors.orange),
            _StatItem(icon: Icons.emoji_events, label: 'Ranking', value: '#$rank', color: Colors.blue),
            _StatItem(icon: Icons.local_fire_department, label: 'Streak', value: '$streak dias', color: Colors.red),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class _BadgesGrid extends StatelessWidget {
  final List<Badge> badges;

  const _BadgesGrid({required this.badges});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _BadgeItem(badge: badge);
      },
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final Badge badge;

  const _BadgeItem({required this.badge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('${badge.icon} ${badge.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(badge.description),
                const SizedBox(height: 8),
                Text('${badge.points} pontos', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (badge.unlocked && badge.unlockedAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Desbloqueado em: ${badge.unlockedAt!.day}/${badge.unlockedAt!.month}/${badge.unlockedAt!.year}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
          ),
        );
      },
      child: Card(
        color: badge.unlocked ? Colors.white : Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(badge.icon, style: TextStyle(fontSize: 40, color: badge.unlocked ? null : Colors.grey)),
            const SizedBox(height: 4),
            Text(
              badge.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badge.unlocked ? null : Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (badge.unlocked)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '+${badge.points}',
                  style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
