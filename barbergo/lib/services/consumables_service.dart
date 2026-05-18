import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consumables_service.g.dart';

@riverpod
ConsumablesService consumablesService(Ref ref) {
  return ConsumablesService();
}

/// Serviço para gerenciar consumíveis do usuário
///
/// Consumíveis disponíveis:
/// - Super Likes: Likes especiais que notificam o destinatário
/// - Boosts: Aumentam a visibilidade do perfil temporariamente
/// - Match Mágico: Garante um match automático
/// - Replays: Permite voltar e dar like em perfis passados
class ConsumablesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Retorna o ID do usuário atual (null-safe)
  String get _currentUserId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');
    return uid;
  }

  /// Obtém os contadores de consumíveis do usuário
  Future<ConsumablesData> getConsumables() async {
    final doc = await _firestore.collection('perfis').doc(_currentUserId).get();

    if (!doc.exists) {
      throw Exception('Perfil não encontrado');
    }

    final data = doc.data()!;
    return ConsumablesData(
      superLikes: data['superLikesRemaining'] ?? 0,
      boosts: data['boostsRemaining'] ?? 0,
      matchMagicos: data['magicLikesRemaining'] ?? 0,
      replays: data['replaysRemaining'] ?? 0,
    );
  }

  /// Stream dos consumíveis em tempo real
  Stream<ConsumablesData> watchConsumables() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(ConsumablesData.empty());

    return _firestore.collection('perfis').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return ConsumablesData.empty();
      final data = doc.data()!;
      return ConsumablesData(
        // Tenta campo novo (superLikesRemaining) e fallback para campo antigo (superLikes)
        superLikes: data['superLikesRemaining'] ?? data['superLikes'] ?? 0,
        boosts: data['boostsRemaining'] ?? data['boosts'] ?? 0,
        matchMagicos: data['magicLikesRemaining'] ?? data['magicMatches'] ?? 0,
        replays: data['replaysRemaining'] ?? data['replays'] ?? 0,
      );
    }).handleError((_) => ConsumablesData.empty());
  }

  /// Consome um Super Like
  Future<bool> useSuperLike() async {
    return _consumeItem('superLikesRemaining', 'Super Like');
  }

  /// Consome um Boost
  Future<bool> useBoost() async {
    return _consumeItem('boostsRemaining', 'Boost');
  }

  /// Consome um Match Mágico
  Future<bool> useMatchMagico() async {
    return _consumeItem('magicLikesRemaining', 'Match Mágico');
  }

  /// Consome um Replay
  Future<bool> useReplay() async {
    return _consumeItem('replaysRemaining', 'Replay');
  }

  /// Verifica se o usuário tem consumível disponível
  ///
  /// Badge Gold tem Super Likes ilimitados (representado como -1)
  Future<bool> hasConsumable(ConsumableType type) async {
    final doc = await _firestore.collection('perfis').doc(_currentUserId).get();

    if (!doc.exists) return false;

    final data = doc.data()!;
    final fieldName = _getFieldName(type);
    final count = data[fieldName] ?? 0;

    // Super Likes ilimitados (Gold badge) = -1
    if (type == ConsumableType.superLike && count == -1) {
      return true; // Unlimited
    }

    return count > 0;
  }

  /// Adiciona consumíveis ao usuário (usado após compra ou recompensa)
  Future<void> addConsumables({int superLikes = 0, int boosts = 0, int matchMagicos = 0, int replays = 0}) async {
    final updates = <String, dynamic>{};

    if (superLikes > 0) {
      updates['superLikesRemaining'] = FieldValue.increment(superLikes);
    }
    if (boosts > 0) {
      updates['boostsRemaining'] = FieldValue.increment(boosts);
    }
    if (matchMagicos > 0) {
      updates['magicLikesRemaining'] = FieldValue.increment(matchMagicos);
    }
    if (replays > 0) {
      updates['replaysRemaining'] = FieldValue.increment(replays);
    }

    if (updates.isNotEmpty) {
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('perfis').doc(_currentUserId).update(updates);

      print('✅ [ConsumablesService] Consumíveis adicionados: $updates');
    }
  }

  /// Consome um item do tipo especificado
  ///
  /// Badge Gold: Super Likes ilimitados (-1) não são decrementados
  Future<bool> _consumeItem(String fieldName, String itemName) async {
    try {
      final docRef = _firestore.collection('perfis').doc(_currentUserId);

      // Usar transação para garantir atomicidade
      return await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          print('❌ [ConsumablesService] Perfil não existe');
          return false;
        }

        final data = snapshot.data()!;
        final currentCount = data[fieldName] ?? 0;

        // 👑 Gold Badge: consumível ilimitado (-1) — não decrementa
        if (currentCount == -1) {
          print('👑 [ConsumablesService] $itemName ILIMITADO (Gold Badge)');
          return true;
        }

        if (currentCount <= 0) {
          print('⚠️ [ConsumablesService] Sem $itemName disponíveis');
          return false;
        }

        // Decrementa o contador
        transaction.update(docRef, {fieldName: FieldValue.increment(-1), 'updatedAt': FieldValue.serverTimestamp()});

        print('✅ [ConsumablesService] $itemName usado. Restam: ${currentCount - 1}');
        return true;
      });
    } catch (e) {
      print('❌ [ConsumablesService] Erro ao usar $itemName: $e');
      return false;
    }
  }

  /// Retorna o nome do campo baseado no tipo de consumível
  String _getFieldName(ConsumableType type) {
    switch (type) {
      case ConsumableType.superLike:
        return 'superLikesRemaining';
      case ConsumableType.boost:
        return 'boostsRemaining';
      case ConsumableType.matchMagico:
        return 'magicLikesRemaining';
      case ConsumableType.replay:
        return 'replaysRemaining';
    }
  }
}

/// Tipos de consumíveis disponíveis
enum ConsumableType { superLike, boost, matchMagico, replay }

/// Modelo de dados dos consumíveis
class ConsumablesData {
  final int superLikes;
  final int boosts;
  final int matchMagicos;
  final int replays;

  const ConsumablesData({
    required this.superLikes,
    required this.boosts,
    required this.matchMagicos,
    required this.replays,
  });

  factory ConsumablesData.empty() {
    return const ConsumablesData(superLikes: 0, boosts: 0, matchMagicos: 0, replays: 0);
  }

  int getCount(ConsumableType type) {
    switch (type) {
      case ConsumableType.superLike:
        return superLikes;
      case ConsumableType.boost:
        return boosts;
      case ConsumableType.matchMagico:
        return matchMagicos;
      case ConsumableType.replay:
        return replays;
    }
  }

  @override
  String toString() {
    return 'ConsumablesData(superLikes: $superLikes, boosts: $boosts, matchMagicos: $matchMagicos, replays: $replays)';
  }
}
