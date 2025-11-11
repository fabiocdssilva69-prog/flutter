import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/profile_entity.dart';
import '../datasources/firestore_service.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(service: ref.watch(firestoreServiceProvider));
}

class ProfileRepository {
  final FirestoreService _service;
  ProfileRepository({required FirestoreService service}) : _service = service;

  // Usamos a coleção 'profiles'. Isso substitui a coleção 'users' anterior.
  static const String profilesPath = 'profiles';

  // Salva ou atualiza o perfil (Cria se não existir, sobrescreve se existir)
  Future<void> saveProfile(ProfileEntity profile) async {
    // Atualiza o timestamp antes de salvar
    final profileToSave = profile.copyWith(updatedAt: DateTime.now());
    await _service.db.collection(profilesPath).doc(profile.userId).set(profileToSave.toMap());
  }

  // Observa as mudanças no perfil de um usuário específico (Real-time)
  Stream<ProfileEntity?> watchProfile(String userId) {
    final docRef = _service.db.collection(profilesPath).doc(userId);
    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        // CRITICAL FIX: Converte Timestamp para DateTime ANTES do fromMap
        final convertedData = _convertTimestampsToDateTime(data);
        final profile = ProfileEntity.fromMap(convertedData);
        return profile;
      }
      return null;
    });
  }

  // Busca o perfil de um usuário específico (One-time read)
  Future<ProfileEntity?> getProfile(String userId) async {
    final docSnapshot = await _service.db.collection(profilesPath).doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      // CRITICAL FIX: Converte Timestamp para DateTime ANTES do fromMap
      final convertedData = _convertTimestampsToDateTime(data);
      return ProfileEntity.fromMap(convertedData);
    }
    return null;
  }

  // Observa todos os perfis (para discovery/swipe)
  // CORREÇÃO BUG P1 #2: Query otimizada com composite index
  // Ordem: Boosted primeiro → Premium → Recentes
  Stream<List<ProfileEntity>> watchAllProfiles() {
    return _service.db
        .collection(profilesPath)
        .where('accountType', isEqualTo: 'barber') // Apenas barbeiros
        .orderBy('boostedUntil', descending: true) // Boosted primeiro (usa composite index)
        .orderBy('isPremium', descending: true) // Premium depois
        .orderBy('updatedAt', descending: true) // Recentes por último
        .limit(50) // Limita para performance
        .snapshots()
        .map((snapshot) {
          debugPrint('📊 [Discovery] Query retornou ${snapshot.docs.length} profiles');
          return snapshot.docs.map((doc) {
            final data = doc.data();
            final convertedData = _convertTimestampsToDateTime(data);
            return ProfileEntity.fromMap(convertedData);
          }).toList();
        });
  }

  // Helper privado: Converte todos os Timestamps em DateTime
  Map<String, dynamic> _convertTimestampsToDateTime(Map<String, dynamic> data) {
    final converted = <String, dynamic>{};

    data.forEach((key, value) {
      if (value is Timestamp) {
        converted[key] = value.toDate();
      } else if (value is Map<String, dynamic>) {
        // Recursivo para objetos aninhados
        converted[key] = _convertTimestampsToDateTime(value);
      } else if (value is List) {
        // Recursivo para arrays
        converted[key] = value.map((item) {
          if (item is Timestamp) return item.toDate();
          if (item is Map<String, dynamic>) return _convertTimestampsToDateTime(item);
          return item;
        }).toList();
      } else {
        converted[key] = value;
      }
    });

    return converted;
  }

  // Atualiza o token FCM. Se token for null, remove o campo do documento (logout).
  Future<void> updateFcmToken(String userId, String? token) async {
    // Usa FieldValue.delete() se o token for null
    final tokenValue = token ?? FieldValue.delete();

    await _service.db.collection(profilesPath).doc(userId).update({
      'fcmToken': tokenValue,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Sprint 24 - Operações Atômicas de Mídia

  // Atualiza a URL do Avatar
  Future<void> updateAvatarUrl(String userId, String? url) async {
    // Se url for null, remove o campo usando FieldValue.delete().
    final urlValue = url ?? FieldValue.delete();

    await _service.db.collection(profilesPath).doc(userId).update({
      'avatarUrl': urlValue,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Adiciona uma nova URL ao Portfólio (Array Union - Atômico)
  Future<void> addPortfolioUrl(String userId, String url) async {
    await _service.db.collection(profilesPath).doc(userId).update({
      // Usa FieldValue.arrayUnion para adicionar sem ler o documento inteiro
      'portfolioUrls': FieldValue.arrayUnion([url]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove uma URL do Portfólio (Array Remove - Atômico)
  Future<void> removePortfolioUrl(String userId, String url) async {
    await _service.db.collection(profilesPath).doc(userId).update({
      // Usa FieldValue.arrayRemove para remover sem ler o documento inteiro
      'portfolioUrls': FieldValue.arrayRemove([url]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // NOVO - Phase 11: Método genérico para atualizar campos do perfil
  /// Atualiza campos específicos do perfil de forma atômica
  /// Útil para Premium features (super likes, boosts, etc)
  Future<void> updateProfile({required String userId, required Map<String, dynamic> data}) async {
    // Adiciona timestamp automaticamente
    final updateData = {...data, 'updatedAt': FieldValue.serverTimestamp()};

    await _service.db.collection(profilesPath).doc(userId).update(updateData);
  }

  /// Alias para saveProfile (compatibilidade)
  Future<void> setProfile(ProfileEntity profile) => saveProfile(profile);

  /// Alias para getProfile (compatibilidade)
  Future<ProfileEntity?> getProfileByUserId(String userId) => getProfile(userId);
}
