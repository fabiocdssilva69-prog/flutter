import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/logger_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/match_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/swipe_repository.dart';

part 'swipe_controller.g.dart';

@riverpod
class SwipeController extends _$SwipeController {
  @override
  FutureOr<void> build() {}

  /// Executar swipe (like ou dislike)
  Future<bool> swipe(String toUserId, bool liked) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;

    state = const AsyncLoading();

    try {
      // 1. Criar swipe no Firestore
      await ref.read(swipeRepositoryProvider).createSwipe(fromUserId: userId, toUserId: toUserId, liked: liked);

      // 2. Se foi like, verificar se existe swipe reverso (match!)
      if (liked) {
        final hasReverseSwipe = await ref.read(swipeRepositoryProvider).hasReverseSwipe(userId, toUserId);

        if (hasReverseSwipe) {
          // É um match! Criar documento em /matches
          final matchId = await ref.read(matchRepositoryProvider).createMatch(user1: userId, user2: toUserId);

          ref
              .read(loggerServiceProvider)
              .logEvent("Match_Created", parameters: {"matchId": matchId, "user1": userId, "user2": toUserId});

          // TODO: Enviar push notification para ambos
        }
      }

      if (!ref.mounted) return false;
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      if (!ref.mounted) return false;
      ref.read(loggerServiceProvider).logError(error, stackTrace, context: "SwipeController");
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  /// NOVO - Phase 11: Executar Super Like (com verificação de limites)
  /// Retorna: true se sucesso, false se falhou ou sem super likes disponíveis
  Future<bool> superLike(String toUserId) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;

    state = const AsyncLoading();

    try {
      // 1. Buscar perfil do usuário para verificar limites
      final profileRepo = ref.read(profileRepositoryProvider);
      final userProfile = await profileRepo.getProfile(userId);

      if (userProfile == null) {
        throw Exception('Perfil do usuário não encontrado');
      }

      // 2. Verificar se o usuário pode usar Super Like
      if (!userProfile.canUseSuperLike) {
        ref.read(loggerServiceProvider).logInfo('Usuário sem super likes disponíveis: $userId');
        if (!ref.mounted) return false;
        state = AsyncError(Exception('Você não tem Super Likes disponíveis'), StackTrace.current);
        return false;
      }

      // 3. Criar Super Like no Firestore
      await ref
          .read(swipeRepositoryProvider)
          .createSwipe(
            fromUserId: userId,
            toUserId: toUserId,
            liked: true, // Super Like sempre é like
            isSuperLike: true, // IMPORTANTE: flag que identifica como Super Like
          );

      // 4. Decrementar super likes do usuário (apenas para free users)
      final newSuperLikesRemaining = userProfile.hasActivePremium
          ? userProfile.superLikesRemaining
          : userProfile.superLikesRemaining - 1;

      if (!userProfile.hasActivePremium) {
        await profileRepo.updateProfile(userId: userId, data: {'superLikesRemaining': newSuperLikesRemaining});
      }

      // 4.5. Track Analytics
      await ref
          .read(analyticsServiceProvider)
          .logSuperLikeUsed(
            targetId: toUserId,
            superLikesRemaining: newSuperLikesRemaining,
            isPremium: userProfile.hasActivePremium,
          );

      // 5. Verificar se existe swipe reverso (match!)
      final hasReverseSwipe = await ref.read(swipeRepositoryProvider).hasReverseSwipe(userId, toUserId);

      if (hasReverseSwipe) {
        // É um match! Criar documento em /matches
        final matchId = await ref.read(matchRepositoryProvider).createMatch(user1: userId, user2: toUserId);

        ref
            .read(loggerServiceProvider)
            .logEvent("SuperLike_Match_Created", parameters: {"matchId": matchId, "user1": userId, "user2": toUserId});

        // TODO: Enviar push notification ESPECIAL para ambos (Super Like Match!)
      } else {
        // Log de Super Like enviado (sem match ainda)
        ref
            .read(loggerServiceProvider)
            .logEvent("SuperLike_Sent", parameters: {"fromUserId": userId, "toUserId": toUserId});

        // TODO: Enviar push notification para toUserId (alguém te deu Super Like!)
      }

      if (!ref.mounted) return false;
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      if (!ref.mounted) return false;
      ref.read(loggerServiceProvider).logError(error, stackTrace, context: "SwipeController.superLike");
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  /// NOVO - Phase 11: Resetar super likes diários (chamado automaticamente ou por Cloud Function)
  Future<void> resetDailySuperLikes(String userId) async {
    try {
      final profileRepo = ref.read(profileRepositoryProvider);
      final userProfile = await profileRepo.getProfile(userId);

      if (userProfile == null) return;

      // Apenas reseta para free users
      if (userProfile.hasActivePremium) return;

      // Verifica se precisa resetar
      if (!userProfile.needsSuperLikeReset) return;

      // Reseta para 1 super like
      await profileRepo.updateProfile(
        userId: userId,
        data: {'superLikesRemaining': 1, 'lastSuperLikeResetAt': DateTime.now()},
      );

      ref.read(loggerServiceProvider).logInfo('Super likes resetados para usuário: $userId');
    } catch (error, stackTrace) {
      ref.read(loggerServiceProvider).logError(error, stackTrace, context: "SwipeController.resetDailySuperLikes");
    }
  }
}
