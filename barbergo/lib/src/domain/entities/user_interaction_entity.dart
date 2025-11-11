import 'package:dart_mappable/dart_mappable.dart';

import '../../core/infrastructure/mappable_hooks.dart';

part 'user_interaction_entity.mapper.dart';

enum InteractionType { applied, ignored }

@MappableClass()
class UserInteractionEntity with UserInteractionEntityMappable {
  final String vacancyId;
  final InteractionType type;

  @MappableField(hook: TimestampHook())
  final DateTime timestamp;

  UserInteractionEntity({required this.vacancyId, required this.type, required this.timestamp});

  static const fromMap = UserInteractionEntityMapper.fromMap;
}
