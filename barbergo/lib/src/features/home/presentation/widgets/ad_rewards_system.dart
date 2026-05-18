import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../services/consumables_service.dart';

/// Sistema de recompensas por assistir anúncios completos
/// Estratégia: Cada anúncio assistido dá recompensas progressivas
class AdRewardsSystem {
  static const String _keyTotalWatchSeconds = 'total_watch_seconds';
  static const String _keyTotalAdsWatched = 'total_ads_watched';
  static const String _keyBoostsEarned = 'boosts_earned_from_ads';
  static const String _keySuperLikesEarned = 'super_likes_earned_from_ads';
  static const String _keyRepeatsEarned = 'repeats_earned_from_ads';
  static const String _keyMagicMatchesEarned = 'magic_matches_earned_from_ads';
  static const String _keyVerificationDaysEarned = 'verification_days_earned';

  /// Tipos de anúncios (APENAS 15s e 30s)
  static const int ad15seconds = 15;
  static const int ad30seconds = 30;

  /// Recompensas progressivas por MINUTO de tempo acumulado
  /// 1 min = Super Like | 2 min = Boost | 3 min = Repeat | 4 min = Magic Match | 5 min = Silver Badge 1D
  /// Depois recomeça: 6 min = Super Like, etc.
  static const List<RewardType> rewardCycle = [
    RewardType.superLike, // 60s (1 min) - ou 4 anúncios de 15s, ou 2 de 30s
    RewardType.boost, // 120s (2 min)
    RewardType.repeat, // 180s (3 min)
    RewardType.magicMatch, // 240s (4 min)
    RewardType.silverBadge, // 300s (5 min)
  ];

  static const int secondsPerReward = 60; // 1 minuto = 1 recompensa

  /// Informações de cada tipo de recompensa
  static const Map<RewardType, RewardInfo> rewardInfoMap = {
    RewardType.superLike: RewardInfo(
      name: 'Super Like',
      icon: '💝',
      description: '1 Super Like para curtidas especiais',
      quantity: 1,
    ),
    RewardType.boost: RewardInfo(
      name: 'Boost',
      icon: '🚀',
      description: '1 Boost para destacar seu perfil',
      quantity: 1,
    ),
    RewardType.repeat: RewardInfo(
      name: 'Repeat',
      icon: '🔄',
      description: '1 Repeat para voltar em perfis',
      quantity: 1,
    ),
    RewardType.magicMatch: RewardInfo(
      name: 'Match Mágico',
      icon: '✨',
      description: '1 Match Mágico instantâneo',
      quantity: 1,
    ),
    RewardType.silverBadge: RewardInfo(
      name: '1 Dia Selo Silver',
      icon: '🏅',
      description: '1 dia de verificação Silver',
      quantity: 1,
    ),
  };

  /// Registra um anúncio assistido e retorna recompensas baseadas em tempo acumulado
  static Future<AdWatchResult> watchedAd(int adDuration) async {
    final prefs = await SharedPreferences.getInstance();

    // Validar duração (apenas 15s ou 30s)
    if (adDuration != ad15seconds && adDuration != ad30seconds) {
      throw ArgumentError('Duração inválida: $adDuration. Use apenas 15s ou 30s.');
    }

    // Obter tempo total atual ANTES de adicionar
    final oldTotalSeconds = prefs.getInt(_keyTotalWatchSeconds) ?? 0;

    // Adicionar tempo do anúncio atual
    final newTotalSeconds = oldTotalSeconds + adDuration;
    await prefs.setInt(_keyTotalWatchSeconds, newTotalSeconds);

    // Incrementar contador de anúncios
    final totalAds = (prefs.getInt(_keyTotalAdsWatched) ?? 0) + 1;
    await prefs.setInt(_keyTotalAdsWatched, totalAds);

    // Calcular quantas recompensas foram desbloqueadas
    final oldRewardCount = oldTotalSeconds ~/ secondsPerReward;
    final newRewardCount = newTotalSeconds ~/ secondsPerReward;
    final rewardsUnlocked = newRewardCount - oldRewardCount;

    // Conceder recompensas desbloqueadas
    final earnedRewards = <EarnedReward>[];
    for (int i = 0; i < rewardsUnlocked; i++) {
      final rewardIndex = (oldRewardCount + i) % rewardCycle.length;
      final rewardType = rewardCycle[rewardIndex];
      await _grantRewardByType(rewardType);

      final info = rewardInfoMap[rewardType]!;
      earnedRewards.add(EarnedReward(type: rewardType, name: info.name, icon: info.icon, quantity: info.quantity));
    }

    return AdWatchResult(
      adDuration: adDuration,
      earnedRewards: earnedRewards,
      totalWatchSeconds: newTotalSeconds,
      totalAdsWatched: totalAds,
      nextRewardAt: ((newRewardCount + 1) * secondsPerReward),
      secondsToNextReward: ((newRewardCount + 1) * secondsPerReward) - newTotalSeconds,
    );
  }

  /// Concede recompensa baseada no tipo
  static Future<void> _grantRewardByType(RewardType type) async {
    final prefs = await SharedPreferences.getInstance();
    final info = rewardInfoMap[type]!;

    // Atualizar SharedPreferences (contador local)
    switch (type) {
      case RewardType.superLike:
        final current = prefs.getInt(_keySuperLikesEarned) ?? 0;
        await prefs.setInt(_keySuperLikesEarned, current + info.quantity);
        break;
      case RewardType.boost:
        final current = prefs.getInt(_keyBoostsEarned) ?? 0;
        await prefs.setInt(_keyBoostsEarned, current + info.quantity);
        break;
      case RewardType.repeat:
        final current = prefs.getInt(_keyRepeatsEarned) ?? 0;
        await prefs.setInt(_keyRepeatsEarned, current + info.quantity);
        break;
      case RewardType.magicMatch:
        final current = prefs.getInt(_keyMagicMatchesEarned) ?? 0;
        await prefs.setInt(_keyMagicMatchesEarned, current + info.quantity);
        break;
      case RewardType.silverBadge:
        final current = prefs.getInt(_keyVerificationDaysEarned) ?? 0;
        await prefs.setInt(_keyVerificationDaysEarned, current + info.quantity);
        break;
    }

    // Sync com Firestore desativado — consumíveis só via compra/assinatura
    // await _syncRewardToFirestore(type, info.quantity);
  }

  /// Sincroniza recompensa ganhar com Firestore usando ConsumablesService
  static Future<void> _syncRewardToFirestore(RewardType type, int quantity) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('⚠️ [AdRewards] User not authenticated, skipping Firestore sync');
        return;
      }

      // Usar ConsumablesService para adicionar consumíveis
      final consumablesService = ConsumablesService();

      switch (type) {
        case RewardType.superLike:
          await consumablesService.addConsumables(superLikes: quantity);
          print('✅ [AdRewards] Synced Super Like to Firestore: +$quantity');
          break;
        case RewardType.boost:
          await consumablesService.addConsumables(boosts: quantity);
          print('✅ [AdRewards] Synced Boost to Firestore: +$quantity');
          break;
        case RewardType.repeat:
          // Repeat = Replay no Firestore
          await consumablesService.addConsumables(replays: quantity);
          print('✅ [AdRewards] Synced Replay to Firestore: +$quantity');
          break;
        case RewardType.magicMatch:
          await consumablesService.addConsumables(matchMagicos: quantity);
          print('✅ [AdRewards] Synced Magic Match to Firestore: +$quantity');
          break;
        case RewardType.silverBadge:
          // TODO: Implementar sistema de badge temporário
          print('ℹ️ [AdRewards] Silver badge rewards not yet implemented');
          break;
      }
    } catch (e) {
      print('❌ [AdRewards] Error syncing to Firestore: $e');
      // Não lança erro para não bloquear o fluxo de recompensas
    }
  }

  /// Retorna próxima recompensa na fila
  static Future<NextRewardInfo> getNextRewardInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final totalSeconds = prefs.getInt(_keyTotalWatchSeconds) ?? 0;

    final currentRewardCount = totalSeconds ~/ secondsPerReward;
    final nextRewardIndex = currentRewardCount % rewardCycle.length;
    final nextRewardType = rewardCycle[nextRewardIndex];
    final info = rewardInfoMap[nextRewardType]!;

    final secondsToNext = ((currentRewardCount + 1) * secondsPerReward) - totalSeconds;

    return NextRewardInfo(
      type: nextRewardType,
      name: info.name,
      icon: info.icon,
      secondsToUnlock: secondsToNext,
      description: info.description,
    );
  }

  /// Retorna tempo total assistido em segundos
  static Future<int> getTotalWatchSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalWatchSeconds) ?? 0;
  }

  /// Retorna total de anúncios assistidos
  static Future<int> getTotalAdsWatched() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalAdsWatched) ?? 0;
  }

  /// Retorna estatísticas do usuário
  static Future<AdRewardStats> getStats() async {
    final prefs = await SharedPreferences.getInstance();

    return AdRewardStats(
      totalWatchSeconds: prefs.getInt(_keyTotalWatchSeconds) ?? 0,
      totalAdsWatched: prefs.getInt(_keyTotalAdsWatched) ?? 0,
      boostsEarned: prefs.getInt(_keyBoostsEarned) ?? 0,
      superLikesEarned: prefs.getInt(_keySuperLikesEarned) ?? 0,
      repeatsEarned: prefs.getInt(_keyRepeatsEarned) ?? 0,
      magicMatchesEarned: prefs.getInt(_keyMagicMatchesEarned) ?? 0,
      verificationDaysEarned: prefs.getInt(_keyVerificationDaysEarned) ?? 0,
    );
  }

  /// Modal de recompensa conquistada (novo sistema progressivo)
  static void showRewardModal(BuildContext context, AdWatchResult result) {
    // Se não ganhou nada, não mostra modal
    if (result.earnedRewards.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFB026FF), Color(0xFF7B2CBF)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: const Color(0xFFB026FF).withOpacity(0.5), blurRadius: 20, spreadRadius: 5)],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Emoji grande
                const Text('🎉', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 16),

                // Título
                Text(
                  result.earnedRewards.length == 1 ? 'Recompensa Desbloqueada!' : 'Recompensas Desbloqueadas!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Info do anúncio
                Text(
                  'Assistiu ${result.adDuration}s de anúncio',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
                const SizedBox(height: 20),

                // Lista de recompensas ganhas
                ...result.earnedRewards.map(
                  (reward) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFD700), width: 2),
                      ),
                      child: Row(
                        children: [
                          Text(reward.icon, style: const TextStyle(fontSize: 36)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '+ ${reward.quantity} ${reward.name}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Progresso
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '⏱️ Tempo total: ${_formatSeconds(result.totalWatchSeconds)}',
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                          ),
                          Text(
                            '📺 ${result.totalAdsWatched} anúncios',
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Próxima recompensa em ${result.secondsToNextReward}s',
                        style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Botão OK
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFB026FF),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Continuar 🎉', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Formata segundos em formato legível (ex: 2min 30s)
  static String _formatSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) {
      return '${minutes}min ${secs}s';
    }
    return '${secs}s';
  }
}

/// Tipos de recompensa disponíveis
enum RewardType { superLike, boost, repeat, magicMatch, silverBadge }

/// Resultado de assistir um anúncio
class AdWatchResult {
  const AdWatchResult({
    required this.adDuration,
    required this.earnedRewards,
    required this.totalWatchSeconds,
    required this.totalAdsWatched,
    required this.nextRewardAt,
    required this.secondsToNextReward,
  });

  final int adDuration;
  final List<EarnedReward> earnedRewards;
  final int totalWatchSeconds;
  final int totalAdsWatched;
  final int nextRewardAt;
  final int secondsToNextReward;
}

/// Recompensa que foi ganha
class EarnedReward {
  const EarnedReward({required this.type, required this.name, required this.icon, required this.quantity});

  final RewardType type;
  final String name;
  final String icon;
  final int quantity;
}

/// Informações sobre um tipo de recompensa
class RewardInfo {
  const RewardInfo({required this.name, required this.icon, required this.description, required this.quantity});

  final String name;
  final String icon;
  final String description;
  final int quantity;
}

/// Informações sobre próxima recompensa
class NextRewardInfo {
  const NextRewardInfo({
    required this.type,
    required this.name,
    required this.icon,
    required this.secondsToUnlock,
    required this.description,
  });

  final RewardType type;
  final String name;
  final String icon;
  final int secondsToUnlock;
  final String description;
}

/// Estatísticas de recompensas do usuário
class AdRewardStats {
  const AdRewardStats({
    required this.totalWatchSeconds,
    required this.totalAdsWatched,
    required this.boostsEarned,
    required this.superLikesEarned,
    required this.repeatsEarned,
    required this.magicMatchesEarned,
    required this.verificationDaysEarned,
  });

  final int totalWatchSeconds;
  final int totalAdsWatched;
  final int boostsEarned;
  final int superLikesEarned;
  final int repeatsEarned;
  final int magicMatchesEarned;
  final int verificationDaysEarned;
}
