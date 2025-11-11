import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/match_timer.dart';
import '../../../data/repositories/match_timer_repository.dart';
import 'match_controller.dart'; // Para acessar matchRepositoryProvider

part 'anti_ghosting_controller.g.dart';

/// Controller para gerenciar anti-ghosting (Phase 1)
@riverpod
class AntiGhostingController extends _$AntiGhostingController {
  @override
  FutureOr<bool> build() {
    return true; // Inicializar
  }

  /// Criar timer quando novo match acontece
  Future<void> createMatchTimer({required String matchId, required String user1Id, required String user2Id}) async {
    final repo = ref.read(matchTimerRepositoryProvider);

    final timer = MatchTimer.forMatch(matchId: matchId, user1Id: user1Id, user2Id: user2Id);

    await repo.createTimer(timer);
  }

  /// Pausar timer quando primeira mensagem for enviada
  Future<void> pauseTimerForMatch(String matchId) async {
    final repo = ref.read(matchTimerRepositoryProvider);

    // Buscar timer do match
    final timer = await repo.getTimerForMatch(matchId);
    if (timer == null) return;

    // Pausar
    await repo.pauseTimer(timer.timerId);
  }

  /// Processar timers expirados (chamado por Cloud Function)
  Future<void> processExpiredTimers() async {
    final timerRepo = ref.read(matchTimerRepositoryProvider);
    final matchRepo = ref.read(matchRepositoryProvider);

    // Buscar timers expirados
    final expiredTimers = await timerRepo.getExpiredTimers();

    for (final timer in expiredTimers) {
      try {
        // Deletar match
        await matchRepo.deleteMatch(timer.matchId);

        // Marcar timer como expirado
        await timerRepo.markAsExpired(timer.timerId);

        // TODO: Enviar notificação para ambos os usuários
        // "Seu match expirou por inatividade"
      } catch (e) {
        // Log error mas continua processando outros timers
        print('Erro ao processar timer ${timer.timerId}: $e');
      }
    }
  }

  /// Enviar notificações de alerta (48h, 24h, 6h restantes)
  Future<void> sendTimerNotifications() async {
    final repo = ref.read(matchTimerRepositoryProvider);

    // Buscar timers que precisam de notificação
    final timers = await repo.getTimersNeedingNotification();

    for (final timer in timers) {
      try {
        final remaining = timer.hoursRemaining;

        // Determinar mensagem baseada em tempo restante
        String message;
        if (remaining <= 6) {
          message = '⚠️ Seu match expira em ${timer.getTimerText()}! Mande uma mensagem agora.';
        } else if (remaining <= 24) {
          message = '⏰ Faltam apenas ${timer.getTimerText()} para seu match expirar.';
        } else {
          message = '💬 Você tem ${timer.getTimerText()} para iniciar uma conversa!';
        }

        // TODO: Enviar notificação push para ambos os usuários
        // Usar Firebase Cloud Messaging

        // Atualizar timestamp da notificação
        await repo.updateLastNotification(timer.timerId);
      } catch (e) {
        print('Erro ao enviar notificação para timer ${timer.timerId}: $e');
      }
    }
  }

  /// Stream de timers do usuário atual
  Stream<List<MatchTimer>> watchUserTimers(String userId) {
    final repo = ref.read(matchTimerRepositoryProvider);
    return repo.watchUserTimers(userId);
  }
}

/// Provider para stream de timers do usuário atual
@riverpod
Stream<List<MatchTimer>> userMatchTimers(UserMatchTimersRef ref, String userId) {
  final repo = ref.watch(matchTimerRepositoryProvider);
  return repo.watchUserTimers(userId);
}
