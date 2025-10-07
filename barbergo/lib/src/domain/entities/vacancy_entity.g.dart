// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VacancyEntity _$VacancyEntityFromJson(Map<String, dynamic> json) =>
    _VacancyEntity(
      vacancyId: json['vacancyId'] as String,
      barbershopId: json['barbershopId'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$VacancyTypeEnumMap, json['type']),
      commissionPercentage: (json['commissionPercentage'] as num?)?.toDouble(),
      workHours: json['workHours'] as String,
      isActive: json['isActive'] as bool,
      createdAt: const DateTimeTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$VacancyEntityToJson(_VacancyEntity instance) =>
    <String, dynamic>{
      'vacancyId': instance.vacancyId,
      'barbershopId': instance.barbershopId,
      'title': instance.title,
      'type': _$VacancyTypeEnumMap[instance.type]!,
      'commissionPercentage': instance.commissionPercentage,
      'workHours': instance.workHours,
      'isActive': instance.isActive,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
    };

const _$VacancyTypeEnumMap = {
  VacancyType.freelancer: 'freelancer',
  VacancyType.clt: 'clt',
  VacancyType.commission: 'commission',
};
