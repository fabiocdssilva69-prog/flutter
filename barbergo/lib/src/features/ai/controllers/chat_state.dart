import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/ai/chat_message.dart';

part 'chat_state.mapper.dart';

// Estado complexo para o controlador
@MappableClass()
class ChatStateData with ChatStateDataMappable {
  final List<ChatMessage> messages;
  final bool hasMore;
  final bool isLoadingMore;

  ChatStateData({required this.messages, required this.hasMore, this.isLoadingMore = false});

  static const fromMap = ChatStateDataMapper.fromMap;
}
