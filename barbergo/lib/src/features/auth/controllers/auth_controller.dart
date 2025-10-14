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
    state = await AsyncValue.guard(
      () => authRepository.signInWithEmailAndPassword(email, password),
    );
    // Retorna true se a operação foi bem-sucedida (não gerou erro)
    return state.hasError == false;
  }

  Future signUp(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => authRepository.signUpWithEmailAndPassword(email, password),
    );
    return state.hasError == false;
  }

  Future signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}
