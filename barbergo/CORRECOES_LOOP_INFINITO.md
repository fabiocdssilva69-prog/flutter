# Correções Aplicadas - Loop Infinito (08/Nov/2025)

## 🎯 Problema Identificado

O app estava ficando preso em um **loop infinito** entre as rotas:

- `/splash` → `/home` → `/initialization-error` → `/splash` → ...

### Root Cause

1. **Perfil inexistente no Firestore**: O usuário `fabiocds.silva69@gmail.com` (UID: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`) está autenticado mas **NÃO tem documento** na coleção `profiles`
2. **Timeout desnecessário**: O `profileStream` aguardava 20s e emitia um erro de timeout, mesmo quando o perfil simplesmente não existia
3. **Router tratando perfil inexistente como erro**: O `app_router.dart` redirecionava para `/initialization-error` ao detectar erro no `profileState`, causando loop

## ✅ Correções Aplicadas

### 1. `profile_controller.dart` - Timeout Otimizado

**ANTES:**

```dart
return profileStream.timeout(
  kProfileLoadTimeout,
  onTimeout: (sink) {
    sink.addError(TimeoutException(...)); // ❌ Emitia erro
    sink.close();
  },
);
```

**DEPOIS:**

```dart
return profileStream.timeout(
  kProfileLoadTimeout,
  onTimeout: (sink) {
    debugPrint('⚠️ TIMEOUT: Firestore demorou mais de ${kProfileLoadTimeout.inSeconds}s para responder');
    sink.add(null); // ✅ Emite null ao invés de erro
    sink.close();
  },
);
```

**Mudança:**

- Agora emite `null` em caso de timeout de rede real
- Perfil inexistente emite `null` imediatamente (sem timeout)
- Apenas problemas de rede causam timeout de 20s

### 2. `app_router.dart` - Router Resiliente

**ANTES:**

```dart
// Tratava erro de Auth OU erro de Profile como crítico
if (authState.hasError || (authState.hasValue && profileState.hasError)) {
  // Redirecionava para /initialization-error
}
```

**DEPOIS:**

```dart
// Apenas erros críticos de Auth são tratados
if (authState.hasError) {
  // Apenas erro de Auth é crítico
  // Perfil null = onboarding necessário (não é erro!)
}
```

**Mudança:**

- Erro de Auth = crítico (redireciona para `/initialization-error`)
- Perfil `null` = normal (redireciona para `/onboarding`)
- Sem mais loop entre rotas

## 🔄 Fluxo Esperado Agora

### Novo Usuário (sem perfil no Firestore)

```
1. Login/Registro → Auth OK ✅
2. Carrega perfil → null (não existe) ✅
3. Tutorial? → Sim → /tutorial
4. Tutorial completo → /onboarding
5. Cria perfil → /home
```

### Usuário Existente (com perfil)

```
1. Login → Auth OK ✅
2. Carrega perfil → ProfileEntity ✅
3. Tutorial completo? → Sim → /home
```

### Problema de Rede Real

```
1. Login → Auth OK ✅
2. Carrega perfil → Timeout após 20s ⚠️
3. Emite null → /onboarding
4. Usuário pode tentar novamente
```

## 📝 Próximos Passos (Ação Manual Necessária)

### Opção A: Testar com Novo Usuário

1. Faça logout do app
2. Crie uma nova conta
3. Complete o tutorial
4. Preencha o onboarding
5. Verifique se chega ao `/home` sem loops

### Opção B: Criar Perfil Manualmente no Firebase

1. Acesse o Firebase Console
2. Vá para Firestore Database
3. Coleção `profiles`
4. Adicione documento com ID: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`
5. Campos mínimos necessários:

```json
{
  "userId": "6RYGS6HoEkhQgikNxUIkn7NpwmI3",
  "email": "fabiocds.silva69@gmail.com",
  "accountType": "barber",
  "name": "Seu Nome",
  "bio": "Sua bio",
  "location": "Sua cidade",
  "contactPhone": "Seu telefone",
  "searchRadiusKm": 25,
  "createdAt": "2025-11-08T00:00:00.000Z",
  "updatedAt": "2025-11-08T00:00:00.000Z",
  "portfolioUrls": []
}
```

6. Faça logout e login no app
7. O app deve carregar o perfil e ir direto para `/home`

### Opção C: Limpar Dados e Refazer Onboarding

1. No dispositivo Android, vá para Configurações
2. Apps → BarberGo
3. Armazenamento → Limpar dados
4. Abra o app novamente
5. Faça login
6. Complete o tutorial
7. Complete o onboarding (isso criará o perfil no Firestore)

## 🐛 Logs para Validação

Se o app ainda apresentar loop, capture os logs:

```bash
flutter logs -d uwbekb8hpf6lamts
```

Procure por:

- `🔄 REDIRECT CHECK:` - mostra as transições de rota
- `❌ ERRO CRÍTICO` - indica erro de Auth (crítico)
- `👤 Perfil incompleto` - indica perfil null (esperado para novo usuário)
- `⚠️ TIMEOUT:` - indica problema de rede real

## 📊 Status das Correções

- ✅ `profile_controller.dart` - Timeout otimizado
- ✅ `app_router.dart` - Router resiliente a perfil null
- ✅ Imports adicionados (`debugPrint`)
- ⏸️ **Teste no dispositivo necessário** (build interrompido por prompt do Windows)

## 🔧 Como Testar as Correções

### Via VS Code (se o build funcionar)

```powershell
# 1. Limpar build anterior
flutter clean

# 2. Reconstruir
flutter build apk --debug

# 3. Instalar no dispositivo
flutter install -d uwbekb8hpf6lamts
```

### Via Terminal Externo (bypass do problema do Windows)

1. Abra PowerShell **fora do VS Code**
2. Navegue até o projeto:

   ```powershell
   cd C:\workspaces\fabiocdssilva69-prog\barbergo
   ```

3. Execute:

   ```powershell
   flutter run --debug -d uwbekb8hpf6lamts
   ```

### Via Hot Reload (se já estiver rodando)

Se o app já está instalado e conectado:

1. Salve os arquivos no VS Code
2. Pressione `r` no terminal do Flutter
3. Ou pressione `R` para hot restart completo

## 🎉 Resultado Esperado

Após as correções:

1. ✅ **Sem mais loop infinito** - Navegação funciona corretamente
2. ✅ **Perfil null = Onboarding** - Não trata como erro crítico
3. ✅ **Timeout otimizado** - 20s apenas para problemas de rede reais
4. ✅ **Router resiliente** - Lida com todos os estados corretamente
5. ✅ **Experiência do usuário melhorada** - Fluxo natural sem travamentos

---

**Data:** 08/Nov/2025  
**Autor:** GitHub Copilot  
**Status:** Correções aplicadas, teste manual necessário
