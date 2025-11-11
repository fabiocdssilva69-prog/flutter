# 🔧 PLANO DE CORREÇÕES COMPLETO - Sprint 2

## 📊 RESUMO DOS PROBLEMAS IDENTIFICADOS

### ❌ CRÍTICOS (Impedem funcionamento)
1. **TIMESTAMP** - Parsing error nos perfis (barber_001 ainda com Timestamp)
2. **FIREBASE STORAGE** - Permissões 403 para upload de imagens
3. **FIRESTORE CHECKOUT** - Permissões negadas para checkout_sessions

### ⚠️ MÉDIOS (Causam crashes)
4. **RIVERPOD LIFECYCLE** - Widget unmount unsafe em SwipeScreen
5. **APP CHECK** - Provider não configurado

---

## 🚀 SEQUÊNCIA DE CORREÇÕES

### 1️⃣ **CORREÇÃO IMEDIATA: TIMESTAMPS** 
**Status:** 🔄 EM ANDAMENTO
**Problema:** `barber_001` ainda tem `createdAt` como Timestamp
**Solução:** 
- Verificar Firebase Console se TODOS os perfis têm campos como `number`
- Re-executar correções se necessário

### 2️⃣ **FIREBASE STORAGE RULES**
**Status:** 🔄 PRÓXIMO
**Problema:** Upload de imagens retorna 403 Forbidden
**Arquivos afetados:**
- `firestore.rules` ou Storage Rules no Console
**Solução:**
- Atualizar regras para permitir upload de portfolio/profile images
- Configurar validação de tamanho/tipo de arquivo

### 3️⃣ **FIRESTORE CHECKOUT PERMISSIONS**
**Status:** 🔄 PRÓXIMO  
**Problema:** Checkout sessions não podem ser criadas
**Arquivo afetado:** `firestore.rules`
**Solução:**
- Adicionar regras para collection `customers/{uid}/checkout_sessions`
- Permitir create/read para usuário autenticado

### 4️⃣ **RIVERPOD LIFECYCLE FIX**
**Status:** 🔄 PRÓXIMO
**Problema:** `ref` usado após widget unmount em SwipeScreen
**Arquivo afetado:** `lib/src/features/discovery/presentation/swipe_screen.dart:270`
**Solução:**
- Implementar `mounted` check antes de usar `ref`
- Usar timer/callback cancellation em dispose()

### 5️⃣ **FIREBASE APP CHECK**
**Status:** 🔄 OPCIONAL
**Problema:** AppCheckProvider não configurado
**Arquivos afetados:** Firebase config, main.dart
**Solução:**
- Configurar reCAPTCHA provider para web
- Debug provider para desenvolvimento

---

## 📋 CHECKLIST DE EXECUÇÃO

- [ ] **TIMESTAMP**: Verificar todos os 10 perfis no Firebase Console
- [ ] **STORAGE**: Atualizar Storage Rules para uploads
- [ ] **FIRESTORE**: Adicionar regras de checkout_sessions  
- [ ] **RIVERPOD**: Fix lifecycle em SwipeScreen
- [ ] **APP CHECK**: Configurar provider (opcional)
- [ ] **TESTE**: Validar todos os fixes funcionando

---

## 🎯 RESULTADO ESPERADO

Após todas as correções:
- ✅ Discovery carrega 7 perfis de barbeiros
- ✅ Upload de imagens funciona sem erros
- ✅ Sistema de boost/checkout funciona
- ✅ Não há crashes no console
- ✅ App estável para próximas features

---

**⏱️ Tempo estimado total:** 45-60 minutos
**🏆 Prioridade:** CRÍTICA - Resolver antes de adicionar novas features