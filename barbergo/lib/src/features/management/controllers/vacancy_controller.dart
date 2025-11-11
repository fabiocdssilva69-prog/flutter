import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/application_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/vacancy_repository.dart';
import '../../../domain/entities/application_entity.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/vacancy_entity.dart';

part 'vacancy_controller.g.dart';

// Provider que retorna stream de vagas da barbearia logada
@riverpod
Stream<List<VacancyEntity>> myVacanciesStream(Ref ref) {
  // Usa ref.read para evitar rebuild loop
  final authUser = ref.read(authRepositoryProvider).currentUser;

  if (authUser == null) {
    return Stream.value([]); // Retorna lista vazia ao invés de Stream.empty()
  }

  final repository = ref.watch(vacancyRepositoryProvider);

  // Adiciona handler de erro para MapperException
  return repository
      .watchVacanciesByBarbershop(authUser.uid)
      .handleError((error, stackTrace) {
        print('❌ ERRO ao carregar vagas: $error');
        print('📍 StackTrace: $stackTrace');
      })
      .map((vacancies) {
        print('📦 Vagas carregadas: ${vacancies.length}');
        return vacancies;
      });
} // Provider que retorna stream de candidaturas para uma vaga específica

@riverpod
Stream<List<ApplicationEntity>> applicationsForVacancyStream(Ref ref, String vacancyId) {
  final repository = ref.watch(applicationRepositoryProvider);
  return repository.watchApplicationsForVacancy(vacancyId);
}

// Controller principal para gerenciamento de vagas e candidaturas
@riverpod
class ManagementController extends _$ManagementController {
  @override
  FutureOr<void> build() {}

  // Criar nova vaga
  Future<bool> createVacancy({
    required String title,
    required VacancyType type,
    double? commissionPercentage,
    required String workHours,
    required String barbershopName,
    required String locationCityState,
    Map<String, dynamic>? preciseLocation,
  }) async {
    final barbershopId = ref.read(authRepositoryProvider).currentUser?.uid;

    if (barbershopId == null) {
      state = AsyncError("Usuário não autenticado.", StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    final now = DateTime.now();
    final newVacancy = VacancyEntity(
      vacancyId: 'pending',
      barbershopId: barbershopId,
      barbershopName: barbershopName,
      title: title,
      type: type,
      commissionPercentage: commissionPercentage,
      workHours: workHours,
      locationCityState: locationCityState,
      preciseLocation: preciseLocation ?? {}, // Usa localização precisa ou vazio
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    final vacancyRepository = ref.read(vacancyRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await vacancyRepository.createVacancy(newVacancy);
    });

    return !state.hasError;
  }

  // Atualizar status de uma candidatura
  Future<void> updateApplicationStatus(String applicationId, ApplicationStatus newStatus) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(applicationRepositoryProvider);
      await repository.updateApplicationStatus(applicationId, newStatus.name);
    });

    if (state.hasError) {
      throw state.error!;
    }
  }
}
