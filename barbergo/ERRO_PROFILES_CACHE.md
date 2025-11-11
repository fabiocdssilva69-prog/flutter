# 🚨 Erro: App Acessa `Profiles` (Maiúsculo) Apesar de Deletado

## 📊 Diagnóstico Completo

### Erros Identificados no Firebase DebugView

**Erro #1 - 22:33:15:**
```
W/Firestore(6578): Listen for Query(target=Query(Profiles/6RYGS6HoEkhQgikN...
                   PERMISSION_DENIED: Missing or insufficient permissions
```

**Erro #2 - 22:23:27:**
```
W/Firestore(6578): Listen for Query(target=Query(Profiles/6RYGS6HoEkhQgikN...
                   PERMISSION_DENIED: Missing or insufficient permissions
```

### Erro Adicional: Router e Riverpod

```
I/flutter(6578): 🚨 ROUTER ERROR: GoException: no routes for location: /
I/flutter(6578): ❌ AUTH: Erro no logout: Cannot use the Ref of authControllerProvider 
                 after it has been disposed
```

## 🔍 Causa Raiz

### 1. Cache Local do Firestore SDK

O Firebase Firestore mantém **cache local persistente** que NÃO é limpo por:
- ❌ `flutter clean`
- ❌ `flutter run` (reinstalação normal)
- ❌ Hot restart/Hot reload
- ❌ Deletar coleção no Firebase Console

O cache **só é limpo** por:
- ✅ **Desinstalar app completamente** do dispositivo
- ✅ Limpar dados do app (Configurações → Apps)
- ✅ Código que desabilita cache:
  ```dart
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  ```

### 2. Como o Cache Foi Criado

**Histórico:**
1. Em algum momento anterior, o app acessou `Profiles` (maiúsculo)
2. Firestore SDK criou cache local com esse caminho
3. Você deletou a coleção `Profiles` no Firebase Console
4. **MAS** o SDK continua tentando sincronizar do cache local
5. Resultado: PERMISSION_DENIED porque coleção não existe + sem rules

### 3. Por Que o Código Está Correto

✅ **Verificado:** TODO o código usa `profiles` (minúsculo)
```dart
// profile_repository.dart
static const String profilesPath = 'profiles'; // ✅ CORRETO

// Todas as queries
await _service.db.collection(profilesPath).doc(userId).get(); // ✅ CORRETO
```

✅ **Verificado:** Firestore Rules usam `profiles` (minúsculo)
```javascript
match /profiles/{profileId} { // ✅ CORRETO
  allow read: if request.auth != null;
  allow write: if request.auth != null && request.auth.uid == profileId;
}
```

## 🔧 Solução: Desinstalar App Completamente

### Opção 1: Via Dispositivo Android (Recomendado)

1. **No Redmi Note 8 Pro:**
   - Vá em **Configurações**
   - **Apps** → **Gerenciar Apps**
   - Procure **BarberGO**
   - Toque no app
   - **Desinstalar**

2. **Após desinstalar, reinstale:**
   ```powershell
   flutter run -d uwbekb8hpf6lamts
   ```

### Opção 2: Via Linha de Comando (Alternativa)

1. **Pare o app** (se estiver rodando):
   - No terminal Flutter, pressione `q`

2. **Desinstale via PowerShell:**
   ```powershell
   # Encontre o ADB
   $adbPath = Get-Command adb -ErrorAction SilentlyContinue
   
   if ($adbPath) {
       adb uninstall com.example.barbergo_app
   } else {
       Write-Host "ADB não encontrado. Use Opção 1 (dispositivo Android)"
   }
   ```

3. **Reinstale:**
   ```powershell
   flutter run -d uwbekb8hpf6lamts
   ```

### Opção 3: Limpar Cache Sem Desinstalar (Temporário)

**⚠️ Esta opção pode não resolver completamente**

No dispositivo:
1. **Configurações** → **Apps** → **BarberGO**
2. **Armazenamento**
3. **Limpar dados**
4. **Limpar cache**

## 🛡️ Prevenção: Desabilitar Cache do Firestore

Para evitar problemas futuros de cache, adicione ao início da app:

### Arquivo: `lib/main.dart`

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔧 DESABILITAR CACHE DO FIRESTORE (evita problemas de collection name)
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false, // ← Desabilita cache local
  );
  
  runApp(const ProviderScope(child: MyApp()));
}
```

**⚠️ Trade-offs:**
- ✅ **Pro:** Sem problemas de cache, sempre dados frescos do servidor
- ❌ **Con:** Sem modo offline, requer conexão sempre
- ❌ **Con:** Pode aumentar uso de dados móveis

## 📊 Correlação com Firebase DebugView

| Timestamp DebugView | Log Android | Evento |
|---------------------|-------------|---------|
| 22:33:15 | W/Firestore: PERMISSION_DENIED on Profiles | `app_exception` |
| 22:23:27 | W/Firestore: PERMISSION_DENIED on Profiles | `app_exception` |
| 22:33:39 | D/FirebaseAuth: user (6RYGS6HoEkhQgikN...) | `login` event |
| 22:33:14 | (Profile load attempt) | `screen_view` |

**Padrão Identificado:**
1. User faz login → Firebase Analytics registra `login`
2. App tenta carregar profile → Acessa cache antigo com `Profiles`
3. Firestore SDK tenta sincronizar → PERMISSION_DENIED
4. Firebase Crashlytics registra `app_exception`

## ✅ Checklist de Validação Pós-Reinstalação

Após desinstalar e reinstalar, verifique nos logs:

### ✅ Sinais de Sucesso:

```
D/FirebaseAuth: Notifying auth state listeners about user (6RYGS6HoEkhQgikN...)
D/Firestore: Listen for Query(target=Query(profiles/6RYGS6HoEkhQgikN... ← lowercase p
✅ SEM ERROS
```

### ❌ Sinais de Problema Persistente:

```
W/Firestore: Listen for Query(target=Query(Profiles/6RYGS6HoEkhQgikN... ← uppercase P
PERMISSION_DENIED
```

Se isso aparecer novamente, significa que:
1. App ainda não foi completamente desinstalado
2. Ou há código gerado (`.g.dart`) com referência antiga

## 🔧 Solução Definitiva: Código + Desinstalação

### Passo 1: Adicione Desabilitação de Cache

```dart
// lib/main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Desabilitar cache para evitar problemas
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}
```

### Passo 2: Limpe Build e Código Gerado

```powershell
flutter clean
dart run build_runner clean
```

### Passo 3: Desinstale App do Dispositivo

**No celular:**
- Configurações → Apps → BarberGO → Desinstalar

### Passo 4: Recompile e Reinstale

```powershell
dart run build_runner build --delete-conflicting-outputs
flutter run -d uwbekb8hpf6lamts
```

### Passo 5: Verifique Logs

Procure por:
- ✅ `D/Firestore: ...profiles/...` (lowercase p)
- ❌ `W/Firestore: ...Profiles/...` (uppercase P)

## 📝 Resumo

| Problema | Causa | Solução |
|----------|-------|---------|
| PERMISSION_DENIED | Cache local Firestore com `Profiles` antigo | Desinstalar app |
| App exception no DebugView | SDK tenta sincronizar cache inválido | Limpar dados app |
| Erro persiste após flutter clean | Cache não é limpo por flutter tools | Desinstalação física |
| Prevenir futuras ocorrências | Cache pode guardar paths antigos | `persistenceEnabled: false` |

## 🎯 Ação Imediata

**Faça agora:**

1. ✋ Pare o app atual no terminal (pressione `q`)
2. 📱 No celular: Configurações → Apps → BarberGO → **Desinstalar**
3. 💻 No terminal: `flutter run -d uwbekb8hpf6lamts`
4. 👀 Monitore logs procurando por `Profiles` (maiúsculo)

**Tempo estimado:** 2-3 minutos

**Resultado esperado:** Sem erros de PERMISSION_DENIED, profile carrega normalmente

---

**Status:** ⏳ Aguardando desinstalação do app pelo usuário
