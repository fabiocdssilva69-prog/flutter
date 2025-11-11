import 'package:dart_mappable/dart_mappable.dart';

part 'media_content.mapper.dart';

/// Entidade para representar mídia (video/audio) em perfis (Phase 1)
@MappableClass()
class MediaContent with MediaContentMappable {
  /// ID único da mídia
  final String mediaId;

  /// Tipo de mídia
  final MediaType type;

  /// URL do arquivo no Firebase Storage
  final String url;

  /// URL da thumbnail (para vídeos)
  final String? thumbnailUrl;

  /// Duração em segundos
  final int durationSeconds;

  /// Tamanho do arquivo em bytes
  final int fileSizeBytes;

  /// Timestamp de upload
  final DateTime uploadedAt;

  /// Se foi processado/comprimido com sucesso
  final bool isProcessed;

  const MediaContent({
    required this.mediaId,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    required this.durationSeconds,
    required this.fileSizeBytes,
    required this.uploadedAt,
    this.isProcessed = false,
  });

  /// Validar limites de mídia
  bool get isValid {
    switch (type) {
      case MediaType.video:
        return durationSeconds <= 30 && fileSizeBytes <= 50 * 1024 * 1024; // 30s, 50MB
      case MediaType.audio:
        return durationSeconds <= 60 && fileSizeBytes <= 10 * 1024 * 1024; // 60s, 10MB
    }
  }

  /// Texto amigável de duração
  String get durationText {
    if (durationSeconds < 60) return '${durationSeconds}s';
    final minutes = (durationSeconds / 60).floor();
    final seconds = durationSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  /// Texto amigável de tamanho
  String get fileSizeText {
    if (fileSizeBytes < 1024) return '${fileSizeBytes}B';
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)}KB';
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

/// Tipo de mídia
enum MediaType { video, audio }
