import 'package:dart_mappable/dart_mappable.dart';

import '../../../core/infrastructure/mappable_hooks.dart';

part 'direct_message_entity.mapper.dart';

@MappableClass()
class DirectMessageEntity with DirectMessageEntityMappable {
  final String messageId;
  final String senderId;
  final String content;

  @MappableField(hook: TimestampHook())
  final DateTime timestamp;

  // Status de envio (para atualização otimista)
  final bool isSent;

  DirectMessageEntity({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isSent = false,
  });

  static const fromMap = DirectMessageEntityMapper.fromMap;
}
