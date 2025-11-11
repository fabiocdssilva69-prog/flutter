# 🔥 PLANO DE IMPLEMENTAÇÃO FIREBASE - Sprint 2

**Data Início**: 16/10/2025  
**Status**: 🚀 INICIANDO AGORA  
**Foco**: Firebase Analytics, Crashlytics e Remote Config

---

## 🎯 OBJETIVO DO SPRINT

Implementar os recursos core do Firebase que trarão:
- 📊 **Analytics**: Entender comportamento dos usuários
- 🐛 **Crashlytics**: Detectar e corrigir bugs automaticamente
- ⚙️ **Remote Config**: Controlar features sem deploy

**Tempo estimado**: 2-3 dias (6-8 horas de trabalho)

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### Fase 1: Preparação (30 min)

- [ ] Verificar Firebase CLI instalado
- [ ] Verificar projeto Firebase configurado
- [ ] Verificar pacotes instalados no pubspec.yaml
- [ ] Criar branch para implementação

### Fase 2: Firebase Analytics (1-2 horas)

- [ ] Adicionar firebase_analytics ao pubspec.yaml
- [ ] Configurar Analytics no main.dart
- [ ] Implementar eventos personalizados
- [ ] Testar logging de eventos
- [ ] Verificar no Firebase Console

### Fase 3: Firebase Crashlytics (1-2 horas)

- [ ] Adicionar firebase_crashlytics ao pubspec.yaml
- [ ] Configurar Crashlytics no main.dart
- [ ] Implementar tratamento de erros
- [ ] Testar crash reporting
- [ ] Verificar crashes no console

### Fase 4: Remote Config (2-3 horas)

- [ ] Adicionar firebase_remote_config ao pubspec.yaml
- [ ] Configurar Remote Config no app
- [ ] Criar parâmetros no Firebase Console
- [ ] Implementar feature flags
- [ ] Testar mudanças dinâmicas

### Fase 5: Testes e Validação (1 hora)

- [ ] Testar todos os recursos juntos
- [ ] Validar no Firebase Console
- [ ] Documentar implementação
- [ ] Commit e push

---

## 🛠️ IMPLEMENTAÇÃO DETALHADA

### PASSO 1: Verificar Ambiente

```powershell
# 1. Verificar Firebase CLI
firebase --version
# Se não estiver instalado: npm install -g firebase-tools

# 2. Verificar login
firebase login

# 3. Listar projetos
firebase projects:list
# Deve mostrar: barbergo-4a9fc

# 4. Verificar FlutterFire CLI
flutterfire --version
# Se não estiver: dart pub global activate flutterfire_cli
```

### PASSO 2: Adicionar Pacotes

Editar `pubspec.yaml`:

```yaml
dependencies:
  # Firebase core (já tem)
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.3
  
  # NOVOS - Analytics, Crashlytics, Remote Config
  firebase_analytics: ^11.3.7
  firebase_crashlytics: ^4.1.7
  firebase_remote_config: ^5.1.7
```

Então executar:

```powershell
flutter pub get
```

### PASSO 3: Configurar Firebase Analytics

**Criar arquivo: `lib/src/services/analytics_service.dart`**

```dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  FirebaseAnalyticsObserver get analyticsObserver => 
    FirebaseAnalyticsObserver(analytics: _analytics);

  // Eventos de Autenticação
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
    if (kDebugMode) print('Analytics: Login com $method');
  }

  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
    if (kDebugMode) print('Analytics: Cadastro com $method');
  }

  // Eventos de Agendamento
  Future<void> logBookingStarted() async {
    await _analytics.logEvent(
      name: 'booking_started',
      parameters: {'timestamp': DateTime.now().toIso8601String()},
    );
    if (kDebugMode) print('Analytics: Agendamento iniciado');
  }

  Future<void> logBookingCompleted({
    required String barberId,
    required String serviceId,
    required double price,
  }) async {
    await _analytics.logEvent(
      name: 'booking_completed',
      parameters: {
        'barber_id': barberId,
        'service_id': serviceId,
        'price': price,
        'currency': 'BRL',
      },
    );
    if (kDebugMode) print('Analytics: Agendamento concluído - R\$ $price');
  }

  Future<void> logBookingCancelled(String reason) async {
    await _analytics.logEvent(
      name: 'booking_cancelled',
      parameters: {'reason': reason},
    );
    if (kDebugMode) print('Analytics: Agendamento cancelado - $reason');
  }

  // Eventos de Navegação
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
    if (kDebugMode) print('Analytics: Tela visualizada - $screenName');
  }

  // Eventos de Busca
  Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
    if (kDebugMode) print('Analytics: Busca realizada - $searchTerm');
  }

  // Propriedades do Usuário
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
    if (kDebugMode) print('Analytics: User ID definido - $userId');
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
    if (kDebugMode) print('Analytics: Propriedade $name = $value');
  }
}
```

### PASSO 4: Configurar Firebase Crashlytics

**Criar arquivo: `lib/src/services/crashlytics_service.dart`**

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Inicializar Crashlytics
  Future<void> initialize() async {
    // Passar erros do Flutter para o Crashlytics
    FlutterError.onError = _crashlytics.recordFlutterFatalError;

    // Passar erros assíncronos para o Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    if (kDebugMode) {
      print('Crashlytics: Inicializado');
    }
  }

  // Registrar erro não fatal
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
    if (kDebugMode) {
      print('Crashlytics: Erro registrado - $exception');
    }
  }

  // Registrar log customizado
  Future<void> log(String message) async {
    await _crashlytics.log(message);
    if (kDebugMode) {
      print('Crashlytics Log: $message');
    }
  }

  // Definir User ID
  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
    if (kDebugMode) {
      print('Crashlytics: User ID definido - $userId');
    }
  }

  // Definir chaves customizadas
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
    if (kDebugMode) {
      print('Crashlytics: Chave $key = $value');
    }
  }

  // Forçar crash (apenas para testes)
  void forceCrashForTesting() {
    if (kDebugMode) {
      _crashlytics.crash();
    }
  }
}
```

### PASSO 5: Configurar Remote Config

**Criar arquivo: `lib/src/services/remote_config_service.dart`**

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  
  // Valores padrão
  final Map<String, dynamic> _defaults = {
    'maintenance_mode': false,
    'maintenance_message': 'Estamos em manutenção. Voltamos em breve!',
    'minimum_app_version': '1.0.0',
    'force_update': false,
    'enable_chat_feature': true,
    'enable_ai_assistant': false,
    'booking_cancellation_hours': 24,
    'promo_banner_enabled': false,
    'promo_banner_text': '',
    'promo_banner_url': '',
  };

  // Inicializar Remote Config
  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      await _remoteConfig.setDefaults(_defaults);
      await _remoteConfig.fetchAndActivate();

      if (kDebugMode) {
        print('Remote Config: Inicializado com sucesso');
        print('Valores atuais: ${_remoteConfig.getAll()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Remote Config: Erro ao inicializar - $e');
      }
    }
  }

  // Forçar atualização dos valores
  Future<void> fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
      if (kDebugMode) {
        print('Remote Config: Valores atualizados');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Remote Config: Erro ao atualizar - $e');
      }
    }
  }

  // Getters para valores específicos
  bool get maintenanceMode => _remoteConfig.getBool('maintenance_mode');
  
  String get maintenanceMessage => 
    _remoteConfig.getString('maintenance_message');
  
  String get minimumAppVersion => 
    _remoteConfig.getString('minimum_app_version');
  
  bool get forceUpdate => _remoteConfig.getBool('force_update');
  
  bool get chatFeatureEnabled => 
    _remoteConfig.getBool('enable_chat_feature');
  
  bool get aiAssistantEnabled => 
    _remoteConfig.getBool('enable_ai_assistant');
  
  int get bookingCancellationHours => 
    _remoteConfig.getInt('booking_cancellation_hours');
  
  bool get promoBannerEnabled => 
    _remoteConfig.getBool('promo_banner_enabled');
  
  String get promoBannerText => 
    _remoteConfig.getString('promo_banner_text');
  
  String get promoBannerUrl => 
    _remoteConfig.getString('promo_banner_url');

  // Método genérico para obter qualquer valor
  dynamic getValue(String key) {
    return _remoteConfig.getValue(key);
  }
}
```

### PASSO 6: Atualizar main.dart

**Editar: `lib/main.dart`**

Adicionar inicialização dos serviços:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'src/app.dart';
import 'src/services/analytics_service.dart';
import 'src/services/crashlytics_service.dart';
import 'src/services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar serviços Firebase
  final crashlytics = CrashlyticsService();
  await crashlytics.initialize();
  
  final remoteConfig = RemoteConfigService();
  await remoteConfig.initialize();

  // Verificar modo de manutenção
  if (remoteConfig.maintenanceMode) {
    runApp(MaintenanceApp(message: remoteConfig.maintenanceMessage));
    return;
  }

  // Executar app normalmente
  runApp(
    ProviderScope(
      child: BarberGoApp(),
    ),
  );
}

// App de manutenção
class MaintenanceApp extends StatelessWidget {
  final String message;
  
  const MaintenanceApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.build, size: 64, color: Colors.orange),
                SizedBox(height: 24),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🧪 COMO TESTAR

### Testar Analytics

```powershell
# 1. Rodar app
flutter run -d chrome

# 2. No código, adicionar teste:
# analyticsService.logLogin('email');

# 3. Ver no Firebase Console:
# Firebase Console > Analytics > Events
# Aguardar 24h para dados aparecerem (ou DebugView para tempo real)
```

### Testar Crashlytics

```dart
// Adicionar botão de teste no app:
ElevatedButton(
  onPressed: () {
    throw Exception('Teste de crash!');
  },
  child: Text('Testar Crash'),
)

// Ver crashes em: Firebase Console > Crashlytics
```

### Testar Remote Config

```powershell
# 1. Ir ao Firebase Console > Remote Config
# 2. Adicionar parâmetros:
#    - maintenance_mode: false
#    - promo_banner_enabled: true
#    - promo_banner_text: "Desconto de 20%!"

# 3. Publicar mudanças
# 4. No app, fechar e reabrir
# 5. Valores devem atualizar automaticamente
```

---

## 📊 FIREBASE CONSOLE - Onde Ver Tudo

```
Firebase Console (console.firebase.google.com)

├── 📊 Analytics
│   ├── Events → Ver eventos personalizados
│   ├── Realtime → Ver atividade em tempo real
│   └── DebugView → Debug eventos (dev mode)
│
├── 🐛 Crashlytics
│   ├── Crashes → Ver crashes fatais
│   ├── Non-fatals → Ver erros não fatais
│   └── Velocity Alerts → Alertas automáticos
│
└── ⚙️ Remote Config
    ├── Parameters → Gerenciar parâmetros
    ├── Conditions → Criar condições (ex: por versão)
    └── Publishing → Histórico de mudanças
```

---

## ✅ CRITÉRIOS DE SUCESSO

Sprint concluído quando:

- [ ] Analytics registrando eventos (visível no console)
- [ ] Crashlytics capturando erros (teste funcionando)
- [ ] Remote Config atualizando valores (sem redeploy)
- [ ] Código documentado e testado
- [ ] Commit realizado com mensagem clara

---

## 🚀 PRÓXIMOS PASSOS (Sprint 3)

Após completar este sprint:

1. Cloud Functions para agendamentos
2. Push Notifications (FCM)
3. Chat/Mensagens em tempo real

---

**VAMOS COMEÇAR?** 

Execute o primeiro comando:

```powershell
firebase --version
```

Me avise o resultado e vamos juntos! 🔥
