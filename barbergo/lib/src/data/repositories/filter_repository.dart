import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/filter_preferences.dart';

part 'filter_repository.g.dart';

/// Repositório para gerenciar preferências de filtro no Firestore
@riverpod
FilterRepository filterRepository(Ref ref) {
  return FilterRepository(FirebaseFirestore.instance);
}

class FilterRepository {
  final FirebaseFirestore _firestore;

  FilterRepository(this._firestore);

  /// Caminho da subcollection de preferências
  CollectionReference _getPreferencesCollection(String userId) {
    return _firestore.collection('profiles').doc(userId).collection('preferences');
  }

  /// Salva as preferências de filtro do usuário
  Future<void> saveFilterPreferences(String userId, FilterPreferences preferences) async {
    await _getPreferencesCollection(userId).doc('filters').set(preferences.toMap());
  }

  /// Carrega as preferências de filtro do usuário
  /// Retorna valores padrão se não houver preferências salvas
  Future<FilterPreferences> loadFilterPreferences(String userId) async {
    final doc = await _getPreferencesCollection(userId).doc('filters').get();

    if (!doc.exists || doc.data() == null) {
      return FilterPreferences.defaults;
    }

    try {
      return FilterPreferencesMapper.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      // Se houver erro ao parsear, retornar padrão
      return FilterPreferences.defaults;
    }
  }

  /// Observa mudanças nas preferências em tempo real
  Stream<FilterPreferences> watchFilterPreferences(String userId) {
    return _getPreferencesCollection(userId).doc('filters').snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return FilterPreferences.defaults;
      }

      try {
        return FilterPreferencesMapper.fromMap(snapshot.data() as Map<String, dynamic>);
      } catch (e) {
        return FilterPreferences.defaults;
      }
    });
  }

  /// Remove todas as preferências (volta ao padrão)
  Future<void> clearFilterPreferences(String userId) async {
    await _getPreferencesCollection(userId).doc('filters').delete();
  }
}
