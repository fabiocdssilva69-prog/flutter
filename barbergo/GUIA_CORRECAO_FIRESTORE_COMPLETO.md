# 🔧 GUIA COMPLETO: CORRIGIR BANCO DE DADOS FIRESTORE

## 🎯 OBJETIVO
Corrigir **TODOS** os profiles no Firestore para que o app funcione 100%.

**URL Firebase Console:**
https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles

---

## 📋 LISTA COMPLETA DE PROFILES PARA CORRIGIR

### Profiles Existentes (Total: 10)
1. ✅ barber_001
2. ⚠️ barber_002 (FALTANDO NA QUERY)
3. ✅ barber_003
4. ⚠️ barber_004 (FALTANDO NA QUERY)
5. ⚠️ barber_005 (FALTANDO NA QUERY)
6. ✅ barber_006
7. ✅ barber_007
8. ⚠️ barbershop_001
9. ⚠️ barbershop_002
10. ⚠️ barbershop_003

---

## 🔴 PROBLEMAS IDENTIFICADOS

### Problema 1: accountType em Português
```
❌ ERRADO: accountType = "barbeiro"
✅ CORRETO: accountType = "barber"

❌ ERRADO: accountType = "barbearia"
✅ CORRETO: accountType = "barbershop"
```

### Problema 2: Timestamp vs Number
```
❌ ERRADO: createdAt = Timestamp { seconds: 1698947000 }
✅ CORRETO: createdAt = 1698947000000 (number)

❌ ERRADO: updatedAt = Timestamp { seconds: 1730483400 }
✅ CORRETO: updatedAt = 1730483400000 (number)

❌ ERRADO: boostedUntil = Timestamp { seconds: 1731175800 }
✅ CORRETO: boostedUntil = 1731175800000 (number) ou null
```

### Problema 3: Campos Obrigatórios Faltando
```
❌ Campo "email" não existe
❌ Campo "boostedUntil" não existe
❌ Campo "isPremium" não existe
❌ Campo "updatedAt" não existe
❌ Campo "searchRadiusKm" não existe
```

---

## 🔧 CORREÇÃO PROFILE POR PROFILE

### 📍 TEMPLATE DE CORREÇÃO (COPIAR E COLAR)

Para cada profile, siga este template:

```
✅ CAMPOS OBRIGATÓRIOS (copiar valores exatos):

accountType: "barber" ou "barbershop" (string)
createdAt: 1698947000000 (number)
updatedAt: 1730483400000 (number)
boostedUntil: null (null, ou number se boosted)
isPremium: false (boolean)
isAvailable: true (boolean)
rating: 0 (number)
totalRatings: 0 (number)
searchRadiusKm: 25 (number)
email: [ver lista abaixo] (string)
```

---

## 📋 CORREÇÕES ESPECÍFICAS POR PROFILE

### 1️⃣ barber_001 (Carlos Silva)

**Status:** ⚠️ VERIFICAR

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barber",
  "email": "carlos.barbeiro@example.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

**Ações:**
1. Abrir: https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles~2Fbarber_001
2. Verificar se `accountType` = "barber" (se "barbeiro", DELETAR e RECRIAR)
3. Verificar se `createdAt` é **number** (se Timestamp, DELETAR e RECRIAR)
4. Verificar se `updatedAt` é **number** (se Timestamp, DELETAR e RECRIAR)
5. Adicionar campos faltantes clicando "Add field"

---

### 2️⃣ barber_002 (João Silva) - **CRÍTICO**

**Status:** 🔴 **NÃO APARECE NA QUERY**

**Provável causa:** Campos obrigatórios faltando OU accountType incorreto

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barber",
  "email": "joao.silva@example.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

**Ações:**
1. Abrir: https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles~2Fbarber_002
2. **VERIFICAR SE DOCUMENTO EXISTE** (se não, criar!)
3. Corrigir/adicionar TODOS os campos acima
4. **CONFIRMAR:** accountType = "barber" (lowercase, inglês)
5. **CONFIRMAR:** Todos os campos são **number** (não Timestamp)

---

### 3️⃣ barber_003 (Thiago Alves)

**Status:** ⚠️ VERIFICAR

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barber",
  "email": "thiago.alves@example.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

---

### 4️⃣ barber_004 (Lucas Mendes) - **CRÍTICO**

**Status:** 🔴 **NÃO APARECE NA QUERY**

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barber",
  "email": "lucas.mendes@example.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

---

### 5️⃣ barber_005 (André Santos) - **CRÍTICO**

**Status:** 🔴 **NÃO APARECE NA QUERY**

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barber",
  "email": "andre.santos@example.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

---

### 6️⃣ barber_006 (Felipe Rodrigues)

**Status:** ⚠️ VERIFICAR

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barber",
  "email": "felipe.rodrigues@example.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

---

### 7️⃣ barber_007 (Marcelo Ferreira)

**Status:** ⚠️ VERIFICAR

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barber",
  "email": "marcelo.ferreira@example.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

---

### 8️⃣ barbershop_001 (Barbearia Vintage)

**Status:** ⚠️ VERIFICAR

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barbershop",
  "email": "contato@barbearia-vintage.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

---

### 9️⃣ barbershop_002 (Corte Moderno)

**Status:** ⚠️ VERIFICAR

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barbershop",
  "email": "admin@cortemoderno.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

---

### 🔟 barbershop_003 (Style Bar)

**Status:** ⚠️ VERIFICAR

**Campos para corrigir/adicionar:**
```json
{
  "accountType": "barbershop",
  "email": "contato@stylebar.com",
  "createdAt": 1698947000000,
  "updatedAt": 1730483400000,
  "boostedUntil": null,
  "isPremium": false,
  "isAvailable": true,
  "rating": 0,
  "totalRatings": 0,
  "searchRadiusKm": 25
}
```

---

## 🔧 PASSO A PASSO: COMO CORRIGIR CADA CAMPO

### Deletar Campo Timestamp

1. Clicar no campo (ex: `createdAt`)
2. Clicar no ícone **🗑️ (lixeira)** à direita
3. Confirmar deleção

### Adicionar Campo Number

1. Clicar em **"+ Add field"**
2. Field name: `createdAt`
3. Type: **number**
4. Value: `1698947000000`
5. Clicar **"Add"**

### Adicionar Campo String

1. Clicar em **"+ Add field"**
2. Field name: `email`
3. Type: **string**
4. Value: `carlos.barbeiro@example.com`
5. Clicar **"Add"**

### Adicionar Campo Boolean

1. Clicar em **"+ Add field"**
2. Field name: `isPremium`
3. Type: **boolean**
4. Value: **false**
5. Clicar **"Add"**

### Adicionar Campo Null

1. Clicar em **"+ Add field"**
2. Field name: `boostedUntil`
3. Type: **null**
4. Clicar **"Add"**

---

## ✅ CHECKLIST DE VALIDAÇÃO

Após corrigir TODOS os 10 profiles, verificar:

### Para CADA profile:
- [ ] `accountType` = "barber" ou "barbershop" (string, lowercase, inglês)
- [ ] `email` existe e é string válida
- [ ] `createdAt` = 1698947000000 (number, não Timestamp)
- [ ] `updatedAt` = 1730483400000 (number, não Timestamp)
- [ ] `boostedUntil` = null ou number (não Timestamp, não undefined)
- [ ] `isPremium` = false (boolean, não string)
- [ ] `isAvailable` = true (boolean)
- [ ] `rating` = 0 (number)
- [ ] `totalRatings` = 0 (number)
- [ ] `searchRadiusKm` = 25 (number)

### Teste Final:
- [ ] Desinstalar app do celular (limpar cache)
- [ ] Reinstalar: `flutter run -d uwbekb8hpf6lamts`
- [ ] Abrir Discovery
- [ ] **Verificar se aparecem 7 profiles** (barber_001 a barber_007)

---

## 🎯 TEMPO ESTIMADO

- **Por profile:** 2-3 minutos
- **Total (10 profiles):** 20-30 minutos
- **Teste final:** 5 minutos

**TOTAL:** ~30-35 minutos

---

## 📊 VALORES DE REFERÊNCIA RÁPIDA

**Copie e cole estes valores exatos:**

```
accountType (barbers): "barber"
accountType (barbershops): "barbershop"
createdAt: 1698947000000
updatedAt: 1730483400000
boostedUntil: null
isPremium: false
isAvailable: true
rating: 0
totalRatings: 0
searchRadiusKm: 25
```

**Emails:**
```
barber_001: carlos.barbeiro@example.com
barber_002: joao.silva@example.com
barber_003: thiago.alves@example.com
barber_004: lucas.mendes@example.com
barber_005: andre.santos@example.com
barber_006: felipe.rodrigues@example.com
barber_007: marcelo.ferreira@example.com
barbershop_001: contato@barbearia-vintage.com
barbershop_002: admin@cortemoderno.com
barbershop_003: contato@stylebar.com
```

---

## 🚨 ERROS COMUNS A EVITAR

❌ **NÃO FAZER:**
- Não usar aspas em numbers (1698947000000, não "1698947000000")
- Não deixar campos undefined (usar null se vazio)
- Não usar Timestamp (sempre number milliseconds)
- Não usar português (barber, não barbeiro)
- Não usar maiúsculas (barber, não Barber)

✅ **FAZER:**
- Usar number para datas (milliseconds desde 1970)
- Usar null para campos opcionais vazios
- Usar lowercase para accountType
- Verificar tipo de cada campo (string, number, boolean, null)

---

**Última Atualização:** 04/11/2025 18:45  
**Próxima Ação:** Abrir Firebase Console e começar correções!
