import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/swipe_entity.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/swipe_repository.dart';
import '../../../domain/entities/profile_entity.dart';

part 'likes_received_controller.g.dart';

/// Controller para gerenciar a funcionalidade "Ver Quem Curtiu Você"
/// Premium Feature - Free users veem quantidade, Premium veem perfis completos
@riverpod
class LikesReceivedController extends _$LikesReceivedController {
  @override
  FutureOr<List<SwipeEntity>> build() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return [];

    // Buscar perfil para verificar se é premium
    final userProfile = await ref.read(profileRepositoryProvider).getProfile(userId);
    if (userProfile == null) return [];

    // Premium users veem tudo, free users veem vazio (só contagem)
    if (!userProfile.hasActivePremium && !userProfile.canSeeWhoLiked) {
      return [];
    }

    // Se é premium, retorna a lista
    final swipeRepo = ref.watch(swipeRepositoryProvider);
    final snapshot = await swipeRepo.watchLikesReceived(userId).first;
    return snapshot;
  }

  /// Conta quantos likes o usuário recebeu (disponível para todos)
  Future<int> countLikesReceived() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return 0;

    return await ref.read(swipeRepositoryProvider).countLikesReceived(userId);
  }

  /// Verifica se o usuário pode ver quem curtiu
  Future<bool> canSeeWhoLiked() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;

    final userProfile = await ref.read(profileRepositoryProvider).getProfile(userId);
    if (userProfile == null) return false;

    return userProfile.hasActivePremium || userProfile.canSeeWhoLiked;
  }

  /// Stream de likes recebidos (real-time) - apenas para premium
  Stream<List<SwipeEntity>> watchLikesReceived() {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return ref.read(swipeRepositoryProvider).watchLikesReceived(userId);
  }

  /// Stream de Super Likes recebidos (sempre visível, destaque especial)
  Stream<List<SwipeEntity>> watchSuperLikesReceived() {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return ref.read(swipeRepositoryProvider).watchSuperLikesReceived(userId);
  }

  /// Buscar perfil de quem deu like (para exibir na lista)
  Future<ProfileEntity?> getProfileFromSwipe(SwipeEntity swipe) async {
    return await ref.read(profileRepositoryProvider).getProfile(swipe.fromUserId);
  }

  /// Dar "like de volta" (retribuir like)
  Future<bool> likeBack(String targetUserId) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;

    try {
      // Verificar se já não deu like antes
      final existingSwipe = await ref.read(swipeRepositoryProvider).getSwipe(userId, targetUserId);
      if (existingSwipe != null) {
        // Já deu swipe, não fazer nada
        return false;
      }

      // Criar swipe de like
      await ref.read(swipeRepositoryProvider).createSwipe(fromUserId: userId, toUserId: targetUserId, liked: true);

      // Verificar se vira match (o outro já tinha dado like)
      // Não precisa verificar aqui porque SwipeController já faz isso
      // Mas sabemos que vai ser match porque estamos retribuindo um like recebido!

      return true;
    } catch (e) {
      return false;
    }
  }
}
