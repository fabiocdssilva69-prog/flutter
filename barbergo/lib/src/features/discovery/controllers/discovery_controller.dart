import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/vacancy_repository.dart';
import '../../../domain/entities/vacancy_entity.dart';

part 'discovery_controller.g.dart';

// Provider que retorna um Stream de vagas ativas para o feed de descoberta
@Riverpod(keepAlive: true)
Stream<List<VacancyEntity>> activeVacanciesStream(
  Ref ref,
) {
  final repository = ref.watch(vacancyRepositoryProvider);
  return repository.watchActiveVacancies();
}
