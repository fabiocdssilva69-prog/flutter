import 'package:dart_mappable/dart_mappable.dart';

part 'ai_chat_suggestion.mapper.dart';

/// Sugestões de IA para melhorar conversas (Phase 2)
@MappableClass()
class AIChatSuggestion with AIChatSuggestionMappable {
  /// ID da sugestão
  final String suggestionId;

  /// ID do match/conversa
  final String matchId;

  /// Tipo de sugestão
  final SuggestionType type;

  /// Texto sugerido (para quick replies)
  final String? suggestedText;

  /// Lista de opções (para multiple choice)
  final List<String>? options;

  /// Contexto da análise
  final Map<String, dynamic>? analysisContext;

  /// Score de relevância (0.0 - 1.0)
  final double relevanceScore;

  /// Timestamp de criação
  final DateTime createdAt;

  /// Se foi usado pelo usuário
  final bool wasUsed;

  const AIChatSuggestion({
    required this.suggestionId,
    required this.matchId,
    required this.type,
    this.suggestedText,
    this.options,
    this.analysisContext,
    required this.relevanceScore,
    required this.createdAt,
    this.wasUsed = false,
  });
}

/// Tipos de sugestões de chat
enum SuggestionType {
  /// Resposta rápida sugerida
  quickReply,

  /// Tópico de conversa
  conversationStarter,

  /// Pergunta para fazer
  question,

  /// Piada/icebreaker
  icebreaker,

  /// Sugestão de emoji
  emoji,

  /// Corrigir tom (muito formal/informal)
  toneAdjustment,

  /// Expandir resposta curta
  expandResponse,

  /// Sugestão de encontro
  dateSuggestion,
}

/// Análise de sentimento da conversa
@MappableClass()
class ConversationSentiment with ConversationSentimentMappable {
  /// ID da análise
  final String analysisId;

  /// ID do match
  final String matchId;

  /// Sentimento geral (0.0 = negativo, 0.5 = neutro, 1.0 = positivo)
  final double sentimentScore;

  /// Nível de engajamento (0.0 - 1.0)
  final double engagementLevel;

  /// Velocidade de resposta (segundos médios)
  final int avgResponseTimeSeconds;

  /// Tamanho médio das mensagens
  final int avgMessageLength;

  /// Indicadores detectados
  final List<String> indicators;

  /// Recomendações
  final List<String> recommendations;

  /// Timestamp da análise
  final DateTime analyzedAt;

  const ConversationSentiment({
    required this.analysisId,
    required this.matchId,
    required this.sentimentScore,
    required this.engagementLevel,
    required this.avgResponseTimeSeconds,
    required this.avgMessageLength,
    required this.indicators,
    required this.recommendations,
    required this.analyzedAt,
  });

  /// Avaliar saúde da conversa
  ConversationHealth get health {
    if (sentimentScore >= 0.7 && engagementLevel >= 0.7) {
      return ConversationHealth.excellent;
    } else if (sentimentScore >= 0.5 && engagementLevel >= 0.5) {
      return ConversationHealth.good;
    } else if (sentimentScore >= 0.3 || engagementLevel >= 0.3) {
      return ConversationHealth.needsAttention;
    } else {
      return ConversationHealth.poor;
    }
  }
}

/// Saúde da conversa
enum ConversationHealth { excellent, good, needsAttention, poor }

/// Estatísticas de uso das sugestões
@MappableClass()
class SuggestionUsageStats with SuggestionUsageStatsMappable {
  /// Total de sugestões geradas
  final int totalGenerated;

  /// Total de sugestões usadas
  final int totalUsed;

  /// Taxa de aceitação
  double get acceptanceRate => totalGenerated > 0 ? totalUsed / totalGenerated : 0.0;

  /// Tipos mais usados
  final Map<String, int> usageByType;

  /// Score médio de relevância das sugestões usadas
  final double avgRelevanceScore;

  const SuggestionUsageStats({
    required this.totalGenerated,
    required this.totalUsed,
    required this.usageByType,
    required this.avgRelevanceScore,
  });
}
