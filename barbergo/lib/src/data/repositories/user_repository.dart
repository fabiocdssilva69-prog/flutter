import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/enums.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/firestore_service.dart';
import 'auth_repository.dart'; // Para acessar o usuário atual

part 'user_repository.g.dart';

class UserRepository {
  UserRepository(this._service);
  final FirestoreService _service;

  static const String usersPath = 'Users';
  static String userPath(String uid) => '$usersPath/$uid';

  // Cria ou atualiza o documento do usuário no Firestore (UserEntity)
  Future<void> setUser(UserEntity user) => _service.setData(path: userPath(user.uid), data: user.toJson());

  // Obtém o UserEntity do usuário atual como Stream
  Stream<UserEntity?> watchUser(String uid) =>
      _service.documentStream(path: userPath(uid), builder: (data, _) => UserEntity.fromJson(data));

  // Obtém um usuário específico por ID (leitura única)
  Future<UserEntity?> getUserById(String uid) async {
    return _service
        .documentStream<UserEntity>(path: userPath(uid), builder: (data, _) => UserEntity.fromJson(data))
        .first;
  }
}

// Provedor para o UserRepository
@riverpod
UserRepository userRepository(Ref ref) {
  final service = ref.watch(firestoreServiceProvider);
  return UserRepository(service);
}

// Provedor que observa os dados do usuário logado (UserEntity)
// Nomeado como currentUserData para clareza (diferente do FirebaseAuth User)
@riverpod
Stream<UserEntity?> currentUserData(Ref ref) {
  // 1. Observa o estado de autenticação (FirebaseAuth)
  final authUser = ref.watch(authStateChangesProvider).value;
  if (authUser == null) {
    // Retorna um stream vazio se não estiver logado
    return const Stream.empty();
  }
  // 2. Se autenticado, observa o documento correspondente no Firestore (UserEntity)
  return ref.watch(userRepositoryProvider).watchUser(authUser.uid);
}

// Provedor auxiliar para obter o tipo de conta atual (Resolve pendência do relatório)
@riverpod
AccountType? currentAccountType(Ref ref) {
  final user = ref.watch(currentUserDataProvider).value;
  return user?.accountType;
}
