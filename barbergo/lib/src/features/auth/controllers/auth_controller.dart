import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/auth_repository.dart';

part 'auth_controller.g.dart';

// Usamos AsyncNotifier para gerenciar estados assíncronos (Loading, Error, Data).
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr build() {
    // Estado inicial não requer ação assíncrona.
  }

  Future signIn(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    // Define o estado como 'Loading'
    state = const AsyncLoading();
    // Executa a operação e atualiza o estado com o resultado (Sucesso ou Erro)
    // AsyncValue.guard captura exceções automaticamente.
    final result = await AsyncValue.guard(() => authRepository.signInWithEmailAndPassword(email, password));
    // ✅ FIX: Verifica se o provider ainda está montado antes de atualizar state
    // Previne erro "Cannot use Ref after disposed" durante navegação
    if (ref.mounted) {
      state = result;
    }
    // Retorna true se a operação foi bem-sucedida (não gerou erro)
    return result.hasError == false;
  }

  Future signUp(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => authRepository.signUpWithEmailAndPassword(email, password));
    // ✅ FIX: Verifica se o provider ainda está montado antes de atualizar state
    if (ref.mounted) {
      state = result;
    }
    return result.hasError == false;
  }

  Future signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => authRepository.signOut());
    // ✅ FIX: Verifica se o provider ainda está montado antes de atualizar state
    if (ref.mounted) {
      state = result;
    }
  }
}
