import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart'; // 🔒 MUTEX

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/entities/profile_entity.dart'; // Para ProfileEntity
import '../../features/profile/controllers/profile_controller.dart'; // Para currentUserProfileProvider
import 'logger_service.dart';

part 'notification_service.g.dart';

// Função Top-Level para background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handling background message: ${message.messageId}
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  final service = NotificationService(
    messaging: FirebaseMessaging.instance,
    ref: ref,
    logger: ref.watch(loggerServiceProvider),
  );
  service.init();
  return service;
}

class NotificationService {
  final FirebaseMessaging _messaging;
  final Ref _ref;
  final LoggerService _logger;
  StreamSubscription? _tokenRefreshSubscription;

  // 🔥 SPRINT 29 - CIRCUIT BREAKER: Flag em memória para quebrar loop FCM
  String? _lastSuccessfullyUploadedToken;

  // 🔒 MUTEX (LOCK): Garante exclusão mútua - apenas 1 execução por vez
  final Lock _tokenSyncLock = Lock();

  NotificationService({required FirebaseMessaging messaging, required Ref ref, required LoggerService logger})
    : _messaging = messaging,
      _ref = ref,
      _logger = logger;

  Future<void> init() async {
    _logger.logEvent("NotificationService_Init");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();

    // Observar Auth State para registrar token ao fazer login
    // Usa ref.listen para observar mudanças no AsyncValue
    _ref.listen(authStateChangesProvider, (previous, next) {
      final user = next.value;
      final previousUser = previous?.value;

      // 🔒 APENAS registra token se o usuário mudou (login/logout)
      // Isso previne chamadas repetidas quando o estado é re-emitido
      if (user != null && user.uid != previousUser?.uid) {
        _registerToken(user.uid);
      }
    });

    // Observar mudanças no token
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(_handleTokenRefresh);
    _listenToMessages();
  }

  void dispose() {
    _tokenRefreshSubscription?.cancel();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);
    _logger.logEvent("FCM_PermissionStatus", parameters: {"status": settings.authorizationStatus.name});
  }

  Future<void> _registerToken(String userId) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        // 🔥 PRÉ-CHECK: Token já foi uploadado? (Otimização para evitar await desnecessário)
        if (token == _lastSuccessfullyUploadedToken) {
          _logger.logEvent("FCM_TokenAlreadyUpToDate_PreAwaitCheck");
          return;
        }

        // O Mutex em _updateTokenInBackend garantirá exclusão mútua
        await _updateTokenInBackend(userId, token);
      }
    } catch (e, stack) {
      _logger.logError(e, stack, context: "Failed to get FCM token");
    }
  }

  void _handleTokenRefresh(String newToken) {
    _logger.logEvent("FCM_TokenRefreshed");
    final userId = _ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId != null) {
      // O Mutex dentro de _updateTokenInBackend já garantirá a exclusão mútua
      unawaited(_updateTokenInBackend(userId, newToken));
    }
  }

  Future<void> _updateTokenInBackend(String userId, String token) async {
    // � MUTEX (LOCK): Aguarda até que a seção crítica esteja livre
    // Apenas UMA execução por vez pode entrar aqui
    await _tokenSyncLock.synchronized(() async {
      // --- INÍCIO DA SEÇÃO CRÍTICA (Atômica) ---
      _logger.logEvent("FCM_LockAcquired");

      try {
        // 1️⃣ VERIFICAÇÃO DE MEMÓRIA (Dentro do lock para garantir valor mais recente)
        // Isso impede que as chamadas que estavam esperando executem desnecessariamente
        if (token == _lastSuccessfullyUploadedToken) {
          _logger.logEvent("FCM_TokenAlreadyUpToDate_MemoryFlag_Safe");
          return;
        }

        // 2️⃣ VERIFICAÇÃO DE ESTADO DO PROVIDER (Consistência adicional)
        final currentProfileAsync = _ref.read(currentUserProfileProvider);
        ProfileEntity? currentProfile;
        currentProfileAsync.whenData((profile) {
          currentProfile = profile;
        });

        if (currentProfile != null && currentProfile!.fcmToken == token) {
          _logger.logEvent("FCM_TokenAlreadyUpToDate_ProviderState_Safe");
          _lastSuccessfullyUploadedToken = token; // Atualiza o flag de memória
          return;
        }

        // 3️⃣ ATUALIZAR O FIRESTORE (Operação Atômica Garantida)
        _logger.logEvent("FCM_UpdatingTokenInBackend_Atomic");

        await _ref.read(profileRepositoryProvider).updateFcmToken(userId, token);
        _logger.logEvent("FCM_TokenUpdateSuccess_Atomic");

        // 4️⃣ ATUALIZAR ESTADO E INVALIDAR CACHE
        _lastSuccessfullyUploadedToken = token;
        _ref.invalidate(currentUserProfileProvider);
      } catch (e, stack) {
        _logger.logError(e, stack, context: "Failed to update FCM token in backend (Atomic)");
        // Em caso de falha, NÃO atualizamos o flag, permitindo nova tentativa
      } finally {
        _logger.logEvent("FCM_LockReleased");
      }
      // --- FIM DA SEÇÃO CRÍTICA (O lock é liberado automaticamente) ---
    });
  }

  void _listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.logEvent("FCM_ForegroundMessageReceived", parameters: {"id": message.messageId ?? ""});
      // O Inbox atualizará automaticamente via Stream.
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.logEvent("FCM_NotificationTapped", parameters: {"id": message.messageId ?? ""});
      // TODO (Sprint 14): Implementar navegação.
    });
  }
}
