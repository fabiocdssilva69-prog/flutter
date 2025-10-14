import 'package:cloud_firestore/cloud_firestore.dart';

import 'enums.dart';

class VacancyEntity {
  const VacancyEntity({
    required this.vacancyId,
    required this.barbershopId,
    required this.barbershopName,
    required this.title,
    required this.type,
    this.commissionPercentage,
    required this.workHours,
    required this.locationCityState,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String vacancyId;
  final String barbershopId;
  final String barbershopName;
  final String title;
  final VacancyType type;
  final double? commissionPercentage;
  final String workHours;
  final String locationCityState;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory VacancyEntity.fromJson(Map<String, dynamic> json) {
    return VacancyEntity(
      vacancyId: json['vacancyId'] as String,
      barbershopId: json['barbershopId'] as String,
      barbershopName: json['barbershopName'] as String,
      title: json['title'] as String,
      type: VacancyType.values.firstWhere((e) => e.toString().split('.').last == json['type']),
      commissionPercentage: (json['commissionPercentage'] as num?)?.toDouble(),
      workHours: json['workHours'] as String,
      locationCityState: json['locationCityState'] as String,
      isActive: json['isActive'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vacancyId': vacancyId,
      'barbershopId': barbershopId,
      'barbershopName': barbershopName,
      'title': title,
      'type': type.toString().split('.').last,
      'commissionPercentage': commissionPercentage,
      'workHours': workHours,
      'locationCityState': locationCityState,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  VacancyEntity copyWith({
    String? vacancyId,
    String? barbershopId,
    String? barbershopName,
    String? title,
    VacancyType? type,
    double? commissionPercentage,
    String? workHours,
    String? locationCityState,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VacancyEntity(
      vacancyId: vacancyId ?? this.vacancyId,
      barbershopId: barbershopId ?? this.barbershopId,
      barbershopName: barbershopName ?? this.barbershopName,
      title: title ?? this.title,
      type: type ?? this.type,
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
      workHours: workHours ?? this.workHours,
      locationCityState: locationCityState ?? this.locationCityState,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
