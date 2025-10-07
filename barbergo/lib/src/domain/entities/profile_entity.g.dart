// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileEntity _$ProfileEntityFromJson(Map<String, dynamic> json) =>
    _ProfileEntity(
      profileId: json['profileId'] as String,
      accountType: $enumDecode(_$AccountTypeEnumMap, json['accountType']),
      name: json['name'] as String,
      bio: json['bio'] as String?,
      city: json['city'] as String,
      neighborhood: json['neighborhood'] as String,
      specialties: (json['specialties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      portfolioUrls: (json['portfolioUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      galleryUrls: (json['galleryUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProfileEntityToJson(_ProfileEntity instance) =>
    <String, dynamic>{
      'profileId': instance.profileId,
      'accountType': _$AccountTypeEnumMap[instance.accountType]!,
      'name': instance.name,
      'bio': instance.bio,
      'city': instance.city,
      'neighborhood': instance.neighborhood,
      'specialties': instance.specialties,
      'portfolioUrls': instance.portfolioUrls,
      'amenities': instance.amenities,
      'galleryUrls': instance.galleryUrls,
    };

const _$AccountTypeEnumMap = {
  AccountType.barber: 'barber',
  AccountType.barbershop: 'barbershop',
};
