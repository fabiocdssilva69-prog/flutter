import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/vacancy_entity.dart';
import '../datasources/firestore_service.dart';

part 'vacancy_repository.g.dart';

class VacancyRepository {
  VacancyRepository(this._service);
  final FirestoreService _service;

  static const String vacanciesPath = 'Vacancies';
  static String vacancyPath(String id) => '$vacanciesPath/$id';

  // Cria uma nova vaga (gera ID automaticamente)
  Future<String> createVacancy(VacancyEntity vacancy) async {
    // Acessamos o Firestore diretamente via service.db para gerar um novo ID
    final docRef = _service.db.collection(vacanciesPath).doc();

    // Atualizamos a entidade com o ID gerado antes de salvar
    final vacancyWithId = vacancy.copyWith(vacancyId: docRef.id);
    await docRef.set(vacancyWithId.toJson());
    return docRef.id;
  }

  // Obtém um Stream de todas as vagas ativas (para o feed/swipe)
  Stream<List<VacancyEntity>> watchActiveVacancies() => _service.collectionStream<VacancyEntity>(
    path: vacanciesPath,
    queryBuilder: (query) => query.where('isActive', isEqualTo: true).orderBy('createdAt', descending: true),
    // Garantimos que o ID do documento seja atribuído à entidade
    builder: (data, id) => VacancyEntity.fromJson(data).copyWith(vacancyId: id),
  );

  // Obtém uma vaga específica (leitura única) (Resolve pendência do relatório)
  Future<VacancyEntity?> getVacancyById(String id) async {
    return _service
        .documentStream<VacancyEntity>(
          path: vacancyPath(id),
          builder: (data, id) => VacancyEntity.fromJson(data).copyWith(vacancyId: id),
        )
        .first;
  }

  // Obtém vagas criadas por uma barbearia específica
  Stream<List<VacancyEntity>> watchVacanciesByBarbershop(String barbershopId) =>
      _service.collectionStream<VacancyEntity>(
        path: vacanciesPath,
        queryBuilder: (query) =>
            query.where('barbershopId', isEqualTo: barbershopId).orderBy('createdAt', descending: true),
        builder: (data, id) => VacancyEntity.fromJson(data).copyWith(vacancyId: id),
      );
}

// Provedor para o VacancyRepository
@riverpod
VacancyRepository vacancyRepository(Ref ref) {
  final service = ref.watch(firestoreServiceProvider);
  return VacancyRepository(service);
}
