// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'compatibility_quiz.dart';

class CompatibilityQuizMapper extends ClassMapperBase<CompatibilityQuiz> {
  CompatibilityQuizMapper._();

  static CompatibilityQuizMapper? _instance;
  static CompatibilityQuizMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CompatibilityQuizMapper._());
      QuizQuestionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CompatibilityQuiz';

  static String _$quizId(CompatibilityQuiz v) => v.quizId;
  static const Field<CompatibilityQuiz, String> _f$quizId = Field(
    'quizId',
    _$quizId,
  );
  static String _$title(CompatibilityQuiz v) => v.title;
  static const Field<CompatibilityQuiz, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$description(CompatibilityQuiz v) => v.description;
  static const Field<CompatibilityQuiz, String> _f$description = Field(
    'description',
    _$description,
  );
  static QuizCategory _$category(CompatibilityQuiz v) => v.category;
  static const Field<CompatibilityQuiz, QuizCategory> _f$category = Field(
    'category',
    _$category,
  );
  static List<QuizQuestion> _$questions(CompatibilityQuiz v) => v.questions;
  static const Field<CompatibilityQuiz, List<QuizQuestion>> _f$questions =
      Field('questions', _$questions);
  static int _$estimatedMinutes(CompatibilityQuiz v) => v.estimatedMinutes;
  static const Field<CompatibilityQuiz, int> _f$estimatedMinutes = Field(
    'estimatedMinutes',
    _$estimatedMinutes,
  );
  static bool _$isActive(CompatibilityQuiz v) => v.isActive;
  static const Field<CompatibilityQuiz, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    opt: true,
    def: true,
  );
  static DateTime _$createdAt(CompatibilityQuiz v) => v.createdAt;
  static const Field<CompatibilityQuiz, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime? _$updatedAt(CompatibilityQuiz v) => v.updatedAt;
  static const Field<CompatibilityQuiz, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
  );

  @override
  final MappableFields<CompatibilityQuiz> fields = const {
    #quizId: _f$quizId,
    #title: _f$title,
    #description: _f$description,
    #category: _f$category,
    #questions: _f$questions,
    #estimatedMinutes: _f$estimatedMinutes,
    #isActive: _f$isActive,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static CompatibilityQuiz _instantiate(DecodingData data) {
    return CompatibilityQuiz(
      quizId: data.dec(_f$quizId),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      category: data.dec(_f$category),
      questions: data.dec(_f$questions),
      estimatedMinutes: data.dec(_f$estimatedMinutes),
      isActive: data.dec(_f$isActive),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CompatibilityQuiz fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CompatibilityQuiz>(map);
  }

  static CompatibilityQuiz fromJson(String json) {
    return ensureInitialized().decodeJson<CompatibilityQuiz>(json);
  }
}

mixin CompatibilityQuizMappable {
  String toJson() {
    return CompatibilityQuizMapper.ensureInitialized()
        .encodeJson<CompatibilityQuiz>(this as CompatibilityQuiz);
  }

  Map<String, dynamic> toMap() {
    return CompatibilityQuizMapper.ensureInitialized()
        .encodeMap<CompatibilityQuiz>(this as CompatibilityQuiz);
  }

  CompatibilityQuizCopyWith<
    CompatibilityQuiz,
    CompatibilityQuiz,
    CompatibilityQuiz
  >
  get copyWith =>
      _CompatibilityQuizCopyWithImpl<CompatibilityQuiz, CompatibilityQuiz>(
        this as CompatibilityQuiz,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CompatibilityQuizMapper.ensureInitialized().stringifyValue(
      this as CompatibilityQuiz,
    );
  }

  @override
  bool operator ==(Object other) {
    return CompatibilityQuizMapper.ensureInitialized().equalsValue(
      this as CompatibilityQuiz,
      other,
    );
  }

  @override
  int get hashCode {
    return CompatibilityQuizMapper.ensureInitialized().hashValue(
      this as CompatibilityQuiz,
    );
  }
}

extension CompatibilityQuizValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CompatibilityQuiz, $Out> {
  CompatibilityQuizCopyWith<$R, CompatibilityQuiz, $Out>
  get $asCompatibilityQuiz => $base.as(
    (v, t, t2) => _CompatibilityQuizCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CompatibilityQuizCopyWith<
  $R,
  $In extends CompatibilityQuiz,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    QuizQuestion,
    QuizQuestionCopyWith<$R, QuizQuestion, QuizQuestion>
  >
  get questions;
  $R call({
    String? quizId,
    String? title,
    String? description,
    QuizCategory? category,
    List<QuizQuestion>? questions,
    int? estimatedMinutes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  CompatibilityQuizCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CompatibilityQuizCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CompatibilityQuiz, $Out>
    implements CompatibilityQuizCopyWith<$R, CompatibilityQuiz, $Out> {
  _CompatibilityQuizCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CompatibilityQuiz> $mapper =
      CompatibilityQuizMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    QuizQuestion,
    QuizQuestionCopyWith<$R, QuizQuestion, QuizQuestion>
  >
  get questions => ListCopyWith(
    $value.questions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(questions: v),
  );
  @override
  $R call({
    String? quizId,
    String? title,
    String? description,
    QuizCategory? category,
    List<QuizQuestion>? questions,
    int? estimatedMinutes,
    bool? isActive,
    DateTime? createdAt,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (quizId != null) #quizId: quizId,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (category != null) #category: category,
      if (questions != null) #questions: questions,
      if (estimatedMinutes != null) #estimatedMinutes: estimatedMinutes,
      if (isActive != null) #isActive: isActive,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  CompatibilityQuiz $make(CopyWithData data) => CompatibilityQuiz(
    quizId: data.get(#quizId, or: $value.quizId),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    category: data.get(#category, or: $value.category),
    questions: data.get(#questions, or: $value.questions),
    estimatedMinutes: data.get(#estimatedMinutes, or: $value.estimatedMinutes),
    isActive: data.get(#isActive, or: $value.isActive),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  CompatibilityQuizCopyWith<$R2, CompatibilityQuiz, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CompatibilityQuizCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class QuizQuestionMapper extends ClassMapperBase<QuizQuestion> {
  QuizQuestionMapper._();

  static QuizQuestionMapper? _instance;
  static QuizQuestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuizQuestionMapper._());
      QuizOptionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'QuizQuestion';

  static String _$questionId(QuizQuestion v) => v.questionId;
  static const Field<QuizQuestion, String> _f$questionId = Field(
    'questionId',
    _$questionId,
  );
  static String _$text(QuizQuestion v) => v.text;
  static const Field<QuizQuestion, String> _f$text = Field('text', _$text);
  static QuestionType _$type(QuizQuestion v) => v.type;
  static const Field<QuizQuestion, QuestionType> _f$type = Field(
    'type',
    _$type,
  );
  static List<QuizOption> _$options(QuizQuestion v) => v.options;
  static const Field<QuizQuestion, List<QuizOption>> _f$options = Field(
    'options',
    _$options,
  );
  static bool _$isRequired(QuizQuestion v) => v.isRequired;
  static const Field<QuizQuestion, bool> _f$isRequired = Field(
    'isRequired',
    _$isRequired,
    opt: true,
    def: true,
  );
  static int _$weight(QuizQuestion v) => v.weight;
  static const Field<QuizQuestion, int> _f$weight = Field(
    'weight',
    _$weight,
    opt: true,
    def: 5,
  );
  static String? _$explanation(QuizQuestion v) => v.explanation;
  static const Field<QuizQuestion, String> _f$explanation = Field(
    'explanation',
    _$explanation,
    opt: true,
  );

  @override
  final MappableFields<QuizQuestion> fields = const {
    #questionId: _f$questionId,
    #text: _f$text,
    #type: _f$type,
    #options: _f$options,
    #isRequired: _f$isRequired,
    #weight: _f$weight,
    #explanation: _f$explanation,
  };

  static QuizQuestion _instantiate(DecodingData data) {
    return QuizQuestion(
      questionId: data.dec(_f$questionId),
      text: data.dec(_f$text),
      type: data.dec(_f$type),
      options: data.dec(_f$options),
      isRequired: data.dec(_f$isRequired),
      weight: data.dec(_f$weight),
      explanation: data.dec(_f$explanation),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuizQuestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuizQuestion>(map);
  }

  static QuizQuestion fromJson(String json) {
    return ensureInitialized().decodeJson<QuizQuestion>(json);
  }
}

mixin QuizQuestionMappable {
  String toJson() {
    return QuizQuestionMapper.ensureInitialized().encodeJson<QuizQuestion>(
      this as QuizQuestion,
    );
  }

  Map<String, dynamic> toMap() {
    return QuizQuestionMapper.ensureInitialized().encodeMap<QuizQuestion>(
      this as QuizQuestion,
    );
  }

  QuizQuestionCopyWith<QuizQuestion, QuizQuestion, QuizQuestion> get copyWith =>
      _QuizQuestionCopyWithImpl<QuizQuestion, QuizQuestion>(
        this as QuizQuestion,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QuizQuestionMapper.ensureInitialized().stringifyValue(
      this as QuizQuestion,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuizQuestionMapper.ensureInitialized().equalsValue(
      this as QuizQuestion,
      other,
    );
  }

  @override
  int get hashCode {
    return QuizQuestionMapper.ensureInitialized().hashValue(
      this as QuizQuestion,
    );
  }
}

extension QuizQuestionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuizQuestion, $Out> {
  QuizQuestionCopyWith<$R, QuizQuestion, $Out> get $asQuizQuestion =>
      $base.as((v, t, t2) => _QuizQuestionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuizQuestionCopyWith<$R, $In extends QuizQuestion, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, QuizOption, QuizOptionCopyWith<$R, QuizOption, QuizOption>>
  get options;
  $R call({
    String? questionId,
    String? text,
    QuestionType? type,
    List<QuizOption>? options,
    bool? isRequired,
    int? weight,
    String? explanation,
  });
  QuizQuestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuizQuestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuizQuestion, $Out>
    implements QuizQuestionCopyWith<$R, QuizQuestion, $Out> {
  _QuizQuestionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuizQuestion> $mapper =
      QuizQuestionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, QuizOption, QuizOptionCopyWith<$R, QuizOption, QuizOption>>
  get options => ListCopyWith(
    $value.options,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(options: v),
  );
  @override
  $R call({
    String? questionId,
    String? text,
    QuestionType? type,
    List<QuizOption>? options,
    bool? isRequired,
    int? weight,
    Object? explanation = $none,
  }) => $apply(
    FieldCopyWithData({
      if (questionId != null) #questionId: questionId,
      if (text != null) #text: text,
      if (type != null) #type: type,
      if (options != null) #options: options,
      if (isRequired != null) #isRequired: isRequired,
      if (weight != null) #weight: weight,
      if (explanation != $none) #explanation: explanation,
    }),
  );
  @override
  QuizQuestion $make(CopyWithData data) => QuizQuestion(
    questionId: data.get(#questionId, or: $value.questionId),
    text: data.get(#text, or: $value.text),
    type: data.get(#type, or: $value.type),
    options: data.get(#options, or: $value.options),
    isRequired: data.get(#isRequired, or: $value.isRequired),
    weight: data.get(#weight, or: $value.weight),
    explanation: data.get(#explanation, or: $value.explanation),
  );

  @override
  QuizQuestionCopyWith<$R2, QuizQuestion, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuizQuestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class QuizOptionMapper extends ClassMapperBase<QuizOption> {
  QuizOptionMapper._();

  static QuizOptionMapper? _instance;
  static QuizOptionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuizOptionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'QuizOption';

  static String _$optionId(QuizOption v) => v.optionId;
  static const Field<QuizOption, String> _f$optionId = Field(
    'optionId',
    _$optionId,
  );
  static String _$text(QuizOption v) => v.text;
  static const Field<QuizOption, String> _f$text = Field('text', _$text);
  static int _$value(QuizOption v) => v.value;
  static const Field<QuizOption, int> _f$value = Field('value', _$value);
  static String? _$description(QuizOption v) => v.description;
  static const Field<QuizOption, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );

  @override
  final MappableFields<QuizOption> fields = const {
    #optionId: _f$optionId,
    #text: _f$text,
    #value: _f$value,
    #description: _f$description,
  };

  static QuizOption _instantiate(DecodingData data) {
    return QuizOption(
      optionId: data.dec(_f$optionId),
      text: data.dec(_f$text),
      value: data.dec(_f$value),
      description: data.dec(_f$description),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuizOption fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuizOption>(map);
  }

  static QuizOption fromJson(String json) {
    return ensureInitialized().decodeJson<QuizOption>(json);
  }
}

mixin QuizOptionMappable {
  String toJson() {
    return QuizOptionMapper.ensureInitialized().encodeJson<QuizOption>(
      this as QuizOption,
    );
  }

  Map<String, dynamic> toMap() {
    return QuizOptionMapper.ensureInitialized().encodeMap<QuizOption>(
      this as QuizOption,
    );
  }

  QuizOptionCopyWith<QuizOption, QuizOption, QuizOption> get copyWith =>
      _QuizOptionCopyWithImpl<QuizOption, QuizOption>(
        this as QuizOption,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QuizOptionMapper.ensureInitialized().stringifyValue(
      this as QuizOption,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuizOptionMapper.ensureInitialized().equalsValue(
      this as QuizOption,
      other,
    );
  }

  @override
  int get hashCode {
    return QuizOptionMapper.ensureInitialized().hashValue(this as QuizOption);
  }
}

extension QuizOptionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuizOption, $Out> {
  QuizOptionCopyWith<$R, QuizOption, $Out> get $asQuizOption =>
      $base.as((v, t, t2) => _QuizOptionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuizOptionCopyWith<$R, $In extends QuizOption, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? optionId, String? text, int? value, String? description});
  QuizOptionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuizOptionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuizOption, $Out>
    implements QuizOptionCopyWith<$R, QuizOption, $Out> {
  _QuizOptionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuizOption> $mapper =
      QuizOptionMapper.ensureInitialized();
  @override
  $R call({
    String? optionId,
    String? text,
    int? value,
    Object? description = $none,
  }) => $apply(
    FieldCopyWithData({
      if (optionId != null) #optionId: optionId,
      if (text != null) #text: text,
      if (value != null) #value: value,
      if (description != $none) #description: description,
    }),
  );
  @override
  QuizOption $make(CopyWithData data) => QuizOption(
    optionId: data.get(#optionId, or: $value.optionId),
    text: data.get(#text, or: $value.text),
    value: data.get(#value, or: $value.value),
    description: data.get(#description, or: $value.description),
  );

  @override
  QuizOptionCopyWith<$R2, QuizOption, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuizOptionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class QuizResponseMapper extends ClassMapperBase<QuizResponse> {
  QuizResponseMapper._();

  static QuizResponseMapper? _instance;
  static QuizResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuizResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'QuizResponse';

  static String _$responseId(QuizResponse v) => v.responseId;
  static const Field<QuizResponse, String> _f$responseId = Field(
    'responseId',
    _$responseId,
  );
  static String _$userId(QuizResponse v) => v.userId;
  static const Field<QuizResponse, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$quizId(QuizResponse v) => v.quizId;
  static const Field<QuizResponse, String> _f$quizId = Field(
    'quizId',
    _$quizId,
  );
  static Map<String, dynamic> _$answers(QuizResponse v) => v.answers;
  static const Field<QuizResponse, Map<String, dynamic>> _f$answers = Field(
    'answers',
    _$answers,
  );
  static DateTime _$startedAt(QuizResponse v) => v.startedAt;
  static const Field<QuizResponse, DateTime> _f$startedAt = Field(
    'startedAt',
    _$startedAt,
  );
  static DateTime? _$completedAt(QuizResponse v) => v.completedAt;
  static const Field<QuizResponse, DateTime> _f$completedAt = Field(
    'completedAt',
    _$completedAt,
    opt: true,
  );
  static bool _$isComplete(QuizResponse v) => v.isComplete;
  static const Field<QuizResponse, bool> _f$isComplete = Field(
    'isComplete',
    _$isComplete,
    opt: true,
    def: false,
  );
  static int _$timeSpentSeconds(QuizResponse v) => v.timeSpentSeconds;
  static const Field<QuizResponse, int> _f$timeSpentSeconds = Field(
    'timeSpentSeconds',
    _$timeSpentSeconds,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<QuizResponse> fields = const {
    #responseId: _f$responseId,
    #userId: _f$userId,
    #quizId: _f$quizId,
    #answers: _f$answers,
    #startedAt: _f$startedAt,
    #completedAt: _f$completedAt,
    #isComplete: _f$isComplete,
    #timeSpentSeconds: _f$timeSpentSeconds,
  };

  static QuizResponse _instantiate(DecodingData data) {
    return QuizResponse(
      responseId: data.dec(_f$responseId),
      userId: data.dec(_f$userId),
      quizId: data.dec(_f$quizId),
      answers: data.dec(_f$answers),
      startedAt: data.dec(_f$startedAt),
      completedAt: data.dec(_f$completedAt),
      isComplete: data.dec(_f$isComplete),
      timeSpentSeconds: data.dec(_f$timeSpentSeconds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuizResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuizResponse>(map);
  }

  static QuizResponse fromJson(String json) {
    return ensureInitialized().decodeJson<QuizResponse>(json);
  }
}

mixin QuizResponseMappable {
  String toJson() {
    return QuizResponseMapper.ensureInitialized().encodeJson<QuizResponse>(
      this as QuizResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return QuizResponseMapper.ensureInitialized().encodeMap<QuizResponse>(
      this as QuizResponse,
    );
  }

  QuizResponseCopyWith<QuizResponse, QuizResponse, QuizResponse> get copyWith =>
      _QuizResponseCopyWithImpl<QuizResponse, QuizResponse>(
        this as QuizResponse,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QuizResponseMapper.ensureInitialized().stringifyValue(
      this as QuizResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuizResponseMapper.ensureInitialized().equalsValue(
      this as QuizResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return QuizResponseMapper.ensureInitialized().hashValue(
      this as QuizResponse,
    );
  }
}

extension QuizResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuizResponse, $Out> {
  QuizResponseCopyWith<$R, QuizResponse, $Out> get $asQuizResponse =>
      $base.as((v, t, t2) => _QuizResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuizResponseCopyWith<$R, $In extends QuizResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get answers;
  $R call({
    String? responseId,
    String? userId,
    String? quizId,
    Map<String, dynamic>? answers,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isComplete,
    int? timeSpentSeconds,
  });
  QuizResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuizResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuizResponse, $Out>
    implements QuizResponseCopyWith<$R, QuizResponse, $Out> {
  _QuizResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuizResponse> $mapper =
      QuizResponseMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get answers => MapCopyWith(
    $value.answers,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(answers: v),
  );
  @override
  $R call({
    String? responseId,
    String? userId,
    String? quizId,
    Map<String, dynamic>? answers,
    DateTime? startedAt,
    Object? completedAt = $none,
    bool? isComplete,
    int? timeSpentSeconds,
  }) => $apply(
    FieldCopyWithData({
      if (responseId != null) #responseId: responseId,
      if (userId != null) #userId: userId,
      if (quizId != null) #quizId: quizId,
      if (answers != null) #answers: answers,
      if (startedAt != null) #startedAt: startedAt,
      if (completedAt != $none) #completedAt: completedAt,
      if (isComplete != null) #isComplete: isComplete,
      if (timeSpentSeconds != null) #timeSpentSeconds: timeSpentSeconds,
    }),
  );
  @override
  QuizResponse $make(CopyWithData data) => QuizResponse(
    responseId: data.get(#responseId, or: $value.responseId),
    userId: data.get(#userId, or: $value.userId),
    quizId: data.get(#quizId, or: $value.quizId),
    answers: data.get(#answers, or: $value.answers),
    startedAt: data.get(#startedAt, or: $value.startedAt),
    completedAt: data.get(#completedAt, or: $value.completedAt),
    isComplete: data.get(#isComplete, or: $value.isComplete),
    timeSpentSeconds: data.get(#timeSpentSeconds, or: $value.timeSpentSeconds),
  );

  @override
  QuizResponseCopyWith<$R2, QuizResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuizResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class QuizResultMapper extends ClassMapperBase<QuizResult> {
  QuizResultMapper._();

  static QuizResultMapper? _instance;
  static QuizResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuizResultMapper._());
      PersonalityProfileMapper.ensureInitialized();
      QuizInsightMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'QuizResult';

  static String _$resultId(QuizResult v) => v.resultId;
  static const Field<QuizResult, String> _f$resultId = Field(
    'resultId',
    _$resultId,
  );
  static String _$userId(QuizResult v) => v.userId;
  static const Field<QuizResult, String> _f$userId = Field('userId', _$userId);
  static String _$quizId(QuizResult v) => v.quizId;
  static const Field<QuizResult, String> _f$quizId = Field('quizId', _$quizId);
  static Map<QuizCategory, double> _$categoryScores(QuizResult v) =>
      v.categoryScores;
  static const Field<QuizResult, Map<QuizCategory, double>> _f$categoryScores =
      Field('categoryScores', _$categoryScores);
  static PersonalityProfile? _$personalityProfile(QuizResult v) =>
      v.personalityProfile;
  static const Field<QuizResult, PersonalityProfile> _f$personalityProfile =
      Field('personalityProfile', _$personalityProfile, opt: true);
  static List<QuizInsight> _$insights(QuizResult v) => v.insights;
  static const Field<QuizResult, List<QuizInsight>> _f$insights = Field(
    'insights',
    _$insights,
  );
  static DateTime _$generatedAt(QuizResult v) => v.generatedAt;
  static const Field<QuizResult, DateTime> _f$generatedAt = Field(
    'generatedAt',
    _$generatedAt,
  );

  @override
  final MappableFields<QuizResult> fields = const {
    #resultId: _f$resultId,
    #userId: _f$userId,
    #quizId: _f$quizId,
    #categoryScores: _f$categoryScores,
    #personalityProfile: _f$personalityProfile,
    #insights: _f$insights,
    #generatedAt: _f$generatedAt,
  };

  static QuizResult _instantiate(DecodingData data) {
    return QuizResult(
      resultId: data.dec(_f$resultId),
      userId: data.dec(_f$userId),
      quizId: data.dec(_f$quizId),
      categoryScores: data.dec(_f$categoryScores),
      personalityProfile: data.dec(_f$personalityProfile),
      insights: data.dec(_f$insights),
      generatedAt: data.dec(_f$generatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuizResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuizResult>(map);
  }

  static QuizResult fromJson(String json) {
    return ensureInitialized().decodeJson<QuizResult>(json);
  }
}

mixin QuizResultMappable {
  String toJson() {
    return QuizResultMapper.ensureInitialized().encodeJson<QuizResult>(
      this as QuizResult,
    );
  }

  Map<String, dynamic> toMap() {
    return QuizResultMapper.ensureInitialized().encodeMap<QuizResult>(
      this as QuizResult,
    );
  }

  QuizResultCopyWith<QuizResult, QuizResult, QuizResult> get copyWith =>
      _QuizResultCopyWithImpl<QuizResult, QuizResult>(
        this as QuizResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QuizResultMapper.ensureInitialized().stringifyValue(
      this as QuizResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuizResultMapper.ensureInitialized().equalsValue(
      this as QuizResult,
      other,
    );
  }

  @override
  int get hashCode {
    return QuizResultMapper.ensureInitialized().hashValue(this as QuizResult);
  }
}

extension QuizResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuizResult, $Out> {
  QuizResultCopyWith<$R, QuizResult, $Out> get $asQuizResult =>
      $base.as((v, t, t2) => _QuizResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuizResultCopyWith<$R, $In extends QuizResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, QuizCategory, double, ObjectCopyWith<$R, double, double>>
  get categoryScores;
  PersonalityProfileCopyWith<$R, PersonalityProfile, PersonalityProfile>?
  get personalityProfile;
  ListCopyWith<
    $R,
    QuizInsight,
    QuizInsightCopyWith<$R, QuizInsight, QuizInsight>
  >
  get insights;
  $R call({
    String? resultId,
    String? userId,
    String? quizId,
    Map<QuizCategory, double>? categoryScores,
    PersonalityProfile? personalityProfile,
    List<QuizInsight>? insights,
    DateTime? generatedAt,
  });
  QuizResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuizResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuizResult, $Out>
    implements QuizResultCopyWith<$R, QuizResult, $Out> {
  _QuizResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuizResult> $mapper =
      QuizResultMapper.ensureInitialized();
  @override
  MapCopyWith<$R, QuizCategory, double, ObjectCopyWith<$R, double, double>>
  get categoryScores => MapCopyWith(
    $value.categoryScores,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryScores: v),
  );
  @override
  PersonalityProfileCopyWith<$R, PersonalityProfile, PersonalityProfile>?
  get personalityProfile => $value.personalityProfile?.copyWith.$chain(
    (v) => call(personalityProfile: v),
  );
  @override
  ListCopyWith<
    $R,
    QuizInsight,
    QuizInsightCopyWith<$R, QuizInsight, QuizInsight>
  >
  get insights => ListCopyWith(
    $value.insights,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(insights: v),
  );
  @override
  $R call({
    String? resultId,
    String? userId,
    String? quizId,
    Map<QuizCategory, double>? categoryScores,
    Object? personalityProfile = $none,
    List<QuizInsight>? insights,
    DateTime? generatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (resultId != null) #resultId: resultId,
      if (userId != null) #userId: userId,
      if (quizId != null) #quizId: quizId,
      if (categoryScores != null) #categoryScores: categoryScores,
      if (personalityProfile != $none) #personalityProfile: personalityProfile,
      if (insights != null) #insights: insights,
      if (generatedAt != null) #generatedAt: generatedAt,
    }),
  );
  @override
  QuizResult $make(CopyWithData data) => QuizResult(
    resultId: data.get(#resultId, or: $value.resultId),
    userId: data.get(#userId, or: $value.userId),
    quizId: data.get(#quizId, or: $value.quizId),
    categoryScores: data.get(#categoryScores, or: $value.categoryScores),
    personalityProfile: data.get(
      #personalityProfile,
      or: $value.personalityProfile,
    ),
    insights: data.get(#insights, or: $value.insights),
    generatedAt: data.get(#generatedAt, or: $value.generatedAt),
  );

  @override
  QuizResultCopyWith<$R2, QuizResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuizResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PersonalityProfileMapper extends ClassMapperBase<PersonalityProfile> {
  PersonalityProfileMapper._();

  static PersonalityProfileMapper? _instance;
  static PersonalityProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PersonalityProfileMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PersonalityProfile';

  static String _$profileId(PersonalityProfile v) => v.profileId;
  static const Field<PersonalityProfile, String> _f$profileId = Field(
    'profileId',
    _$profileId,
  );
  static String _$userId(PersonalityProfile v) => v.userId;
  static const Field<PersonalityProfile, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static PersonalityType _$type(PersonalityProfile v) => v.type;
  static const Field<PersonalityProfile, PersonalityType> _f$type = Field(
    'type',
    _$type,
  );
  static Map<PersonalityTrait, int> _$traits(PersonalityProfile v) => v.traits;
  static const Field<PersonalityProfile, Map<PersonalityTrait, int>> _f$traits =
      Field('traits', _$traits);
  static String _$description(PersonalityProfile v) => v.description;
  static const Field<PersonalityProfile, String> _f$description = Field(
    'description',
    _$description,
  );
  static List<String> _$strengths(PersonalityProfile v) => v.strengths;
  static const Field<PersonalityProfile, List<String>> _f$strengths = Field(
    'strengths',
    _$strengths,
  );
  static List<String> _$weaknesses(PersonalityProfile v) => v.weaknesses;
  static const Field<PersonalityProfile, List<String>> _f$weaknesses = Field(
    'weaknesses',
    _$weaknesses,
  );
  static List<PersonalityType> _$compatibleTypes(PersonalityProfile v) =>
      v.compatibleTypes;
  static const Field<PersonalityProfile, List<PersonalityType>>
  _f$compatibleTypes = Field('compatibleTypes', _$compatibleTypes);
  static DateTime _$generatedAt(PersonalityProfile v) => v.generatedAt;
  static const Field<PersonalityProfile, DateTime> _f$generatedAt = Field(
    'generatedAt',
    _$generatedAt,
  );

  @override
  final MappableFields<PersonalityProfile> fields = const {
    #profileId: _f$profileId,
    #userId: _f$userId,
    #type: _f$type,
    #traits: _f$traits,
    #description: _f$description,
    #strengths: _f$strengths,
    #weaknesses: _f$weaknesses,
    #compatibleTypes: _f$compatibleTypes,
    #generatedAt: _f$generatedAt,
  };

  static PersonalityProfile _instantiate(DecodingData data) {
    return PersonalityProfile(
      profileId: data.dec(_f$profileId),
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      traits: data.dec(_f$traits),
      description: data.dec(_f$description),
      strengths: data.dec(_f$strengths),
      weaknesses: data.dec(_f$weaknesses),
      compatibleTypes: data.dec(_f$compatibleTypes),
      generatedAt: data.dec(_f$generatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PersonalityProfile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PersonalityProfile>(map);
  }

  static PersonalityProfile fromJson(String json) {
    return ensureInitialized().decodeJson<PersonalityProfile>(json);
  }
}

mixin PersonalityProfileMappable {
  String toJson() {
    return PersonalityProfileMapper.ensureInitialized()
        .encodeJson<PersonalityProfile>(this as PersonalityProfile);
  }

  Map<String, dynamic> toMap() {
    return PersonalityProfileMapper.ensureInitialized()
        .encodeMap<PersonalityProfile>(this as PersonalityProfile);
  }

  PersonalityProfileCopyWith<
    PersonalityProfile,
    PersonalityProfile,
    PersonalityProfile
  >
  get copyWith =>
      _PersonalityProfileCopyWithImpl<PersonalityProfile, PersonalityProfile>(
        this as PersonalityProfile,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PersonalityProfileMapper.ensureInitialized().stringifyValue(
      this as PersonalityProfile,
    );
  }

  @override
  bool operator ==(Object other) {
    return PersonalityProfileMapper.ensureInitialized().equalsValue(
      this as PersonalityProfile,
      other,
    );
  }

  @override
  int get hashCode {
    return PersonalityProfileMapper.ensureInitialized().hashValue(
      this as PersonalityProfile,
    );
  }
}

extension PersonalityProfileValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PersonalityProfile, $Out> {
  PersonalityProfileCopyWith<$R, PersonalityProfile, $Out>
  get $asPersonalityProfile => $base.as(
    (v, t, t2) => _PersonalityProfileCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PersonalityProfileCopyWith<
  $R,
  $In extends PersonalityProfile,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, PersonalityTrait, int, ObjectCopyWith<$R, int, int>>
  get traits;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get strengths;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get weaknesses;
  ListCopyWith<
    $R,
    PersonalityType,
    ObjectCopyWith<$R, PersonalityType, PersonalityType>
  >
  get compatibleTypes;
  $R call({
    String? profileId,
    String? userId,
    PersonalityType? type,
    Map<PersonalityTrait, int>? traits,
    String? description,
    List<String>? strengths,
    List<String>? weaknesses,
    List<PersonalityType>? compatibleTypes,
    DateTime? generatedAt,
  });
  PersonalityProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PersonalityProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PersonalityProfile, $Out>
    implements PersonalityProfileCopyWith<$R, PersonalityProfile, $Out> {
  _PersonalityProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PersonalityProfile> $mapper =
      PersonalityProfileMapper.ensureInitialized();
  @override
  MapCopyWith<$R, PersonalityTrait, int, ObjectCopyWith<$R, int, int>>
  get traits => MapCopyWith(
    $value.traits,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(traits: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get strengths =>
      ListCopyWith(
        $value.strengths,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(strengths: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get weaknesses =>
      ListCopyWith(
        $value.weaknesses,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(weaknesses: v),
      );
  @override
  ListCopyWith<
    $R,
    PersonalityType,
    ObjectCopyWith<$R, PersonalityType, PersonalityType>
  >
  get compatibleTypes => ListCopyWith(
    $value.compatibleTypes,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(compatibleTypes: v),
  );
  @override
  $R call({
    String? profileId,
    String? userId,
    PersonalityType? type,
    Map<PersonalityTrait, int>? traits,
    String? description,
    List<String>? strengths,
    List<String>? weaknesses,
    List<PersonalityType>? compatibleTypes,
    DateTime? generatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (profileId != null) #profileId: profileId,
      if (userId != null) #userId: userId,
      if (type != null) #type: type,
      if (traits != null) #traits: traits,
      if (description != null) #description: description,
      if (strengths != null) #strengths: strengths,
      if (weaknesses != null) #weaknesses: weaknesses,
      if (compatibleTypes != null) #compatibleTypes: compatibleTypes,
      if (generatedAt != null) #generatedAt: generatedAt,
    }),
  );
  @override
  PersonalityProfile $make(CopyWithData data) => PersonalityProfile(
    profileId: data.get(#profileId, or: $value.profileId),
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    traits: data.get(#traits, or: $value.traits),
    description: data.get(#description, or: $value.description),
    strengths: data.get(#strengths, or: $value.strengths),
    weaknesses: data.get(#weaknesses, or: $value.weaknesses),
    compatibleTypes: data.get(#compatibleTypes, or: $value.compatibleTypes),
    generatedAt: data.get(#generatedAt, or: $value.generatedAt),
  );

  @override
  PersonalityProfileCopyWith<$R2, PersonalityProfile, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PersonalityProfileCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class QuizInsightMapper extends ClassMapperBase<QuizInsight> {
  QuizInsightMapper._();

  static QuizInsightMapper? _instance;
  static QuizInsightMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuizInsightMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'QuizInsight';

  static String _$insightId(QuizInsight v) => v.insightId;
  static const Field<QuizInsight, String> _f$insightId = Field(
    'insightId',
    _$insightId,
  );
  static QuizInsightType _$type(QuizInsight v) => v.type;
  static const Field<QuizInsight, QuizInsightType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$title(QuizInsight v) => v.title;
  static const Field<QuizInsight, String> _f$title = Field('title', _$title);
  static String _$message(QuizInsight v) => v.message;
  static const Field<QuizInsight, String> _f$message = Field(
    'message',
    _$message,
  );
  static double _$confidence(QuizInsight v) => v.confidence;
  static const Field<QuizInsight, double> _f$confidence = Field(
    'confidence',
    _$confidence,
  );

  @override
  final MappableFields<QuizInsight> fields = const {
    #insightId: _f$insightId,
    #type: _f$type,
    #title: _f$title,
    #message: _f$message,
    #confidence: _f$confidence,
  };

  static QuizInsight _instantiate(DecodingData data) {
    return QuizInsight(
      insightId: data.dec(_f$insightId),
      type: data.dec(_f$type),
      title: data.dec(_f$title),
      message: data.dec(_f$message),
      confidence: data.dec(_f$confidence),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuizInsight fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuizInsight>(map);
  }

  static QuizInsight fromJson(String json) {
    return ensureInitialized().decodeJson<QuizInsight>(json);
  }
}

mixin QuizInsightMappable {
  String toJson() {
    return QuizInsightMapper.ensureInitialized().encodeJson<QuizInsight>(
      this as QuizInsight,
    );
  }

  Map<String, dynamic> toMap() {
    return QuizInsightMapper.ensureInitialized().encodeMap<QuizInsight>(
      this as QuizInsight,
    );
  }

  QuizInsightCopyWith<QuizInsight, QuizInsight, QuizInsight> get copyWith =>
      _QuizInsightCopyWithImpl<QuizInsight, QuizInsight>(
        this as QuizInsight,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QuizInsightMapper.ensureInitialized().stringifyValue(
      this as QuizInsight,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuizInsightMapper.ensureInitialized().equalsValue(
      this as QuizInsight,
      other,
    );
  }

  @override
  int get hashCode {
    return QuizInsightMapper.ensureInitialized().hashValue(this as QuizInsight);
  }
}

extension QuizInsightValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuizInsight, $Out> {
  QuizInsightCopyWith<$R, QuizInsight, $Out> get $asQuizInsight =>
      $base.as((v, t, t2) => _QuizInsightCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuizInsightCopyWith<$R, $In extends QuizInsight, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? insightId,
    QuizInsightType? type,
    String? title,
    String? message,
    double? confidence,
  });
  QuizInsightCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuizInsightCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuizInsight, $Out>
    implements QuizInsightCopyWith<$R, QuizInsight, $Out> {
  _QuizInsightCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuizInsight> $mapper =
      QuizInsightMapper.ensureInitialized();
  @override
  $R call({
    String? insightId,
    QuizInsightType? type,
    String? title,
    String? message,
    double? confidence,
  }) => $apply(
    FieldCopyWithData({
      if (insightId != null) #insightId: insightId,
      if (type != null) #type: type,
      if (title != null) #title: title,
      if (message != null) #message: message,
      if (confidence != null) #confidence: confidence,
    }),
  );
  @override
  QuizInsight $make(CopyWithData data) => QuizInsight(
    insightId: data.get(#insightId, or: $value.insightId),
    type: data.get(#type, or: $value.type),
    title: data.get(#title, or: $value.title),
    message: data.get(#message, or: $value.message),
    confidence: data.get(#confidence, or: $value.confidence),
  );

  @override
  QuizInsightCopyWith<$R2, QuizInsight, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuizInsightCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class QuizCompatibilityComparisonMapper
    extends ClassMapperBase<QuizCompatibilityComparison> {
  QuizCompatibilityComparisonMapper._();

  static QuizCompatibilityComparisonMapper? _instance;
  static QuizCompatibilityComparisonMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = QuizCompatibilityComparisonMapper._(),
      );
      CompatibilityMatchMapper.ensureInitialized();
      CompatibilityConflictMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'QuizCompatibilityComparison';

  static String _$comparisonId(QuizCompatibilityComparison v) => v.comparisonId;
  static const Field<QuizCompatibilityComparison, String> _f$comparisonId =
      Field('comparisonId', _$comparisonId);
  static String _$user1Id(QuizCompatibilityComparison v) => v.user1Id;
  static const Field<QuizCompatibilityComparison, String> _f$user1Id = Field(
    'user1Id',
    _$user1Id,
  );
  static String _$user2Id(QuizCompatibilityComparison v) => v.user2Id;
  static const Field<QuizCompatibilityComparison, String> _f$user2Id = Field(
    'user2Id',
    _$user2Id,
  );
  static double _$overallCompatibility(QuizCompatibilityComparison v) =>
      v.overallCompatibility;
  static const Field<QuizCompatibilityComparison, double>
  _f$overallCompatibility = Field(
    'overallCompatibility',
    _$overallCompatibility,
  );
  static Map<QuizCategory, double> _$categoryCompatibility(
    QuizCompatibilityComparison v,
  ) => v.categoryCompatibility;
  static const Field<QuizCompatibilityComparison, Map<QuizCategory, double>>
  _f$categoryCompatibility = Field(
    'categoryCompatibility',
    _$categoryCompatibility,
  );
  static List<CompatibilityMatch> _$matches(QuizCompatibilityComparison v) =>
      v.matches;
  static const Field<QuizCompatibilityComparison, List<CompatibilityMatch>>
  _f$matches = Field('matches', _$matches);
  static List<CompatibilityConflict> _$conflicts(
    QuizCompatibilityComparison v,
  ) => v.conflicts;
  static const Field<QuizCompatibilityComparison, List<CompatibilityConflict>>
  _f$conflicts = Field('conflicts', _$conflicts);
  static List<String> _$recommendations(QuizCompatibilityComparison v) =>
      v.recommendations;
  static const Field<QuizCompatibilityComparison, List<String>>
  _f$recommendations = Field('recommendations', _$recommendations);
  static DateTime _$comparedAt(QuizCompatibilityComparison v) => v.comparedAt;
  static const Field<QuizCompatibilityComparison, DateTime> _f$comparedAt =
      Field('comparedAt', _$comparedAt);
  static bool _$isHighCompatibility(QuizCompatibilityComparison v) =>
      v.isHighCompatibility;
  static const Field<QuizCompatibilityComparison, bool> _f$isHighCompatibility =
      Field(
        'isHighCompatibility',
        _$isHighCompatibility,
        mode: FieldMode.member,
      );
  static QuizCategory? _$topCategory(QuizCompatibilityComparison v) =>
      v.topCategory;
  static const Field<QuizCompatibilityComparison, QuizCategory> _f$topCategory =
      Field('topCategory', _$topCategory, mode: FieldMode.member);

  @override
  final MappableFields<QuizCompatibilityComparison> fields = const {
    #comparisonId: _f$comparisonId,
    #user1Id: _f$user1Id,
    #user2Id: _f$user2Id,
    #overallCompatibility: _f$overallCompatibility,
    #categoryCompatibility: _f$categoryCompatibility,
    #matches: _f$matches,
    #conflicts: _f$conflicts,
    #recommendations: _f$recommendations,
    #comparedAt: _f$comparedAt,
    #isHighCompatibility: _f$isHighCompatibility,
    #topCategory: _f$topCategory,
  };

  static QuizCompatibilityComparison _instantiate(DecodingData data) {
    return QuizCompatibilityComparison(
      comparisonId: data.dec(_f$comparisonId),
      user1Id: data.dec(_f$user1Id),
      user2Id: data.dec(_f$user2Id),
      overallCompatibility: data.dec(_f$overallCompatibility),
      categoryCompatibility: data.dec(_f$categoryCompatibility),
      matches: data.dec(_f$matches),
      conflicts: data.dec(_f$conflicts),
      recommendations: data.dec(_f$recommendations),
      comparedAt: data.dec(_f$comparedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuizCompatibilityComparison fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuizCompatibilityComparison>(map);
  }

  static QuizCompatibilityComparison fromJson(String json) {
    return ensureInitialized().decodeJson<QuizCompatibilityComparison>(json);
  }
}

mixin QuizCompatibilityComparisonMappable {
  String toJson() {
    return QuizCompatibilityComparisonMapper.ensureInitialized()
        .encodeJson<QuizCompatibilityComparison>(
          this as QuizCompatibilityComparison,
        );
  }

  Map<String, dynamic> toMap() {
    return QuizCompatibilityComparisonMapper.ensureInitialized()
        .encodeMap<QuizCompatibilityComparison>(
          this as QuizCompatibilityComparison,
        );
  }

  QuizCompatibilityComparisonCopyWith<
    QuizCompatibilityComparison,
    QuizCompatibilityComparison,
    QuizCompatibilityComparison
  >
  get copyWith =>
      _QuizCompatibilityComparisonCopyWithImpl<
        QuizCompatibilityComparison,
        QuizCompatibilityComparison
      >(this as QuizCompatibilityComparison, $identity, $identity);
  @override
  String toString() {
    return QuizCompatibilityComparisonMapper.ensureInitialized().stringifyValue(
      this as QuizCompatibilityComparison,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuizCompatibilityComparisonMapper.ensureInitialized().equalsValue(
      this as QuizCompatibilityComparison,
      other,
    );
  }

  @override
  int get hashCode {
    return QuizCompatibilityComparisonMapper.ensureInitialized().hashValue(
      this as QuizCompatibilityComparison,
    );
  }
}

extension QuizCompatibilityComparisonValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuizCompatibilityComparison, $Out> {
  QuizCompatibilityComparisonCopyWith<$R, QuizCompatibilityComparison, $Out>
  get $asQuizCompatibilityComparison => $base.as(
    (v, t, t2) => _QuizCompatibilityComparisonCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class QuizCompatibilityComparisonCopyWith<
  $R,
  $In extends QuizCompatibilityComparison,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, QuizCategory, double, ObjectCopyWith<$R, double, double>>
  get categoryCompatibility;
  ListCopyWith<
    $R,
    CompatibilityMatch,
    CompatibilityMatchCopyWith<$R, CompatibilityMatch, CompatibilityMatch>
  >
  get matches;
  ListCopyWith<
    $R,
    CompatibilityConflict,
    CompatibilityConflictCopyWith<
      $R,
      CompatibilityConflict,
      CompatibilityConflict
    >
  >
  get conflicts;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get recommendations;
  $R call({
    String? comparisonId,
    String? user1Id,
    String? user2Id,
    double? overallCompatibility,
    Map<QuizCategory, double>? categoryCompatibility,
    List<CompatibilityMatch>? matches,
    List<CompatibilityConflict>? conflicts,
    List<String>? recommendations,
    DateTime? comparedAt,
  });
  QuizCompatibilityComparisonCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _QuizCompatibilityComparisonCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuizCompatibilityComparison, $Out>
    implements
        QuizCompatibilityComparisonCopyWith<
          $R,
          QuizCompatibilityComparison,
          $Out
        > {
  _QuizCompatibilityComparisonCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<QuizCompatibilityComparison> $mapper =
      QuizCompatibilityComparisonMapper.ensureInitialized();
  @override
  MapCopyWith<$R, QuizCategory, double, ObjectCopyWith<$R, double, double>>
  get categoryCompatibility => MapCopyWith(
    $value.categoryCompatibility,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryCompatibility: v),
  );
  @override
  ListCopyWith<
    $R,
    CompatibilityMatch,
    CompatibilityMatchCopyWith<$R, CompatibilityMatch, CompatibilityMatch>
  >
  get matches => ListCopyWith(
    $value.matches,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(matches: v),
  );
  @override
  ListCopyWith<
    $R,
    CompatibilityConflict,
    CompatibilityConflictCopyWith<
      $R,
      CompatibilityConflict,
      CompatibilityConflict
    >
  >
  get conflicts => ListCopyWith(
    $value.conflicts,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(conflicts: v),
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
    String? comparisonId,
    String? user1Id,
    String? user2Id,
    double? overallCompatibility,
    Map<QuizCategory, double>? categoryCompatibility,
    List<CompatibilityMatch>? matches,
    List<CompatibilityConflict>? conflicts,
    List<String>? recommendations,
    DateTime? comparedAt,
  }) => $apply(
    FieldCopyWithData({
      if (comparisonId != null) #comparisonId: comparisonId,
      if (user1Id != null) #user1Id: user1Id,
      if (user2Id != null) #user2Id: user2Id,
      if (overallCompatibility != null)
        #overallCompatibility: overallCompatibility,
      if (categoryCompatibility != null)
        #categoryCompatibility: categoryCompatibility,
      if (matches != null) #matches: matches,
      if (conflicts != null) #conflicts: conflicts,
      if (recommendations != null) #recommendations: recommendations,
      if (comparedAt != null) #comparedAt: comparedAt,
    }),
  );
  @override
  QuizCompatibilityComparison $make(CopyWithData data) =>
      QuizCompatibilityComparison(
        comparisonId: data.get(#comparisonId, or: $value.comparisonId),
        user1Id: data.get(#user1Id, or: $value.user1Id),
        user2Id: data.get(#user2Id, or: $value.user2Id),
        overallCompatibility: data.get(
          #overallCompatibility,
          or: $value.overallCompatibility,
        ),
        categoryCompatibility: data.get(
          #categoryCompatibility,
          or: $value.categoryCompatibility,
        ),
        matches: data.get(#matches, or: $value.matches),
        conflicts: data.get(#conflicts, or: $value.conflicts),
        recommendations: data.get(#recommendations, or: $value.recommendations),
        comparedAt: data.get(#comparedAt, or: $value.comparedAt),
      );

  @override
  QuizCompatibilityComparisonCopyWith<$R2, QuizCompatibilityComparison, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _QuizCompatibilityComparisonCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CompatibilityMatchMapper extends ClassMapperBase<CompatibilityMatch> {
  CompatibilityMatchMapper._();

  static CompatibilityMatchMapper? _instance;
  static CompatibilityMatchMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CompatibilityMatchMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CompatibilityMatch';

  static String _$questionId(CompatibilityMatch v) => v.questionId;
  static const Field<CompatibilityMatch, String> _f$questionId = Field(
    'questionId',
    _$questionId,
  );
  static String _$questionText(CompatibilityMatch v) => v.questionText;
  static const Field<CompatibilityMatch, String> _f$questionText = Field(
    'questionText',
    _$questionText,
  );
  static String _$user1Answer(CompatibilityMatch v) => v.user1Answer;
  static const Field<CompatibilityMatch, String> _f$user1Answer = Field(
    'user1Answer',
    _$user1Answer,
  );
  static String _$user2Answer(CompatibilityMatch v) => v.user2Answer;
  static const Field<CompatibilityMatch, String> _f$user2Answer = Field(
    'user2Answer',
    _$user2Answer,
  );
  static double _$matchScore(CompatibilityMatch v) => v.matchScore;
  static const Field<CompatibilityMatch, double> _f$matchScore = Field(
    'matchScore',
    _$matchScore,
  );

  @override
  final MappableFields<CompatibilityMatch> fields = const {
    #questionId: _f$questionId,
    #questionText: _f$questionText,
    #user1Answer: _f$user1Answer,
    #user2Answer: _f$user2Answer,
    #matchScore: _f$matchScore,
  };

  static CompatibilityMatch _instantiate(DecodingData data) {
    return CompatibilityMatch(
      questionId: data.dec(_f$questionId),
      questionText: data.dec(_f$questionText),
      user1Answer: data.dec(_f$user1Answer),
      user2Answer: data.dec(_f$user2Answer),
      matchScore: data.dec(_f$matchScore),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CompatibilityMatch fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CompatibilityMatch>(map);
  }

  static CompatibilityMatch fromJson(String json) {
    return ensureInitialized().decodeJson<CompatibilityMatch>(json);
  }
}

mixin CompatibilityMatchMappable {
  String toJson() {
    return CompatibilityMatchMapper.ensureInitialized()
        .encodeJson<CompatibilityMatch>(this as CompatibilityMatch);
  }

  Map<String, dynamic> toMap() {
    return CompatibilityMatchMapper.ensureInitialized()
        .encodeMap<CompatibilityMatch>(this as CompatibilityMatch);
  }

  CompatibilityMatchCopyWith<
    CompatibilityMatch,
    CompatibilityMatch,
    CompatibilityMatch
  >
  get copyWith =>
      _CompatibilityMatchCopyWithImpl<CompatibilityMatch, CompatibilityMatch>(
        this as CompatibilityMatch,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CompatibilityMatchMapper.ensureInitialized().stringifyValue(
      this as CompatibilityMatch,
    );
  }

  @override
  bool operator ==(Object other) {
    return CompatibilityMatchMapper.ensureInitialized().equalsValue(
      this as CompatibilityMatch,
      other,
    );
  }

  @override
  int get hashCode {
    return CompatibilityMatchMapper.ensureInitialized().hashValue(
      this as CompatibilityMatch,
    );
  }
}

extension CompatibilityMatchValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CompatibilityMatch, $Out> {
  CompatibilityMatchCopyWith<$R, CompatibilityMatch, $Out>
  get $asCompatibilityMatch => $base.as(
    (v, t, t2) => _CompatibilityMatchCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CompatibilityMatchCopyWith<
  $R,
  $In extends CompatibilityMatch,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? questionId,
    String? questionText,
    String? user1Answer,
    String? user2Answer,
    double? matchScore,
  });
  CompatibilityMatchCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CompatibilityMatchCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CompatibilityMatch, $Out>
    implements CompatibilityMatchCopyWith<$R, CompatibilityMatch, $Out> {
  _CompatibilityMatchCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CompatibilityMatch> $mapper =
      CompatibilityMatchMapper.ensureInitialized();
  @override
  $R call({
    String? questionId,
    String? questionText,
    String? user1Answer,
    String? user2Answer,
    double? matchScore,
  }) => $apply(
    FieldCopyWithData({
      if (questionId != null) #questionId: questionId,
      if (questionText != null) #questionText: questionText,
      if (user1Answer != null) #user1Answer: user1Answer,
      if (user2Answer != null) #user2Answer: user2Answer,
      if (matchScore != null) #matchScore: matchScore,
    }),
  );
  @override
  CompatibilityMatch $make(CopyWithData data) => CompatibilityMatch(
    questionId: data.get(#questionId, or: $value.questionId),
    questionText: data.get(#questionText, or: $value.questionText),
    user1Answer: data.get(#user1Answer, or: $value.user1Answer),
    user2Answer: data.get(#user2Answer, or: $value.user2Answer),
    matchScore: data.get(#matchScore, or: $value.matchScore),
  );

  @override
  CompatibilityMatchCopyWith<$R2, CompatibilityMatch, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CompatibilityMatchCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CompatibilityConflictMapper
    extends ClassMapperBase<CompatibilityConflict> {
  CompatibilityConflictMapper._();

  static CompatibilityConflictMapper? _instance;
  static CompatibilityConflictMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CompatibilityConflictMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CompatibilityConflict';

  static String _$questionId(CompatibilityConflict v) => v.questionId;
  static const Field<CompatibilityConflict, String> _f$questionId = Field(
    'questionId',
    _$questionId,
  );
  static String _$questionText(CompatibilityConflict v) => v.questionText;
  static const Field<CompatibilityConflict, String> _f$questionText = Field(
    'questionText',
    _$questionText,
  );
  static String _$user1Answer(CompatibilityConflict v) => v.user1Answer;
  static const Field<CompatibilityConflict, String> _f$user1Answer = Field(
    'user1Answer',
    _$user1Answer,
  );
  static String _$user2Answer(CompatibilityConflict v) => v.user2Answer;
  static const Field<CompatibilityConflict, String> _f$user2Answer = Field(
    'user2Answer',
    _$user2Answer,
  );
  static ConflictSeverity _$severity(CompatibilityConflict v) => v.severity;
  static const Field<CompatibilityConflict, ConflictSeverity> _f$severity =
      Field('severity', _$severity);
  static String? _$resolutionTip(CompatibilityConflict v) => v.resolutionTip;
  static const Field<CompatibilityConflict, String> _f$resolutionTip = Field(
    'resolutionTip',
    _$resolutionTip,
    opt: true,
  );

  @override
  final MappableFields<CompatibilityConflict> fields = const {
    #questionId: _f$questionId,
    #questionText: _f$questionText,
    #user1Answer: _f$user1Answer,
    #user2Answer: _f$user2Answer,
    #severity: _f$severity,
    #resolutionTip: _f$resolutionTip,
  };

  static CompatibilityConflict _instantiate(DecodingData data) {
    return CompatibilityConflict(
      questionId: data.dec(_f$questionId),
      questionText: data.dec(_f$questionText),
      user1Answer: data.dec(_f$user1Answer),
      user2Answer: data.dec(_f$user2Answer),
      severity: data.dec(_f$severity),
      resolutionTip: data.dec(_f$resolutionTip),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CompatibilityConflict fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CompatibilityConflict>(map);
  }

  static CompatibilityConflict fromJson(String json) {
    return ensureInitialized().decodeJson<CompatibilityConflict>(json);
  }
}

mixin CompatibilityConflictMappable {
  String toJson() {
    return CompatibilityConflictMapper.ensureInitialized()
        .encodeJson<CompatibilityConflict>(this as CompatibilityConflict);
  }

  Map<String, dynamic> toMap() {
    return CompatibilityConflictMapper.ensureInitialized()
        .encodeMap<CompatibilityConflict>(this as CompatibilityConflict);
  }

  CompatibilityConflictCopyWith<
    CompatibilityConflict,
    CompatibilityConflict,
    CompatibilityConflict
  >
  get copyWith =>
      _CompatibilityConflictCopyWithImpl<
        CompatibilityConflict,
        CompatibilityConflict
      >(this as CompatibilityConflict, $identity, $identity);
  @override
  String toString() {
    return CompatibilityConflictMapper.ensureInitialized().stringifyValue(
      this as CompatibilityConflict,
    );
  }

  @override
  bool operator ==(Object other) {
    return CompatibilityConflictMapper.ensureInitialized().equalsValue(
      this as CompatibilityConflict,
      other,
    );
  }

  @override
  int get hashCode {
    return CompatibilityConflictMapper.ensureInitialized().hashValue(
      this as CompatibilityConflict,
    );
  }
}

extension CompatibilityConflictValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CompatibilityConflict, $Out> {
  CompatibilityConflictCopyWith<$R, CompatibilityConflict, $Out>
  get $asCompatibilityConflict => $base.as(
    (v, t, t2) => _CompatibilityConflictCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CompatibilityConflictCopyWith<
  $R,
  $In extends CompatibilityConflict,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? questionId,
    String? questionText,
    String? user1Answer,
    String? user2Answer,
    ConflictSeverity? severity,
    String? resolutionTip,
  });
  CompatibilityConflictCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CompatibilityConflictCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CompatibilityConflict, $Out>
    implements CompatibilityConflictCopyWith<$R, CompatibilityConflict, $Out> {
  _CompatibilityConflictCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CompatibilityConflict> $mapper =
      CompatibilityConflictMapper.ensureInitialized();
  @override
  $R call({
    String? questionId,
    String? questionText,
    String? user1Answer,
    String? user2Answer,
    ConflictSeverity? severity,
    Object? resolutionTip = $none,
  }) => $apply(
    FieldCopyWithData({
      if (questionId != null) #questionId: questionId,
      if (questionText != null) #questionText: questionText,
      if (user1Answer != null) #user1Answer: user1Answer,
      if (user2Answer != null) #user2Answer: user2Answer,
      if (severity != null) #severity: severity,
      if (resolutionTip != $none) #resolutionTip: resolutionTip,
    }),
  );
  @override
  CompatibilityConflict $make(CopyWithData data) => CompatibilityConflict(
    questionId: data.get(#questionId, or: $value.questionId),
    questionText: data.get(#questionText, or: $value.questionText),
    user1Answer: data.get(#user1Answer, or: $value.user1Answer),
    user2Answer: data.get(#user2Answer, or: $value.user2Answer),
    severity: data.get(#severity, or: $value.severity),
    resolutionTip: data.get(#resolutionTip, or: $value.resolutionTip),
  );

  @override
  CompatibilityConflictCopyWith<$R2, CompatibilityConflict, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CompatibilityConflictCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class QuizStatsMapper extends ClassMapperBase<QuizStats> {
  QuizStatsMapper._();

  static QuizStatsMapper? _instance;
  static QuizStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuizStatsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'QuizStats';

  static String _$quizId(QuizStats v) => v.quizId;
  static const Field<QuizStats, String> _f$quizId = Field('quizId', _$quizId);
  static int _$totalResponses(QuizStats v) => v.totalResponses;
  static const Field<QuizStats, int> _f$totalResponses = Field(
    'totalResponses',
    _$totalResponses,
  );
  static int _$completedResponses(QuizStats v) => v.completedResponses;
  static const Field<QuizStats, int> _f$completedResponses = Field(
    'completedResponses',
    _$completedResponses,
  );
  static double _$averageCompletionTime(QuizStats v) => v.averageCompletionTime;
  static const Field<QuizStats, double> _f$averageCompletionTime = Field(
    'averageCompletionTime',
    _$averageCompletionTime,
  );
  static double _$completionRate(QuizStats v) => v.completionRate;
  static const Field<QuizStats, double> _f$completionRate = Field(
    'completionRate',
    _$completionRate,
  );
  static Map<String, int> _$popularAnswers(QuizStats v) => v.popularAnswers;
  static const Field<QuizStats, Map<String, int>> _f$popularAnswers = Field(
    'popularAnswers',
    _$popularAnswers,
  );
  static DateTime _$generatedAt(QuizStats v) => v.generatedAt;
  static const Field<QuizStats, DateTime> _f$generatedAt = Field(
    'generatedAt',
    _$generatedAt,
  );

  @override
  final MappableFields<QuizStats> fields = const {
    #quizId: _f$quizId,
    #totalResponses: _f$totalResponses,
    #completedResponses: _f$completedResponses,
    #averageCompletionTime: _f$averageCompletionTime,
    #completionRate: _f$completionRate,
    #popularAnswers: _f$popularAnswers,
    #generatedAt: _f$generatedAt,
  };

  static QuizStats _instantiate(DecodingData data) {
    return QuizStats(
      quizId: data.dec(_f$quizId),
      totalResponses: data.dec(_f$totalResponses),
      completedResponses: data.dec(_f$completedResponses),
      averageCompletionTime: data.dec(_f$averageCompletionTime),
      completionRate: data.dec(_f$completionRate),
      popularAnswers: data.dec(_f$popularAnswers),
      generatedAt: data.dec(_f$generatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuizStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuizStats>(map);
  }

  static QuizStats fromJson(String json) {
    return ensureInitialized().decodeJson<QuizStats>(json);
  }
}

mixin QuizStatsMappable {
  String toJson() {
    return QuizStatsMapper.ensureInitialized().encodeJson<QuizStats>(
      this as QuizStats,
    );
  }

  Map<String, dynamic> toMap() {
    return QuizStatsMapper.ensureInitialized().encodeMap<QuizStats>(
      this as QuizStats,
    );
  }

  QuizStatsCopyWith<QuizStats, QuizStats, QuizStats> get copyWith =>
      _QuizStatsCopyWithImpl<QuizStats, QuizStats>(
        this as QuizStats,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QuizStatsMapper.ensureInitialized().stringifyValue(
      this as QuizStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuizStatsMapper.ensureInitialized().equalsValue(
      this as QuizStats,
      other,
    );
  }

  @override
  int get hashCode {
    return QuizStatsMapper.ensureInitialized().hashValue(this as QuizStats);
  }
}

extension QuizStatsValueCopy<$R, $Out> on ObjectCopyWith<$R, QuizStats, $Out> {
  QuizStatsCopyWith<$R, QuizStats, $Out> get $asQuizStats =>
      $base.as((v, t, t2) => _QuizStatsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuizStatsCopyWith<$R, $In extends QuizStats, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get popularAnswers;
  $R call({
    String? quizId,
    int? totalResponses,
    int? completedResponses,
    double? averageCompletionTime,
    double? completionRate,
    Map<String, int>? popularAnswers,
    DateTime? generatedAt,
  });
  QuizStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuizStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuizStats, $Out>
    implements QuizStatsCopyWith<$R, QuizStats, $Out> {
  _QuizStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuizStats> $mapper =
      QuizStatsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>>
  get popularAnswers => MapCopyWith(
    $value.popularAnswers,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(popularAnswers: v),
  );
  @override
  $R call({
    String? quizId,
    int? totalResponses,
    int? completedResponses,
    double? averageCompletionTime,
    double? completionRate,
    Map<String, int>? popularAnswers,
    DateTime? generatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (quizId != null) #quizId: quizId,
      if (totalResponses != null) #totalResponses: totalResponses,
      if (completedResponses != null) #completedResponses: completedResponses,
      if (averageCompletionTime != null)
        #averageCompletionTime: averageCompletionTime,
      if (completionRate != null) #completionRate: completionRate,
      if (popularAnswers != null) #popularAnswers: popularAnswers,
      if (generatedAt != null) #generatedAt: generatedAt,
    }),
  );
  @override
  QuizStats $make(CopyWithData data) => QuizStats(
    quizId: data.get(#quizId, or: $value.quizId),
    totalResponses: data.get(#totalResponses, or: $value.totalResponses),
    completedResponses: data.get(
      #completedResponses,
      or: $value.completedResponses,
    ),
    averageCompletionTime: data.get(
      #averageCompletionTime,
      or: $value.averageCompletionTime,
    ),
    completionRate: data.get(#completionRate, or: $value.completionRate),
    popularAnswers: data.get(#popularAnswers, or: $value.popularAnswers),
    generatedAt: data.get(#generatedAt, or: $value.generatedAt),
  );

  @override
  QuizStatsCopyWith<$R2, QuizStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuizStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CreateQuizRequestMapper extends ClassMapperBase<CreateQuizRequest> {
  CreateQuizRequestMapper._();

  static CreateQuizRequestMapper? _instance;
  static CreateQuizRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CreateQuizRequestMapper._());
      QuizQuestionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CreateQuizRequest';

  static String _$title(CreateQuizRequest v) => v.title;
  static const Field<CreateQuizRequest, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$description(CreateQuizRequest v) => v.description;
  static const Field<CreateQuizRequest, String> _f$description = Field(
    'description',
    _$description,
  );
  static QuizCategory _$category(CreateQuizRequest v) => v.category;
  static const Field<CreateQuizRequest, QuizCategory> _f$category = Field(
    'category',
    _$category,
  );
  static List<QuizQuestion> _$questions(CreateQuizRequest v) => v.questions;
  static const Field<CreateQuizRequest, List<QuizQuestion>> _f$questions =
      Field('questions', _$questions);

  @override
  final MappableFields<CreateQuizRequest> fields = const {
    #title: _f$title,
    #description: _f$description,
    #category: _f$category,
    #questions: _f$questions,
  };

  static CreateQuizRequest _instantiate(DecodingData data) {
    return CreateQuizRequest(
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      category: data.dec(_f$category),
      questions: data.dec(_f$questions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CreateQuizRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CreateQuizRequest>(map);
  }

  static CreateQuizRequest fromJson(String json) {
    return ensureInitialized().decodeJson<CreateQuizRequest>(json);
  }
}

mixin CreateQuizRequestMappable {
  String toJson() {
    return CreateQuizRequestMapper.ensureInitialized()
        .encodeJson<CreateQuizRequest>(this as CreateQuizRequest);
  }

  Map<String, dynamic> toMap() {
    return CreateQuizRequestMapper.ensureInitialized()
        .encodeMap<CreateQuizRequest>(this as CreateQuizRequest);
  }

  CreateQuizRequestCopyWith<
    CreateQuizRequest,
    CreateQuizRequest,
    CreateQuizRequest
  >
  get copyWith =>
      _CreateQuizRequestCopyWithImpl<CreateQuizRequest, CreateQuizRequest>(
        this as CreateQuizRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CreateQuizRequestMapper.ensureInitialized().stringifyValue(
      this as CreateQuizRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return CreateQuizRequestMapper.ensureInitialized().equalsValue(
      this as CreateQuizRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return CreateQuizRequestMapper.ensureInitialized().hashValue(
      this as CreateQuizRequest,
    );
  }
}

extension CreateQuizRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CreateQuizRequest, $Out> {
  CreateQuizRequestCopyWith<$R, CreateQuizRequest, $Out>
  get $asCreateQuizRequest => $base.as(
    (v, t, t2) => _CreateQuizRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CreateQuizRequestCopyWith<
  $R,
  $In extends CreateQuizRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    QuizQuestion,
    QuizQuestionCopyWith<$R, QuizQuestion, QuizQuestion>
  >
  get questions;
  $R call({
    String? title,
    String? description,
    QuizCategory? category,
    List<QuizQuestion>? questions,
  });
  CreateQuizRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CreateQuizRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CreateQuizRequest, $Out>
    implements CreateQuizRequestCopyWith<$R, CreateQuizRequest, $Out> {
  _CreateQuizRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CreateQuizRequest> $mapper =
      CreateQuizRequestMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    QuizQuestion,
    QuizQuestionCopyWith<$R, QuizQuestion, QuizQuestion>
  >
  get questions => ListCopyWith(
    $value.questions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(questions: v),
  );
  @override
  $R call({
    String? title,
    String? description,
    QuizCategory? category,
    List<QuizQuestion>? questions,
  }) => $apply(
    FieldCopyWithData({
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (category != null) #category: category,
      if (questions != null) #questions: questions,
    }),
  );
  @override
  CreateQuizRequest $make(CopyWithData data) => CreateQuizRequest(
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    category: data.get(#category, or: $value.category),
    questions: data.get(#questions, or: $value.questions),
  );

  @override
  CreateQuizRequestCopyWith<$R2, CreateQuizRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CreateQuizRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SubmitQuizRequestMapper extends ClassMapperBase<SubmitQuizRequest> {
  SubmitQuizRequestMapper._();

  static SubmitQuizRequestMapper? _instance;
  static SubmitQuizRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubmitQuizRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubmitQuizRequest';

  static String _$quizId(SubmitQuizRequest v) => v.quizId;
  static const Field<SubmitQuizRequest, String> _f$quizId = Field(
    'quizId',
    _$quizId,
  );
  static Map<String, dynamic> _$answers(SubmitQuizRequest v) => v.answers;
  static const Field<SubmitQuizRequest, Map<String, dynamic>> _f$answers =
      Field('answers', _$answers);
  static int _$timeSpentSeconds(SubmitQuizRequest v) => v.timeSpentSeconds;
  static const Field<SubmitQuizRequest, int> _f$timeSpentSeconds = Field(
    'timeSpentSeconds',
    _$timeSpentSeconds,
  );

  @override
  final MappableFields<SubmitQuizRequest> fields = const {
    #quizId: _f$quizId,
    #answers: _f$answers,
    #timeSpentSeconds: _f$timeSpentSeconds,
  };

  static SubmitQuizRequest _instantiate(DecodingData data) {
    return SubmitQuizRequest(
      quizId: data.dec(_f$quizId),
      answers: data.dec(_f$answers),
      timeSpentSeconds: data.dec(_f$timeSpentSeconds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubmitQuizRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubmitQuizRequest>(map);
  }

  static SubmitQuizRequest fromJson(String json) {
    return ensureInitialized().decodeJson<SubmitQuizRequest>(json);
  }
}

mixin SubmitQuizRequestMappable {
  String toJson() {
    return SubmitQuizRequestMapper.ensureInitialized()
        .encodeJson<SubmitQuizRequest>(this as SubmitQuizRequest);
  }

  Map<String, dynamic> toMap() {
    return SubmitQuizRequestMapper.ensureInitialized()
        .encodeMap<SubmitQuizRequest>(this as SubmitQuizRequest);
  }

  SubmitQuizRequestCopyWith<
    SubmitQuizRequest,
    SubmitQuizRequest,
    SubmitQuizRequest
  >
  get copyWith =>
      _SubmitQuizRequestCopyWithImpl<SubmitQuizRequest, SubmitQuizRequest>(
        this as SubmitQuizRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SubmitQuizRequestMapper.ensureInitialized().stringifyValue(
      this as SubmitQuizRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubmitQuizRequestMapper.ensureInitialized().equalsValue(
      this as SubmitQuizRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return SubmitQuizRequestMapper.ensureInitialized().hashValue(
      this as SubmitQuizRequest,
    );
  }
}

extension SubmitQuizRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubmitQuizRequest, $Out> {
  SubmitQuizRequestCopyWith<$R, SubmitQuizRequest, $Out>
  get $asSubmitQuizRequest => $base.as(
    (v, t, t2) => _SubmitQuizRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SubmitQuizRequestCopyWith<
  $R,
  $In extends SubmitQuizRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get answers;
  $R call({
    String? quizId,
    Map<String, dynamic>? answers,
    int? timeSpentSeconds,
  });
  SubmitQuizRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubmitQuizRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubmitQuizRequest, $Out>
    implements SubmitQuizRequestCopyWith<$R, SubmitQuizRequest, $Out> {
  _SubmitQuizRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubmitQuizRequest> $mapper =
      SubmitQuizRequestMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get answers => MapCopyWith(
    $value.answers,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(answers: v),
  );
  @override
  $R call({
    String? quizId,
    Map<String, dynamic>? answers,
    int? timeSpentSeconds,
  }) => $apply(
    FieldCopyWithData({
      if (quizId != null) #quizId: quizId,
      if (answers != null) #answers: answers,
      if (timeSpentSeconds != null) #timeSpentSeconds: timeSpentSeconds,
    }),
  );
  @override
  SubmitQuizRequest $make(CopyWithData data) => SubmitQuizRequest(
    quizId: data.get(#quizId, or: $value.quizId),
    answers: data.get(#answers, or: $value.answers),
    timeSpentSeconds: data.get(#timeSpentSeconds, or: $value.timeSpentSeconds),
  );

  @override
  SubmitQuizRequestCopyWith<$R2, SubmitQuizRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SubmitQuizRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

