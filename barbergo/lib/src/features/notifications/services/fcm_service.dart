import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../data/repositories/notification_repository.dart';

/// Handler para notificações em background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  // Processar notificação em background
}

/// Serviço de Firebase Cloud Messaging
class FcmService {
  final FirebaseMessaging _messaging;
  final NotificationRepository _repository;
  final FirebaseFirestore _firestore;

  String? _fcmToken;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  FcmService({
    FirebaseMessaging? messaging,
    required NotificationRepository repository,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _repository = repository,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Inicializar FCM
  Future<void> initialize(String userId) async {
    // Solicitar permissão
    final settings = await _requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('FCM permission not granted');
      return;
    }

    // Obter token FCM
    _fcmToken = await _messaging.getToken();
    if (_fcmToken != null) {
      await _saveFcmToken(userId, _fcmToken!);
      debugPrint('FCM Token: $_fcmToken');
    }

    // Listener para token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _saveFcmToken(userId, newToken);
    });

    // Configurar handlers
    _setupMessageHandlers(userId);
  }

  /// Solicitar permissão para notificações
  Future<NotificationSettings> _requestPermission() async {
    return await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// Salvar token FCM no Firestore
  Future<void> _saveFcmToken(String userId, String token) async {
    await _firestore.collection('fcmTokens').doc(userId).set({
      'token': token,
      'userId': userId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Configurar handlers de mensagens
  void _setupMessageHandlers(String userId) {
    // Mensagem quando app está em foreground
    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      _handleForegroundMessage(userId, message);
    });

    // Mensagem quando app é aberto por notificação
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageOpenedApp(message);
    });

    // Verificar se app foi aberto por notificação
    _checkInitialMessage();
  }

  /// Processar mensagem em foreground
  void _handleForegroundMessage(String userId, RemoteMessage message) {
    debugPrint('Foreground message: ${message.notification?.title}');

    // Criar notificação local
    if (message.notification != null) {
      final notification = NotificationEntity(
        id: '',
        type: _getNotificationType(message.data['type']),
        title: message.notification!.title ?? 'Nova notificação',
        message: message.notification!.body ?? '',
        contextData: message.data.isNotEmpty ? message.data : null,
        isRead: false,
        createdAt: DateTime.now(),
      );

      _repository.createNotification(userId, notification);
    }
  }

  /// Processar quando app é aberto por notificação
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('App opened from notification: ${message.messageId}');
    
    // Navegar para tela específica baseado no tipo
    final route = _getDeepLinkRoute(message.data);
    if (route != null) {
      // TODO: Implementar navegação usando GoRouter ou Navigator
      debugPrint('Navigate to: $route');
    }
  }

  /// Verificar mensagem inicial (app aberto por notificação)
  Future<void> _checkInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      _handleMessageOpenedApp(message);
    }
  }

  /// Converter string para NotificationType
  NotificationType _getNotificationType(dynamic type) {
    if (type == null) return NotificationType.systemAlert;
    
    try {
      return NotificationType.values.firstWhere(
        (e) => e.name == type.toString(),
        orElse: () => NotificationType.systemAlert,
      );
    } catch (e) {
      return NotificationType.systemAlert;
    }
  }

  /// Obter rota de deep link
  String? _getDeepLinkRoute(Map<String, dynamic> data) {
    if (data.isEmpty) return null;

    final type = _getNotificationType(data['type']);
    
    switch (type) {
      case NotificationType.match:
        return data['matchId'] != null ? '/matches/${data['matchId']}' : null;
      case NotificationType.message:
        return data['chatId'] != null ? '/chat/${data['chatId']}' : null;
      case NotificationType.like:
        return data['profileId'] != null ? '/profile/${data['profileId']}' : null;
      case NotificationType.booking:
        return data['bookingId'] != null ? '/bookings/${data['bookingId']}' : null;
      case NotificationType.aiSuggestion:
        return data['suggestionId'] != null ? '/ai/suggestions/${data['suggestionId']}' : null;
      case NotificationType.applicationReceived:
      case NotificationType.applicationStatusUpdate:
      case NotificationType.systemAlert:
        return null;
    }
  }

  /// Obter token FCM atual
  String? get fcmToken => _fcmToken;

  /// Limpar recursos
  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
  }

  /// Deletar token FCM (logout)
  Future<void> deleteToken(String userId) async {
    await _messaging.deleteToken();
    await _firestore.collection('fcmTokens').doc(userId).delete();
  }
}
