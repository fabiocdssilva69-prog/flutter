import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/smart_reminder.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/smart_reminder_repository.dart';
import '../../matches/controllers/match_controller.dart';

part 'smart_reminders_controller.g.dart';

/// Controller para Smart Reminders (Phase 2)
@riverpod
class SmartRemindersController extends _$SmartRemindersController {
  @override
  FutureOr<bool> build() async {
    // Inicializar e verificar lembretes pendentes
    await _checkPendingReminders();
    return true;
  }

  /// Criar lembrete para responder mensagem
  Future<void> scheduleReplyReminder({required String matchId, required String matchName, int hoursDelay = 24}) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    final reminder = SmartReminder(
      reminderId: '',
      userId: currentUser.uid,
      type: ReminderType.replyToMessage,
      title: 'Responda $matchName',
      message: 'Você não respondeu $matchName há $hoursDelay horas. Que tal continuar a conversa?',
      scheduledFor: DateTime.now().add(Duration(hours: hoursDelay)),
      context: {'matchId': matchId, 'matchName': matchName},
      priority: 4,
      createdAt: DateTime.now(),
    );

    final repo = ref.read(smartReminderRepositoryProvider);
    await repo.createReminder(reminder);
  }

  /// Criar lembrete para iniciar conversa com match novo
  Future<void> scheduleStartConversationReminder({
    required String matchId,
    required String matchName,
    int hoursDelay = 6,
  }) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    final reminder = SmartReminder(
      reminderId: '',
      userId: currentUser.uid,
      type: ReminderType.startConversation,
      title: 'Inicie conversa com $matchName',
      message: 'Vocês deram match! Envie a primeira mensagem antes que expire em 72h.',
      scheduledFor: DateTime.now().add(Duration(hours: hoursDelay)),
      context: {'matchId': matchId, 'matchName': matchName},
      priority: 5,
      createdAt: DateTime.now(),
    );

    final repo = ref.read(smartReminderRepositoryProvider);
    await repo.createReminder(reminder);
  }

  /// Criar lembrete de match expirando
  Future<void> scheduleMatchExpiringReminder({
    required String matchId,
    required String matchName,
    required DateTime expiresAt,
  }) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    final repo = ref.read(smartReminderRepositoryProvider);

    // Agendar 3 lembretes: 48h, 24h, 6h antes
    final intervals = [
      Duration(hours: 24), // 48h antes do fim (24h restantes)
      Duration(hours: 48), // 24h antes do fim (24h restantes)
      Duration(hours: 66), // 6h antes do fim
    ];

    for (final interval in intervals) {
      final notifyAt = expiresAt.subtract(interval);
      if (notifyAt.isAfter(DateTime.now())) {
        final remaining = expiresAt.difference(notifyAt).inHours;

        final reminder = SmartReminder(
          reminderId: '',
          userId: currentUser.uid,
          type: ReminderType.matchExpiringSoon,
          title: 'Match expirando!',
          message: 'Seu match com $matchName expira em ${remaining}h! Envie uma mensagem agora.',
          scheduledFor: notifyAt,
          context: {'matchId': matchId, 'matchName': matchName, 'hoursRemaining': remaining},
          priority: 5,
          createdAt: DateTime.now(),
        );

        await repo.createReminder(reminder);
      }
    }
  }

  /// Criar lembrete de perfil inativo
  Future<void> scheduleProfileInactiveReminder({required int daysInactive}) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    final reminder = SmartReminder(
      reminderId: '',
      userId: currentUser.uid,
      type: ReminderType.profileInactive,
      title: 'Seu perfil está inativo',
      message: 'Você não usa o app há $daysInactive dias. Volte e veja seus novos matches!',
      scheduledFor: DateTime.now().add(const Duration(hours: 1)),
      priority: 3,
      createdAt: DateTime.now(),
    );

    final repo = ref.read(smartReminderRepositoryProvider);
    await repo.createReminder(reminder);
  }

  /// Criar lembrete de super like renovado
  Future<void> scheduleSuperLikeRenewedReminder() async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    final reminder = SmartReminder(
      reminderId: '',
      userId: currentUser.uid,
      type: ReminderType.superLikeRenewed,
      title: '⭐ Super Like Renovado!',
      message: 'Seu super like diário foi renovado. Use agora para chamar atenção!',
      scheduledFor: DateTime.now(),
      priority: 4,
      createdAt: DateTime.now(),
    );

    final repo = ref.read(smartReminderRepositoryProvider);
    await repo.createReminder(reminder);
  }

  /// Processar lembretes pendentes (chamado por background task ou Cloud Function)
  Future<void> _checkPendingReminders() async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    final repo = ref.read(smartReminderRepositoryProvider);
    final prefs = await repo.getUserPreferences(currentUser.uid);

    // Verificar se pode notificar agora
    if (!prefs.canNotifyNow()) return;

    // Buscar lembretes pendentes
    final pendingReminders = await repo.getPendingReminders(currentUser.uid);

    for (final reminder in pendingReminders) {
      if (reminder.shouldSendNow() && prefs.enabledTypes.contains(reminder.type)) {
        // Enviar notificação (TODO: Integrar com FCM)
        await _sendNotification(reminder);

        // Marcar como enviado
        await repo.markAsSent(reminder.reminderId);
      }
    }
  }

  /// Marcar lembrete como agido
  Future<void> markAsActedUpon(String reminderId) async {
    final repo = ref.read(smartReminderRepositoryProvider);
    await repo.markAsActedUpon(reminderId);
  }

  /// Cancelar lembrete
  Future<void> cancelReminder(String reminderId) async {
    final repo = ref.read(smartReminderRepositoryProvider);
    await repo.deleteReminder(reminderId);
  }

  /// Atualizar preferências de lembretes
  Future<void> updatePreferences(ReminderPreferences prefs) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    final repo = ref.read(smartReminderRepositoryProvider);
    await repo.savePreferences(currentUser.uid, prefs);
  }

  /// Stream de lembretes do usuário
  Stream<List<SmartReminder>> watchReminders() {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return const Stream.empty();

    final repo = ref.read(smartReminderRepositoryProvider);
    return repo.watchUserReminders(currentUser.uid);
  }

  // TODO: Integrar com Firebase Cloud Messaging
  Future<void> _sendNotification(SmartReminder reminder) async {
    // Implementar envio de notificação push
    print('📢 Notificação: ${reminder.title} - ${reminder.message}');
  }
}

/// Provider para stream de lembretes
@riverpod
Stream<List<SmartReminder>> userSmartReminders(UserSmartRemindersRef ref) {
  final controller = ref.watch(smartRemindersControllerProvider.notifier);
  return controller.watchReminders();
}

/// Provider para contagem de lembretes pendentes
@riverpod
Future<int> pendingRemindersCount(PendingRemindersCountRef ref) async {
  final currentUser = ref.watch(authRepositoryProvider).currentUser;
  if (currentUser == null) return 0;

  final repo = ref.watch(smartReminderRepositoryProvider);
  final reminders = await repo.getPendingReminders(currentUser.uid);
  return reminders.length;
}
