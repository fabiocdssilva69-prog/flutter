import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/smart_reminder.dart';
import '../../../auth/data/auth_service.dart';

/// Provider do repositório de lembretes
final smartReminderRepositoryProvider = Provider<SmartReminderRepository>((ref) {
  final service = ref.watch(authServiceProvider);
  return SmartReminderRepository(service: service);
});

/// Repositório para gerenciar Smart Reminders (Phase 2)
class SmartReminderRepository {
  final AuthService _service;

  SmartReminderRepository({required AuthService service}) : _service = service;

  static const String remindersPath = 'smart_reminders';
  static const String preferencesPath = 'reminder_preferences';

  /// Criar novo lembrete
  Future<String> createReminder(SmartReminder reminder) async {
    final doc = await _service.db.collection(remindersPath).add(reminder.toFirestore());
    return doc.id;
  }

  /// Obter lembretes pendentes do usuário
  Future<List<SmartReminder>> getPendingReminders(String userId) async {
    final now = DateTime.now();
    final snapshot = await _service.db
        .collection(remindersPath)
        .where('userId', isEqualTo: userId)
        .where('wasSent', isEqualTo: false)
        .where('scheduledFor', isLessThanOrEqualTo: now.millisecondsSinceEpoch)
        .orderBy('scheduledFor')
        .orderBy('priority', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  /// Stream de lembretes do usuário
  Stream<List<SmartReminder>> watchUserReminders(String userId, {int limit = 20}) {
    return _service.db
        .collection(remindersPath)
        .where('userId', isEqualTo: userId)
        .orderBy('scheduledFor', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
    });
  }

  /// Marcar lembrete como enviado
  Future<void> markAsSent(String reminderId) async {
    await _service.db.collection(remindersPath).doc(reminderId).update({
      'wasSent': true,
    });
  }

  /// Marcar lembrete como agido
  Future<void> markAsActedUpon(String reminderId) async {
    await _service.db.collection(remindersPath).doc(reminderId).update({
      'wasActedUpon': true,
    });
  }

  /// Deletar lembrete
  Future<void> deleteReminder(String reminderId) async {
    await _service.db.collection(remindersPath).doc(reminderId).delete();
  }

  /// Deletar lembretes antigos (cleanup)
  Future<void> deleteOldReminders(String userId, {int daysOld = 30}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    
    final snapshot = await _service.db
        .collection(remindersPath)
        .where('userId', isEqualTo: userId)
        .where('createdAt', isLessThan: cutoffDate.millisecondsSinceEpoch)
        .get();

    final batch = _service.db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }

  /// Salvar preferências de lembretes
  Future<void> savePreferences(String userId, ReminderPreferences prefs) async {
    await _service.db.collection(preferencesPath).doc(userId).set({
      'enabledTypes': prefs.enabledTypes.map((t) => t.name).toList(),
      'startHour': prefs.startHour,
      'endHour': prefs.endHour,
      'enabledDays': prefs.enabledDays.toList(),
      'maxPerDay': prefs.maxPerDay,
    });
  }

  /// Obter preferências de lembretes
  Future<ReminderPreferences> getUserPreferences(String userId) async {
    final doc = await _service.db.collection(preferencesPath).doc(userId).get();
    
    if (!doc.exists) return const ReminderPreferences();
    
    final data = doc.data()!;
    return ReminderPreferences(
      enabledTypes: (data['enabledTypes'] as List<dynamic>)
          .map((name) => ReminderType.values.firstWhere(
                (t) => t.name == name,
                orElse: () => ReminderType.replyToMessage,
              ))
          .toSet(),
      startHour: data['startHour'] as int? ?? 9,
      endHour: data['endHour'] as int? ?? 22,
      enabledDays: (data['enabledDays'] as List<dynamic>).map((d) => d as int).toSet(),
      maxPerDay: data['maxPerDay'] as int? ?? 5,
    );
  }

  SmartReminder _fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SmartReminder(
      reminderId: doc.id,
      userId: data['userId'] as String,
      type: ReminderType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => ReminderType.replyToMessage,
      ),
      title: data['title'] as String,
      message: data['message'] as String,
      scheduledFor: DateTime.fromMillisecondsSinceEpoch(data['scheduledFor'] as int),
      context: data['context'] as Map<String, dynamic>?,
      wasSent: data['wasSent'] as bool? ?? false,
      wasActedUpon: data['wasActedUpon'] as bool? ?? false,
      priority: data['priority'] as int? ?? 3,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
    );
  }
}
