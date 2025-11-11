import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Serviço centralizado para Firebase Analytics
class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsService(this._analytics);

  /// Loga um evento customizado
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  /// Loga quando o usuário visualiza uma tela
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  /// Loga login do usuário
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  /// Loga quando o usuário faz um agendamento
  Future<void> logBookingCreated({
    required String serviceType,
    required double value,
  }) async {
    await _analytics.logEvent(
      name: 'booking_created',
      parameters: {
        'service_type': serviceType,
        'value': value,
        'currency': 'BRL',
      },
    );
  }

  /// Loga quando o usuário cancela um agendamento
  Future<void> logBookingCancelled(String reason) async {
    await _analytics.logEvent(
      name: 'booking_cancelled',
      parameters: {'reason': reason},
    );
  }

  /// Loga quando o usuário completa um agendamento
  Future<void> logBookingCompleted({
    required String serviceType,
    required double value,
  }) async {
    await _analytics.logEvent(
      name: 'booking_completed',
      parameters: {
        'service_type': serviceType,
        'value': value,
        'currency': 'BRL',
      },
    );
  }

  /// Loga busca do usuário
  Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  /// Define propriedades do usuário
  Future<void> setUserProperties({
    String? userType,
    String? preferredLanguage,
  }) async {
    if (userType != null) {
      await _analytics.setUserProperty(name: 'user_type', value: userType);
    }
    if (preferredLanguage != null) {
      await _analytics.setUserProperty(
        name: 'preferred_language',
        value: preferredLanguage,
      );
    }
  }
}

/// Serviço centralizado para Firebase Crashlytics
class FirebaseCrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  FirebaseCrashlyticsService(this._crashlytics);

  /// Registra um erro não fatal
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: false,
    );
  }

  /// Registra um erro fatal
  Future<void> recordFatalError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: true,
    );
  }

  /// Adiciona log customizado
  void log(String message) {
    _crashlytics.log(message);
  }

  /// Define ID do usuário
  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// Define atributo customizado
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }
}

/// Serviço centralizado para Firebase Remote Config
class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfigService(this._remoteConfig);

  /// Inicializa o Remote Config com valores padrão
  Future<void> initialize(Map<String, dynamic> defaults) async {
    await _remoteConfig.setDefaults(defaults);
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
  }

  /// Busca e ativa as configurações remotas
  Future<bool> fetchAndActivate() async {
    return await _remoteConfig.fetchAndActivate();
  }

  /// Obtém valor string
  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  /// Obtém valor booleano
  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  /// Obtém valor inteiro
  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  /// Obtém valor double
  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }
}

/// Provider para FirebaseAnalyticsService
final firebaseAnalyticsServiceProvider = Provider<FirebaseAnalyticsService>((ref) {
  return FirebaseAnalyticsService(FirebaseAnalytics.instance);
});

/// Provider para FirebaseCrashlyticsService
final firebaseCrashlyticsServiceProvider =
    Provider<FirebaseCrashlyticsService>((ref) {
  return FirebaseCrashlyticsService(FirebaseCrashlytics.instance);
});

/// Provider para FirebaseRemoteConfigService
final firebaseRemoteConfigServiceProvider =
    Provider<FirebaseRemoteConfigService>((ref) {
  return FirebaseRemoteConfigService(FirebaseRemoteConfig.instance);
});
