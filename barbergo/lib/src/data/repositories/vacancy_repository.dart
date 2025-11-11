import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart'; // NOVO: Sprint 24
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/vacancy_entity.dart';
import '../datasources/firestore_service.dart';

part 'vacancy_repository.g.dart';

class VacancyRepository {
  VacancyRepository(this._service);
  final FirestoreService _service;

  static const String vacanciesPath = 'vacancies';
  static String vacancyPath(String id) => '$vacanciesPath/$id';

  // Cria uma nova vaga (gera ID automaticamente)
  Future<String> createVacancy(VacancyEntity vacancy) async {
    // Acessamos o Firestore diretamente via service.db para gerar um novo ID
    final docRef = _service.db.collection(vacanciesPath).doc();

    // Atualizamos a entidade com o ID gerado antes de salvar
    final vacancyWithId = vacancy.copyWith(vacancyId: docRef.id);
    await docRef.set(vacancyWithId.toMap());
    return docRef.id;
  }

  // Smart Matching v2 - Consulta por Raio
  // Retorna um Stream de listas de vagas dentro do raio especificado.
  Stream<List<VacancyEntity>> queryByRadius({required GeoFirePoint center, required double radiusInKm}) {
    // Define a coleção a ser consultada
    final collection = _service.db.collection(vacanciesPath);

    // Cria uma GeoCollectionReference para consultas geoespaciais
    final geoCollection = GeoCollectionReference<Map<String, dynamic>>(collection);

    // Define o campo que contém o GeoFirePoint (definido na entidade)
    const field = 'preciseLocation';

    // Executa a consulta geoespacial usando GeoCollectionReference
    // Nota Importante: Firestore não permite combinar GeoQueries com outros filtros de desigualdade facilmente.
    // Consultamos tudo no raio e filtramos 'isActive' no cliente (que é eficiente o suficiente para o MVP).
    final stream = geoCollection.subscribeWithin(
      center: center,
      radiusInKm: radiusInKm,
      field: field,
      // geopointFrom: função que extrai o GeoPoint do documento
      geopointFrom: (data) {
        final preciseLocation = data[field] as Map<String, dynamic>?;
        if (preciseLocation != null && preciseLocation['geopoint'] != null) {
          return preciseLocation['geopoint'] as GeoPoint;
        }
        // Fallback: retorna um ponto padrão se não houver localização
        return const GeoPoint(0, 0);
      },
      // strictMode garante precisão no raio
      strictMode: true,
    );

    // Mapeia os resultados e aplica filtro adicional
    return stream.map((snapshotList) {
      final vacancies = snapshotList.map((doc) {
        final data = doc.data();
        if (data == null) return null;
        return VacancyEntity.fromMap(data);
      }).whereType<VacancyEntity>(); // Remove os nulos

      // FILTRO ADICIONAL (Client-Side): Garante que apenas vagas ATIVAS sejam retornadas.
      return vacancies.where((v) => v.isActive).toList();

      // A ordem é por proximidade devido à natureza da GeoQuery.
    });
  }

  // NOVO: Atualiza o status (isActive) de uma vaga
  Future<void> updateVacancyStatus(String vacancyId, bool isActive) async {
    final docRef = _service.db.collection(vacanciesPath).doc(vacancyId);
    await docRef.update({'isActive': isActive, 'updatedAt': DateTime.now().toIso8601String()});
  }

  // NOVO: Observa uma única vaga pelo ID (para a tela de detalhes)
  Stream<VacancyEntity?> watchVacancyById(String vacancyId) {
    final docRef = _service.db.collection(vacanciesPath).doc(vacancyId);
    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        return VacancyEntity.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Obtém uma vaga específica (leitura única) (Resolve pendência do relatório)
  Future<VacancyEntity?> getVacancyById(String id) async {
    return _service
        .documentStream<VacancyEntity>(
          path: vacancyPath(id),
          builder: (data, id) => VacancyEntity.fromMap(data).copyWith(vacancyId: id),
        )
        .first;
  }

  // Obtém vagas criadas por uma barbearia específica
  Stream<List<VacancyEntity>> watchVacanciesByBarbershop(String barbershopId) =>
      _service.collectionStream<VacancyEntity>(
        path: vacanciesPath,
        queryBuilder: (query) =>
            query.where('barbershopId', isEqualTo: barbershopId).orderBy('createdAt', descending: true),
        builder: (data, id) => VacancyEntity.fromMap(data).copyWith(vacancyId: id),
      );

  // Obtém todas as vagas ativas (para barbeiros descobrirem)
  Stream<List<VacancyEntity>> watchActiveVacancies() => _service.collectionStream<VacancyEntity>(
    path: vacanciesPath,
    queryBuilder: (query) => query.where('isActive', isEqualTo: true).orderBy('createdAt', descending: true).limit(50),
    builder: (data, id) => VacancyEntity.fromMap(data).copyWith(vacancyId: id),
  );
}

// Provedor para o VacancyRepository
@riverpod
VacancyRepository vacancyRepository(Ref ref) {
  final service = ref.watch(firestoreServiceProvider);
  return VacancyRepository(service);
}
