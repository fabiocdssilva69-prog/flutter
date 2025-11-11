// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ai_chat_suggestion.dart';

class AIChatSuggestionMapper extends ClassMapperBase<AIChatSuggestion> {
  AIChatSuggestionMapper._();

  static AIChatSuggestionMapper? _instance;
  static AIChatSuggestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AIChatSuggestionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AIChatSuggestion';

  static String _$suggestionId(AIChatSuggestion v) => v.suggestionId;
  static const Field<AIChatSuggestion, String> _f$suggestionId = Field(
    'suggestionId',
    _$suggestionId,
  );
  static String _$matchId(AIChatSuggestion v) => v.matchId;
  static const Field<AIChatSuggestion, String> _f$matchId = Field(
    'matchId',
    _$matchId,
  );
  static SuggestionType _$type(AIChatSuggestion v) => v.type;
  static const Field<AIChatSuggestion, SuggestionType> _f$type = Field(
    'type',
    _$type,
  );
  static String? _$suggestedText(AIChatSuggestion v) => v.suggestedText;
  static const Field<AIChatSuggestion, String> _f$suggestedText = Field(
    'suggestedText',
    _$suggestedText,
    opt: true,
  );
  static List<String>? _$options(AIChatSuggestion v) => v.options;
  static const Field<AIChatSuggestion, List<String>> _f$options = Field(
    'options',
    _$options,
    opt: true,
  );
  static Map<String, dynamic>? _$analysisContext(AIChatSuggestion v) =>
      v.analysisContext;
  static const Field<AIChatSuggestion, Map<String, dynamic>>
  _f$analysisContext = Field('analysisContext', _$analysisContext, opt: true);
  static double _$relevanceScore(AIChatSuggestion v) => v.relevanceScore;
  static const Field<AIChatSuggestion, double> _f$relevanceScore = Field(
    'relevanceScore',
    _$relevanceScore,
  );
  static DateTime _$createdAt(AIChatSuggestion v) => v.createdAt;
  static const Field<AIChatSuggestion, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static bool _$wasUsed(AIChatSuggestion v) => v.wasUsed;
  static const Field<AIChatSuggestion, bool> _f$wasUsed = Field(
    'wasUsed',
    _$wasUsed,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<AIChatSuggestion> fields = const {
    #suggestionId: _f$suggestionId,
    #matchId: _f$matchId,
    #type: _f$type,
    #suggestedText: _f$suggestedText,
    #options: _f$options,
    #analysisContext: _f$analysisContext,
    #relevanceScore: _f$relevanceScore,
    #createdAt: _f$createdAt,
    #wasUsed: _f$wasUsed,
  };

  static AIChatSuggestion _instantiate(DecodingData data) {
    return AIChatSuggestion(
      suggestionId: data.dec(_f$suggestionId),
      matchId: data.dec(_f$matchId),
      type: data.dec(_f$type),
      suggestedText: data.dec(_f$suggestedText),
      options: data.dec(_f$options),
      analysisContext: data.dec(_f$analysisContext),
      relevanceScore: data.dec(_f$relevanceScore),
      createdAt: data.dec(_f$createdAt),
      wasUsed: data.dec(_f$wasUsed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AIChatSuggestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AIChatSuggestion>(map);
  }

  static AIChatSuggestion fromJson(String json) {
    return ensureInitialized().decodeJson<AIChatSuggestion>(json);
  }
}

mixin AIChatSuggestionMappable {
  String toJson() {
    return AIChatSuggestionMapper.ensureInitialized()
        .encodeJson<AIChatSuggestion>(this as AIChatSuggestion);
  }

  Map<String, dynamic> toMap() {
    return AIChatSuggestionMapper.ensureInitialized()
        .encodeMap<AIChatSuggestion>(this as AIChatSuggestion);
  }

  AIChatSuggestionCopyWith<AIChatSuggestion, AIChatSuggestion, AIChatSuggestion>
  get copyWith =>
      _AIChatSuggestionCopyWithImpl<AIChatSuggestion, AIChatSuggestion>(
        this as AIChatSuggestion,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AIChatSuggestionMapper.ensureInitialized().stringifyValue(
      this as AIChatSuggestion,
    );
  }

  @override
  bool operator ==(Object other) {
    return AIChatSuggestionMapper.ensureInitialized().equalsValue(
      this as AIChatSuggestion,
      other,
    );
  }

  @override
  int get hashCode {
    return AIChatSuggestionMapper.ensureInitialized().hashValue(
      this as AIChatSuggestion,
    );
  }
}

extension AIChatSuggestionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AIChatSuggestion, $Out> {
  AIChatSuggestionCopyWith<$R, AIChatSuggestion, $Out>
  get $asAIChatSuggestion =>
      $base.as((v, t, t2) => _AIChatSuggestionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AIChatSuggestionCopyWith<$R, $In extends AIChatSuggestion, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get options;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get analysisContext;
  $R call({
    String? suggestionId,
    String? matchId,
    SuggestionType? type,
    String? suggestedText,
    List<String>? options,
    Map<String, dynamic>? analysisContext,
    double? relevanceScore,
    DateTime? createdAt,
    bool? wasUsed,
  });
  AIChatSuggestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AIChatSuggestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AIChatSuggestion, $Out>
    implements AIChatSuggestionCopyWith<$R, AIChatSuggestion, $Out> {
  _AIChatSuggestionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AIChatSuggestion> $mapper =
      AIChatSuggestionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get options =>
      $value.options != null
      ? ListCopyWith(
          $value.options!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(options: v),
        )
      : null;
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get analysisContext => $value.analysisContext != null
      ? MapCopyWith(
          $value.analysisContext!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(analysisContext: v),
        )
      : null;
  @override
  $R call({
    String? suggestionId,
    String? matchId,
    SuggestionType? type,
    Object? suggestedText = $none,
    Object? options = $none,
    Object? analysisContext = $none,
    double? relevanceScore,
    DateTime? createdAt,
    bool? wasUsed,
  }) => $apply(
    FieldCopyWithData({
      if (suggestionId != null) #suggestionId: suggestionId,
      if (matchId != null) #matchId: matchId,
      if (type != null) #type: type,
      if (suggestedText != $none) #suggestedText: suggestedText,
      if (options != $none) #options: options,
      if (analysisContext != $none) #analysisContext: analysisContext,
      if (relevanceScore != null) #relevanceScore: relevanceScore,
      if (createdAt != null) #createdAt: createdAt,
      if (wasUsed != null) #wasUsed: wasUsed,
    }),
  );
  @override
  AIChatSuggestion $make(CopyWithData data) => AIChatSuggestion(
    suggestionId: data.get(#suggestionId, or: $value.suggestionId),
    matchId: data.get(#matchId, or: $value.matchId),
    type: data.get(#type, or: $value.type),
    suggestedText: data.get(#suggestedText, or: $value.suggestedText),
    options: data.get(#options, or: $value.options),
    analysisContext: data.get(#analysisContext, or: $value.analysisContext),
    relevanceScore: data.get(#relevanceScore, or: $value.relevanceScore),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    wasUsed: data.get(#wasUsed, or: $value.wasUsed),
  );

  @override
  AIChatSuggestionCopyWith<$R2, AIChatSuggestion, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AIChatSuggestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ConversationSentimentMapper
    extends ClassMapperBase<ConversationSentiment> {
  ConversationSentimentMapper._();

  static ConversationSentimentMapper? _instance;
  static ConversationSentimentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConversationSentimentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ConversationSentiment';

  static String _$analysisId(ConversationSentiment v) => v.analysisId;
  static const Field<ConversationSentiment, String> _f$analysisId = Field(
    'analysisId',
    _$analysisId,
  );
  static String _$matchId(ConversationSentiment v) => v.matchId;
  static const Field<ConversationSentiment, String> _f$matchId = Field(
    'matchId',
    _$matchId,
  );
  static double _$sentimentScore(ConversationSentiment v) => v.sentimentScore;
  static const Field<ConversationSentiment, double> _f$sentimentScore = Field(
    'sentimentScore',
    _$sentimentScore,
  );
  static double _$engagementLevel(ConversationSentiment v) => v.engagementLevel;
  static const Field<ConversationSentiment, double> _f$engagementLevel = Field(
    'engagementLevel',
    _$engagementLevel,
  );
  static int _$avgResponseTimeSeconds(ConversationSentiment v) =>
      v.avgResponseTimeSeconds;
  static const Field<ConversationSentiment, int> _f$avgResponseTimeSeconds =
      Field('avgResponseTimeSeconds', _$avgResponseTimeSeconds);
  static int _$avgMessageLength(ConversationSentiment v) => v.avgMessageLength;
  static const Field<ConversationSentiment, int> _f$avgMessageLength = Field(
    'avgMessageLength',
    _$avgMessageLength,
  );
  static List<String> _$indicators(ConversationSentiment v) => v.indicators;
  static const Field<ConversationSentiment, List<String>> _f$indicators = Field(
    'indicators',
    _$indicators,
  );
  static List<String> _$recommendations(ConversationSentiment v) =>
      v.recommendations;
  static const Field<ConversationSentiment, List<String>> _f$recommendations =
      Field('recommendations', _$recommendations);
  static DateTime _$analyzedAt(ConversationSentiment v) => v.analyzedAt;
  static const Field<ConversationSentiment, DateTime> _f$analyzedAt = Field(
    'analyzedAt',
    _$analyzedAt,
  );
  static ConversationHealth _$health(ConversationSentiment v) => v.health;
  static const Field<ConversationSentiment, ConversationHealth> _f$health =
      Field('health', _$health, mode: FieldMode.member);

  @override
  final MappableFields<ConversationSentiment> fields = const {
    #analysisId: _f$analysisId,
    #matchId: _f$matchId,
    #sentimentScore: _f$sentimentScore,
    #engagementLevel: _f$engagementLevel,
    #avgResponseTimeSeconds: _f$avgResponseTimeSeconds,
    #avgMessageLength: _f$avgMessageLength,
    #indicators: _f$indicators,
    #recommendations: _f$recommendations,
    #analyzedAt: _f$analyzedAt,
    #health: _f$health,
  };

  static ConversationSentiment _instantiate(DecodingData data) {
    return ConversationSentiment(
      analysisId: data.dec(_f$analysisId),
      matchId: data.dec(_f$matchId),
      sentimentScore: data.dec(_f$sentimentScore),
      engagementLevel: data.dec(_f$engagementLevel),
      avgResponseTimeSeconds: data.dec(_f$avgResponseTimeSeconds),
      avgMessageLength: data.dec(_f$avgMessageLength),
      indicators: data.dec(_f$indicators),
      recommendations: data.dec(_f$recommendations),
      analyzedAt: data.dec(_f$analyzedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConversationSentiment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConversationSentiment>(map);
  }

  static ConversationSentiment fromJson(String json) {
    return ensureInitialized().decodeJson<ConversationSentiment>(json);
  }
}

mixin ConversationSentimentMappable {
  String toJson() {
    return ConversationSentimentMapper.ensureInitialized()
        .encodeJson<ConversationSentiment>(this as ConversationSentiment);
  }

  Map<String, dynamic> toMap() {
    return ConversationSentimentMapper.ensureInitialized()
        .encodeMap<ConversationSentiment>(this as ConversationSentiment);
  }

  ConversationSentimentCopyWith<
    ConversationSentiment,
    ConversationSentiment,
    ConversationSentiment
  >
  get copyWith =>
      _ConversationSentimentCopyWithImpl<
        ConversationSentiment,
        ConversationSentiment
      >(this as ConversationSentiment, $identity, $identity);
  @override
  String toString() {
    return ConversationSentimentMapper.ensureInitialized().stringifyValue(
      this as ConversationSentiment,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConversationSentimentMapper.ensureInitialized().equalsValue(
      this as ConversationSentiment,
      other,
    );
  }

  @override
  int get hashCode {
    return ConversationSentimentMapper.ensureInitialized().hashValue(
      this as ConversationSentiment,
    );
  }
}

extension ConversationSentimentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConversationSentiment, $Out> {
  ConversationSentimentCopyWith<$R, ConversationSentiment, $Out>
  get $asConversationSentiment => $base.as(
    (v, t, t2) => _ConversationSentimentCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ConversationSentimentCopyWith<
  $R,
  $In extends ConversationSentiment,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get indicators;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get recommendations;
  $R call({
    String? analysisId,
    String? matchId,
    double? sentimentScore,
    double? engagementLevel,
    int? avgResponseTimeSeconds,
    int? avgMessageLength,
    List<String>? indicators,
    List<String>? recommendations,
    DateTime? analyzedAt,
  });
  ConversationSentimentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConversationSentimentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConversationSentiment, $Out>
    implements ConversationSentimentCopyWith<$R, ConversationSentiment, $Out> {
  _ConversationSentimentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConversationSentiment> $mapper =
      ConversationSentimentMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get indicators =>
      ListCopyWith(
        $value.indicators,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(indicators: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get recommendations => ListCopyWith(
    $value.recommendations,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(recommendations: v),
  );
  @override
  $R call({
    String? analysisId,
    String? matchId,
    double? sentimentScore,
    double? engagementLevel,
    int? avgResponseTimeSeconds,
    int? avgMessageLength,
    List<String>? indicators,
    List<String>? recommendations,
    DateTime? analyzedAt,
  }) => $apply(
    FieldCopyWithData({
      if (analysisId != null) #analysisId: analysisId,
      if (matchId != null) #matchId: matchId,
      if (sentimentScore != null) #sentimentScore: sentimentScore,
      if (engagementLevel != null) #engagementLevel: engagementLevel,
      if (avgResponseTimeSeconds != null)
        #avgResponseTimeSeconds: avgResponseTimeSeconds,
      if (avgMessageLength != null) #avgMessageLength: avgMessageLength,
      if (indicators != null) #indicators: indicators,
      if (recommendations != null) #recommendations: recommendations,
      if (analyzedAt != null) #analyzedAt: analyzedAt,
    }),
  );
  @override
  ConversationSentiment $make(CopyWithData data) => ConversationSentiment(
    analysisId: data.get(#analysisId, or: $value.analysisId),
    matchId: data.get(#matchId, or: $value.matchId),
    sentimentScore: data.get(#sentimentScore, or: $value.sentimentScore),
    engagementLevel: data.get(#engagementLevel, or: $value.engagementLevel),
    avgResponseTimeSeconds: data.get(
      #avgResponseTimeSeconds,
      or: $value.avgResponseTimeSeconds,
    ),
    avgMessageLength: data.get(#avgMessageLength, or: $value.avgMessageLength),
    indicators: data.get(#indicators, or: $value.indicators),
    recommendations: data.get(#recommendations, or: $value.recommendations),
    analyzedAt: data.get(#analyzedAt, or: $value.analyzedAt),
  );

  @override
  ConversationSentimentCopyWith<$R2, ConversationSentiment, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ConversationSentimentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SuggestionUsageStatsMapper extends ClassMapperBase<SuggestionUsageStats> {
  SuggestionUsageStatsMapper._();

  static SuggestionUsageStatsMapper? _instance;
  static SuggestionUsageStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SuggestionUsageStatsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SuggestionUsageStats';

  static int _$totalGenerated(SuggestionUsageStats v) => v.totalGenerated;
  static const Field<SuggestionUsageStats, int> _f$totalGenerated = Field(
    'totalGenerated',
    _$totalGenerated,
  );
  static int _$totalUsed(SuggestionUsageStats v) => v.totalUsed;
  static const Field<SuggestionUsageStats, int> _f$totalUsed = Field(
    'totalUsed',
    _$totalUsed,
  );
  static Map<String, int> _$usageByType(SuggestionUsageStats v) =>
      v.usageByType;
  static const Field<SuggestionUsageStats, Map<String, int>> _f$usageByType =
      Field('usageByType', _$usageByType);
  static double _$avgRelevanceScore(SuggestionUsageStats v) =>
      v.avgRelevanceScore;
  static const Field<SuggestionUsageStats, double> _f$avgRelevanceScore = Field(
    'avgRelevanceScore',
    _$avgRelevanceScore,
  );
  static double _$acceptanceRate(SuggestionUsageStats v) => v.acceptanceRate;
  static const Field<SuggestionUsageStats, double> _f$acceptanceRate = Field(
    'acceptanceRate',
    _$acceptanceRate,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<SuggestionUsageStats> fields = const {
    #totalGenerated: _f$totalGenerated,
    #totalUsed: _f$totalUsed,
    #usageByType: _f$usageByType,
    #avgRelevanceScore: _f$avgRelevanceScore,
    #acceptanceRate: _f$acceptanceRate,
  };

  static SuggestionUsageStats _instantiate(DecodingData data) {
    return SuggestionUsageStats(
      totalGenerated: data.dec(_f$totalGenerated),
      totalUsed: data.dec(_f$totalUsed),
      usageByType: data.dec(_f$usageByType),
      avgRelevanceScore: data.dec(_f$avgRelevanceScore),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SuggestionUsageStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SuggestionUsageStats>(map);
  }

  static SuggestionUsageStats fromJson(String json) {
    return ensureInitialized().decodeJson<SuggestionUsageStats>(json);
  }
}

mixin SuggestionUsageStatsMappable {
  String toJson() {
    return SuggestionUsageStatsMapper.ensureInitialized()
        .encodeJson<SuggestionUsageStats>(this as SuggestionUsageStats);
  }

  Map<String, dynamic> toMap() {
    return SuggestionUsageStatsMapper.ensureInitialized()
        .encodeMap<SuggestionUsageStats>(this as SuggestionUsageStats);
  }

  SuggestionUsageStatsCopyWith<
    SuggestionUsageStats,
    SuggestionUsageStats,
    SuggestionUsageStats
  >
  get copyWith =>
      _SuggestionUsageStatsCopyWithImpl<
        SuggestionUsageStats,
        SuggestionUsageStats
      >(this as SuggestionUsageStats, $identity, $identity);
  @override
  String toString() {
    return SuggestionUsageStatsMapper.ensureInitialized().stringifyValue(
      this as SuggestionUsageStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return SuggestionUsageStatsMapper.ensureInitialized().equalsValue(
      this as SuggestionUsageStats,
      other,
    );
  }

  @override
  int get hashCode {
    return SuggestionUsageStatsMapper.ensureInitialized().hashValue(
      this as SuggestionUsageStats,
    );
  }
}

extension SuggestionUsageStatsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SuggestionUsageStats, $Out> {
  SuggestionUsageStatsCopyWith<$R, SuggestionUsageStats, $Out>
  get $asSuggestionUsageStats => $base.as(
    (v, t, t2) => _SuggestionUsageStatsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SuggestionUsageStatsCopyWith<
  $R,
  $In extends SuggestionUsageStats,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get usageByType;
  $R call({
    int? totalGenerated,
    int? totalUsed,
    Map<String, int>? usageByType,
    double? avgRelevanceScore,
  });
  SuggestionUsageStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SuggestionUsageStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SuggestionUsageStats, $Out>
    implements SuggestionUsageStatsCopyWith<$R, SuggestionUsageStats, $Out> {
  _SuggestionUsageStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SuggestionUsageStats> $mapper =
      SuggestionUsageStatsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get usageByType =>
      MapCopyWith(
        $value.usageByType,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(usageByType: v),
      );
  @override
  $R call({
    int? totalGenerated,
    int? totalUsed,
    Map<String, int>? usageByType,
    double? avgRelevanceScore,
  }) => $apply(
    FieldCopyWithData({
      if (totalGenerated != null) #totalGenerated: totalGenerated,
      if (totalUsed != null) #totalUsed: totalUsed,
      if (usageByType != null) #usageByType: usageByType,
      if (avgRelevanceScore != null) #avgRelevanceScore: avgRelevanceScore,
    }),
  );
  @override
  SuggestionUsageStats $make(CopyWithData data) => SuggestionUsageStats(
    totalGenerated: data.get(#totalGenerated, or: $value.totalGenerated),
    totalUsed: data.get(#totalUsed, or: $value.totalUsed),
    usageByType: data.get(#usageByType, or: $value.usageByType),
    avgRelevanceScore: data.get(
      #avgRelevanceScore,
      or: $value.avgRelevanceScore,
    ),
  );

  @override
  SuggestionUsageStatsCopyWith<$R2, SuggestionUsageStats, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SuggestionUsageStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

