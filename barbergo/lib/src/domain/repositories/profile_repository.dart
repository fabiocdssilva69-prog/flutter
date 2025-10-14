import 'package:barbergo_app/src/domain/entities/profile_entity.dart';

/// Repositório responsável por fornecer dados de perfil dos usuários.
abstract class ProfileRepository {
  Future<ProfileEntity?> getProfileByUserId(String userId);
}
