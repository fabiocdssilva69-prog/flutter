import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/match_timer.dart';
import '../../../auth/data/auth_service.dart';

/// Provider do repositório de timers
final matchTimerRepositoryProvider = Provider<MatchTimerRepository>((ref) {
  final service = ref.watch(authServiceProvider);
  return MatchTimerRepository(service: service);
});

/// Repositório para gerenciar timers de matches (Phase 1 - Anti-Ghosting)
class MatchTimerRepository {
  final AuthService _service;

  MatchTimerRepository({required AuthService service}) : _service = service;

  static const String timersPath = 'match_timers';

  /// Criar timer para novo match
  Future<void> createTimer(MatchTimer timer) async {
    await _service.db.collection(timersPath).add(timer.toFirestore());
  }

  /// Obter timer de um match específico
  Future<MatchTimer?> getTimerForMatch(String matchId) async {
    final snapshot = await _service.db
        .collection(timersPath)
        .where('matchId', isEqualTo: matchId)
        .where('status', isEqualTo: TimerStatus.active.name)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return MatchTimer.fromFirestore(snapshot.docs.first);
  }

  /// Pausar timer quando primeira mensagem for enviada
  Future<void> pauseTimer(String timerId) async {
    await _service.db.collection(timersPath).doc(timerId).update({
      'status': TimerStatus.paused.name,
      'firstMessageAt': FieldValue.serverTimestamp(),
    });
  }

  /// Marcar timer como expirado
  Future<void> markAsExpired(String timerId) async {
    await _service.db.collection(timersPath).doc(timerId).update({
      'status': TimerStatus.expired.name,
    });
  }

  /// Atualizar timestamp da última notificação
  Future<void> updateLastNotification(String timerId) async {
    await _service.db.collection(timersPath).doc(timerId).update({
      'lastNotificationAt': FieldValue.serverTimestamp(),
    });
  }

  /// Buscar timers ativos expirados (para Cloud Function)
  Future<List<MatchTimer>> getExpiredTimers() async {
    final now = DateTime.now();
    final snapshot = await _service.db
        .collection(timersPath)
        .where('status', isEqualTo: TimerStatus.active.name)
        .where('expiresAt', isLessThan: Timestamp.fromDate(now))
        .get();

    return snapshot.docs.map((doc) => MatchTimer.fromFirestore(doc)).toList();
  }

  /// Buscar timers que precisam de notificação
  Future<List<MatchTimer>> getTimersNeedingNotification() async {
    final now = DateTime.now();
    final in48Hours = now.add(const Duration(hours: 48));
    
    final snapshot = await _service.db
        .collection(timersPath)
        .where('status', isEqualTo: TimerStatus.active.name)
        .where('firstMessageAt', isNull: true) // Ainda não conversaram
        .where('expiresAt', isLessThan: Timestamp.fromDate(in48Hours))
        .get();

    return snapshot.docs
        .map((doc) => MatchTimer.fromFirestore(doc))
        .where((timer) => timer.shouldSendNotification())
        .toList();
  }

  /// Stream de timers do usuário
  Stream<List<MatchTimer>> watchUserTimers(String userId) {
    return _service.db
        .collection(timersPath)
        .where('status', isEqualTo: TimerStatus.active.name)
        .where('user1Id', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot1) async {
      final timers1 = snapshot1.docs.map((doc) => MatchTimer.fromFirestore(doc)).toList();
      
      // Também buscar onde userId é user2Id
      final snapshot2 = await _service.db
          .collection(timersPath)
          .where('status', isEqualTo: TimerStatus.active.name)
          .where('user2Id', isEqualTo: userId)
          .get();
      
      final timers2 = snapshot2.docs.map((doc) => MatchTimer.fromFirestore(doc)).toList();
      
      return [...timers1, ...timers2];
    });
  }

  /// Deletar timer
  Future<void> deleteTimer(String timerId) async {
    await _service.db.collection(timersPath).doc(timerId).delete();
  }
}
