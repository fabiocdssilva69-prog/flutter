# 🔧 SOLUÇÃO: Alterar Perfil para Barbearia

## 🎯 Situação Atual

O app está rodando, mas você tem perfil de **Barbeiro** e precisa de **Barbearia** para criar vagas.

---

## 📝 Passo a Passo RÁPIDO (2 minutos)

### 1️⃣ Abrir Firebase Console

**👉 CLIQUE AQUI:** [Abrir Firebase Firestore](https://console.firebase.google.com/project/barbergo-38c21/firestore/data)

### 2️⃣ Procurar Sua Coleção de Perfil

**IMPORTANTE:** Procure em **DUAS** coleções possíveis:

#### Opção A: Coleção `profiles` (minúsculo)
1. Clique em **`profiles`** no menu lateral
2. Procure seu documento com ID: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`

#### Opção B: Coleção `Profiles` (maiúsculo) ⚠️
1. Clique em **`Profiles`** (com P maiúsculo)
2. Procure seu documento com ID: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`

**Dica:** Se ver ambas, o documento **correto** está em `profiles` (minúsculo)

### 3️⃣ Abrir Seu Documento

Clique no documento com ID: **`6RYGS6HoEkhQgikNxUIkn7NpwmI3`**

### 4️⃣ Editar o Campo `accountType`

1. Procure o campo **`accountType`**
2. **Clique no valor atual** (provavelmente: `barber`)
3. **Digite:** `barbershop`
4. **Pressione Enter**

**Antes:**
```
accountType: "barber"
```

**Depois:**
```
accountType: "barbershop"
```

### 5️⃣ Salvar e Verificar

- Firebase salva automaticamente
- Você verá uma confirmação verde

### 6️⃣ Reiniciar o App

**No terminal Flutter (onde está o app rodando):**
```
Pressione: R (maiúsculo - Hot Restart)
```

**OU feche e abra o app no celular**

---

## ✅ Testar Agora

1. Abra o app
2. Vá em: **Gestão → Minhas Vagas → "+"**
3. Preencha qualquer coisa:
   - Título: "Teste"
   - Horário: "Seg a sexta"
   - Comissão: 50
   - Requisitos: "teste"
4. Clique **"Publicar Vaga"**
5. **Deve funcionar agora!** ✅

---

## 🐛 Se Continuar Dando Erro

### Se o campo `accountType` não existir:

**Adicione manualmente:**

1. No documento, clique em **"Add Field"** ou **"+"**
2. **Field name:** `accountType`
3. **Type:** string
4. **Value:** `barbershop`
5. Salve

### Se o documento não existir em `profiles`:

**Mas existir em `Profiles`:**

1. Copie o `userId`: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`
2. Abra o documento em `Profiles` (maiúsculo)
3. Clique nos **3 pontos** (menu) → **"Copy Document"**
4. Cole na coleção `profiles` (minúsculo)
5. Edite o `accountType` para `barbershop`

### Se nada funcionar:

**Logout e Login novamente:**

1. App → Perfil → Sair
2. Faça login novamente
3. Verifique se o perfil carrega
4. Tente criar vaga

---

## 📊 Informações do Seu Perfil

**User ID:** `6RYGS6HoEkhQgikNxUIkn7NpwmI3`

**Tipo Atual:** `barber` (Barbeiro)

**Tipo Necessário:** `barbershop` (Barbearia)

**Coleção Correta:** `profiles` (minúsculo)

---

## 🎯 Após Alterar

Você poderá:

- ✅ **Criar vagas**
- ✅ Pausar/Retomar vagas
- ✅ Ver candidatos
- ✅ Aceitar/Rejeitar candidaturas
- ✅ Dashboard de gestão completo

**Não funcionará (normal para Barbearia):**
- ❌ Feed de vagas (função de Barbeiro)
- ❌ Swipe para aplicar (função de Barbeiro)
- ❌ Ver minhas candidaturas (função de Barbeiro)

---

## 🚨 MUITO IMPORTANTE

**Problema detectado nos logs:**

O app está tentando acessar: `Profiles/6RYGS6HoEkhQgikN...` (com P maiúsculo)

Mas as regras do Firestore esperam: `profiles/6RYGS6HoEkhQgikN...` (minúsculo)

**Solução:**
- Certifique-se de editar o documento na coleção **`profiles`** (minúsculo)
- Se o documento estiver em `Profiles` (maiúsculo), copie para `profiles`

---

**⏱️ Tempo estimado: 2 minutos**

**Status:** App instalado e aguardando alteração ✅

**Próximo passo:** Alterar `accountType` no Firebase Console!
