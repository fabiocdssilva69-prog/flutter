import 'package:dart_mappable/dart_mappable.dart';

part 'compatibility_score.g.dart';

/// Entity para Advanced Matching Algorithm (Phase 3)
/// Sistema de compatibilidade avançado com ML-ready features
@MappableClass()
class CompatibilityScore with CompatibilityScoreMappable {
  final String scoreId;
  final String userId1;
  final String userId2;
  final double overallScore; // 0-100
  final DateTime calculatedAt;
  final Map<CompatibilityFactor, double> factorScores;
  final List<CompatibilityInsight> insights;
  final MatchPrediction prediction;
  final BehavioralAnalysis? behavioralData;

  const CompatibilityScore({
    required this.scoreId,
    required this.userId1,
    required this.userId2,
    required this.overallScore,
    required this.calculatedAt,
    required this.factorScores,
    required this.insights,
    required this.prediction,
    this.behavioralData,
  });

  /// Verificar se é alta compatibilidade (>75)
  bool get isHighCompatibility => overallScore >= 75;

  /// Verificar se é média compatibilidade (50-75)
  bool get isMediumCompatibility => overallScore >= 50 && overallScore < 75;

  /// Obter top 3 fatores
  List<MapEntry<CompatibilityFactor, double>> get topFactors {
    final sorted = factorScores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).toList();
  }

  /// Obter fatores fracos (score < 40)
  List<MapEntry<CompatibilityFactor, double>> get weakFactors {
    return factorScores.entries.where((e) => e.value < 40).toList();
  }
}

/// Fatores de compatibilidade
enum CompatibilityFactor {
  interests, // Interesses em comum
  values, // Valores e crenças
  lifestyle, // Estilo de vida
  communication, // Estilo de comunicação
  personality, // Personalidade (MBTI-like)
  goals, // Objetivos de relacionamento
  location, // Proximidade geográfica
  activity, // Nível de atividade
  humor, // Senso de humor
  education, // Nível educacional
  career, // Ambições profissionais
  family, // Valores familiares
  socialHabits, // Hábitos sociais
  healthFitness, // Saúde e fitness
  financialViews, // Visão financeira
}

/// Insight de compatibilidade
@MappableClass()
class CompatibilityInsight with CompatibilityInsightMappable {
  final String insightId;
  final InsightType type;
  final String title;
  final String description;
  final double impactScore; // 0-10
  final List<String> suggestions;

  const CompatibilityInsight({
    required this.insightId,
    required this.type,
    required this.title,
    required this.description,
    required this.impactScore,
    this.suggestions = const [],
  });
}

/// Tipos de insight
enum InsightType {
  strength, // Ponto forte
  weakness, // Ponto fraco
  opportunity, // Oportunidade
  warning, // Alerta
  recommendation, // Recomendação
}

/// Predição de match
@MappableClass()
class MatchPrediction with MatchPredictionMappable {
  final double successProbability; // 0-1
  final MatchOutcome predictedOutcome;
  final int estimatedMessagesBeforeMeet; // Quantas mensagens antes de encontro
  final int estimatedDaysToFirstDate;
  final double longTermPotential; // 0-100
  final List<String> riskFactors;
  final List<String> successFactors;

  const MatchPrediction({
    required this.successProbability,
    required this.predictedOutcome,
    required this.estimatedMessagesBeforeMeet,
    required this.estimatedDaysToFirstDate,
    required this.longTermPotential,
    this.riskFactors = const [],
    this.successFactors = const [],
  });
}

/// Resultado previsto do match
enum MatchOutcome {
  highSuccess, // Alta chance de sucesso (>80%)
  moderateSuccess, // Chance moderada (50-80%)
  uncertain, // Incerto (30-50%)
  lowSuccess, // Baixa chance (<30%)
}

/// Análise comportamental
@MappableClass()
class BehavioralAnalysis with BehavioralAnalysisMappable {
  final String analysisId;
  final DateTime analyzedAt;
  final UserBehaviorProfile user1Behavior;
  final UserBehaviorProfile user2Behavior;
  final double behavioralCompatibility; // 0-100
  final List<BehaviorPattern> sharedPatterns;
  final List<BehaviorPattern> conflictingPatterns;

  const BehavioralAnalysis({
    required this.analysisId,
    required this.analyzedAt,
    required this.user1Behavior,
    required this.user2Behavior,
    required this.behavioralCompatibility,
    this.sharedPatterns = const [],
    this.conflictingPatterns = const [],
  });
}

/// Perfil comportamental do usuário
@MappableClass()
class UserBehaviorProfile with UserBehaviorProfileMappable {
  final String userId;
  final ResponsePattern responsePattern;
  final ActivityPattern activityPattern;
  final EngagementStyle engagementStyle;
  final ConversationStyle conversationStyle;
  final double averageResponseTimeMinutes;
  final double dailyActiveHours;
  final int averageMessageLength;
  final double emojiUsageRate; // 0-1
  final double questionAskerRate; // Taxa de perguntas
  final Map<String, double> topicPreferences; // Tópicos favoritos

  const UserBehaviorProfile({
    required this.userId,
    required this.responsePattern,
    required this.activityPattern,
    required this.engagementStyle,
    required this.conversationStyle,
    required this.averageResponseTimeMinutes,
    required this.dailyActiveHours,
    required this.averageMessageLength,
    required this.emojiUsageRate,
    required this.questionAskerRate,
    this.topicPreferences = const {},
  });
}

/// Padrões de resposta
enum ResponsePattern {
  immediate, // Responde imediatamente (<5 min)
  quick, // Rápido (5-30 min)
  moderate, // Moderado (30 min - 2h)
  slow, // Lento (2-12h)
  irregular, // Irregular
}

/// Padrões de atividade
enum ActivityPattern {
  morningPerson, // Ativo de manhã
  afternoonPerson, // Ativo à tarde
  eveningPerson, // Ativo à noite
  nightOwl, // Coruja noturna
  consistent, // Consistente o dia todo
  weekendWarrior, // Mais ativo nos fins de semana
}

/// Estilo de engajamento
enum EngagementStyle {
  proactive, // Toma iniciativa
  reactive, // Responde mas não inicia muito
  balanced, // Balanceado
  selective, // Seletivo
  enthusiastic, // Entusiasmado
}

/// Estilo de conversa
enum ConversationStyle {
  detailed, // Mensagens longas e detalhadas
  concise, // Mensagens curtas
  playful, // Brincalhão, muitos emojis
  serious, // Sério e direto
  analytical, // Analítico, faz muitas perguntas
  storyteller, // Conta histórias
}

/// Padrão comportamental
@MappableClass()
class BehaviorPattern with BehaviorPatternMappable {
  final String patternId;
  final String name;
  final String description;
  final PatternType type;
  final double strength; // 0-1

  const BehaviorPattern({
    required this.patternId,
    required this.name,
    required this.description,
    required this.type,
    required this.strength,
  });
}

/// Tipo de padrão
enum PatternType {
  positive, // Padrão positivo
  negative, // Padrão negativo
  neutral, // Neutro
}

/// Features para Machine Learning
@MappableClass()
class MLFeatureVector with MLFeatureVectorMappable {
  final String userId;
  final List<double> features; // Vector de features numéricas
  final Map<String, dynamic> metadata;
  final DateTime generatedAt;

  const MLFeatureVector({
    required this.userId,
    required this.features,
    this.metadata = const {},
    required this.generatedAt,
  });

  /// Calcular similaridade cosine com outro vetor
  double cosineSimilarity(MLFeatureVector other) {
    if (features.length != other.features.length) {
      throw ArgumentError('Vectors must have same length');
    }

    var dotProduct = 0.0;
    var norm1 = 0.0;
    var norm2 = 0.0;

    for (var i = 0; i < features.length; i++) {
      dotProduct += features[i] * other.features[i];
      norm1 += features[i] * features[i];
      norm2 += other.features[i] * other.features[i];
    }

    if (norm1 == 0 || norm2 == 0) return 0;

    return dotProduct / (sqrt(norm1) * sqrt(norm2));
  }

  double sqrt(double x) => x < 0 ? 0 : x.sqrt();
}

extension on double {
  double sqrt() {
    if (this <= 0) return 0;
    var guess = this / 2;
    for (var i = 0; i < 10; i++) {
      guess = (guess + this / guess) / 2;
    }
    return guess;
  }
}

/// Configuração do algoritmo de matching
@MappableClass()
class MatchingAlgorithmConfig with MatchingAlgorithmConfigMappable {
  final Map<CompatibilityFactor, double> factorWeights;
  final double behavioralWeight; // Peso da análise comportamental
  final bool enableMLPredictions;
  final double minScoreThreshold; // Score mínimo para mostrar match
  final int maxDailyMatches; // Limite de matches por dia

  const MatchingAlgorithmConfig({
    required this.factorWeights,
    this.behavioralWeight = 0.3,
    this.enableMLPredictions = false,
    this.minScoreThreshold = 30.0,
    this.maxDailyMatches = 50,
  });

  /// Config padrão
  factory MatchingAlgorithmConfig.defaultConfig() {
    return MatchingAlgorithmConfig(
      factorWeights: {
        CompatibilityFactor.interests: 0.15,
        CompatibilityFactor.values: 0.20,
        CompatibilityFactor.lifestyle: 0.12,
        CompatibilityFactor.communication: 0.10,
        CompatibilityFactor.personality: 0.15,
        CompatibilityFactor.goals: 0.18,
        CompatibilityFactor.location: 0.10,
      },
    );
  }
}

/// Estatísticas do algoritmo
@MappableClass()
class MatchingStats with MatchingStatsMappable {
  final int totalScoresCalculated;
  final double averageScore;
  final int highCompatibilityCount;
  final Map<CompatibilityFactor, double> factorAverages;
  final DateTime periodStart;
  final DateTime periodEnd;

  const MatchingStats({
    required this.totalScoresCalculated,
    required this.averageScore,
    required this.highCompatibilityCount,
    required this.factorAverages,
    required this.periodStart,
    required this.periodEnd,
  });
}
