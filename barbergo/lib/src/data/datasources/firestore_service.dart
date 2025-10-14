import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_service.g.dart';

// Provedor para a instância do Cloud Firestore
@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

// Serviço centralizado para operações CRUD no Firestore
class FirestoreService {
  FirestoreService(this._db);
  final FirebaseFirestore _db;

  // Expõe o db para acesso direto se necessário (ex: transações, geração de ID)
  FirebaseFirestore get db => _db;

  // Método Genérico para definir (Criar/Atualizar) um documento
  Future<void> setData({required String path, required Map<String, dynamic> data, bool merge = false}) async {
    final reference = _db.doc(path);
    await reference.set(data, SetOptions(merge: merge));
  }

  // Método para atualizar campos específicos de um documento
  Future<void> updateDocument({required String path, required Map<String, dynamic> data}) async {
    final reference = _db.doc(path);
    await reference.update(data);
  }

  // Método Genérico para obter um Stream de um documento específico
  Stream<T?> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = _db.doc(path);
    return reference.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return builder(snapshot.data()!, snapshot.id);
      }
      return null;
    });
  }

  // Método Genérico para obter um Stream de uma coleção (com filtros e ordenação)
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query = _db.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query) ?? query;
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs.map((doc) => builder(doc.data(), doc.id)).where((value) => value != null).toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }
}

// Provedor para o FirestoreService
@riverpod
FirestoreService firestoreService(Ref ref) {
  final db = ref.watch(firebaseFirestoreProvider);
  return FirestoreService(db);
}
