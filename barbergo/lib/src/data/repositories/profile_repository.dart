import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/profile_entity.dart';
import '../datasources/firestore_service.dart';
import 'auth_repository.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository(this._service);
  final FirestoreService _service;

  static const String profilesPath = 'Profiles';
  static String profilePath(String uid) => '$profilesPath/$uid';

  // Cria ou atualiza o perfil público
  Future<void> setProfile(ProfileEntity profile) => _service.setData(
    path: profilePath(profile.userId),
    data: profile.toJson(),
    merge: true, // Usa merge para permitir atualizações parciais
  );

  // Obtém um perfil específico como Stream
  Stream<ProfileEntity?> watchProfile(String uid) =>
      _service.documentStream(path: profilePath(uid), builder: (data, _) => ProfileEntity.fromJson(data));

  // Obtém um perfil específico como Future (leitura única) (Resolve pendência do relatório)
  Future<ProfileEntity?> getProfileByUserId(String uid) async {
    // Implementação simplificada usando stream.first.
    return watchProfile(uid).first;
  }
}

// Provedor para o ProfileRepository
@riverpod
ProfileRepository profileRepository(Ref ref) {
  final service = ref.watch(firestoreServiceProvider);
  return ProfileRepository(service);
}

// Provedor que observa o perfil do usuário logado
@riverpod
Stream<ProfileEntity?> currentProfileData(Ref ref) {
  final authUser = ref.watch(authStateChangesProvider).value;
  if (authUser == null) {
    return const Stream.empty();
  }
  return ref.watch(profileRepositoryProvider).watchProfile(authUser.uid);
}
