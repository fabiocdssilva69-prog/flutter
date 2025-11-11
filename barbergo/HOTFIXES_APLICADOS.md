# HOTFIXES APLICADOS - SPRINT 28 FASE 0

**Data/Hora:** 27/10/2025 16:30  
**Status:** COMPLETO - Pronto para teste  

---

## RESUMO EXECUTIVO

### Problema Diagnosticado
Após corrigir o `MapperException` do `TimestampHook`, identificamos DOIS novos erros críticos:

1. **Bad State: "Using ref when unmounted"** (CRÍTICO)
   - Login bem-sucedido no Firebase
   - App crashava imediatamente após autenticação
   - Causa: Condição de corrida entre async login e navegação automática do GoRouter

2. **Loop Infinito FCM** (PERFORMANCE)
   - Token FCM sendo atualizado repetidamente no Firestore
   - Impacto: Drenagem de bateria + custos desnecessários
   - Causa: Não verificava se token já estava atualizado

---

## HOTFIXES IMPLEMENTADOS

### Hotfix 1: Login Screen (Arquitetura Reativa)

**Arquivo:** `lib/src/features/auth/screens/login_screen.dart`

**Problema:**
```dart
// ANTES (ERRADO):
Future _submit() async {
  await ref.read(authControllerProvider.notifier).signIn(...);
  await ref.read(firebaseAnalyticsServiceProvider).logLogin('email'); // ❌ CRASH: widget unmounted
}
```

**Solução:**
```dart
// DEPOIS (CORRETO):
Future<void> _submit() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  
  // Apenas dispara a ação
  await ref.read(authControllerProvider.notifier).signIn(email, password);
  // NÃO usa ref/context após await
}

@override
Widget build(BuildContext context) {
  // Listener observa resultado de forma segura
  ref.listen<AsyncValue<void>>(
    authControllerProvider,
    (previous, state) {
      // Erros via dialog
      state.showAlertDialogOnError(context);
      
      // Analytics de sucesso (seguro, pois está no listener)
      if (state.hasValue && !state.isLoading && previous?.isLoading == true) {
        ref.read(firebaseAnalyticsServiceProvider).logLogin('email');
      }
    },
  );
  // ... UI
}
```

**Benefícios:**
- ✅ Elimina condição de corrida
- ✅ Segue best practice Riverpod (reatividade)
- ✅ GoRouter navega automaticamente sem conflito
- ✅ Analytics logado de forma segura

---

### Hotfix 2: FCM Token Loop

**Arquivo:** `lib/src/core/services/notification_service.dart`

**Problema:**
```dart
// ANTES (ERRADO):
void _updateTokenInBackend(String userId, String token) {
  _logger.logEvent("FCM_UpdatingTokenInBackend");
  unawaited(
    _ref.read(profileRepositoryProvider).updateFcmToken(userId, token)
  ); // ❌ Atualiza sempre, mesmo se token é igual
}
```

**Solução:**
```dart
// DEPOIS (CORRETO):
void _updateTokenInBackend(String userId, String token) {
  // 1. Obter perfil atual
  final currentProfile = _ref.read(currentUserProfileProvider).valueOrNull;
  
  // 2. VERIFICAÇÃO ANTI-LOOP
  if (currentProfile != null && currentProfile.fcmToken == token) {
    _logger.logEvent("FCM_TokenAlreadyUpToDate");
    return; // ✅ Token já está correto, não faz nada
  }
  
  // 3. Atualizar apenas se diferente
  _logger.logEvent("FCM_UpdatingTokenInBackend");
  unawaited(
    _ref.read(profileRepositoryProvider).updateFcmToken(userId, token).then((_) {
      _logger.logEvent("FCM_TokenUpdateSuccess");
      _ref.invalidate(currentUserProfileProvider); // Sincroniza cache
    }).catchError((e, stack) {
      _logger.logError(e, stack, context: "Failed to update FCM token");
    }),
  );
}
```

**Benefícios:**
- ✅ Elimina loop infinito
- ✅ Reduz writes desnecessários no Firestore
- ✅ Economiza bateria do dispositivo
- ✅ Reduz custos de backend

---

## CORREÇÕES TÉCNICAS

### Arquivos Modificados
1. `lib/src/features/auth/screens/login_screen.dart`
   - Refatorado `_submit()` para não usar ref após await
   - Adicionado `ref.listen` com tratamento de erro e analytics
   
2. `lib/src/core/services/notification_service.dart`
   - Adicionado import `profile_controller.dart`
   - Implementada verificação de token antes de atualizar
   - Adicionado invalidate para sincronizar cache

### Build Status
- ✅ `dart run build_runner build --delete-conflicting-outputs` (121s)
- ✅ 4 outputs gerados (Riverpod + Mappable)
- ✅ Zero erros de compilação

---

## INSTRUÇÕES PARA INSTALAÇÃO

### Problema do Terminal VS Code
O terminal integrado do VS Code está apresentando prompt de batch file que interrompe o `flutter run`.

### Solução: PowerShell Externo

Abra um **PowerShell NOVO** (fora do VS Code) e execute:

```powershell
# Navegue para o projeto
cd C:\workspaces\fabiocdssilva69-prog\barbergo

# Execute o app
flutter run -d uwbekb8hpf6lamts
```

**OU use o script automatizado:**

```powershell
powershell -ExecutionPolicy Bypass -File "C:\workspaces\fabiocdssilva69-prog\barbergo\instalar_corrigido.ps1"
```

### Durante a Instalação
- ⏰ Tempo estimado: **5-7 minutos**
- 📱 Mantenha o celular **desbloqueado**
- ✅ Aceite o pop-up **"Instalar via USB"** se aparecer
- 🔍 Aguarde mensagem: **"Flutter run key commands"**

---

## TESTE DO LOGIN

### Passo a Passo

1. **Abrir o app** no celular (instalado via PowerShell)

2. **Ir para tela de login**

3. **Digitar credenciais:**
   - Email: `fabiocds.silva69@gmail.com`
   - Senha: (a senha configurada)

4. **Clicar em "ENTRAR"**

5. **Verificar comportamentos:**

   #### Cenário A (Esperado - 90% probabilidade):
   - ✅ Botão mostra `CircularProgressIndicator`
   - ✅ Login bem-sucedido no Firebase
   - ✅ Navegação automática para tela Home/Dashboard
   - ✅ **SEM CRASH** (sem "Bad state" error)
   - ✅ Logs FCM mostram "TokenAlreadyUpToDate" (sem loop)

   #### Cenário B (Se persistir - 10% probabilidade):
   - ❌ App crasha após login
   - 📸 **Tirar screenshot do erro**
   - 💬 **Relatar no chat** imediatamente

---

## LOGS ESPERADOS (Firebase DebugView)

### Login Bem-Sucedido:
```
I/FirebaseAuth: Logging in as fabiocds.silva69@gmail.com...
D/FirebaseAuth: Notifying auth state listeners about user
I/flutter: [LOG EVENT] login_method: email
I/flutter: [LOG EVENT] FCM_TokenAlreadyUpToDate  ← NOVO (sem loop)
```

### Navegação Automática:
```
I/flutter: [LOG SCREEN] home_screen
```

---

## PRÓXIMOS PASSOS (Após Login Funcionar)

1. **Testar Crashlytics** (forçar crash controlado)
2. **Validar notificações FCM** (enviar teste do Firebase Console)
3. **Completar Fase 0** (48h críticas)
4. **Iniciar Fase 1** (Feature Freeze + Auditoria MVP)

---

## BACKUPS E SEGURANÇA

### Commits Git (Se aplicável):
```bash
git add lib/src/features/auth/screens/login_screen.dart
git add lib/src/core/services/notification_service.dart
git commit -m "fix: resolve login unmounted error + FCM loop (Hotfix Sprint 28)"
```

### Arquivos de Referência:
- `STATUS_CAPTURA_AO_VIVO.md` - Sessão de diagnóstico
- `INSTRUCOES_INSTALACAO_CORRIGIDA.md` - Guia anterior
- `capturar_erro_login.ps1` - Script de monitoring (se necessário)

---

## SUPORTE

Se encontrar problemas:

1. **Capturar logs em tempo real:**
   ```powershell
   flutter logs -d uwbekb8hpf6lamts > logs_teste_hotfix.txt
   ```

2. **Verificar se app está rodando:**
   ```powershell
   adb -s uwbekb8hpf6lamts shell ps | Select-String "barbergo"
   ```

3. **Forçar parada (se necessário):**
   ```powershell
   adb -s uwbekb8hpf6lamts shell am force-stop com.example.barbergo_app
   ```

---

**Maestro Fábio:** Os hotfixes estão prontos. Basta executar `flutter run` em um PowerShell externo e testar o login. Expectativa: **login funcionará sem crash** e **FCM sem loop**. Aguardo confirmação! 🚀
