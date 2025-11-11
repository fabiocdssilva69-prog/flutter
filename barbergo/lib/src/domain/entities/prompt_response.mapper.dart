// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'prompt_response.dart';

class PromptResponseMapper extends ClassMapperBase<PromptResponse> {
  PromptResponseMapper._();

  static PromptResponseMapper? _instance;
  static PromptResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PromptResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PromptResponse';

  static String _$responseId(PromptResponse v) => v.responseId;
  static const Field<PromptResponse, String> _f$responseId = Field(
    'responseId',
    _$responseId,
  );
  static String _$promptId(PromptResponse v) => v.promptId;
  static const Field<PromptResponse, String> _f$promptId = Field(
    'promptId',
    _$promptId,
  );
  static String _$promptText(PromptResponse v) => v.promptText;
  static const Field<PromptResponse, String> _f$promptText = Field(
    'promptText',
    _$promptText,
  );
  static String _$response(PromptResponse v) => v.response;
  static const Field<PromptResponse, String> _f$response = Field(
    'response',
    _$response,
  );
  static DateTime _$createdAt(PromptResponse v) => v.createdAt;
  static const Field<PromptResponse, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static bool _$isValid(PromptResponse v) => v.isValid;
  static const Field<PromptResponse, bool> _f$isValid = Field(
    'isValid',
    _$isValid,
    mode: FieldMode.member,
  );
  static String _$preview(PromptResponse v) => v.preview;
  static const Field<PromptResponse, String> _f$preview = Field(
    'preview',
    _$preview,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<PromptResponse> fields = const {
    #responseId: _f$responseId,
    #promptId: _f$promptId,
    #promptText: _f$promptText,
    #response: _f$response,
    #createdAt: _f$createdAt,
    #isValid: _f$isValid,
    #preview: _f$preview,
  };

  static PromptResponse _instantiate(DecodingData data) {
    return PromptResponse(
      responseId: data.dec(_f$responseId),
      promptId: data.dec(_f$promptId),
      promptText: data.dec(_f$promptText),
      response: data.dec(_f$response),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PromptResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PromptResponse>(map);
  }

  static PromptResponse fromJson(String json) {
    return ensureInitialized().decodeJson<PromptResponse>(json);
  }
}

mixin PromptResponseMappable {
  String toJson() {
    return PromptResponseMapper.ensureInitialized().encodeJson<PromptResponse>(
      this as PromptResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return PromptResponseMapper.ensureInitialized().encodeMap<PromptResponse>(
      this as PromptResponse,
    );
  }

  PromptResponseCopyWith<PromptResponse, PromptResponse, PromptResponse>
  get copyWith => _PromptResponseCopyWithImpl<PromptResponse, PromptResponse>(
    this as PromptResponse,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PromptResponseMapper.ensureInitialized().stringifyValue(
      this as PromptResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return PromptResponseMapper.ensureInitialized().equalsValue(
      this as PromptResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return PromptResponseMapper.ensureInitialized().hashValue(
      this as PromptResponse,
    );
  }
}

extension PromptResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PromptResponse, $Out> {
  PromptResponseCopyWith<$R, PromptResponse, $Out> get $asPromptResponse =>
      $base.as((v, t, t2) => _PromptResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PromptResponseCopyWith<$R, $In extends PromptResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? responseId,
    String? promptId,
    String? promptText,
    String? response,
    DateTime? createdAt,
  });
  PromptResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PromptResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PromptResponse, $Out>
    implements PromptResponseCopyWith<$R, PromptResponse, $Out> {
  _PromptResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PromptResponse> $mapper =
      PromptResponseMapper.ensureInitialized();
  @override
  $R call({
    String? responseId,
    String? promptId,
    String? promptText,
    String? response,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (responseId != null) #responseId: responseId,
      if (promptId != null) #promptId: promptId,
      if (promptText != null) #promptText: promptText,
      if (response != null) #response: response,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  PromptResponse $make(CopyWithData data) => PromptResponse(
    responseId: data.get(#responseId, or: $value.responseId),
    promptId: data.get(#promptId, or: $value.promptId),
    promptText: data.get(#promptText, or: $value.promptText),
    response: data.get(#response, or: $value.response),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  PromptResponseCopyWith<$R2, PromptResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PromptResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

