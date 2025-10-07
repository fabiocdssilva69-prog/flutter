import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'converters.dart';
import 'enums.dart';

part 'vacancy_entity.freezed.dart';
part 'vacancy_entity.g.dart';

@freezed
class VacancyEntity with _$VacancyEntity {
  const factory VacancyEntity({
    required String vacancyId,
    required String barbershopId,
    required String title,
    required VacancyType type,
    double? commissionPercentage,
    required String workHours,
    required bool isActive,
    @DateTimeTimestampConverter() required DateTime createdAt,
  }) = _VacancyEntity;

  factory VacancyEntity.fromJson(Map<String, dynamic> json) =>
      _$VacancyEntityFromJson(json);
}
