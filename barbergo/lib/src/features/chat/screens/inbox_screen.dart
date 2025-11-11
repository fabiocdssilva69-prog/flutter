import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n_helper.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/chat/chat_room_entity.dart';
import '../controllers/inbox_controller.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxStreamProvider);
    final currentUserId = ref.watch(authRepositoryProvider).currentUser?.uid;

    return Scaffold(
      // Esta tela será usada no IndexedStack da HomeScreen.
      body: inboxAsync.when(
        data: (rooms) {
          if (currentUserId == null) {
            return const Center(child: Text("Erro de autenticação."));
          }
          if (rooms.isEmpty) {
            return Center(child: Text(context.l10n.noConversationsYet));
          }
          return ListView.separated(
            itemCount: rooms.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildRoomTile(context, rooms[index], currentUserId);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Erro ao carregar Inbox: $e")),
      ),
    );
  }

  Widget _buildRoomTile(BuildContext context, ChatRoomEntity room, String currentUserId) {
    // Encontra o outro participante na sala
    final otherParticipantEntry = room.participants.entries.firstWhere(
      (entry) => entry.key != currentUserId,
      orElse: () => MapEntry('unknown', ParticipantInfo(userId: 'unknown', name: 'Usuário Desconhecido')),
    );

    final otherParticipant = otherParticipantEntry.value;

    // Obtém a contagem de não lidas para o usuário atual
    final unreadCount = room.unreadCounts[currentUserId] ?? 0;
    final isUnread = unreadCount > 0;

    return ListTile(
      leading: CircleAvatar(child: Text(otherParticipant.name.substring(0, 1))),
      title: Text(otherParticipant.name, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(
        room.lastMessage ?? "Conversa iniciada",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal),
      ),
      // Mostra o Badge OU a hora da última mensagem
      trailing: isUnread
          ? Badge.count(count: unreadCount)
          : (room.lastMessageTimestamp == null
                ? null
                : Text(
                    "${room.lastMessageTimestamp!.hour}:${room.lastMessageTimestamp!.minute.toString().padLeft(2, '0')}",
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
      onTap: () {
        // Navega para a tela de chat passando o objeto Room completo via 'extra'
        context.push('/direct-message', extra: room);
      },
    );
  }
}
