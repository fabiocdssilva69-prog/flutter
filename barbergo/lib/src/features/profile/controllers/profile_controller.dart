import 'dart:async'; // Necessário para TimeoutException

import 'package:cloud_firestore/cloud_firestore.dart'; // Para GeoPoint
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/profile_entity.dart';

part 'profile_controller.g.dart';

// Define um tempo limite razoável para o carregamento do perfil
const Duration kProfileLoadTimeout = Duration(seconds: 20);

// Provedor CRUCIAL: Observa o perfil do usuário logado em tempo real.
// Usado para verificar se o Onboarding foi concluído e para exibir dados na UI.
@Riverpod(keepAlive: true)
Stream<ProfileEntity?> currentUserProfile(Ref ref) {
  // Depende do estado de autenticação
  final authState = ref.watch(authStateChangesProvider);

  // Se ainda estiver carregando o estado de auth, esperamos (retorna stream vazio).
  // Isso impede que a lógica do perfil seja executada antes de sabermos se o usuário está logado.
  if (authState.isLoading) {
    return const Stream.empty();
  }

  final authUser = authState.value;

  if (authUser == null) {
    // Se não estiver logado, resolve imediatamente como nulo.
    return Stream.value(null);
  }

  // Se autenticado, observa o perfil no repositório.
  final profileStream = ref.watch(profileRepositoryProvider).watchProfile(authUser.uid);

  // ✅ FIX CRÍTICO: O problema era que o timeout se aplicava ao Stream CONTÍNUO!
  // Solução: Usar firstWithTimeout para garantir a primeira emissão rápida,
  // mas manter o Stream ativo sem timeout depois disso.

  late StreamController<ProfileEntity?> controller;
  bool hasEmittedFirst = false;

  controller = StreamController<ProfileEntity?>(
    onListen: () {
      // Subscreve ao profileStream
      final subscription = profileStream.listen(
        (profile) {
          debugPrint('📥 ProfileStream emitiu: ${profile != null ? "ProfileEntity(name: ${profile.name})" : "NULL"}');
          if (!hasEmittedFirst) {
            hasEmittedFirst = true;
            debugPrint('✅ Primeira emissão recebida (hasEmittedFirst = true)');
          }
          if (!controller.isClosed) {
            controller.add(profile);
          }
        },
        onError: (error, stackTrace) {
          debugPrint('❌ Erro no profileStream: $error');
          if (!controller.isClosed) {
            controller.add(null);
          }
        },
      );

      // Timeout APENAS para a primeira emissão
      if (!hasEmittedFirst) {
        Future.delayed(kProfileLoadTimeout, () {
          if (!hasEmittedFirst && !controller.isClosed) {
            debugPrint('⚠️ TIMEOUT: Primeira carga do perfil demorou mais de ${kProfileLoadTimeout.inSeconds}s');
            debugPrint('   Emitindo null para permitir navegação para onboarding');
            hasEmittedFirst = true;
            controller.add(null);
          }
        });
      }

      controller.onCancel = () {
        subscription.cancel();
      };
    },
  );

  return controller.stream;
}

// Controlador para Ações (Salvar/Editar Perfil)
@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() {} // Estado inicial vazio

  // Método para salvar o perfil (usado no Onboarding e na Edição)
  Future<bool> saveProfile({
    required String name,
    required String bio,
    required String location, // Descrição textual
    required String contactPhone,
    required AccountType accountType,
    // NOVO: Parâmetros opcionais para atualização granular
    Position? newPosition,
    int? newSearchRadiusKm,
  }) async {
    final authUser = ref.read(authRepositoryProvider).currentUser;
    if (authUser == null) {
      state = AsyncError("Usuário não autenticado.", StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    // Tenta obter o perfil existente
    final existingProfile = await ref.read(profileRepositoryProvider).getProfile(authUser.uid);

    // Processa a nova posição se fornecida
    Map<String, dynamic>? preciseLocation;
    if (newPosition != null) {
      // Converte Position (do Geolocator) para GeoFirePoint e depois para Map
      final geoPoint = GeoFirePoint(GeoPoint(newPosition.latitude, newPosition.longitude));
      preciseLocation = geoPoint.data;
    } else {
      // Mantém a localização existente se não for fornecida uma nova
      preciseLocation = existingProfile?.preciseLocation;
    }

    // Constrói a entidade (usando o construtor dart_mappable)
    // Nota: dart_mappable não requer copyWith para criar a entidade inicial, apenas para atualizar.
    final profile = ProfileEntity(
      userId: authUser.uid,
      email: authUser.email ?? 'Email não disponível',
      accountType: accountType,
      name: name.trim(),
      bio: bio.trim(),
      location: location.trim(),
      contactPhone: contactPhone.trim(),
      // Usa a nova localização ou a existente
      preciseLocation: preciseLocation,
      // Usa o novo raio, ou o existente, ou o padrão
      searchRadiusKm: newSearchRadiusKm ?? existingProfile?.searchRadiusKm ?? 25,
      createdAt: existingProfile?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      // Mantém a mídia existente se não estivermos atualizando aqui
      avatarUrl: existingProfile?.avatarUrl,
      portfolioUrls: existingProfile?.portfolioUrls ?? const [],
    );

    // Chama o repositório
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).saveProfile(profile);
    });

    return !state.hasError;
  }
}
