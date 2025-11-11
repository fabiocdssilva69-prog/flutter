import 'package:cloud_firestore/cloud_firestore.dart'; // Para GeoPoint
import 'package:dart_mappable/dart_mappable.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart'; // NOVO: Sprint 24

import '../../core/infrastructure/mappable_hooks.dart';
import 'enums.dart';

part 'vacancy_entity.mapper.dart';

@MappableClass()
class VacancyEntity with VacancyEntityMappable {
  final String vacancyId;
  final String barbershopId;
  final String barbershopName;
  final String locationCityState;

  // NOVO (GEO - Sprint 24): Localização Exata (Chave para a busca por raio)
  // Armazenado como Map para compatibilidade com dart_mappable
  @MappableField(hook: GeoFirePointHook())
  final Map<String, dynamic>? preciseLocation; // OPCIONAL para compatibilidade

  final String title;
  final VacancyType type;
  final double? commissionPercentage;
  final String workHours;
  final String? requirements;
  final List<String>? benefits;

  final bool isActive;

  @MappableField(hook: TimestampHook())
  final DateTime createdAt;
  @MappableField(hook: TimestampHook())
  final DateTime? updatedAt;

  VacancyEntity({
    required this.vacancyId,
    required this.barbershopId,
    required this.barbershopName,
    required this.locationCityState,
    this.preciseLocation, // OPCIONAL (Sprint 24)
    required this.title,
    required this.type,
    required this.workHours,
    required this.isActive,
    required this.createdAt,
    this.commissionPercentage,
    this.requirements,
    this.benefits,
    this.updatedAt,
  });

  // Getter para converter preciseLocation de Map para GeoFirePoint
  GeoFirePoint get geoLocation {
    if (preciseLocation == null) {
      return GeoFirePoint(const GeoPoint(0, 0));
    }
    try {
      final geopoint = preciseLocation!['geopoint'];
      if (geopoint is GeoPoint) {
        return GeoFirePoint(geopoint);
      }
    } catch (e) {
      // Se falhar, cria um ponto padrão (0,0)
      return GeoFirePoint(const GeoPoint(0, 0));
    }
    return GeoFirePoint(const GeoPoint(0, 0));
  }

  static const fromMap = VacancyEntityMapper.fromMap;
}
