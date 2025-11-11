import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/chat_room_repository.dart';
import '../../../domain/entities/chat/chat_room_entity.dart';

part 'inbox_controller.g.dart';

// Provedor que observa o stream de salas de chat do usuário logado (Inbox).
@riverpod
Stream<List<ChatRoomEntity>> inboxStream(Ref ref) {
  // Usamos authStateChangesProvider para reatividade ao login/logout.
  final authState = ref.watch(authStateChangesProvider);
  final userId = authState.value?.uid;

  if (userId == null) {
    return Stream.value([]);
  }

  return ref.watch(chatRoomRepositoryProvider).watchMyRooms(userId);
}
