import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_entity.dart';

/// Repositório para gerenciar notificações no Firestore
class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Referência da coleção de notificações de um usuário
  CollectionReference _notificationsCollection(String userId) {
    return _firestore
        .collection('profiles')
        .doc(userId)
        .collection('notifications');
  }

  /// Criar nova notificação
  Future<String> createNotification(NotificationEntity notification) async {
    final docRef = await _notificationsCollection(notification.userId).add(
      notification.toMap(),
    );
    return docRef.id;
  }

  /// Observar notificações do usuário (tempo real)
  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    return _notificationsCollection(userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationEntity.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  /// Observar apenas notificações não lidas
  Stream<List<NotificationEntity>> watchUnreadNotifications(String userId) {
    return _notificationsCollection(userId)
        .where('isRead', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationEntity.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  /// Obter contagem de não lidas
  Stream<int> watchUnreadCount(String userId) {
    return _notificationsCollection(userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  /// Marcar notificação como lida
  Future<void> markAsRead(String userId, String notificationId) async {
    await _notificationsCollection(userId).doc(notificationId).update({
      'isRead': true,
    });
  }

  /// Marcar todas como lidas
  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final unreadDocs = await _notificationsCollection(userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in unreadDocs.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  /// Deletar notificação
  Future<void> deleteNotification(String userId, String notificationId) async {
    await _notificationsCollection(userId).doc(notificationId).delete();
  }

  /// Deletar todas as notificações lidas
  Future<void> deleteAllRead(String userId) async {
    final batch = _firestore.batch();
    final readDocs = await _notificationsCollection(userId)
        .where('isRead', isEqualTo: true)
        .get();

    for (final doc in readDocs.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  /// Deletar notificações antigas (mais de 30 dias)
  Future<void> deleteOldNotifications(String userId) async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final batch = _firestore.batch();
    
    final oldDocs = await _notificationsCollection(userId)
        .where('createdAt', isLessThan: Timestamp.fromDate(thirtyDaysAgo))
        .get();

    for (final doc in oldDocs.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  /// Obter notificação específica
  Future<NotificationEntity?> getNotification(
    String userId,
    String notificationId,
  ) async {
    final doc = await _notificationsCollection(userId)
        .doc(notificationId)
        .get();

    if (!doc.exists) return null;

    return NotificationEntity.fromMap(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }
}
