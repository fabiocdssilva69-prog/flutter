import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/application_entity.dart';
import '../datasources/firestore_service.dart';

part 'application_repository.g.dart';

class ApplicationRepository {
  ApplicationRepository(this._service);
  final FirestoreService _service;

  static const String applicationsPath = 'applications';

  // Obtém um Stream de candidaturas para uma barbearia específica (Resolve pendência do relatório)
  Stream<List<ApplicationEntity>> watchApplicationsForBarbershop(String barbershopId) =>
      _service.collectionStream<ApplicationEntity>(
        path: applicationsPath,
        queryBuilder: (query) =>
            query.where('barbershopId', isEqualTo: barbershopId).orderBy('createdAt', descending: true),
        // Garantimos que o ID do documento seja atribuído à entidade
        builder: (data, id) => ApplicationEntity.fromMap(data).copyWith(applicationId: id),
      );

  // Cria uma nova candidatura
  Future<String> createApplication(ApplicationEntity application) async {
    final docRef = _service.db.collection(applicationsPath).doc();
    final applicationWithId = application.copyWith(applicationId: docRef.id);
    await docRef.set(applicationWithId.toMap());
    return docRef.id;
  }

  // Obtém candidaturas para uma vaga específica
  Stream<List<ApplicationEntity>> watchApplicationsForVacancy(String vacancyId) {
    print('🔍 Buscando applications para vacancyId: $vacancyId');
    return _service
        .collectionStream<ApplicationEntity>(
          path: applicationsPath,
          queryBuilder: (query) =>
              query.where('vacancyId', isEqualTo: vacancyId).orderBy('createdAt', descending: true),
          builder: (data, id) {
            print('📝 Application data: $data');
            return ApplicationEntity.fromMap(data).copyWith(applicationId: id);
          },
        )
        .handleError((error, stackTrace) {
          print('❌ ERRO ao carregar applications: $error');
          print('📍 StackTrace: $stackTrace');
        })
        .map((applications) {
          print('📦 Applications carregadas: ${applications.length}');
          return applications;
        });
  }

  // Obtém candidaturas de um barbeiro específico
  Stream<List<ApplicationEntity>> watchApplicationsByBarber(String barberId) =>
      _service.collectionStream<ApplicationEntity>(
        path: applicationsPath,
        queryBuilder: (query) => query.where('barberId', isEqualTo: barberId).orderBy('createdAt', descending: true),
        builder: (data, id) => ApplicationEntity.fromMap(data).copyWith(applicationId: id),
      );

  // Atualiza o status de uma candidatura
  Future<void> updateApplicationStatus(String applicationId, String status) async {
    await _service.updateDocument(path: '$applicationsPath/$applicationId', data: {'status': status});
  }
}

// Provedor para o ApplicationRepository
@riverpod
ApplicationRepository applicationRepository(Ref ref) {
  final service = ref.watch(firestoreServiceProvider);
  return ApplicationRepository(service);
}
