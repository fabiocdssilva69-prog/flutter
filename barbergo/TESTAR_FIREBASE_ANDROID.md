# 🤖 Testar Firebase Analytics no Android

**Data:** 2025-10-16  
**Status:** ✅ Pronto para testar no Android

---

## 📱 Pré-requisitos

### 1. Verificar Emulador Android

```powershell
# Ver emuladores disponíveis
flutter emulators

# Se não tiver emulador, criar um:
# Abrir Android Studio → Tools → AVD Manager → Create Virtual Device
# Recomendado: Pixel 5 API 33 (Android 13)
```

### 2. Iniciar Emulador

```powershell
# Opção 1: Via Flutter (se tiver emulador configurado)
flutter emulators --launch <nome_do_emulador>

# Opção 2: Via Android Studio
# Abrir Android Studio → AVD Manager → ▶️ Play no emulador

# Opção 3: Usar dispositivo físico
# Conectar telefone via USB
# Habilitar "Depuração USB" no telefone
```

### 3. Verificar Dispositivo Conectado

```powershell
# Ver dispositivos disponíveis
flutter devices

# Deve aparecer algo como:
# Pixel 5 API 33 (mobile) • emulator-5554 • android • Android 13 (API 33)
# ou
# SM-G973F (mobile) • XXXXXXXXX • android • Android 12 (API 31)
```

---

## 🚀 Como Rodar no Android

### Método 1: Modo Normal

```powershell
# Rodar no emulador/dispositivo Android
flutter run

# Se tiver múltiplos dispositivos:
flutter run -d <device-id>

# Exemplo:
flutter run -d emulator-5554
```

### Método 2: Modo Debug com Firebase DebugView

```powershell
# Rodar com debug habilitado para ver eventos em tempo real
flutter run --dart-define=FLUTTER_WEB_DEBUG=true

# Ou com device específico:
flutter run -d emulator-5554 --dart-define=FLUTTER_WEB_DEBUG=true
```

### Método 3: Verificar Build Release

```powershell
# Build APK de produção
flutter build apk --release

# Instalar no dispositivo:
flutter install

# APK gerado em: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Fluxo de Teste Completo

### 1. Testar Tela de Login

```
1. Abrir app no Android
2. Ir para tela de Login
3. ✅ Verificar: logScreenView('login_screen') foi chamado
4. Fazer login com usuário teste
5. ✅ Verificar: logLogin('email') foi chamado
```

### 2. Testar Cadastro

```
1. Ir para tela de Cadastro
2. ✅ Verificar: logScreenView('signup_screen') foi chamado
3. Criar nova conta
4. ✅ Verificar: logEvent('sign_up', method: 'email') foi chamado
```

### 3. Testar Onboarding

```
1. Após criar conta, vai para Onboarding
2. ✅ Verificar: logScreenView('onboarding_account_type') foi chamado
3. Selecionar tipo de conta (Barbeiro/Barbearia)
4. Preencher cidade
5. Clicar em "Continuar"
6. ✅ Verificar: logEvent('onboarding_completed', account_type, location) foi chamado
```

### 4. Testar Home Screen

```
1. Após onboarding, vai para Home
2. ✅ Verificar: logScreenView('home_barber' ou 'home_barbershop') foi chamado
3. ✅ Verificar: setUserProperties(userType) foi chamado
```

### 5. Testar Chat IA

```
1. Ir para Chat Artístico (se tiver no menu)
2. ✅ Verificar: logScreenView('ai_artistic_chat') foi chamado
3. Enviar mensagem no chat
4. ✅ Verificar: logEvent('ai_message_sent', message_length) foi chamado
5. Usar sugestão de prompt
6. ✅ Verificar: logEvent('ai_suggested_prompt_used', prompt) foi chamado
```

---

## 📊 Verificar Eventos no Firebase Console

### Opção 1: DebugView (Tempo Real)

```
1. Abrir Firebase Console:
   https://console.firebase.google.com

2. Selecionar projeto "barbergo"

3. Analytics → DebugView

4. Selecionar seu dispositivo na lista

5. Navegar pelo app e ver eventos aparecerem em tempo real! 🎉
```

### Opção 2: Analytics (Após 24 horas)

```
1. Firebase Console → Analytics → Eventos

2. Ver estatísticas agregadas:
   - Contagem de eventos
   - Usuários únicos
   - Eventos por tela
   - Funil de conversão
```

---

## 🐛 Troubleshooting Android

### Problema: Emulador não inicia

```powershell
# Verificar se Android SDK está instalado
flutter doctor

# Deve mostrar:
# [✓] Android toolchain - develop for Android devices

# Se não estiver:
# Baixar Android Studio: https://developer.android.com/studio
# Instalar Android SDK através do Android Studio
```

### Problema: App não instala

```powershell
# Limpar cache e reinstalar
flutter clean
flutter pub get
flutter run
```

### Problema: Erro de compilação Android

```powershell
# Verificar configuração do Firebase no Android
# Arquivo deve existir: android/app/google-services.json

# Se não existir:
# 1. Firebase Console → Project Settings
# 2. Adicionar app Android
# 3. Download google-services.json
# 4. Colocar em: android/app/google-services.json
```

### Problema: Eventos não aparecem no DebugView

```powershell
# 1. Verificar se app está em modo debug
flutter run --debug

# 2. Verificar se Firebase Analytics está inicializado
# Ver logs no Android Studio ou terminal

# 3. Aguardar até 10 minutos (primeira sincronização pode demorar)

# 4. Forçar envio de eventos:
# Minimizar app → Maximizar app (força sync)
```

### Problema: "Waiting for another flutter command to release the startup lock"

```powershell
# Matar processo do Flutter
Get-Process | Where-Object {$_.ProcessName -eq "dart"} | Stop-Process -Force

# Ou reiniciar VS Code
```

---

## 📱 Comparação: Web vs Android

| Recurso | Web (Chrome) | Android |
|---------|-------------|---------|
| **Velocidade de teste** | ⚡ Rápido (hot reload instantâneo) | 🐢 Mais lento (recompilação) |
| **DebugView** | ✅ Funciona | ✅ Funciona |
| **Performance real** | ⚠️ Simulada | ✅ Real |
| **Push Notifications** | ❌ Limitado | ✅ Completo |
| **Sensores** | ❌ Não tem | ✅ GPS, Câmera, etc |
| **Firebase Analytics** | ✅ Completo | ✅ Completo |

**Recomendação:** 
- Use **Web** para desenvolvimento rápido e testes de lógica
- Use **Android** para testes finais antes de publicar

---

## 📋 Checklist de Teste Android

### Ambiente
- [ ] Android SDK instalado (`flutter doctor`)
- [ ] Emulador criado ou dispositivo físico conectado
- [ ] `flutter devices` mostra dispositivo Android
- [ ] Arquivo `android/app/google-services.json` existe

### Build
- [ ] `flutter clean` executado
- [ ] `flutter pub get` executado
- [ ] `flutter run` compila sem erros
- [ ] App abre no dispositivo Android

### Testes de Analytics
- [ ] Firebase Console → DebugView está aberto
- [ ] LoginScreen → `login_screen` aparece no DebugView
- [ ] Login com sucesso → `login` aparece no DebugView
- [ ] SignupScreen → `signup_screen` + `sign_up` aparecem
- [ ] Onboarding → `onboarding_account_type` + `onboarding_completed` aparecem
- [ ] HomeScreen → `home_barber` ou `home_barbershop` aparece
- [ ] Chat IA → `ai_artistic_chat` + `ai_message_sent` aparecem

### Verificação Final
- [ ] Todos os 5 eventos de screen view funcionam
- [ ] Todos os 6 eventos de ação funcionam
- [ ] User properties aparecem no Firebase Console
- [ ] Nenhum crash ou erro durante navegação

---

## 🎯 Comandos Rápidos (Copiar e Colar)

```powershell
# 1. Ver dispositivos
flutter devices

# 2. Rodar no Android (modo debug com DebugView)
flutter run --dart-define=FLUTTER_WEB_DEBUG=true

# 3. Se der erro, limpar e tentar novamente
flutter clean
flutter pub get
flutter run

# 4. Verificar logs em tempo real
# Terminal mostra logs automaticamente

# 5. Build release (para testar performance real)
flutter build apk --release
```

---

## 📸 Screenshots Importantes

### 1. Firebase DebugView
```
Firebase Console → Analytics → DebugView

Você verá:
├── Dispositivo: "Pixel 5 API 33" ou "SM-XXXXX"
├── Eventos em tempo real:
│   ├── screen_view (login_screen)
│   ├── login (method: email)
│   ├── screen_view (home_barber)
│   └── ai_message_sent (message_length: 45)
└── User Properties:
    └── user_type: barber
```

### 2. Terminal do Flutter (durante `flutter run`)
```
Launching lib\main.dart on Pixel 5 API 33 in debug mode...
Running Gradle task 'assembleDebug'...
✓ Built build\app\outputs\flutter-apk\app-debug.apk.

Flutter run key commands.
r Hot reload. 🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

💪 Running with sound null safety 💪

An Observatory debugger and profiler on Pixel 5 API 33 is available at: http://127.0.0.1:xxxxx/
The Flutter DevTools debugger and profiler on Pixel 5 API 33 is available at: http://127.0.0.1:xxxxx/
```

---

## 🎉 Status

✅ **Código pronto** - Todas as telas com Firebase Analytics integrado  
✅ **Web testado** - Pode testar no Chrome  
⏳ **Android pendente** - Aguardando teste no emulador/dispositivo  

---

## 📞 Próximo Passo

**AGORA:**
```powershell
# 1. Verificar se tem emulador/dispositivo
flutter devices

# 2. Se sim, rodar:
flutter run

# 3. Navegar pelo app e testar cada tela
# 4. Verificar eventos no Firebase Console → DebugView
```

**DEPOIS:**
- Testar no dispositivo físico (melhor performance)
- Verificar eventos agregados após 24h
- Adicionar mais eventos conforme necessário

---

**Criado em:** 2025-10-16  
**Versão:** 1.0.0  
**Status:** ⏳ Aguardando teste Android
