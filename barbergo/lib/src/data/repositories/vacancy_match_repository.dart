import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/vacancy_match_entity.dart';
import '../datasources/firestore_service.dart';

part 'vacancy_match_repository.g.dart';

/// Repository para gerenciar matches entre barbeiros e vagas
/// Similar ao MatchRepository mas específico para vagas
class VacancyMatchRepository {
  final FirestoreService _service;
  static const String matchesPath = 'vacancy_matches';

  VacancyMatchRepository(this._service);

  /// Criar um match entre barbeiro e vaga
  Future<String> createMatch({
    required String barberId,
    required String barbershopId,
    required String vacancyId,
    required String barberName,
    required String barbershopName,
    required String vacancyTitle,
  }) async {
    final match = VacancyMatchEntity(
      matchId: '',
      barberId: barberId,
      barbershopId: barbershopId,
      vacancyId: vacancyId,
      barberName: barberName,
      barbershopName: barbershopName,
      vacancyTitle: vacancyTitle,
      status: 'active',
      createdAt: DateTime.now(),
      unreadCount: {barberId: 0, barbershopId: 0},
    );

    final docRef = _service.db.collection(matchesPath).doc();
    final matchWithId = match.copyWith(matchId: docRef.id);
    await docRef.set(matchWithId.toMap());

    print('✅ Match criado: $barberId <-> $vacancyId (${docRef.id})');
    return docRef.id;
  }

  /// Verificar se já existe match entre barbeiro e vaga
  Future<VacancyMatchEntity?> getMatch(String barberId, String vacancyId) async {
    final query = await _service.db
        .collection(matchesPath)
        .where('barberId', isEqualTo: barberId)
        .where('vacancyId', isEqualTo: vacancyId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return VacancyMatchEntity.fromMap(query.docs.first.data()).copyWith(matchId: query.docs.first.id);
  }

  /// Listar matches ativos de uma vaga (para barbearia ver candidatos)
  Stream<List<VacancyMatchEntity>> watchVacancyMatches(String vacancyId) {
    print('🔍 Buscando matches para vacancyId: $vacancyId');

    return _service
        .collectionStream<VacancyMatchEntity>(
          path: matchesPath,
          queryBuilder: (query) =>
              query.where('vacancyId', isEqualTo: vacancyId).orderBy('createdAt', descending: true),
          builder: (data, id) {
            print('📝 Match data: $data');
            return VacancyMatchEntity.fromMap(data).copyWith(matchId: id);
          },
        )
        .handleError((error, stackTrace) {
          print('❌ ERRO ao carregar matches: $error');
          print('📍 StackTrace: $stackTrace');
        })
        .map((matches) {
          // Filtrar apenas matches ativos no cliente
          final activeMatches = matches.where((m) => m.status == 'active').toList();
          print('📦 Matches carregados: ${activeMatches.length} de ${matches.length}');
          return activeMatches;
        });
  }

  /// Listar matches do barbeiro (suas candidaturas)
  Stream<List<VacancyMatchEntity>> watchBarberMatches(String barberId) {
    return _service.collectionStream<VacancyMatchEntity>(
      path: matchesPath,
      queryBuilder: (query) => query
          .where('barberId', isEqualTo: barberId)
          .where('status', isEqualTo: 'active')
          .orderBy('createdAt', descending: true),
      builder: (data, id) => VacancyMatchEntity.fromMap(data).copyWith(matchId: id),
    );
  }

  /// Atualizar status do match
  Future<void> updateMatchStatus(String matchId, String status) async {
    await _service.updateDocument(path: '$matchesPath/$matchId', data: {'status': status});
  }

  /// Atualizar informações de última mensagem
  Future<void> updateLastMessage(String matchId) async {
    await _service.updateDocument(path: '$matchesPath/$matchId', data: {'lastMessageAt': DateTime.now()});
  }
}

@riverpod
VacancyMatchRepository vacancyMatchRepository(Ref ref) {
  final service = ref.watch(firestoreServiceProvider);
  return VacancyMatchRepository(service);
}
