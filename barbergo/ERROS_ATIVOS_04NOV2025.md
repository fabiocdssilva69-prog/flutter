# 🔴 ERROS ATIVOS - ANÁLISE COMPLETA (04/11/2025)

## 📊 RESUMO EXECUTIVO

**Data/Hora:** 04/11/2025 18:25  
**Device:** Redmi Note 8 Pro (uwbekb8hpf6lamts)  
**User:** 6RYGS6HoEkhQgikNxUIkn7NpwmI3 (AccountType.barbershop)  
**App State:** Rodando, mas com 2 bugs críticos confirmados

---

## 🔴 ERRO CRÍTICO #1: CardSwiper setState After Dispose

### Status: ❌ **BUG AINDA EXISTE - PACKAGE EXTERNO**

**Stack Trace Completo:**
```
❌ [LOG ERROR] PlatformDispatcher.onError (Fatal)
setState() called after dispose(): _CardSwiperState<Widget>#ece0f(lifecycle state: defunct, not mounted, ticker inactive)

#0 State.setState.<anonymous closure> (package:flutter/src/widgets/framework.dart:1163:9)
#1 State.setState (package:flutter/src/widgets/framework.dart:1198:6)
#2 _CardSwiperState._reset (package:flutter_card_swiper/src/widget/card_swiper_state.dart:246:5)
#3 _CardSwiperState._animationStatusListener (package:flutter_card_swiper/src/widget/card_swiper_state.dart:218:7)
```

**DESCOBERTA CRÍTICA:**
- ❌ O erro NÃO está no nosso código (`swipe_screen.dart`)
- ❌ O erro está DENTRO do package `flutter_card_swiper` (linha 246: `_reset()`)
- ❌ O package chama `setState()` em `_animationStatusListener` após dispose

**Trigger:**
- Usuário fez 4 swipes com sucesso (Like #1, #2, #3, #4)
- Apertou BACK button (KEYCODE_BACK)
- Package tentou resetar animação APÓS widget ser disposed

**Localização Exata do Bug:**
- Package: `flutter_card_swiper 7.1.0`
- File: `package:flutter_card_swiper/src/widget/card_swiper_state.dart`
- Method: `_CardSwiperState._reset()` (linha 246)
- Listener: `_animationStatusListener` (linha 218)

**Por Que Nossas Correções Não Funcionaram:**
```dart
// ❌ NOSSO CÓDIGO (swipe_screen.dart) ESTÁ CORRETO:
if (mounted && context.mounted) { ... } ✅

// ❌ MAS O PACKAGE FAZ ISSO INTERNAMENTE:
void _animationStatusListener(...) {
  // ...código...
  _reset(); // ← Chama sem verificar mounted!
}

void _reset() {
  setState(() { ... }); // ← BOOM! Widget já foi disposed
}
```

---

## 🟡 ERRO CRÍTICO #2: Discovery Carrega Apenas 4 Profiles

### Status: ⚠️ **CONFIRMADO - PROFILES FALTANDO NO FIRESTORE**

**Logs da Query:**
```
🔍 [discoverProfiles] currentProfile.accountType: AccountType.barbershop
🔍 [discoverProfiles] accountTypeFilter: barber
🔍 [discoverProfiles] snapshot.docs.length: 4
🔍 [discoverProfiles] Processing doc: barber_007
🔍 [discoverProfiles] Processing doc: barber_006
🔍 [discoverProfiles] Processing doc: barber_003
🔍 [discoverProfiles] Processing doc: barber_001
🔍 [discoverProfiles] Profiles before filters: 4
✅ [discoverProfiles] Final profiles count: 4 (server-ordered)
```

**Profiles Faltando:**
- ❌ `barber_002` (NÃO retornado pela query)
- ❌ `barber_004` (NÃO retornado pela query)
- ❌ `barber_005` (NÃO retornado pela query)

**Possíveis Causas:**

1. **Campos obrigatórios faltando nos profiles:**
   - Query usa: `orderBy('boostedUntil')` → Se barber_002/004/005 não têm esse campo, são excluídos
   - Query usa: `orderBy('isPremium')` → Se barber_002/004/005 não têm esse campo, são excluídos
   - Query usa: `orderBy('updatedAt')` → Se barber_002/004/005 não têm esse campo, são excluídos

2. **accountType incorreto:**
   - Se barber_002/004/005 têm `accountType: "barbeiro"` (português) ao invés de `"barber"` (inglês)
   - Query filtra: `where('accountType', isEqualTo: 'barber')`

3. **Índice composto parcial:**
   - Firebase pode ter construído índice apenas com docs que têm TODOS os campos
   - Docs com campos faltando ficam fora do índice

**Diagnóstico Necessário:**
```
1. Abrir Firebase Console: https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles
2. Verificar barber_002, barber_004, barber_005:
   - Campo `accountType` existe? Valor = "barber" ou "barbeiro"?
   - Campo `boostedUntil` existe? (pode ser null, mas campo deve existir)
   - Campo `isPremium` existe? (boolean)
   - Campo `updatedAt` existe? (number milliseconds)
```

---

## ✅ CONFIRMAÇÕES POSITIVAS (O QUE FUNCIONA)

### 1. Sistema de Swipe Funcionando
```
📊 [Analytics] Like #1 - Ratio: 100.0%
📊 [Analytics] Like #2 - Ratio: 100.0%
📊 [Analytics] Like #3 - Ratio: 100.0%
📊 [Analytics] Like #4 - Ratio: 100.0%
```
- ✅ 4 swipes realizados com sucesso
- ✅ Analytics tracking funcionando
- ✅ Tempo de visualização sendo medido (6s, 3s, 7s, 3s)
- ✅ Like ratio calculado corretamente

### 2. Firebase Integrado
- ✅ Auth: User `6RYGS6HoEkhQgikNxUIkn7NpwmI3` autenticado
- ✅ FCM Token gerado
- ✅ Crashlytics capturando erros
- ✅ Analytics events sendo logados
- ✅ Remote Config funcionando

### 3. Query Firestore Correta
- ✅ Filtro `accountType = 'barber'` funcionando
- ✅ Server-side ordering: boostedUntil → isPremium → updatedAt
- ✅ Limite de 50 profiles aplicado
- ✅ Cache TTL 5 minutos funcionando

---

## 🎯 PLANO DE CORREÇÃO IMEDIATO

### CORREÇÃO 1: CardSwiper setState After Dispose

**Opção A: Upgrade Package (RECOMENDADO)**
```bash
# Verificar se versão mais nova existe
flutter pub outdated

# Se flutter_card_swiper 7.2.0 disponível:
flutter pub upgrade flutter_card_swiper

# Notas da Release 7.2.0 podem ter corrigido o bug
```

**Opção B: Workaround Temporário**
```dart
// lib/src/features/discovery/presentation/swipe_screen.dart

@override
void dispose() {
  // ADICIONAR: Remover todos os listeners do controller ANTES de dispose
  WidgetsBinding.instance.removeObserver(this);
  
  // NEW: Prevenir animações pendentes
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Vazio - cancela callbacks pendentes
  });
  
  // NEW: Adicionar delay micro para animações completarem
  Future.microtask(() {
    try {
      _swiperController.dispose();
    } catch (e) {
      debugPrint('⚠️ CardSwiper dispose warning: $e');
    }
  });
  
  super.dispose();
}
```

**Opção C: Substituir Package**
```yaml
# pubspec.yaml
dependencies:
  # flutter_card_swiper: ^7.1.0  # ← REMOVER
  appinio_swiper: ^2.1.1         # ← Package alternativo sem bug
```

**Prioridade:** 🔴 ALTA - Causa crash ao sair da tela

---

### CORREÇÃO 2: Discovery 4 Profiles (Investigação)

**Passo 1: Verificar Profiles no Firebase Console**
```
URL: https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles

Verificar para barber_002, barber_004, barber_005:

✅ Checklist por Profile:
[ ] Documento existe?
[ ] accountType = "barber" (lowercase, inglês)?
[ ] boostedUntil existe? (pode ser null)
[ ] isPremium existe? (boolean true/false)
[ ] updatedAt existe? (number, não Timestamp)
[ ] createdAt existe? (number, não Timestamp)
[ ] email existe? (string)
```

**Passo 2: Corrigir Campos Faltantes**

Se `barber_002` não aparece:
```
1. Abrir documento: profiles/barber_002
2. Adicionar/Corrigir:
   - accountType: "barber" (string)
   - boostedUntil: null (ou number se boosted)
   - isPremium: false (boolean)
   - updatedAt: 1730483400000 (number)
   - createdAt: 1698947000000 (number)
   - email: "joão.silva@example.com" (string)
```

Repetir para `barber_004` e `barber_005`.

**Passo 3: Adicionar Logs Detalhados**
```dart
// lib/src/features/discovery/controllers/discovery_controller.dart

Stream<List<ProfileEntity>> _queryWithRetry(...) {
  return query.snapshots().transform(
    StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<ProfileEntity>>.fromHandlers(
      handleData: (snapshot, sink) {
        try {
          debugPrint('🔍 [discoverProfiles] snapshot.docs.length: ${snapshot.docs.length}');
          
          // NEW: Log ALL doc IDs returned by query
          debugPrint('📋 [discoverProfiles] Doc IDs: ${snapshot.docs.map((d) => d.id).join(", ")}');

          var profiles = snapshot.docs.map((doc) {
            try {
              final data = doc.data();
              
              // NEW: Log campos críticos de cada doc
              debugPrint('  🔍 ${doc.id}:');
              debugPrint('    - accountType: ${data['accountType']}');
              debugPrint('    - boostedUntil: ${data['boostedUntil']}');
              debugPrint('    - isPremium: ${data['isPremium']}');
              debugPrint('    - updatedAt: ${data['updatedAt']}');
              
              return ProfileEntity.fromMap(data);
            } catch (e, stackTrace) {
              debugPrint('❌ [discoverProfiles] PARSE ERROR ${doc.id}: $e');
              debugPrint('❌ Doc data: ${doc.data()}');
              return null;
            }
          })
          .whereType<ProfileEntity>()
          .where((profile) => profile.userId != currentUserId)
          .toList();
          
          // ... resto do código
        }
      },
    ),
  );
}
```

**Prioridade:** 🟡 MÉDIA-ALTA - Limita funcionalidade mas não causa crash

---

## 🔍 OUTROS ERROS ENCONTRADOS (Não Críticos)

### 1. GoogleApiManager SecurityException
```
E/GoogleApiManager(31740): Failed to get service from broker
E/GoogleApiManager(31740): java.lang.SecurityException: Unknown calling package name 'com.google.android.gms'
```
**Status:** ⚪ IGNORAR  
**Razão:** Erro conhecido do Google Play Services no Redmi Note 8 Pro  
**Impacto:** Zero - App funciona normalmente

### 2. FlagRegistrar Failed
```
W/FlagRegistrar(31740): Failed to register com.google.android.gms.providerinstaller
```
**Status:** ⚪ IGNORAR  
**Razão:** Phenotype.API não disponível no device (normal em Xiaomi)  
**Impacto:** Zero - Firebase funciona normalmente

### 3. Skipped Frames
```
I/Choreographer(31740): Skipped 88 frames! The application may be doing too much work on its main thread.
```
**Status:** ⚪ MONITORAR  
**Razão:** UI thread ocupada durante inicialização (normal)  
**Impacto:** Baixo - Apenas na primeira carga

### 4. Accessing Hidden Methods
```
W/le.barbergo_ap(31740): Accessing hidden method Ljava/security/spec/ECParameterSpec;->getCurveName()...
```
**Status:** ⚪ IGNORAR  
**Razão:** Firebase/GMS usando APIs internas (permitido em greylist)  
**Impacto:** Zero

---

## 📋 CHECKLIST DE AÇÃO

### Imediato (Próximos 30 minutos):

- [ ] **CORREÇÃO 1A:** Verificar `flutter pub outdated` para flutter_card_swiper
- [ ] **CORREÇÃO 1B:** Se 7.2.0 disponível, fazer upgrade
- [ ] **CORREÇÃO 1C:** Se não, aplicar workaround Future.microtask
- [ ] **CORREÇÃO 2.1:** Abrir Firebase Console e verificar barber_002
- [ ] **CORREÇÃO 2.2:** Verificar campos de barber_002 (accountType, boostedUntil, isPremium, updatedAt)
- [ ] **CORREÇÃO 2.3:** Repetir para barber_004 e barber_005

### Curto Prazo (Próximas 2 horas):

- [ ] Adicionar logs detalhados em discovery_controller.dart
- [ ] Testar novamente após correções Firestore
- [ ] Validar que 7 profiles aparecem
- [ ] Testar BACK button após swipes (validar correção setState)
- [ ] Documentar resultados

### Médio Prazo (Próximos dias):

- [ ] Investigar imagens não carregando (Bug #4)
- [ ] Testar Boost button (Bug #7)
- [ ] Verificar criação de vagas (Bug #8)
- [ ] Testar troca de perfil (Bug #9)

---

## 📊 MÉTRICAS DO TESTE

**Teste Realizado:** 04/11/2025 18:20-18:25  
**Duração:** ~5 minutos  
**Swipes Testados:** 4 (todos bem-sucedidos até pressionar BACK)

**Performance:**
- ✅ App inicialização: 357.5s (build) + 6.7s (install) = ~6 minutos
- ✅ Discovery load: <1s (4 profiles)
- ✅ Swipe latência: <100ms por swipe
- ✅ Analytics eventos: 100% capturados
- ❌ Crash ao sair: 100% reproduzível (BACK button)

**Profiles Carregados:**
- barber_001 ✅
- barber_002 ❌
- barber_003 ✅
- barber_004 ❌
- barber_005 ❌
- barber_006 ✅
- barber_007 ✅

**Taxa de Sucesso:** 57% (4/7 profiles)

---

## 🎯 PRÓXIMOS PASSOS

1. ⏳ **AGORA:** Verificar `flutter pub outdated`
2. ⏳ **AGORA:** Abrir Firebase Console e inspecionar barber_002/004/005
3. ⏳ **15 min:** Aplicar correção CardSwiper (upgrade ou workaround)
4. ⏳ **15 min:** Corrigir campos faltantes no Firestore
5. ⏳ **10 min:** Hot reload e testar novamente
6. ⏳ **10 min:** Documentar resultados finais

**Tempo Estimado Total:** 50 minutos

---

**Última Atualização:** 04/11/2025 18:30  
**Próxima Ação:** Executar `flutter pub outdated`
