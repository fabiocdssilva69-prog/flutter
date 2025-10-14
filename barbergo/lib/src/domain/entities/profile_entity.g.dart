// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileEntity _$ProfileEntityFromJson(Map<String, dynamic> json) =>
    _ProfileEntity(
      userId: json['userId'] as String,
      accountType: $enumDecode(_$AccountTypeEnumMap, json['accountType']),
      name: json['name'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String? ?? '',
      location: json['location'] as String? ?? '',
      contactPhone: json['contactPhone'] as String? ?? '',
      fcmToken: json['fcmToken'] as String?,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['updatedAt'],
        const TimestampConverter().fromJson,
      ),
    );

Map<String, dynamic> _$ProfileEntityToJson(_ProfileEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'accountType': _$AccountTypeEnumMap[instance.accountType]!,
      'name': instance.name,
      'email': instance.email,
      'bio': instance.bio,
      'location': instance.location,
      'contactPhone': instance.contactPhone,
      'fcmToken': instance.fcmToken,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.updatedAt,
        const TimestampConverter().toJson,
      ),
    };

const _$AccountTypeEnumMap = {
  AccountType.barber: 'barber',
  AccountType.barbershop: 'barbershop',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
