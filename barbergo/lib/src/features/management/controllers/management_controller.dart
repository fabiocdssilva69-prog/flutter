import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/application_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/chat_room_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/vacancy_repository.dart';
import '../../../domain/entities/application_entity.dart';
import '../../../domain/entities/chat/chat_room_entity.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/entities/vacancy_entity.dart';
import '../../profile/controllers/profile_controller.dart';

part 'management_controller.g.dart';

// Provedor para observar os detalhes de UMA vaga específica (usado na tela de detalhes)
@riverpod
Stream<VacancyEntity?> vacancyDetailsStream(Ref ref, String vacancyId) {
  return ref.watch(vacancyRepositoryProvider).watchVacancyById(vacancyId);
}

// Provedor para observar candidaturas de uma vaga específica
@riverpod
Stream<List<ApplicationEntity>> applicationsForVacancyStream(Ref ref, String vacancyId) {
  return ref.watch(applicationRepositoryProvider).watchApplicationsForVacancy(vacancyId);
}

// NOVO: Provedor para observar o perfil de um usuário específico (para ver dados de candidatos)
@riverpod
Stream<ProfileEntity?> userProfileStream(Ref ref, String userId) {
  return ref.watch(profileRepositoryProvider).watchProfile(userId);
}

// NOVO: Provedor para observar as vagas da barbearia logada
@riverpod
Stream<List<VacancyEntity>> myVacanciesStream(Ref ref) {
  final barbershopId = ref.watch(authRepositoryProvider).currentUser?.uid;
  if (barbershopId == null) {
    return Stream.value([]);
  }
  return ref.watch(vacancyRepositoryProvider).watchVacanciesByBarbershop(barbershopId);
}

@riverpod
class ManagementController extends _$ManagementController {
  @override
  FutureOr<void> build() {
    // Inicialização vazia
  }

  Future<bool> createVacancy({
    required String title,
    required VacancyType type,
    double? commissionPercentage,
    required String workHours,
    String? requirements,
  }) async {
    // 1. Validação de Autenticação e Perfil
    final barbershopId = ref.read(authRepositoryProvider).currentUser?.uid;
    final currentProfile = ref.read(currentUserProfileProvider).value;

    if (barbershopId == null || currentProfile == null) {
      state = AsyncError("Usuário não autenticado ou perfil não carregado.", StackTrace.current);
      return false;
    }

    // VALIDAÇÃO CRUCIAL: Garante que a localização exata (GeoPoint) esteja presente.
    if (currentProfile.preciseLocation == null || currentProfile.location.isEmpty) {
      state = AsyncError("locationRequiredForVacancy", StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    // 2. Criar a entidade (Incluindo GeoPoint desnormalizado)
    final newVacancy = VacancyEntity(
      vacancyId: 'pending',
      barbershopId: barbershopId,
      barbershopName: currentProfile.name,
      locationCityState: currentProfile.location,
      preciseLocation: currentProfile.preciseLocation!, // Garantido pela validação acima
      title: title,
      type: type,
      commissionPercentage: commissionPercentage,
      workHours: workHours,
      requirements: requirements,
      benefits: const [],
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // 3. Chamar o repositório
    final vacancyRepository = ref.read(vacancyRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await vacancyRepository.createVacancy(newVacancy);
    });

    return !state.hasError;
  }

  // NOVO: Método para Pausar/Reabrir a vaga
  Future<bool> toggleVacancyStatus({required String vacancyId, required bool currentStatus}) async {
    state = const AsyncLoading();
    final vacancyRepository = ref.read(vacancyRepositoryProvider);

    final newStatus = !currentStatus; // Inverte o status atual

    state = await AsyncValue.guard(() async {
      // A segurança de quem pode alterar a vaga deve ser garantida pelas Regras do Firestore.
      await vacancyRepository.updateVacancyStatus(vacancyId, newStatus);
    });

    // Se for bem sucedido, o stream da UI (vacancyDetailsStreamProvider) será atualizado automaticamente.
    return !state.hasError;
  }

  // NOVO: Método para aceitar/rejeitar candidatura
  Future<bool> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus newStatus,
    required String barberId,
  }) async {
    state = const AsyncLoading();
    final applicationRepository = ref.read(applicationRepositoryProvider);

    // 1. Atualiza o status da candidatura
    state = await AsyncValue.guard(() async {
      await applicationRepository.updateApplicationStatus(applicationId, newStatus.toString().split('.').last);
    });

    if (state.hasError) return false;

    // 2. Se o status for ACEITO, tenta criar a sala de chat
    if (newStatus == ApplicationStatus.accepted) {
      // Usamos um novo guard para a criação do chat. Isso garante que o erro do chat seja capturado,
      // mas não impede que a atualização do status da candidatura seja considerada bem-sucedida.
      final chatState = await AsyncValue.guard(() async {
        await _createChatRoom(barberId);
      });

      if (chatState.hasError) {
        // Se o chat falhar, definimos o estado global com o erro do chat (para a UI mostrar o alerta).
        state = chatState;
      }
    }

    // Retorna sucesso para a ação principal (atualização de status).
    return true;
  }

  Future<void> _createChatRoom(String barberId) async {
    final barbershopId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (barbershopId == null) throw Exception("Erro: Barbearia não autenticada.");

    // Precisamos dos perfis de ambos os usuários para os nomes.
    final profileRepo = ref.read(profileRepositoryProvider);
    final barbershopProfile = await profileRepo.getProfile(barbershopId);
    final barberProfile = await profileRepo.getProfile(barberId);

    if (barbershopProfile == null || barberProfile == null) {
      throw Exception("Erro: Não foi possível encontrar os perfis necessários para iniciar o chat.");
    }

    // Cria um ID único e determinístico para a sala (ordenando os UIDs alfabeticamente)
    final participantsIds = [barbershopId, barberId]..sort();
    final roomId = "${participantsIds[0]}_${participantsIds[1]}";

    // Cria a entidade da sala
    final now = DateTime.now();
    final newRoom = ChatRoomEntity(
      roomId: roomId,
      participantIds: participantsIds,
      createdAt: now,
      lastMessage: "Conversa iniciada após match!", // Mensagem inicial padrão
      lastMessageTimestamp: now,
      participants: {
        barbershopId: ParticipantInfo(userId: barbershopId, name: barbershopProfile.name),
        barberId: ParticipantInfo(userId: barberId, name: barberProfile.name),
      },
      // Inicializa contadores (Barbearia leu, Barbeiro recebe 1 não lida)
      unreadCounts: {barbershopId: 0, barberId: 1},
    );

    // Salva a sala no repositório (createRoom é idempotente)
    await ref.read(chatRoomRepositoryProvider).createRoom(newRoom);
  }
}
