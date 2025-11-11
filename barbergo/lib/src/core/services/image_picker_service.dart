import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Serviço de seleção e edição de imagens

class ImagePickerService {
  static ImagePickerService? _instance;
  final ImagePicker _picker = ImagePicker();

  ImagePickerService._();

  static ImagePickerService getInstance() {
    _instance ??= ImagePickerService._();
    return _instance!;
  }

  // ============================================
  // PICK IMAGE
  // ============================================

  Future<File?> pickImageFromGallery({int? maxWidth, int? maxHeight, int imageQuality = 85}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );

      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  Future<File?> pickImageFromCamera({
    int? maxWidth,
    int? maxHeight,
    int imageQuality = 85,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
      );

      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  Future<List<File>> pickMultipleImages({int? maxWidth, int? maxHeight, int imageQuality = 85, int? limit}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
        limit: limit,
      );

      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      return [];
    }
  }

  // ============================================
  // PICK VIDEO
  // ============================================

  Future<File?> pickVideoFromGallery({Duration? maxDuration}) async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery, maxDuration: maxDuration);

      if (video == null) return null;

      return File(video.path);
    } catch (e) {
      return null;
    }
  }

  Future<File?> pickVideoFromCamera({
    Duration? maxDuration,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: maxDuration,
        preferredCameraDevice: preferredCameraDevice,
      );

      if (video == null) return null;

      return File(video.path);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // CROP IMAGE
  // ============================================

  Future<File?> cropImage(File imageFile, {CropAspectRatio? aspectRatio, int compressQuality = 90}) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: aspectRatio,
        compressQuality: compressQuality,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cortar Imagem',
            toolbarColor: const Color(0xFFFF6B6B),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Cortar Imagem', aspectRatioLockEnabled: false),
        ],
      );

      if (croppedFile == null) return null;

      return File(croppedFile.path);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // HELPERS
  // ============================================

  Future<File?> pickAndCropImage({
    required ImageSource source,
    CropAspectRatio? aspectRatio,
    int imageQuality = 85,
    int compressQuality = 90,
  }) async {
    File? image;

    if (source == ImageSource.camera) {
      image = await pickImageFromCamera(imageQuality: imageQuality);
    } else {
      image = await pickImageFromGallery(imageQuality: imageQuality);
    }

    if (image == null) return null;

    return await cropImage(image, aspectRatio: aspectRatio, compressQuality: compressQuality);
  }

  Future<File?> saveImageToAppDirectory(File imageFile, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, filename);

      return await imageFile.copy(imagePath);
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteImage(File imageFile) async {
    try {
      if (await imageFile.exists()) {
        await imageFile.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<int> getImageFileSize(File imageFile) async {
    try {
      return await imageFile.length();
    } catch (e) {
      return 0;
    }
  }

  bool isFileSizeValid(int bytes, {int maxMB = 10}) {
    final maxBytes = maxMB * 1024 * 1024;
    return bytes <= maxBytes;
  }
}
