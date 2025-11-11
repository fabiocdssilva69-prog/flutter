# 🔥 DELEGAÇÃO COMPLETA: Firebase Setup para Features Premium

**Data:** 1 de Novembro de 2025  
**Destinatário:** Agente Coding / Dev Team  
**Prazo:** 1 hora (tudo de uma vez)  
**Objetivo:** Preparar Firebase para sistema de monetização completo

---

## � INÍCIO RÁPIDO

**Antes de começar, você precisa das Stripe Keys!**

### Não tem as Stripe Keys ainda?
📖 Leia: **`GUIA_OBTER_STRIPE_KEYS.md`** (15 min)

### Já tem as Stripe Keys?
⚡ Execute: **`PROMPTS_STRIPE_CONFIG.md`** (copie e cole os comandos)

### Quer automatizar tudo?
🤖 Execute: `.\firebase_setup_automated.ps1` (o script pergunta as keys)

---

## �📋 RESUMO EXECUTIVO

Precisamos preparar o Firebase para implementar 3 features premium:

1. **Super Like System** (1 grátis/dia, ilimitado no Premium)
2. **Ver Quem Curtiu Você** (blur para free, completo para premium)
3. **Sistema de Assinatura Premium** (R$ 19,90/mês)

**Escopo Total:**

- 4 novas collections no Firestore
- 5 novos indexes compostos
- 8 novas regras de segurança
- 3 Cloud Functions (webhooks)
- 1 extensão Firebase (Stripe)

---

## 🗄️ PARTE 1: FIRESTORE - COLLECTIONS & SCHEMAS

### **1.1 Collection: `subscriptions`**

**Caminho:** `/subscriptions/{userId}`

**Documento Schema:**

```json
{
  "userId": "string (mesmo ID do documento)",
  "plan": "string (monthly | yearly | free)",
  "status": "string (active | canceled | expired | trial)",
  "startedAt": "timestamp",
  "expiresAt": "timestamp",
  "autoRenew": "boolean",
  "canceledAt": "timestamp | null",
  "stripeCustomerId": "string | null",
  "stripeSubscriptionId": "string | null",
  "paymentMethod": "string (stripe | google_play | apple_iap)",
  "features": {
    "superLikesRemaining": "number",
    "boostsRemaining": "number",
    "canSeeWhoLiked": "boolean",
    "hasAdvancedFilters": "boolean"
  },
  "metadata": {
    "createdAt": "timestamp",
    "updatedAt": "timestamp",
    "version": "number"
  }
}
```

**Exemplo de Documento:**

```json
{
  "userId": "abc123",
  "plan": "monthly",
  "status": "active",
  "startedAt": "2025-11-01T10:00:00Z",
  "expiresAt": "2025-12-01T10:00:00Z",
  "autoRenew": true,
  "canceledAt": null,
  "stripeCustomerId": "cus_ABC123",
  "stripeSubscriptionId": "sub_XYZ789",
  "paymentMethod": "stripe",
  "features": {
    "superLikesRemaining": -1,
    "boostsRemaining": 1,
    "canSeeWhoLiked": true,
    "hasAdvancedFilters": true
  },
  "metadata": {
    "createdAt": "2025-11-01T10:00:00Z",
    "updatedAt": "2025-11-01T10:00:00Z",
    "version": 1
  }
}
```

**Indexes Necessários:**

```
Collection: subscriptions
Fields: status (ASC), expiresAt (ASC)
Scope: Collection

Collection: subscriptions
Fields: stripeCustomerId (ASC), status (ASC)
Scope: Collection
```

---

### **1.2 Collection: `super_likes`**

**Caminho:** `/super_likes/{superLikeId}`

**Documento Schema:**

```json
{
  "superLikeId": "string (auto-generated)",
  "fromUserId": "string",
  "toUserId": "string",
  "createdAt": "timestamp",
  "notified": "boolean (se já enviou notificação)",
  "viewed": "boolean (se destinatário já viu)",
  "viewedAt": "timestamp | null",
  "resultedInMatch": "boolean",
  "matchId": "string | null"
}
```

**Exemplo de Documento:**

```json
{
  "superLikeId": "sl_abc123",
  "fromUserId": "user_barbeiro_123",
  "toUserId": "user_barbearia_456",
  "createdAt": "2025-11-01T14:30:00Z",
  "notified": true,
  "viewed": false,
  "viewedAt": null,
  "resultedInMatch": false,
  "matchId": null
}
```

**Indexes Necessários:**

```
Collection: super_likes
Fields: toUserId (ASC), viewed (ASC), createdAt (DESC)
Scope: Collection

Collection: super_likes
Fields: fromUserId (ASC), createdAt (DESC)
Scope: Collection
```

---

### **1.3 Collection: `daily_limits`**

**Caminho:** `/daily_limits/{userId}_{date}`

**Documento Schema:**

```json
{
  "userId": "string",
  "date": "string (YYYY-MM-DD)",
  "superLikesUsed": "number",
  "swipesUsed": "number",
  "likesGiven": "number",
  "resetAt": "timestamp (próxima meia-noite)",
  "isPremium": "boolean (cache do status)",
  "metadata": {
    "createdAt": "timestamp",
    "updatedAt": "timestamp"
  }
}
```

**Exemplo de Documento:**

```json
{
  "userId": "abc123",
  "date": "2025-11-01",
  "superLikesUsed": 1,
  "swipesUsed": 47,
  "likesGiven": 23,
  "resetAt": "2025-11-02T00:00:00Z",
  "isPremium": false,
  "metadata": {
    "createdAt": "2025-11-01T08:00:00Z",
    "updatedAt": "2025-11-01T14:30:00Z"
  }
}
```

**Indexes Necessários:**

```
Collection: daily_limits
Fields: userId (ASC), date (DESC)
Scope: Collection
```

---

### **1.4 Collection: `boost_activations`**

**Caminho:** `/boost_activations/{boostId}`

**Documento Schema:**

```json
{
  "boostId": "string (auto-generated)",
  "userId": "string",
  "startedAt": "timestamp",
  "expiresAt": "timestamp",
  "duration": "number (minutos, default 30)",
  "status": "string (active | expired)",
  "viewsCount": "number (quantas vezes foi visto)",
  "likesReceived": "number (likes recebidos durante boost)",
  "matchesGenerated": "number (matches durante boost)",
  "metadata": {
    "createdAt": "timestamp",
    "cost": "number (boosts gastos)"
  }
}
```

**Exemplo de Documento:**

```json
{
  "boostId": "boost_abc123",
  "userId": "user_123",
  "startedAt": "2025-11-01T15:00:00Z",
  "expiresAt": "2025-11-01T15:30:00Z",
  "duration": 30,
  "status": "active",
  "viewsCount": 47,
  "likesReceived": 12,
  "matchesGenerated": 3,
  "metadata": {
    "createdAt": "2025-11-01T15:00:00Z",
    "cost": 1
  }
}
```

**Indexes Necessários:**

```
Collection: boost_activations
Fields: userId (ASC), status (ASC), expiresAt (DESC)
Scope: Collection

Collection: boost_activations
Fields: status (ASC), expiresAt (ASC)
Scope: Collection (para query de boosts ativos)
```

---

### **1.5 Modificar Collection Existente: `swipes`**

**ADICIONAR campos novos:**

```json
{
  // ... campos existentes (swipeId, fromUserId, toUserId, liked, createdAt)
  "isSuperLike": "boolean", // 🆕 NOVO
  "superLikeId": "string | null" // 🆕 NOVO (referência se foi super like)
}
```

**Index ADICIONAL necessário:**

```
Collection: swipes
Fields: toUserId (ASC), liked (ASC), isSuperLike (DESC), createdAt (DESC)
Scope: Collection
```

---

### **1.6 Modificar Collection Existente: `profiles`**

**ADICIONAR campos novos:**

```json
{
  // ... campos existentes
  "isPremium": "boolean", // 🆕 NOVO (cache do status premium)
  "premiumSince": "timestamp | null", // 🆕 NOVO
  "boostedUntil": "timestamp | null", // 🆕 NOVO (até quando está em boost)
  "boostsRemaining": "number", // 🆕 NOVO (quantos boosts tem disponível)
  "subscriptionTier": "string (free | premium | premium_plus)" // 🆕 NOVO
}
```

---

## 🔒 PARTE 2: FIRESTORE RULES

**Arquivo:** `firestore.rules`

**ADICIONAR estas regras:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ============================================
    // HELPER FUNCTIONS
    // ============================================
    
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    function isPremiumUser() {
      return isAuthenticated() && 
             get(/databases/$(database)/documents/profiles/$(request.auth.uid)).data.isPremium == true;
    }
    
    function hasValidSubscription() {
      let sub = get(/databases/$(database)/documents/subscriptions/$(request.auth.uid)).data;
      return sub.status == 'active' && sub.expiresAt > request.time;
    }
    
    // ============================================
    // SUBSCRIPTIONS
    // ============================================
    
    match /subscriptions/{userId} {
      // Usuário pode ler apenas sua própria assinatura
      allow read: if isOwner(userId);
      
      // Apenas Cloud Functions podem criar/atualizar (via Stripe webhook)
      allow create: if false; // Bloqueado para clientes
      allow update: if false; // Bloqueado para clientes
      
      // Usuário pode cancelar (setar autoRenew = false)
      allow update: if isOwner(userId) && 
                       request.resource.data.diff(resource.data).affectedKeys().hasOnly(['autoRenew', 'canceledAt', 'metadata.updatedAt']) &&
                       request.resource.data.autoRenew == false;
      
      // Nunca pode deletar
      allow delete: if false;
    }
    
    // ============================================
    // SUPER LIKES
    // ============================================
    
    match /super_likes/{superLikeId} {
      // Usuário pode ler super likes RECEBIDOS por ele
      allow read: if isAuthenticated() && 
                     resource.data.toUserId == request.auth.uid;
      
      // Usuário pode ler super likes ENVIADOS por ele
      allow read: if isAuthenticated() && 
                     resource.data.fromUserId == request.auth.uid;
      
      // Usuário pode criar super like se:
      // 1. É autenticado
      // 2. fromUserId é ele mesmo
      // 3. Não ultrapassou limite diário (verificado no backend)
      allow create: if isAuthenticated() && 
                       request.resource.data.fromUserId == request.auth.uid;
      
      // Pode atualizar apenas campos 'viewed' e 'viewedAt' (quando visualiza)
      allow update: if isAuthenticated() && 
                       resource.data.toUserId == request.auth.uid &&
                       request.resource.data.diff(resource.data).affectedKeys().hasOnly(['viewed', 'viewedAt']);
      
      // Nunca pode deletar
      allow delete: if false;
    }
    
    // ============================================
    // DAILY LIMITS
    // ============================================
    
    match /daily_limits/{limitId} {
      // Formato: {userId}_{date}
      // Apenas o próprio usuário pode ler seus limites
      allow read: if isAuthenticated() && 
                     resource.data.userId == request.auth.uid;
      
      // Sistema (Cloud Function) cria limites
      allow create: if false; // Bloqueado para clientes, só backend
      
      // Sistema (Cloud Function) atualiza limites
      allow update: if false; // Bloqueado para clientes, só backend
      
      // Nunca pode deletar
      allow delete: if false;
    }
    
    // ============================================
    // BOOST ACTIVATIONS
    // ============================================
    
    match /boost_activations/{boostId} {
      // Usuário pode ler apenas seus próprios boosts
      allow read: if isAuthenticated() && 
                     resource.data.userId == request.auth.uid;
      
      // Usuário pode criar boost se:
      // 1. É autenticado
      // 2. userId é ele mesmo
      // 3. Tem boosts disponíveis (verificado no backend)
      allow create: if isAuthenticated() && 
                       request.resource.data.userId == request.auth.uid;
      
      // Sistema atualiza contadores (viewsCount, likesReceived, etc)
      allow update: if false; // Bloqueado para clientes, só backend
      
      // Nunca pode deletar
      allow delete: if false;
    }
    
    // ============================================
    // SWIPES (modificar regra existente)
    // ============================================
    
    match /swipes/{swipeId} {
      // ... regras existentes ...
      
      // ADICIONAR validação para super like
      allow create: if isAuthenticated() && 
                       request.resource.data.fromUserId == request.auth.uid &&
                       // Se é super like, deve ter criado super_like doc também
                       (!request.resource.data.isSuperLike || 
                        exists(/databases/$(database)/documents/super_likes/$(request.resource.data.superLikeId)));
    }
    
    // ============================================
    // PROFILES (modificar regra existente)
    // ============================================
    
    match /profiles/{userId} {
      // ... regras existentes ...
      
      // Usuário pode atualizar boostedUntil e boostsRemaining via backend
      // mas não diretamente (só através de Cloud Function ao ativar boost)
      allow update: if isOwner(userId) && 
                       !request.resource.data.diff(resource.data).affectedKeys().hasAny(['isPremium', 'premiumSince', 'boostedUntil', 'boostsRemaining', 'subscriptionTier']);
    }
  }
}
```

---

## ☁️ PARTE 3: CLOUD FUNCTIONS

### **3.1 Function: `stripeWebhook`**

**Trigger:** HTTPS (POST)  
**Endpoint:** `https://us-central1-{project-id}.cloudfunctions.net/stripeWebhook`

**Eventos Stripe para escutar:**

- `customer.subscription.created`
- `customer.subscription.updated`
- `customer.subscription.deleted`
- `invoice.payment_succeeded`
- `invoice.payment_failed`

**Código (Node.js):**

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')(functions.config().stripe.secret_key);

admin.initializeApp();
const db = admin.firestore();

exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const webhookSecret = functions.config().stripe.webhook_secret;
  
  let event;
  
  try {
    event = stripe.webhooks.constructEvent(req.rawBody, sig, webhookSecret);
  } catch (err) {
    console.error('Webhook signature verification failed:', err);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }
  
  // Handle event
  switch (event.type) {
    case 'customer.subscription.created':
    case 'customer.subscription.updated':
      await handleSubscriptionUpdate(event.data.object);
      break;
      
    case 'customer.subscription.deleted':
      await handleSubscriptionCanceled(event.data.object);
      break;
      
    case 'invoice.payment_succeeded':
      await handlePaymentSucceeded(event.data.object);
      break;
      
    case 'invoice.payment_failed':
      await handlePaymentFailed(event.data.object);
      break;
      
    default:
      console.log(`Unhandled event type: ${event.type}`);
  }
  
  res.json({ received: true });
});

async function handleSubscriptionUpdate(subscription) {
  const customerId = subscription.customer;
  
  // Buscar userId pelo stripeCustomerId
  const userQuery = await db.collection('subscriptions')
    .where('stripeCustomerId', '==', customerId)
    .limit(1)
    .get();
  
  if (userQuery.empty) {
    console.error('User not found for customer:', customerId);
    return;
  }
  
  const userId = userQuery.docs[0].id;
  
  // Atualizar subscription
  await db.collection('subscriptions').doc(userId).set({
    userId: userId,
    plan: subscription.items.data[0].price.recurring.interval, // monthly ou yearly
    status: subscription.status, // active, canceled, etc
    startedAt: admin.firestore.Timestamp.fromMillis(subscription.current_period_start * 1000),
    expiresAt: admin.firestore.Timestamp.fromMillis(subscription.current_period_end * 1000),
    autoRenew: !subscription.cancel_at_period_end,
    stripeCustomerId: customerId,
    stripeSubscriptionId: subscription.id,
    paymentMethod: 'stripe',
    features: {
      superLikesRemaining: -1, // ilimitado
      boostsRemaining: 1, // 1 por mês
      canSeeWhoLiked: true,
      hasAdvancedFilters: true
    },
    metadata: {
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      version: admin.firestore.FieldValue.increment(1)
    }
  }, { merge: true });
  
  // Atualizar flag premium no profile
  await db.collection('profiles').doc(userId).update({
    isPremium: subscription.status === 'active',
    premiumSince: admin.firestore.Timestamp.fromMillis(subscription.current_period_start * 1000),
    subscriptionTier: 'premium'
  });
  
  console.log('Subscription updated for user:', userId);
}

async function handleSubscriptionCanceled(subscription) {
  const customerId = subscription.customer;
  
  const userQuery = await db.collection('subscriptions')
    .where('stripeCustomerId', '==', customerId)
    .limit(1)
    .get();
  
  if (userQuery.empty) return;
  
  const userId = userQuery.docs[0].id;
  
  await db.collection('subscriptions').doc(userId).update({
    status: 'canceled',
    autoRenew: false,
    canceledAt: admin.firestore.FieldValue.serverTimestamp()
  });
  
  await db.collection('profiles').doc(userId).update({
    isPremium: false,
    subscriptionTier: 'free'
  });
  
  console.log('Subscription canceled for user:', userId);
}

async function handlePaymentSucceeded(invoice) {
  console.log('Payment succeeded:', invoice.id);
  // Renovação bem-sucedida - subscription já foi atualizada
}

async function handlePaymentFailed(invoice) {
  console.log('Payment failed:', invoice.id);
  // Enviar notificação ao usuário sobre falha no pagamento
}
```

---

### **3.2 Function: `checkExpiredSubscriptions`**

**Trigger:** Cloud Scheduler (cron job)  
**Schedule:** `0 */6 * * *` (a cada 6 horas)

**Código:**

```javascript
exports.checkExpiredSubscriptions = functions.pubsub
  .schedule('0 */6 * * *')
  .timeZone('America/Sao_Paulo')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    
    // Buscar assinaturas expiradas
    const expiredSubs = await db.collection('subscriptions')
      .where('status', '==', 'active')
      .where('expiresAt', '<', now)
      .get();
    
    const batch = db.batch();
    
    for (const doc of expiredSubs.docs) {
      const userId = doc.id;
      
      // Marcar como expired
      batch.update(doc.ref, {
        status: 'expired',
        'metadata.updatedAt': admin.firestore.FieldValue.serverTimestamp()
      });
      
      // Remover flag premium do profile
      const profileRef = db.collection('profiles').doc(userId);
      batch.update(profileRef, {
        isPremium: false,
        subscriptionTier: 'free'
      });
    }
    
    await batch.commit();
    
    console.log(`Marked ${expiredSubs.size} subscriptions as expired`);
  });
```

---

### **3.3 Function: `resetDailyLimits`**

**Trigger:** Cloud Scheduler (cron job)  
**Schedule:** `0 0 * * *` (todo dia à meia-noite)

**Código:**

```javascript
exports.resetDailyLimits = functions.pubsub
  .schedule('0 0 * * *')
  .timeZone('America/Sao_Paulo')
  .onRun(async (context) => {
    // Daily limits são criados sob demanda
    // Não precisa deletar, só expiram automaticamente
    console.log('Daily limits reset (automatic by date)');
  });
```

---

## 🔌 PARTE 4: FIREBASE EXTENSIONS

### **4.1 Instalar Extension: Run Payments with Stripe**

**Nome:** `firestore-stripe-payments`  
**Publisher:** Firebase  
**Versão:** Latest

**Configuração:**

```yaml
# extension.yaml
Stripe API Secret Key: sk_live_... (obtido do Stripe Dashboard)
Products and pricing plans collection: products
Customer details and subscriptions collection: customers
Sync new users to Stripe customers: Yes
Automatically delete Stripe customer objects: No
```

**Produtos a criar no Stripe Dashboard:**

```javascript
// Produto 1: BarberGO Premium Monthly
{
  name: "BarberGO Premium - Mensal",
  description: "Acesso completo a todas features premium",
  prices: [
    {
      unit_amount: 1990, // R$ 19,90
      currency: "brl",
      recurring: {
        interval: "month"
      }
    }
  ]
}

// Produto 2: BarberGO Premium Yearly
{
  name: "BarberGO Premium - Anual",
  description: "12 meses com desconto (economize 20%)",
  prices: [
    {
      unit_amount: 19104, // R$ 191,04 (20% desconto)
      currency: "brl",
      recurring: {
        interval: "year"
      }
    }
  ]
}

// Produto 3: Boosts Pack
{
  name: "5 Boosts",
  description: "Apareça no topo por 30 minutos (5x)",
  prices: [
    {
      unit_amount: 990, // R$ 9,90
      currency: "brl",
      type: "one_time"
    }
  ]
}

// Produto 4: Super Likes Pack
{
  name: "10 Super Likes",
  description: "Destaque-se com super likes extras",
  prices: [
    {
      unit_amount: 890, // R$ 8,90
      currency: "brl",
      type: "one_time"
    }
  ]
}
```

---

## 📱 PARTE 5: FIREBASE CLOUD MESSAGING (Notificações)

### **5.1 Topics para subscrição:**

```javascript
// Todos os usuários
fcm.subscribeToTopic(fcmToken, 'all_users');

// Apenas premium
fcm.subscribeToTopic(fcmToken, 'premium_users');

// Por tipo de conta
fcm.subscribeToTopic(fcmToken, 'barbeiros');
fcm.subscribeToTopic(fcmToken, 'barbearias');
```

### **5.2 Notification Templates:**

**Template 1: Match**

```json
{
  "notification": {
    "title": "🎉 Novo Match!",
    "body": "Você e {{matchName}} se curtiram!",
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "sound": "match_sound.mp3"
  },
  "data": {
    "type": "match",
    "matchId": "{{matchId}}",
    "matchName": "{{matchName}}",
    "matchPhotoUrl": "{{matchPhotoUrl}}",
    "route": "/matches/{{matchId}}"
  }
}
```

**Template 2: Super Like Recebido**

```json
{
  "notification": {
    "title": "⭐ Super Like!",
    "body": "{{senderName}} te deu um Super Like!",
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "sound": "super_like_sound.mp3"
  },
  "data": {
    "type": "super_like",
    "senderId": "{{senderId}}",
    "senderName": "{{senderName}}",
    "superLikeId": "{{superLikeId}}",
    "route": "/profile/{{senderId}}"
  }
}
```

**Template 3: Mensagem Recebida**

```json
{
  "notification": {
    "title": "💬 {{senderName}}",
    "body": "{{messagePreview}}",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  },
  "data": {
    "type": "message",
    "chatId": "{{chatId}}",
    "senderId": "{{senderId}}",
    "route": "/chat/{{chatId}}"
  }
}
```

**Template 4: Inatividade (3 dias)**

```json
{
  "notification": {
    "title": "Volte para o BarberGO! 👋",
    "body": "{{newCount}} novos perfis estão esperando por você",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  },
  "data": {
    "type": "re_engagement",
    "newCount": "{{newCount}}",
    "route": "/discovery"
  }
}
```

**Template 5: Premium Expirando**

```json
{
  "notification": {
    "title": "⚠️ Seu Premium Expira em 3 Dias",
    "body": "Renove agora e continue aproveitando todos os benefícios",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  },
  "data": {
    "type": "subscription_expiring",
    "expiresAt": "{{expiresAt}}",
    "route": "/premium"
  }
}
```

---

## 🔐 PARTE 6: CONFIGURAÇÕES DE SEGURANÇA

### **6.1 Environment Variables (Cloud Functions)**

**Criar no Firebase Functions config:**

```bash
firebase functions:config:set \
  stripe.secret_key="sk_live_..." \
  stripe.webhook_secret="whsec_..." \
  stripe.publishable_key="pk_live_..."

firebase functions:config:set \
  app.name="BarberGO" \
  app.url="https://barbergo.app" \
  app.support_email="suporte@barbergo.app"

firebase functions:config:set \
  notifications.fcm_server_key="..." \
  notifications.vapid_key="..."
```

### **6.2 API Keys Restrictions (Firebase Console)**

**Web API Key:**

- Allowed referrers: `barbergo.app/*`, `*.barbergo.app/*`
- APIs: Firestore, Auth, FCM, Storage

**Android API Key:**

- Package name: `com.barbergo.app`
- SHA-1: (do seu keystore)

**iOS API Key:**

- Bundle ID: `com.barbergo.app`

---

## 📊 PARTE 7: ANALYTICS EVENTS

### **7.1 Custom Events para Firebase Analytics:**

```javascript
// Premium
analytics.logEvent('premium_screen_viewed');
analytics.logEvent('premium_upsell_shown', { location: 'super_like_limit' });
analytics.logEvent('subscription_started', { plan: 'monthly', price: 19.90 });
analytics.logEvent('subscription_canceled');

// Super Like
analytics.logEvent('super_like_sent', { toUserId: '...', isPremium: false });
analytics.logEvent('super_like_received', { fromUserId: '...' });
analytics.logEvent('super_like_limit_reached');

// Ver Quem Curtiu
analytics.logEvent('likes_screen_viewed', { likesCount: 12 });
analytics.logEvent('like_back_pressed', { profileId: '...' });
analytics.logEvent('likes_paywall_shown');

// Boost
analytics.logEvent('boost_activated', { duration: 30 });
analytics.logEvent('boost_purchase', { quantity: 5, price: 9.90 });
analytics.logEvent('boost_views', { viewsCount: 47 });
```

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **FIRESTORE:**

- [ ] Criar collection `subscriptions` com schema especificado
- [ ] Criar collection `super_likes` com schema especificado
- [ ] Criar collection `daily_limits` com schema especificado
- [ ] Criar collection `boost_activations` com schema especificado
- [ ] Adicionar campos `isSuperLike` e `superLikeId` em `swipes`
- [ ] Adicionar campos premium em `profiles` (isPremium, boostedUntil, etc)
- [ ] Criar todos os 5 indexes compostos listados acima
- [ ] Atualizar `firestore.rules` com novas regras de segurança

### **CLOUD FUNCTIONS:**

- [ ] Deploy `stripeWebhook` function
- [ ] Deploy `checkExpiredSubscriptions` function (cron)
- [ ] Deploy `resetDailyLimits` function (cron)
- [ ] Configurar environment variables (Stripe keys)
- [ ] Testar webhook com Stripe CLI

### **STRIPE:**

- [ ] Criar conta Stripe (ou usar existente)
- [ ] Criar 4 produtos (Premium Monthly, Premium Yearly, Boosts, Super Likes)
- [ ] Configurar webhook endpoint apontando para Cloud Function
- [ ] Obter API keys (secret, publishable, webhook secret)
- [ ] Instalar Firebase Extension `firestore-stripe-payments`

### **NOTIFICAÇÕES:**

- [ ] Configurar FCM Server Key
- [ ] Criar 5 notification templates no código
- [ ] Testar envio de notificação de match
- [ ] Testar envio de notificação de super like
- [ ] Configurar cron job para notificações de inatividade

### **ANALYTICS:**

- [ ] Ativar Firebase Analytics no projeto
- [ ] Criar 12 custom events listados
- [ ] Configurar conversions no Google Analytics

### **SECURITY:**

- [ ] Configurar API key restrictions (web, Android, iOS)
- [ ] Ativar App Check (proteção contra abuso)
- [ ] Configurar CORS nas Cloud Functions
- [ ] Revisar todas as Firestore Rules

---

## 🚀 ORDEM DE EXECUÇÃO RECOMENDADA

### **FASE 1: Preparação (15 min)**

1. Criar collections no Firestore (subscriptions, super_likes, daily_limits, boost_activations)
2. Criar indexes compostos
3. Atualizar firestore.rules

### **FASE 2: Stripe Setup (20 min)**

4. Criar conta Stripe
5. Criar 4 produtos
6. Instalar Firebase Extension
7. Configurar webhook endpoint

### **FASE 3: Cloud Functions (15 min)**

8. Deploy das 3 functions
9. Configurar environment variables
10. Testar webhook com Stripe CLI

### **FASE 4: Notificações (10 min)**

11. Configurar FCM
12. Criar notification templates
13. Testar envio de notificação

### **TOTAL:** ~1 hora ⏱️

---

## 📞 SUPORTE & TROUBLESHOOTING

### **Problemas Comuns:**

**1. Webhook não recebe eventos do Stripe:**

- Verificar se URL está correta no Stripe Dashboard
- Verificar se webhook secret está configurado nas env vars
- Testar com `stripe listen --forward-to localhost:5001/...`

**2. Firestore rules negam acesso:**

- Verificar se usuário está autenticado
- Verificar se campo `isPremium` está correto no profile
- Testar rules no Firebase Console > Firestore > Rules > Playground

**3. Notificações não chegam:**

- Verificar se FCM token está salvo no Firestore
- Verificar se permissões foram concedidas no dispositivo
- Testar envio manual pelo Firebase Console

---

## 🎯 RESULTADO ESPERADO

Após completar todas as tarefas acima, teremos:

✅ Sistema de assinatura Premium funcionando (R$ 19,90/mês)  
✅ Super Likes (1 grátis/dia, ilimitado para premium)  
✅ "Ver Quem Curtiu" (blur para free, completo para premium)  
✅ Sistema de Boost (R$ 9,90 por 5 boosts)  
✅ Notificações push estratégicas  
✅ Analytics completo  
✅ Segurança robusta (Firestore Rules + App Check)  
✅ Webhooks Stripe funcionando (renovações automáticas)  

**Pronto para monetizar! 💰🚀**

---

**DELEGAÇÃO PRONTA! Copie este documento inteiro e envie para o agente coding implementar tudo de uma vez.** 📋✅
