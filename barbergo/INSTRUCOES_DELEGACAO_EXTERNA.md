# 🔥 INSTRUÇÕES PARA DELEGAÇÃO EXTERNA

**Data:** 02/11/2025  
**Para:** Agente Firebase/Backend/Google Cloud  
**Urgência:** 🔴 ALTA (necessário para desenvolvimento Flutter)

---

## 📋 VISÃO GERAL

Você precisa configurar **3 ambientes externos** para o BarberGO:

```
1️⃣ Firebase Storage + Cloud Functions (2-3h)
2️⃣ Google Maps API Key (30min)
3️⃣ Firestore Indexes (15min)

TOTAL: 3-4 horas
```

---

# 1️⃣ FIREBASE STORAGE + CLOUD FUNCTIONS

**Tempo estimado:** 2-3 horas  
**Prioridade:** 🔴 CRÍTICA  
**Para:** Sistema de Verificação de Perfil e Upload de Certificados

## PASSO 1: Configurar Firebase Storage (20 min)

### 1.1 Inicializar Storage

```bash
# 1. Login no Firebase
firebase login

# 2. Navegar para o projeto
cd C:\workspaces\fabiocdssilva69-prog\barbergo

# 3. Inicializar Storage
firebase init storage

# Quando perguntar "What file should be used for Storage Rules?":
# Responder: storage.rules
```

### 1.2 Criar Regras de Storage

**Criar arquivo:** `storage.rules` (na raiz do projeto)

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // ========================================
    // VERIFICAÇÃO DE DOCUMENTOS
    // ========================================
    match /verifications/{userId}/{document} {
      // Leitura: Qualquer usuário autenticado
      allow read: if request.auth != null;
      
      // Escrita: Apenas o próprio usuário
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024 // 5MB máximo
                   && request.resource.contentType.matches('image/.*'); // Apenas imagens
    }
    
    // ========================================
    // CERTIFICADOS DE CURSOS
    // ========================================
    match /certificates/{userId}/{certId} {
      // Leitura: Qualquer usuário autenticado (para ver no perfil)
      allow read: if request.auth != null;
      
      // Escrita: Apenas o próprio usuário
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024 // 5MB máximo
                   && (request.resource.contentType.matches('image/.*') 
                       || request.resource.contentType == 'application/pdf');
    }
    
    // ========================================
    // PORTFÓLIO (fotos de trabalhos)
    // ========================================
    match /portfolio/{userId}/{imageId} {
      // Leitura: Público (para exibir nos perfis)
      allow read: if true;
      
      // Escrita: Apenas o próprio usuário
      allow write: if request.auth != null 
                    && request.auth.uid == userId
                    && request.resource.size < 5 * 1024 * 1024 // 5MB máximo
                    && request.resource.contentType.matches('image/.*');
    }
    
    // ========================================
    // FOTOS DE PERFIL
    // ========================================
    match /profile_photos/{userId}/{photoId} {
      // Leitura: Público
      allow read: if true;
      
      // Escrita: Apenas o próprio usuário
      allow write: if request.auth != null 
                    && request.auth.uid == userId
                    && request.resource.size < 3 * 1024 * 1024 // 3MB máximo
                    && request.resource.contentType.matches('image/.*');
    }
    
    // ========================================
    // CHAT - ANEXOS E IMAGENS
    // ========================================
    match /chat_attachments/{chatId}/{messageId} {
      // Leitura: Apenas participantes do chat
      allow read: if request.auth != null; // TODO: Validar participação no chat
      
      // Escrita: Usuários autenticados
      allow write: if request.auth != null 
                    && request.resource.size < 10 * 1024 * 1024 // 10MB máximo
                    && (request.resource.contentType.matches('image/.*')
                        || request.resource.contentType.matches('application/.*'));
    }
  }
}
```

### 1.3 Deploy das Regras

```bash
firebase deploy --only storage
```

**Resultado esperado:**

```
✔ Deploy complete!

Resources:
  storage: deployed
```

---

## PASSO 2: Criar Cloud Functions (1-2h)

### 2.1 Criar Arquivo de Verificação

**Criar arquivo:** `functions/src/verification.ts`

```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Inicializar Admin (se ainda não foi feito)
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();
const messaging = admin.messaging();

// ========================================
// PROCESSAR NOVA VERIFICAÇÃO SUBMETIDA
// ========================================
export const processVerification = functions.firestore
  .document('verifications/{verificationId}')
  .onCreate(async (snap, context) => {
    const verificationId = context.params.verificationId;
    const data = snap.data();
    
    console.log(`📋 Nova verificação recebida: ${verificationId}`);
    console.log(`👤 Usuário: ${data.userId}`);
    console.log(`📄 Tipo: ${data.documentType}`);
    
    try {
      // 1. Atualizar status inicial
      await snap.ref.update({
        status: 'pending',
        submittedAt: admin.firestore.FieldValue.serverTimestamp(),
        processedAt: null,
      });
      
      // 2. Criar task para admin revisar
      await db.collection('admin_tasks').add({
        type: 'verification_review',
        userId: data.userId,
        verificationId: verificationId,
        documentUrl: data.documentUrl,
        documentType: data.documentType,
        status: 'pending',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      // 3. Enviar notificação para o usuário
      const userDoc = await db.collection('users').doc(data.userId).get();
      const fcmToken = userDoc.data()?.fcmToken;
      
      if (fcmToken) {
        await messaging.send({
          token: fcmToken,
          notification: {
            title: '📋 Verificação Recebida',
            body: 'Sua solicitação de verificação está em análise. Pode levar até 48h.',
          },
          data: {
            type: 'verification_received',
            verificationId: verificationId,
          },
        });
      }
      
      console.log(`✅ Verificação processada com sucesso: ${verificationId}`);
      return { success: true };
      
    } catch (error) {
      console.error(`❌ Erro ao processar verificação ${verificationId}:`, error);
      
      // Marcar como erro
      await snap.ref.update({
        status: 'error',
        error: String(error),
      });
      
      throw error;
    }
  });

// ========================================
// APROVAR VERIFICAÇÃO (Chamado por Admin)
// ========================================
export const approveVerification = functions.https.onCall(async (data, context) => {
  console.log('✅ Tentativa de aprovar verificação:', data);
  
  // 1. Validar autenticação
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Usuário não autenticado'
    );
  }
  
  // 2. Validar se é admin
  const callerDoc = await db.collection('users').doc(context.auth.uid).get();
  const isAdmin = callerDoc.data()?.role === 'admin' || callerDoc.data()?.isAdmin === true;
  
  if (!isAdmin) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Apenas administradores podem aprovar verificações'
    );
  }
  
  const { userId, verificationId } = data;
  
  if (!userId || !verificationId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'userId e verificationId são obrigatórios'
    );
  }
  
  try {
    console.log(`👤 Admin ${context.auth.uid} aprovando verificação de ${userId}`);
    
    // 3. Atualizar documento de verificação
    await db.collection('verifications').doc(verificationId).update({
      status: 'approved',
      approvedAt: admin.firestore.FieldValue.serverTimestamp(),
      approvedBy: context.auth.uid,
      processedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    // 4. Atualizar perfil do usuário
    await db.collection('profiles').doc(userId).update({
      isVerified: true,
      verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    // 5. Atualizar documento de usuário (se existir)
    const userRef = db.collection('users').doc(userId);
    const userDoc = await userRef.get();
    
    if (userDoc.exists) {
      await userRef.update({
        isVerified: true,
        verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
    
    // 6. Atualizar task do admin
    const adminTasks = await db.collection('admin_tasks')
      .where('verificationId', '==', verificationId)
      .where('status', '==', 'pending')
      .get();
    
    const batch = db.batch();
    adminTasks.docs.forEach(doc => {
      batch.update(doc.ref, {
        status: 'completed',
        completedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });
    await batch.commit();
    
    // 7. Enviar notificação para o usuário
    const fcmToken = userDoc.data()?.fcmToken;
    
    if (fcmToken) {
      await messaging.send({
        token: fcmToken,
        notification: {
          title: '✅ Perfil Verificado!',
          body: 'Parabéns! Seu perfil foi verificado com sucesso. Agora você tem o badge de verificado!',
        },
        data: {
          type: 'verification_approved',
          verificationId: verificationId,
        },
      });
    }
    
    console.log(`✅ Verificação ${verificationId} aprovada com sucesso`);
    return { success: true, message: 'Verificação aprovada com sucesso' };
    
  } catch (error) {
    console.error('❌ Erro ao aprovar verificação:', error);
    throw new functions.https.HttpsError(
      'internal',
      `Erro ao aprovar verificação: ${error}`
    );
  }
});

// ========================================
// REJEITAR VERIFICAÇÃO (Chamado por Admin)
// ========================================
export const rejectVerification = functions.https.onCall(async (data, context) => {
  console.log('❌ Tentativa de rejeitar verificação:', data);
  
  // 1. Validar autenticação
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Usuário não autenticado'
    );
  }
  
  // 2. Validar se é admin
  const callerDoc = await db.collection('users').doc(context.auth.uid).get();
  const isAdmin = callerDoc.data()?.role === 'admin' || callerDoc.data()?.isAdmin === true;
  
  if (!isAdmin) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Apenas administradores podem rejeitar verificações'
    );
  }
  
  const { userId, verificationId, reason } = data;
  
  if (!userId || !verificationId || !reason) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'userId, verificationId e reason são obrigatórios'
    );
  }
  
  try {
    console.log(`👤 Admin ${context.auth.uid} rejeitando verificação de ${userId}`);
    
    // 3. Atualizar documento de verificação
    await db.collection('verifications').doc(verificationId).update({
      status: 'rejected',
      rejectedAt: admin.firestore.FieldValue.serverTimestamp(),
      rejectedBy: context.auth.uid,
      rejectionReason: reason,
      processedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    // 4. Atualizar task do admin
    const adminTasks = await db.collection('admin_tasks')
      .where('verificationId', '==', verificationId)
      .where('status', '==', 'pending')
      .get();
    
    const batch = db.batch();
    adminTasks.docs.forEach(doc => {
      batch.update(doc.ref, {
        status: 'rejected',
        completedAt: admin.firestore.FieldValue.serverTimestamp(),
        rejectionReason: reason,
      });
    });
    await batch.commit();
    
    // 5. Enviar notificação para o usuário
    const userDoc = await db.collection('users').doc(userId).get();
    const fcmToken = userDoc.data()?.fcmToken;
    
    if (fcmToken) {
      await messaging.send({
        token: fcmToken,
        notification: {
          title: '❌ Verificação Rejeitada',
          body: `Sua verificação foi rejeitada. Motivo: ${reason}`,
        },
        data: {
          type: 'verification_rejected',
          verificationId: verificationId,
          reason: reason,
        },
      });
    }
    
    console.log(`❌ Verificação ${verificationId} rejeitada com sucesso`);
    return { success: true, message: 'Verificação rejeitada' };
    
  } catch (error) {
    console.error('❌ Erro ao rejeitar verificação:', error);
    throw new functions.https.HttpsError(
      'internal',
      `Erro ao rejeitar verificação: ${error}`
    );
  }
});
```

### 2.2 Adicionar Exports no Index

**Editar arquivo:** `functions/src/index.ts`

Adicionar no início:

```typescript
// Importar funções de verificação
export {
  processVerification,
  approveVerification,
  rejectVerification,
} from './verification';
```

### 2.3 Instalar Dependências

```bash
cd functions
npm install
cd ..
```

### 2.4 Deploy das Functions

```bash
firebase deploy --only functions:processVerification,functions:approveVerification,functions:rejectVerification
```

**Resultado esperado:**

```
✔ functions[processVerification(us-central1)]: Successful create operation.
✔ functions[approveVerification(us-central1)]: Successful create operation.
✔ functions[rejectVerification(us-central1)]: Successful create operation.

✔ Deploy complete!
```

### 2.5 Verificar Deploy

```bash
firebase functions:list
```

**Deve mostrar:**

```
processVerification
approveVerification
rejectVerification
```

---

## PASSO 3: Testar Storage (10 min)

### 3.1 Teste Manual no Console

1. Acesse: <https://console.firebase.google.com/>
2. Selecione o projeto BarberGO
3. Vá em **Storage** → **Files**
4. Tente fazer upload de uma imagem teste
5. Verifique se as regras estão aplicadas

### 3.2 Teste via CLI (Opcional)

```bash
# Ver buckets disponíveis
firebase storage:buckets:list

# Ver arquivos
gsutil ls gs://YOUR_BUCKET_NAME
```

---

# 2️⃣ GOOGLE MAPS API KEY

**Tempo estimado:** 30 minutos  
**Prioridade:** 🟡 MÉDIA (necessário para Mapa Interativo)  
**Para:** Exibir perfis e vagas em mapa

## PASSO 1: Acessar Google Cloud Console

1. Acesse: <https://console.cloud.google.com/>
2. Faça login com a conta do projeto
3. Selecione o projeto BarberGO (ou crie um novo)

---

## PASSO 2: Habilitar APIs Necessárias

### 2.1 Acessar API Library

- Menu lateral → **APIs & Services** → **Library**

### 2.2 Habilitar as seguintes APIs

1. **Maps SDK for Android**
   - Pesquisar: "Maps SDK for Android"
   - Clicar em **ENABLE**

2. **Maps SDK for iOS**
   - Pesquisar: "Maps SDK for iOS"
   - Clicar em **ENABLE**

3. **Maps JavaScript API** (para web)
   - Pesquisar: "Maps JavaScript API"
   - Clicar em **ENABLE**

4. **Geocoding API**
   - Pesquisar: "Geocoding API"
   - Clicar em **ENABLE**

5. **Places API**
   - Pesquisar: "Places API"
   - Clicar em **ENABLE**

**Aguardar:** Cada API leva ~1 min para ativar

---

## PASSO 3: Criar API Key

### 3.1 Criar Credencial

1. Menu lateral → **APIs & Services** → **Credentials**
2. Clicar em **+ CREATE CREDENTIALS**
3. Selecionar **API Key**
4. **COPIAR A CHAVE GERADA** (exemplo: `AIzaSyB1a2c3...`)

---

## PASSO 4: Restringir API Key (SEGURANÇA CRÍTICA)

### 4.1 Clicar na chave criada para editar

### 4.2 Application restrictions

**Opção 1: Android apps**

```
Adicionar item:
- Package name: br.com.barbergo.app
- SHA-1 certificate fingerprint: [obter do keystore]
```

**Como obter SHA-1:**

```bash
# Para debug (desenvolvimento)
cd android
./gradlew signingReport

# Copiar o SHA-1 do "Variant: debug"
```

**Opção 2: iOS apps**

```
Adicionar item:
- Bundle ID: br.com.barbergo.app
```

**Opção 3: Websites** (para Flutter Web)

```
Adicionar item:
- Website URL: https://barbergo.com.br/*
```

### 4.3 API restrictions

Selecionar: **Restrict key**

Marcar apenas:

- ✅ Maps SDK for Android
- ✅ Maps SDK for iOS
- ✅ Maps JavaScript API
- ✅ Geocoding API
- ✅ Places API

### 4.4 Salvar

Clicar em **SAVE**

---

## PASSO 5: Adicionar ao Projeto

### 5.1 Criar arquivo .env (na raiz do projeto)

**Criar arquivo:** `.env`

```env
# Google Maps API Key
GOOGLE_MAPS_API_KEY=AIzaSyB1a2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q

# Substituir pela chave real gerada acima ^^^
```

### 5.2 Adicionar ao .gitignore

**Editar:** `.gitignore`

Adicionar:

```
.env
```

### 5.3 Configurar Android

**Editar:** `android/app/src/main/AndroidManifest.xml`

Adicionar dentro de `<application>`:

```xml
<application>
  <!-- Conteúdo existente... -->
  
  <!-- Google Maps API Key -->
  <meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="${GOOGLE_MAPS_API_KEY}"/>
    
</application>
```

### 5.4 Configurar iOS

**Editar:** `ios/Runner/AppDelegate.swift`

Adicionar no início:

```swift
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Google Maps
    GMSServices.provideAPIKey("AIzaSyB1a2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q")
    // ^^^ Substituir pela chave real
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

---

## PASSO 6: Compartilhar Chave com Desenvolvedor

**Enviar para o desenvolvedor Flutter:**

```
✅ GOOGLE MAPS API KEY CRIADA

Chave: AIzaSyB1a2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q

APIs habilitadas:
- Maps SDK for Android ✅
- Maps SDK for iOS ✅
- Maps JavaScript API ✅
- Geocoding API ✅
- Places API ✅

Restrições aplicadas:
- Android: br.com.barbergo.app
- iOS: br.com.barbergo.app

⚠️ IMPORTANTE: Adicionar ao .env e NÃO COMMITAR!
```

---

# 3️⃣ FIRESTORE INDEXES

**Tempo estimado:** 15 minutos  
**Prioridade:** 🟢 BAIXA (necessário para Filtros Avançados)  
**Para:** Queries complexas com múltiplos filtros

## PASSO 1: Atualizar firestore.indexes.json

**Editar arquivo:** `firestore.indexes.json`

```json
{
  "indexes": [
    {
      "collectionGroup": "profiles",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "accountType", "order": "ASCENDING" },
        { "fieldPath": "isVerified", "order": "ASCENDING" },
        { "fieldPath": "hourlyRate", "order": "ASCENDING" },
        { "fieldPath": "rating", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "profiles",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "accountType", "order": "ASCENDING" },
        { "fieldPath": "services", "arrayConfig": "CONTAINS" },
        { "fieldPath": "rating", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "profiles",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "accountType", "order": "ASCENDING" },
        { "fieldPath": "rating", "order": "DESCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "vacancies",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "type", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "vacancies",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "location", "order": "ASCENDING" },
        { "fieldPath": "salary", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "swipes",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "action", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "matches",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "users", "arrayConfig": "CONTAINS" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "chats",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "participants", "arrayConfig": "CONTAINS" },
        { "fieldPath": "lastMessageAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "verifications",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "submittedAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "admin_tasks",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "type", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ],
  "fieldOverrides": []
}
```

---

## PASSO 2: Deploy dos Indexes

```bash
firebase deploy --only firestore:indexes
```

**Resultado esperado:**

```
✔ firestore: released indexes in firestore.indexes.json successfully

✔ Deploy complete!
```

---

## PASSO 3: Aguardar Criação (5-10 min)

Os índices são criados de forma assíncrona no Firebase.

### 3.1 Verificar status

```bash
firebase firestore:indexes
```

**Status possíveis:**

- 🟡 `CREATING` - Aguardar
- 🟢 `ACTIVE` - Pronto para uso
- 🔴 `ERROR` - Verificar configuração

### 3.2 Verificar no Console

1. Acesse: <https://console.firebase.google.com/>
2. Selecione o projeto
3. **Firestore Database** → **Indexes**
4. Aguardar até todos estarem `ACTIVE`

---

# ✅ CHECKLIST FINAL

## Firebase Storage + Functions

```
[ ] firebase init storage
[ ] Criar storage.rules
[ ] firebase deploy --only storage
[ ] Criar functions/src/verification.ts
[ ] Adicionar exports em functions/src/index.ts
[ ] cd functions && npm install
[ ] firebase deploy --only functions:processVerification,functions:approveVerification,functions:rejectVerification
[ ] firebase functions:list (verificar)
[ ] Teste de upload no Console Firebase
```

## Google Maps API Key

```
[ ] Acessar https://console.cloud.google.com/
[ ] Habilitar 5 APIs (Maps Android/iOS/JS, Geocoding, Places)
[ ] Criar API Key
[ ] Copiar chave
[ ] Restringir por app (Android SHA-1, iOS Bundle ID)
[ ] Restringir por APIs (selecionar apenas as 5)
[ ] Criar .env com a chave
[ ] Adicionar .env ao .gitignore
[ ] Configurar AndroidManifest.xml
[ ] Configurar AppDelegate.swift
[ ] Enviar chave para desenvolvedor
```

## Firestore Indexes

```
[ ] Atualizar firestore.indexes.json
[ ] firebase deploy --only firestore:indexes
[ ] Aguardar criação (5-10 min)
[ ] firebase firestore:indexes (verificar ACTIVE)
[ ] Verificar no Console Firebase
```

---

# 📞 COMANDOS ÚTEIS

## Verificação de Status

```bash
# Ver projetos Firebase
firebase projects:list

# Ver functions deployadas
firebase functions:list

# Ver status dos indexes
firebase firestore:indexes

# Ver buckets de Storage
firebase storage:buckets:list
```

## Logs e Debug

```bash
# Ver logs das functions em tempo real
firebase functions:log --follow

# Ver logs de uma function específica
firebase functions:log --only approveVerification

# Ver últimos 100 logs
firebase functions:log --limit 100
```

## Teste Local (antes do deploy)

```bash
# Testar functions localmente
cd functions
npm run serve

# Emulador completo (Firebase + Firestore + Storage)
firebase emulators:start
```

## Rollback se der erro

```bash
# Deletar function problemática
firebase functions:delete FUNCTION_NAME --force

# Re-deploy
firebase deploy --only functions:FUNCTION_NAME
```

## Limpar e Reinstalar

```bash
# Se houver erro nas functions
cd functions
rm -rf node_modules package-lock.json
npm install
cd ..
```

---

# 🚨 PROBLEMAS COMUNS

## Erro: "Permission denied" no Storage

**Solução:**

```bash
# Verificar regras
firebase deploy --only storage

# Testar no Console: https://console.firebase.google.com/ → Storage
```

## Erro: "Function deployment failed"

**Solução:**

```bash
cd functions
npm install
npm run build

# Verificar erros de TypeScript
npx tsc --noEmit

# Re-deploy
firebase deploy --only functions
```

## Erro: "Index creation failed"

**Solução:**

```bash
# Verificar sintaxe do JSON
cat firestore.indexes.json | jq

# Re-deploy
firebase deploy --only firestore:indexes
```

## Google Maps não aparece no app

**Solução:**

1. Verificar se API Key está correta
2. Verificar se APIs estão habilitadas
3. Verificar restrições (SHA-1 correto?)
4. Aguardar ~5 min após habilitar APIs

---

# 📊 RESUMO EXECUTIVO

## Tempo Total Estimado

```
Firebase Storage + Functions:  2-3h
Google Maps API Key:           30min
Firestore Indexes:             15min
────────────────────────────────────
TOTAL:                         3-4h
```

## Prioridades

```
🔴 CRÍTICO:
   - Firebase Storage + Functions
   (necessário para verificação de perfil)

🟡 IMPORTANTE:
   - Google Maps API Key
   (necessário para mapa interativo)

🟢 DESEJÁVEL:
   - Firestore Indexes
   (melhora performance dos filtros)
```

## Após Completar

**Enviar para o desenvolvedor Flutter:**

```
✅ AMBIENTES EXTERNOS CONFIGURADOS

Firebase Storage:
- Regras deployadas
- 3 Functions ativas: processVerification, approveVerification, rejectVerification

Google Maps:
- API Key: AIzaSy...
- 5 APIs habilitadas
- Restrições aplicadas

Firestore:
- 10 indexes criados
- Status: ACTIVE

Próximo passo: Implementar código Flutter!
```

---

**Status:** 🔴 AGUARDANDO EXECUÇÃO  
**Prioridade:** ALTA  
**Deadline:** O quanto antes (bloqueia desenvolvimento Flutter)

🚀 **PODE COMEÇAR AGORA!**
