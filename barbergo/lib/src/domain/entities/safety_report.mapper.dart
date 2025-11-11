// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'safety_report.dart';

class SafetyReportMapper extends ClassMapperBase<SafetyReport> {
  SafetyReportMapper._();

  static SafetyReportMapper? _instance;
  static SafetyReportMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SafetyReportMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SafetyReport';

  static String _$reportId(SafetyReport v) => v.reportId;
  static const Field<SafetyReport, String> _f$reportId = Field(
    'reportId',
    _$reportId,
  );
  static String _$reporterId(SafetyReport v) => v.reporterId;
  static const Field<SafetyReport, String> _f$reporterId = Field(
    'reporterId',
    _$reporterId,
  );
  static String _$reportedUserId(SafetyReport v) => v.reportedUserId;
  static const Field<SafetyReport, String> _f$reportedUserId = Field(
    'reportedUserId',
    _$reportedUserId,
  );
  static ReportReason _$reason(SafetyReport v) => v.reason;
  static const Field<SafetyReport, ReportReason> _f$reason = Field(
    'reason',
    _$reason,
  );
  static String? _$customReason(SafetyReport v) => v.customReason;
  static const Field<SafetyReport, String> _f$customReason = Field(
    'customReason',
    _$customReason,
    opt: true,
  );
  static List<String> _$evidenceUrls(SafetyReport v) => v.evidenceUrls;
  static const Field<SafetyReport, List<String>> _f$evidenceUrls = Field(
    'evidenceUrls',
    _$evidenceUrls,
    opt: true,
    def: const [],
  );
  static DateTime _$createdAt(SafetyReport v) => v.createdAt;
  static const Field<SafetyReport, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static ReportStatus _$status(SafetyReport v) => v.status;
  static const Field<SafetyReport, ReportStatus> _f$status = Field(
    'status',
    _$status,
  );
  static String? _$reviewedBy(SafetyReport v) => v.reviewedBy;
  static const Field<SafetyReport, String> _f$reviewedBy = Field(
    'reviewedBy',
    _$reviewedBy,
    opt: true,
  );
  static DateTime? _$reviewedAt(SafetyReport v) => v.reviewedAt;
  static const Field<SafetyReport, DateTime> _f$reviewedAt = Field(
    'reviewedAt',
    _$reviewedAt,
    opt: true,
  );
  static ReportAction? _$action(SafetyReport v) => v.action;
  static const Field<SafetyReport, ReportAction> _f$action = Field(
    'action',
    _$action,
    opt: true,
  );
  static String? _$reviewNotes(SafetyReport v) => v.reviewNotes;
  static const Field<SafetyReport, String> _f$reviewNotes = Field(
    'reviewNotes',
    _$reviewNotes,
    opt: true,
  );
  static ReportSeverity _$severity(SafetyReport v) => v.severity;
  static const Field<SafetyReport, ReportSeverity> _f$severity = Field(
    'severity',
    _$severity,
    opt: true,
    def: ReportSeverity.medium,
  );

  @override
  final MappableFields<SafetyReport> fields = const {
    #reportId: _f$reportId,
    #reporterId: _f$reporterId,
    #reportedUserId: _f$reportedUserId,
    #reason: _f$reason,
    #customReason: _f$customReason,
    #evidenceUrls: _f$evidenceUrls,
    #createdAt: _f$createdAt,
    #status: _f$status,
    #reviewedBy: _f$reviewedBy,
    #reviewedAt: _f$reviewedAt,
    #action: _f$action,
    #reviewNotes: _f$reviewNotes,
    #severity: _f$severity,
  };

  static SafetyReport _instantiate(DecodingData data) {
    return SafetyReport(
      reportId: data.dec(_f$reportId),
      reporterId: data.dec(_f$reporterId),
      reportedUserId: data.dec(_f$reportedUserId),
      reason: data.dec(_f$reason),
      customReason: data.dec(_f$customReason),
      evidenceUrls: data.dec(_f$evidenceUrls),
      createdAt: data.dec(_f$createdAt),
      status: data.dec(_f$status),
      reviewedBy: data.dec(_f$reviewedBy),
      reviewedAt: data.dec(_f$reviewedAt),
      action: data.dec(_f$action),
      reviewNotes: data.dec(_f$reviewNotes),
      severity: data.dec(_f$severity),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SafetyReport fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SafetyReport>(map);
  }

  static SafetyReport fromJson(String json) {
    return ensureInitialized().decodeJson<SafetyReport>(json);
  }
}

mixin SafetyReportMappable {
  String toJson() {
    return SafetyReportMapper.ensureInitialized().encodeJson<SafetyReport>(
      this as SafetyReport,
    );
  }

  Map<String, dynamic> toMap() {
    return SafetyReportMapper.ensureInitialized().encodeMap<SafetyReport>(
      this as SafetyReport,
    );
  }

  SafetyReportCopyWith<SafetyReport, SafetyReport, SafetyReport> get copyWith =>
      _SafetyReportCopyWithImpl<SafetyReport, SafetyReport>(
        this as SafetyReport,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SafetyReportMapper.ensureInitialized().stringifyValue(
      this as SafetyReport,
    );
  }

  @override
  bool operator ==(Object other) {
    return SafetyReportMapper.ensureInitialized().equalsValue(
      this as SafetyReport,
      other,
    );
  }

  @override
  int get hashCode {
    return SafetyReportMapper.ensureInitialized().hashValue(
      this as SafetyReport,
    );
  }
}

extension SafetyReportValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SafetyReport, $Out> {
  SafetyReportCopyWith<$R, SafetyReport, $Out> get $asSafetyReport =>
      $base.as((v, t, t2) => _SafetyReportCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SafetyReportCopyWith<$R, $In extends SafetyReport, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get evidenceUrls;
  $R call({
    String? reportId,
    String? reporterId,
    String? reportedUserId,
    ReportReason? reason,
    String? customReason,
    List<String>? evidenceUrls,
    DateTime? createdAt,
    ReportStatus? status,
    String? reviewedBy,
    DateTime? reviewedAt,
    ReportAction? action,
    String? reviewNotes,
    ReportSeverity? severity,
  });
  SafetyReportCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SafetyReportCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SafetyReport, $Out>
    implements SafetyReportCopyWith<$R, SafetyReport, $Out> {
  _SafetyReportCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SafetyReport> $mapper =
      SafetyReportMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get evidenceUrls => ListCopyWith(
    $value.evidenceUrls,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(evidenceUrls: v),
  );
  @override
  $R call({
    String? reportId,
    String? reporterId,
    String? reportedUserId,
    ReportReason? reason,
    Object? customReason = $none,
    List<String>? evidenceUrls,
    DateTime? createdAt,
    ReportStatus? status,
    Object? reviewedBy = $none,
    Object? reviewedAt = $none,
    Object? action = $none,
    Object? reviewNotes = $none,
    ReportSeverity? severity,
  }) => $apply(
    FieldCopyWithData({
      if (reportId != null) #reportId: reportId,
      if (reporterId != null) #reporterId: reporterId,
      if (reportedUserId != null) #reportedUserId: reportedUserId,
      if (reason != null) #reason: reason,
      if (customReason != $none) #customReason: customReason,
      if (evidenceUrls != null) #evidenceUrls: evidenceUrls,
      if (createdAt != null) #createdAt: createdAt,
      if (status != null) #status: status,
      if (reviewedBy != $none) #reviewedBy: reviewedBy,
      if (reviewedAt != $none) #reviewedAt: reviewedAt,
      if (action != $none) #action: action,
      if (reviewNotes != $none) #reviewNotes: reviewNotes,
      if (severity != null) #severity: severity,
    }),
  );
  @override
  SafetyReport $make(CopyWithData data) => SafetyReport(
    reportId: data.get(#reportId, or: $value.reportId),
    reporterId: data.get(#reporterId, or: $value.reporterId),
    reportedUserId: data.get(#reportedUserId, or: $value.reportedUserId),
    reason: data.get(#reason, or: $value.reason),
    customReason: data.get(#customReason, or: $value.customReason),
    evidenceUrls: data.get(#evidenceUrls, or: $value.evidenceUrls),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    status: data.get(#status, or: $value.status),
    reviewedBy: data.get(#reviewedBy, or: $value.reviewedBy),
    reviewedAt: data.get(#reviewedAt, or: $value.reviewedAt),
    action: data.get(#action, or: $value.action),
    reviewNotes: data.get(#reviewNotes, or: $value.reviewNotes),
    severity: data.get(#severity, or: $value.severity),
  );

  @override
  SafetyReportCopyWith<$R2, SafetyReport, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SafetyReportCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UserBlockMapper extends ClassMapperBase<UserBlock> {
  UserBlockMapper._();

  static UserBlockMapper? _instance;
  static UserBlockMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserBlockMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserBlock';

  static String _$blockId(UserBlock v) => v.blockId;
  static const Field<UserBlock, String> _f$blockId = Field(
    'blockId',
    _$blockId,
  );
  static String _$blockerId(UserBlock v) => v.blockerId;
  static const Field<UserBlock, String> _f$blockerId = Field(
    'blockerId',
    _$blockerId,
  );
  static String _$blockedUserId(UserBlock v) => v.blockedUserId;
  static const Field<UserBlock, String> _f$blockedUserId = Field(
    'blockedUserId',
    _$blockedUserId,
  );
  static DateTime _$blockedAt(UserBlock v) => v.blockedAt;
  static const Field<UserBlock, DateTime> _f$blockedAt = Field(
    'blockedAt',
    _$blockedAt,
  );
  static String? _$reason(UserBlock v) => v.reason;
  static const Field<UserBlock, String> _f$reason = Field(
    'reason',
    _$reason,
    opt: true,
  );

  @override
  final MappableFields<UserBlock> fields = const {
    #blockId: _f$blockId,
    #blockerId: _f$blockerId,
    #blockedUserId: _f$blockedUserId,
    #blockedAt: _f$blockedAt,
    #reason: _f$reason,
  };

  static UserBlock _instantiate(DecodingData data) {
    return UserBlock(
      blockId: data.dec(_f$blockId),
      blockerId: data.dec(_f$blockerId),
      blockedUserId: data.dec(_f$blockedUserId),
      blockedAt: data.dec(_f$blockedAt),
      reason: data.dec(_f$reason),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserBlock fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserBlock>(map);
  }

  static UserBlock fromJson(String json) {
    return ensureInitialized().decodeJson<UserBlock>(json);
  }
}

mixin UserBlockMappable {
  String toJson() {
    return UserBlockMapper.ensureInitialized().encodeJson<UserBlock>(
      this as UserBlock,
    );
  }

  Map<String, dynamic> toMap() {
    return UserBlockMapper.ensureInitialized().encodeMap<UserBlock>(
      this as UserBlock,
    );
  }

  UserBlockCopyWith<UserBlock, UserBlock, UserBlock> get copyWith =>
      _UserBlockCopyWithImpl<UserBlock, UserBlock>(
        this as UserBlock,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserBlockMapper.ensureInitialized().stringifyValue(
      this as UserBlock,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserBlockMapper.ensureInitialized().equalsValue(
      this as UserBlock,
      other,
    );
  }

  @override
  int get hashCode {
    return UserBlockMapper.ensureInitialized().hashValue(this as UserBlock);
  }
}

extension UserBlockValueCopy<$R, $Out> on ObjectCopyWith<$R, UserBlock, $Out> {
  UserBlockCopyWith<$R, UserBlock, $Out> get $asUserBlock =>
      $base.as((v, t, t2) => _UserBlockCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserBlockCopyWith<$R, $In extends UserBlock, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? blockId,
    String? blockerId,
    String? blockedUserId,
    DateTime? blockedAt,
    String? reason,
  });
  UserBlockCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserBlockCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserBlock, $Out>
    implements UserBlockCopyWith<$R, UserBlock, $Out> {
  _UserBlockCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserBlock> $mapper =
      UserBlockMapper.ensureInitialized();
  @override
  $R call({
    String? blockId,
    String? blockerId,
    String? blockedUserId,
    DateTime? blockedAt,
    Object? reason = $none,
  }) => $apply(
    FieldCopyWithData({
      if (blockId != null) #blockId: blockId,
      if (blockerId != null) #blockerId: blockerId,
      if (blockedUserId != null) #blockedUserId: blockedUserId,
      if (blockedAt != null) #blockedAt: blockedAt,
      if (reason != $none) #reason: reason,
    }),
  );
  @override
  UserBlock $make(CopyWithData data) => UserBlock(
    blockId: data.get(#blockId, or: $value.blockId),
    blockerId: data.get(#blockerId, or: $value.blockerId),
    blockedUserId: data.get(#blockedUserId, or: $value.blockedUserId),
    blockedAt: data.get(#blockedAt, or: $value.blockedAt),
    reason: data.get(#reason, or: $value.reason),
  );

  @override
  UserBlockCopyWith<$R2, UserBlock, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserBlockCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EmergencyContactMapper extends ClassMapperBase<EmergencyContact> {
  EmergencyContactMapper._();

  static EmergencyContactMapper? _instance;
  static EmergencyContactMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EmergencyContactMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'EmergencyContact';

  static String _$contactId(EmergencyContact v) => v.contactId;
  static const Field<EmergencyContact, String> _f$contactId = Field(
    'contactId',
    _$contactId,
  );
  static String _$userId(EmergencyContact v) => v.userId;
  static const Field<EmergencyContact, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$name(EmergencyContact v) => v.name;
  static const Field<EmergencyContact, String> _f$name = Field('name', _$name);
  static String _$phoneNumber(EmergencyContact v) => v.phoneNumber;
  static const Field<EmergencyContact, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
  );
  static String? _$email(EmergencyContact v) => v.email;
  static const Field<EmergencyContact, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static bool _$isEnabled(EmergencyContact v) => v.isEnabled;
  static const Field<EmergencyContact, bool> _f$isEnabled = Field(
    'isEnabled',
    _$isEnabled,
    opt: true,
    def: true,
  );
  static DateTime _$addedAt(EmergencyContact v) => v.addedAt;
  static const Field<EmergencyContact, DateTime> _f$addedAt = Field(
    'addedAt',
    _$addedAt,
  );
  static DateTime? _$lastNotifiedAt(EmergencyContact v) => v.lastNotifiedAt;
  static const Field<EmergencyContact, DateTime> _f$lastNotifiedAt = Field(
    'lastNotifiedAt',
    _$lastNotifiedAt,
    opt: true,
  );

  @override
  final MappableFields<EmergencyContact> fields = const {
    #contactId: _f$contactId,
    #userId: _f$userId,
    #name: _f$name,
    #phoneNumber: _f$phoneNumber,
    #email: _f$email,
    #isEnabled: _f$isEnabled,
    #addedAt: _f$addedAt,
    #lastNotifiedAt: _f$lastNotifiedAt,
  };

  static EmergencyContact _instantiate(DecodingData data) {
    return EmergencyContact(
      contactId: data.dec(_f$contactId),
      userId: data.dec(_f$userId),
      name: data.dec(_f$name),
      phoneNumber: data.dec(_f$phoneNumber),
      email: data.dec(_f$email),
      isEnabled: data.dec(_f$isEnabled),
      addedAt: data.dec(_f$addedAt),
      lastNotifiedAt: data.dec(_f$lastNotifiedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EmergencyContact fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EmergencyContact>(map);
  }

  static EmergencyContact fromJson(String json) {
    return ensureInitialized().decodeJson<EmergencyContact>(json);
  }
}

mixin EmergencyContactMappable {
  String toJson() {
    return EmergencyContactMapper.ensureInitialized()
        .encodeJson<EmergencyContact>(this as EmergencyContact);
  }

  Map<String, dynamic> toMap() {
    return EmergencyContactMapper.ensureInitialized()
        .encodeMap<EmergencyContact>(this as EmergencyContact);
  }

  EmergencyContactCopyWith<EmergencyContact, EmergencyContact, EmergencyContact>
  get copyWith =>
      _EmergencyContactCopyWithImpl<EmergencyContact, EmergencyContact>(
        this as EmergencyContact,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EmergencyContactMapper.ensureInitialized().stringifyValue(
      this as EmergencyContact,
    );
  }

  @override
  bool operator ==(Object other) {
    return EmergencyContactMapper.ensureInitialized().equalsValue(
      this as EmergencyContact,
      other,
    );
  }

  @override
  int get hashCode {
    return EmergencyContactMapper.ensureInitialized().hashValue(
      this as EmergencyContact,
    );
  }
}

extension EmergencyContactValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EmergencyContact, $Out> {
  EmergencyContactCopyWith<$R, EmergencyContact, $Out>
  get $asEmergencyContact =>
      $base.as((v, t, t2) => _EmergencyContactCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EmergencyContactCopyWith<$R, $In extends EmergencyContact, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? contactId,
    String? userId,
    String? name,
    String? phoneNumber,
    String? email,
    bool? isEnabled,
    DateTime? addedAt,
    DateTime? lastNotifiedAt,
  });
  EmergencyContactCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EmergencyContactCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EmergencyContact, $Out>
    implements EmergencyContactCopyWith<$R, EmergencyContact, $Out> {
  _EmergencyContactCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EmergencyContact> $mapper =
      EmergencyContactMapper.ensureInitialized();
  @override
  $R call({
    String? contactId,
    String? userId,
    String? name,
    String? phoneNumber,
    Object? email = $none,
    bool? isEnabled,
    DateTime? addedAt,
    Object? lastNotifiedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (contactId != null) #contactId: contactId,
      if (userId != null) #userId: userId,
      if (name != null) #name: name,
      if (phoneNumber != null) #phoneNumber: phoneNumber,
      if (email != $none) #email: email,
      if (isEnabled != null) #isEnabled: isEnabled,
      if (addedAt != null) #addedAt: addedAt,
      if (lastNotifiedAt != $none) #lastNotifiedAt: lastNotifiedAt,
    }),
  );
  @override
  EmergencyContact $make(CopyWithData data) => EmergencyContact(
    contactId: data.get(#contactId, or: $value.contactId),
    userId: data.get(#userId, or: $value.userId),
    name: data.get(#name, or: $value.name),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
    email: data.get(#email, or: $value.email),
    isEnabled: data.get(#isEnabled, or: $value.isEnabled),
    addedAt: data.get(#addedAt, or: $value.addedAt),
    lastNotifiedAt: data.get(#lastNotifiedAt, or: $value.lastNotifiedAt),
  );

  @override
  EmergencyContactCopyWith<$R2, EmergencyContact, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EmergencyContactCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SafetyCheckInMapper extends ClassMapperBase<SafetyCheckIn> {
  SafetyCheckInMapper._();

  static SafetyCheckInMapper? _instance;
  static SafetyCheckInMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SafetyCheckInMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SafetyCheckIn';

  static String _$checkInId(SafetyCheckIn v) => v.checkInId;
  static const Field<SafetyCheckIn, String> _f$checkInId = Field(
    'checkInId',
    _$checkInId,
  );
  static String _$userId(SafetyCheckIn v) => v.userId;
  static const Field<SafetyCheckIn, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static DateTime _$scheduledTime(SafetyCheckIn v) => v.scheduledTime;
  static const Field<SafetyCheckIn, DateTime> _f$scheduledTime = Field(
    'scheduledTime',
    _$scheduledTime,
  );
  static DateTime? _$checkedInAt(SafetyCheckIn v) => v.checkedInAt;
  static const Field<SafetyCheckIn, DateTime> _f$checkedInAt = Field(
    'checkedInAt',
    _$checkedInAt,
    opt: true,
  );
  static String? _$location(SafetyCheckIn v) => v.location;
  static const Field<SafetyCheckIn, String> _f$location = Field(
    'location',
    _$location,
    opt: true,
  );
  static String? _$datePartnerUserId(SafetyCheckIn v) => v.datePartnerUserId;
  static const Field<SafetyCheckIn, String> _f$datePartnerUserId = Field(
    'datePartnerUserId',
    _$datePartnerUserId,
    opt: true,
  );
  static bool _$isEmergency(SafetyCheckIn v) => v.isEmergency;
  static const Field<SafetyCheckIn, bool> _f$isEmergency = Field(
    'isEmergency',
    _$isEmergency,
    opt: true,
    def: false,
  );
  static String? _$emergencyMessage(SafetyCheckIn v) => v.emergencyMessage;
  static const Field<SafetyCheckIn, String> _f$emergencyMessage = Field(
    'emergencyMessage',
    _$emergencyMessage,
    opt: true,
  );
  static CheckInStatus _$status(SafetyCheckIn v) => v.status;
  static const Field<SafetyCheckIn, CheckInStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: CheckInStatus.pending,
  );
  static bool _$isOverdue(SafetyCheckIn v) => v.isOverdue;
  static const Field<SafetyCheckIn, bool> _f$isOverdue = Field(
    'isOverdue',
    _$isOverdue,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<SafetyCheckIn> fields = const {
    #checkInId: _f$checkInId,
    #userId: _f$userId,
    #scheduledTime: _f$scheduledTime,
    #checkedInAt: _f$checkedInAt,
    #location: _f$location,
    #datePartnerUserId: _f$datePartnerUserId,
    #isEmergency: _f$isEmergency,
    #emergencyMessage: _f$emergencyMessage,
    #status: _f$status,
    #isOverdue: _f$isOverdue,
  };

  static SafetyCheckIn _instantiate(DecodingData data) {
    return SafetyCheckIn(
      checkInId: data.dec(_f$checkInId),
      userId: data.dec(_f$userId),
      scheduledTime: data.dec(_f$scheduledTime),
      checkedInAt: data.dec(_f$checkedInAt),
      location: data.dec(_f$location),
      datePartnerUserId: data.dec(_f$datePartnerUserId),
      isEmergency: data.dec(_f$isEmergency),
      emergencyMessage: data.dec(_f$emergencyMessage),
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SafetyCheckIn fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SafetyCheckIn>(map);
  }

  static SafetyCheckIn fromJson(String json) {
    return ensureInitialized().decodeJson<SafetyCheckIn>(json);
  }
}

mixin SafetyCheckInMappable {
  String toJson() {
    return SafetyCheckInMapper.ensureInitialized().encodeJson<SafetyCheckIn>(
      this as SafetyCheckIn,
    );
  }

  Map<String, dynamic> toMap() {
    return SafetyCheckInMapper.ensureInitialized().encodeMap<SafetyCheckIn>(
      this as SafetyCheckIn,
    );
  }

  SafetyCheckInCopyWith<SafetyCheckIn, SafetyCheckIn, SafetyCheckIn>
  get copyWith => _SafetyCheckInCopyWithImpl<SafetyCheckIn, SafetyCheckIn>(
    this as SafetyCheckIn,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SafetyCheckInMapper.ensureInitialized().stringifyValue(
      this as SafetyCheckIn,
    );
  }

  @override
  bool operator ==(Object other) {
    return SafetyCheckInMapper.ensureInitialized().equalsValue(
      this as SafetyCheckIn,
      other,
    );
  }

  @override
  int get hashCode {
    return SafetyCheckInMapper.ensureInitialized().hashValue(
      this as SafetyCheckIn,
    );
  }
}

extension SafetyCheckInValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SafetyCheckIn, $Out> {
  SafetyCheckInCopyWith<$R, SafetyCheckIn, $Out> get $asSafetyCheckIn =>
      $base.as((v, t, t2) => _SafetyCheckInCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SafetyCheckInCopyWith<$R, $In extends SafetyCheckIn, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? checkInId,
    String? userId,
    DateTime? scheduledTime,
    DateTime? checkedInAt,
    String? location,
    String? datePartnerUserId,
    bool? isEmergency,
    String? emergencyMessage,
    CheckInStatus? status,
  });
  SafetyCheckInCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SafetyCheckInCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SafetyCheckIn, $Out>
    implements SafetyCheckInCopyWith<$R, SafetyCheckIn, $Out> {
  _SafetyCheckInCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SafetyCheckIn> $mapper =
      SafetyCheckInMapper.ensureInitialized();
  @override
  $R call({
    String? checkInId,
    String? userId,
    DateTime? scheduledTime,
    Object? checkedInAt = $none,
    Object? location = $none,
    Object? datePartnerUserId = $none,
    bool? isEmergency,
    Object? emergencyMessage = $none,
    CheckInStatus? status,
  }) => $apply(
    FieldCopyWithData({
      if (checkInId != null) #checkInId: checkInId,
      if (userId != null) #userId: userId,
      if (scheduledTime != null) #scheduledTime: scheduledTime,
      if (checkedInAt != $none) #checkedInAt: checkedInAt,
      if (location != $none) #location: location,
      if (datePartnerUserId != $none) #datePartnerUserId: datePartnerUserId,
      if (isEmergency != null) #isEmergency: isEmergency,
      if (emergencyMessage != $none) #emergencyMessage: emergencyMessage,
      if (status != null) #status: status,
    }),
  );
  @override
  SafetyCheckIn $make(CopyWithData data) => SafetyCheckIn(
    checkInId: data.get(#checkInId, or: $value.checkInId),
    userId: data.get(#userId, or: $value.userId),
    scheduledTime: data.get(#scheduledTime, or: $value.scheduledTime),
    checkedInAt: data.get(#checkedInAt, or: $value.checkedInAt),
    location: data.get(#location, or: $value.location),
    datePartnerUserId: data.get(
      #datePartnerUserId,
      or: $value.datePartnerUserId,
    ),
    isEmergency: data.get(#isEmergency, or: $value.isEmergency),
    emergencyMessage: data.get(#emergencyMessage, or: $value.emergencyMessage),
    status: data.get(#status, or: $value.status),
  );

  @override
  SafetyCheckInCopyWith<$R2, SafetyCheckIn, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SafetyCheckInCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SafetySettingsMapper extends ClassMapperBase<SafetySettings> {
  SafetySettingsMapper._();

  static SafetySettingsMapper? _instance;
  static SafetySettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SafetySettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SafetySettings';

  static String _$userId(SafetySettings v) => v.userId;
  static const Field<SafetySettings, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static bool _$photoVerificationRequired(SafetySettings v) =>
      v.photoVerificationRequired;
  static const Field<SafetySettings, bool> _f$photoVerificationRequired = Field(
    'photoVerificationRequired',
    _$photoVerificationRequired,
    opt: true,
    def: false,
  );
  static bool _$shareLocationOnDates(SafetySettings v) =>
      v.shareLocationOnDates;
  static const Field<SafetySettings, bool> _f$shareLocationOnDates = Field(
    'shareLocationOnDates',
    _$shareLocationOnDates,
    opt: true,
    def: false,
  );
  static bool _$enableCheckIns(SafetySettings v) => v.enableCheckIns;
  static const Field<SafetySettings, bool> _f$enableCheckIns = Field(
    'enableCheckIns',
    _$enableCheckIns,
    opt: true,
    def: true,
  );
  static bool _$autoNotifyEmergency(SafetySettings v) => v.autoNotifyEmergency;
  static const Field<SafetySettings, bool> _f$autoNotifyEmergency = Field(
    'autoNotifyEmergency',
    _$autoNotifyEmergency,
    opt: true,
    def: true,
  );
  static int _$checkInReminderMinutes(SafetySettings v) =>
      v.checkInReminderMinutes;
  static const Field<SafetySettings, int> _f$checkInReminderMinutes = Field(
    'checkInReminderMinutes',
    _$checkInReminderMinutes,
    opt: true,
    def: 30,
  );
  static bool _$hideFromSearch(SafetySettings v) => v.hideFromSearch;
  static const Field<SafetySettings, bool> _f$hideFromSearch = Field(
    'hideFromSearch',
    _$hideFromSearch,
    opt: true,
    def: false,
  );
  static bool _$requireMessageApproval(SafetySettings v) =>
      v.requireMessageApproval;
  static const Field<SafetySettings, bool> _f$requireMessageApproval = Field(
    'requireMessageApproval',
    _$requireMessageApproval,
    opt: true,
    def: false,
  );
  static DateTime _$updatedAt(SafetySettings v) => v.updatedAt;
  static const Field<SafetySettings, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );

  @override
  final MappableFields<SafetySettings> fields = const {
    #userId: _f$userId,
    #photoVerificationRequired: _f$photoVerificationRequired,
    #shareLocationOnDates: _f$shareLocationOnDates,
    #enableCheckIns: _f$enableCheckIns,
    #autoNotifyEmergency: _f$autoNotifyEmergency,
    #checkInReminderMinutes: _f$checkInReminderMinutes,
    #hideFromSearch: _f$hideFromSearch,
    #requireMessageApproval: _f$requireMessageApproval,
    #updatedAt: _f$updatedAt,
  };

  static SafetySettings _instantiate(DecodingData data) {
    return SafetySettings(
      userId: data.dec(_f$userId),
      photoVerificationRequired: data.dec(_f$photoVerificationRequired),
      shareLocationOnDates: data.dec(_f$shareLocationOnDates),
      enableCheckIns: data.dec(_f$enableCheckIns),
      autoNotifyEmergency: data.dec(_f$autoNotifyEmergency),
      checkInReminderMinutes: data.dec(_f$checkInReminderMinutes),
      hideFromSearch: data.dec(_f$hideFromSearch),
      requireMessageApproval: data.dec(_f$requireMessageApproval),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SafetySettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SafetySettings>(map);
  }

  static SafetySettings fromJson(String json) {
    return ensureInitialized().decodeJson<SafetySettings>(json);
  }
}

mixin SafetySettingsMappable {
  String toJson() {
    return SafetySettingsMapper.ensureInitialized().encodeJson<SafetySettings>(
      this as SafetySettings,
    );
  }

  Map<String, dynamic> toMap() {
    return SafetySettingsMapper.ensureInitialized().encodeMap<SafetySettings>(
      this as SafetySettings,
    );
  }

  SafetySettingsCopyWith<SafetySettings, SafetySettings, SafetySettings>
  get copyWith => _SafetySettingsCopyWithImpl<SafetySettings, SafetySettings>(
    this as SafetySettings,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SafetySettingsMapper.ensureInitialized().stringifyValue(
      this as SafetySettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return SafetySettingsMapper.ensureInitialized().equalsValue(
      this as SafetySettings,
      other,
    );
  }

  @override
  int get hashCode {
    return SafetySettingsMapper.ensureInitialized().hashValue(
      this as SafetySettings,
    );
  }
}

extension SafetySettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SafetySettings, $Out> {
  SafetySettingsCopyWith<$R, SafetySettings, $Out> get $asSafetySettings =>
      $base.as((v, t, t2) => _SafetySettingsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SafetySettingsCopyWith<$R, $In extends SafetySettings, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    bool? photoVerificationRequired,
    bool? shareLocationOnDates,
    bool? enableCheckIns,
    bool? autoNotifyEmergency,
    int? checkInReminderMinutes,
    bool? hideFromSearch,
    bool? requireMessageApproval,
    DateTime? updatedAt,
  });
  SafetySettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SafetySettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SafetySettings, $Out>
    implements SafetySettingsCopyWith<$R, SafetySettings, $Out> {
  _SafetySettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SafetySettings> $mapper =
      SafetySettingsMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    bool? photoVerificationRequired,
    bool? shareLocationOnDates,
    bool? enableCheckIns,
    bool? autoNotifyEmergency,
    int? checkInReminderMinutes,
    bool? hideFromSearch,
    bool? requireMessageApproval,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (photoVerificationRequired != null)
        #photoVerificationRequired: photoVerificationRequired,
      if (shareLocationOnDates != null)
        #shareLocationOnDates: shareLocationOnDates,
      if (enableCheckIns != null) #enableCheckIns: enableCheckIns,
      if (autoNotifyEmergency != null)
        #autoNotifyEmergency: autoNotifyEmergency,
      if (checkInReminderMinutes != null)
        #checkInReminderMinutes: checkInReminderMinutes,
      if (hideFromSearch != null) #hideFromSearch: hideFromSearch,
      if (requireMessageApproval != null)
        #requireMessageApproval: requireMessageApproval,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  SafetySettings $make(CopyWithData data) => SafetySettings(
    userId: data.get(#userId, or: $value.userId),
    photoVerificationRequired: data.get(
      #photoVerificationRequired,
      or: $value.photoVerificationRequired,
    ),
    shareLocationOnDates: data.get(
      #shareLocationOnDates,
      or: $value.shareLocationOnDates,
    ),
    enableCheckIns: data.get(#enableCheckIns, or: $value.enableCheckIns),
    autoNotifyEmergency: data.get(
      #autoNotifyEmergency,
      or: $value.autoNotifyEmergency,
    ),
    checkInReminderMinutes: data.get(
      #checkInReminderMinutes,
      or: $value.checkInReminderMinutes,
    ),
    hideFromSearch: data.get(#hideFromSearch, or: $value.hideFromSearch),
    requireMessageApproval: data.get(
      #requireMessageApproval,
      or: $value.requireMessageApproval,
    ),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  SafetySettingsCopyWith<$R2, SafetySettings, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SafetySettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SafetyStatsMapper extends ClassMapperBase<SafetyStats> {
  SafetyStatsMapper._();

  static SafetyStatsMapper? _instance;
  static SafetyStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SafetyStatsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SafetyStats';

  static int _$totalReportsSubmitted(SafetyStats v) => v.totalReportsSubmitted;
  static const Field<SafetyStats, int> _f$totalReportsSubmitted = Field(
    'totalReportsSubmitted',
    _$totalReportsSubmitted,
  );
  static int _$totalReportsReceived(SafetyStats v) => v.totalReportsReceived;
  static const Field<SafetyStats, int> _f$totalReportsReceived = Field(
    'totalReportsReceived',
    _$totalReportsReceived,
  );
  static int _$activeBlocks(SafetyStats v) => v.activeBlocks;
  static const Field<SafetyStats, int> _f$activeBlocks = Field(
    'activeBlocks',
    _$activeBlocks,
  );
  static int _$emergencyContactsCount(SafetyStats v) =>
      v.emergencyContactsCount;
  static const Field<SafetyStats, int> _f$emergencyContactsCount = Field(
    'emergencyContactsCount',
    _$emergencyContactsCount,
  );
  static int _$checkInsCompleted(SafetyStats v) => v.checkInsCompleted;
  static const Field<SafetyStats, int> _f$checkInsCompleted = Field(
    'checkInsCompleted',
    _$checkInsCompleted,
  );
  static int _$checkInsMissed(SafetyStats v) => v.checkInsMissed;
  static const Field<SafetyStats, int> _f$checkInsMissed = Field(
    'checkInsMissed',
    _$checkInsMissed,
  );
  static DateTime? _$lastReportDate(SafetyStats v) => v.lastReportDate;
  static const Field<SafetyStats, DateTime> _f$lastReportDate = Field(
    'lastReportDate',
    _$lastReportDate,
    opt: true,
  );
  static double _$safetyScore(SafetyStats v) => v.safetyScore;
  static const Field<SafetyStats, double> _f$safetyScore = Field(
    'safetyScore',
    _$safetyScore,
  );

  @override
  final MappableFields<SafetyStats> fields = const {
    #totalReportsSubmitted: _f$totalReportsSubmitted,
    #totalReportsReceived: _f$totalReportsReceived,
    #activeBlocks: _f$activeBlocks,
    #emergencyContactsCount: _f$emergencyContactsCount,
    #checkInsCompleted: _f$checkInsCompleted,
    #checkInsMissed: _f$checkInsMissed,
    #lastReportDate: _f$lastReportDate,
    #safetyScore: _f$safetyScore,
  };

  static SafetyStats _instantiate(DecodingData data) {
    return SafetyStats(
      totalReportsSubmitted: data.dec(_f$totalReportsSubmitted),
      totalReportsReceived: data.dec(_f$totalReportsReceived),
      activeBlocks: data.dec(_f$activeBlocks),
      emergencyContactsCount: data.dec(_f$emergencyContactsCount),
      checkInsCompleted: data.dec(_f$checkInsCompleted),
      checkInsMissed: data.dec(_f$checkInsMissed),
      lastReportDate: data.dec(_f$lastReportDate),
      safetyScore: data.dec(_f$safetyScore),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SafetyStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SafetyStats>(map);
  }

  static SafetyStats fromJson(String json) {
    return ensureInitialized().decodeJson<SafetyStats>(json);
  }
}

mixin SafetyStatsMappable {
  String toJson() {
    return SafetyStatsMapper.ensureInitialized().encodeJson<SafetyStats>(
      this as SafetyStats,
    );
  }

  Map<String, dynamic> toMap() {
    return SafetyStatsMapper.ensureInitialized().encodeMap<SafetyStats>(
      this as SafetyStats,
    );
  }

  SafetyStatsCopyWith<SafetyStats, SafetyStats, SafetyStats> get copyWith =>
      _SafetyStatsCopyWithImpl<SafetyStats, SafetyStats>(
        this as SafetyStats,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SafetyStatsMapper.ensureInitialized().stringifyValue(
      this as SafetyStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return SafetyStatsMapper.ensureInitialized().equalsValue(
      this as SafetyStats,
      other,
    );
  }

  @override
  int get hashCode {
    return SafetyStatsMapper.ensureInitialized().hashValue(this as SafetyStats);
  }
}

extension SafetyStatsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SafetyStats, $Out> {
  SafetyStatsCopyWith<$R, SafetyStats, $Out> get $asSafetyStats =>
      $base.as((v, t, t2) => _SafetyStatsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SafetyStatsCopyWith<$R, $In extends SafetyStats, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? totalReportsSubmitted,
    int? totalReportsReceived,
    int? activeBlocks,
    int? emergencyContactsCount,
    int? checkInsCompleted,
    int? checkInsMissed,
    DateTime? lastReportDate,
    double? safetyScore,
  });
  SafetyStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SafetyStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SafetyStats, $Out>
    implements SafetyStatsCopyWith<$R, SafetyStats, $Out> {
  _SafetyStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SafetyStats> $mapper =
      SafetyStatsMapper.ensureInitialized();
  @override
  $R call({
    int? totalReportsSubmitted,
    int? totalReportsReceived,
    int? activeBlocks,
    int? emergencyContactsCount,
    int? checkInsCompleted,
    int? checkInsMissed,
    Object? lastReportDate = $none,
    double? safetyScore,
  }) => $apply(
    FieldCopyWithData({
      if (totalReportsSubmitted != null)
        #totalReportsSubmitted: totalReportsSubmitted,
      if (totalReportsReceived != null)
        #totalReportsReceived: totalReportsReceived,
      if (activeBlocks != null) #activeBlocks: activeBlocks,
      if (emergencyContactsCount != null)
        #emergencyContactsCount: emergencyContactsCount,
      if (checkInsCompleted != null) #checkInsCompleted: checkInsCompleted,
      if (checkInsMissed != null) #checkInsMissed: checkInsMissed,
      if (lastReportDate != $none) #lastReportDate: lastReportDate,
      if (safetyScore != null) #safetyScore: safetyScore,
    }),
  );
  @override
  SafetyStats $make(CopyWithData data) => SafetyStats(
    totalReportsSubmitted: data.get(
      #totalReportsSubmitted,
      or: $value.totalReportsSubmitted,
    ),
    totalReportsReceived: data.get(
      #totalReportsReceived,
      or: $value.totalReportsReceived,
    ),
    activeBlocks: data.get(#activeBlocks, or: $value.activeBlocks),
    emergencyContactsCount: data.get(
      #emergencyContactsCount,
      or: $value.emergencyContactsCount,
    ),
    checkInsCompleted: data.get(
      #checkInsCompleted,
      or: $value.checkInsCompleted,
    ),
    checkInsMissed: data.get(#checkInsMissed, or: $value.checkInsMissed),
    lastReportDate: data.get(#lastReportDate, or: $value.lastReportDate),
    safetyScore: data.get(#safetyScore, or: $value.safetyScore),
  );

  @override
  SafetyStatsCopyWith<$R2, SafetyStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SafetyStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CreateReportRequestMapper extends ClassMapperBase<CreateReportRequest> {
  CreateReportRequestMapper._();

  static CreateReportRequestMapper? _instance;
  static CreateReportRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CreateReportRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CreateReportRequest';

  static String _$reportedUserId(CreateReportRequest v) => v.reportedUserId;
  static const Field<CreateReportRequest, String> _f$reportedUserId = Field(
    'reportedUserId',
    _$reportedUserId,
  );
  static ReportReason _$reason(CreateReportRequest v) => v.reason;
  static const Field<CreateReportRequest, ReportReason> _f$reason = Field(
    'reason',
    _$reason,
  );
  static String? _$customReason(CreateReportRequest v) => v.customReason;
  static const Field<CreateReportRequest, String> _f$customReason = Field(
    'customReason',
    _$customReason,
    opt: true,
  );
  static List<String> _$evidenceUrls(CreateReportRequest v) => v.evidenceUrls;
  static const Field<CreateReportRequest, List<String>> _f$evidenceUrls = Field(
    'evidenceUrls',
    _$evidenceUrls,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<CreateReportRequest> fields = const {
    #reportedUserId: _f$reportedUserId,
    #reason: _f$reason,
    #customReason: _f$customReason,
    #evidenceUrls: _f$evidenceUrls,
  };

  static CreateReportRequest _instantiate(DecodingData data) {
    return CreateReportRequest(
      reportedUserId: data.dec(_f$reportedUserId),
      reason: data.dec(_f$reason),
      customReason: data.dec(_f$customReason),
      evidenceUrls: data.dec(_f$evidenceUrls),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CreateReportRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CreateReportRequest>(map);
  }

  static CreateReportRequest fromJson(String json) {
    return ensureInitialized().decodeJson<CreateReportRequest>(json);
  }
}

mixin CreateReportRequestMappable {
  String toJson() {
    return CreateReportRequestMapper.ensureInitialized()
        .encodeJson<CreateReportRequest>(this as CreateReportRequest);
  }

  Map<String, dynamic> toMap() {
    return CreateReportRequestMapper.ensureInitialized()
        .encodeMap<CreateReportRequest>(this as CreateReportRequest);
  }

  CreateReportRequestCopyWith<
    CreateReportRequest,
    CreateReportRequest,
    CreateReportRequest
  >
  get copyWith =>
      _CreateReportRequestCopyWithImpl<
        CreateReportRequest,
        CreateReportRequest
      >(this as CreateReportRequest, $identity, $identity);
  @override
  String toString() {
    return CreateReportRequestMapper.ensureInitialized().stringifyValue(
      this as CreateReportRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return CreateReportRequestMapper.ensureInitialized().equalsValue(
      this as CreateReportRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return CreateReportRequestMapper.ensureInitialized().hashValue(
      this as CreateReportRequest,
    );
  }
}

extension CreateReportRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CreateReportRequest, $Out> {
  CreateReportRequestCopyWith<$R, CreateReportRequest, $Out>
  get $asCreateReportRequest => $base.as(
    (v, t, t2) => _CreateReportRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CreateReportRequestCopyWith<
  $R,
  $In extends CreateReportRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get evidenceUrls;
  $R call({
    String? reportedUserId,
    ReportReason? reason,
    String? customReason,
    List<String>? evidenceUrls,
  });
  CreateReportRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CreateReportRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CreateReportRequest, $Out>
    implements CreateReportRequestCopyWith<$R, CreateReportRequest, $Out> {
  _CreateReportRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CreateReportRequest> $mapper =
      CreateReportRequestMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get evidenceUrls => ListCopyWith(
    $value.evidenceUrls,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(evidenceUrls: v),
  );
  @override
  $R call({
    String? reportedUserId,
    ReportReason? reason,
    Object? customReason = $none,
    List<String>? evidenceUrls,
  }) => $apply(
    FieldCopyWithData({
      if (reportedUserId != null) #reportedUserId: reportedUserId,
      if (reason != null) #reason: reason,
      if (customReason != $none) #customReason: customReason,
      if (evidenceUrls != null) #evidenceUrls: evidenceUrls,
    }),
  );
  @override
  CreateReportRequest $make(CopyWithData data) => CreateReportRequest(
    reportedUserId: data.get(#reportedUserId, or: $value.reportedUserId),
    reason: data.get(#reason, or: $value.reason),
    customReason: data.get(#customReason, or: $value.customReason),
    evidenceUrls: data.get(#evidenceUrls, or: $value.evidenceUrls),
  );

  @override
  CreateReportRequestCopyWith<$R2, CreateReportRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CreateReportRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SafetyTipMapper extends ClassMapperBase<SafetyTip> {
  SafetyTipMapper._();

  static SafetyTipMapper? _instance;
  static SafetyTipMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SafetyTipMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SafetyTip';

  static String _$tipId(SafetyTip v) => v.tipId;
  static const Field<SafetyTip, String> _f$tipId = Field('tipId', _$tipId);
  static String _$title(SafetyTip v) => v.title;
  static const Field<SafetyTip, String> _f$title = Field('title', _$title);
  static String _$description(SafetyTip v) => v.description;
  static const Field<SafetyTip, String> _f$description = Field(
    'description',
    _$description,
  );
  static SafetyTipCategory _$category(SafetyTip v) => v.category;
  static const Field<SafetyTip, SafetyTipCategory> _f$category = Field(
    'category',
    _$category,
  );
  static int _$priority(SafetyTip v) => v.priority;
  static const Field<SafetyTip, int> _f$priority = Field(
    'priority',
    _$priority,
    opt: true,
    def: 5,
  );
  static String? _$iconUrl(SafetyTip v) => v.iconUrl;
  static const Field<SafetyTip, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );

  @override
  final MappableFields<SafetyTip> fields = const {
    #tipId: _f$tipId,
    #title: _f$title,
    #description: _f$description,
    #category: _f$category,
    #priority: _f$priority,
    #iconUrl: _f$iconUrl,
  };

  static SafetyTip _instantiate(DecodingData data) {
    return SafetyTip(
      tipId: data.dec(_f$tipId),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      category: data.dec(_f$category),
      priority: data.dec(_f$priority),
      iconUrl: data.dec(_f$iconUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SafetyTip fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SafetyTip>(map);
  }

  static SafetyTip fromJson(String json) {
    return ensureInitialized().decodeJson<SafetyTip>(json);
  }
}

mixin SafetyTipMappable {
  String toJson() {
    return SafetyTipMapper.ensureInitialized().encodeJson<SafetyTip>(
      this as SafetyTip,
    );
  }

  Map<String, dynamic> toMap() {
    return SafetyTipMapper.ensureInitialized().encodeMap<SafetyTip>(
      this as SafetyTip,
    );
  }

  SafetyTipCopyWith<SafetyTip, SafetyTip, SafetyTip> get copyWith =>
      _SafetyTipCopyWithImpl<SafetyTip, SafetyTip>(
        this as SafetyTip,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SafetyTipMapper.ensureInitialized().stringifyValue(
      this as SafetyTip,
    );
  }

  @override
  bool operator ==(Object other) {
    return SafetyTipMapper.ensureInitialized().equalsValue(
      this as SafetyTip,
      other,
    );
  }

  @override
  int get hashCode {
    return SafetyTipMapper.ensureInitialized().hashValue(this as SafetyTip);
  }
}

extension SafetyTipValueCopy<$R, $Out> on ObjectCopyWith<$R, SafetyTip, $Out> {
  SafetyTipCopyWith<$R, SafetyTip, $Out> get $asSafetyTip =>
      $base.as((v, t, t2) => _SafetyTipCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SafetyTipCopyWith<$R, $In extends SafetyTip, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? tipId,
    String? title,
    String? description,
    SafetyTipCategory? category,
    int? priority,
    String? iconUrl,
  });
  SafetyTipCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SafetyTipCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SafetyTip, $Out>
    implements SafetyTipCopyWith<$R, SafetyTip, $Out> {
  _SafetyTipCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SafetyTip> $mapper =
      SafetyTipMapper.ensureInitialized();
  @override
  $R call({
    String? tipId,
    String? title,
    String? description,
    SafetyTipCategory? category,
    int? priority,
    Object? iconUrl = $none,
  }) => $apply(
    FieldCopyWithData({
      if (tipId != null) #tipId: tipId,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (category != null) #category: category,
      if (priority != null) #priority: priority,
      if (iconUrl != $none) #iconUrl: iconUrl,
    }),
  );
  @override
  SafetyTip $make(CopyWithData data) => SafetyTip(
    tipId: data.get(#tipId, or: $value.tipId),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    category: data.get(#category, or: $value.category),
    priority: data.get(#priority, or: $value.priority),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
  );

  @override
  SafetyTipCopyWith<$R2, SafetyTip, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SafetyTipCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

