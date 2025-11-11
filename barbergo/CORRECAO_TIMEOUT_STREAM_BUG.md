# 🐛 Correção CRÍTICA: Timeout no Stream Contínuo (08/Nov/2025)

## ❌ Bug Descoberto

### Sintomas

1. ✅ App carrega perfil com sucesso (logs mostram `hasValue=true`)
2. ✅ Navega para `/home` corretamente
3. ✅ Upload de imagens funciona
4. ❌ **Após exatamente 20 segundos**, app redireciona para `/onboarding`
5. ❌ Usuário não consegue completar onboarding

### Logs do Problema

```
I/flutter: Profile: loading=false, hasValue=true, hasError=false
I/flutter: ✅ Setup completo. Redirecionando para Home
I/flutter: 📊 ImageUpload_Success: {folder: portfolio}
// ... 20 segundos depois ...
I/flutter: ⚠️ TIMEOUT: Firestore demorou mais de 20s para responder
I/flutter: 👤 Perfil incompleto. Redirecionando para Onboarding
```

## 🔍 Root Cause

### Código Problemático

**Arquivo:** `lib/src/features/profile/controllers/profile_controller.dart`

```dart
// ❌ ERRADO: Timeout no Stream CONTÍNUO
return profileStream.timeout(
  kProfileLoadTimeout,
  onTimeout: (sink) {
    debugPrint('⚠️ TIMEOUT: Firestore demorou mais de 20s...');
    sink.add(null);  // ❌ Sobrescreve perfil válido após 20s!
    sink.close();
  },
);
```

### Por que estava errado?

O método `.timeout()` no Dart aplica o timeout a **TODAS as emissões do Stream**, não apenas à primeira!

**Comportamento:**

1. **t=0s:** Firestore emite perfil (`ProfileEntity`) ✅
2. **t=0-20s:** Stream fica aguardando próxima atualização do Firestore
3. **t=20s:** `.timeout()` dispara porque não houve nova emissão
4. **t=20s:** Emite `null`, **sobrescrevendo o perfil válido** ❌
5. Router detecta `profileState.value == null` → Redireciona para onboarding

### Diagrama do Bug

```
Time    Event                           profileState.value
-------------------------------------------------------------
0s      Firestore emite perfil         ProfileEntity (válido)
0-20s   Stream aguardando atualização  ProfileEntity (válido)
20s     Timeout dispara                null (INVALIDA perfil!)
20s     Router verifica estado         null → Onboarding
```

## ✅ Solução Implementada

### Nova Lógica

**Timeout APENAS na primeira emissão, não no Stream contínuo**

```dart
// ✅ CORRETO: Timeout apenas para primeira carga
late StreamController<ProfileEntity?> controller;
bool hasEmittedFirst = false;

controller = StreamController<ProfileEntity?>(
  onListen: () {
    // Subscreve ao profileStream
    final subscription = profileStream.listen(
      (profile) {
        if (!hasEmittedFirst) {
          hasEmittedFirst = true;
        }
        if (!controller.isClosed) {
          controller.add(profile);  // ✅ Sempre emite dados válidos
        }
      },
      onError: (error, stackTrace) {
        debugPrint('❌ Erro no profileStream: $error');
        if (!controller.isClosed) {
          controller.add(null);
        }
      },
    );
    
    // Timeout APENAS para a primeira emissão
    if (!hasEmittedFirst) {
      Future.delayed(kProfileLoadTimeout, () {
        if (!hasEmittedFirst && !controller.isClosed) {
          debugPrint('⚠️ TIMEOUT: Primeira carga do perfil demorou mais de ${kProfileLoadTimeout.inSeconds}s');
          debugPrint('   Emitindo null para permitir navegação para onboarding');
          hasEmittedFirst = true;
          controller.add(null);
        }
      });
    }
    
    controller.onCancel = () {
      subscription.cancel();
    };
  },
);

return controller.stream;
```

### Como Funciona Agora

**Diagrama da Correção:**

```
Time    Event                           profileState.value
-------------------------------------------------------------
0s      Firestore emite perfil         ProfileEntity (válido)
0s      hasEmittedFirst = true         ProfileEntity (válido)
0-∞     Stream aguardando atualização  ProfileEntity (válido)
∞       Stream nunca mais dá timeout   ProfileEntity (válido)
```

**Caso: Perfil não existe (novo usuário):**

```
Time    Event                           profileState.value
-------------------------------------------------------------
0s      Firestore emite null           null (correto)
0s      hasEmittedFirst = true         null (esperado)
0s      Router redireciona             Onboarding (correto)
```

**Caso: Rede lenta:**

```
Time    Event                           profileState.value
-------------------------------------------------------------
0-20s   Aguardando Firestore           (loading)
20s     Timeout dispara                null (fallback correto)
20s     Router redireciona             Onboarding (permite uso)
21s     Firestore responde tarde       ProfileEntity (atualiza)
21s     Router redireciona             Home (corrige rota)
```

## 🎯 Resultado

### Antes (Bug)

- ❌ App funcionava por 20 segundos
- ❌ Depois redirecionava para onboarding
- ❌ Impossível completar cadastro
- ❌ Loop infinito de redireccionamentos

### Depois (Corrigido)

- ✅ Stream contínuo funciona indefinidamente
- ✅ Timeout apenas para primeira carga (rede lenta)
- ✅ Perfil permanece válido após carregamento
- ✅ Onboarding pode ser completado
- ✅ Navegação estável

## 📊 Logs Esperados Após Correção

### Usuário com Perfil Existente

```
I/flutter: Profile: loading=false, hasValue=true, hasError=false
I/flutter: ✅ Setup completo. Redirecionando para Home
// SEM MAIS TIMEOUT APÓS 20s
// Usuário permanece em /home indefinidamente
```

### Usuário Novo (Sem Perfil)

```
I/flutter: Profile: loading=false, hasValue=true, hasError=false
I/flutter: 👤 Perfil incompleto. Redirecionando para Onboarding
// Usuário pode completar onboarding SEM timeout
```

### Rede Lenta (Primeira Carga)

```
I/flutter: Profile: loading=true, hasValue=false, hasError=false
// ... 20 segundos ...
I/flutter: ⚠️ TIMEOUT: Primeira carga do perfil demorou mais de 20s
I/flutter:    Emitindo null para permitir navegação para onboarding
I/flutter: Profile: loading=false, hasValue=true, hasError=false (value=null)
I/flutter: 👤 Perfil incompleto. Redirecionando para Onboarding
// Usuário pode usar o app mesmo com rede lenta
```

## 🧪 Como Validar

### Teste 1: Perfil Existente

1. Login com conta existente
2. **Espere 30+ segundos na tela home**
3. **Esperado:** App permanece em `/home`, sem redirecionamentos

### Teste 2: Onboarding Completo

1. Novo usuário, complete onboarding
2. Preencha formulário
3. Upload 2 fotos do portfólio
4. **Esperado:** Consegue clicar em "Concluir" e salvar perfil

### Teste 3: Navegação Pós-Onboarding

1. Complete onboarding
2. Aguarde confirmação
3. **Esperado:** App navega para `/home` e permanece lá

## 📚 Arquivos Modificados

### profile_controller.dart

**Mudanças:**

- ❌ Removido `.timeout()` no Stream contínuo
- ✅ Adicionado `StreamController` customizado
- ✅ Flag `hasEmittedFirst` para controlar primeira emissão
- ✅ `Future.delayed` para timeout apenas inicial
- ✅ Subscrição permanece ativa indefinidamente

**Linhas afetadas:** ~40-65

## 🔧 Conceitos Técnicos

### Stream.timeout() vs Timeout na Primeira Emissão

**Stream.timeout():**

- Aplica timeout a **toda emissão**
- Útil para streams finitos ou com emissões regulares
- **PROBLEMA:** Streams do Firestore podem ficar silenciosos

**Timeout customizado:**

- Aplica apenas à **primeira emissão**
- Permite Stream permanecer ativo indefinidamente
- **SOLUÇÃO:** Firestore pode emitir quando houver mudanças

### Por que Firestore Streams Ficam Silenciosos?

Firestore `.snapshots()` emite apenas quando:

1. **Primeira subscrição** (imediato)
2. **Documento é criado/atualizado/deletado** (eventos)
3. **Conexão é restabelecida após offline** (recuperação)

**Entre eventos, o Stream fica "silencioso" aguardando mudanças!**

Isso é esperado e correto - não deveria causar timeout.

## 🚀 Próximos Passos

1. ✅ Build e deploy da correção
2. ⏳ Testar onboarding completo no dispositivo
3. ⏳ Validar navegação estável após 30+ segundos
4. ⏳ Confirmar perfil é salvo com sucesso
5. ⏳ Verificar home screen funciona sem loops

---

**Data:** 08/Nov/2025  
**Autor:** GitHub Copilot  
**Criticidade:** 🔴 CRÍTICA - App inutilizável sem esta correção  
**Status:** ✅ Correção aplicada, aguardando validação em device
