import 'package:dart_mappable/dart_mappable.dart';

part 'prompt_response.mapper.dart';

/// Resposta a um prompt do perfil (estilo Hinge)
/// Exemplo: Prompt "Meu talento secreto é..." → Response "Fazer café perfeito"
@MappableClass()
class PromptResponse with PromptResponseMappable {
  /// ID único da resposta
  final String responseId;

  /// ID do prompt escolhido (ex: "secret_talent")
  final String promptId;

  /// Texto do prompt (ex: "Meu talento secreto é...")
  final String promptText;

  /// Resposta do usuário (min 20 chars)
  final String response;

  /// Timestamp de criação
  final DateTime createdAt;

  const PromptResponse({
    required this.responseId,
    required this.promptId,
    required this.promptText,
    required this.response,
    required this.createdAt,
  });

  /// Validar resposta (min 20 chars, max 200 chars)
  bool get isValid => response.length >= 20 && response.length <= 200;

  /// Preview da resposta (primeiras 50 chars)
  String get preview => response.length > 50 ? '${response.substring(0, 47)}...' : response;
}
