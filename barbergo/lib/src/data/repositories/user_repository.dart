import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user_entity.dart';
import 'auth_repository.dart';

part 'user_repository.g.dart';

/// Provider do repository
@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance);
}

/// Provider para o user atual (básico - apenas UserEntity, não ProfileEntity completo)
@riverpod
Stream<UserEntity?> currentUser(Ref ref) {
  final authUser = ref.watch(authRepositoryProvider).currentUser;
  if (authUser == null) return Stream.value(null);

  final repo = ref.watch(userRepositoryProvider);
  return repo.watchUser(authUser.uid);
}

/// Repository para operações com User (dados básicos)
class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');

  /// Observa mudanças no user (dados básicos)
  Stream<UserEntity?> watchUser(String userId) {
    return _users.doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserEntity.fromMap(snapshot.data()!, userId);
    });
  }

  /// Pega user uma vez
  Future<UserEntity?> getUser(String userId) async {
    final doc = await _users.doc(userId).get();
    if (!doc.exists) return null;
    return UserEntity.fromMap(doc.data()!, userId);
  }

  /// Cria/Atualiza user básico
  Future<void> saveUser(UserEntity user) async {
    await _users.doc(user.userId).set(user.toMap(), SetOptions(merge: true));
  }

  /// Atualiza campos específicos
  Future<void> updateUser({required String userId, required Map<String, dynamic> data}) async {
    await _users.doc(userId).update({...data, 'updatedAt': DateTime.now().toIso8601String()});
  }

  /// Deleta user
  Future<void> deleteUser(String userId) async {
    await _users.doc(userId).delete();
  }

  /// Verifica se user existe
  Future<bool> userExists(String userId) async {
    final doc = await _users.doc(userId).get();
    return doc.exists;
  }

  /// Busca users por email
  Future<List<UserEntity>> findByEmail(String email) async {
    final query = await _users.where('email', isEqualTo: email).get();
    return query.docs.map((doc) => UserEntity.fromMap(doc.data(), doc.id)).toList();
  }

  /// Alias para getUser (compatibilidade)
  Future<UserEntity?> getUserById(String userId) => getUser(userId);

  /// Alias para saveUser (compatibilidade)
  Future<void> setUser(UserEntity user) => saveUser(user);
}
