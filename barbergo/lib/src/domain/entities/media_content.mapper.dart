// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'media_content.dart';

class MediaContentMapper extends ClassMapperBase<MediaContent> {
  MediaContentMapper._();

  static MediaContentMapper? _instance;
  static MediaContentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MediaContentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MediaContent';

  static String _$mediaId(MediaContent v) => v.mediaId;
  static const Field<MediaContent, String> _f$mediaId = Field(
    'mediaId',
    _$mediaId,
  );
  static MediaType _$type(MediaContent v) => v.type;
  static const Field<MediaContent, MediaType> _f$type = Field('type', _$type);
  static String _$url(MediaContent v) => v.url;
  static const Field<MediaContent, String> _f$url = Field('url', _$url);
  static String? _$thumbnailUrl(MediaContent v) => v.thumbnailUrl;
  static const Field<MediaContent, String> _f$thumbnailUrl = Field(
    'thumbnailUrl',
    _$thumbnailUrl,
    opt: true,
  );
  static int _$durationSeconds(MediaContent v) => v.durationSeconds;
  static const Field<MediaContent, int> _f$durationSeconds = Field(
    'durationSeconds',
    _$durationSeconds,
  );
  static int _$fileSizeBytes(MediaContent v) => v.fileSizeBytes;
  static const Field<MediaContent, int> _f$fileSizeBytes = Field(
    'fileSizeBytes',
    _$fileSizeBytes,
  );
  static DateTime _$uploadedAt(MediaContent v) => v.uploadedAt;
  static const Field<MediaContent, DateTime> _f$uploadedAt = Field(
    'uploadedAt',
    _$uploadedAt,
  );
  static bool _$isProcessed(MediaContent v) => v.isProcessed;
  static const Field<MediaContent, bool> _f$isProcessed = Field(
    'isProcessed',
    _$isProcessed,
    opt: true,
    def: false,
  );
  static bool _$isValid(MediaContent v) => v.isValid;
  static const Field<MediaContent, bool> _f$isValid = Field(
    'isValid',
    _$isValid,
    mode: FieldMode.member,
  );
  static String _$durationText(MediaContent v) => v.durationText;
  static const Field<MediaContent, String> _f$durationText = Field(
    'durationText',
    _$durationText,
    mode: FieldMode.member,
  );
  static String _$fileSizeText(MediaContent v) => v.fileSizeText;
  static const Field<MediaContent, String> _f$fileSizeText = Field(
    'fileSizeText',
    _$fileSizeText,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<MediaContent> fields = const {
    #mediaId: _f$mediaId,
    #type: _f$type,
    #url: _f$url,
    #thumbnailUrl: _f$thumbnailUrl,
    #durationSeconds: _f$durationSeconds,
    #fileSizeBytes: _f$fileSizeBytes,
    #uploadedAt: _f$uploadedAt,
    #isProcessed: _f$isProcessed,
    #isValid: _f$isValid,
    #durationText: _f$durationText,
    #fileSizeText: _f$fileSizeText,
  };

  static MediaContent _instantiate(DecodingData data) {
    return MediaContent(
      mediaId: data.dec(_f$mediaId),
      type: data.dec(_f$type),
      url: data.dec(_f$url),
      thumbnailUrl: data.dec(_f$thumbnailUrl),
      durationSeconds: data.dec(_f$durationSeconds),
      fileSizeBytes: data.dec(_f$fileSizeBytes),
      uploadedAt: data.dec(_f$uploadedAt),
      isProcessed: data.dec(_f$isProcessed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MediaContent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MediaContent>(map);
  }

  static MediaContent fromJson(String json) {
    return ensureInitialized().decodeJson<MediaContent>(json);
  }
}

mixin MediaContentMappable {
  String toJson() {
    return MediaContentMapper.ensureInitialized().encodeJson<MediaContent>(
      this as MediaContent,
    );
  }

  Map<String, dynamic> toMap() {
    return MediaContentMapper.ensureInitialized().encodeMap<MediaContent>(
      this as MediaContent,
    );
  }

  MediaContentCopyWith<MediaContent, MediaContent, MediaContent> get copyWith =>
      _MediaContentCopyWithImpl<MediaContent, MediaContent>(
        this as MediaContent,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MediaContentMapper.ensureInitialized().stringifyValue(
      this as MediaContent,
    );
  }

  @override
  bool operator ==(Object other) {
    return MediaContentMapper.ensureInitialized().equalsValue(
      this as MediaContent,
      other,
    );
  }

  @override
  int get hashCode {
    return MediaContentMapper.ensureInitialized().hashValue(
      this as MediaContent,
    );
  }
}

extension MediaContentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MediaContent, $Out> {
  MediaContentCopyWith<$R, MediaContent, $Out> get $asMediaContent =>
      $base.as((v, t, t2) => _MediaContentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MediaContentCopyWith<$R, $In extends MediaContent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? mediaId,
    MediaType? type,
    String? url,
    String? thumbnailUrl,
    int? durationSeconds,
    int? fileSizeBytes,
    DateTime? uploadedAt,
    bool? isProcessed,
  });
  MediaContentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MediaContentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MediaContent, $Out>
    implements MediaContentCopyWith<$R, MediaContent, $Out> {
  _MediaContentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MediaContent> $mapper =
      MediaContentMapper.ensureInitialized();
  @override
  $R call({
    String? mediaId,
    MediaType? type,
    String? url,
    Object? thumbnailUrl = $none,
    int? durationSeconds,
    int? fileSizeBytes,
    DateTime? uploadedAt,
    bool? isProcessed,
  }) => $apply(
    FieldCopyWithData({
      if (mediaId != null) #mediaId: mediaId,
      if (type != null) #type: type,
      if (url != null) #url: url,
      if (thumbnailUrl != $none) #thumbnailUrl: thumbnailUrl,
      if (durationSeconds != null) #durationSeconds: durationSeconds,
      if (fileSizeBytes != null) #fileSizeBytes: fileSizeBytes,
      if (uploadedAt != null) #uploadedAt: uploadedAt,
      if (isProcessed != null) #isProcessed: isProcessed,
    }),
  );
  @override
  MediaContent $make(CopyWithData data) => MediaContent(
    mediaId: data.get(#mediaId, or: $value.mediaId),
    type: data.get(#type, or: $value.type),
    url: data.get(#url, or: $value.url),
    thumbnailUrl: data.get(#thumbnailUrl, or: $value.thumbnailUrl),
    durationSeconds: data.get(#durationSeconds, or: $value.durationSeconds),
    fileSizeBytes: data.get(#fileSizeBytes, or: $value.fileSizeBytes),
    uploadedAt: data.get(#uploadedAt, or: $value.uploadedAt),
    isProcessed: data.get(#isProcessed, or: $value.isProcessed),
  );

  @override
  MediaContentCopyWith<$R2, MediaContent, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MediaContentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

