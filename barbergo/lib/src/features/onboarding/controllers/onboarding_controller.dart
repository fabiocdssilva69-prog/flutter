import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/entities/user_entity.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {}

  Future<bool> completeOnboarding({
    required AccountType accountType,
    required String name,
    required String location,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);
    final profileRepository = ref.read(profileRepositoryProvider);

    final firebaseUser = authRepository.currentUser;
    if (firebaseUser == null || firebaseUser.email == null) {
      state = AsyncError("Usuário não autenticado.", StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    // Cria as entidades UserEntity e ProfileEntity
    final newUser = UserEntity(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: name,
      accountType: accountType,
      subscriptionTier: SubscriptionTier.free,
      createdAt: DateTime.now(),
    );

    final newProfile = ProfileEntity(
      userId: firebaseUser.uid,
      accountType: accountType,
      name: name,
      email: firebaseUser.email!,
      location: location,
      createdAt: DateTime.now(),
    );

    // Salva ambas no Firestore
    state = await AsyncValue.guard(() async {
      // Idealmente isso seria uma transação ou batch write.
      await userRepository.setUser(newUser);
      await profileRepository.setProfile(newProfile);
    });

    // Se sucesso, o currentUserDataProvider será atualizado automaticamente, e o roteador reagirá.
    return !state.hasError;
  }
}
