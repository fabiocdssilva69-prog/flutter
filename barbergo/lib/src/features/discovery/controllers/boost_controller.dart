import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/logger_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../domain/entities/profile_entity.dart';

part 'boost_controller.g.dart';

/// Controller para gerenciar o sistema de Boost
/// Boost: aparecer no topo dos resultados de discovery por 30 minutos
/// Compra: 5 boosts por R$ 9,90 via Stripe
@riverpod
class BoostController extends _$BoostController {
  @override
  FutureOr<void> build() {}

  /// Ativa um boost (30 minutos de destaque)
  /// Retorna: true se sucesso, false se falhou ou sem boosts disponíveis
  Future<bool> activateBoost() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;

    state = const AsyncLoading();

    try {
      // 1. Buscar perfil do usuário para verificar boosts disponíveis
      final profileRepo = ref.read(profileRepositoryProvider);
      final userProfile = await profileRepo.getProfile(userId);

      if (userProfile == null) {
        throw Exception('Perfil do usuário não encontrado');
      }

      // 2. Verificar se pode ativar boost
      if (!userProfile.canActivateBoost) {
        if (userProfile.isBoosted) {
          ref.read(loggerServiceProvider).logInfo('Usuário já está boosted: $userId');
          if (!ref.mounted) return false;
          state = AsyncError(Exception('Você já está em destaque!'), StackTrace.current);
          return false;
        } else {
          ref.read(loggerServiceProvider).logInfo('Usuário sem boosts disponíveis: $userId');
          if (!ref.mounted) return false;
          state = AsyncError(Exception('Você não tem boosts disponíveis'), StackTrace.current);
          return false;
        }
      }

      // 3. Calcular tempo de expiração (30 minutos a partir de agora)
      final boostedUntil = DateTime.now().add(const Duration(minutes: 30));

      // 4. Atualizar perfil no Firestore
      final newBoostsRemaining = userProfile.boostsRemaining - 1;
      await profileRepo.updateProfile(
        userId: userId,
        data: {
          'boostedUntil': boostedUntil,
          'boostsRemaining': newBoostsRemaining, // Decrementa
        },
      );

      // 5. Track Analytics (novo AnalyticsService)
      await ref.read(analyticsServiceProvider).logBoostActivated(boostsRemaining: newBoostsRemaining, source: 'button');

      // 6. Log no Firebase (legado)
      ref
          .read(loggerServiceProvider)
          .logEvent(
            'Boost_Activated',
            parameters: {
              'userId': userId,
              'boostedUntil': boostedUntil.toIso8601String(),
              'boostsRemaining': newBoostsRemaining,
            },
          );

      // 7. TODO: Enviar notificação push informando que o boost foi ativado
      // "🚀 Seu perfil está em destaque por 30 minutos!"

      if (!ref.mounted) return false;
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      if (!ref.mounted) return false;
      ref.read(loggerServiceProvider).logError(error, stackTrace, context: 'BoostController.activateBoost');
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  /// Verifica se o usuário pode ativar boost
  Future<bool> canActivateBoost() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;

    try {
      final userProfile = await ref.read(profileRepositoryProvider).getProfile(userId);
      return userProfile?.canActivateBoost ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Retorna quantos boosts o usuário tem disponíveis
  Future<int> getBoostsRemaining() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return 0;

    try {
      final userProfile = await ref.read(profileRepositoryProvider).getProfile(userId);
      return userProfile?.boostsRemaining ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Verifica se o usuário está boosted no momento
  Future<bool> isBoosted() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;

    try {
      final userProfile = await ref.read(profileRepositoryProvider).getProfile(userId);
      return userProfile?.isBoosted ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Retorna o tempo restante de boost (em minutos)
  /// Retorna 0 se não está boosted
  Future<int> getBoostTimeRemaining() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return 0;

    try {
      final userProfile = await ref.read(profileRepositoryProvider).getProfile(userId);

      if (userProfile == null || userProfile.boostedUntil == null) return 0;
      if (!userProfile.isBoosted) return 0;

      final now = DateTime.now();
      final difference = userProfile.boostedUntil!.difference(now);

      return difference.inMinutes.clamp(0, 30);
    } catch (e) {
      return 0;
    }
  }

  /// Stream do perfil do usuário (para monitorar boost em real-time)
  Stream<ProfileEntity?> watchUserProfile() {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return Stream.value(null);

    return ref.read(profileRepositoryProvider).watchProfile(userId);
  }

  /// Desativa boost manualmente (caso usuário queira cancelar)
  /// Não reembolsa o boost usado
  Future<bool> deactivateBoost() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;

    try {
      await ref
          .read(profileRepositoryProvider)
          .updateProfile(
            userId: userId,
            data: {
              'boostedUntil': null, // Remove o boost
            },
          );

      ref.read(loggerServiceProvider).logEvent('Boost_Deactivated', parameters: {'userId': userId});

      return true;
    } catch (e) {
      ref.read(loggerServiceProvider).logError(e, StackTrace.current, context: 'BoostController.deactivateBoost');
      return false;
    }
  }
}
