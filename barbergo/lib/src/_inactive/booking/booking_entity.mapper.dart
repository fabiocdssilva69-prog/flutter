// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'booking_entity.dart';

class BookingEntityMapper extends ClassMapperBase<BookingEntity> {
  BookingEntityMapper._();

  static BookingEntityMapper? _instance;
  static BookingEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BookingEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BookingEntity';

  static String _$id(BookingEntity v) => v.id;
  static const Field<BookingEntity, String> _f$id = Field('id', _$id);
  static String _$barberId(BookingEntity v) => v.barberId;
  static const Field<BookingEntity, String> _f$barberId = Field(
    'barberId',
    _$barberId,
  );
  static String _$barberName(BookingEntity v) => v.barberName;
  static const Field<BookingEntity, String> _f$barberName = Field(
    'barberName',
    _$barberName,
  );
  static String? _$barberAvatarUrl(BookingEntity v) => v.barberAvatarUrl;
  static const Field<BookingEntity, String> _f$barberAvatarUrl = Field(
    'barberAvatarUrl',
    _$barberAvatarUrl,
    opt: true,
  );
  static String _$clientId(BookingEntity v) => v.clientId;
  static const Field<BookingEntity, String> _f$clientId = Field(
    'clientId',
    _$clientId,
  );
  static String _$clientName(BookingEntity v) => v.clientName;
  static const Field<BookingEntity, String> _f$clientName = Field(
    'clientName',
    _$clientName,
  );
  static String? _$clientAvatarUrl(BookingEntity v) => v.clientAvatarUrl;
  static const Field<BookingEntity, String> _f$clientAvatarUrl = Field(
    'clientAvatarUrl',
    _$clientAvatarUrl,
    opt: true,
  );
  static String _$serviceType(BookingEntity v) => v.serviceType;
  static const Field<BookingEntity, String> _f$serviceType = Field(
    'serviceType',
    _$serviceType,
  );
  static DateTime _$dateTime(BookingEntity v) => v.dateTime;
  static const Field<BookingEntity, DateTime> _f$dateTime = Field(
    'dateTime',
    _$dateTime,
    hook: TimestampHook(),
  );
  static int _$durationMinutes(BookingEntity v) => v.durationMinutes;
  static const Field<BookingEntity, int> _f$durationMinutes = Field(
    'durationMinutes',
    _$durationMinutes,
    opt: true,
    def: 60,
  );
  static double _$price(BookingEntity v) => v.price;
  static const Field<BookingEntity, double> _f$price = Field('price', _$price);
  static BookingStatus _$status(BookingEntity v) => v.status;
  static const Field<BookingEntity, BookingStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: BookingStatus.pending,
  );
  static String? _$notes(BookingEntity v) => v.notes;
  static const Field<BookingEntity, String> _f$notes = Field(
    'notes',
    _$notes,
    opt: true,
  );
  static DateTime _$createdAt(BookingEntity v) => v.createdAt;
  static const Field<BookingEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    hook: TimestampHook(),
  );
  static DateTime? _$updatedAt(BookingEntity v) => v.updatedAt;
  static const Field<BookingEntity, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
    hook: TimestampHook(),
  );
  static String? _$cancellationReason(BookingEntity v) => v.cancellationReason;
  static const Field<BookingEntity, String> _f$cancellationReason = Field(
    'cancellationReason',
    _$cancellationReason,
    opt: true,
  );
  static String? _$cancelledBy(BookingEntity v) => v.cancelledBy;
  static const Field<BookingEntity, String> _f$cancelledBy = Field(
    'cancelledBy',
    _$cancelledBy,
    opt: true,
  );
  static bool _$canBeCancelled(BookingEntity v) => v.canBeCancelled;
  static const Field<BookingEntity, bool> _f$canBeCancelled = Field(
    'canBeCancelled',
    _$canBeCancelled,
    mode: FieldMode.member,
  );
  static bool _$isPast(BookingEntity v) => v.isPast;
  static const Field<BookingEntity, bool> _f$isPast = Field(
    'isPast',
    _$isPast,
    mode: FieldMode.member,
  );
  static bool _$isToday(BookingEntity v) => v.isToday;
  static const Field<BookingEntity, bool> _f$isToday = Field(
    'isToday',
    _$isToday,
    mode: FieldMode.member,
  );
  static DateTime _$endTime(BookingEntity v) => v.endTime;
  static const Field<BookingEntity, DateTime> _f$endTime = Field(
    'endTime',
    _$endTime,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<BookingEntity> fields = const {
    #id: _f$id,
    #barberId: _f$barberId,
    #barberName: _f$barberName,
    #barberAvatarUrl: _f$barberAvatarUrl,
    #clientId: _f$clientId,
    #clientName: _f$clientName,
    #clientAvatarUrl: _f$clientAvatarUrl,
    #serviceType: _f$serviceType,
    #dateTime: _f$dateTime,
    #durationMinutes: _f$durationMinutes,
    #price: _f$price,
    #status: _f$status,
    #notes: _f$notes,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #cancellationReason: _f$cancellationReason,
    #cancelledBy: _f$cancelledBy,
    #canBeCancelled: _f$canBeCancelled,
    #isPast: _f$isPast,
    #isToday: _f$isToday,
    #endTime: _f$endTime,
  };

  static BookingEntity _instantiate(DecodingData data) {
    return BookingEntity(
      id: data.dec(_f$id),
      barberId: data.dec(_f$barberId),
      barberName: data.dec(_f$barberName),
      barberAvatarUrl: data.dec(_f$barberAvatarUrl),
      clientId: data.dec(_f$clientId),
      clientName: data.dec(_f$clientName),
      clientAvatarUrl: data.dec(_f$clientAvatarUrl),
      serviceType: data.dec(_f$serviceType),
      dateTime: data.dec(_f$dateTime),
      durationMinutes: data.dec(_f$durationMinutes),
      price: data.dec(_f$price),
      status: data.dec(_f$status),
      notes: data.dec(_f$notes),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      cancellationReason: data.dec(_f$cancellationReason),
      cancelledBy: data.dec(_f$cancelledBy),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BookingEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BookingEntity>(map);
  }

  static BookingEntity fromJson(String json) {
    return ensureInitialized().decodeJson<BookingEntity>(json);
  }
}

mixin BookingEntityMappable {
  String toJson() {
    return BookingEntityMapper.ensureInitialized().encodeJson<BookingEntity>(
      this as BookingEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return BookingEntityMapper.ensureInitialized().encodeMap<BookingEntity>(
      this as BookingEntity,
    );
  }

  BookingEntityCopyWith<BookingEntity, BookingEntity, BookingEntity>
  get copyWith => _BookingEntityCopyWithImpl<BookingEntity, BookingEntity>(
    this as BookingEntity,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return BookingEntityMapper.ensureInitialized().stringifyValue(
      this as BookingEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return BookingEntityMapper.ensureInitialized().equalsValue(
      this as BookingEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return BookingEntityMapper.ensureInitialized().hashValue(
      this as BookingEntity,
    );
  }
}

extension BookingEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BookingEntity, $Out> {
  BookingEntityCopyWith<$R, BookingEntity, $Out> get $asBookingEntity =>
      $base.as((v, t, t2) => _BookingEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BookingEntityCopyWith<$R, $In extends BookingEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? barberId,
    String? barberName,
    String? barberAvatarUrl,
    String? clientId,
    String? clientName,
    String? clientAvatarUrl,
    String? serviceType,
    DateTime? dateTime,
    int? durationMinutes,
    double? price,
    BookingStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? cancellationReason,
    String? cancelledBy,
  });
  BookingEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BookingEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BookingEntity, $Out>
    implements BookingEntityCopyWith<$R, BookingEntity, $Out> {
  _BookingEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BookingEntity> $mapper =
      BookingEntityMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? barberId,
    String? barberName,
    Object? barberAvatarUrl = $none,
    String? clientId,
    String? clientName,
    Object? clientAvatarUrl = $none,
    String? serviceType,
    DateTime? dateTime,
    int? durationMinutes,
    double? price,
    BookingStatus? status,
    Object? notes = $none,
    DateTime? createdAt,
    Object? updatedAt = $none,
    Object? cancellationReason = $none,
    Object? cancelledBy = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (barberId != null) #barberId: barberId,
      if (barberName != null) #barberName: barberName,
      if (barberAvatarUrl != $none) #barberAvatarUrl: barberAvatarUrl,
      if (clientId != null) #clientId: clientId,
      if (clientName != null) #clientName: clientName,
      if (clientAvatarUrl != $none) #clientAvatarUrl: clientAvatarUrl,
      if (serviceType != null) #serviceType: serviceType,
      if (dateTime != null) #dateTime: dateTime,
      if (durationMinutes != null) #durationMinutes: durationMinutes,
      if (price != null) #price: price,
      if (status != null) #status: status,
      if (notes != $none) #notes: notes,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
      if (cancellationReason != $none) #cancellationReason: cancellationReason,
      if (cancelledBy != $none) #cancelledBy: cancelledBy,
    }),
  );
  @override
  BookingEntity $make(CopyWithData data) => BookingEntity(
    id: data.get(#id, or: $value.id),
    barberId: data.get(#barberId, or: $value.barberId),
    barberName: data.get(#barberName, or: $value.barberName),
    barberAvatarUrl: data.get(#barberAvatarUrl, or: $value.barberAvatarUrl),
    clientId: data.get(#clientId, or: $value.clientId),
    clientName: data.get(#clientName, or: $value.clientName),
    clientAvatarUrl: data.get(#clientAvatarUrl, or: $value.clientAvatarUrl),
    serviceType: data.get(#serviceType, or: $value.serviceType),
    dateTime: data.get(#dateTime, or: $value.dateTime),
    durationMinutes: data.get(#durationMinutes, or: $value.durationMinutes),
    price: data.get(#price, or: $value.price),
    status: data.get(#status, or: $value.status),
    notes: data.get(#notes, or: $value.notes),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    cancellationReason: data.get(
      #cancellationReason,
      or: $value.cancellationReason,
    ),
    cancelledBy: data.get(#cancelledBy, or: $value.cancelledBy),
  );

  @override
  BookingEntityCopyWith<$R2, BookingEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BookingEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

