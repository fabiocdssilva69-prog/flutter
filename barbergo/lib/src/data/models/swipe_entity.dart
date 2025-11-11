import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../core/infrastructure/mappable_hooks.dart';

part 'swipe_entity.mapper.dart';

/// Entidade representando um swipe (like ou dislike)
@MappableClass()
class SwipeEntity with SwipeEntityMappable {
  final String swipeId;
  final String fromUserId; // Quem deu o swipe
  final String toUserId; // Quem recebeu o swipe
  final bool liked; // true = like, false = dislike
  final bool isSuperLike; // NOVO - Phase 11: true se foi um Super Like (destaque especial)
  final String? comment; // NOVO - Phase 1: Comentário opcional ao dar like
  final String? promptResponseId; // NOVO - Phase 1: ID do prompt que está comentando
  @MappableField(hook: TimestampHook())
  final DateTime createdAt;

  const SwipeEntity({
    required this.swipeId,
    required this.fromUserId,
    required this.toUserId,
    required this.liked,
    this.isSuperLike = false, // Default: like normal
    this.comment, // NOVO - Phase 1
    this.promptResponseId, // NOVO - Phase 1
    required this.createdAt,
  });

  /// Converte para Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'liked': liked,
      'isSuperLike': isSuperLike, // NOVO - Phase 11
      'comment': comment, // NOVO - Phase 1
      'promptResponseId': promptResponseId, // NOVO - Phase 1
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Cria SwipeEntity de documento Firestore
  factory SwipeEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SwipeEntityMapper.fromMap({
      'swipeId': doc.id,
      ...data,
    });
  }
}
