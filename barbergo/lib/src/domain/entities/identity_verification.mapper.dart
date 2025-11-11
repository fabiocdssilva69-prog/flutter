// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'identity_verification.dart';

class IdentityVerificationMapper extends ClassMapperBase<IdentityVerification> {
  IdentityVerificationMapper._();

  static IdentityVerificationMapper? _instance;
  static IdentityVerificationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = IdentityVerificationMapper._());
      VerificationDocumentMapper.ensureInitialized();
      VerificationBadgeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'IdentityVerification';

  static String _$verificationId(IdentityVerification v) => v.verificationId;
  static const Field<IdentityVerification, String> _f$verificationId = Field(
    'verificationId',
    _$verificationId,
  );
  static String _$userId(IdentityVerification v) => v.userId;
  static const Field<IdentityVerification, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static VerificationType _$type(IdentityVerification v) => v.type;
  static const Field<IdentityVerification, VerificationType> _f$type = Field(
    'type',
    _$type,
  );
  static VerificationStatus _$status(IdentityVerification v) => v.status;
  static const Field<IdentityVerification, VerificationStatus> _f$status =
      Field('status', _$status);
  static DateTime _$submittedAt(IdentityVerification v) => v.submittedAt;
  static const Field<IdentityVerification, DateTime> _f$submittedAt = Field(
    'submittedAt',
    _$submittedAt,
  );
  static DateTime? _$reviewedAt(IdentityVerification v) => v.reviewedAt;
  static const Field<IdentityVerification, DateTime> _f$reviewedAt = Field(
    'reviewedAt',
    _$reviewedAt,
    opt: true,
  );
  static String? _$reviewedBy(IdentityVerification v) => v.reviewedBy;
  static const Field<IdentityVerification, String> _f$reviewedBy = Field(
    'reviewedBy',
    _$reviewedBy,
    opt: true,
  );
  static String? _$rejectionReason(IdentityVerification v) => v.rejectionReason;
  static const Field<IdentityVerification, String> _f$rejectionReason = Field(
    'rejectionReason',
    _$rejectionReason,
    opt: true,
  );
  static List<VerificationDocument> _$documents(IdentityVerification v) =>
      v.documents;
  static const Field<IdentityVerification, List<VerificationDocument>>
  _f$documents = Field('documents', _$documents);
  static VerificationBadge? _$badge(IdentityVerification v) => v.badge;
  static const Field<IdentityVerification, VerificationBadge> _f$badge = Field(
    'badge',
    _$badge,
    opt: true,
  );
  static int _$attemptCount(IdentityVerification v) => v.attemptCount;
  static const Field<IdentityVerification, int> _f$attemptCount = Field(
    'attemptCount',
    _$attemptCount,
    opt: true,
    def: 1,
  );
  static DateTime? _$nextAttemptAllowedAt(IdentityVerification v) =>
      v.nextAttemptAllowedAt;
  static const Field<IdentityVerification, DateTime> _f$nextAttemptAllowedAt =
      Field('nextAttemptAllowedAt', _$nextAttemptAllowedAt, opt: true);
  static bool _$isVerified(IdentityVerification v) => v.isVerified;
  static const Field<IdentityVerification, bool> _f$isVerified = Field(
    'isVerified',
    _$isVerified,
    mode: FieldMode.member,
  );
  static bool _$canRetry(IdentityVerification v) => v.canRetry;
  static const Field<IdentityVerification, bool> _f$canRetry = Field(
    'canRetry',
    _$canRetry,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<IdentityVerification> fields = const {
    #verificationId: _f$verificationId,
    #userId: _f$userId,
    #type: _f$type,
    #status: _f$status,
    #submittedAt: _f$submittedAt,
    #reviewedAt: _f$reviewedAt,
    #reviewedBy: _f$reviewedBy,
    #rejectionReason: _f$rejectionReason,
    #documents: _f$documents,
    #badge: _f$badge,
    #attemptCount: _f$attemptCount,
    #nextAttemptAllowedAt: _f$nextAttemptAllowedAt,
    #isVerified: _f$isVerified,
    #canRetry: _f$canRetry,
  };

  static IdentityVerification _instantiate(DecodingData data) {
    return IdentityVerification(
      verificationId: data.dec(_f$verificationId),
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      status: data.dec(_f$status),
      submittedAt: data.dec(_f$submittedAt),
      reviewedAt: data.dec(_f$reviewedAt),
      reviewedBy: data.dec(_f$reviewedBy),
      rejectionReason: data.dec(_f$rejectionReason),
      documents: data.dec(_f$documents),
      badge: data.dec(_f$badge),
      attemptCount: data.dec(_f$attemptCount),
      nextAttemptAllowedAt: data.dec(_f$nextAttemptAllowedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static IdentityVerification fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<IdentityVerification>(map);
  }

  static IdentityVerification fromJson(String json) {
    return ensureInitialized().decodeJson<IdentityVerification>(json);
  }
}

mixin IdentityVerificationMappable {
  String toJson() {
    return IdentityVerificationMapper.ensureInitialized()
        .encodeJson<IdentityVerification>(this as IdentityVerification);
  }

  Map<String, dynamic> toMap() {
    return IdentityVerificationMapper.ensureInitialized()
        .encodeMap<IdentityVerification>(this as IdentityVerification);
  }

  IdentityVerificationCopyWith<
    IdentityVerification,
    IdentityVerification,
    IdentityVerification
  >
  get copyWith =>
      _IdentityVerificationCopyWithImpl<
        IdentityVerification,
        IdentityVerification
      >(this as IdentityVerification, $identity, $identity);
  @override
  String toString() {
    return IdentityVerificationMapper.ensureInitialized().stringifyValue(
      this as IdentityVerification,
    );
  }

  @override
  bool operator ==(Object other) {
    return IdentityVerificationMapper.ensureInitialized().equalsValue(
      this as IdentityVerification,
      other,
    );
  }

  @override
  int get hashCode {
    return IdentityVerificationMapper.ensureInitialized().hashValue(
      this as IdentityVerification,
    );
  }
}

extension IdentityVerificationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, IdentityVerification, $Out> {
  IdentityVerificationCopyWith<$R, IdentityVerification, $Out>
  get $asIdentityVerification => $base.as(
    (v, t, t2) => _IdentityVerificationCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class IdentityVerificationCopyWith<
  $R,
  $In extends IdentityVerification,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    VerificationDocument,
    VerificationDocumentCopyWith<$R, VerificationDocument, VerificationDocument>
  >
  get documents;
  VerificationBadgeCopyWith<$R, VerificationBadge, VerificationBadge>?
  get badge;
  $R call({
    String? verificationId,
    String? userId,
    VerificationType? type,
    VerificationStatus? status,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
    List<VerificationDocument>? documents,
    VerificationBadge? badge,
    int? attemptCount,
    DateTime? nextAttemptAllowedAt,
  });
  IdentityVerificationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _IdentityVerificationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, IdentityVerification, $Out>
    implements IdentityVerificationCopyWith<$R, IdentityVerification, $Out> {
  _IdentityVerificationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<IdentityVerification> $mapper =
      IdentityVerificationMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    VerificationDocument,
    VerificationDocumentCopyWith<$R, VerificationDocument, VerificationDocument>
  >
  get documents => ListCopyWith(
    $value.documents,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(documents: v),
  );
  @override
  VerificationBadgeCopyWith<$R, VerificationBadge, VerificationBadge>?
  get badge => $value.badge?.copyWith.$chain((v) => call(badge: v));
  @override
  $R call({
    String? verificationId,
    String? userId,
    VerificationType? type,
    VerificationStatus? status,
    DateTime? submittedAt,
    Object? reviewedAt = $none,
    Object? reviewedBy = $none,
    Object? rejectionReason = $none,
    List<VerificationDocument>? documents,
    Object? badge = $none,
    int? attemptCount,
    Object? nextAttemptAllowedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (verificationId != null) #verificationId: verificationId,
      if (userId != null) #userId: userId,
      if (type != null) #type: type,
      if (status != null) #status: status,
      if (submittedAt != null) #submittedAt: submittedAt,
      if (reviewedAt != $none) #reviewedAt: reviewedAt,
      if (reviewedBy != $none) #reviewedBy: reviewedBy,
      if (rejectionReason != $none) #rejectionReason: rejectionReason,
      if (documents != null) #documents: documents,
      if (badge != $none) #badge: badge,
      if (attemptCount != null) #attemptCount: attemptCount,
      if (nextAttemptAllowedAt != $none)
        #nextAttemptAllowedAt: nextAttemptAllowedAt,
    }),
  );
  @override
  IdentityVerification $make(CopyWithData data) => IdentityVerification(
    verificationId: data.get(#verificationId, or: $value.verificationId),
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    status: data.get(#status, or: $value.status),
    submittedAt: data.get(#submittedAt, or: $value.submittedAt),
    reviewedAt: data.get(#reviewedAt, or: $value.reviewedAt),
    reviewedBy: data.get(#reviewedBy, or: $value.reviewedBy),
    rejectionReason: data.get(#rejectionReason, or: $value.rejectionReason),
    documents: data.get(#documents, or: $value.documents),
    badge: data.get(#badge, or: $value.badge),
    attemptCount: data.get(#attemptCount, or: $value.attemptCount),
    nextAttemptAllowedAt: data.get(
      #nextAttemptAllowedAt,
      or: $value.nextAttemptAllowedAt,
    ),
  );

  @override
  IdentityVerificationCopyWith<$R2, IdentityVerification, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _IdentityVerificationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VerificationDocumentMapper extends ClassMapperBase<VerificationDocument> {
  VerificationDocumentMapper._();

  static VerificationDocumentMapper? _instance;
  static VerificationDocumentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VerificationDocumentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VerificationDocument';

  static String _$documentId(VerificationDocument v) => v.documentId;
  static const Field<VerificationDocument, String> _f$documentId = Field(
    'documentId',
    _$documentId,
  );
  static DocumentType _$type(VerificationDocument v) => v.type;
  static const Field<VerificationDocument, DocumentType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$fileUrl(VerificationDocument v) => v.fileUrl;
  static const Field<VerificationDocument, String> _f$fileUrl = Field(
    'fileUrl',
    _$fileUrl,
  );
  static String? _$fileHash(VerificationDocument v) => v.fileHash;
  static const Field<VerificationDocument, String> _f$fileHash = Field(
    'fileHash',
    _$fileHash,
    opt: true,
  );
  static DateTime _$uploadedAt(VerificationDocument v) => v.uploadedAt;
  static const Field<VerificationDocument, DateTime> _f$uploadedAt = Field(
    'uploadedAt',
    _$uploadedAt,
  );
  static Map<String, dynamic> _$metadata(VerificationDocument v) => v.metadata;
  static const Field<VerificationDocument, Map<String, dynamic>> _f$metadata =
      Field('metadata', _$metadata, opt: true, def: const {});

  @override
  final MappableFields<VerificationDocument> fields = const {
    #documentId: _f$documentId,
    #type: _f$type,
    #fileUrl: _f$fileUrl,
    #fileHash: _f$fileHash,
    #uploadedAt: _f$uploadedAt,
    #metadata: _f$metadata,
  };

  static VerificationDocument _instantiate(DecodingData data) {
    return VerificationDocument(
      documentId: data.dec(_f$documentId),
      type: data.dec(_f$type),
      fileUrl: data.dec(_f$fileUrl),
      fileHash: data.dec(_f$fileHash),
      uploadedAt: data.dec(_f$uploadedAt),
      metadata: data.dec(_f$metadata),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VerificationDocument fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VerificationDocument>(map);
  }

  static VerificationDocument fromJson(String json) {
    return ensureInitialized().decodeJson<VerificationDocument>(json);
  }
}

mixin VerificationDocumentMappable {
  String toJson() {
    return VerificationDocumentMapper.ensureInitialized()
        .encodeJson<VerificationDocument>(this as VerificationDocument);
  }

  Map<String, dynamic> toMap() {
    return VerificationDocumentMapper.ensureInitialized()
        .encodeMap<VerificationDocument>(this as VerificationDocument);
  }

  VerificationDocumentCopyWith<
    VerificationDocument,
    VerificationDocument,
    VerificationDocument
  >
  get copyWith =>
      _VerificationDocumentCopyWithImpl<
        VerificationDocument,
        VerificationDocument
      >(this as VerificationDocument, $identity, $identity);
  @override
  String toString() {
    return VerificationDocumentMapper.ensureInitialized().stringifyValue(
      this as VerificationDocument,
    );
  }

  @override
  bool operator ==(Object other) {
    return VerificationDocumentMapper.ensureInitialized().equalsValue(
      this as VerificationDocument,
      other,
    );
  }

  @override
  int get hashCode {
    return VerificationDocumentMapper.ensureInitialized().hashValue(
      this as VerificationDocument,
    );
  }
}

extension VerificationDocumentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VerificationDocument, $Out> {
  VerificationDocumentCopyWith<$R, VerificationDocument, $Out>
  get $asVerificationDocument => $base.as(
    (v, t, t2) => _VerificationDocumentCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VerificationDocumentCopyWith<
  $R,
  $In extends VerificationDocument,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata;
  $R call({
    String? documentId,
    DocumentType? type,
    String? fileUrl,
    String? fileHash,
    DateTime? uploadedAt,
    Map<String, dynamic>? metadata,
  });
  VerificationDocumentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VerificationDocumentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VerificationDocument, $Out>
    implements VerificationDocumentCopyWith<$R, VerificationDocument, $Out> {
  _VerificationDocumentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VerificationDocument> $mapper =
      VerificationDocumentMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata => MapCopyWith(
    $value.metadata,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(metadata: v),
  );
  @override
  $R call({
    String? documentId,
    DocumentType? type,
    String? fileUrl,
    Object? fileHash = $none,
    DateTime? uploadedAt,
    Map<String, dynamic>? metadata,
  }) => $apply(
    FieldCopyWithData({
      if (documentId != null) #documentId: documentId,
      if (type != null) #type: type,
      if (fileUrl != null) #fileUrl: fileUrl,
      if (fileHash != $none) #fileHash: fileHash,
      if (uploadedAt != null) #uploadedAt: uploadedAt,
      if (metadata != null) #metadata: metadata,
    }),
  );
  @override
  VerificationDocument $make(CopyWithData data) => VerificationDocument(
    documentId: data.get(#documentId, or: $value.documentId),
    type: data.get(#type, or: $value.type),
    fileUrl: data.get(#fileUrl, or: $value.fileUrl),
    fileHash: data.get(#fileHash, or: $value.fileHash),
    uploadedAt: data.get(#uploadedAt, or: $value.uploadedAt),
    metadata: data.get(#metadata, or: $value.metadata),
  );

  @override
  VerificationDocumentCopyWith<$R2, VerificationDocument, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _VerificationDocumentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VerificationBadgeMapper extends ClassMapperBase<VerificationBadge> {
  VerificationBadgeMapper._();

  static VerificationBadgeMapper? _instance;
  static VerificationBadgeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VerificationBadgeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VerificationBadge';

  static String _$badgeId(VerificationBadge v) => v.badgeId;
  static const Field<VerificationBadge, String> _f$badgeId = Field(
    'badgeId',
    _$badgeId,
  );
  static BadgeLevel _$level(VerificationBadge v) => v.level;
  static const Field<VerificationBadge, BadgeLevel> _f$level = Field(
    'level',
    _$level,
  );
  static DateTime _$issuedAt(VerificationBadge v) => v.issuedAt;
  static const Field<VerificationBadge, DateTime> _f$issuedAt = Field(
    'issuedAt',
    _$issuedAt,
  );
  static DateTime _$expiresAt(VerificationBadge v) => v.expiresAt;
  static const Field<VerificationBadge, DateTime> _f$expiresAt = Field(
    'expiresAt',
    _$expiresAt,
  );
  static Set<VerificationType> _$verificationsCompleted(VerificationBadge v) =>
      v.verificationsCompleted;
  static const Field<VerificationBadge, Set<VerificationType>>
  _f$verificationsCompleted = Field(
    'verificationsCompleted',
    _$verificationsCompleted,
  );
  static int _$trustScore(VerificationBadge v) => v.trustScore;
  static const Field<VerificationBadge, int> _f$trustScore = Field(
    'trustScore',
    _$trustScore,
  );
  static bool _$isExpired(VerificationBadge v) => v.isExpired;
  static const Field<VerificationBadge, bool> _f$isExpired = Field(
    'isExpired',
    _$isExpired,
    mode: FieldMode.member,
  );
  static bool _$needsRenewal(VerificationBadge v) => v.needsRenewal;
  static const Field<VerificationBadge, bool> _f$needsRenewal = Field(
    'needsRenewal',
    _$needsRenewal,
    mode: FieldMode.member,
  );
  static String _$color(VerificationBadge v) => v.color;
  static const Field<VerificationBadge, String> _f$color = Field(
    'color',
    _$color,
    mode: FieldMode.member,
  );
  static String _$icon(VerificationBadge v) => v.icon;
  static const Field<VerificationBadge, String> _f$icon = Field(
    'icon',
    _$icon,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<VerificationBadge> fields = const {
    #badgeId: _f$badgeId,
    #level: _f$level,
    #issuedAt: _f$issuedAt,
    #expiresAt: _f$expiresAt,
    #verificationsCompleted: _f$verificationsCompleted,
    #trustScore: _f$trustScore,
    #isExpired: _f$isExpired,
    #needsRenewal: _f$needsRenewal,
    #color: _f$color,
    #icon: _f$icon,
  };

  static VerificationBadge _instantiate(DecodingData data) {
    return VerificationBadge(
      badgeId: data.dec(_f$badgeId),
      level: data.dec(_f$level),
      issuedAt: data.dec(_f$issuedAt),
      expiresAt: data.dec(_f$expiresAt),
      verificationsCompleted: data.dec(_f$verificationsCompleted),
      trustScore: data.dec(_f$trustScore),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VerificationBadge fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VerificationBadge>(map);
  }

  static VerificationBadge fromJson(String json) {
    return ensureInitialized().decodeJson<VerificationBadge>(json);
  }
}

mixin VerificationBadgeMappable {
  String toJson() {
    return VerificationBadgeMapper.ensureInitialized()
        .encodeJson<VerificationBadge>(this as VerificationBadge);
  }

  Map<String, dynamic> toMap() {
    return VerificationBadgeMapper.ensureInitialized()
        .encodeMap<VerificationBadge>(this as VerificationBadge);
  }

  VerificationBadgeCopyWith<
    VerificationBadge,
    VerificationBadge,
    VerificationBadge
  >
  get copyWith =>
      _VerificationBadgeCopyWithImpl<VerificationBadge, VerificationBadge>(
        this as VerificationBadge,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VerificationBadgeMapper.ensureInitialized().stringifyValue(
      this as VerificationBadge,
    );
  }

  @override
  bool operator ==(Object other) {
    return VerificationBadgeMapper.ensureInitialized().equalsValue(
      this as VerificationBadge,
      other,
    );
  }

  @override
  int get hashCode {
    return VerificationBadgeMapper.ensureInitialized().hashValue(
      this as VerificationBadge,
    );
  }
}

extension VerificationBadgeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VerificationBadge, $Out> {
  VerificationBadgeCopyWith<$R, VerificationBadge, $Out>
  get $asVerificationBadge => $base.as(
    (v, t, t2) => _VerificationBadgeCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VerificationBadgeCopyWith<
  $R,
  $In extends VerificationBadge,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? badgeId,
    BadgeLevel? level,
    DateTime? issuedAt,
    DateTime? expiresAt,
    Set<VerificationType>? verificationsCompleted,
    int? trustScore,
  });
  VerificationBadgeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VerificationBadgeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VerificationBadge, $Out>
    implements VerificationBadgeCopyWith<$R, VerificationBadge, $Out> {
  _VerificationBadgeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VerificationBadge> $mapper =
      VerificationBadgeMapper.ensureInitialized();
  @override
  $R call({
    String? badgeId,
    BadgeLevel? level,
    DateTime? issuedAt,
    DateTime? expiresAt,
    Set<VerificationType>? verificationsCompleted,
    int? trustScore,
  }) => $apply(
    FieldCopyWithData({
      if (badgeId != null) #badgeId: badgeId,
      if (level != null) #level: level,
      if (issuedAt != null) #issuedAt: issuedAt,
      if (expiresAt != null) #expiresAt: expiresAt,
      if (verificationsCompleted != null)
        #verificationsCompleted: verificationsCompleted,
      if (trustScore != null) #trustScore: trustScore,
    }),
  );
  @override
  VerificationBadge $make(CopyWithData data) => VerificationBadge(
    badgeId: data.get(#badgeId, or: $value.badgeId),
    level: data.get(#level, or: $value.level),
    issuedAt: data.get(#issuedAt, or: $value.issuedAt),
    expiresAt: data.get(#expiresAt, or: $value.expiresAt),
    verificationsCompleted: data.get(
      #verificationsCompleted,
      or: $value.verificationsCompleted,
    ),
    trustScore: data.get(#trustScore, or: $value.trustScore),
  );

  @override
  VerificationBadgeCopyWith<$R2, VerificationBadge, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VerificationBadgeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VerificationRequestMapper extends ClassMapperBase<VerificationRequest> {
  VerificationRequestMapper._();

  static VerificationRequestMapper? _instance;
  static VerificationRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VerificationRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VerificationRequest';

  static String _$userId(VerificationRequest v) => v.userId;
  static const Field<VerificationRequest, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static VerificationType _$type(VerificationRequest v) => v.type;
  static const Field<VerificationRequest, VerificationType> _f$type = Field(
    'type',
    _$type,
  );
  static Map<String, dynamic> _$additionalData(VerificationRequest v) =>
      v.additionalData;
  static const Field<VerificationRequest, Map<String, dynamic>>
  _f$additionalData = Field(
    'additionalData',
    _$additionalData,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<VerificationRequest> fields = const {
    #userId: _f$userId,
    #type: _f$type,
    #additionalData: _f$additionalData,
  };

  static VerificationRequest _instantiate(DecodingData data) {
    return VerificationRequest(
      userId: data.dec(_f$userId),
      type: data.dec(_f$type),
      additionalData: data.dec(_f$additionalData),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VerificationRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VerificationRequest>(map);
  }

  static VerificationRequest fromJson(String json) {
    return ensureInitialized().decodeJson<VerificationRequest>(json);
  }
}

mixin VerificationRequestMappable {
  String toJson() {
    return VerificationRequestMapper.ensureInitialized()
        .encodeJson<VerificationRequest>(this as VerificationRequest);
  }

  Map<String, dynamic> toMap() {
    return VerificationRequestMapper.ensureInitialized()
        .encodeMap<VerificationRequest>(this as VerificationRequest);
  }

  VerificationRequestCopyWith<
    VerificationRequest,
    VerificationRequest,
    VerificationRequest
  >
  get copyWith =>
      _VerificationRequestCopyWithImpl<
        VerificationRequest,
        VerificationRequest
      >(this as VerificationRequest, $identity, $identity);
  @override
  String toString() {
    return VerificationRequestMapper.ensureInitialized().stringifyValue(
      this as VerificationRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return VerificationRequestMapper.ensureInitialized().equalsValue(
      this as VerificationRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return VerificationRequestMapper.ensureInitialized().hashValue(
      this as VerificationRequest,
    );
  }
}

extension VerificationRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VerificationRequest, $Out> {
  VerificationRequestCopyWith<$R, VerificationRequest, $Out>
  get $asVerificationRequest => $base.as(
    (v, t, t2) => _VerificationRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VerificationRequestCopyWith<
  $R,
  $In extends VerificationRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get additionalData;
  $R call({
    String? userId,
    VerificationType? type,
    Map<String, dynamic>? additionalData,
  });
  VerificationRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VerificationRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VerificationRequest, $Out>
    implements VerificationRequestCopyWith<$R, VerificationRequest, $Out> {
  _VerificationRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VerificationRequest> $mapper =
      VerificationRequestMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get additionalData => MapCopyWith(
    $value.additionalData,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(additionalData: v),
  );
  @override
  $R call({
    String? userId,
    VerificationType? type,
    Map<String, dynamic>? additionalData,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (type != null) #type: type,
      if (additionalData != null) #additionalData: additionalData,
    }),
  );
  @override
  VerificationRequest $make(CopyWithData data) => VerificationRequest(
    userId: data.get(#userId, or: $value.userId),
    type: data.get(#type, or: $value.type),
    additionalData: data.get(#additionalData, or: $value.additionalData),
  );

  @override
  VerificationRequestCopyWith<$R2, VerificationRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _VerificationRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VerificationResultMapper extends ClassMapperBase<VerificationResult> {
  VerificationResultMapper._();

  static VerificationResultMapper? _instance;
  static VerificationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VerificationResultMapper._());
      VerificationBadgeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'VerificationResult';

  static bool _$success(VerificationResult v) => v.success;
  static const Field<VerificationResult, bool> _f$success = Field(
    'success',
    _$success,
  );
  static String? _$verificationId(VerificationResult v) => v.verificationId;
  static const Field<VerificationResult, String> _f$verificationId = Field(
    'verificationId',
    _$verificationId,
    opt: true,
  );
  static VerificationStatus? _$status(VerificationResult v) => v.status;
  static const Field<VerificationResult, VerificationStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
  );
  static String? _$message(VerificationResult v) => v.message;
  static const Field<VerificationResult, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
  );
  static VerificationBadge? _$badge(VerificationResult v) => v.badge;
  static const Field<VerificationResult, VerificationBadge> _f$badge = Field(
    'badge',
    _$badge,
    opt: true,
  );
  static List<String> _$nextSteps(VerificationResult v) => v.nextSteps;
  static const Field<VerificationResult, List<String>> _f$nextSteps = Field(
    'nextSteps',
    _$nextSteps,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<VerificationResult> fields = const {
    #success: _f$success,
    #verificationId: _f$verificationId,
    #status: _f$status,
    #message: _f$message,
    #badge: _f$badge,
    #nextSteps: _f$nextSteps,
  };

  static VerificationResult _instantiate(DecodingData data) {
    return VerificationResult(
      success: data.dec(_f$success),
      verificationId: data.dec(_f$verificationId),
      status: data.dec(_f$status),
      message: data.dec(_f$message),
      badge: data.dec(_f$badge),
      nextSteps: data.dec(_f$nextSteps),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VerificationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VerificationResult>(map);
  }

  static VerificationResult fromJson(String json) {
    return ensureInitialized().decodeJson<VerificationResult>(json);
  }
}

mixin VerificationResultMappable {
  String toJson() {
    return VerificationResultMapper.ensureInitialized()
        .encodeJson<VerificationResult>(this as VerificationResult);
  }

  Map<String, dynamic> toMap() {
    return VerificationResultMapper.ensureInitialized()
        .encodeMap<VerificationResult>(this as VerificationResult);
  }

  VerificationResultCopyWith<
    VerificationResult,
    VerificationResult,
    VerificationResult
  >
  get copyWith =>
      _VerificationResultCopyWithImpl<VerificationResult, VerificationResult>(
        this as VerificationResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VerificationResultMapper.ensureInitialized().stringifyValue(
      this as VerificationResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return VerificationResultMapper.ensureInitialized().equalsValue(
      this as VerificationResult,
      other,
    );
  }

  @override
  int get hashCode {
    return VerificationResultMapper.ensureInitialized().hashValue(
      this as VerificationResult,
    );
  }
}

extension VerificationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VerificationResult, $Out> {
  VerificationResultCopyWith<$R, VerificationResult, $Out>
  get $asVerificationResult => $base.as(
    (v, t, t2) => _VerificationResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VerificationResultCopyWith<
  $R,
  $In extends VerificationResult,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  VerificationBadgeCopyWith<$R, VerificationBadge, VerificationBadge>?
  get badge;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get nextSteps;
  $R call({
    bool? success,
    String? verificationId,
    VerificationStatus? status,
    String? message,
    VerificationBadge? badge,
    List<String>? nextSteps,
  });
  VerificationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VerificationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VerificationResult, $Out>
    implements VerificationResultCopyWith<$R, VerificationResult, $Out> {
  _VerificationResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VerificationResult> $mapper =
      VerificationResultMapper.ensureInitialized();
  @override
  VerificationBadgeCopyWith<$R, VerificationBadge, VerificationBadge>?
  get badge => $value.badge?.copyWith.$chain((v) => call(badge: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get nextSteps =>
      ListCopyWith(
        $value.nextSteps,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(nextSteps: v),
      );
  @override
  $R call({
    bool? success,
    Object? verificationId = $none,
    Object? status = $none,
    Object? message = $none,
    Object? badge = $none,
    List<String>? nextSteps,
  }) => $apply(
    FieldCopyWithData({
      if (success != null) #success: success,
      if (verificationId != $none) #verificationId: verificationId,
      if (status != $none) #status: status,
      if (message != $none) #message: message,
      if (badge != $none) #badge: badge,
      if (nextSteps != null) #nextSteps: nextSteps,
    }),
  );
  @override
  VerificationResult $make(CopyWithData data) => VerificationResult(
    success: data.get(#success, or: $value.success),
    verificationId: data.get(#verificationId, or: $value.verificationId),
    status: data.get(#status, or: $value.status),
    message: data.get(#message, or: $value.message),
    badge: data.get(#badge, or: $value.badge),
    nextSteps: data.get(#nextSteps, or: $value.nextSteps),
  );

  @override
  VerificationResultCopyWith<$R2, VerificationResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VerificationResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VerificationStatsMapper extends ClassMapperBase<VerificationStats> {
  VerificationStatsMapper._();

  static VerificationStatsMapper? _instance;
  static VerificationStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VerificationStatsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VerificationStats';

  static int _$totalVerifications(VerificationStats v) => v.totalVerifications;
  static const Field<VerificationStats, int> _f$totalVerifications = Field(
    'totalVerifications',
    _$totalVerifications,
  );
  static int _$approvedCount(VerificationStats v) => v.approvedCount;
  static const Field<VerificationStats, int> _f$approvedCount = Field(
    'approvedCount',
    _$approvedCount,
  );
  static int _$rejectedCount(VerificationStats v) => v.rejectedCount;
  static const Field<VerificationStats, int> _f$rejectedCount = Field(
    'rejectedCount',
    _$rejectedCount,
  );
  static int _$pendingCount(VerificationStats v) => v.pendingCount;
  static const Field<VerificationStats, int> _f$pendingCount = Field(
    'pendingCount',
    _$pendingCount,
  );
  static double _$approvalRate(VerificationStats v) => v.approvalRate;
  static const Field<VerificationStats, double> _f$approvalRate = Field(
    'approvalRate',
    _$approvalRate,
  );
  static Map<VerificationType, int> _$verificationsByType(
    VerificationStats v,
  ) => v.verificationsByType;
  static const Field<VerificationStats, Map<VerificationType, int>>
  _f$verificationsByType = Field('verificationsByType', _$verificationsByType);
  static DateTime _$lastVerifiedAt(VerificationStats v) => v.lastVerifiedAt;
  static const Field<VerificationStats, DateTime> _f$lastVerifiedAt = Field(
    'lastVerifiedAt',
    _$lastVerifiedAt,
  );

  @override
  final MappableFields<VerificationStats> fields = const {
    #totalVerifications: _f$totalVerifications,
    #approvedCount: _f$approvedCount,
    #rejectedCount: _f$rejectedCount,
    #pendingCount: _f$pendingCount,
    #approvalRate: _f$approvalRate,
    #verificationsByType: _f$verificationsByType,
    #lastVerifiedAt: _f$lastVerifiedAt,
  };

  static VerificationStats _instantiate(DecodingData data) {
    return VerificationStats(
      totalVerifications: data.dec(_f$totalVerifications),
      approvedCount: data.dec(_f$approvedCount),
      rejectedCount: data.dec(_f$rejectedCount),
      pendingCount: data.dec(_f$pendingCount),
      approvalRate: data.dec(_f$approvalRate),
      verificationsByType: data.dec(_f$verificationsByType),
      lastVerifiedAt: data.dec(_f$lastVerifiedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VerificationStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VerificationStats>(map);
  }

  static VerificationStats fromJson(String json) {
    return ensureInitialized().decodeJson<VerificationStats>(json);
  }
}

mixin VerificationStatsMappable {
  String toJson() {
    return VerificationStatsMapper.ensureInitialized()
        .encodeJson<VerificationStats>(this as VerificationStats);
  }

  Map<String, dynamic> toMap() {
    return VerificationStatsMapper.ensureInitialized()
        .encodeMap<VerificationStats>(this as VerificationStats);
  }

  VerificationStatsCopyWith<
    VerificationStats,
    VerificationStats,
    VerificationStats
  >
  get copyWith =>
      _VerificationStatsCopyWithImpl<VerificationStats, VerificationStats>(
        this as VerificationStats,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VerificationStatsMapper.ensureInitialized().stringifyValue(
      this as VerificationStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return VerificationStatsMapper.ensureInitialized().equalsValue(
      this as VerificationStats,
      other,
    );
  }

  @override
  int get hashCode {
    return VerificationStatsMapper.ensureInitialized().hashValue(
      this as VerificationStats,
    );
  }
}

extension VerificationStatsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VerificationStats, $Out> {
  VerificationStatsCopyWith<$R, VerificationStats, $Out>
  get $asVerificationStats => $base.as(
    (v, t, t2) => _VerificationStatsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VerificationStatsCopyWith<
  $R,
  $In extends VerificationStats,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, VerificationType, int, ObjectCopyWith<$R, int, int>>
  get verificationsByType;
  $R call({
    int? totalVerifications,
    int? approvedCount,
    int? rejectedCount,
    int? pendingCount,
    double? approvalRate,
    Map<VerificationType, int>? verificationsByType,
    DateTime? lastVerifiedAt,
  });
  VerificationStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VerificationStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VerificationStats, $Out>
    implements VerificationStatsCopyWith<$R, VerificationStats, $Out> {
  _VerificationStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VerificationStats> $mapper =
      VerificationStatsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, VerificationType, int, ObjectCopyWith<$R, int, int>>
  get verificationsByType => MapCopyWith(
    $value.verificationsByType,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(verificationsByType: v),
  );
  @override
  $R call({
    int? totalVerifications,
    int? approvedCount,
    int? rejectedCount,
    int? pendingCount,
    double? approvalRate,
    Map<VerificationType, int>? verificationsByType,
    DateTime? lastVerifiedAt,
  }) => $apply(
    FieldCopyWithData({
      if (totalVerifications != null) #totalVerifications: totalVerifications,
      if (approvedCount != null) #approvedCount: approvedCount,
      if (rejectedCount != null) #rejectedCount: rejectedCount,
      if (pendingCount != null) #pendingCount: pendingCount,
      if (approvalRate != null) #approvalRate: approvalRate,
      if (verificationsByType != null)
        #verificationsByType: verificationsByType,
      if (lastVerifiedAt != null) #lastVerifiedAt: lastVerifiedAt,
    }),
  );
  @override
  VerificationStats $make(CopyWithData data) => VerificationStats(
    totalVerifications: data.get(
      #totalVerifications,
      or: $value.totalVerifications,
    ),
    approvedCount: data.get(#approvedCount, or: $value.approvedCount),
    rejectedCount: data.get(#rejectedCount, or: $value.rejectedCount),
    pendingCount: data.get(#pendingCount, or: $value.pendingCount),
    approvalRate: data.get(#approvalRate, or: $value.approvalRate),
    verificationsByType: data.get(
      #verificationsByType,
      or: $value.verificationsByType,
    ),
    lastVerifiedAt: data.get(#lastVerifiedAt, or: $value.lastVerifiedAt),
  );

  @override
  VerificationStatsCopyWith<$R2, VerificationStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VerificationStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

