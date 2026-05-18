import 'dart:async'; // Necessário para TimeoutException

import 'package:cloud_firestore/cloud_firestore.dart'; // Para GeoPoint
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Para FutureProvider
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        (profile) async {
          debugPrint('📥 ProfileStream emitiu: ${profile != null ? "ProfileEntity(name: ${profile.name})" : "NULL"}');

          // Se o perfil não existir, aguarda 2s para o signup_screen salvar primeiro
          if (profile == null) {
            final creationTime = authUser.metadata.creationTime;
            final isNew = creationTime != null &&
                DateTime.now().difference(creationTime).inSeconds < 15;

            // Lê dados pendentes do signup_screen (salvos antes do await signUp)
            final prefs = await SharedPreferences.getInstance();
            final pendingType = prefs.getString('pending_account_type');
            final pendingName = prefs.getString('pending_name') ?? '';
            final pendingPhone = prefs.getString('pending_phone') ?? '';

            AccountType accountType = AccountType.customer;
            if (pendingType == 'barber') accountType = AccountType.barber;
            if (pendingType == 'barbershop') accountType = AccountType.barbershop;

            final bio = accountType == AccountType.barber
                ? 'Barbeiro profissional'
                : accountType == AccountType.barbershop
                    ? 'Barbearia no BarberGO'
                    : 'Cliente do BarberGO';

            debugPrint('🆕 Auto-criando perfil: type=$pendingType, name=$pendingName, isNew=$isNew');

            try {
              final newProfile = ProfileEntity(
                userId: authUser.uid,
                email: authUser.email ?? '',
                accountType: accountType,
                name: pendingName.isNotEmpty ? pendingName : (authUser.displayName ?? 'Usuário'),
                bio: bio,
                location: 'Brasil',
                contactPhone: pendingPhone,
                facebookUrl: pendingPhone, // WhatsApp no edit_profile usa facebookUrl
                nationality: 'BR',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              await ref.read(profileRepositoryProvider).saveProfile(newProfile);
              // Limpa dados pendentes após usar
              await prefs.remove('pending_account_type');
              await prefs.remove('pending_name');
              await prefs.remove('pending_phone');
              if (!controller.isClosed) controller.add(newProfile);
            } catch (e) {
              debugPrint('❌ Erro ao criar perfil: $e');
              if (!controller.isClosed) controller.add(null);
            }
          } else {
            // Perfil existe, emite normalmente
            if (!hasEmittedFirst) {
              hasEmittedFirst = true;
              debugPrint('✅ Primeira emissão recebida (hasEmittedFirst = true)');
            }
            if (!controller.isClosed) {
              controller.add(profile);
            }
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
      // Converte Position para Map com geopoint e geohash
      final geoPoint = GeoFirePoint(GeoPoint(newPosition.latitude, newPosition.longitude));
      // Armazena como Map com latitude/longitude e geohash (serializável)
      preciseLocation = {
        'geopoint': {'latitude': newPosition.latitude, 'longitude': newPosition.longitude},
        'geohash': geoPoint.geohash,
      };
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
      preciseLocation: preciseLocation,
      searchRadiusKm: newSearchRadiusKm ?? existingProfile?.searchRadiusKm ?? 25,
      createdAt: existingProfile?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      avatarUrl: existingProfile?.avatarUrl,
      portfolioUrls: existingProfile?.portfolioUrls ?? const [],
      // Preserva consumíveis e premium — nunca resetar ao editar perfil
      superLikesRemaining: existingProfile?.superLikesRemaining ?? 1,
      magicLikesRemaining: existingProfile?.magicLikesRemaining ?? 1,
      boostsRemaining: existingProfile?.boostsRemaining ?? 1,
      replaysRemaining: existingProfile?.replaysRemaining ?? 1,
      isPremium: existingProfile?.isPremium ?? false,
      verificationBadge: existingProfile?.verificationBadge ?? VerificationBadge.none,
      badgeExpiresAt: existingProfile?.badgeExpiresAt,
      canSeeWhoLiked: existingProfile?.canSeeWhoLiked ?? false,
    );

    // Chama o repositório
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).saveProfile(profile);
    });

    return !state.hasError;
  }

  // Método para alternar o tipo de conta (barber ↔ barbershop)
  Future<bool> switchAccountType() async {
    final authUser = ref.read(authRepositoryProvider).currentUser;
    if (authUser == null) {
      state = AsyncError("Usuário não autenticado.", StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    try {
      // Obtém o perfil atual
      final existingProfile = await ref.read(profileRepositoryProvider).getProfile(authUser.uid);
      if (existingProfile == null) {
        state = AsyncError("Perfil não encontrado.", StackTrace.current);
        return false;
      }

      // Alterna o tipo de conta
      final newAccountType = existingProfile.accountType == AccountType.barber
          ? AccountType.barbershop
          : AccountType.barber;

      // Cria o perfil atualizado
      final updatedProfile = existingProfile.copyWith(accountType: newAccountType, updatedAt: DateTime.now());

      // Salva o perfil atualizado
      await ref.read(profileRepositoryProvider).saveProfile(updatedProfile);

      state = const AsyncData(true);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}

// Provider para buscar perfil de outro usuário por ID (usado no chat para mostrar nomes)
final profileByIdProvider = FutureProvider.family<ProfileEntity?, String>((ref, userId) async {
  try {
    return await ref.watch(profileRepositoryProvider).getProfile(userId);
  } catch (e) {
    debugPrint('❌ [profileByIdProvider] Erro ao buscar perfil $userId: $e');
    return null; // Retorna null em caso de erro para não travar a UI
  }
});
