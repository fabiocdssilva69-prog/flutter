import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/core/config/config.dart'; // NOVO: Gerenciamento de variáveis de ambiente
import 'src/core/services/logger_service.dart'; // NOVO: Logging centralizado
import 'src/data/init.dart'; // HOTFIX: MapperContainer initialization
import 'src/debug/print_fcm_token.dart'; // DEBUG: Helper para imprimir FCM token

// Provider global para Firebase Analytics
final firebaseAnalyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});

// Provider global para Firebase Crashlytics
final firebaseCrashlyticsProvider = Provider<FirebaseCrashlytics>((ref) {
  return FirebaseCrashlytics.instance;
});

// Provider global para Firebase Remote Config
final firebaseRemoteConfigProvider = Provider<FirebaseRemoteConfig>((ref) {
  return FirebaseRemoteConfig.instance;
});

void main() async {
  // 1. Inicialização do Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. HOTFIX CRÍTICO: Inicializar MapperContainer ANTES de tudo
  // Isso registra o TimestampHook globalmente para conversão Firestore Timestamp <-> DateTime
  initMappers();

  // 2.1. Configurar timeago para português brasileiro
  timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

  // 3. Carrega Variáveis de Ambiente (.env)
  await Config.load();

  // 4. Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 5. Inicializa o Container do Riverpod
  // Usamos ProviderContainer para acessar o logger antes de rodar o app
  final container = ProviderContainer();
  final logger = container.read(loggerServiceProvider);

  logger.logEvent('app_initialization_started');

  // 6. Configura Firestore
  // ✅ HABILITA OFFLINE PERSISTENCE para resiliência de rede
  // Permite que o app funcione sem internet, cacheando dados localmente
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // ← Habilita cache local offline
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Cache ilimitado
  );

  // 7. Configura Firebase Analytics
  final analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);
  // ✅ CORRIGIDO: Removido prefixo reservado "firebase_"
  logger.logEvent('analytics_service_configured');

  // 8. Configura Crashlytics e Handlers de Erro Globais

  // Captura erros síncronos do Flutter (Ex: erros de layout/renderização)
  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    // Loga localmente e envia para o Crashlytics
    logger.logError(
      errorDetails.exception,
      errorDetails.stack ?? StackTrace.current,
      context: "FlutterError.onError (Fatal)",
    );
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Captura erros assíncronos que não são tratados pelo framework (Ex: Futures que falham)
  PlatformDispatcher.instance.onError = (error, stack) {
    // Loga localmente e envia para o Crashlytics
    logger.logError(error, stack, context: "PlatformDispatcher.onError (Fatal)");
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true; // Indica que o erro foi tratado
  };

  // ✅ CORRIGIDO: Removido prefixo reservado "firebase_"
  logger.logEvent('crashlytics_service_configured');

  // 9. Configura Firebase Remote Config com valores padrão
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(fetchTimeout: const Duration(minutes: 1), minimumFetchInterval: const Duration(hours: 1)),
  );

  // Define valores padrão para Remote Config
  await remoteConfig.setDefaults({
    'enable_new_feature': false,
    'welcome_message': 'Bem-vindo ao BarberGo!',
    'max_booking_days': 30,
    'enable_ai_chat': true,
    'enable_ai_artistic_mode': false,
    'maintenance_mode': false,
  });

  // Busca configurações remotas (não bloqueia o app)
  remoteConfig
      .fetchAndActivate()
      .then((_) {
        logger.logEvent('remote_config_fetched');
      })
      .catchError((error) {
        logger.logError(error, StackTrace.current, context: 'Remote Config Fetch');
      });

  // 10. Log inicial de abertura do app
  await analytics.logAppOpen();
  logger.logEvent('app_opened');

  // 11. DEBUG: Imprime FCM Token no console (facilita testes de notificação)
  if (kDebugMode) {
    printFcmToken();
  }

  // 12. Roda o aplicativo usando UncontrolledProviderScope com o container inicializado
  runApp(UncontrolledProviderScope(container: container, child: const BarberGoApp()));
}
