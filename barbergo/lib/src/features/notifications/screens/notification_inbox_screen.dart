import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/async_value_ui.dart';
import '../../../core/utils/l10n_helper.dart';
import '../../../domain/entities/notification_entity.dart';
import '../controllers/notification_controller.dart';

class NotificationInboxScreen extends ConsumerWidget {
  const NotificationInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsStreamProvider);
    ref.listen<AsyncValue>(notificationControllerProvider, (_, state) => state.showAlertDialogOnError(context));
    final isLoadingAction = ref.watch(notificationControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notificationsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read_outlined),
            tooltip: context.l10n.markAllAsRead,
            onPressed: (isLoadingAction || ref.watch(unreadNotificationCountProvider) == 0)
                ? null
                : () => ref.read(notificationControllerProvider.notifier).markAllAsRead(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(userNotificationsStreamProvider),
        child: notificationsAsync.when(
          data: (notifications) {
            if (notifications.isEmpty) {
              return ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Text(context.l10n.noNotificationsYet),
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) => NotificationTile(notification: notifications[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text("Erro: $e")),
        ),
      ),
    );
  }
}

class NotificationTile extends ConsumerWidget {
  final NotificationEntity notification;
  const NotificationTile({super.key, required this.notification});

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.applicationReceived:
        return Icons.person_add_alt_1_outlined;
      case NotificationType.applicationStatusUpdate:
        return Icons.work_history_outlined;
      case NotificationType.systemAlert:
        return Icons.warning_amber_outlined;
      case NotificationType.match:
        return Icons.favorite;
      case NotificationType.message:
        return Icons.chat_bubble;
      case NotificationType.like:
        return Icons.thumb_up;
      case NotificationType.booking:
        return Icons.event;
      case NotificationType.aiSuggestion:
        return Icons.auto_awesome;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontWeight = notification.isRead ? FontWeight.normal : FontWeight.bold;
    final backgroundColor = notification.isRead ? Colors.transparent : Theme.of(context).primaryColor.withOpacity(0.05);

    return ListTile(
      tileColor: backgroundColor,
      leading: Icon(_getIcon(notification.type)),
      title: Text(notification.title, style: TextStyle(fontWeight: fontWeight)),
      subtitle: Text(notification.message, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Text(
        "${notification.createdAt.day}/${notification.createdAt.month}",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () {
        if (!notification.isRead) {
          ref.read(notificationControllerProvider.notifier).markAsRead(notification.id);
        }
        // Navegar para tela de deep link
        final route = notification.deepLinkRoute;
        if (route != null) {
          // TODO: Implementar navegação usando GoRouter
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navegar para: $route')),
          );
        }
      },
    );
  }
}
