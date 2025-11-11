# 🐛 ANÁLISE COMPLETA - BUGS REAIS DO APP

## 📊 STATUS GERAL
**Data:** 27/10/2025 18:00  
**Build:** Sprint 28 - Fase 0  
**Situação:** ⚠️ APP BUGADO - 7 BUGS CRÍTICOS CONFIRMADOS

---

## 🔴 ERROS CRÍTICOS (P0) - BLOQUEADORES ABSOLUTOS

### ✅ BUG 1: Login Unmounted Error (HOTFIX APLICADO)
**Status:** ✅ CORRIGIDO (aguardando validação no device)

**Sintoma:**
```
❌ Bad state: Using ref when unmounted
❌ App crashava após login bem-sucedido
```

**Correção Aplicada:**
- Arquivo: `lib/src/features/auth/screens/login_screen.dart`
- Mudança: `ref.listen` ao invés de `await ref.read()` após async
- Resultado: Login + navegação sem crash

---

### ✅ BUG 2: FCM Token Loop (HOTFIX APLICADO)
**Status:** ✅ CORRIGIDO

**Sintoma:**
```
⚠️ Token FCM atualizado repetidamente no Firestore
⚠️ Drenagem de bateria + custos Firestore
```

**Correção Aplicada:**
- Arquivo: `lib/src/core/services/notification_service.dart`
- Mudança: Verificação de token antes de atualizar
- Resultado: Token atualiza só quando muda

---

### ✅ BUG 3: MapperException Timestamp (RESOLVIDO)
**Status:** ✅ CORRIGIDO PERMANENTEMENTE (Sprint 27)

**Sintoma:**
```
❌ MapperException: Invalid value for field 'createdAt'
```

**Correção:**
- Arquivo: `lib/src/core/serialization/timestamp_hook.dart`
- Solução: Hook detecta e converte todos tipos de timestamp

---

## 🟡 ERROS DE ALTA PRIORIDADE (P1) - BLOQUEADORES PARCIAIS

### ❌ BUG 4: Imagens de Perfil Não Carregam
**Status:** ❌ NÃO CORRIGIDO

**Evidências:**
```dart
// seed_screen.dart cria profiles com avatarUrl válidas:
'avatarUrl': 'https://i.pravatar.cc/400?img=12',
'avatarUrl': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
```

**Possíveis Causas:**
1. **Firebase Storage 403 Errors** (confirmado em logs)
2. **Cache Firestore** com dados antigos (Profiles maiúsculo)
3. **URLs quebradas** ou timeout na rede

**Locais Afetados:**
- `lib/src/features/discovery/presentation/widgets/profile_card.dart`
- `lib/src/features/profile/screens/profile_screen.dart`  
- `UserAvatar` widget em múltiplos locais

**Investigação Necessária:**
1. Verificar logs console para erros de imagem
2. Testar URLs manualmente no navegador
3. Verificar Firebase Storage Rules
4. Desinstalar app para limpar cache (Profiles → profiles)

---

### ✅ BUG 5: CardSwiper setState After Dispose
**Status:** ✅ CORRIGIDO (04/11/2025 - Aguardando teste no device)

**Sintoma:**
```
⚠️ setState() called after dispose(): _CardSwiperState
⚠️ Memory leak warning
```

**Arquivo Corrigido:**
- `lib/src/features/discovery/presentation/swipe_screen.dart`

**Correções Aplicadas:**

1. ✅ **addPostFrameCallback com mounted check (linha 167):**
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (mounted && context.mounted) { // ✅ Verificação dupla
    _preloadNextImages(context, profiles, index);
  }
});
```

2. ✅ **dispose() com try-catch (linha 82):**
```dart
try {
  _swiperController.dispose();
} catch (e) {
  debugPrint('⚠️ CardSwiper dispose warning: $e');
}
```

3. ✅ **onSwipe com múltiplos mounted checks (linhas 248, 267, 284, 303, 324):**
```dart
if (!mounted) return true; // Early exit principal
// ... código async ...
if (!mounted) return true; // Após Future.delayed
// ... mais código async ...
if (matchQuery.docs.isNotEmpty && mounted) { ... }
else if (mounted) { ... }
```

**Resultado Esperado:**
- ✅ Elimina setState após dispose
- ✅ Previne memory leaks
- ✅ Operações assíncronas seguras

**Prioridade:** ✅ RESOLVIDO - Aguardando teste no Redmi Note 8 Pro

---

### ❌ BUG 6: Discovery Carrega Apenas 4 Profiles
**Status:** ❌ NÃO CORRIGIDO

**Sintoma:**
```
⚠️ Tela Discovery mostra apenas 4 profiles
⚠️ Esperado: 7+ profiles (barber_001 até barber_007)
⚠️ Real: Apenas barber_001, 003, 006, 007 aparecem
```

**Arquivo:**
- `lib/src/features/discovery/controllers/discovery_controller.dart`

**Query Atual:**
```dart
.orderBy('boostedUntil', descending: true) // Boosted primeiro
.orderBy('isPremium', descending: true)    // Premium depois
.orderBy('updatedAt', descending: true)    // Recentes último
```

**Possíveis Causas:**
1. **Filtros excessivos** removendo profiles válidos
2. **Firebase Composite Index faltando** (confirmado em logs)
3. **Profiles com campos faltantes** (email, boostedUntil, etc)
4. **Cache Firestore** com dados antigos

**Investigação Necessária:**
1. Verificar Firebase Console → Indexes
2. Confirmar se todos 10 profiles têm campos obrigatórios
3. Testar query manualmente no Firebase Console
4. Adicionar logs detalhados em discovery_controller

**Prioridade:** ALTA - Impede testes completos

---

## 🟢 ERROS MÉDIOS (P2) - FUNCIONALIDADES QUEBRADAS

### ❌ BUG 7: Boost Button Quebrada
**Status:** ⚠️ CÓDIGO EXISTE MAS NÃO TESTADO

**Arquivos:**
- `lib/src/features/discovery/presentation/widgets/boost_button.dart`
- `lib/src/features/discovery/controllers/boost_controller.dart`
- `lib/src/features/discovery/presentation/boost_screen.dart`

**Código Parece Correto:**
```dart
// BoostButton usa StreamBuilder para watchUserProfile()
// boost_controller tem activateBoost() implementado
// Profile tem isBoosted e canActivateBoost getters
```

**Possíveis Problemas:**
1. **boost_screen.dart não encontrada** nos resultados grep
2. **Navigator push** pode estar indo para tela inexistente
3. **watchUserProfile()** pode não estar retornando dados
4. **Stripe integration** pode estar quebrada (compra de boosts)

**Investigação Necessária:**
1. Buscar `boost_screen.dart` no projeto
2. Testar navegação do BoostButton
3. Verificar logs ao tentar ativar boost
4. Validar Stripe endpoints

**Prioridade:** MÉDIA - Feature premium não crítica

---

### ❌ BUG 8: Sistema Criação de Vagas Quebrado
**Status:** ❌ NÃO INVESTIGADO

**Sintoma:**
```
❌ Usuário reportou que não consegue criar vagas
```

**Investigação Pendente:**
1. Localizar formulário de criação de vagas
2. Testar fluxo completo
3. Verificar validações e campos obrigatórios
4. Confirmar integração Firebase

**Prioridade:** MÉDIA - Bloqueia fluxo barbearia

---

### ❌ BUG 9: Troca Barbeiro ↔ Barbearia Não Funciona
**Status:** ❌ NÃO INVESTIGADO

**Sintoma:**
```
❌ Usuário não consegue alternar entre perfis barbeiro e barbearia
```

**Investigação Pendente:**
1. Localizar código de alternância de perfis
2. Verificar estado Riverpod relacionado
3. Testar navegação e persistência
4. Validar autenticação

**Prioridade:** MÉDIA - Afeta usabilidade

---

## ⚪ PROBLEMAS CONHECIDOS (P3) - NÃO BLOQUEANTES

### ⚠️ ISSUE 10: Cache Firestore com "Profiles" Maiúsculo
**Status:** ⚠️ REQUER AÇÃO MANUAL

**Causa Raiz:**
- Firebase SDK mantém cache local persistente
- Cache antigo tem `Profiles` (maiúsculo)
- Todo código atual usa `profiles` (minúsculo)

**Solução:**
1. Desinstalar app completamente do celular
2. Ou: Configurações → Apps → BarberGO → Limpar dados
3. Reinstalar: `flutter run -d uwbekb8hpf6lamts`

**Logs Identificados:**
```
W/Firestore: Listen for Query(target=Query(Profiles/6RYGS6HoE...
             PERMISSION_DENIED: Missing or insufficient permissions
```

**Prevenção Futura:**
```dart
// main.dart - Desabilitar cache
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: false,
);
```

**Prioridade:** BAIXA - Workaround disponível

---

## 📊 RESUMO EXECUTIVO

### Por Prioridade:
| Prioridade | Resolvidos | Pendentes | Total |
|-----------|-----------|-----------|-------|
| **P0 (Crítico)** | 3 ✅ | 0 ❌ | 3 |
| **P1 (Alto)** | 1 ✅ | 2 ❌ | 3 |
| **P2 (Médio)** | 0 ✅ | 3 ❌ | 3 |
| **P3 (Baixo)** | 0 ✅ | 1 ⚠️ | 1 |
| **TOTAL** | **4** | **6** | **10** |

### Taxa de Resolução:
- **Resolvidos:** 40% (4/10) ⬆️
- **Pendentes:** 60% (6/10)
- **Status:** 🔄 **APP EM CORREÇÃO - TESTE EM ANDAMENTO**

---

## 🎯 PLANO DE AÇÃO IMEDIATO

### FASE 1: CORREÇÃO P1 - PRÓXIMAS 2 HORAS

#### ✅ Correção 1: CardSwiper Lifecycle (30 minutos)

**Arquivo:** `lib/src/features/discovery/presentation/swipe_screen.dart`

**Mudanças Necessárias:**

1. **Correção no cardBuilder (linha ~163):**
```dart
// ANTES:
WidgetsBinding.instance.addPostFrameCallback((_) {
  _preloadNextImages(context, profiles, index);
});

// DEPOIS:
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (mounted && context.mounted) {
    _preloadNextImages(context, profiles, index);
  }
});
```

2. **Consolidar onSwipe callback:**
```dart
// ANTES: Múltiplas verificações espalhadas
if (mounted) { await ... }
// Check again later
if (!mounted) return true;

// DEPOIS: Early exits no início
onSwipe: (previousIndex, currentIndex, direction) async {
  if (!mounted) return true; // ✅ Early exit principal
  
  // resto do código...
}
```

3. **Dispose safety:**
```dart
@override
void dispose() {
  WidgetsBinding.instance.removeObserver(this);
  
  try {
    _swiperController.dispose();
  } catch (e) {
    debugPrint('⚠️ CardSwiper dispose warning: $e');
  }
  
  super.dispose();
}
```

---

#### 🔍 Correção 2: Investigação Imagens (45 minutos)

**Checklist de Diagnóstico:**

1. **Verificar Console Logs:**
```powershell
flutter logs -d uwbekb8hpf6lamts | Select-String "avatarUrl|NetworkImage|403|PERMISSION_DENIED"
```

2. **Testar URLs Manualmente:**
- Abrir `https://i.pravatar.cc/400?img=12` no navegador
- Confirmar se carrega corretamente

3. **Verificar Firebase Storage Rules:**
```javascript
// storage.rules - Deve permitir leitura pública
match /{allPaths=**} {
  allow read;
  allow write: if request.auth != null;
}
```

4. **Desinstalar App (limpar cache):**
```powershell
# No celular:
# Configurações → Apps → BarberGO → Desinstalar
flutter run -d uwbekb8hpf6lamts
```

---

#### 🔍 Correção 3: Discovery 4 Profiles (45 minutos)

**Checklist de Diagnóstico:**

1. **Verificar Composite Indexes no Firebase Console:**
- Ir em: <https://console.firebase.google.com/project/barbergo-38c21/firestore/indexes>
- Confirmar index: `profiles → boostedUntil DESC → isPremium DESC → updatedAt DESC`
- Status: Deve estar "Enabled" (não "Building")

2. **Verificar Profiles no Firestore:**
- Abrir Firebase Console → Firestore Database
- Collection: `profiles` (minúsculo)
- Confirmar 10 documentos existem:
  * barber_001, barber_002, ..., barber_007
  * barbershop_001, barbershop_002, barbershop_003
- Verificar campos obrigatórios em cada:
  * ✅ email (string)
  * ✅ boostedUntil (number ou null)
  * ✅ isPremium (boolean)
  * ✅ updatedAt (number)

3. **Adicionar Logs Detalhados:**
```dart
// discovery_controller.dart
Future<List<ProfileEntity>> discoverProfiles() async {
  final query = _service.db
      .collection(ProfileRepository.profilesPath)
      .orderBy('boostedUntil', descending: true)
      .orderBy('isPremium', descending: true)
      .orderBy('updatedAt', descending: true);
  
  final snapshot = await query.get();
  debugPrint('📊 [Discovery] Total docs returned: ${snapshot.docs.length}');
  
  for (final doc in snapshot.docs) {
    debugPrint('  - ${doc.id}: ${doc.data()['name']}');
  }
  
  // ... resto do código
}
```

4. **Testar Query Manualmente no Firebase Console:**
- Firebase Console → Firestore Database
- Query Builder:
  * Collection: `profiles`
  * Order by: `boostedUntil` (desc)
  * Order by: `isPremium` (desc)
  * Order by: `updatedAt` (desc)
- Confirmar quantos documentos retornam

---

### FASE 2: CORREÇÃO P2 - PRÓXIMOS 2 DIAS

#### 🔧 Correção 4: Boost Button (2h)

**Tarefas:**
1. Localizar `boost_screen.dart` (se existe)
2. Testar navegação do BoostButton
3. Adicionar logs em boost_controller
4. Validar activateBoost() funciona
5. Verificar Stripe integration

---

#### 🔧 Correção 5: Criação Vagas (3h)

**Tarefas:**
1. Localizar formulário criação vagas
2. Testar end-to-end
3. Verificar validações
4. Confirmar salvamento Firestore
5. Adicionar error handling

---

#### 🔧 Correção 6: Troca Perfis (2h)

**Tarefas:**
1. Localizar código alternância
2. Verificar estado Riverpod
3. Testar navegação
4. Validar persistência
5. Documentar fluxo

---

### FASE 3: VALIDAÇÃO FINAL

#### ✅ Checklist de Validação:

1. **Login Funciona:** ✅ Após hotfix
2. **FCM Sem Loop:** ✅ Após hotfix
3. **Imagens Carregam:** ⏳ Após desinstalar app
4. **Discovery 7+ Profiles:** ⏳ Após verificar indexes
5. **CardSwiper Estável:** ⏳ Após correção lifecycle
6. **Boost Funciona:** ❌ Pendente
7. **Criar Vaga:** ❌ Pendente
8. **Trocar Perfil:** ❌ Pendente

---

## 📝 DOCUMENTAÇÃO DE BUGS

### Como Reportar Bugs:

**Template:**
```markdown
## BUG #[número]

**Status:** ❌ NÃO CORRIGIDO

**Prioridade:** P0 / P1 / P2 / P3

**Sintoma:**
[Descrição do erro visível para o usuário]

**Logs/Evidências:**
```
[Stack trace ou logs do console]
```

**Arquivos Afetados:**
- `lib/path/to/file.dart`

**Causa Raiz:**
[Explicação técnica do problema]

**Correção Proposta:**
```dart
// Código da solução
```

**Prioridade:** [Justificativa]
```

---

## 🔄 HISTÓRICO DE ATUALIZAÇÕES

### 27/10/2025 18:00 - Criação Documento
- ✅ Mapeados 10 bugs (3 resolvidos, 7 pendentes)
- ✅ Prioridades definidas (P0 → P3)
- ✅ Plano de ação estruturado
- ⏳ Aguardando execução correções P1

---

**Próxima Atualização:** Após correções FASE 1 (P1)
**Responsável:** Biel (Dev) + Maestro Fábio (QA)
