import 'package:dart_mappable/dart_mappable.dart';

import '../../core/infrastructure/mappable_hooks.dart';

part 'vacancy_match_entity.mapper.dart';

/// Representa um match entre um barbeiro e uma vaga
/// Similar ao MatchEntity mas específico para vagas
@MappableClass()
class VacancyMatchEntity with VacancyMatchEntityMappable {
  final String matchId;
  final String barberId;
  final String barbershopId;
  final String vacancyId;

  // Informações desnormalizadas para facilitar UI
  final String barberName;
  final String barbershopName;
  final String vacancyTitle;

  final String status; // pending, active, rejected, hired

  @MappableField(hook: TimestampHook())
  final DateTime createdAt;

  @MappableField(hook: TimestampHook())
  final DateTime? lastMessageAt;

  final Map<String, int> unreadCount; // {barberId: 0, barbershopId: 0}

  const VacancyMatchEntity({
    required this.matchId,
    required this.barberId,
    required this.barbershopId,
    required this.vacancyId,
    required this.barberName,
    required this.barbershopName,
    required this.vacancyTitle,
    this.status = 'pending',
    required this.createdAt,
    this.lastMessageAt,
    this.unreadCount = const {},
  });

  static const fromMap = VacancyMatchEntityMapper.fromMap;
}
