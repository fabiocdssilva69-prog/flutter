import 'package:barbergo_app/src/domain/entities/vacancy_entity.dart';

/// Repositório responsável por operações relacionadas a vagas.
abstract class VacancyRepository {
  Future<VacancyEntity?> getVacancyById(String vacancyId);
}
