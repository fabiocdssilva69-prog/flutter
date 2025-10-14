import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/user_entity.dart';

part 'core_data_controller.g.dart';

// Provider para obter detalhes de um usuário específico
// Útil para exibir informações de barbeiros ou barbearias
@riverpod
Future<UserEntity?> userDetails(Ref ref, String userId) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById(userId);
}

// Provider para obter o perfil de um usuário (contém nome, foto, etc)
@riverpod
Future<ProfileEntity?> userProfile(Ref ref, String userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileByUserId(userId);
}
