import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/vacancy_repository.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/entities/vacancy_entity.dart';

part 'discovery_controller.g.dart';

// Provider que retorna um Stream de vagas ativas para o feed de descoberta
@Riverpod(keepAlive: true)
Stream<List<VacancyEntity>> activeVacanciesStream(Ref ref) {
  final repository = ref.watch(vacancyRepositoryProvider);
  return repository.watchActiveVacancies();
}

// Provider para perfis de descoberta (SwipeScreen)
@Riverpod(keepAlive: true)
Stream<List<ProfileEntity>> discoverProfiles(Ref ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.watchAllProfiles();
}
