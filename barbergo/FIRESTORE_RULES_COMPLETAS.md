# 🔒 FIRESTORE RULES COMPLETAS - SISTEMA DE MATCHES

## 📋 QUANDO USAR:
Copie estas rules **DEPOIS** que os 3 índices estiverem com status 🟢 **"Enabled"**.

---

## 🔥 FIRESTORE RULES - COPIAR E COLAR

Vá para: **Firebase Console → Firestore Database → Rules**

Cole este código completo:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // ==================== FUNÇÕES AUXILIARES ====================
    
    // Verifica se o usuário está autenticado
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Verifica se é o próprio usuário
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Verifica se o usuário faz parte de um array
    function isParticipant(userIds) {
      return isAuthenticated() && request.auth.uid in userIds;
    }
    
    // ==================== PROFILES ====================
    
    match /profiles/{userId} {
      // Leitura: Qualquer usuário autenticado pode ver perfis (para discovery/swipe)
      allow read: if isAuthenticated();
      
      // Criação: Apenas o próprio usuário pode criar seu perfil
      allow create: if isOwner(userId) 
                    && request.resource.data.userId == userId
                    && request.resource.data.keys().hasAll(['displayName', 'accountType', 'email']);
      
      // Atualização: Apenas o próprio usuário pode atualizar seu perfil
      allow update: if isOwner(userId);
      
      // Exclusão: Apenas o próprio usuário pode deletar seu perfil
      allow delete: if isOwner(userId);
    }
    
    // ==================== SWIPES ====================
    
    match /swipes/{swipeId} {
      // Leitura: Apenas quem deu o swipe pode ver seus próprios swipes
      allow read: if isAuthenticated() 
                  && resource.data.fromUserId == request.auth.uid;
      
      // Criação: Apenas o usuário autenticado pode criar swipes
      allow create: if isAuthenticated() 
                    && request.resource.data.fromUserId == request.auth.uid
                    && request.resource.data.keys().hasAll(['fromUserId', 'toUserId', 'liked']);
      
      // Atualização/Exclusão: Não permitidas (swipes são imutáveis)
      allow update, delete: if false;
    }
    
    // ==================== MATCHES ====================
    
    match /matches/{matchId} {
      // Leitura: Apenas participantes do match podem ver
      allow read: if isAuthenticated() 
                  && isParticipant(resource.data.userIds);
      
      // Criação: Apenas Cloud Functions podem criar matches
      // (usuários comuns não podem criar matches diretamente)
      allow create: if false; // Somente Cloud Functions
      
      // Atualização: Apenas participantes podem atualizar (ex: unreadCount)
      allow update: if isAuthenticated() 
                    && isParticipant(resource.data.userIds);
      
      // Exclusão: Apenas participantes podem deletar o match
      allow delete: if isAuthenticated() 
                    && isParticipant(resource.data.userIds);
    }
    
    // ==================== CHATS ====================
    
    match /chats/{chatId} {
      // Leitura: Apenas participantes do chat podem ver
      allow read: if isAuthenticated() 
                  && isParticipant(resource.data.participants);
      
      // Criação: Apenas Cloud Functions ou participantes podem criar
      allow create: if isAuthenticated() 
                    && isParticipant(request.resource.data.participants)
                    && request.resource.data.keys().hasAll(['participants', 'matchId']);
      
      // Atualização: Apenas participantes podem atualizar
      allow update: if isAuthenticated() 
                    && isParticipant(resource.data.participants);
      
      // Exclusão: Apenas participantes podem deletar
      allow delete: if isAuthenticated() 
                    && isParticipant(resource.data.participants);
      
      // ==================== MESSAGES (subcollection) ====================
      
      match /messages/{messageId} {
        // Leitura: Apenas participantes do chat podem ver mensagens
        allow read: if isAuthenticated() 
                    && isParticipant(get(/databases/$(database)/documents/chats/$(chatId)).data.participants);
        
        // Criação: Apenas participantes podem enviar mensagens
        allow create: if isAuthenticated() 
                      && isParticipant(get(/databases/$(database)/documents/chats/$(chatId)).data.participants)
                      && request.resource.data.senderId == request.auth.uid
                      && request.resource.data.keys().hasAll(['senderId', 'text', 'createdAt']);
        
        // Atualização: Apenas o remetente pode atualizar (ex: marcar como lida)
        allow update: if isAuthenticated() 
                      && resource.data.senderId == request.auth.uid;
        
        // Exclusão: Apenas o remetente pode deletar suas mensagens
        allow delete: if isAuthenticated() 
                      && resource.data.senderId == request.auth.uid;
      }
    }
    
    // ==================== VACANCIES (compatibilidade) ====================
    
    match /vacancies/{vacancyId} {
      allow read: if isAuthenticated();
      allow create, update: if isAuthenticated();
      allow delete: if isAuthenticated() 
                    && resource.data.barbershopId == request.auth.uid;
    }
    
    // ==================== APPLICATIONS (compatibilidade) ====================
    
    match /applications/{applicationId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() 
                    && request.resource.data.barberId == request.auth.uid;
      allow update: if isAuthenticated();
      allow delete: if isAuthenticated();
    }
    
    // ==================== NOTIFICAÇÕES ====================
    
    match /notifications/{notificationId} {
      allow read: if isAuthenticated() 
                  && resource.data.userId == request.auth.uid;
      allow create: if false; // Apenas Cloud Functions
      allow update: if isAuthenticated() 
                    && resource.data.userId == request.auth.uid;
      allow delete: if isAuthenticated() 
                    && resource.data.userId == request.auth.uid;
    }
    
    // ==================== FCM TOKENS ====================
    
    match /fcmTokens/{tokenId} {
      allow read, write: if isAuthenticated() 
                         && resource.data.userId == request.auth.uid;
    }
  }
}
```

---

## ✅ COMO APLICAR AS RULES:

1. **Abra o Firebase Console**: https://console.firebase.google.com/project/barbergo-38c21/firestore/rules

2. **Apague TODO o conteúdo atual** da área de texto

3. **Cole as rules acima** (cópia completa)

4. **Clique em "Publish"** (botão azul no topo direito)

5. **Aguarde 10-20 segundos** para as rules serem aplicadas

---

## 🎯 ORDEM DE EXECUÇÃO:

### **AGORA (enquanto índices constroem)**:
- ✅ Aguardar 2-5 minutos
- ✅ Verificar se os 3 índices ficaram 🟢 "Enabled"

### **DEPOIS (quando índices estiverem prontos)**:
1. ✅ Copiar e colar Firestore Rules acima
2. ✅ Publicar as rules
3. ✅ Testar o app

---

## 🐛 TROUBLESHOOTING:

### **Se der erro "Permission Denied" após publicar:**
- Verifique se o userId no documento `profiles` corresponde ao UID do Firebase Auth
- Teste com `firebase emulators:start` para debug local (opcional)
- Veja os logs de segurança: Firebase Console → Firestore → Rules → Tab "Rules Playground"

### **Se os matches não aparecerem:**
- Confirme que os 3 índices estão 🟢 "Enabled"
- Verifique se o campo `userIds` no documento `matches` é um array
- Teste a query manualmente no Firebase Console

---

## 📊 RESUMO:

| Item | Status | Ação |
|------|--------|------|
| Índice 1 (matches) | 🟡 Criando | Aguardar ficar 🟢 |
| Índice 2 (chats) | 🟡 Criando | Aguardar ficar 🟢 |
| Índice 4 (profiles) | 🟡 Criando | Aguardar ficar 🟢 |
| Índice 3 (messages) | ✅ Não precisa | Firestore tem índice automático |
| Firestore Rules | ⏳ Pronto para copiar | Aplicar DEPOIS dos índices |
| App | ✅ Pronto | Testar DEPOIS das rules |

---

**Me avise quando os 3 índices estiverem 🟢 "Enabled"!** 🚀
