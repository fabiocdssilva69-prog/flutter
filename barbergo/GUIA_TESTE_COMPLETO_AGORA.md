# 🎯 GUIA DE TESTE COMPLETO - SISTEMA DE MATCHES

## ✅ PRÉ-REQUISITOS (TODOS PRONTOS)
- ✅ 3 Índices Firestore: ATIVADOS
- ✅ Firestore Rules: PUBLICADAS (14:15)
- ✅ 3 Perfis criados: João Silva, NOBRUS BARBERSHOP, Maria Santos
- ✅ App compilado sem erros
- ✅ **ZERO erros de PERMISSION_DENIED** nos logs! 🎉

---

## 🚀 TESTE 1: VERIFICAR BOTÕES DE MATCH

### **Objetivo**: Confirmar que os botões "Descobrir" e "Matches" aparecem

### **Passos**:
1. Execute:
   ```bash
   flutter run -d uwbekb8hpf6lamts
   ```

2. **No celular**:
   - App abre na primeira aba (**Minhas Vagas**)
   - **Procure NO TOPO DA TELA** uma barra roxa/rosa com 2 botões lado a lado:
     - 🔵 **"Descobrir"** (azul/roxo, ícone explore)
     - 💗 **"Matches"** (rosa/pink, ícone coração)

3. **Tire um print** e me envie OU **me confirme**: "Sim, vejo os 2 botões"

---

## 🎯 TESTE 2: TELA DE DESCOBRIR (SwipeScreen)

### **Objetivo**: Verificar se perfis são carregados

### **Passos**:
1. **Toque no botão "Descobrir"**

2. **Aguarde 2-3 segundos**

3. **O que você DEVE ver**:
   ✅ **Opção A**: Cards de perfis aparecendo (João Silva ou Maria Santos)
   - Nome do perfil
   - Foto
   - Distância
   - Botões ❌ (deslike) e ❤️ (like) embaixo

   ❌ **Opção B**: "Nenhum perfil disponível"
   - Mensagem: "Não encontramos ninguém por perto"
   - Sugestão: "Tente aumentar o raio de busca"

4. **Me diga**: Qual opção você viu? (A ou B)

---

## 🎯 TESTE 3: DAR LIKE (SWIPE)

### **Se você viu perfis (Opção A)**:

1. **No primeiro perfil que aparecer**:
   - 👆 **Arraste o card para a DIREITA** (swipe right)
   - OU toque no botão ❤️ (coração)

2. **O que deve acontecer**:
   - ✅ Snackbar aparece: "Curtiu [Nome do Perfil]"
   - ✅ Próximo card aparece
   - ✅ **Aguarde 2-3 segundos**
   - ⚠️ Como ainda não há swipe reverso, **NÃO deve aparecer confetti**

3. **Verifique no Firestore**:
   - Vá para: https://console.firebase.google.com/project/barbergo-38c21/firestore/data
   - Abra collection `swipes`
   - **Deve ter 1 documento novo**:
     ```javascript
     {
       fromUserId: "6RYGS6HoEkhQgikNxUIkn7NpwmI3",
       toUserId: "PROFILE_A_UID" ou "PROFILE_C_UID",
       liked: true,
       createdAt: Timestamp
     }
     ```

4. **Me confirme**: "Swipe criado com sucesso no Firestore!"

---

## 🎯 TESTE 4: CRIAR MATCH (SWIPE REVERSO)

### **Objetivo**: Testar detecção de match e confetti

### **Passos**:

1. **Anote qual perfil você deu like** (João Silva ou Maria Santos)

2. **No Firebase Console**:
   - Vá para: https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fswipes
   - Clique em **"Add document"**
   - **Document ID**: (deixe auto-generate)
   - **Campos**:
     ```javascript
     fromUserId: "PROFILE_A_UID"  // Se você deu like no João
     // OU
     fromUserId: "PROFILE_C_UID"  // Se você deu like na Maria
     
     toUserId: "6RYGS6HoEkhQgikNxUIkn7NpwmI3"  // Você (NOBRUS)
     
     liked: true
     
     createdAt: (clique em "Add field" → selecione "timestamp")
     ```
   - Clique em **"Add"**

3. **No app (SwipeScreen)**:
   - Deslize para a **DIREITA** no mesmo perfil novamente (João ou Maria)
   - OU se já passou, navegue até encontrar o perfil de novo

4. **O que DEVE acontecer (aguarde 2-3 segundos)**:
   🎉 **MatchCelebrationDialog aparece**:
   - ✅ Confetti animado por 3 segundos (explosão de partículas coloridas)
   - ✅ 2 avatares circulares (você + João/Maria)
   - ✅ Ícone de coração rosa entre os avatares
   - ✅ Texto: "🎉 É um Match!"
   - ✅ Mensagem: "Você e [Nome] deram match!"
   - ✅ 2 botões:
     - "Continuar explorando" (fecha dialog)
     - "Enviar mensagem" (abre chat)

5. **Verifique no Firestore**:
   - Collection `matches` deve ter 1 documento novo:
     ```javascript
     {
       matchId: "6RYGS6HoEkhQgikNxUIkn7NpwmI3_PROFILE_A_UID",
       userIds: ["6RYGS6HoEkhQgikNxUIkn7NpwmI3", "PROFILE_A_UID"],
       user1: "6RYGS6HoEkhQgikNxUIkn7NpwmI3",
       user2: "PROFILE_A_UID",
       createdAt: Timestamp,
       lastMessageAt: null,
       unreadCount: {
         "6RYGS6HoEkhQgikNxUIkn7NpwmI3": 0,
         "PROFILE_A_UID": 0
       }
     }
     ```

6. **Me diga**: 
   - Confetti apareceu? ✅ / ❌
   - Dialog apareceu? ✅ / ❌
   - Match criado no Firestore? ✅ / ❌

---

## 🎯 TESTE 5: TELA DE MATCHES

### **Objetivo**: Verificar lista de matches

### **Passos**:

1. **No app**:
   - Volte para tela inicial (botão BACK ou feche o dialog)
   - Toque no botão **"Matches"** (rosa, ícone coração)

2. **O que você DEVE ver**:
   - ✅ Lista com 1 card de match
   - ✅ Avatar do perfil (João ou Maria)
   - ✅ Nome do perfil
   - ✅ "Vocês deram match!"
   - ✅ Botão "Enviar mensagem"

3. **Me confirme**: "Vejo 1 match na lista!"

---

## 🎯 TESTE 6: ABRIR CHAT

### **Objetivo**: Testar navegação para chat

### **Passos**:

1. **Na MatchCelebrationDialog** OU **Na tela de Matches**:
   - Toque em **"Enviar mensagem"**

2. **O que você DEVE ver**:
   - ✅ Tela de chat abre
   - ✅ AppBar com nome do perfil (João Silva ou Maria Santos)
   - ✅ Campo de texto embaixo: "Digite uma mensagem..."
   - ✅ Botão de enviar (ícone send)
   - ✅ Área de mensagens vazia (por enquanto)

3. **Me confirme**: "Chat abriu corretamente!"

---

## 🎯 TESTE 7: ENVIAR MENSAGEM

### **Objetivo**: Testar envio de mensagem

### **Passos**:

1. **No chat**:
   - Digite: "Olá! 👋"
   - Toque no botão **Send** (ícone avião/seta)

2. **O que você DEVE ver**:
   - ✅ Mensagem aparece na tela
   - ✅ Sua mensagem alinhada à direita (cor azul/roxa)
   - ✅ Timestamp da mensagem

3. **Verifique no Firestore**:
   - Collection `chats` → (procure documento com seu userId)
   - Subcollection `messages` → deve ter 1 documento:
     ```javascript
     {
       messageId: "...",
       senderId: "6RYGS6HoEkhQgikNxUIkn7NpwmI3",
       text: "Olá! 👋",
       createdAt: Timestamp,
       read: false
     }
     ```

4. **Me confirme**: "Mensagem enviada e aparece no chat!"

---

## 🎯 TESTE 8: CLOUD FUNCTIONS

### **Objetivo**: Verificar se Cloud Functions executaram

### **Passos**:

1. **Vá para Firebase Console**:
   - https://console.firebase.google.com/project/barbergo-38c21/functions/logs

2. **Procure pelos logs**:
   - ✅ **detectMatch**: Deve ter log "✅ Match criado: [matchId]"
   - ✅ **sendMatchNotification**: Deve ter log "🔔 Notificações enviadas: 2"
   - ✅ **onNewMessage** (se enviou mensagem): Deve ter log

3. **Me diga**: Viu os logs das Cloud Functions? ✅ / ❌

---

## 📊 RESUMO FINAL - CHECKLIST COMPLETO

| # | Teste | Status | Observação |
|---|-------|--------|------------|
| 1 | Botões "Descobrir" e "Matches" visíveis | ⏳ | Aguardando confirmação |
| 2 | SwipeScreen carrega perfis | ⏳ | Aguardando confirmação |
| 3 | Swipe right cria documento em `swipes` | ⏳ | Aguardando confirmação |
| 4 | Match detectado + Confetti animado | ⏳ | Aguardando confirmação |
| 5 | Tela de Matches lista matches | ⏳ | Aguardando confirmação |
| 6 | Navegação para chat funciona | ⏳ | Aguardando confirmação |
| 7 | Envio de mensagem funciona | ⏳ | Aguardando confirmação |
| 8 | Cloud Functions executaram | ⏳ | Aguardando confirmação |

---

## 🚀 COMEÇE PELO TESTE 1

Execute o app e **me confirme se vê os 2 botões no topo da tela**! 

Depois seguimos para o próximo teste. 💪
