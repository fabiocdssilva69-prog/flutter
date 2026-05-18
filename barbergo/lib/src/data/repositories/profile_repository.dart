import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  // IMPORTANTE: Collection correta no Firebase = 'perfis' (português)
  // Banco: bancobarber (Enterprise MongoDB-compatible)
  static const String profilesPath = 'perfis';

  // Salva ou atualiza o perfil (merge: true — nunca sobrescreve campos não incluídos)
  Future<void> saveProfile(ProfileEntity profile) async {
    final profileToSave = profile.copyWith(updatedAt: DateTime.now());
    await _service.db.collection(profilesPath).doc(profile.userId).set(
      profileToSave.toMap(),
      SetOptions(merge: true),
    );
  }

  // Observa as mudanças no perfil de um usuário específico (Real-time)
  Stream<ProfileEntity?> watchProfile(String userId) {
    final docRef = _service.db.collection(profilesPath).doc(userId);
    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        // O TimestampHook no ProfileEntity converte automaticamente
        final profile = ProfileEntity.fromMap(data);
        return profile;
      }
      return null;
    });
  }

  // Busca o perfil de um usuário específico (One-time read)
  Future<ProfileEntity?> getProfile(String userId) async {
    try {
      final docSnapshot = await _service.db.collection(profilesPath).doc(userId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        // CORREÇÃO 3: Converter GeoPoint na leitura
        if (data['preciseLocation'] != null && data['preciseLocation'] is Map) {
          final preciseLocation = data['preciseLocation'] as Map<String, dynamic>;
          if (preciseLocation['geopoint'] != null && preciseLocation['geopoint'] is! Map) {
            final geopoint = preciseLocation['geopoint'] as GeoPoint;
            data['preciseLocation'] = {
              'geopoint': {'latitude': geopoint.latitude, 'longitude': geopoint.longitude},
              'geohash': preciseLocation['geohash'],
            };
          }
        }
        // O TimestampHook no ProfileEntity converte automaticamente
        return ProfileEntity.fromMap(data);
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ [ProfileRepository] Erro ao buscar perfil $userId: $e');
      debugPrint('Stack: $stackTrace');
      return null;
    }
  }

  // NOVO: Barbeiros veem apenas BARBEARIAS (limitado a 20 para performance)
  Stream<List<ProfileEntity>> watchBarbershopsForBarbers(String currentUserId) {
    print('🔍 [ProfileRepository.watchBarbershopsForBarbers] INICIANDO');
    print('   Collection: $profilesPath');
    print('   Query: accountType == "barbershop"');
    print('   CurrentUser: $currentUserId');

    return _service.db
        .collection(profilesPath)
        .where('accountType', isEqualTo: 'barbershop')
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .snapshots()
        .handleError((error, stackTrace) {
          print('❌ [watchBarbershopsForBarbers] ERRO NO STREAM: $error');
          print('   Stack: $stackTrace');
        })
        .map((snapshot) {
          print('📊 [watchBarbershopsForBarbers] Query retornou ${snapshot.docs.length} barbearias');
          if (snapshot.docs.isEmpty) {
            print('⚠️  [watchBarbershopsForBarbers] NENHUMA BARBEARIA ENCONTRADA!');
          } else {
            for (var doc in snapshot.docs.take(3)) {
              print('   - ${doc.id}: ${doc.data()['name']}');
            }
          }
          final profiles = _convertSnapshotToProfiles(snapshot, currentUserId);
          print('✅ [watchBarbershopsForBarbers] Retornando ${profiles.length} perfis');
          return profiles;
        });
  }

  // NOVO: Barbearias veem apenas BARBEIROS (limitado a 20 para performance)
  Stream<List<ProfileEntity>> watchBarbersForBarbershops(String currentUserId) {
    print('🔍 [Discovery] Barbearia buscando barbeiros em: $profilesPath');
    return _service.db
        .collection(profilesPath)
        .where('accountType', isEqualTo: 'barber')
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .snapshots()
        .handleError((error, stackTrace) {
          print('❌ [Discovery] Erro no stream: $error');
        })
        .map((snapshot) {
          print('📊 [Discovery] Query retornou ${snapshot.docs.length} barbeiros');
          return _convertSnapshotToProfiles(snapshot, currentUserId);
        });
  }

  // NOVO: Clientes veem TODOS (barbeiros E barbearias) - limitado a 20 para performance
  Stream<List<ProfileEntity>> watchAllForClients(String currentUserId) {
    print('🔍 [Discovery] Cliente buscando todos em: $profilesPath');
    return _service.db
        .collection(profilesPath)
        .where('accountType', whereIn: ['barber', 'barbershop'])
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .snapshots()
        .handleError((error, stackTrace) {
          print('❌ [Discovery] Erro no stream: $error');
        })
        .map((snapshot) {
          print('📊 [Discovery] Query retornou ${snapshot.docs.length} perfis');
          return _convertSnapshotToProfiles(snapshot, currentUserId);
        });
  }

  // ANTIGO: Mantido para compatibilidade (não usar no SwipeScreen)
  Stream<List<ProfileEntity>> watchAllProfiles() {
    print('🔍 [Discovery] Iniciando query em collection: $profilesPath');
    debugPrint('🔍 [Discovery] Iniciando query em collection: $profilesPath');
    return _service.db
        .collection(profilesPath) // Collection 'perfis'
        // TEMPORÁRIO: Query simples sem whereIn para diagnóstico
        .snapshots()
        .handleError((error, stackTrace) {
          print('❌ [Discovery] Erro no stream: $error');
          print('📋 Stack: $stackTrace');
          debugPrint('❌ [Discovery] Erro no stream: $error');
          debugPrint('📋 Stack: $stackTrace');
        })
        .map((snapshot) {
          print('📊 [Discovery] Query retornou ${snapshot.docs.length} perfis');
          debugPrint('📊 [Discovery] Query retornou ${snapshot.docs.length} perfis');

          if (snapshot.docs.isEmpty) {
            debugPrint('⚠️ [Discovery] Nenhum perfil encontrado em $profilesPath');
            return <ProfileEntity>[];
          }

          return _convertSnapshotToProfiles(snapshot, null);
        });
  }

  // Método auxiliar para converter snapshot em lista de perfis
  List<ProfileEntity> _convertSnapshotToProfiles(QuerySnapshot<Map<String, dynamic>> snapshot, String? excludeUserId) {
    print('🔍 [_convertSnapshotToProfiles] INICIANDO');
    print('   excludeUserId: $excludeUserId');
    print('   Total de docs recebidos: ${snapshot.docs.length}');

    if (snapshot.docs.isEmpty) {
      debugPrint('⚠️ [Discovery] Nenhum perfil encontrado');
      return <ProfileEntity>[];
    }

    final profiles = snapshot.docs
        .map((doc) {
          try {
            final data = doc.data();
            final docUserId = data['userId'];
            final docId = doc.id;

            debugPrint(
              '👤 [Discovery] Processando perfil:\n'
              '   doc.id: $docId\n'
              '   data[userId]: $docUserId\n'
              '   accountType: ${data['accountType']}\n'
              '   name: ${data['name']}\n'
              '   excludeUserId: $excludeUserId',
            );

            // Excluir o próprio usuário - COMPARAÇÃO CRÍTICA
            if (excludeUserId != null) {
              // Testar ambas as comparações para debug
              final matchesUserId = docUserId == excludeUserId;
              final matchesDocId = docId == excludeUserId;

              print('🔍 [Discovery] Comparação de exclusão:');
              print('   data[userId] == excludeUserId: $matchesUserId ($docUserId == $excludeUserId)');
              print('   doc.id == excludeUserId: $matchesDocId ($docId == $excludeUserId)');

              if (matchesUserId) {
                print('⏭️ [Discovery] ✅ PULANDO próprio perfil (match por userId)');
                return null;
              }

              if (matchesDocId) {
                print('⏭️ [Discovery] ✅ PULANDO próprio perfil (match por doc.id)');
                return null;
              }
            }

            // CORREÇÃO 3: Garantir que GeoPoint seja convertido corretamente
            if (data['preciseLocation'] != null && data['preciseLocation'] is Map) {
              final preciseLocation = data['preciseLocation'] as Map<String, dynamic>;
              if (preciseLocation['geopoint'] != null && preciseLocation['geopoint'] is! Map) {
                // Converte GeoPoint do Firestore para Map
                final geopoint = preciseLocation['geopoint'] as GeoPoint;
                data['preciseLocation'] = {
                  'geopoint': {'latitude': geopoint.latitude, 'longitude': geopoint.longitude},
                  'geohash': preciseLocation['geohash'],
                };
              }
            }

            // CORREÇÃO CRÍTICA: Não converte Timestamps manualmente!
            // O TimestampHook() no ProfileEntity já faz a conversão automaticamente.
            // Passar o data original permite que o hook funcione corretamente.

            // CORREÇÃO 6: Validar campos obrigatórios
            if (data['userId'] == null || data['name'] == null) {
              debugPrint('⚠️ [Discovery] Perfil ${doc.id} com dados inválidos');
              return null;
            }
            return ProfileEntity.fromMap(data);
          } catch (e, stackTrace) {
            debugPrint('❌ [Discovery] Erro ao converter perfil ${doc.id}: $e');
            debugPrint('Stack: $stackTrace');
            return null;
          }
        })
        .whereType<ProfileEntity>()
        .toList();

    // Ordenar localmente para evitar índice composto
    profiles.sort((a, b) {
      // 1. Boosted primeiro
      if (a.boostedUntil != null && b.boostedUntil == null) return -1;
      if (b.boostedUntil != null && a.boostedUntil == null) return 1;

      // 2. Premium depois
      if (a.isPremium && !b.isPremium) return -1;
      if (b.isPremium && !a.isPremium) return 1;

      // 3. Mais recentes (com null check)
      final aDate = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return profiles.take(50).toList(); // Limita a 50
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

  // Upload de avatar — retorna a nova URL para atualização imediata da UI
  Future<String> uploadAvatar(String userId, File imageFile) async {
    try {
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child('avatars').child(userId).child(fileName);
      final snapshot = await storageRef.putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));
      final downloadUrl = await snapshot.ref.getDownloadURL();
      await updateAvatarUrl(userId, downloadUrl);
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      rethrow;
    }
  }

  // Remove o avatar do Firebase Storage e do perfil
  Future<void> removeAvatar(String userId) async {
    try {
      // Busca o perfil atual para obter a URL do avatar
      final profile = await getProfile(userId);
      if (profile?.avatarUrl != null && profile!.avatarUrl!.isNotEmpty) {
        try {
          // Tenta remover o arquivo do Storage
          final ref = FirebaseStorage.instance.refFromURL(profile.avatarUrl!);
          await ref.delete();
        } catch (e) {
          // Se falhar ao deletar do Storage, continua e remove a referência do perfil
          debugPrint('Error deleting avatar from storage: $e');
        }
      }

      // Remove a URL do perfil
      await updateAvatarUrl(userId, null);
    } catch (e) {
      debugPrint('Error removing avatar: $e');
      rethrow;
    }
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

  /// Busca todos os perfis (usado em Store Locator)
  Future<List<ProfileEntity>> getAllProfiles() async {
    final querySnapshot = await _service.db.collection(profilesPath).get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      // O TimestampHook no ProfileEntity converte automaticamente
      return ProfileEntity.fromMap(data);
    }).toList();
  }

  /// NOVO: Busca perfis com paginação
  /// [lastDocument] - Último documento da página anterior (para cursor-based pagination)
  /// [limit] - Número de perfis por página (padrão: 20)
  /// [accountType] - Filtro opcional por tipo de conta
  /// [excludeUserId] - Excluir usuário específico (normalmente o próprio usuário)
  Future<({List<ProfileEntity> profiles, DocumentSnapshot? lastDoc})> getProfilesPaginated({
    DocumentSnapshot? lastDocument,
    int limit = 20,
    String? accountType,
    String? excludeUserId,
  }) async {
    print('📄 [ProfileRepository.getProfilesPaginated]');
    print('   limit: $limit');
    print('   accountType: $accountType');
    print('   excludeUserId: $excludeUserId');
    print('   lastDocument: ${lastDocument?.id}');

    try {
      Query<Map<String, dynamic>> query = _service.db.collection(profilesPath);

      // Aplicar filtro de accountType se fornecido
      if (accountType != null) {
        query = query.where('accountType', isEqualTo: accountType);
      }

      // Ordenar por updatedAt decrescente (mais recentes primeiro)
      query = query.orderBy('updatedAt', descending: true);

      // Aplicar cursor se fornecido (paginação)
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Aplicar limite
      query = query.limit(limit);

      final querySnapshot = await query.get();
      print('📊 [getProfilesPaginated] Query retornou ${querySnapshot.docs.length} perfis');

      if (querySnapshot.docs.isEmpty) {
        return (profiles: <ProfileEntity>[], lastDoc: null);
      }

      // Converter documentos para ProfileEntity
      final profiles = querySnapshot.docs
          .map((doc) {
            try {
              final data = doc.data();

              // Excluir usuário específico se fornecido
              if (excludeUserId != null && data['userId'] == excludeUserId) {
                return null;
              }

              // Excluir perfis que ocultaram da busca (showProfile = false)
              // Ausência do campo = true (padrão)
              if (data['showProfile'] == false) return null;

              // Validar campos obrigatórios
              if (data['userId'] == null || data['name'] == null) {
                print('⚠️ [getProfilesPaginated] Perfil ${doc.id} com dados inválidos');
                return null;
              }

              return ProfileEntity.fromMap(data);
            } catch (e, stackTrace) {
              print('❌ [getProfilesPaginated] Erro ao converter perfil ${doc.id}: $e');
              print('   Stack: $stackTrace');
              return null;
            }
          })
          .whereType<ProfileEntity>()
          .toList();

      // Retornar perfis e último documento (para próxima página)
      final lastDoc = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
      print('✅ [getProfilesPaginated] Retornando ${profiles.length} perfis');

      return (profiles: profiles, lastDoc: lastDoc);
    } catch (e, stackTrace) {
      print('❌ [getProfilesPaginated] ERRO: $e');
      print('   Stack: $stackTrace');
      return (profiles: <ProfileEntity>[], lastDoc: null);
    }
  }

  /// Busca perfil por ID (alias para getProfile)
  Future<ProfileEntity?> getProfileById(String userId) => getProfile(userId);
}
