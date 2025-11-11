import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../core/infrastructure/mappable_hooks.dart';

part 'match_entity.mapper.dart';

/// Entidade representando um match bidirecional
@MappableClass()
class MatchEntity with MatchEntityMappable {
  final String matchId;
  final List<String> userIds; // Array para facilitar queries
  final String user1;
  final String user2;
  @MappableField(hook: TimestampHook())
  final DateTime createdAt;
  @MappableField(hook: TimestampHook())
  final DateTime? lastMessageAt;
  final Map<String, int> unreadCount; // userId -> count

  const MatchEntity({
    required this.matchId,
    required this.userIds,
    required this.user1,
    required this.user2,
    required this.createdAt,
    this.lastMessageAt,
    required this.unreadCount,
  });

  /// Converte para Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userIds': userIds,
      'user1': user1,
      'user2': user2,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessageAt': lastMessageAt != null ? Timestamp.fromDate(lastMessageAt!) : null,
      'unreadCount': unreadCount,
    };
  }

  /// Cria MatchEntity de documento Firestore
  factory MatchEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchEntityMapper.fromMap({'matchId': doc.id, ...data});
  }

  /// Retorna o outro usuário do match
  String getOtherUserId(String currentUserId) {
    return userIds.firstWhere((id) => id != currentUserId);
  }
}
