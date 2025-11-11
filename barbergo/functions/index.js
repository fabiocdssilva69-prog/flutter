const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')(functions.config().stripe?.secret_key || process.env.STRIPE_SECRET_KEY);

admin.initializeApp();
const db = admin.firestore();

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

async function handleSubscriptionUpdate(subscription) {
  const customerId = subscription.customer;
  
  console.log('📝 Handling subscription update for customer:', customerId);
  
  // Buscar userId pelo stripeCustomerId
  const userQuery = await db.collection('subscriptions')
    .where('stripeCustomerId', '==', customerId)
    .limit(1)
    .get();
  
  if (userQuery.empty) {
    console.error('❌ User not found for customer:', customerId);
    return;
  }
  
  const userId = userQuery.docs[0].id;
  const plan = subscription.items.data[0].price.recurring.interval; // monthly ou yearly
  const isActive = subscription.status === 'active';
  
  // Atualizar subscription
  await db.collection('subscriptions').doc(userId).set({
    userId: userId,
    plan: plan,
    status: subscription.status,
    startedAt: admin.firestore.Timestamp.fromMillis(subscription.current_period_start * 1000),
    expiresAt: admin.firestore.Timestamp.fromMillis(subscription.current_period_end * 1000),
    autoRenew: !subscription.cancel_at_period_end,
    canceledAt: null,
    stripeCustomerId: customerId,
    stripeSubscriptionId: subscription.id,
    paymentMethod: 'stripe',
    features: {
      superLikesRemaining: isActive ? -1 : 0, // -1 = ilimitado
      boostsRemaining: isActive ? 1 : 0, // 1 por mês
      canSeeWhoLiked: isActive,
      hasAdvancedFilters: isActive
    },
    metadata: {
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      version: admin.firestore.FieldValue.increment(1)
    }
  }, { merge: true });
  
  // Atualizar flag premium no profile
  await db.collection('profiles').doc(userId).update({
    isPremium: isActive,
    premiumSince: isActive ? admin.firestore.Timestamp.fromMillis(subscription.current_period_start * 1000) : null,
    subscriptionTier: isActive ? 'premium' : 'free'
  });
  
  console.log(`✅ Subscription updated for user: ${userId} (status: ${subscription.status})`);
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
  
  await db.collection('profiles').doc(userId).update({
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
      const profileRef = db.collection('profiles').doc(userId);
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
    const userDoc = await db.collection('profiles').doc(userId).get();
    
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
