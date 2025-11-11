import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../domain/entities/notification_entity.dart';

part 'notification_controller.g.dart';

@riverpod
Stream<List<NotificationEntity>> userNotificationsStream(Ref ref) {
  final userId = ref.watch(authStateChangesProvider).value?.uid;
  if (userId == null) return Stream.value([]);
  return ref.watch(notificationRepositoryProvider).watchNotifications(userId);
}

// Provedor derivado para o Badge.
@riverpod
int unreadNotificationCount(Ref ref) {
  final notifications = ref.watch(userNotificationsStreamProvider).value;
  return notifications?.where((n) => !n.isRead).length ?? 0;
}

@riverpod
class NotificationController extends _$NotificationController {
  @override
  FutureOr<void> build() {}

  Future<void> markAsRead(String notificationId) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return;
    state = await AsyncValue.guard(() async {
      await ref.read(notificationRepositoryProvider).markAsRead(userId, notificationId);
    });
  }

  Future<void> markAllAsRead() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(notificationRepositoryProvider).markAllAsRead(userId);
    });
  }

  Future<void> deleteNotification(String notificationId) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return;
    state = await AsyncValue.guard(() async {
      await ref.read(notificationRepositoryProvider).deleteNotification(userId, notificationId);
    });
  }

  Future<void> deleteAllRead() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(notificationRepositoryProvider).deleteAllRead(userId);
    });
  }
}
