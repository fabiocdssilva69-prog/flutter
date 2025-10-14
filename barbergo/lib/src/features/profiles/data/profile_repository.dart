import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/profile_entity.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository(this._firestore);
  final FirebaseFirestore _firestore;

  /// Cria ou atualiza o perfil do usuário na coleção "Profiles".
  /// O ID do documento é o UID do usuário.
  Future<void> createProfile(ProfileEntity profile) async {
    await _firestore.collection('Profiles').doc(profile.userId).set(profile.toJson());
  }

  /// Busca o perfil de um usuário pelo UID.
  /// Retorna null se o documento não existir.
  Future<ProfileEntity?> getProfile(String uid) async {
    final doc = await _firestore.collection('Profiles').doc(uid).get();
    if (!doc.exists) return null;
    return ProfileEntity.fromJson(doc.data()!);
  }

  /// Alias para getProfile para compatibilidade
  Future<ProfileEntity?> getUserProfile(String uid) async {
    return getProfile(uid);
  }
}

/// Provedor de uma instância singleton do FirebaseFirestore.
@riverpod
FirebaseFirestore firestore(Ref ref) {
  return FirebaseFirestore.instance;
}

/// Provedor do ProfileRepository.
@riverpod
ProfileRepository profileRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  return ProfileRepository(firestore);
}

/// Provedor futuro que retorna o perfil do usuário logado.
/// Observa o estado de autenticação e busca o documento correspondente.
/// Retorna null se o usuário não estiver logado ou se o perfil não existir.
@riverpod
Future<ProfileEntity?> userProfile(Ref ref) async {
  final authState = ref.watch(authStateChangesProvider);
  final user = authState.value;
  if (user == null) return null;
  return ref.watch(profileRepositoryProvider).getProfile(user.uid);
}
