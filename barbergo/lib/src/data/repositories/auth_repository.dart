import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Login com E-mail e Senha
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Registro com E-mail e Senha (Cria a conta no Auth)
  Future signUpWithEmailAndPassword(String email, String password) async {
    // Nota: Usamos createUserWithEmailAndPassword que é o nome padrão do SDK Firebase
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future signOut() async {
    await _auth.signOut();
  }
}

// Provedor para a instância do FirebaseAuth
@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

// Provedor para o AuthRepository
@riverpod
AuthRepository authRepository(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthRepository(auth);
}

// Provedor principal que expõe o Stream do estado de autenticação
@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
