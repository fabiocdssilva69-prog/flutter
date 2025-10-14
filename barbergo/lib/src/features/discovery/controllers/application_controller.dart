import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/application_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/application_entity.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/vacancy_entity.dart';

part 'application_controller.g.dart';

@riverpod
class ApplicationController extends _$ApplicationController {
  @override
  void build() {
    // Não retorna nada específico no estado inicial
  }

  // Método para aplicar em uma vaga
  Future<void> applyForVacancy(VacancyEntity vacancy) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      // Obter o ID do usuário atual
      final authUser = ref.read(authStateChangesProvider).value;
      if (authUser == null) {
        throw Exception('Você precisa estar logado para se candidatar.');
      }

      final repository = ref.read(applicationRepositoryProvider);

      // Criar a entidade de candidatura
      final application = ApplicationEntity(
        applicationId: '', // Será preenchido no repository
        vacancyId: vacancy.vacancyId,
        barbershopId: vacancy.barbershopId,
        barbershopName: vacancy.barbershopName,
        barberId: authUser.uid,
        status: ApplicationStatus.pending,
        createdAt: DateTime.now(),
      );

      // Salvar no Firestore
      await repository.createApplication(application);
    });
  }
}
