import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/notification_entity.dart';
import '../datasources/firestore_service.dart';
import 'profile_repository.dart';

part 'notification_repository.g.dart';

@riverpod
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepository(service: ref.watch(firestoreServiceProvider));
}

class NotificationRepository {
  final FirestoreService _service;
  NotificationRepository({required FirestoreService service}) : _service = service;

  // Estrutura: profiles/{userId}/notifications/{notificationId}
  CollectionReference _getNotificationsCollection(String userId) {
    return _service.db.collection(ProfileRepository.profilesPath).doc(userId).collection('notifications');
  }

  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    final query = _getNotificationsCollection(userId).orderBy('createdAt', descending: true).limit(50);
    return query.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => NotificationEntity.fromMap(doc.data() as Map<String, dynamic>)).toList(),
    );
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    await _getNotificationsCollection(userId).doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final unreadSnapshot = await _getNotificationsCollection(userId).where('isRead', isEqualTo: false).get();
    final batch = _service.db.batch();
    for (final doc in unreadSnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> deleteNotification(String userId, String notificationId) async {
    await _getNotificationsCollection(userId).doc(notificationId).delete();
  }

  Future<void> deleteAllRead(String userId) async {
    final readSnapshot = await _getNotificationsCollection(userId).where('isRead', isEqualTo: true).get();
    final batch = _service.db.batch();
    for (final doc in readSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<int> watchUnreadCount(String userId) {
    return _getNotificationsCollection(userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Future<String> createNotification(String userId, NotificationEntity notification) async {
    final docRef = await _getNotificationsCollection(userId).add(
      notification.toMap(),
    );
    return docRef.id;
  }
}
