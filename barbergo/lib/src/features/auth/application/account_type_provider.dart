import 'package:barbergo_app/src/domain/entities/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';

/// Provider que expõe o tipo de conta do usuário autenticado.
///
/// ✅ CORRIGIDO: Agora usa currentUserProfileProvider (Stream com timeout otimizado)
/// ao invés de userProfileProvider (Future sem timeout que causava loading infinito)
final currentAccountTypeProvider = Provider<AccountType?>((ref) {
  final userProfileAsync = ref.watch(currentUserProfileProvider);

  return userProfileAsync.when(
    data: (profile) => profile?.accountType,
    loading: () => null,
    error: (error, stackTrace) => null,
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
    error: (error, stackTrace) => null,
  );
});
