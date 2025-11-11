import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_compress/video_compress.dart';

import '../../../domain/entities/media_content.dart';

part 'media_upload_controller.g.dart';

/// Controller para upload e gerenciamento de mídia (Phase 1)
@riverpod
class MediaUploadController extends _$MediaUploadController {
  @override
  FutureOr<void> build() async {
    // Inicializar
  }

  /// Upload de vídeo (máx 30s, comprime automaticamente)
  Future<MediaContent?> uploadVideo({
    required File videoFile,
    required String userId,
    Function(double)? onProgress,
  }) async {
    state = const AsyncLoading();

    try {
      // 1. Validar duração
      final mediaInfo = await VideoCompress.getMediaInfo(videoFile.path);
      final durationMs = mediaInfo.duration ?? 0;
      final durationSeconds = (durationMs / 1000).round();

      if (durationSeconds > 30) {
        throw Exception('Vídeo deve ter no máximo 30 segundos');
      }

      // 2. Comprimir vídeo
      onProgress?.call(0.1);
      final compressedInfo = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedInfo == null || compressedInfo.file == null) {
        throw Exception('Falha na compressão do vídeo');
      }

      onProgress?.call(0.5);

      // 3. Gerar thumbnail
      final thumbnailFile = await VideoCompress.getFileThumbnail(compressedInfo.file!.path, quality: 50);

      // 4. Upload para Firebase Storage
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final videoPath = 'users/$userId/videos/video_$timestamp.mp4';
      final thumbPath = 'users/$userId/videos/thumb_$timestamp.jpg';

      // Upload vídeo
      final videoRef = FirebaseStorage.instance.ref().child(videoPath);
      final videoTask = videoRef.putFile(compressedInfo.file!);

      videoTask.snapshotEvents.listen((snapshot) {
        final progress = 0.5 + (snapshot.bytesTransferred / snapshot.totalBytes) * 0.3;
        onProgress?.call(progress);
      });

      await videoTask;
      final videoUrl = await videoRef.getDownloadURL();

      // Upload thumbnail
      onProgress?.call(0.8);
      final thumbRef = FirebaseStorage.instance.ref().child(thumbPath);
      await thumbRef.putFile(thumbnailFile);
      final thumbUrl = await thumbRef.getDownloadURL();

      onProgress?.call(1.0);

      // 5. Criar MediaContent entity
      final media = MediaContent(
        mediaId: '',
        type: MediaType.video,
        url: videoUrl,
        thumbnailUrl: thumbUrl,
        durationSeconds: durationSeconds,
        fileSizeBytes: compressedInfo.filesize ?? 0,
        uploadedAt: DateTime.now(),
        isProcessed: true,
      );

      state = const AsyncData(null);
      return media;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    } finally {
      // Cleanup
      VideoCompress.deleteAllCache();
    }
  }

  /// Upload de áudio (máx 60s)
  Future<MediaContent?> uploadAudio({
    required File audioFile,
    required String userId,
    int durationSeconds = 0,
    Function(double)? onProgress,
  }) async {
    state = const AsyncLoading();

    try {
      // Validar duração
      if (durationSeconds > 60) {
        throw Exception('Áudio deve ter no máximo 60 segundos');
      }

      // Upload para Firebase Storage
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final audioPath = 'users/$userId/audio/audio_$timestamp.m4a';

      final audioRef = FirebaseStorage.instance.ref().child(audioPath);
      final audioTask = audioRef.putFile(audioFile);

      audioTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      await audioTask;
      final audioUrl = await audioRef.getDownloadURL();

      // Criar MediaContent entity
      final media = MediaContent(
        mediaId: '',
        type: MediaType.audio,
        url: audioUrl,
        durationSeconds: durationSeconds,
        fileSizeBytes: await audioFile.length(),
        uploadedAt: DateTime.now(),
        isProcessed: true,
      );

      state = const AsyncData(null);
      return media;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    }
  }

  /// Deletar mídia do Storage
  Future<bool> deleteMedia(String mediaUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(mediaUrl);
      await ref.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
