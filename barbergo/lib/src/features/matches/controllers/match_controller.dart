import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/match_entity.dart';
import '../repositories/match_repository.dart';

part 'match_controller.g.dart';

// Provider do repository
final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return MatchRepository();
});

// Stream provider de matches
@riverpod
Stream<List<MatchEntity>> userMatches(UserMatchesRef ref) {
  final repository = ref.watch(matchRepositoryProvider);
  return repository.watchUserMatches();
}

// Provider de contagem de matches
@riverpod
Future<int> matchesCount(MatchesCountRef ref) {
  final repository = ref.watch(matchRepositoryProvider);
  return repository.getMatchesCount();
}

// Controller para actions
@riverpod
class MatchController extends _$MatchController {
  @override
  FutureOr<void> build() async {
    // Inicialização
  }

  MatchRepository get _repository => ref.read(matchRepositoryProvider);

  // Criar match manual (para testes)
  Future<MatchEntity?> createMatch(String otherUserId) async {
    state = const AsyncLoading();

    try {
      final match = await _repository.createMatch(otherUserId);
      
      // NOVO - Phase 1: Criar timer de 72h para anti-ghosting
      if (match != null) {
        // Importar anti_ghosting_controller quando disponível
        // await ref.read(antiGhostingControllerProvider.notifier)
        //   .createMatchTimer(
        //     matchId: match.matchId,
        //     user1Id: match.user1,
        //     user2Id: match.user2,
        //   );
      }
      
      state = const AsyncData(null);
      return match;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    }
  }

  // Unmatch
  Future<bool> unmatch(String matchId) async {
    state = const AsyncLoading();

    try {
      await _repository.unmatch(matchId);
      state = const AsyncData(null);

      // Invalidar lista de matches para atualizar
      ref.invalidate(userMatchesProvider);

      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }

  // Block user
  Future<bool> blockUser(String userId) async {
    state = const AsyncLoading();

    try {
      await _repository.blockUser(userId);
      state = const AsyncData(null);

      // Invalidar lista de matches
      ref.invalidate(userMatchesProvider);

      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }

  // Report user
  Future<bool> reportUser({required String userId, required String reason, String? details}) async {
    state = const AsyncLoading();

    try {
      await _repository.reportUser(userId: userId, reason: reason, details: details);
      state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }

  // Verificar se usuário está bloqueado
  Future<bool> isUserBlocked(String userId) async {
    return await _repository.isUserBlocked(userId);
  }

  // Atualizar última interação
  Future<void> updateLastInteraction(String matchId) async {
    await _repository.updateLastInteraction(matchId);

    // Invalidar para reordenar lista
    ref.invalidate(userMatchesProvider);
  }
}
