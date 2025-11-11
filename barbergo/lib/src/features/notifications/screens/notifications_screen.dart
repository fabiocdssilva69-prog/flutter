import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/notification_entity.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_card.dart';

/// Tela de notificações
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          // Marcar todas como lidas
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Marcar todas como lidas',
            onPressed: () async {
              await ref.read(notificationControllerProvider.notifier).markAllAsRead();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todas marcadas como lidas')),
                );
              }
            },
          ),
          // Menu de opções
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'deleteRead',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 8),
                    Text('Deletar lidas'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'deleteRead') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Deletar notificações lidas'),
                    content: const Text(
                      'Deseja deletar todas as notificações já lidas?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Deletar'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await ref.read(notificationControllerProvider.notifier).deleteAllRead();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notificações deletadas')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userNotificationsStreamProvider);
            },
            child: ListView.builder(
              itemCount: notifications.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () => _handleNotificationTap(context, ref, notification),
                  onDelete: () => _deleteNotification(context, ref, notification),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erro ao carregar notificações'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(userNotificationsStreamProvider),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma notificação',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Você será notificado sobre matches,\nmensagens e outros eventos',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNotificationTap(
    BuildContext context,
    WidgetRef ref,
    NotificationEntity notification,
  ) async {
    // Marcar como lida
    if (!notification.isRead) {
      await ref.read(notificationControllerProvider.notifier).markAsRead(notification.id);
    }

    // Navegar para rota de deep link
    final route = notification.deepLinkRoute;
    if (route != null && context.mounted) {
      // TODO: Implementar navegação usando GoRouter
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navegar para: $route')),
      );
    }
  }

  Future<void> _deleteNotification(
    BuildContext context,
    WidgetRef ref,
    NotificationEntity notification,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar notificação'),
        content: const Text('Deseja deletar esta notificação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await ref.read(notificationControllerProvider.notifier).deleteNotification(notification.id);
    }
  }
}
