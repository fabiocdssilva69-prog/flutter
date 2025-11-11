# 🚨 PROBLEMA: Coleção com Nome Errado

## 🔍 Problema Identificado

O Firebase tem **DUAS** coleções:

- ❌ `Profiles` (com P maiúsculo) - **ERRADO**
- ✅ `profiles` (com p minúsculo) - **CORRETO**

O app está tentando acessar `Profiles` (maiúsculo), mas as regras do Firestore esperam `profiles` (minúsculo).

---

## ✅ SOLUÇÃO DEFINITIVA

### 1️⃣ Deletar Coleção `Profiles` (Maiúsculo)

**Acesse:** <https://console.firebase.google.com/project/barbergo-38c21/firestore/data>

1. Procure a coleção **`Profiles`** (com P maiúsculo)
2. Clique no documento: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`
3. Clique nos **3 pontos** (⋮) no topo direito
4. Selecione **"Delete document"**
5. Confirme

### 2️⃣ Verificar/Criar na Coleção `profiles` (Minúsculo)

1. Procure a coleção **`profiles`** (com p minúsculo)
2. Verifique se existe o documento: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`

**Se NÃO existir:**

1. Clique em **"Start collection"** ou **"+"**
2. **Collection ID:** `profiles` (minúsculo!)
3. **Document ID:** `6RYGS6HoEkhQgikNxUIkn7NpwmI3`
4. **Adicione os campos:**

```
userId: "6RYGS6HoEkhQgikNxUIkn7NpwmI3" (string)
accountType: "barbershop" (string)
name: "[Seu Nome]" (string)
email: "[Seu Email]" (string)  
location: "São Paulo, SP" (string)
bio: "" (string)
contactPhone: "" (string)
createdAt: [timestamp atual]
updatedAt: [timestamp atual]
```

5. Clique **"Save"**

**Se JÁ existir:**

1. Abra o documento
2. Verifique se `accountType` está como `"barbershop"`
3. Se não, edite para `"barbershop"`

### 3️⃣ Reinstalar o App

**No terminal (ou uma nova janela PowerShell):**

```powershell
flutter run -d uwbekb8hpf6lamts
```

---

## 🎯 Por Que Isso Aconteceu?

**Firestore é case-sensitive!**

- `Profiles` ≠ `profiles`
- São **DUAS** coleções diferentes
- O código usa `profiles` (minúsculo)
- As regras esperam `profiles` (minúsculo)
- Mas alguém criou dados em `Profiles` (maiúsculo)

---

## ⚡ Ação URGENTE

1. **DELETE** a coleção/documento `Profiles` (maiúsculo)
2. **VERIFIQUE** que existe em `profiles` (minúsculo) com `accountType: "barbershop"`
3. **REINSTALE** o app

---

## 📸 Como Identificar

**ERRADO (Delete isso):**

```
Collections
  └─ Profiles  ← P MAIÚSCULO ❌
      └─ 6RYGS6HoEkhQgikNxUIkn7NpwmI3
```

**CORRETO (Use isso):**

```
Collections
  └─ profiles  ← p minúsculo ✅
      └─ 6RYGS6HoEkhQgikNxUIkn7NpwmI3
          ├─ accountType: "barbershop"
          ├─ name: "..."
          ├─ email: "..."
          └─ location: "..."
```

---

**⏱️ Tempo estimado: 3 minutos para corrigir**

**Status:** Problema crítico identificado - coleção com nome errado!
