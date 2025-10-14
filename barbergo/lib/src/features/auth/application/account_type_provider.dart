import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barbergo_app/src/domain/entities/enums.dart';
import '../../profiles/data/profile_repository.dart';
import '../controllers/auth_controller.dart';

/// Provider que expõe o tipo de conta do usuário autenticado.
///
/// Integrado com nosso sistema de perfis existente para obter o AccountType
/// do usuário logado através do userProfileProvider.
final currentAccountTypeProvider = Provider<AccountType?>((ref) {
  final userProfileAsync = ref.watch(userProfileProvider);

  return userProfileAsync.when(
    data: (profile) => profile?.accountType,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider que expõe o identificador do usuário autenticado.
///
/// Integrado com nosso sistema de autenticação existente para obter o UID
/// do usuário logado através do authControllerProvider.
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authControllerProvider);

  return authState.when(
    data: (user) => user?.uid,
    loading: () => null,
    error: (_, __) => null,
  );
});
