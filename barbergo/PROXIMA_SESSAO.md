# 📋 CHECKLIST - PRÓXIMA SESSÃO (Prioridade de Execução)

**Data de Criação**: 22/10/2025
**Última Atualização Sprint**: 22 (Production Hardening - COMPLETO)

---

## 🔴 P0 - CRÍTICO (FAZER PRIMEIRO)

### 1. Implementar FCM Token no App Flutter (2-3 horas)

**Por quê**: Cloud Functions já enviam push, mas app não salva token ainda. Sem isso, nenhuma notificação chegará nos dispositivos.

**Passos**:

#### 1.1. Adicionar Dependência (5 min)
```yaml
# pubspec.yaml (linha ~50, após firebase_core)
dependencies:
  firebase_messaging: ^14.7.0  # Adicionar esta linha
```

```bash
flutter pub get
```

#### 1.2. Criar FCM Service (30 min)
Criar arquivo: `lib/src/core/services/fcm_service.dart`

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_service.g.dart';

@riverpod
FcmService fcmService(Ref ref) {
  return FcmService();
}

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  // Salva FCM token no Firestore
  Future<void> saveFcmToken(String userId) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .update({'fcmToken': token});
        
        if (kDebugMode) {
          debugPrint('✅ FCM Token saved: ${token.substring(0, 20)}...');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error saving FCM token: $e');
      }
    }
  }
  
  // Solicita permissão de notificações (iOS)
  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    if (kDebugMode) {
      debugPrint('Notification permission: ${settings.authorizationStatus}');
    }
  }
  
  // Configura handlers de notificação
  void setupHandlers() {
    // Foreground: App aberto
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('📩 Foreground notification: ${message.notification?.title}');
      }
      // TODO: Mostrar dialog ou snackbar
    });
    
    // Background: App em segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('📩 Opened from background: ${message.data}');
      }
      // TODO: Navegar para tela correta (inbox, vacancyDetails, etc)
    });
  }
}

// Background handler (DEVE estar no top-level, fora da classe)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    debugPrint('📩 Background notification: ${message.notification?.title}');
  }
}
```

#### 1.3. Integrar no App (30 min)
Atualizar `lib/main.dart`:

```dart
// No topo do arquivo
import 'package:firebase_messaging/firebase_messaging.dart';
import 'src/core/services/fcm_service.dart';

// ANTES do runApp()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // ADICIONAR: Background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  runApp(ProviderScope(child: MyApp()));
}

// Background handler (top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    debugPrint('📩 Background: ${message.notification?.title}');
  }
}
```

Atualizar `lib/src/core/controllers/auth_controller.dart`:

```dart
// No método de login/signup, após criar perfil:
Future<void> signInWithEmailPassword(String email, String password) async {
  // ... código existente ...
  
  // ADICIONAR após login bem-sucedido:
  final fcmService = ref.read(fcmServiceProvider);
  await fcmService.requestPermission();
  await fcmService.saveFcmToken(user.uid);
  fcmService.setupHandlers();
}
```

#### 1.4. Configurar Android (15 min)
`android/app/src/main/AndroidManifest.xml`:

```xml
<!-- ADICIONAR dentro de <application> -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="barbergo_channel" />

<service
    android:name="com.google.firebase.messaging.FirebaseMessagingService"
    android:exported="false">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
</service>
```

#### 1.5. Configurar iOS (15 min)
`ios/Runner/Info.plist`:

```xml
<!-- ADICIONAR antes de </dict> -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### 1.6. Testar (1 hora)
1. Build APK: `flutter build apk --debug`
2. Instalar no device: `flutter install`
3. Fazer login no app
4. Verificar Firestore: Campo `fcmToken` deve estar salvo em `profiles/{userId}`
5. Testar notificação manual no Firebase Console:
   - Console → Cloud Messaging → Send test message
   - Colar o FCM token
   - Enviar → Verificar se chega no dispositivo

---

### 2. Testar Fluxo End-to-End (1-2 horas)

**Cenários de Teste**:

#### 2.1. Nova Candidatura
1. Login como barbeiro
2. Navegar para "Explorar Vagas"
3. Clicar em uma vaga
4. Clicar "Candidatar-se"
5. **Verificar**:
   - [ ] Barbearia recebe push notification
   - [ ] Notificação salva em Inbox da barbearia
   - [ ] Ao clicar: Navega para "Gestão de Candidaturas"

#### 2.2. Aceitar Candidatura
1. Login como barbearia
2. Navegar para "Gestão" → "Candidaturas"
3. Clicar "Aceitar e Abrir Chat"
4. **Verificar**:
   - [ ] Barbeiro recebe push: "✅ Candidatura Aceita!"
   - [ ] Notificação salva no Inbox do barbeiro
   - [ ] Sala de chat criada (Sprint 21)
   - [ ] Ao clicar notificação: Navega para Inbox

#### 2.3. Rejeitar Candidatura
1. Login como barbearia
2. Clicar "Rejeitar" em uma candidatura
3. **Verificar**:
   - [ ] Barbeiro recebe push: "❌ Candidatura Rejeitada"
   - [ ] Notificação salva no Inbox
   - [ ] Ao clicar: Navega para "Minhas Candidaturas"

#### 2.4. Editar Perfil (Propagação)
1. Login como barbearia
2. Editar nome ou localização no perfil
3. **Verificar**:
   - [ ] Vagas atualizadas com novo nome
   - [ ] Candidaturas atualizadas
   - [ ] Salas de chat atualizadas
   - [ ] Logs no Console Firebase: "Propagating changes for Profile..."

---

## 🟡 P1 - ALTO (FAZER DEPOIS DO P0)

### 3. Monitorar Cloud Functions (30 min)

**Firebase Console** → Functions → Selecionar função:

#### 3.1. Métricas a Verificar
- **Invocações**: Quantas vezes foi chamada
- **Taxa de erro**: Deve ser < 5%
- **Latência**: Deve ser < 2s
- **Custo**: Verificar se está no free tier

#### 3.2. Logs
```bash
# Logs das últimas 24h
firebase functions:log --since 24h

# Logs de uma função específica
firebase functions:log --only propagateProfileUpdate

# Seguir logs em tempo real
firebase functions:log
```

#### 3.3. Alertas (Configurar no Console)
- Taxa de erro > 5%
- Latência > 3s
- Custo diário > $1.00

---

### 4. Otimizar Performance (1 hora)

#### 4.1. Firestore Indexes
Verificar se todos os indexes foram criados:
```bash
firebase firestore:indexes:list
```

**Status esperado**: 6 indexes, todos "ENABLED"

Se algum estiver "BUILDING", aguardar 5-10 minutos.

#### 4.2. Cloud Functions
Verificar logs para queries lentas:
```bash
firebase functions:log --only propagateProfileUpdate | grep "slow"
```

Se encontrar queries > 2s, considerar:
- Aumentar memory (256MB → 512MB)
- Adicionar índices no Firestore
- Otimizar batch size (500 operations max)

---

## 🟢 P2 - MÉDIO (MELHORIAS)

### 5. Criar Testes Automatizados (4-6 horas)

#### 5.1. Cloud Functions (Jest)
Criar `functions/test/notificationUtils.test.ts`:

```typescript
import {getFcmToken, saveToInbox, sendFcmMessage} from '../src/notificationUtils';
import * as admin from 'firebase-admin';

// Mock Firestore
jest.mock('firebase-admin', () => ({
  firestore: jest.fn(() => ({
    collection: jest.fn().mockReturnThis(),
    doc: jest.fn().mockReturnThis(),
    get: jest.fn().mockResolvedValue({data: () => ({fcmToken: 'test-token'})}),
  })),
}));

describe('notificationUtils', () => {
  test('getFcmToken retorna token válido', async () => {
    const token = await getFcmToken('user123');
    expect(token).toBe('test-token');
  });
  
  // Mais testes...
});
```

#### 5.2. Flutter (Widget Tests)
Criar `test/widgets/application_tile_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:barbergo_app/src/features/management/widgets/application_tile.dart';

void main() {
  testWidgets('Mostra erro quando perfil não encontrado', (tester) async {
    // Arrange: Mock provider retornando null
    
    // Act: Renderizar ApplicationTile
    await tester.pumpWidget(/* ... */);
    
    // Assert: Verificar se mostra ícone de erro
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Perfil não encontrado'), findsOneWidget);
  });
}
```

---

### 6. Documentação Adicional (1 hora)

#### 6.1. README do Projeto
Atualizar `README.md` com:
- Como configurar FCM
- Como testar notificações
- Como debugar Cloud Functions

#### 6.2. Guia de Troubleshooting
Criar `TROUBLESHOOTING.md`:
- "Notificação não chega" → Verificar FCM token
- "Function dá timeout" → Aumentar memory
- "Propagação não funciona" → Verificar logs

---

## 🔵 P3 - BAIXO (OPCIONAL)

### 7. Melhorias UX (2-3 horas)

#### 7.1. Badge de Notificações
Adicionar contador de notificações não lidas:
```dart
Badge(
  count: unreadCount,
  child: Icon(Icons.notifications),
)
```

#### 7.2. Sons Personalizados
Adicionar sons diferentes para cada tipo:
- Nova candidatura: "notification_new.mp3"
- Aceita: "notification_success.mp3"
- Rejeitada: "notification_error.mp3"

#### 7.3. Vibração
```dart
import 'package:vibration/vibration.dart';

if (message.notification != null) {
  Vibration.vibrate(duration: 500);
}
```

---

### 8. Analytics e Tracking (1 hora)

Adicionar eventos no LoggerService:
```dart
logEvent('notification_received', parameters: {
  'type': message.data['type'],
  'timestamp': DateTime.now().toIso8601String(),
});

logEvent('notification_clicked', parameters: {
  'screen': message.data['screen'],
  'notification_id': message.messageId,
});
```

---

## 📅 CRONOGRAMA SUGERIDO

### Sessão 1 (3-4 horas)
- [ ] P0.1: Implementar FCM Token (2-3h)
- [ ] P0.2: Testar End-to-End (1h)

### Sessão 2 (2 horas)
- [ ] P1.3: Monitorar Functions (30min)
- [ ] P1.4: Otimizar Performance (1h)
- [ ] P2.6: Documentação (30min)

### Sessão 3 (4-6 horas) - Opcional
- [ ] P2.5: Testes Automatizados (4-6h)

### Sessão 4 (3 horas) - Opcional
- [ ] P3.7: Melhorias UX (2h)
- [ ] P3.8: Analytics (1h)

---

## 🛠️ COMANDOS ÚTEIS PARA NEXT SESSION

### Verificar Estado
```bash
# Cloud Functions
firebase functions:list

# Firestore Indexes
firebase firestore:indexes:list

# Logs recentes
firebase functions:log --since 1h

# Device conectado
flutter devices
```

### Build e Deploy
```bash
# Build Runner
dart run build_runner build --delete-conflicting-outputs

# Build APK Debug
flutter build apk --debug

# Install no device
flutter install -d uwbekb8hpf6lamts

# Redeploy functions
firebase deploy --only functions
```

### Debug
```bash
# Logs em tempo real
firebase functions:log

# Emulador local (testar antes de deploy)
firebase emulators:start

# Dart analyze
dart analyze

# Flutter analyze
flutter analyze
```

---

## ✅ CRITÉRIOS DE SUCESSO

### MVP Completo (P0 + P1)
- [ ] FCM token salvando corretamente
- [ ] Push notifications chegando em foreground
- [ ] Push notifications chegando em background
- [ ] Navegação funcionando ao clicar notificação
- [ ] Propagação de dados funcionando
- [ ] Cloud Functions sem erros nos logs
- [ ] Performance aceitável (< 2s latency)

### Production Ready (MVP + P2)
- [ ] Testes automatizados passando
- [ ] Documentação completa
- [ ] Monitoramento configurado
- [ ] Alertas configurados

### Excelência (Production Ready + P3)
- [ ] UX polida (badge, sons, vibração)
- [ ] Analytics configurado
- [ ] Cobertura de testes > 80%

---

**Criado em**: 22/10/2025
**Próxima Revisão**: Após completar P0 (FCM Implementation)
**Estimativa Total**: 8-16 horas (depende de incluir P2 e P3)
