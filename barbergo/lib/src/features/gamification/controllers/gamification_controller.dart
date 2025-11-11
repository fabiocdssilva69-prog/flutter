import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gamification_controller.g.dart';

enum BadgeType {
  firstCut,
  loyal,
  socialite,
  earlyBird,
  nightOwl,
  perfectWeek,
  monthlyKing,
  reviewer,
  referrer,
  explorer,
}

class Badge {
  final BadgeType type;
  final String name;
  final String description;
  final String icon;
  final int points;
  final bool unlocked;
  final DateTime? unlockedAt;

  Badge({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.points,
    required this.unlocked,
    this.unlockedAt,
  });

  static Map<BadgeType, Badge> get all => {
    BadgeType.firstCut: Badge(
      type: BadgeType.firstCut,
      name: 'Primeiro Corte',
      description: 'Complete seu primeiro agendamento',
      icon: '✂️',
      points: 10,
      unlocked: false,
    ),
    BadgeType.loyal: Badge(
      type: BadgeType.loyal,
      name: 'Cliente Fiel',
      description: '10 cortes com o mesmo barbeiro',
      icon: '🏆',
      points: 50,
      unlocked: false,
    ),
    BadgeType.socialite: Badge(
      type: BadgeType.socialite,
      name: 'Socialite',
      description: '50 posts na galeria social',
      icon: '📸',
      points: 30,
      unlocked: false,
    ),
    BadgeType.earlyBird: Badge(
      type: BadgeType.earlyBird,
      name: 'Madrugador',
      description: '5 agendamentos antes das 9h',
      icon: '🌅',
      points: 20,
      unlocked: false,
    ),
    BadgeType.nightOwl: Badge(
      type: BadgeType.nightOwl,
      name: 'Coruja',
      description: '5 agendamentos depois das 18h',
      icon: '🦉',
      points: 20,
      unlocked: false,
    ),
    BadgeType.perfectWeek: Badge(
      type: BadgeType.perfectWeek,
      name: 'Semana Perfeita',
      description: 'Agende todos os dias da semana',
      icon: '⭐',
      points: 100,
      unlocked: false,
    ),
    BadgeType.monthlyKing: Badge(
      type: BadgeType.monthlyKing,
      name: 'Rei do Mês',
      description: 'Mais XP no mês',
      icon: '👑',
      points: 200,
      unlocked: false,
    ),
    BadgeType.reviewer: Badge(
      type: BadgeType.reviewer,
      name: 'Avaliador',
      description: 'Deixe 20 avaliações',
      icon: '⭐',
      points: 40,
      unlocked: false,
    ),
    BadgeType.referrer: Badge(
      type: BadgeType.referrer,
      name: 'Influenciador',
      description: 'Convide 5 amigos',
      icon: '🎁',
      points: 60,
      unlocked: false,
    ),
    BadgeType.explorer: Badge(
      type: BadgeType.explorer,
      name: 'Explorador',
      description: 'Visite 10 barbeiros diferentes',
      icon: '🗺️',
      points: 80,
      unlocked: false,
    ),
  };
}

class UserLevel {
  final int level;
  final String title;
  final int currentXP;
  final int xpToNextLevel;
  final double progress;

  UserLevel({
    required this.level,
    required this.title,
    required this.currentXP,
    required this.xpToNextLevel,
    required this.progress,
  });

  static String getTitleForLevel(int level) {
    if (level < 5) return 'Iniciante';
    if (level < 10) return 'Frequentador';
    if (level < 20) return 'Veterano';
    if (level < 30) return 'Expert';
    if (level < 50) return 'Mestre';
    return 'Lenda';
  }

  static int getXPForLevel(int level) {
    return level * 100 + (level * level * 10);
  }
}

class GamificationStats {
  final UserLevel level;
  final List<Badge> badges;
  final int totalPoints;
  final int rank;
  final int totalBookings;
  final int streak;

  GamificationStats({
    required this.level,
    required this.badges,
    required this.totalPoints,
    required this.rank,
    required this.totalBookings,
    required this.streak,
  });
}

@riverpod
class GamificationController extends _$GamificationController {
  @override
  Future<GamificationStats> build() async {
    return _loadStats('current-user-id'); // TODO: ID real
  }

  Future<GamificationStats> _loadStats(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('gamification').doc(userId).get();

      final data = doc.data() ?? {};

      final currentXP = data['xp'] ?? 0;
      final level = _calculateLevel(currentXP);
      final xpToNext = UserLevel.getXPForLevel(level + 1);

      final userLevel = UserLevel(
        level: level,
        title: UserLevel.getTitleForLevel(level),
        currentXP: currentXP,
        xpToNextLevel: xpToNext,
        progress: currentXP / xpToNext,
      );

      final unlockedBadges = List<String>.from(data['badges'] ?? []);
      final badges = Badge.all.values.map((badge) {
        final unlocked = unlockedBadges.contains(badge.type.name);
        return Badge(
          type: badge.type,
          name: badge.name,
          description: badge.description,
          icon: badge.icon,
          points: badge.points,
          unlocked: unlocked,
          unlockedAt: unlocked ? DateTime.now() : null,
        );
      }).toList();

      return GamificationStats(
        level: userLevel,
        badges: badges,
        totalPoints: data['totalPoints'] ?? 0,
        rank: data['rank'] ?? 999,
        totalBookings: data['totalBookings'] ?? 0,
        streak: data['streak'] ?? 0,
      );
    } catch (e) {
      return GamificationStats(
        level: UserLevel(level: 1, title: 'Iniciante', currentXP: 0, xpToNextLevel: 100, progress: 0),
        badges: [],
        totalPoints: 0,
        rank: 0,
        totalBookings: 0,
        streak: 0,
      );
    }
  }

  int _calculateLevel(int xp) {
    int level = 1;
    while (xp >= UserLevel.getXPForLevel(level)) {
      level++;
    }
    return level - 1;
  }

  Future<void> addXP(String userId, int amount, String reason) async {
    final docRef = FirebaseFirestore.instance.collection('gamification').doc(userId);

    await docRef.set({
      'xp': FieldValue.increment(amount),
      'totalPoints': FieldValue.increment(amount),
      'lastActivity': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Log atividade
    await docRef.collection('activities').add({
      'amount': amount,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ref.invalidateSelf();
  }

  Future<void> unlockBadge(String userId, BadgeType badgeType) async {
    final badge = Badge.all[badgeType]!;

    await FirebaseFirestore.instance.collection('gamification').doc(userId).update({
      'badges': FieldValue.arrayUnion([badgeType.name]),
      'totalPoints': FieldValue.increment(badge.points),
    });

    ref.invalidateSelf();
  }

  Future<void> updateStreak(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('gamification').doc(userId).get();

    final data = doc.data() ?? {};
    final lastActivity = (data['lastActivity'] as Timestamp?)?.toDate();
    final now = DateTime.now();

    int streak = data['streak'] ?? 0;

    if (lastActivity != null) {
      final daysDiff = now.difference(lastActivity).inDays;
      if (daysDiff == 1) {
        streak++;
      } else if (daysDiff > 1) {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    await doc.reference.update({'streak': streak, 'lastActivity': FieldValue.serverTimestamp()});

    ref.invalidateSelf();
  }
}
