import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/vacancy_entity.dart';

part 'vacancy_repository.g.dart';

class VacancyRepository {
  VacancyRepository(this._firestore);
  final FirebaseFirestore _firestore;

  /// Cria uma nova vaga na coleção "Vacancies" do Firestore.
  Future<void> createVacancy(VacancyEntity vacancy) async {
    await _firestore
        .collection('Vacancies')
        .doc(vacancy.vacancyId)
        .set(vacancy.toJson());
  }

  /// Retorna uma stream com todas as vagas ativas para feed em tempo real.
  /// Ordenado por data de criação (mais recentes primeiro).
  Stream<List<VacancyEntity>> watchActiveVacancies() {
    return _firestore
        .collection('Vacancies')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return VacancyEntity.fromJson(doc.data());
          }).toList();
        });
  }

  /// Busca vagas por ID da barbearia (para gerenciamento).
  Stream<List<VacancyEntity>> watchVacanciesByBarbershop(String barbershopId) {
    return _firestore
        .collection('Vacancies')
        .where('barbershopId', isEqualTo: barbershopId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return VacancyEntity.fromJson(doc.data());
          }).toList();
        });
  }

  /// Atualiza o status de uma vaga (ativar/desativar).
  Future<void> updateVacancyStatus(String vacancyId, bool isActive) async {
    await _firestore.collection('Vacancies').doc(vacancyId).update({
      'isActive': isActive,
    });
  }

  /// Busca uma vaga específica pelo ID.
  Future<VacancyEntity> getVacancyById(String vacancyId) async {
    final doc = await _firestore.collection('Vacancies').doc(vacancyId).get();

    if (!doc.exists) {
      throw Exception('Vaga não encontrada com ID: $vacancyId');
    }

    return VacancyEntity.fromJson(doc.data()!);
  }
}

/// Provedor do VacancyRepository.
@riverpod
VacancyRepository vacancyRepository(Ref ref) {
  final firestore = FirebaseFirestore.instance;
  return VacancyRepository(firestore);
}

/// StreamProvider que retorna todas as vagas ativas em tempo real.
@riverpod
Stream<List<VacancyEntity>> activeVacancies(Ref ref) {
  return ref.watch(vacancyRepositoryProvider).watchActiveVacancies();
}

/// StreamProvider que retorna as vagas de uma barbearia específica.
@riverpod
Stream<List<VacancyEntity>> barbershopVacancies(Ref ref, String barbershopId) {
  return ref
      .watch(vacancyRepositoryProvider)
      .watchVacanciesByBarbershop(barbershopId);
}
