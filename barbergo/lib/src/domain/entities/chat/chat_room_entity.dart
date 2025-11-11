import 'package:dart_mappable/dart_mappable.dart';

import '../../../core/infrastructure/mappable_hooks.dart';

part 'chat_room_entity.mapper.dart';

// Classe auxiliar para informações básicas dos participantes
@MappableClass()
class ParticipantInfo with ParticipantInfoMappable {
  final String userId;
  final String name;
  // final String? avatarUrl; // Adicionar na Sprint de Mídia

  ParticipantInfo({required this.userId, required this.name});

  static const fromMap = ParticipantInfoMapper.fromMap;
}

@MappableClass()
class ChatRoomEntity with ChatRoomEntityMappable {
  final String roomId;

  // Lista de IDs para queries eficientes (array-contains no Firestore)
  final List<String> participantIds;

  // Mapa de Participantes (Chave = UserId, Valor = Info Básica)
  final Map<String, ParticipantInfo> participants;

  // Metadados da Última Mensagem (Desnormalizados)
  final String? lastMessage;
  @MappableField(hook: TimestampHook())
  final DateTime? lastMessageTimestamp;

  // Contagem de não lidas (Chave = UserId, Valor = Contagem)
  final Map<String, int> unreadCounts;

  @MappableField(hook: TimestampHook())
  final DateTime createdAt;

  ChatRoomEntity({
    required this.roomId,
    required this.participantIds,
    required this.participants,
    required this.createdAt,
    required this.unreadCounts,
    this.lastMessage,
    this.lastMessageTimestamp,
  });

  static const fromMap = ChatRoomEntityMapper.fromMap;
}
