import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'logger_service.dart';

part 'image_upload_service.g.dart';

@riverpod
ImageUploadService imageUploadService(Ref ref) {
  return ImageUploadService(storage: FirebaseStorage.instance, logger: ref.watch(loggerServiceProvider));
}

class ImageUploadService {
  final FirebaseStorage _storage;
  final LoggerService _logger;
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  ImageUploadService({required FirebaseStorage storage, required LoggerService logger})
    : _storage = storage,
      _logger = logger;

  // Método para escolher imagem da galeria
  Future<XFile?> pickImage() async {
    try {
      // Qualidade 75% para balancear tamanho e visualização
      return await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    } catch (e, stack) {
      _logger.logError(e, stack, context: "ImagePicker failed");
      return null;
    }
  }

  // 🔥 SPRINT 29 - OTIMIZAÇÃO: Compressão de imagens
  Future<File?> _compressImage(XFile imageFile, {bool isAvatar = false}) async {
    // Web não suporta compressão nativa, retorna null para usar bytes direto
    if (kIsWeb) return null;

    final filePath = imageFile.path;

    // Usa o diretório temporário para o arquivo comprimido
    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/${_uuid.v4()}.jpg';

    // Configurações de compressão: Avatares menores e com maior qualidade
    final quality = isAvatar ? 85 : 75; // Avatar: 85%, Fotos normais: 75%
    final maxWidth = isAvatar ? 512 : 1080; // Avatar: 512px, Fotos: 1080px

    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: quality,
        minWidth: maxWidth,
        format: CompressFormat.jpeg, // JPEG para consistência e compressão
      );

      if (result == null) {
        _logger.logEvent("ImageCompress_Failed");
        return File(filePath); // Fallback para original
      }

      final originalSize = await File(filePath).length();
      final compressedSize = await File(result.path).length();
      final reduction = ((originalSize - compressedSize) / originalSize * 100).toStringAsFixed(1);

      _logger.logEvent(
        "ImageCompress_Success",
        parameters: {
          "originalKB": (originalSize / 1024).toStringAsFixed(1),
          "compressedKB": (compressedSize / 1024).toStringAsFixed(1),
          "reductionPercent": reduction,
        },
      );

      return File(result.path);
    } catch (e, stack) {
      _logger.logError(e, stack, context: "Failed to compress image");
      return File(filePath); // Fallback para a imagem original
    }
  }

  // Método para fazer upload da imagem
  Future<String?> uploadImage(
    XFile imageFile,
    String userId, {
    String folder = 'profile_pictures',
    String? customFileName,
  }) async {
    _logger.logEvent("ImageUpload_Start", parameters: {"folder": folder});

    // 🔥 SPRINT 29: Comprimir imagem antes do upload (exceto Web)
    final isAvatar = folder == 'profile_pictures' || folder == 'avatars';
    final compressedFile = await _compressImage(imageFile, isAvatar: isAvatar);

    // Define o caminho no Storage: /images/{folder}/{userId}/{fileName}.jpg
    final fileName = customFileName ?? "${_uuid.v4()}.jpg"; // Força .jpg após compressão
    final ref = _storage.ref().child('images/$folder/$userId/$fileName');

    try {
      UploadTask uploadTask;

      // Tratamento específico para Web vs Mobile
      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        uploadTask = ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      } else {
        // Mobile: usa arquivo comprimido se disponível, senão usa original
        final fileToUpload = compressedFile ?? File(imageFile.path);
        uploadTask = ref.putFile(fileToUpload);
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      _logger.logEvent("ImageUpload_Success", parameters: {"folder": folder});
      return downloadUrl;
    } on FirebaseException catch (e, stack) {
      _logger.logError(e, stack, context: "FirebaseStorage upload failed: ${e.code}");
      return null;
    }
  }

  // Método para deletar arquivos
  Future<bool> deleteFile(String fullUrl) async {
    try {
      final ref = _storage.refFromURL(fullUrl);

      // ✅ OTIMIZAÇÃO: Verifica se o arquivo existe antes de tentar deletar
      try {
        await ref.getMetadata();
      } on FirebaseException catch (e) {
        if (e.code == 'object-not-found') {
          // Arquivo já não existe, considera sucesso
          _logger.logEvent("Storage_Delete_Skipped_NotFound");
          return true;
        }
        rethrow;
      }

      await ref.delete();
      _logger.logEvent("Storage_Delete_Success");
      return true;
    } catch (e, stack) {
      _logger.logError(e, stack, context: "StorageService Delete Failed");
      return false;
    }
  }
}
