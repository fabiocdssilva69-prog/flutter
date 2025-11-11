import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../data/models/match_entity.dart';
import '../../../../domain/entities/profile_entity.dart';

class MatchCard extends StatelessWidget {
  final MatchEntity match;
  final ProfileEntity otherUserProfile;

  const MatchCard({super.key, required this.match, required this.otherUserProfile});

  @override
  Widget build(BuildContext context) {
    final unreadCount = match.unreadCount[otherUserProfile.userId] ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: otherUserProfile.avatarUrl != null
              ? CachedNetworkImageProvider(otherUserProfile.avatarUrl!)
              : null,
          child: otherUserProfile.avatarUrl == null ? Text(otherUserProfile.name[0].toUpperCase()) : null,
        ),
        title: Text(otherUserProfile.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: match.lastMessageAt != null
            ? Text(timeago.format(match.lastMessageAt!, locale: 'pt_BR'), style: const TextStyle(fontSize: 12))
            : const Text('Novo match!'),
        trailing: unreadCount > 0
            ? Badge(label: Text('$unreadCount'), child: const Icon(Icons.chat_bubble))
            : const Icon(Icons.chat_bubble_outline),
        onTap: () {
          // Usa GoRouter para navegar
          context.push('/chat/${match.matchId}', extra: otherUserProfile);
        },
      ),
    );
  }
}
