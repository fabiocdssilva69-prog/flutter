import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user_interaction_entity.dart';
import '../datasources/firestore_service.dart';
import 'profile_repository.dart'; // Para usar o caminho 'profiles'

part 'interaction_repository.g.dart';

@riverpod
InteractionRepository interactionRepository(Ref ref) {
  return InteractionRepository(service: ref.watch(firestoreServiceProvider));
}

class InteractionRepository {
  final FirestoreService _service;

  InteractionRepository({required FirestoreService service}) : _service = service;

  // Estrutura: profiles/{userId}/interactions/{vacancyId}
  CollectionReference _getInteractionsCollection(String userId) {
    // Usamos o caminho definido no ProfileRepository para consistência
    return _service.db.collection(ProfileRepository.profilesPath).doc(userId).collection('interactions');
  }

  // Registra a interação (usando vacancyId como ID do documento)
  Future<void> recordInteraction(String userId, UserInteractionEntity interaction) async {
    final collection = _getInteractionsCollection(userId);
    await collection.doc(interaction.vacancyId).set(interaction.toMap(), SetOptions(merge: true));
  }

  // Observa o conjunto (Set) de IDs de vagas interagidas (Eficiente para filtragem)
  Stream<Set<String>> watchInteractedVacancyIds(String userId) {
    final collection = _getInteractionsCollection(userId);
    return collection.snapshots().map((snapshot) {
      // Retorna um Set<String> para lookups O(1)
      return snapshot.docs.map((doc) => doc.id).toSet();
    });
  }
}
