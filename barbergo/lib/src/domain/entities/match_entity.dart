import 'package:dart_mappable/dart_mappable.dart';

import 'package:barbergo_app/src/core/infrastructure/mappable_hooks.dart';

part 'match_entity.mapper.dart';

@MappableClass()
class MatchEntity with MatchEntityMappable {
  final String matchId;
  final List<String> participants;

  @MappableField(hook: TimestampHook())
  final DateTime matchedAt;

  final Map<String, dynamic>? contactInfo;

  const MatchEntity({required this.matchId, required this.participants, required this.matchedAt, this.contactInfo});

  // Factory constructors para compatibilidade com repositórios
  static MatchEntity fromMap(Map<String, dynamic> map) => MatchEntityMapper.fromMap(map);

  static MatchEntity fromJson(String json) => MatchEntityMapper.fromJson(json);
}
