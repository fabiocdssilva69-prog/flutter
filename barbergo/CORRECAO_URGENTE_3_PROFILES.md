# 🚨 AÇÃO URGENTE - BANCO DE DADOS BUGADO

## 📊 SITUAÇÃO ATUAL

**Problema:** Discovery mostra apenas 4/7 profiles  
**Causa Raiz:** Campos faltando/incorretos em barber_002, barber_004, barber_005  
**Impacto:** App não funciona corretamente

---

## ✅ SOLUÇÃO: 3 CORREÇÕES CRÍTICAS

### 🔴 PROFILE 1: barber_002 (João Silva)

**URL Direto:**
https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles~2Fbarber_002

**Corrigir/Adicionar estes campos:**

| Campo | Tipo | Valor |
|-------|------|-------|
| accountType | string | `barber` |
| email | string | `joao.silva@example.com` |
| createdAt | number | `1698947000000` |
| updatedAt | number | `1730483400000` |
| boostedUntil | null | (deixar vazio) |
| isPremium | boolean | `false` |
| searchRadiusKm | number | `25` |

---

### 🔴 PROFILE 2: barber_004 (Lucas Mendes)

**URL Direto:**
https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles~2Fbarber_004

**Corrigir/Adicionar estes campos:**

| Campo | Tipo | Valor |
|-------|------|-------|
| accountType | string | `barber` |
| email | string | `lucas.mendes@example.com` |
| createdAt | number | `1698947000000` |
| updatedAt | number | `1730483400000` |
| boostedUntil | null | (deixar vazio) |
| isPremium | boolean | `false` |
| searchRadiusKm | number | `25` |

---

### 🔴 PROFILE 3: barber_005 (André Santos)

**URL Direto:**
https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles~2Fbarber_005

**Corrigir/Adicionar estes campos:**

| Campo | Tipo | Valor |
|-------|------|-------|
| accountType | string | `barber` |
| email | string | `andre.santos@example.com` |
| createdAt | number | `1698947000000` |
| updatedAt | number | `1730483400000` |
| boostedUntil | null | (deixar vazio) |
| isPremium | boolean | `false` |
| searchRadiusKm | number | `25` |

---

## 🔧 INSTRUÇÕES RÁPIDAS

### Para CADA profile acima:

1. **Clicar no link** do profile
2. **Verificar se existe** (se não, criar documento primeiro)
3. **Para cada campo:**
   - Se campo **NÃO existe**: Clicar "+ Add field" e adicionar
   - Se campo **é Timestamp**: DELETAR e recriar como **number**
   - Se campo **é string "barbeiro"**: DELETAR e recriar como **string "barber"**

### Adicionar campo:
```
1. Clicar "+ Add field"
2. Field name: [copiar da tabela]
3. Type: [copiar da tabela]
4. Value: [copiar da tabela]
5. Clicar "Add"
```

### Deletar campo:
```
1. Clicar no campo
2. Clicar ícone 🗑️ (lixeira)
3. Confirmar
```

---

## ⚠️ ATENÇÃO ESPECIAL

### accountType DEVE SER:
- ✅ `"barber"` (lowercase, inglês)
- ❌ NÃO `"barbeiro"` (português)
- ❌ NÃO `"Barber"` (maiúscula)

### Datas DEVEM SER number:
- ✅ `1698947000000` (number, sem aspas)
- ❌ NÃO `Timestamp { seconds: 1698947000 }`
- ❌ NÃO `"1698947000000"` (string com aspas)

### boostedUntil PODE SER:
- ✅ `null` (tipo null, campo vazio)
- ✅ `1731175800000` (number se profile boosted)
- ❌ NÃO deixar sem adicionar campo

---

## ✅ TESTE APÓS CORREÇÃO

### 1. Desinstalar app (limpar cache):
```
No celular:
Configurações → Apps → BarberGO → Desinstalar
```

### 2. Reinstalar app:
```bash
flutter run -d uwbekb8hpf6lamts
```

### 3. Verificar Discovery:
- Abrir tela "Descobrir"
- Contar quantos profiles aparecem
- **ESPERADO: 7 profiles** (barber_001 a barber_007)
- **SE AINDA 4:** Repetir verificação dos campos

---

## 📊 DIAGNÓSTICO RÁPIDO

Se após correção ainda mostrar 4 profiles:

### Verificar no Firebase Console:

**Para barber_002, barber_004, barber_005:**

```
✅ Campo accountType = "barber" (exatamente assim)
✅ Campo createdAt é number (não Timestamp)
✅ Campo updatedAt é number (não Timestamp)
✅ Campo email existe (qualquer string)
✅ Campo boostedUntil existe (null ou number)
✅ Campo isPremium existe (boolean)
```

Se **TODOS** os campos acima estão corretos e ainda não aparece:

1. Verificar índice composto no Firebase:
   - Ir em: Indexes
   - Procurar índice: `profiles → accountType → boostedUntil → isPremium → updatedAt`
   - Status deve ser: **Enabled**

2. Se índice está "Building":
   - Aguardar conclusão (~5 minutos)
   - Recarregar app

---

## 🎯 RESULTADO ESPERADO

**Antes:** 4 profiles (barber_001, 003, 006, 007)  
**Depois:** 7 profiles (barber_001, 002, 003, 004, 005, 006, 007)

**Logs esperados:**
```
🔍 [discoverProfiles] snapshot.docs.length: 7
✅ [discoverProfiles] Final profiles count: 7 (server-ordered)
```

---

## ⏱️ TEMPO ESTIMADO

- Correção 3 profiles: **5-10 minutos**
- Desinstalar/reinstalar app: **3 minutos**
- Teste final: **2 minutos**

**TOTAL: ~10-15 minutos**

---

## 📞 SE PRECISAR DE AJUDA

**Me avise se:**
- ✅ Após correção, ainda mostra 4 profiles
- ✅ Algum campo não consegue adicionar/deletar
- ✅ Documento não existe e não sabe como criar
- ✅ Após 15 minutos, índice ainda está "Building"

**Eu posso:**
- Criar script automatizado
- Verificar Firebase Rules
- Diagnosticar problema específico
- Criar profiles manualmente via script

---

**Criado:** 04/11/2025 18:50  
**Status:** 🔴 AGUARDANDO CORREÇÃO MANUAL  
**Próxima Ação:** Abrir Firebase Console e corrigir 3 profiles
