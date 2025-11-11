import 'package:dart_mappable/dart_mappable.dart';

part 'ai_coach_message.mapper.dart';

/// Entidade para mensagens do AI Dating Coach (Phase 2)
@MappableClass()
class AICoachMessage with AICoachMessageMappable {
  /// ID da mensagem
  final String messageId;
  
  /// ID do usuário
  final String userId;
  
  /// Tipo de mensagem (conselho, análise, sugestão)
  final CoachMessageType type;
  
  /// Conteúdo da mensagem (gerado pela IA)
  final String content;
  
  /// Contexto que originou a mensagem (opcional)
  final Map<String, dynamic>? context;
  
  /// Se foi lida pelo usuário
  final bool isRead;
  
  /// Timestamp de criação
  final DateTime createdAt;
  
  /// Rating do usuário (1-5 estrelas, null = não avaliado)
  final int? userRating;
  
  const AICoachMessage({
    required this.messageId,
    required this.userId,
    required this.type,
    required this.content,
    this.context,
    this.isRead = false,
    required this.createdAt,
    this.userRating,
  });
  
  /// Converter para Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type.name,
      'content': content,
      'context': context,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userRating': userRating,
    };
  }
}

/// Tipos de mensagens do coach
enum CoachMessageType {
  /// Conselho geral de namoro
  generalAdvice,
  
  /// Análise de perfil do usuário
  profileAnalysis,
  
  /// Sugestão de melhoria no perfil
  profileSuggestion,
  
  /// Dica para conversa específica
  chatTip,
  
  /// Análise de compatibilidade
  compatibilityAnalysis,
  
  /// Dica para primeiro encontro
  firstDateTip,
  
  /// Motivação/encorajamento
  encouragement,
  
  /// Alerta/aviso
  warning,
}

/// Request para o AI Coach gerar conteúdo
@MappableClass()
class AICoachRequest with AICoachRequestMappable {
  /// Tipo de análise solicitada
  final CoachMessageType type;
  
  /// Contexto da solicitação
  final Map<String, dynamic> context;
  
  /// Histórico recente (para manter contexto)
  final List<String>? recentMessages;
  
  const AICoachRequest({
    required this.type,
    required this.context,
    this.recentMessages,
  });
}
