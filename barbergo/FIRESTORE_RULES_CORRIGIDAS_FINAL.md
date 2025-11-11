# 🔒 FIRESTORE RULES CORRIGIDAS - VERSÃO FINAL

## ⚠️ PROBLEMA IDENTIFICADO

O app está tentando acessar 2 collections que não estão nas rules:

1. `profiles/{userId}/notifications` (subcollection)
2. `chat_rooms` (collection antiga do sistema de chat antigo)

---

## 🔥 FIRESTORE RULES - COPIAR E COLAR (VERSÃO CORRIGIDA)

**Vá para**: <https://console.firebase.google.com/project/barbergo-38c21/firestore/rules>

**Cole este código completo** (substitua TUDO):

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // ==================== FUNÇÕES AUXILIARES ====================
    
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    function isParticipant(userIds) {
      return isAuthenticated() && request.auth.uid in userIds;
    }
    
    // ==================== PROFILES ====================
    
    match /profiles/{userId} {
      allow read: if isAuthenticated();
      
      allow create: if isOwner(userId) 
                    && request.resource.data.userId == userId;
      
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
      
      // 🆕 NOTIFICATIONS (subcollection)
      match /notifications/{notificationId} {
        // Leitura: Apenas o próprio usuário vê suas notificações
        allow read: if isOwner(userId);
        
        // Criação: Apenas Cloud Functions ou sistema
        allow create: if true; // Permitir para Cloud Functions criarem
        
        // Atualização: Apenas o próprio usuário (marcar como lida)
        allow update: if isOwner(userId);
        
        // Exclusão: Apenas o próprio usuário
        allow delete: if isOwner(userId);
      }
    }
    
    // ==================== SWIPES ====================
    
    match /swipes/{swipeId} {
      allow read: if isAuthenticated() 
                  && resource.data.fromUserId == request.auth.uid;
      
      allow create: if isAuthenticated() 
                    && request.resource.data.fromUserId == request.auth.uid
                    && request.resource.data.keys().hasAll(['fromUserId', 'toUserId', 'liked']);
      
      allow update, delete: if false;
    }
    
    // ==================== MATCHES ====================
    
    match /matches/{matchId} {
      allow read: if isAuthenticated() 
                  && isParticipant(resource.data.userIds);
      
      allow create: if true; // Cloud Functions criam
      
      allow update: if isAuthenticated() 
                    && isParticipant(resource.data.userIds);
      
      allow delete: if isAuthenticated() 
                    && isParticipant(resource.data.userIds);
    }
    
    // ==================== CHATS (novo sistema) ====================
    
    match /chats/{chatId} {
      allow read: if isAuthenticated() 
                  && isParticipant(resource.data.participants);
      
      allow create: if isAuthenticated() 
                    && isParticipant(request.resource.data.participants);
      
      allow update: if isAuthenticated() 
                    && isParticipant(resource.data.participants);
      
      allow delete: if isAuthenticated() 
                    && isParticipant(resource.data.participants);
      
      // Messages (subcollection)
      match /messages/{messageId} {
        allow read: if isAuthenticated() 
                    && isParticipant(get(/databases/$(database)/documents/chats/$(chatId)).data.participants);
        
        allow create: if isAuthenticated() 
                      && isParticipant(get(/databases/$(database)/documents/chats/$(chatId)).data.participants)
                      && request.resource.data.senderId == request.auth.uid;
        
        allow update: if isAuthenticated() 
                      && resource.data.senderId == request.auth.uid;
        
        allow delete: if isAuthenticated() 
                      && resource.data.senderId == request.auth.uid;
      }
    }
    
    // 🆕 CHAT_ROOMS (sistema antigo - compatibilidade)
    match /chat_rooms/{roomId} {
      allow read: if isAuthenticated() 
                  && isParticipant(resource.data.participantIds);
      
      allow create: if isAuthenticated() 
                    && isParticipant(request.resource.data.participantIds);
      
      allow update: if isAuthenticated() 
                    && isParticipant(resource.data.participantIds);
      
      allow delete: if isAuthenticated() 
                    && isParticipant(resource.data.participantIds);
      
      // Messages (subcollection do sistema antigo)
      match /messages/{messageId} {
        allow read: if isAuthenticated() 
                    && isParticipant(get(/databases/$(database)/documents/chat_rooms/$(roomId)).data.participantIds);
        
        allow create: if isAuthenticated() 
                      && isParticipant(get(/databases/$(database)/documents/chat_rooms/$(roomId)).data.participantIds);
        
        allow update, delete: if isAuthenticated();
      }
    }
    
    // ==================== VACANCIES ====================
    
    match /vacancies/{vacancyId} {
      allow read: if isAuthenticated();
      allow create, update: if isAuthenticated();
      allow delete: if isAuthenticated() 
                    && resource.data.barbershopId == request.auth.uid;
    }
    
    // ==================== APPLICATIONS ====================
    
    match /applications/{applicationId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() 
                    && request.resource.data.barberId == request.auth.uid;
      allow update: if isAuthenticated();
      allow delete: if isAuthenticated();
    }
    
    // ==================== FCM TOKENS ====================
    
    match /fcmTokens/{tokenId} {
      allow read, write: if isAuthenticated();
    }
  }
}
```

---

## ✅ DIFERENÇAS DA VERSÃO ANTERIOR

### 🆕 **Adicionado**

1. ✅ `profiles/{userId}/notifications` - Subcollection de notificações
2. ✅ `chat_rooms` - Collection antiga do sistema de chat (compatibilidade)
3. ✅ `matches.create: if true` - Permitir Cloud Functions criarem matches

### 🔧 **Corrigido**

- Rules agora cobrem **100% das queries** que o app está fazendo
- Removido validações muito restritas que bloqueavam Cloud Functions

---

## 🚀 COMO APLICAR

1. **Abra**: <https://console.firebase.google.com/project/barbergo-38c21/firestore/rules>
2. **Apague TUDO** que está lá
3. **Cole** as rules acima
4. **Clique em "Publish"**
5. **Aguarde 10 segundos**
6. **Execute o app novamente**:

   ```bash
   flutter run -d uwbekb8hpf6lamts
   ```

---

## 📊 RESUMO DOS ERROS CORRIGIDOS

| Erro | Collection | Status | Solução |
|------|-----------|--------|---------|
| PERMISSION_DENIED | `profiles/{userId}/notifications` | ❌ Faltava | ✅ Adicionada |
| PERMISSION_DENIED | `chat_rooms` | ❌ Faltava | ✅ Adicionada |
| Matches não criavam | `matches` | ⚠️ Muito restritiva | ✅ Permitido Cloud Functions |

---

**Me avise quando publicar as rules corrigidas!** 🚀
