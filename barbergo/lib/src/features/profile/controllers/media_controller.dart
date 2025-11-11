import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/image_upload_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import 'profile_controller.dart'; // Para verificar o perfil atual

part 'media_controller.g.dart';

@riverpod
class MediaController extends _$MediaController {
  @override
  // O estado gerencia o loading durante o upload/exclusão.
  FutureOr<void> build() {}

  // Método principal para Upload (Avatar ou Portfólio)
  Future<bool> uploadImage(bool isAvatar) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    final imageService = ref.read(imageUploadServiceProvider);
    final profileRepo = ref.read(profileRepositoryProvider);

    if (userId == null) return false;

    // Verificação de limite para Portfólio
    if (!isAvatar) {
      final currentProfile = ref.read(currentUserProfileProvider).value;
      if (currentProfile != null && currentProfile.portfolioUrls.length >= 6) {
        // Define o estado como erro para a UI reagir (via AsyncValueUI)
        state = AsyncError("portfolioLimitReached", StackTrace.current);
        return false;
      }
    }

    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      // 1. Seleciona a imagem
      final pickedFile = await imageService.pickImage();
      if (pickedFile == null) return false; // Usuário cancelou

      // 2. Upload para o Storage
      // Usamos 'avatar.jpg' para avatar (sobrescreve), e UUID padrão para portfólio.
      final downloadUrl = await imageService.uploadImage(
        pickedFile,
        userId,
        folder: isAvatar ? 'avatars' : 'portfolio',
        customFileName: isAvatar ? 'avatar.jpg' : null,
      );

      if (downloadUrl == null) throw Exception("Falha no upload da imagem.");

      // 3. Atualiza o Firestore (Operações Atômicas do Repositório)
      if (isAvatar) {
        await profileRepo.updateAvatarUrl(userId, downloadUrl);
      } else {
        await profileRepo.addPortfolioUrl(userId, downloadUrl);
      }

      return true;
    });

    state = result;
    return result.value ?? false;
  }

  // Método para deletar uma foto do Portfólio
  Future<bool> removePortfolioImage(String imageUrl) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    final imageService = ref.read(imageUploadServiceProvider);
    final profileRepo = ref.read(profileRepositoryProvider);

    if (userId == null) return false;

    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      // 1. Remove do Firestore (Operação Atômica)
      await profileRepo.removePortfolioUrl(userId, imageUrl);

      // 2. Deleta do Storage (Operação Assíncrona em Background)
      // Não bloqueamos a UI se a deleção do Storage falhar (best effort).
      imageService.deleteFile(imageUrl).catchError((e) {
        // Log do erro, mas não propaga para o usuário.
        return false;
      });

      return true;
    });

    state = result;
    return result.value ?? false;
  }

  // Método para deletar o Avatar
  Future<bool> deleteAvatar() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    final imageService = ref.read(imageUploadServiceProvider);
    final profileRepo = ref.read(profileRepositoryProvider);

    if (userId == null) return false;

    // Obtém a URL atual do avatar para deletar do Storage
    final currentProfile = ref.read(currentUserProfileProvider).value;
    final currentAvatarUrl = currentProfile?.avatarUrl;

    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      // 1. Remove do Firestore (Operação Atômica - Define como null)
      await profileRepo.updateAvatarUrl(userId, null);

      // 2. Deleta do Storage (Best Effort)
      if (currentAvatarUrl != null && currentAvatarUrl.isNotEmpty) {
        imageService.deleteFile(currentAvatarUrl).catchError((e) {
          return false;
        });
      }

      return true;
    });

    state = result;
    return result.value ?? false;
  }
}
