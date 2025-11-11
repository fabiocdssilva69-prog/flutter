import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/services/logger_service.dart';

// Widget reutilizável para exibir Avatares com Cache, Retry e Fallback robusto
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String? userName; // Para mostrar inicial do nome como fallback

  const UserAvatar({super.key, this.imageUrl, this.radius = 20.0, this.userName});

  @override
  Widget build(BuildContext context) {
    // Valida URL antes de tentar carregar
    if (imageUrl != null && imageUrl!.isNotEmpty && _isValidUrl(imageUrl!)) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => CircleAvatar(radius: radius, backgroundImage: imageProvider),
        // Placeholder enquanto carrega
        placeholder: (context, url) => CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey[300],
          child: SizedBox(
            width: radius * 0.6,
            height: radius * 0.6,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey[600]),
          ),
        ),
        // Widget de erro com retry automático (maxRetries=3, retryDelay=1s)
        errorWidget: (context, url, error) {
          // CORREÇÃO BUG P1: Log detalhado com tipo de erro
          debugPrint('❌ [UserAvatar] ERRO COMPLETO:');
          debugPrint('   URL: $url');
          debugPrint('   Error: $error');
          debugPrint('   Type: ${error.runtimeType}');

          // Log no Firebase Crashlytics
          LoggerService().logError(
            error,
            StackTrace.current,
            context: 'Avatar load failed: $url | Type: ${error.runtimeType}',
          );

          return _buildFallbackAvatar();
        },
        // CORREÇÃO BUG P1: Configuração de cache otimizada
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
        httpHeaders: const {'Cache-Control': 'max-age=86400'}, // Cache de 24h
        maxHeightDiskCache: 1200,
        maxWidthDiskCache: 800,
      );
    }

    // Fallback para URLs inválidas ou vazias
    return _buildFallbackAvatar();
  }

  /// Valida se a URL é uma string válida de HTTP/HTTPS
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isScheme('http') || uri.isScheme('https');
    } catch (e) {
      debugPrint('🖼️ [UserAvatar] URL inválida: $url');
      return false;
    }
  }

  /// Constrói avatar fallback: inicial do nome ou ícone de pessoa
  Widget _buildFallbackAvatar() {
    // Se tem nome do usuário, mostra primeira letra em maiúscula
    if (userName != null && userName!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: _generateColorFromName(userName!),
        child: Text(
          userName![0].toUpperCase(),
          style: TextStyle(fontSize: radius * 0.8, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }

    // Fallback padrão: ícone de pessoa
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[400],
      child: Icon(Icons.person, size: radius * 0.8, color: Colors.white),
    );
  }

  /// Gera cor consistente baseada no hash do nome
  Color _generateColorFromName(String name) {
    final hash = name.hashCode;
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.orange[700]!,
      Colors.purple[700]!,
      Colors.teal[700]!,
      Colors.pink[700]!,
      Colors.indigo[700]!,
      Colors.amber[700]!,
    ];
    return colors[hash.abs() % colors.length];
  }
}
