import 'package:cloud_firestore/cloud_firestore.dart';

import 'enums.dart';

class ApplicationEntity {
  const ApplicationEntity({
    required this.applicationId,
    required this.vacancyId,
    required this.barberId,
    required this.barbershopId,
    required this.barbershopName,
    required this.status,
    required this.createdAt,
  });

  final String applicationId;
  final String vacancyId;
  final String barberId;
  final String barbershopId;
  final String barbershopName;
  final ApplicationStatus status;
  final DateTime createdAt;

  factory ApplicationEntity.fromJson(Map<String, dynamic> json) {
    return ApplicationEntity(
      applicationId: json['applicationId'] as String,
      vacancyId: json['vacancyId'] as String,
      barberId: json['barberId'] as String,
      barbershopId: json['barbershopId'] as String,
      barbershopName: json['barbershopName'] as String,
      status: ApplicationStatus.values.firstWhere((e) => e.toString().split('.').last == json['status']),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicationId': applicationId,
      'vacancyId': vacancyId,
      'barberId': barberId,
      'barbershopId': barbershopId,
      'barbershopName': barbershopName,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ApplicationEntity copyWith({
    String? applicationId,
    String? vacancyId,
    String? barberId,
    String? barbershopId,
    String? barbershopName,
    ApplicationStatus? status,
    DateTime? createdAt,
  }) {
    return ApplicationEntity(
      applicationId: applicationId ?? this.applicationId,
      vacancyId: vacancyId ?? this.vacancyId,
      barberId: barberId ?? this.barberId,
      barbershopId: barbershopId ?? this.barbershopId,
      barbershopName: barbershopName ?? this.barbershopName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
