// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'compatibility_score.dart';

class CompatibilityScoreMapper extends ClassMapperBase<CompatibilityScore> {
  CompatibilityScoreMapper._();

  static CompatibilityScoreMapper? _instance;
  static CompatibilityScoreMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CompatibilityScoreMapper._());
      CompatibilityInsightMapper.ensureInitialized();
      MatchPredictionMapper.ensureInitialized();
      BehavioralAnalysisMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CompatibilityScore';

  static String _$scoreId(CompatibilityScore v) => v.scoreId;
  static const Field<CompatibilityScore, String> _f$scoreId = Field(
    'scoreId',
    _$scoreId,
  );
  static String _$userId1(CompatibilityScore v) => v.userId1;
  static const Field<CompatibilityScore, String> _f$userId1 = Field(
    'userId1',
    _$userId1,
  );
  static String _$userId2(CompatibilityScore v) => v.userId2;
  static const Field<CompatibilityScore, String> _f$userId2 = Field(
    'userId2',
    _$userId2,
  );
  static double _$overallScore(CompatibilityScore v) => v.overallScore;
  static const Field<CompatibilityScore, double> _f$overallScore = Field(
    'overallScore',
    _$overallScore,
  );
  static DateTime _$calculatedAt(CompatibilityScore v) => v.calculatedAt;
  static const Field<CompatibilityScore, DateTime> _f$calculatedAt = Field(
    'calculatedAt',
    _$calculatedAt,
  );
  static Map<CompatibilityFactor, double> _$factorScores(
    CompatibilityScore v,
  ) => v.factorScores;
  static const Field<CompatibilityScore, Map<CompatibilityFactor, double>>
  _f$factorScores = Field('factorScores', _$factorScores);
  static List<CompatibilityInsight> _$insights(CompatibilityScore v) =>
      v.insights;
  static const Field<CompatibilityScore, List<CompatibilityInsight>>
  _f$insights = Field('insights', _$insights);
  static MatchPrediction _$prediction(CompatibilityScore v) => v.prediction;
  static const Field<CompatibilityScore, MatchPrediction> _f$prediction = Field(
    'prediction',
    _$prediction,
  );
  static BehavioralAnalysis? _$behavioralData(CompatibilityScore v) =>
      v.behavioralData;
  static const Field<CompatibilityScore, BehavioralAnalysis> _f$behavioralData =
      Field('behavioralData', _$behavioralData, opt: true);
  static bool _$isHighCompatibility(CompatibilityScore v) =>
      v.isHighCompatibility;
  static const Field<CompatibilityScore, bool> _f$isHighCompatibility = Field(
    'isHighCompatibility',
    _$isHighCompatibility,
    mode: FieldMode.member,
  );
  static bool _$isMediumCompatibility(CompatibilityScore v) =>
      v.isMediumCompatibility;
  static const Field<CompatibilityScore, bool> _f$isMediumCompatibility = Field(
    'isMediumCompatibility',
    _$isMediumCompatibility,
    mode: FieldMode.member,
  );
  static List<MapEntry<CompatibilityFactor, double>> _$topFactors(
    CompatibilityScore v,
  ) => v.topFactors;
  static const Field<
    CompatibilityScore,
    List<MapEntry<CompatibilityFactor, double>>
  >
  _f$topFactors = Field('topFactors', _$topFactors, mode: FieldMode.member);
  static List<MapEntry<CompatibilityFactor, double>> _$weakFactors(
    CompatibilityScore v,
  ) => v.weakFactors;
  static const Field<
    CompatibilityScore,
    List<MapEntry<CompatibilityFactor, double>>
  >
  _f$weakFactors = Field('weakFactors', _$weakFactors, mode: FieldMode.member);

  @override
  final MappableFields<CompatibilityScore> fields = const {
    #scoreId: _f$scoreId,
    #userId1: _f$userId1,
    #userId2: _f$userId2,
    #overallScore: _f$overallScore,
    #calculatedAt: _f$calculatedAt,
    #factorScores: _f$factorScores,
    #insights: _f$insights,
    #prediction: _f$prediction,
    #behavioralData: _f$behavioralData,
    #isHighCompatibility: _f$isHighCompatibility,
    #isMediumCompatibility: _f$isMediumCompatibility,
    #topFactors: _f$topFactors,
    #weakFactors: _f$weakFactors,
  };

  static CompatibilityScore _instantiate(DecodingData data) {
    return CompatibilityScore(
      scoreId: data.dec(_f$scoreId),
      userId1: data.dec(_f$userId1),
      userId2: data.dec(_f$userId2),
      overallScore: data.dec(_f$overallScore),
      calculatedAt: data.dec(_f$calculatedAt),
      factorScores: data.dec(_f$factorScores),
      insights: data.dec(_f$insights),
      prediction: data.dec(_f$prediction),
      behavioralData: data.dec(_f$behavioralData),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CompatibilityScore fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CompatibilityScore>(map);
  }

  static CompatibilityScore fromJson(String json) {
    return ensureInitialized().decodeJson<CompatibilityScore>(json);
  }
}

mixin CompatibilityScoreMappable {
  String toJson() {
    return CompatibilityScoreMapper.ensureInitialized()
        .encodeJson<CompatibilityScore>(this as CompatibilityScore);
  }

  Map<String, dynamic> toMap() {
    return CompatibilityScoreMapper.ensureInitialized()
        .encodeMap<CompatibilityScore>(this as CompatibilityScore);
  }

  CompatibilityScoreCopyWith<
    CompatibilityScore,
    CompatibilityScore,
    CompatibilityScore
  >
  get copyWith =>
      _CompatibilityScoreCopyWithImpl<CompatibilityScore, CompatibilityScore>(
        this as CompatibilityScore,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CompatibilityScoreMapper.ensureInitialized().stringifyValue(
      this as CompatibilityScore,
    );
  }

  @override
  bool operator ==(Object other) {
    return CompatibilityScoreMapper.ensureInitialized().equalsValue(
      this as CompatibilityScore,
      other,
    );
  }

  @override
  int get hashCode {
    return CompatibilityScoreMapper.ensureInitialized().hashValue(
      this as CompatibilityScore,
    );
  }
}

extension CompatibilityScoreValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CompatibilityScore, $Out> {
  CompatibilityScoreCopyWith<$R, CompatibilityScore, $Out>
  get $asCompatibilityScore => $base.as(
    (v, t, t2) => _CompatibilityScoreCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CompatibilityScoreCopyWith<
  $R,
  $In extends CompatibilityScore,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    CompatibilityFactor,
    double,
    ObjectCopyWith<$R, double, double>
  >
  get factorScores;
  ListCopyWith<
    $R,
    CompatibilityInsight,
    CompatibilityInsightCopyWith<$R, CompatibilityInsight, CompatibilityInsight>
  >
  get insights;
  MatchPredictionCopyWith<$R, MatchPrediction, MatchPrediction> get prediction;
  BehavioralAnalysisCopyWith<$R, BehavioralAnalysis, BehavioralAnalysis>?
  get behavioralData;
  $R call({
    String? scoreId,
    String? userId1,
    String? userId2,
    double? overallScore,
    DateTime? calculatedAt,
    Map<CompatibilityFactor, double>? factorScores,
    List<CompatibilityInsight>? insights,
    MatchPrediction? prediction,
    BehavioralAnalysis? behavioralData,
  });
  CompatibilityScoreCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CompatibilityScoreCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CompatibilityScore, $Out>
    implements CompatibilityScoreCopyWith<$R, CompatibilityScore, $Out> {
  _CompatibilityScoreCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CompatibilityScore> $mapper =
      CompatibilityScoreMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    CompatibilityFactor,
    double,
    ObjectCopyWith<$R, double, double>
  >
  get factorScores => MapCopyWith(
    $value.factorScores,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(factorScores: v),
  );
  @override
  ListCopyWith<
    $R,
    CompatibilityInsight,
    CompatibilityInsightCopyWith<$R, CompatibilityInsight, CompatibilityInsight>
  >
  get insights => ListCopyWith(
    $value.insights,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(insights: v),
  );
  @override
  MatchPredictionCopyWith<$R, MatchPrediction, MatchPrediction>
  get prediction =>
      $value.prediction.copyWith.$chain((v) => call(prediction: v));
  @override
  BehavioralAnalysisCopyWith<$R, BehavioralAnalysis, BehavioralAnalysis>?
  get behavioralData =>
      $value.behavioralData?.copyWith.$chain((v) => call(behavioralData: v));
  @override
  $R call({
    String? scoreId,
    String? userId1,
    String? userId2,
    double? overallScore,
    DateTime? calculatedAt,
    Map<CompatibilityFactor, double>? factorScores,
    List<CompatibilityInsight>? insights,
    MatchPrediction? prediction,
    Object? behavioralData = $none,
  }) => $apply(
    FieldCopyWithData({
      if (scoreId != null) #scoreId: scoreId,
      if (userId1 != null) #userId1: userId1,
      if (userId2 != null) #userId2: userId2,
      if (overallScore != null) #overallScore: overallScore,
      if (calculatedAt != null) #calculatedAt: calculatedAt,
      if (factorScores != null) #factorScores: factorScores,
      if (insights != null) #insights: insights,
      if (prediction != null) #prediction: prediction,
      if (behavioralData != $none) #behavioralData: behavioralData,
    }),
  );
  @override
  CompatibilityScore $make(CopyWithData data) => CompatibilityScore(
    scoreId: data.get(#scoreId, or: $value.scoreId),
    userId1: data.get(#userId1, or: $value.userId1),
    userId2: data.get(#userId2, or: $value.userId2),
    overallScore: data.get(#overallScore, or: $value.overallScore),
    calculatedAt: data.get(#calculatedAt, or: $value.calculatedAt),
    factorScores: data.get(#factorScores, or: $value.factorScores),
    insights: data.get(#insights, or: $value.insights),
    prediction: data.get(#prediction, or: $value.prediction),
    behavioralData: data.get(#behavioralData, or: $value.behavioralData),
  );

  @override
  CompatibilityScoreCopyWith<$R2, CompatibilityScore, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CompatibilityScoreCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CompatibilityInsightMapper extends ClassMapperBase<CompatibilityInsight> {
  CompatibilityInsightMapper._();

  static CompatibilityInsightMapper? _instance;
  static CompatibilityInsightMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CompatibilityInsightMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CompatibilityInsight';

  static String _$insightId(CompatibilityInsight v) => v.insightId;
  static const Field<CompatibilityInsight, String> _f$insightId = Field(
    'insightId',
    _$insightId,
  );
  static InsightType _$type(CompatibilityInsight v) => v.type;
  static const Field<CompatibilityInsight, InsightType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$title(CompatibilityInsight v) => v.title;
  static const Field<CompatibilityInsight, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$description(CompatibilityInsight v) => v.description;
  static const Field<CompatibilityInsight, String> _f$description = Field(
    'description',
    _$description,
  );
  static double _$impactScore(CompatibilityInsight v) => v.impactScore;
  static const Field<CompatibilityInsight, double> _f$impactScore = Field(
    'impactScore',
    _$impactScore,
  );
  static List<String> _$suggestions(CompatibilityInsight v) => v.suggestions;
  static const Field<CompatibilityInsight, List<String>> _f$suggestions = Field(
    'suggestions',
    _$suggestions,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<CompatibilityInsight> fields = const {
    #insightId: _f$insightId,
    #type: _f$type,
    #title: _f$title,
    #description: _f$description,
    #impactScore: _f$impactScore,
    #suggestions: _f$suggestions,
  };

  static CompatibilityInsight _instantiate(DecodingData data) {
    return CompatibilityInsight(
      insightId: data.dec(_f$insightId),
      type: data.dec(_f$type),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      impactScore: data.dec(_f$impactScore),
      suggestions: data.dec(_f$suggestions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CompatibilityInsight fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CompatibilityInsight>(map);
  }

  static CompatibilityInsight fromJson(String json) {
    return ensureInitialized().decodeJson<CompatibilityInsight>(json);
  }
}

mixin CompatibilityInsightMappable {
  String toJson() {
    return CompatibilityInsightMapper.ensureInitialized()
        .encodeJson<CompatibilityInsight>(this as CompatibilityInsight);
  }

  Map<String, dynamic> toMap() {
    return CompatibilityInsightMapper.ensureInitialized()
        .encodeMap<CompatibilityInsight>(this as CompatibilityInsight);
  }

  CompatibilityInsightCopyWith<
    CompatibilityInsight,
    CompatibilityInsight,
    CompatibilityInsight
  >
  get copyWith =>
      _CompatibilityInsightCopyWithImpl<
        CompatibilityInsight,
        CompatibilityInsight
      >(this as CompatibilityInsight, $identity, $identity);
  @override
  String toString() {
    return CompatibilityInsightMapper.ensureInitialized().stringifyValue(
      this as CompatibilityInsight,
    );
  }

  @override
  bool operator ==(Object other) {
    return CompatibilityInsightMapper.ensureInitialized().equalsValue(
      this as CompatibilityInsight,
      other,
    );
  }

  @override
  int get hashCode {
    return CompatibilityInsightMapper.ensureInitialized().hashValue(
      this as CompatibilityInsight,
    );
  }
}

extension CompatibilityInsightValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CompatibilityInsight, $Out> {
  CompatibilityInsightCopyWith<$R, CompatibilityInsight, $Out>
  get $asCompatibilityInsight => $base.as(
    (v, t, t2) => _CompatibilityInsightCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CompatibilityInsightCopyWith<
  $R,
  $In extends CompatibilityInsight,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get suggestions;
  $R call({
    String? insightId,
    InsightType? type,
    String? title,
    String? description,
    double? impactScore,
    List<String>? suggestions,
  });
  CompatibilityInsightCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CompatibilityInsightCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CompatibilityInsight, $Out>
    implements CompatibilityInsightCopyWith<$R, CompatibilityInsight, $Out> {
  _CompatibilityInsightCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CompatibilityInsight> $mapper =
      CompatibilityInsightMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get suggestions => ListCopyWith(
    $value.suggestions,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(suggestions: v),
  );
  @override
  $R call({
    String? insightId,
    InsightType? type,
    String? title,
    String? description,
    double? impactScore,
    List<String>? suggestions,
  }) => $apply(
    FieldCopyWithData({
      if (insightId != null) #insightId: insightId,
      if (type != null) #type: type,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (impactScore != null) #impactScore: impactScore,
      if (suggestions != null) #suggestions: suggestions,
    }),
  );
  @override
  CompatibilityInsight $make(CopyWithData data) => CompatibilityInsight(
    insightId: data.get(#insightId, or: $value.insightId),
    type: data.get(#type, or: $value.type),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    impactScore: data.get(#impactScore, or: $value.impactScore),
    suggestions: data.get(#suggestions, or: $value.suggestions),
  );

  @override
  CompatibilityInsightCopyWith<$R2, CompatibilityInsight, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CompatibilityInsightCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MatchPredictionMapper extends ClassMapperBase<MatchPrediction> {
  MatchPredictionMapper._();

  static MatchPredictionMapper? _instance;
  static MatchPredictionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchPredictionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MatchPrediction';

  static double _$successProbability(MatchPrediction v) => v.successProbability;
  static const Field<MatchPrediction, double> _f$successProbability = Field(
    'successProbability',
    _$successProbability,
  );
  static MatchOutcome _$predictedOutcome(MatchPrediction v) =>
      v.predictedOutcome;
  static const Field<MatchPrediction, MatchOutcome> _f$predictedOutcome = Field(
    'predictedOutcome',
    _$predictedOutcome,
  );
  static int _$estimatedMessagesBeforeMeet(MatchPrediction v) =>
      v.estimatedMessagesBeforeMeet;
  static const Field<MatchPrediction, int> _f$estimatedMessagesBeforeMeet =
      Field('estimatedMessagesBeforeMeet', _$estimatedMessagesBeforeMeet);
  static int _$estimatedDaysToFirstDate(MatchPrediction v) =>
      v.estimatedDaysToFirstDate;
  static const Field<MatchPrediction, int> _f$estimatedDaysToFirstDate = Field(
    'estimatedDaysToFirstDate',
    _$estimatedDaysToFirstDate,
  );
  static double _$longTermPotential(MatchPrediction v) => v.longTermPotential;
  static const Field<MatchPrediction, double> _f$longTermPotential = Field(
    'longTermPotential',
    _$longTermPotential,
  );
  static List<String> _$riskFactors(MatchPrediction v) => v.riskFactors;
  static const Field<MatchPrediction, List<String>> _f$riskFactors = Field(
    'riskFactors',
    _$riskFactors,
    opt: true,
    def: const [],
  );
  static List<String> _$successFactors(MatchPrediction v) => v.successFactors;
  static const Field<MatchPrediction, List<String>> _f$successFactors = Field(
    'successFactors',
    _$successFactors,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<MatchPrediction> fields = const {
    #successProbability: _f$successProbability,
    #predictedOutcome: _f$predictedOutcome,
    #estimatedMessagesBeforeMeet: _f$estimatedMessagesBeforeMeet,
    #estimatedDaysToFirstDate: _f$estimatedDaysToFirstDate,
    #longTermPotential: _f$longTermPotential,
    #riskFactors: _f$riskFactors,
    #successFactors: _f$successFactors,
  };

  static MatchPrediction _instantiate(DecodingData data) {
    return MatchPrediction(
      successProbability: data.dec(_f$successProbability),
      predictedOutcome: data.dec(_f$predictedOutcome),
      estimatedMessagesBeforeMeet: data.dec(_f$estimatedMessagesBeforeMeet),
      estimatedDaysToFirstDate: data.dec(_f$estimatedDaysToFirstDate),
      longTermPotential: data.dec(_f$longTermPotential),
      riskFactors: data.dec(_f$riskFactors),
      successFactors: data.dec(_f$successFactors),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MatchPrediction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchPrediction>(map);
  }

  static MatchPrediction fromJson(String json) {
    return ensureInitialized().decodeJson<MatchPrediction>(json);
  }
}

mixin MatchPredictionMappable {
  String toJson() {
    return MatchPredictionMapper.ensureInitialized()
        .encodeJson<MatchPrediction>(this as MatchPrediction);
  }

  Map<String, dynamic> toMap() {
    return MatchPredictionMapper.ensureInitialized().encodeMap<MatchPrediction>(
      this as MatchPrediction,
    );
  }

  MatchPredictionCopyWith<MatchPrediction, MatchPrediction, MatchPrediction>
  get copyWith =>
      _MatchPredictionCopyWithImpl<MatchPrediction, MatchPrediction>(
        this as MatchPrediction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MatchPredictionMapper.ensureInitialized().stringifyValue(
      this as MatchPrediction,
    );
  }

  @override
  bool operator ==(Object other) {
    return MatchPredictionMapper.ensureInitialized().equalsValue(
      this as MatchPrediction,
      other,
    );
  }

  @override
  int get hashCode {
    return MatchPredictionMapper.ensureInitialized().hashValue(
      this as MatchPrediction,
    );
  }
}

extension MatchPredictionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchPrediction, $Out> {
  MatchPredictionCopyWith<$R, MatchPrediction, $Out> get $asMatchPrediction =>
      $base.as((v, t, t2) => _MatchPredictionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchPredictionCopyWith<$R, $In extends MatchPrediction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get riskFactors;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get successFactors;
  $R call({
    double? successProbability,
    MatchOutcome? predictedOutcome,
    int? estimatedMessagesBeforeMeet,
    int? estimatedDaysToFirstDate,
    double? longTermPotential,
    List<String>? riskFactors,
    List<String>? successFactors,
  });
  MatchPredictionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MatchPredictionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchPrediction, $Out>
    implements MatchPredictionCopyWith<$R, MatchPrediction, $Out> {
  _MatchPredictionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchPrediction> $mapper =
      MatchPredictionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get riskFactors => ListCopyWith(
    $value.riskFactors,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(riskFactors: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get successFactors => ListCopyWith(
    $value.successFactors,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(successFactors: v),
  );
  @override
  $R call({
    double? successProbability,
    MatchOutcome? predictedOutcome,
    int? estimatedMessagesBeforeMeet,
    int? estimatedDaysToFirstDate,
    double? longTermPotential,
    List<String>? riskFactors,
    List<String>? successFactors,
  }) => $apply(
    FieldCopyWithData({
      if (successProbability != null) #successProbability: successProbability,
      if (predictedOutcome != null) #predictedOutcome: predictedOutcome,
      if (estimatedMessagesBeforeMeet != null)
        #estimatedMessagesBeforeMeet: estimatedMessagesBeforeMeet,
      if (estimatedDaysToFirstDate != null)
        #estimatedDaysToFirstDate: estimatedDaysToFirstDate,
      if (longTermPotential != null) #longTermPotential: longTermPotential,
      if (riskFactors != null) #riskFactors: riskFactors,
      if (successFactors != null) #successFactors: successFactors,
    }),
  );
  @override
  MatchPrediction $make(CopyWithData data) => MatchPrediction(
    successProbability: data.get(
      #successProbability,
      or: $value.successProbability,
    ),
    predictedOutcome: data.get(#predictedOutcome, or: $value.predictedOutcome),
    estimatedMessagesBeforeMeet: data.get(
      #estimatedMessagesBeforeMeet,
      or: $value.estimatedMessagesBeforeMeet,
    ),
    estimatedDaysToFirstDate: data.get(
      #estimatedDaysToFirstDate,
      or: $value.estimatedDaysToFirstDate,
    ),
    longTermPotential: data.get(
      #longTermPotential,
      or: $value.longTermPotential,
    ),
    riskFactors: data.get(#riskFactors, or: $value.riskFactors),
    successFactors: data.get(#successFactors, or: $value.successFactors),
  );

  @override
  MatchPredictionCopyWith<$R2, MatchPrediction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MatchPredictionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BehavioralAnalysisMapper extends ClassMapperBase<BehavioralAnalysis> {
  BehavioralAnalysisMapper._();

  static BehavioralAnalysisMapper? _instance;
  static BehavioralAnalysisMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BehavioralAnalysisMapper._());
      UserBehaviorProfileMapper.ensureInitialized();
      BehaviorPatternMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BehavioralAnalysis';

  static String _$analysisId(BehavioralAnalysis v) => v.analysisId;
  static const Field<BehavioralAnalysis, String> _f$analysisId = Field(
    'analysisId',
    _$analysisId,
  );
  static DateTime _$analyzedAt(BehavioralAnalysis v) => v.analyzedAt;
  static const Field<BehavioralAnalysis, DateTime> _f$analyzedAt = Field(
    'analyzedAt',
    _$analyzedAt,
  );
  static UserBehaviorProfile _$user1Behavior(BehavioralAnalysis v) =>
      v.user1Behavior;
  static const Field<BehavioralAnalysis, UserBehaviorProfile> _f$user1Behavior =
      Field('user1Behavior', _$user1Behavior);
  static UserBehaviorProfile _$user2Behavior(BehavioralAnalysis v) =>
      v.user2Behavior;
  static const Field<BehavioralAnalysis, UserBehaviorProfile> _f$user2Behavior =
      Field('user2Behavior', _$user2Behavior);
  static double _$behavioralCompatibility(BehavioralAnalysis v) =>
      v.behavioralCompatibility;
  static const Field<BehavioralAnalysis, double> _f$behavioralCompatibility =
      Field('behavioralCompatibility', _$behavioralCompatibility);
  static List<BehaviorPattern> _$sharedPatterns(BehavioralAnalysis v) =>
      v.sharedPatterns;
  static const Field<BehavioralAnalysis, List<BehaviorPattern>>
  _f$sharedPatterns = Field(
    'sharedPatterns',
    _$sharedPatterns,
    opt: true,
    def: const [],
  );
  static List<BehaviorPattern> _$conflictingPatterns(BehavioralAnalysis v) =>
      v.conflictingPatterns;
  static const Field<BehavioralAnalysis, List<BehaviorPattern>>
  _f$conflictingPatterns = Field(
    'conflictingPatterns',
    _$conflictingPatterns,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<BehavioralAnalysis> fields = const {
    #analysisId: _f$analysisId,
    #analyzedAt: _f$analyzedAt,
    #user1Behavior: _f$user1Behavior,
    #user2Behavior: _f$user2Behavior,
    #behavioralCompatibility: _f$behavioralCompatibility,
    #sharedPatterns: _f$sharedPatterns,
    #conflictingPatterns: _f$conflictingPatterns,
  };

  static BehavioralAnalysis _instantiate(DecodingData data) {
    return BehavioralAnalysis(
      analysisId: data.dec(_f$analysisId),
      analyzedAt: data.dec(_f$analyzedAt),
      user1Behavior: data.dec(_f$user1Behavior),
      user2Behavior: data.dec(_f$user2Behavior),
      behavioralCompatibility: data.dec(_f$behavioralCompatibility),
      sharedPatterns: data.dec(_f$sharedPatterns),
      conflictingPatterns: data.dec(_f$conflictingPatterns),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BehavioralAnalysis fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BehavioralAnalysis>(map);
  }

  static BehavioralAnalysis fromJson(String json) {
    return ensureInitialized().decodeJson<BehavioralAnalysis>(json);
  }
}

mixin BehavioralAnalysisMappable {
  String toJson() {
    return BehavioralAnalysisMapper.ensureInitialized()
        .encodeJson<BehavioralAnalysis>(this as BehavioralAnalysis);
  }

  Map<String, dynamic> toMap() {
    return BehavioralAnalysisMapper.ensureInitialized()
        .encodeMap<BehavioralAnalysis>(this as BehavioralAnalysis);
  }

  BehavioralAnalysisCopyWith<
    BehavioralAnalysis,
    BehavioralAnalysis,
    BehavioralAnalysis
  >
  get copyWith =>
      _BehavioralAnalysisCopyWithImpl<BehavioralAnalysis, BehavioralAnalysis>(
        this as BehavioralAnalysis,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BehavioralAnalysisMapper.ensureInitialized().stringifyValue(
      this as BehavioralAnalysis,
    );
  }

  @override
  bool operator ==(Object other) {
    return BehavioralAnalysisMapper.ensureInitialized().equalsValue(
      this as BehavioralAnalysis,
      other,
    );
  }

  @override
  int get hashCode {
    return BehavioralAnalysisMapper.ensureInitialized().hashValue(
      this as BehavioralAnalysis,
    );
  }
}

extension BehavioralAnalysisValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BehavioralAnalysis, $Out> {
  BehavioralAnalysisCopyWith<$R, BehavioralAnalysis, $Out>
  get $asBehavioralAnalysis => $base.as(
    (v, t, t2) => _BehavioralAnalysisCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class BehavioralAnalysisCopyWith<
  $R,
  $In extends BehavioralAnalysis,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  UserBehaviorProfileCopyWith<$R, UserBehaviorProfile, UserBehaviorProfile>
  get user1Behavior;
  UserBehaviorProfileCopyWith<$R, UserBehaviorProfile, UserBehaviorProfile>
  get user2Behavior;
  ListCopyWith<
    $R,
    BehaviorPattern,
    BehaviorPatternCopyWith<$R, BehaviorPattern, BehaviorPattern>
  >
  get sharedPatterns;
  ListCopyWith<
    $R,
    BehaviorPattern,
    BehaviorPatternCopyWith<$R, BehaviorPattern, BehaviorPattern>
  >
  get conflictingPatterns;
  $R call({
    String? analysisId,
    DateTime? analyzedAt,
    UserBehaviorProfile? user1Behavior,
    UserBehaviorProfile? user2Behavior,
    double? behavioralCompatibility,
    List<BehaviorPattern>? sharedPatterns,
    List<BehaviorPattern>? conflictingPatterns,
  });
  BehavioralAnalysisCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BehavioralAnalysisCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BehavioralAnalysis, $Out>
    implements BehavioralAnalysisCopyWith<$R, BehavioralAnalysis, $Out> {
  _BehavioralAnalysisCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BehavioralAnalysis> $mapper =
      BehavioralAnalysisMapper.ensureInitialized();
  @override
  UserBehaviorProfileCopyWith<$R, UserBehaviorProfile, UserBehaviorProfile>
  get user1Behavior =>
      $value.user1Behavior.copyWith.$chain((v) => call(user1Behavior: v));
  @override
  UserBehaviorProfileCopyWith<$R, UserBehaviorProfile, UserBehaviorProfile>
  get user2Behavior =>
      $value.user2Behavior.copyWith.$chain((v) => call(user2Behavior: v));
  @override
  ListCopyWith<
    $R,
    BehaviorPattern,
    BehaviorPatternCopyWith<$R, BehaviorPattern, BehaviorPattern>
  >
  get sharedPatterns => ListCopyWith(
    $value.sharedPatterns,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(sharedPatterns: v),
  );
  @override
  ListCopyWith<
    $R,
    BehaviorPattern,
    BehaviorPatternCopyWith<$R, BehaviorPattern, BehaviorPattern>
  >
  get conflictingPatterns => ListCopyWith(
    $value.conflictingPatterns,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(conflictingPatterns: v),
  );
  @override
  $R call({
    String? analysisId,
    DateTime? analyzedAt,
    UserBehaviorProfile? user1Behavior,
    UserBehaviorProfile? user2Behavior,
    double? behavioralCompatibility,
    List<BehaviorPattern>? sharedPatterns,
    List<BehaviorPattern>? conflictingPatterns,
  }) => $apply(
    FieldCopyWithData({
      if (analysisId != null) #analysisId: analysisId,
      if (analyzedAt != null) #analyzedAt: analyzedAt,
      if (user1Behavior != null) #user1Behavior: user1Behavior,
      if (user2Behavior != null) #user2Behavior: user2Behavior,
      if (behavioralCompatibility != null)
        #behavioralCompatibility: behavioralCompatibility,
      if (sharedPatterns != null) #sharedPatterns: sharedPatterns,
      if (conflictingPatterns != null)
        #conflictingPatterns: conflictingPatterns,
    }),
  );
  @override
  BehavioralAnalysis $make(CopyWithData data) => BehavioralAnalysis(
    analysisId: data.get(#analysisId, or: $value.analysisId),
    analyzedAt: data.get(#analyzedAt, or: $value.analyzedAt),
    user1Behavior: data.get(#user1Behavior, or: $value.user1Behavior),
    user2Behavior: data.get(#user2Behavior, or: $value.user2Behavior),
    behavioralCompatibility: data.get(
      #behavioralCompatibility,
      or: $value.behavioralCompatibility,
    ),
    sharedPatterns: data.get(#sharedPatterns, or: $value.sharedPatterns),
    conflictingPatterns: data.get(
      #conflictingPatterns,
      or: $value.conflictingPatterns,
    ),
  );

  @override
  BehavioralAnalysisCopyWith<$R2, BehavioralAnalysis, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BehavioralAnalysisCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UserBehaviorProfileMapper extends ClassMapperBase<UserBehaviorProfile> {
  UserBehaviorProfileMapper._();

  static UserBehaviorProfileMapper? _instance;
  static UserBehaviorProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserBehaviorProfileMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserBehaviorProfile';

  static String _$userId(UserBehaviorProfile v) => v.userId;
  static const Field<UserBehaviorProfile, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static ResponsePattern _$responsePattern(UserBehaviorProfile v) =>
      v.responsePattern;
  static const Field<UserBehaviorProfile, ResponsePattern> _f$responsePattern =
      Field('responsePattern', _$responsePattern);
  static ActivityPattern _$activityPattern(UserBehaviorProfile v) =>
      v.activityPattern;
  static const Field<UserBehaviorProfile, ActivityPattern> _f$activityPattern =
      Field('activityPattern', _$activityPattern);
  static EngagementStyle _$engagementStyle(UserBehaviorProfile v) =>
      v.engagementStyle;
  static const Field<UserBehaviorProfile, EngagementStyle> _f$engagementStyle =
      Field('engagementStyle', _$engagementStyle);
  static ConversationStyle _$conversationStyle(UserBehaviorProfile v) =>
      v.conversationStyle;
  static const Field<UserBehaviorProfile, ConversationStyle>
  _f$conversationStyle = Field('conversationStyle', _$conversationStyle);
  static double _$averageResponseTimeMinutes(UserBehaviorProfile v) =>
      v.averageResponseTimeMinutes;
  static const Field<UserBehaviorProfile, double>
  _f$averageResponseTimeMinutes = Field(
    'averageResponseTimeMinutes',
    _$averageResponseTimeMinutes,
  );
  static double _$dailyActiveHours(UserBehaviorProfile v) => v.dailyActiveHours;
  static const Field<UserBehaviorProfile, double> _f$dailyActiveHours = Field(
    'dailyActiveHours',
    _$dailyActiveHours,
  );
  static int _$averageMessageLength(UserBehaviorProfile v) =>
      v.averageMessageLength;
  static const Field<UserBehaviorProfile, int> _f$averageMessageLength = Field(
    'averageMessageLength',
    _$averageMessageLength,
  );
  static double _$emojiUsageRate(UserBehaviorProfile v) => v.emojiUsageRate;
  static const Field<UserBehaviorProfile, double> _f$emojiUsageRate = Field(
    'emojiUsageRate',
    _$emojiUsageRate,
  );
  static double _$questionAskerRate(UserBehaviorProfile v) =>
      v.questionAskerRate;
  static const Field<UserBehaviorProfile, double> _f$questionAskerRate = Field(
    'questionAskerRate',
    _$questionAskerRate,
  );
  static Map<String, double> _$topicPreferences(UserBehaviorProfile v) =>
      v.topicPreferences;
  static const Field<UserBehaviorProfile, Map<String, double>>
  _f$topicPreferences = Field(
    'topicPreferences',
    _$topicPreferences,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<UserBehaviorProfile> fields = const {
    #userId: _f$userId,
    #responsePattern: _f$responsePattern,
    #activityPattern: _f$activityPattern,
    #engagementStyle: _f$engagementStyle,
    #conversationStyle: _f$conversationStyle,
    #averageResponseTimeMinutes: _f$averageResponseTimeMinutes,
    #dailyActiveHours: _f$dailyActiveHours,
    #averageMessageLength: _f$averageMessageLength,
    #emojiUsageRate: _f$emojiUsageRate,
    #questionAskerRate: _f$questionAskerRate,
    #topicPreferences: _f$topicPreferences,
  };

  static UserBehaviorProfile _instantiate(DecodingData data) {
    return UserBehaviorProfile(
      userId: data.dec(_f$userId),
      responsePattern: data.dec(_f$responsePattern),
      activityPattern: data.dec(_f$activityPattern),
      engagementStyle: data.dec(_f$engagementStyle),
      conversationStyle: data.dec(_f$conversationStyle),
      averageResponseTimeMinutes: data.dec(_f$averageResponseTimeMinutes),
      dailyActiveHours: data.dec(_f$dailyActiveHours),
      averageMessageLength: data.dec(_f$averageMessageLength),
      emojiUsageRate: data.dec(_f$emojiUsageRate),
      questionAskerRate: data.dec(_f$questionAskerRate),
      topicPreferences: data.dec(_f$topicPreferences),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserBehaviorProfile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserBehaviorProfile>(map);
  }

  static UserBehaviorProfile fromJson(String json) {
    return ensureInitialized().decodeJson<UserBehaviorProfile>(json);
  }
}

mixin UserBehaviorProfileMappable {
  String toJson() {
    return UserBehaviorProfileMapper.ensureInitialized()
        .encodeJson<UserBehaviorProfile>(this as UserBehaviorProfile);
  }

  Map<String, dynamic> toMap() {
    return UserBehaviorProfileMapper.ensureInitialized()
        .encodeMap<UserBehaviorProfile>(this as UserBehaviorProfile);
  }

  UserBehaviorProfileCopyWith<
    UserBehaviorProfile,
    UserBehaviorProfile,
    UserBehaviorProfile
  >
  get copyWith =>
      _UserBehaviorProfileCopyWithImpl<
        UserBehaviorProfile,
        UserBehaviorProfile
      >(this as UserBehaviorProfile, $identity, $identity);
  @override
  String toString() {
    return UserBehaviorProfileMapper.ensureInitialized().stringifyValue(
      this as UserBehaviorProfile,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserBehaviorProfileMapper.ensureInitialized().equalsValue(
      this as UserBehaviorProfile,
      other,
    );
  }

  @override
  int get hashCode {
    return UserBehaviorProfileMapper.ensureInitialized().hashValue(
      this as UserBehaviorProfile,
    );
  }
}

extension UserBehaviorProfileValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserBehaviorProfile, $Out> {
  UserBehaviorProfileCopyWith<$R, UserBehaviorProfile, $Out>
  get $asUserBehaviorProfile => $base.as(
    (v, t, t2) => _UserBehaviorProfileCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UserBehaviorProfileCopyWith<
  $R,
  $In extends UserBehaviorProfile,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, double, ObjectCopyWith<$R, double, double>>
  get topicPreferences;
  $R call({
    String? userId,
    ResponsePattern? responsePattern,
    ActivityPattern? activityPattern,
    EngagementStyle? engagementStyle,
    ConversationStyle? conversationStyle,
    double? averageResponseTimeMinutes,
    double? dailyActiveHours,
    int? averageMessageLength,
    double? emojiUsageRate,
    double? questionAskerRate,
    Map<String, double>? topicPreferences,
  });
  UserBehaviorProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UserBehaviorProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserBehaviorProfile, $Out>
    implements UserBehaviorProfileCopyWith<$R, UserBehaviorProfile, $Out> {
  _UserBehaviorProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserBehaviorProfile> $mapper =
      UserBehaviorProfileMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, double, ObjectCopyWith<$R, double, double>>
  get topicPreferences => MapCopyWith(
    $value.topicPreferences,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(topicPreferences: v),
  );
  @override
  $R call({
    String? userId,
    ResponsePattern? responsePattern,
    ActivityPattern? activityPattern,
    EngagementStyle? engagementStyle,
    ConversationStyle? conversationStyle,
    double? averageResponseTimeMinutes,
    double? dailyActiveHours,
    int? averageMessageLength,
    double? emojiUsageRate,
    double? questionAskerRate,
    Map<String, double>? topicPreferences,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (responsePattern != null) #responsePattern: responsePattern,
      if (activityPattern != null) #activityPattern: activityPattern,
      if (engagementStyle != null) #engagementStyle: engagementStyle,
      if (conversationStyle != null) #conversationStyle: conversationStyle,
      if (averageResponseTimeMinutes != null)
        #averageResponseTimeMinutes: averageResponseTimeMinutes,
      if (dailyActiveHours != null) #dailyActiveHours: dailyActiveHours,
      if (averageMessageLength != null)
        #averageMessageLength: averageMessageLength,
      if (emojiUsageRate != null) #emojiUsageRate: emojiUsageRate,
      if (questionAskerRate != null) #questionAskerRate: questionAskerRate,
      if (topicPreferences != null) #topicPreferences: topicPreferences,
    }),
  );
  @override
  UserBehaviorProfile $make(CopyWithData data) => UserBehaviorProfile(
    userId: data.get(#userId, or: $value.userId),
    responsePattern: data.get(#responsePattern, or: $value.responsePattern),
    activityPattern: data.get(#activityPattern, or: $value.activityPattern),
    engagementStyle: data.get(#engagementStyle, or: $value.engagementStyle),
    conversationStyle: data.get(
      #conversationStyle,
      or: $value.conversationStyle,
    ),
    averageResponseTimeMinutes: data.get(
      #averageResponseTimeMinutes,
      or: $value.averageResponseTimeMinutes,
    ),
    dailyActiveHours: data.get(#dailyActiveHours, or: $value.dailyActiveHours),
    averageMessageLength: data.get(
      #averageMessageLength,
      or: $value.averageMessageLength,
    ),
    emojiUsageRate: data.get(#emojiUsageRate, or: $value.emojiUsageRate),
    questionAskerRate: data.get(
      #questionAskerRate,
      or: $value.questionAskerRate,
    ),
    topicPreferences: data.get(#topicPreferences, or: $value.topicPreferences),
  );

  @override
  UserBehaviorProfileCopyWith<$R2, UserBehaviorProfile, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserBehaviorProfileCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BehaviorPatternMapper extends ClassMapperBase<BehaviorPattern> {
  BehaviorPatternMapper._();

  static BehaviorPatternMapper? _instance;
  static BehaviorPatternMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BehaviorPatternMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BehaviorPattern';

  static String _$patternId(BehaviorPattern v) => v.patternId;
  static const Field<BehaviorPattern, String> _f$patternId = Field(
    'patternId',
    _$patternId,
  );
  static String _$name(BehaviorPattern v) => v.name;
  static const Field<BehaviorPattern, String> _f$name = Field('name', _$name);
  static String _$description(BehaviorPattern v) => v.description;
  static const Field<BehaviorPattern, String> _f$description = Field(
    'description',
    _$description,
  );
  static PatternType _$type(BehaviorPattern v) => v.type;
  static const Field<BehaviorPattern, PatternType> _f$type = Field(
    'type',
    _$type,
  );
  static double _$strength(BehaviorPattern v) => v.strength;
  static const Field<BehaviorPattern, double> _f$strength = Field(
    'strength',
    _$strength,
  );

  @override
  final MappableFields<BehaviorPattern> fields = const {
    #patternId: _f$patternId,
    #name: _f$name,
    #description: _f$description,
    #type: _f$type,
    #strength: _f$strength,
  };

  static BehaviorPattern _instantiate(DecodingData data) {
    return BehaviorPattern(
      patternId: data.dec(_f$patternId),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      type: data.dec(_f$type),
      strength: data.dec(_f$strength),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BehaviorPattern fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BehaviorPattern>(map);
  }

  static BehaviorPattern fromJson(String json) {
    return ensureInitialized().decodeJson<BehaviorPattern>(json);
  }
}

mixin BehaviorPatternMappable {
  String toJson() {
    return BehaviorPatternMapper.ensureInitialized()
        .encodeJson<BehaviorPattern>(this as BehaviorPattern);
  }

  Map<String, dynamic> toMap() {
    return BehaviorPatternMapper.ensureInitialized().encodeMap<BehaviorPattern>(
      this as BehaviorPattern,
    );
  }

  BehaviorPatternCopyWith<BehaviorPattern, BehaviorPattern, BehaviorPattern>
  get copyWith =>
      _BehaviorPatternCopyWithImpl<BehaviorPattern, BehaviorPattern>(
        this as BehaviorPattern,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BehaviorPatternMapper.ensureInitialized().stringifyValue(
      this as BehaviorPattern,
    );
  }

  @override
  bool operator ==(Object other) {
    return BehaviorPatternMapper.ensureInitialized().equalsValue(
      this as BehaviorPattern,
      other,
    );
  }

  @override
  int get hashCode {
    return BehaviorPatternMapper.ensureInitialized().hashValue(
      this as BehaviorPattern,
    );
  }
}

extension BehaviorPatternValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BehaviorPattern, $Out> {
  BehaviorPatternCopyWith<$R, BehaviorPattern, $Out> get $asBehaviorPattern =>
      $base.as((v, t, t2) => _BehaviorPatternCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BehaviorPatternCopyWith<$R, $In extends BehaviorPattern, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? patternId,
    String? name,
    String? description,
    PatternType? type,
    double? strength,
  });
  BehaviorPatternCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BehaviorPatternCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BehaviorPattern, $Out>
    implements BehaviorPatternCopyWith<$R, BehaviorPattern, $Out> {
  _BehaviorPatternCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BehaviorPattern> $mapper =
      BehaviorPatternMapper.ensureInitialized();
  @override
  $R call({
    String? patternId,
    String? name,
    String? description,
    PatternType? type,
    double? strength,
  }) => $apply(
    FieldCopyWithData({
      if (patternId != null) #patternId: patternId,
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (type != null) #type: type,
      if (strength != null) #strength: strength,
    }),
  );
  @override
  BehaviorPattern $make(CopyWithData data) => BehaviorPattern(
    patternId: data.get(#patternId, or: $value.patternId),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    type: data.get(#type, or: $value.type),
    strength: data.get(#strength, or: $value.strength),
  );

  @override
  BehaviorPatternCopyWith<$R2, BehaviorPattern, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BehaviorPatternCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MLFeatureVectorMapper extends ClassMapperBase<MLFeatureVector> {
  MLFeatureVectorMapper._();

  static MLFeatureVectorMapper? _instance;
  static MLFeatureVectorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MLFeatureVectorMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MLFeatureVector';

  static String _$userId(MLFeatureVector v) => v.userId;
  static const Field<MLFeatureVector, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static List<double> _$features(MLFeatureVector v) => v.features;
  static const Field<MLFeatureVector, List<double>> _f$features = Field(
    'features',
    _$features,
  );
  static Map<String, dynamic> _$metadata(MLFeatureVector v) => v.metadata;
  static const Field<MLFeatureVector, Map<String, dynamic>> _f$metadata = Field(
    'metadata',
    _$metadata,
    opt: true,
    def: const {},
  );
  static DateTime _$generatedAt(MLFeatureVector v) => v.generatedAt;
  static const Field<MLFeatureVector, DateTime> _f$generatedAt = Field(
    'generatedAt',
    _$generatedAt,
  );

  @override
  final MappableFields<MLFeatureVector> fields = const {
    #userId: _f$userId,
    #features: _f$features,
    #metadata: _f$metadata,
    #generatedAt: _f$generatedAt,
  };

  static MLFeatureVector _instantiate(DecodingData data) {
    return MLFeatureVector(
      userId: data.dec(_f$userId),
      features: data.dec(_f$features),
      metadata: data.dec(_f$metadata),
      generatedAt: data.dec(_f$generatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MLFeatureVector fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MLFeatureVector>(map);
  }

  static MLFeatureVector fromJson(String json) {
    return ensureInitialized().decodeJson<MLFeatureVector>(json);
  }
}

mixin MLFeatureVectorMappable {
  String toJson() {
    return MLFeatureVectorMapper.ensureInitialized()
        .encodeJson<MLFeatureVector>(this as MLFeatureVector);
  }

  Map<String, dynamic> toMap() {
    return MLFeatureVectorMapper.ensureInitialized().encodeMap<MLFeatureVector>(
      this as MLFeatureVector,
    );
  }

  MLFeatureVectorCopyWith<MLFeatureVector, MLFeatureVector, MLFeatureVector>
  get copyWith =>
      _MLFeatureVectorCopyWithImpl<MLFeatureVector, MLFeatureVector>(
        this as MLFeatureVector,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MLFeatureVectorMapper.ensureInitialized().stringifyValue(
      this as MLFeatureVector,
    );
  }

  @override
  bool operator ==(Object other) {
    return MLFeatureVectorMapper.ensureInitialized().equalsValue(
      this as MLFeatureVector,
      other,
    );
  }

  @override
  int get hashCode {
    return MLFeatureVectorMapper.ensureInitialized().hashValue(
      this as MLFeatureVector,
    );
  }
}

extension MLFeatureVectorValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MLFeatureVector, $Out> {
  MLFeatureVectorCopyWith<$R, MLFeatureVector, $Out> get $asMLFeatureVector =>
      $base.as((v, t, t2) => _MLFeatureVectorCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MLFeatureVectorCopyWith<$R, $In extends MLFeatureVector, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get features;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata;
  $R call({
    String? userId,
    List<double>? features,
    Map<String, dynamic>? metadata,
    DateTime? generatedAt,
  });
  MLFeatureVectorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MLFeatureVectorCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MLFeatureVector, $Out>
    implements MLFeatureVectorCopyWith<$R, MLFeatureVector, $Out> {
  _MLFeatureVectorCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MLFeatureVector> $mapper =
      MLFeatureVectorMapper.ensureInitialized();
  @override
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get features =>
      ListCopyWith(
        $value.features,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(features: v),
      );
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata => MapCopyWith(
    $value.metadata,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(metadata: v),
  );
  @override
  $R call({
    String? userId,
    List<double>? features,
    Map<String, dynamic>? metadata,
    DateTime? generatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (features != null) #features: features,
      if (metadata != null) #metadata: metadata,
      if (generatedAt != null) #generatedAt: generatedAt,
    }),
  );
  @override
  MLFeatureVector $make(CopyWithData data) => MLFeatureVector(
    userId: data.get(#userId, or: $value.userId),
    features: data.get(#features, or: $value.features),
    metadata: data.get(#metadata, or: $value.metadata),
    generatedAt: data.get(#generatedAt, or: $value.generatedAt),
  );

  @override
  MLFeatureVectorCopyWith<$R2, MLFeatureVector, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MLFeatureVectorCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MatchingAlgorithmConfigMapper
    extends ClassMapperBase<MatchingAlgorithmConfig> {
  MatchingAlgorithmConfigMapper._();

  static MatchingAlgorithmConfigMapper? _instance;
  static MatchingAlgorithmConfigMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = MatchingAlgorithmConfigMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'MatchingAlgorithmConfig';

  static Map<CompatibilityFactor, double> _$factorWeights(
    MatchingAlgorithmConfig v,
  ) => v.factorWeights;
  static const Field<MatchingAlgorithmConfig, Map<CompatibilityFactor, double>>
  _f$factorWeights = Field('factorWeights', _$factorWeights);
  static double _$behavioralWeight(MatchingAlgorithmConfig v) =>
      v.behavioralWeight;
  static const Field<MatchingAlgorithmConfig, double> _f$behavioralWeight =
      Field('behavioralWeight', _$behavioralWeight, opt: true, def: 0.3);
  static bool _$enableMLPredictions(MatchingAlgorithmConfig v) =>
      v.enableMLPredictions;
  static const Field<MatchingAlgorithmConfig, bool> _f$enableMLPredictions =
      Field(
        'enableMLPredictions',
        _$enableMLPredictions,
        opt: true,
        def: false,
      );
  static double _$minScoreThreshold(MatchingAlgorithmConfig v) =>
      v.minScoreThreshold;
  static const Field<MatchingAlgorithmConfig, double> _f$minScoreThreshold =
      Field('minScoreThreshold', _$minScoreThreshold, opt: true, def: 30.0);
  static int _$maxDailyMatches(MatchingAlgorithmConfig v) => v.maxDailyMatches;
  static const Field<MatchingAlgorithmConfig, int> _f$maxDailyMatches = Field(
    'maxDailyMatches',
    _$maxDailyMatches,
    opt: true,
    def: 50,
  );

  @override
  final MappableFields<MatchingAlgorithmConfig> fields = const {
    #factorWeights: _f$factorWeights,
    #behavioralWeight: _f$behavioralWeight,
    #enableMLPredictions: _f$enableMLPredictions,
    #minScoreThreshold: _f$minScoreThreshold,
    #maxDailyMatches: _f$maxDailyMatches,
  };

  static MatchingAlgorithmConfig _instantiate(DecodingData data) {
    return MatchingAlgorithmConfig(
      factorWeights: data.dec(_f$factorWeights),
      behavioralWeight: data.dec(_f$behavioralWeight),
      enableMLPredictions: data.dec(_f$enableMLPredictions),
      minScoreThreshold: data.dec(_f$minScoreThreshold),
      maxDailyMatches: data.dec(_f$maxDailyMatches),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MatchingAlgorithmConfig fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchingAlgorithmConfig>(map);
  }

  static MatchingAlgorithmConfig fromJson(String json) {
    return ensureInitialized().decodeJson<MatchingAlgorithmConfig>(json);
  }
}

mixin MatchingAlgorithmConfigMappable {
  String toJson() {
    return MatchingAlgorithmConfigMapper.ensureInitialized()
        .encodeJson<MatchingAlgorithmConfig>(this as MatchingAlgorithmConfig);
  }

  Map<String, dynamic> toMap() {
    return MatchingAlgorithmConfigMapper.ensureInitialized()
        .encodeMap<MatchingAlgorithmConfig>(this as MatchingAlgorithmConfig);
  }

  MatchingAlgorithmConfigCopyWith<
    MatchingAlgorithmConfig,
    MatchingAlgorithmConfig,
    MatchingAlgorithmConfig
  >
  get copyWith =>
      _MatchingAlgorithmConfigCopyWithImpl<
        MatchingAlgorithmConfig,
        MatchingAlgorithmConfig
      >(this as MatchingAlgorithmConfig, $identity, $identity);
  @override
  String toString() {
    return MatchingAlgorithmConfigMapper.ensureInitialized().stringifyValue(
      this as MatchingAlgorithmConfig,
    );
  }

  @override
  bool operator ==(Object other) {
    return MatchingAlgorithmConfigMapper.ensureInitialized().equalsValue(
      this as MatchingAlgorithmConfig,
      other,
    );
  }

  @override
  int get hashCode {
    return MatchingAlgorithmConfigMapper.ensureInitialized().hashValue(
      this as MatchingAlgorithmConfig,
    );
  }
}

extension MatchingAlgorithmConfigValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchingAlgorithmConfig, $Out> {
  MatchingAlgorithmConfigCopyWith<$R, MatchingAlgorithmConfig, $Out>
  get $asMatchingAlgorithmConfig => $base.as(
    (v, t, t2) => _MatchingAlgorithmConfigCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class MatchingAlgorithmConfigCopyWith<
  $R,
  $In extends MatchingAlgorithmConfig,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    CompatibilityFactor,
    double,
    ObjectCopyWith<$R, double, double>
  >
  get factorWeights;
  $R call({
    Map<CompatibilityFactor, double>? factorWeights,
    double? behavioralWeight,
    bool? enableMLPredictions,
    double? minScoreThreshold,
    int? maxDailyMatches,
  });
  MatchingAlgorithmConfigCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MatchingAlgorithmConfigCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchingAlgorithmConfig, $Out>
    implements
        MatchingAlgorithmConfigCopyWith<$R, MatchingAlgorithmConfig, $Out> {
  _MatchingAlgorithmConfigCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchingAlgorithmConfig> $mapper =
      MatchingAlgorithmConfigMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    CompatibilityFactor,
    double,
    ObjectCopyWith<$R, double, double>
  >
  get factorWeights => MapCopyWith(
    $value.factorWeights,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(factorWeights: v),
  );
  @override
  $R call({
    Map<CompatibilityFactor, double>? factorWeights,
    double? behavioralWeight,
    bool? enableMLPredictions,
    double? minScoreThreshold,
    int? maxDailyMatches,
  }) => $apply(
    FieldCopyWithData({
      if (factorWeights != null) #factorWeights: factorWeights,
      if (behavioralWeight != null) #behavioralWeight: behavioralWeight,
      if (enableMLPredictions != null)
        #enableMLPredictions: enableMLPredictions,
      if (minScoreThreshold != null) #minScoreThreshold: minScoreThreshold,
      if (maxDailyMatches != null) #maxDailyMatches: maxDailyMatches,
    }),
  );
  @override
  MatchingAlgorithmConfig $make(CopyWithData data) => MatchingAlgorithmConfig(
    factorWeights: data.get(#factorWeights, or: $value.factorWeights),
    behavioralWeight: data.get(#behavioralWeight, or: $value.behavioralWeight),
    enableMLPredictions: data.get(
      #enableMLPredictions,
      or: $value.enableMLPredictions,
    ),
    minScoreThreshold: data.get(
      #minScoreThreshold,
      or: $value.minScoreThreshold,
    ),
    maxDailyMatches: data.get(#maxDailyMatches, or: $value.maxDailyMatches),
  );

  @override
  MatchingAlgorithmConfigCopyWith<$R2, MatchingAlgorithmConfig, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MatchingAlgorithmConfigCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MatchingStatsMapper extends ClassMapperBase<MatchingStats> {
  MatchingStatsMapper._();

  static MatchingStatsMapper? _instance;
  static MatchingStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchingStatsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MatchingStats';

  static int _$totalScoresCalculated(MatchingStats v) =>
      v.totalScoresCalculated;
  static const Field<MatchingStats, int> _f$totalScoresCalculated = Field(
    'totalScoresCalculated',
    _$totalScoresCalculated,
  );
  static double _$averageScore(MatchingStats v) => v.averageScore;
  static const Field<MatchingStats, double> _f$averageScore = Field(
    'averageScore',
    _$averageScore,
  );
  static int _$highCompatibilityCount(MatchingStats v) =>
      v.highCompatibilityCount;
  static const Field<MatchingStats, int> _f$highCompatibilityCount = Field(
    'highCompatibilityCount',
    _$highCompatibilityCount,
  );
  static Map<CompatibilityFactor, double> _$factorAverages(MatchingStats v) =>
      v.factorAverages;
  static const Field<MatchingStats, Map<CompatibilityFactor, double>>
  _f$factorAverages = Field('factorAverages', _$factorAverages);
  static DateTime _$periodStart(MatchingStats v) => v.periodStart;
  static const Field<MatchingStats, DateTime> _f$periodStart = Field(
    'periodStart',
    _$periodStart,
  );
  static DateTime _$periodEnd(MatchingStats v) => v.periodEnd;
  static const Field<MatchingStats, DateTime> _f$periodEnd = Field(
    'periodEnd',
    _$periodEnd,
  );

  @override
  final MappableFields<MatchingStats> fields = const {
    #totalScoresCalculated: _f$totalScoresCalculated,
    #averageScore: _f$averageScore,
    #highCompatibilityCount: _f$highCompatibilityCount,
    #factorAverages: _f$factorAverages,
    #periodStart: _f$periodStart,
    #periodEnd: _f$periodEnd,
  };

  static MatchingStats _instantiate(DecodingData data) {
    return MatchingStats(
      totalScoresCalculated: data.dec(_f$totalScoresCalculated),
      averageScore: data.dec(_f$averageScore),
      highCompatibilityCount: data.dec(_f$highCompatibilityCount),
      factorAverages: data.dec(_f$factorAverages),
      periodStart: data.dec(_f$periodStart),
      periodEnd: data.dec(_f$periodEnd),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MatchingStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchingStats>(map);
  }

  static MatchingStats fromJson(String json) {
    return ensureInitialized().decodeJson<MatchingStats>(json);
  }
}

mixin MatchingStatsMappable {
  String toJson() {
    return MatchingStatsMapper.ensureInitialized().encodeJson<MatchingStats>(
      this as MatchingStats,
    );
  }

  Map<String, dynamic> toMap() {
    return MatchingStatsMapper.ensureInitialized().encodeMap<MatchingStats>(
      this as MatchingStats,
    );
  }

  MatchingStatsCopyWith<MatchingStats, MatchingStats, MatchingStats>
  get copyWith => _MatchingStatsCopyWithImpl<MatchingStats, MatchingStats>(
    this as MatchingStats,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MatchingStatsMapper.ensureInitialized().stringifyValue(
      this as MatchingStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return MatchingStatsMapper.ensureInitialized().equalsValue(
      this as MatchingStats,
      other,
    );
  }

  @override
  int get hashCode {
    return MatchingStatsMapper.ensureInitialized().hashValue(
      this as MatchingStats,
    );
  }
}

extension MatchingStatsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchingStats, $Out> {
  MatchingStatsCopyWith<$R, MatchingStats, $Out> get $asMatchingStats =>
      $base.as((v, t, t2) => _MatchingStatsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchingStatsCopyWith<$R, $In extends MatchingStats, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    CompatibilityFactor,
    double,
    ObjectCopyWith<$R, double, double>
  >
  get factorAverages;
  $R call({
    int? totalScoresCalculated,
    double? averageScore,
    int? highCompatibilityCount,
    Map<CompatibilityFactor, double>? factorAverages,
    DateTime? periodStart,
    DateTime? periodEnd,
  });
  MatchingStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MatchingStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchingStats, $Out>
    implements MatchingStatsCopyWith<$R, MatchingStats, $Out> {
  _MatchingStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchingStats> $mapper =
      MatchingStatsMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    CompatibilityFactor,
    double,
    ObjectCopyWith<$R, double, double>
  >
  get factorAverages => MapCopyWith(
    $value.factorAverages,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(factorAverages: v),
  );
  @override
  $R call({
    int? totalScoresCalculated,
    double? averageScore,
    int? highCompatibilityCount,
    Map<CompatibilityFactor, double>? factorAverages,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) => $apply(
    FieldCopyWithData({
      if (totalScoresCalculated != null)
        #totalScoresCalculated: totalScoresCalculated,
      if (averageScore != null) #averageScore: averageScore,
      if (highCompatibilityCount != null)
        #highCompatibilityCount: highCompatibilityCount,
      if (factorAverages != null) #factorAverages: factorAverages,
      if (periodStart != null) #periodStart: periodStart,
      if (periodEnd != null) #periodEnd: periodEnd,
    }),
  );
  @override
  MatchingStats $make(CopyWithData data) => MatchingStats(
    totalScoresCalculated: data.get(
      #totalScoresCalculated,
      or: $value.totalScoresCalculated,
    ),
    averageScore: data.get(#averageScore, or: $value.averageScore),
    highCompatibilityCount: data.get(
      #highCompatibilityCount,
      or: $value.highCompatibilityCount,
    ),
    factorAverages: data.get(#factorAverages, or: $value.factorAverages),
    periodStart: data.get(#periodStart, or: $value.periodStart),
    periodEnd: data.get(#periodEnd, or: $value.periodEnd),
  );

  @override
  MatchingStatsCopyWith<$R2, MatchingStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MatchingStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

