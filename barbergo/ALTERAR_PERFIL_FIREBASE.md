# 🔧 Como Alterar Seu Perfil para Barbearia

## 🎯 Objetivo

Mudar seu perfil de **Barbeiro** para **Barbearia** para poder criar vagas.

---

## 📝 Passo a Passo (2 minutos)

### 1️⃣ Abrir Firebase Console

**Clique aqui:** https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles

### 2️⃣ Encontrar Seu Perfil

1. Você verá uma lista de documentos em `profiles`
2. Procure pelo documento com SEU nome ou email
3. O ID do documento é seu `userId`

**Dica:** Se não souber qual é o seu, procure por:
- Nome: O nome que você cadastrou
- Email: Seu email de login
- Último criado: O documento mais recente

### 3️⃣ Editar o Campo `accountType`

1. **Clique** no seu documento (abre os detalhes)
2. Procure o campo **`accountType`**
3. **Clique no valor** (deve estar: `barber`)
4. **Digite:** `barbershop`
5. **Pressione Enter** ou clique fora para salvar

**Antes:**
```
accountType: barber
```

**Depois:**
```
accountType: barbershop
```

### 4️⃣ Salvar Alterações

- O Firebase salva automaticamente
- Você verá uma confirmação verde no topo

### 5️⃣ Reiniciar o App

**No celular:**
- Feche completamente o app
- Abra novamente

**OU no terminal (Hot Restart):**
- Pressione `R` (maiúsculo)
- Aguarde recarregar

---

## ✅ Testar

Agora tente criar uma vaga novamente:

1. Abra o app
2. Navegue: **Gestão → Minhas Vagas → "+"**
3. Preencha o formulário
4. Clique **"Publicar Vaga"**
5. Deve funcionar! ✅

---

## 🆘 Se Ainda Não Conseguir Achar Seu Perfil

### Descobrir seu User ID

1. **No app**, vá para: Perfil
2. **Olhe** alguma informação única (nome, email)
3. **No Firebase Console:**
   - Vá em: Authentication → Users
   - Procure seu email
   - Copie o **User ID** (UID)
4. **Volte** para: Firestore → profiles
5. **Procure** o documento com esse ID

---

## 🎨 Link Alternativo (Se o Primeiro Não Abrir)

**Console principal:** https://console.firebase.google.com/project/barbergo-38c21

Depois navegue:
1. **Firestore Database** (menu lateral esquerdo)
2. Clique em **profiles** (coleção)
3. Procure seu documento
4. Edite `accountType`

---

## ⚠️ Observação Importante

**Por que não criar nova conta:**
- Requer email diferente
- Firebase Authentication pode limitar criações rápidas
- Mais rápido alterar o existente

**É seguro alterar?**
- ✅ Sim! É apenas seu perfil de teste
- ✅ Podemos reverter depois se quiser
- ✅ Não afeta outros dados

---

## 🚀 Depois de Alterar

Você terá acesso a:

### Como Barbearia
- ✅ Criar vagas
- ✅ Pausar/Retomar vagas  
- ✅ Ver candidatos
- ✅ Aceitar/Rejeitar candidaturas
- ✅ Dashboard de gestão

### Ainda Funciona
- ✅ Login
- ✅ Editar perfil
- ✅ Ver lista de vagas

### Não Vai Funcionar (normal)
- ❌ Feed de vagas (é função de Barbeiro)
- ❌ Swipe para aplicar (é função de Barbeiro)
- ❌ Ver minhas candidaturas (é função de Barbeiro)

---

## 🔄 Para Voltar a Ser Barbeiro Depois

Repita o processo, mas mude de volta:
```
accountType: barbershop → barber
```

---

## 📞 Se Precisar de Ajuda

**Dificuldade para encontrar o documento?**
- Me envie o nome ou email que você usou
- Posso ajudar a localizar

**Erro ao salvar?**
- Verifique se está logado no Firebase com a conta certa
- Tente em navegador anônimo

**App não atualiza?**
- Feche completamente o app
- Reinstale: `flutter run -d uwbekb8hpf6lamts`

---

**⏱️ Tempo total: 2 minutos**

**Status atual:** App instalado e aguardando ✅
