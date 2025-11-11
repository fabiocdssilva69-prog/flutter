import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/chat/direct_message_entity.dart';

part 'direct_message_state.mapper.dart';

@MappableClass()
class DirectMessageState with DirectMessageStateMappable {
  final List<DirectMessageEntity> messages;
  final bool hasMore;
  final bool isLoadingMore;

  DirectMessageState({required this.messages, required this.hasMore, this.isLoadingMore = false});
}
