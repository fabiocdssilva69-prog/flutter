const functions = require('firebase-functions');
const admin = require('firebase-admin');
// Prioridade: variável de ambiente (live) → functions.config() (fallback)
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY || functions.config().stripe?.secret_key);
const badgeHandler = require('./src/stripe_badge_handler');

admin.initializeApp();
const db = admin.firestore();

// ============================================
// IMPORTAR API ROUTES
// ============================================
const apiRoutes = require('./src/api');
exports.api = apiRoutes.api;

// ============================================
// FUNÇÃO 1: STRIPE WEBHOOK
// ============================================

exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const webhookSecret = functions.config().stripe?.webhook_secret || process.env.STRIPE_WEBHOOK_SECRET;
  
  let event;
  
  try {
    event = stripe.webhooks.constructEvent(req.rawBody, sig, webhookSecret);
  } catch (err) {
    console.error('⚠️  Webhook signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }
  
  console.log('✅ Webhook received:', event.type);
  
  // Handle event
  try {
    switch (event.type) {
      case 'customer.subscription.created':
      case 'customer.subscription.updated':
        // Sistema de badges (Silver/Gold)
        await badgeHandler.handleSubscriptionEvent(event.data.object, event.type);
        // Sistema legacy de premium
        await handleSubscriptionUpdate(event.data.object);
        break;
        
      case 'customer.subscription.deleted':
        // Sistema de badges (Silver/Gold)
        await badgeHandler.handleSubscriptionEvent(event.data.object, event.type);
        // Sistema legacy de premium
        await handleSubscriptionCanceled(event.data.object);
        break;
      
      case 'customer.subscription.trial_will_end':
        await badgeHandler.handleTrialWillEnd(event.data.object);
        break;
        
      case 'invoice.payment_succeeded':
        await handlePaymentSucceeded(event.data.object);
        break;
        
      case 'invoice.payment_failed':
        await handlePaymentFailed(event.data.object);
        break;
      
      case 'checkout.session.completed':
        if (event.data.object.mode === 'subscription') {
          // Salva stripeCustomerId no perfil para lookup posterior
          await linkCustomerToUser(event.data.object);
        } else {
          await handleConsumableCheckout(event.data.object);
        }
        break;
      
      case 'payment_intent.succeeded':
        console.log('✅ Pagamento confirmado:', event.data.object.id);
        break;
      
      case 'payment_intent.payment_failed':
        console.error('❌ Pagamento falhou:', event.data.object.id);
        break;
        
      default:
        console.log(`ℹ️  Unhandled event type: ${event.type}`);
    }
    
    res.json({ received: true, event: event.type });
  } catch (error) {
    console.error('❌ Error handling webhook:', error);
    res.status(500).json({ error: error.message });
  }
});

// ============================================
// HANDLER: SUBSCRIPTION UPDATE
// ============================================

// Mapeamento de priceId → plano
const GOLD_PRICE_IDS = new Set([
  'price_1ShGe3Pru6X3lyL9tvExYkyc', // Gold Mensal
  'price_1ShGe3Pru6X3lyL97BKkZ2yH', // Gold Anual
  'price_1ShGe3Pru6X3lyL9uZueF1Ot', // Gold alt
]);
const SILVER_PRICE_IDS = new Set([
  'price_1ShGe4Pru6X3lyL9EYUlrwuz', // Silver Mensal
  'price_1ShGe4Pru6X3lyL9z8DSuDMD', // Silver Anual
  'price_1ShGe4Pru6X3lyL9Oe2uwLmz', // Silver alt
]);

async function findUserByCustomerId(customerId) {
  // 1. Busca em perfis por stripeCustomerId
  let snap = await db.collection('perfis').where('stripeCustomerId', '==', customerId).limit(1).get();
  if (!snap.empty) return snap.docs[0];

  // 2. Busca email do cliente no Stripe e procura em perfis
  try {
    const customer = await stripe.customers.retrieve(customerId);
    if (customer.email) {
      snap = await db.collection('perfis').where('email', '==', customer.email).limit(1).get();
      if (!snap.empty) {
        // Salva stripeCustomerId para próximas consultas
        await snap.docs[0].ref.update({ stripeCustomerId: customerId });
        return snap.docs[0];
      }
    }
  } catch (e) {
    console.warn('⚠️ Erro ao buscar customer no Stripe:', e.message);
  }
  return null;
}

async function linkCustomerToUser(session) {
  const clientRef = session.client_reference_id;
  const customerId = session.customer;
  if (!clientRef || !customerId) return;
  const uid = clientRef.includes('_') ? clientRef.split('_').slice(0, -1).join('_') : clientRef;
  if (!uid) return;
  await db.collection('perfis').doc(uid).update({ stripeCustomerId: customerId }).catch(() => {});
  console.log(`🔗 Linked customer ${customerId} → user ${uid}`);
}

async function handleSubscriptionUpdate(subscription) {
  const customerId = subscription.customer;
  const priceId = subscription.items.data[0]?.price?.id ?? '';
  const isActive = subscription.status === 'active';
  const isPastDue = subscription.status === 'past_due';
  const isEffective = isActive || isPastDue;

  console.log(`📝 Subscription update: customer=${customerId} priceId=${priceId} status=${subscription.status}`);

  const profileDoc = await findUserByCustomerId(customerId);
  if (!profileDoc) {
    console.error('❌ User not found for customer:', customerId);
    return;
  }
  const userId = profileDoc.id;

  // Determina plano
  let badge = 'none';
  if (isEffective && GOLD_PRICE_IDS.has(priceId)) badge = 'gold';
  else if (isEffective && SILVER_PRICE_IDS.has(priceId)) badge = 'silver';

  const isGold = badge === 'gold';
  const isSilver = badge === 'silver';
  const periodEnd = subscription.current_period_end;
  const badgeExpiresAt = periodEnd ? admin.firestore.Timestamp.fromMillis(periodEnd * 1000) : null;

  // Consumíveis por plano
  const benefits = isEffective ? {
    superLikesRemaining: isGold ? 15 : isSilver ? 10 : 1,
    magicLikesRemaining: isGold ? 15 : isSilver ? 5 : 0,
    replaysRemaining:    isGold ? -1 : isSilver ? 5 : 0,
    boostsRemaining:     isGold ? 10 : isSilver ? 5 : 0,
  } : { superLikesRemaining: 1, magicLikesRemaining: 0, replaysRemaining: 0, boostsRemaining: 0 };

  // Atualiza perfil com badge + consumíveis
  await db.collection('perfis').doc(userId).update({
    isPremium: isActive,
    hasActivePremium: isEffective,
    stripeCustomerId: customerId,
    verificationBadge: badge,
    badgeExpiresAt,
    badgeGrantedBy: isEffective ? 'subscription' : null,
    canSeeWhoLiked: isEffective,
    ...benefits,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Limpa assinaturas antigas e salva só a atual
  const oldSubs = await db.collection('subscriptions').where('userId', '==', userId).get();
  const batch = db.batch();
  oldSubs.docs.forEach(d => { if (d.id !== subscription.id) batch.delete(d.ref); });
  batch.set(db.collection('subscriptions').doc(subscription.id), {
    userId, stripeCustomerId: customerId, stripeSubscriptionId: subscription.id,
    stripePriceId: priceId, status: subscription.status,
    currentPeriodEnd: badgeExpiresAt, badge,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true });
  await batch.commit();

  console.log(`✅ Subscription updated for ${userId}: badge=${badge} status=${subscription.status}`);
}

// ============================================
// HANDLER: SUBSCRIPTION CANCELED
// ============================================

async function handleSubscriptionCanceled(subscription) {
  const customerId = subscription.customer;
  
  console.log('🚫 Handling subscription cancellation for customer:', customerId);
  
  const userQuery = await db.collection('subscriptions')
    .where('stripeCustomerId', '==', customerId)
    .limit(1)
    .get();
  
  if (userQuery.empty) {
    console.warn('⚠️  User not found for customer:', customerId);
    return;
  }
  
  const userId = userQuery.docs[0].id;
  
  await db.collection('subscriptions').doc(userId).update({
    status: 'canceled',
    autoRenew: false,
    canceledAt: admin.firestore.FieldValue.serverTimestamp(),
    features: {
      superLikesRemaining: 0,
      boostsRemaining: 0,
      canSeeWhoLiked: false,
      hasAdvancedFilters: false
    }
  });
  
  await db.collection('perfis').doc(userId).update({
    isPremium: false,
    premiumSince: null,
    subscriptionTier: 'free'
  });
  
  console.log(`✅ Subscription canceled for user: ${userId}`);
}

// ============================================
// HANDLER: PAYMENT SUCCEEDED
// ============================================

async function handlePaymentSucceeded(invoice) {
  console.log('💰 Payment succeeded:', invoice.id);
  
  // Log para analytics
  const customerId = invoice.customer;
  const amount = invoice.amount_paid / 100; // Convert cents to reais
  
  console.log(`✅ Payment of R$ ${amount.toFixed(2)} received from customer: ${customerId}`);
  
  // Subscription já foi atualizada via subscription.updated event
  // Aqui podemos enviar notificação ao usuário ou atualizar analytics
}

// ============================================
// HANDLER: PAYMENT FAILED
// ============================================

async function handlePaymentFailed(invoice) {
  console.warn('⚠️  Payment failed:', invoice.id);
  
  const customerId = invoice.customer;
  
  // Buscar usuário
  const userQuery = await db.collection('subscriptions')
    .where('stripeCustomerId', '==', customerId)
    .limit(1)
    .get();
  
  if (!userQuery.empty) {
    const userId = userQuery.docs[0].id;
    
    console.log(`⚠️  Payment failed for user: ${userId}`);
    
    // TODO: Enviar notificação push ao usuário sobre falha no pagamento
    // TODO: Enviar email de lembrete
  }
}

// ============================================
// FUNÇÃO 2: CHECK EXPIRED SUBSCRIPTIONS (CRON)
// ============================================

exports.checkExpiredSubscriptions = functions.pubsub
  .schedule('0 */6 * * *') // A cada 6 horas
  .timeZone('America/Sao_Paulo')
  .onRun(async (context) => {
    console.log('🔍 Checking for expired subscriptions...');
    
    const now = admin.firestore.Timestamp.now();
    
    // Buscar assinaturas expiradas
    const expiredSubs = await db.collection('subscriptions')
      .where('status', '==', 'active')
      .where('expiresAt', '<', now)
      .get();
    
    if (expiredSubs.empty) {
      console.log('✅ No expired subscriptions found');
      return null;
    }
    
    console.log(`📊 Found ${expiredSubs.size} expired subscriptions`);
    
    const batch = db.batch();
    
    for (const doc of expiredSubs.docs) {
      const userId = doc.id;
      
      // Marcar como expired
      batch.update(doc.ref, {
        status: 'expired',
        'metadata.updatedAt': admin.firestore.FieldValue.serverTimestamp(),
        'features.superLikesRemaining': 0,
        'features.boostsRemaining': 0,
        'features.canSeeWhoLiked': false,
        'features.hasAdvancedFilters': false
      });
      
      // Remover flag premium do profile
      const profileRef = db.collection('perfis').doc(userId);
      batch.update(profileRef, {
        isPremium: false,
        premiumSince: null,
        subscriptionTier: 'free'
      });
      
      console.log(`✅ Marking subscription as expired for user: ${userId}`);
    }
    
    await batch.commit();
    
    console.log(`✅ Marked ${expiredSubs.size} subscriptions as expired`);
    
    return null;
  });

// ============================================
// FUNÇÃO 3: RESET DAILY LIMITS (CRON)
// ============================================

exports.resetDailyLimits = functions.pubsub
  .schedule('0 0 * * *') // Todo dia à meia-noite
  .timeZone('America/Sao_Paulo')
  .onRun(async (context) => {
    console.log('🔄 Daily limits reset triggered');
    
    // Daily limits são criados sob demanda com campo 'date'
    // Eles expiram automaticamente pela data, não precisa deletar
    // Esta função é apenas um checkpoint de logging
    
    console.log('✅ Daily limits will reset automatically by date field');
    
    return null;
  });

// ============================================
// FUNÇÃO 4: SEND NOTIFICATION (HELPER)
// ============================================

async function sendNotification(userId, notification) {
  try {
    // Buscar FCM token do usuário
    const userDoc = await db.collection('perfis').doc(userId).get();
    
    if (!userDoc.exists) {
      console.warn(`⚠️  User not found: ${userId}`);
      return;
    }
    
    const fcmToken = userDoc.data().fcmToken;
    
    if (!fcmToken) {
      console.warn(`⚠️  No FCM token for user: ${userId}`);
      return;
    }
    
    // Enviar notificação
    const message = {
      token: fcmToken,
      notification: notification.notification,
      data: notification.data || {},
      android: {
        priority: 'high',
        notification: {
          sound: 'default',
          clickAction: 'FLUTTER_NOTIFICATION_CLICK'
        }
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1
          }
        }
      }
    };
    
    await admin.messaging().send(message);
    
    console.log(`✅ Notification sent to user: ${userId}`);
  } catch (error) {
    console.error(`❌ Error sending notification to ${userId}:`, error);
  }
}

// Exportar função de notificação para uso em outras functions
exports.sendNotification = sendNotification;

// ============================================
// FUNÇÃO: PROCESSAR PAGAMENTOS DE CONSUMÍVEIS
// ============================================

/**
 * Mapeamento de produtos para consumíveis
 * Atualize os price_ids com os IDs reais do seu Stripe
 */
const CONSUMABLE_PRODUCTS = {
  // ─── Super Likes (IDs reais do Stripe) ───────────────────────────────────
  'price_1ShGe1Pru6X3lyL9uyCNuWqL': { type: 'superLikes', quantity: 10 },
  'price_1ShGe2Pru6X3lyL9kwLldKir': { type: 'superLikes', quantity: 20 },
  'price_1ShGe2Pru6X3lyL9w9mlMEGO': { type: 'superLikes', quantity: 50 },

  // ─── Boosts (IDs reais do Stripe) ────────────────────────────────────────
  'price_1ShGe2Pru6X3lyL9rNLIbjDx': { type: 'boosts', quantity: 5 },
  'price_1ShGe3Pru6X3lyL9B0MVE8Fv': { type: 'boosts', quantity: 10 },
  'price_1ShGe2Pru6X3lyL90Rb0xJMD': { type: 'boosts', quantity: 20 },

  // ─── Fallback — IDs legados (manter para compatibilidade) ─────────────────
  'price_super_likes_10': { type: 'superLikes', quantity: 10 },
  'price_super_likes_20': { type: 'superLikes', quantity: 20 },
  'price_super_likes_50': { type: 'superLikes', quantity: 50 },
  'price_boosts_10': { type: 'boosts', quantity: 10 },
  'price_boosts_20': { type: 'boosts', quantity: 20 },
  'price_magic_match_3': { type: 'magicLikes', quantity: 3 },
  'price_magic_match_10': { type: 'magicLikes', quantity: 10 },
  'price_replay_10': { type: 'replays', quantity: 10 },
  'price_replay_20': { type: 'replays', quantity: 20 },
};

/**
 * Credita consumíveis ao usuário
 */
async function creditConsumables(userId, consumableType, quantity) {
  const consumablesRef = db.collection('consumables').doc(userId);
  const profileRef = db.collection('perfis').doc(userId);
  
  // Atualiza /consumables (source of truth)
  await consumablesRef.set({
    [consumableType]: admin.firestore.FieldValue.increment(quantity),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true });
  
  // Atualiza /perfis (para sincronização)
  const fieldMapping = {
    'superLikes': 'superLikesRemaining',
    'magicLikes': 'magicLikesRemaining',
    'replays': 'replaysRemaining',
    'boosts': 'boostsRemaining',
  };
  
  const profileField = fieldMapping[consumableType];
  if (profileField) {
    await profileRef.update({
      [profileField]: admin.firestore.FieldValue.increment(quantity),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
  
  console.log(`✅ Creditado: ${quantity} ${consumableType} para usuário ${userId}`);
}

/**
 * Registra a transação
 */
async function logConsumableTransaction(userId, sessionId, productInfo, amount) {
  await db.collection('transactions').add({
    userId,
    sessionId,
    productType: productInfo.type,
    quantity: productInfo.quantity,
    amount,
    status: 'completed',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
  
  console.log(`📝 Transação registrada: ${sessionId}`);
}

/**
 * Processa checkout de consumíveis
 */
// Mapeamento productId → consumíveis (sem precisar chamar API Stripe)
const PRODUCT_ID_MAP = {
  'boosts5':      { boostsRemaining: 5 },
  'boosts10':     { boostsRemaining: 10 },
  'boosts20':     { boostsRemaining: 20 },
  'superLikes10': { superLikesRemaining: 10 },
  'superLikes20': { superLikesRemaining: 20 },
  'superLikes50': { superLikesRemaining: 50 },
  'magicMatch3':  { magicLikesRemaining: 3 },
  'magicMatch10': { magicLikesRemaining: 10 },
  'magicMatch25': { magicLikesRemaining: 25 },
  'replay10':     { replaysRemaining: 10 },
  'replay20':     { replaysRemaining: 20 },
  'replay50':     { replaysRemaining: 50 },
};

async function handleConsumableCheckout(session) {
  console.log('🔄 Processando checkout de consumível:', session.id);

  // client_reference_id formato: "uid_productId"
  const clientRef = session.client_reference_id || '';
  const parts = clientRef.split('_');
  const productId = parts.length >= 2 ? parts[parts.length - 1] : '';
  const userId = parts.length >= 2 ? parts.slice(0, parts.length - 1).join('_') : clientRef;

  console.log(`🔑 clientRef="${clientRef}" → uid="${userId}" productId="${productId}"`);

  if (!userId) {
    console.error('❌ userId não encontrado na sessão');
    return;
  }

  // Identifica consumível pelo productId — sem chamar API Stripe
  const consumable = PRODUCT_ID_MAP[productId];

  if (consumable) {
    // Credita diretamente em perfis/ via FieldValue.increment
    const updates = { updatedAt: admin.firestore.FieldValue.serverTimestamp() };
    for (const [field, qty] of Object.entries(consumable)) {
      updates[field] = admin.firestore.FieldValue.increment(qty);
    }
    await db.collection('perfis').doc(userId).update(updates);
    console.log(`✅ Consumíveis creditados para ${userId}:`, consumable);

    // Notificação
    const labels = {
      boostsRemaining: 'Boosts',
      superLikesRemaining: 'Super Likes',
      magicLikesRemaining: 'Magic Matches',
      replaysRemaining: 'Replays',
    };
    const field = Object.keys(consumable)[0];
    const qty = Object.values(consumable)[0];
    await sendNotification(userId, {
      notification: {
        title: '🎉 Compra realizada!',
        body: `Você recebeu ${qty} ${labels[field] || 'itens'}!`,
      },
      data: { type: 'purchase_success' }
    });
  } else {
    console.warn(`⚠️ productId "${productId}" não mapeado`);
  }
}

// ============================================
// FUNÇÃO: SINCRONIZAR CONSUMÍVEIS MANUALMENTE
// ============================================

exports.syncConsumables = functions.https.onCall(async (data, context) => {
  // Verifica autenticação
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Usuário não autenticado'
    );
  }
  
  const userId = data.userId || context.auth.uid;
  
  try {
    // Busca consumíveis
    const consumablesDoc = await db.collection('consumables').doc(userId).get();
    
    if (!consumablesDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Consumíveis não encontrados');
    }
    
    const consumables = consumablesDoc.data();
    
    // Atualiza perfil
    await db.collection('perfis').doc(userId).update({
      superLikesRemaining: consumables.superLikes || 0,
      magicLikesRemaining: consumables.magicLikes || 0,
      replaysRemaining: consumables.replays || 0,
      boostsRemaining: consumables.boosts || 0,
      boostedUntil: consumables.boostedUntil || null,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    console.log(`✅ Consumíveis sincronizados para ${userId}`);
    
    return {
      success: true,
      consumables: {
        superLikes: consumables.superLikes || 0,
        magicLikes: consumables.magicLikes || 0,
        replays: consumables.replays || 0,
        boosts: consumables.boosts || 0,
      },
    };
  } catch (error) {
    console.error('❌ Erro ao sincronizar consumíveis:', error);
    throw new functions.https.HttpsError('internal', error.message);
  }
});

// ============================================
// FUNÇÃO: NOTIFICAR MAGIC MATCH
// ============================================
// Trigger quando um like é criado com isMagicMatch = true
exports.onMagicMatchReceived = functions.firestore
  .document('likes/{likeId}')
  .onCreate(async (snap, context) => {
    const likeData = snap.data();
    
    // Verificar se é Magic Match
    if (!likeData.isMagicMatch) {
      return null;
    }
    
    const senderId = likeData.userId; // Quem enviou o Magic Match
    const receiverId = likeData.likedUserId; // Quem recebeu
    
    try {
      // Buscar perfil de quem enviou
      const senderProfile = await db.collection('perfis').doc(senderId).get();
      
      if (!senderProfile.exists) {
        console.warn(`⚠️ Sender profile not found: ${senderId}`);
        return null;
      }
      
      const senderName = senderProfile.data().name || 'Alguém';
      const senderPhoto = senderProfile.data().photoUrl || '';
      
      // Enviar notificação para quem recebeu
      await sendNotification(receiverId, {
        notification: {
          title: '🪄✨ Magic Match!',
          body: `${senderName} usou Magic Match em você! Curtida instantânea enviada!`,
          imageUrl: senderPhoto,
        },
        data: {
          type: 'magic_match',
          senderId: senderId,
          senderName: senderName,
          likeId: context.params.likeId,
          timestamp: Date.now().toString(),
        },
      });
      
      console.log(`🪄 Magic Match notification sent: ${senderId} → ${receiverId}`);
      
      return null;
    } catch (error) {
      console.error('❌ Error sending Magic Match notification:', error);
      return null;
    }
  });
