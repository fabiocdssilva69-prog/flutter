# INSTRUÇÕES CRÍTICAS - INSTALAÇÃO COM CORREÇÃO

## 🔴 PROBLEMA IDENTIFICADO

O app instalado no celular **NÃO contém a correção do TimestampHook**.

- **App instalado**: 25/10/2025 17:37 (ANTES da correção)
- **Correção aplicada**: 25/10/2025 17:46 (DEPOIS)
- **Mapper regenerado**: 25/10/2025 17:46 ✅

## ✅ SOLUÇÃO

### Passo 1: Desinstalar App Antigo

**No celular:**
1. Configurações → Apps → Gerenciar apps
2. Procure "barbergo_app" ou "BarberGO"
3. Toque em **Desinstalar**
4. Confirme a desinstalação

### Passo 2: Limpar Cache de Build (Opcional mas Recomendado)

**No PC:**
```powershell
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Passo 3: Reinstalar com Correção

**No PC:**
```powershell
flutter run -d uwbekb8hpf6lamts
```

**IMPORTANTE:**
- Mantenha o celular **desbloqueado** durante instalação
- Aguarde mensagem "Flutter run key commands" aparecer
- **NÃO feche o app** durante a instalação

### Passo 4: Testar Login

1. Abra o app no celular
2. Vá para tela de login
3. Digite: `fabiocds.silva69@gmail.com`
4. Digite a senha
5. Toque em "Entrar"

**Se o erro aparecer:**
- Tire screenshot
- Copie texto do erro
- Informe imediatamente

**Se o login funcionar:**
- ✅ Correção validada!
- Prossiga com testes normais

## 📊 O QUE FOI CORRIGIDO

O `TimestampHook` agora detecta e converte corretamente:
- ✅ `Timestamp` do Firestore → `DateTime`
- ✅ `DateTime` direto → `DateTime` (sem erro)
- ✅ `String` (ISO 8601) → `DateTime`
- ✅ `num` (milliseconds) → `DateTime`
- ✅ `Map` com `_seconds` (Web) → `DateTime`

## 🚨 SE O ERRO PERSISTIR

Execute este comando e envie o resultado:
```powershell
.\capturar_erro_login.ps1
```

Enquanto isso:
1. Reproduza o erro no celular
2. Aguarde tela de erro aparecer
3. Pressione `Ctrl+C` no terminal
4. Envie o arquivo `logs_captura_erro_*.txt`

---

**Status Atual:** Aguardando desinstalação manual e reinstalação com correção.
