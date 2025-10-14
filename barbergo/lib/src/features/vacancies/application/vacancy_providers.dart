import 'package:barbergo_app/src/domain/entities/vacancy_entity.dart';
import 'package:barbergo_app/src/domain/repositories/vacancy_repository.dart' as domain;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vacancy_repository.dart' as data;

/// Provider que expõe uma implementação que adapta nosso repository concreto
/// ao contrato abstrato do domain layer.
final domainVacancyRepositoryProvider = Provider<domain.VacancyRepository>((ref) {
  final concreteRepo = ref.watch(data.vacancyRepositoryProvider);
  return _VacancyRepositoryAdapter(concreteRepo);
});

/// Provider responsável por buscar os detalhes de uma vaga específica.
final vacancyByIdProvider = FutureProvider.family.autoDispose<VacancyEntity?, String>((ref, vacancyId) {
  final repository = ref.watch(domainVacancyRepositoryProvider);
  return repository.getVacancyById(vacancyId);
});

/// Adapter que implementa o contrato do domain reutilizando nossa implementação concreta.
class _VacancyRepositoryAdapter implements domain.VacancyRepository {
  _VacancyRepositoryAdapter(this._concreteRepository);

  final data.VacancyRepository _concreteRepository;

  @override
  Future<VacancyEntity> getVacancyById(String vacancyId) async {
    // Delega para o método implementado no repository concreto
    return _concreteRepository.getVacancyById(vacancyId);
  }
}
