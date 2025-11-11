import 'package:dart_mappable/dart_mappable.dart';

import '../../core/infrastructure/mappable_hooks.dart';
import 'enums.dart';

part 'application_entity.mapper.dart';

@MappableClass()
class ApplicationEntity with ApplicationEntityMappable {
  final String applicationId;
  final String vacancyId;
  final String barberId;
  final String barbershopId;
  final String barbershopName;

  final ApplicationStatus status;

  @MappableField(hook: TimestampHook())
  final DateTime createdAt;
  @MappableField(hook: TimestampHook())
  final DateTime? updatedAt;

  ApplicationEntity({
    required this.applicationId,
    required this.vacancyId,
    required this.barberId,
    required this.barbershopId,
    required this.barbershopName,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  static const fromMap = ApplicationEntityMapper.fromMap;
}
