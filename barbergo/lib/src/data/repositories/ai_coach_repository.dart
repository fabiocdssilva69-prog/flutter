import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/ai_coach_message.dart';
import '../../../auth/data/auth_service.dart';

/// Provider do repositório do AI Coach
final aiCoachRepositoryProvider = Provider<AICoachRepository>((ref) {
  final service = ref.watch(authServiceProvider);
  return AICoachRepository(service: service);
});

/// Repositório para gerenciar mensagens do AI Dating Coach (Phase 2)
class AICoachRepository {
  final AuthService _service;

  AICoachRepository({required AuthService service}) : _service = service;

  static const String messagesPath = 'ai_coach_messages';

  /// Salvar mensagem do coach
  Future<String> saveMessage(AICoachMessage message) async {
    final doc = await _service.db.collection(messagesPath).add(message.toFirestore());
    return doc.id;
  }

  /// Obter mensagens não lidas do usuário
  Future<List<AICoachMessage>> getUnreadMessages(String userId) async {
    final snapshot = await _service.db
        .collection(messagesPath)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return AICoachMessage(
        messageId: doc.id,
        userId: data['userId'] as String,
        type: CoachMessageType.values.firstWhere(
          (t) => t.name == data['type'],
          orElse: () => CoachMessageType.generalAdvice,
        ),
        content: data['content'] as String,
        context: data['context'] as Map<String, dynamic>?,
        isRead: data['isRead'] as bool? ?? false,
        createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
        userRating: data['userRating'] as int?,
      );
    }).toList();
  }

  /// Stream de mensagens do usuário
  Stream<List<AICoachMessage>> watchUserMessages(String userId, {int limit = 20}) {
    return _service.db
        .collection(messagesPath)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AICoachMessage(
          messageId: doc.id,
          userId: data['userId'] as String,
          type: CoachMessageType.values.firstWhere(
            (t) => t.name == data['type'],
            orElse: () => CoachMessageType.generalAdvice,
          ),
          content: data['content'] as String,
          context: data['context'] as Map<String, dynamic>?,
          isRead: data['isRead'] as bool? ?? false,
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
          userRating: data['userRating'] as int?,
        );
      }).toList();
    });
  }

  /// Marcar mensagem como lida
  Future<void> markAsRead(String messageId) async {
    await _service.db.collection(messagesPath).doc(messageId).update({
      'isRead': true,
    });
  }

  /// Avaliar mensagem (1-5 estrelas)
  Future<void> rateMessage(String messageId, int rating) async {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating deve estar entre 1 e 5');
    }
    
    await _service.db.collection(messagesPath).doc(messageId).update({
      'userRating': rating,
    });
  }

  /// Obter contagem de mensagens não lidas
  Future<int> getUnreadCount(String userId) async {
    final snapshot = await _service.db
        .collection(messagesPath)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// Deletar mensagens antigas (cleanup)
  Future<void> deleteOldMessages(String userId, {int daysOld = 90}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    
    final snapshot = await _service.db
        .collection(messagesPath)
        .where('userId', isEqualTo: userId)
        .where('createdAt', isLessThan: cutoffDate.millisecondsSinceEpoch)
        .get();

    final batch = _service.db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }
}
