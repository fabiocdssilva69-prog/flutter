import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import Stripe from 'stripe'

/**
 * STRIPE TRIGGERS
 *
 * Cloud Functions para integração com Stripe e gerenciamento de assinaturas premium.
 *
 * Funções:
 * 1. stripeWebhook - Processa eventos do Stripe (HTTPS trigger)
 * 2. checkExpiredSubscriptions - Verifica assinaturas expiradas (Cron: a cada 6 horas)
 * 3. resetDailyLimits - Reseta limites diários (Cron: diariamente à meia-noite)
 */

// V2 Migration: Lazy initialization do Stripe para evitar erros no CLI
// O Stripe só será inicializado quando a function for executada no Cloud
let stripeInstance: Stripe | null = null

function getStripe(): Stripe {
  if (!stripeInstance) {
    const apiKey = process.env.STRIPE_SECRET_KEY || ''
    if (!apiKey) {
      throw new Error('STRIPE_SECRET_KEY não configurada no .env')
    }
    stripeInstance = new Stripe(apiKey, {
      apiVersion: '2025-10-29.clover',
    })
  }
  return stripeInstance
}

const db = admin.firestore()

/**
 * FUNÇÃO 1: stripeWebhook
 *
 * Webhook HTTPS que recebe eventos do Stripe e atualiza o Firestore.
 *
 * Eventos processados:
 * - customer.subscription.created
 * - customer.subscription.updated
 * - customer.subscription.deleted
 * - invoice.payment_succeeded
 * - invoice.payment_failed
 */
export const stripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'] as string
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET || ''

  let event: Stripe.Event

  try {
    // Verifica a assinatura do webhook para garantir que veio do Stripe
    const stripe = getStripe()
    event = stripe.webhooks.constructEvent(req.rawBody, sig, webhookSecret)
  } catch (err: any) {
    console.error('⚠️ Webhook signature verification failed:', err.message)
    res.status(400).send(`Webhook Error: ${err.message}`)
    return
  }

  console.log(`✅ Received Stripe event: ${event.type}`)

  try {
    // Processa diferentes tipos de eventos
    switch (event.type) {
      case 'customer.subscription.created':
      case 'customer.subscription.updated':
        await handleSubscriptionUpdate(event.data.object as Stripe.Subscription)
        break

      case 'customer.subscription.deleted':
        await handleSubscriptionCanceled(event.data.object as Stripe.Subscription)
        break

      case 'invoice.payment_succeeded':
        await handlePaymentSucceeded(event.data.object as Stripe.Invoice)
        break

      case 'invoice.payment_failed':
        await handlePaymentFailed(event.data.object as Stripe.Invoice)
        break

      default:
        console.log(`⚠️ Unhandled event type: ${event.type}`)
    }

    res.json({ received: true })
  } catch (error: any) {
    console.error('❌ Error processing webhook:', error)
    res.status(500).send(`Webhook Error: ${error.message}`)
  }
})

/**
 * Atualiza ou cria uma assinatura no Firestore
 */
async function handleSubscriptionUpdate(subscription: Stripe.Subscription) {
  const customerId = subscription.customer as string
  const subscriptionId = subscription.id

  console.log(`📝 Updating subscription: ${subscriptionId} for customer: ${customerId}`)

  // Busca o usuário pelo Stripe Customer ID
  const profilesSnapshot = await db.collection('profiles').where('stripeCustomerId', '==', customerId).limit(1).get()

  if (profilesSnapshot.empty) {
    console.error(`❌ No user found with stripeCustomerId: ${customerId}`)
    return
  }

  const profileDoc = profilesSnapshot.docs[0]
  const userId = profileDoc.id

  // Determina os recursos premium com base no produto
  const productId = subscription.items.data[0]?.price.product as string
  const features = {
    canSeeWhoLiked: true,
    superLikesRemaining: -1, // -1 = ilimitado
    boostsRemaining: 0,
  }

  // Se for uma assinatura, dá acesso a super likes ilimitados
  if (subscription.items.data[0]?.price.recurring) {
    features.superLikesRemaining = -1 // Ilimitado
  }

  // Atualiza a assinatura no Firestore
  await db
    .collection('subscriptions')
    .doc(subscriptionId)
    .set(
      {
        userId,
        stripeCustomerId: customerId,
        stripeSubscriptionId: subscriptionId,
        stripePriceId: subscription.items.data[0]?.price.id,
        stripeProductId: productId,
        status: subscription.status,
        currentPeriodStart: admin.firestore.Timestamp.fromDate(new Date((subscription as any).current_period_start * 1000)),
        currentPeriodEnd: admin.firestore.Timestamp.fromDate(new Date((subscription as any).current_period_end * 1000)),
        cancelAtPeriodEnd: (subscription as any).cancel_at_period_end,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    )

  // Atualiza o status premium no perfil do usuário
  await profileDoc.ref.update({
    isPremium: subscription.status === 'active',
    ...features,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  })

  console.log(`✅ Subscription ${subscriptionId} updated for user ${userId}`)

  // Envia notificação ao usuário
  await sendNotification(userId, {
    title: '🎉 Assinatura Premium Ativa!',
    body: 'Aproveite todos os benefícios premium do BarberGO.',
  })
}

/**
 * Marca uma assinatura como cancelada no Firestore
 */
async function handleSubscriptionCanceled(subscription: Stripe.Subscription) {
  const subscriptionId = subscription.id
  const customerId = subscription.customer as string

  console.log(`🚫 Canceling subscription: ${subscriptionId}`)

  // Busca o usuário pelo Stripe Customer ID
  const profilesSnapshot = await db.collection('profiles').where('stripeCustomerId', '==', customerId).limit(1).get()

  if (profilesSnapshot.empty) {
    console.error(`❌ No user found with stripeCustomerId: ${customerId}`)
    return
  }

  const profileDoc = profilesSnapshot.docs[0]
  const userId = profileDoc.id

  // Atualiza a assinatura
  await db.collection('subscriptions').doc(subscriptionId).update({
    status: 'canceled',
    canceledAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  })

  // Remove o status premium do perfil
  await profileDoc.ref.update({
    isPremium: false,
    canSeeWhoLiked: false,
    superLikesRemaining: 0,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  })

  console.log(`✅ Subscription ${subscriptionId} canceled for user ${userId}`)

  // Envia notificação ao usuário
  await sendNotification(userId, {
    title: '😢 Assinatura Cancelada',
    body: 'Sua assinatura premium foi cancelada. Esperamos você de volta!',
  })
}

/**
 * Registra pagamento bem-sucedido
 */
async function handlePaymentSucceeded(invoice: Stripe.Invoice) {
  const subscriptionId = (invoice as any).subscription as string;
  console.log(`💰 Payment succeeded for subscription: ${subscriptionId}`)

  // Registra o pagamento no Firestore (opcional)
  if (subscriptionId) {
    await db.collection('payments').add({
      subscriptionId,
      invoiceId: invoice.id,
      amount: invoice.amount_paid / 100, // Converte de centavos para reais
      currency: invoice.currency,
      status: 'succeeded',
      paidAt: admin.firestore.Timestamp.fromDate(new Date(invoice.created * 1000)),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    })
  }
}

/**
 * Registra pagamento falhado e notifica o usuário
 */
async function handlePaymentFailed(invoice: Stripe.Invoice) {
  const subscriptionId = (invoice as any).subscription as string;
  const customerId = invoice.customer as string;

  console.log(`❌ Payment failed for subscription: ${subscriptionId}`)

  // Busca o usuário pelo Stripe Customer ID
  const profilesSnapshot = await db.collection('profiles').where('stripeCustomerId', '==', customerId).limit(1).get()

  if (!profilesSnapshot.empty) {
    const userId = profilesSnapshot.docs[0].id

    // Envia notificação ao usuário
    await sendNotification(userId, {
      title: '⚠️ Falha no Pagamento',
      body: 'Não conseguimos processar seu pagamento. Por favor, atualize seu método de pagamento.',
    })
  }

  // Registra o pagamento falhado no Firestore (opcional)
  if (subscriptionId) {
    await db.collection('payments').add({
      subscriptionId,
      invoiceId: invoice.id,
      amount: invoice.amount_due / 100,
      currency: invoice.currency,
      status: 'failed',
      failedAt: admin.firestore.Timestamp.fromDate(new Date(invoice.created * 1000)),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    })
  }
}

/**
 * FUNÇÃO 2: checkExpiredSubscriptions
 *
 * Cron job que executa a cada 6 horas para verificar e marcar assinaturas expiradas.
 *
 * Timezone: America/Sao_Paulo
 * Schedule: 0 (asterisk)/6 (asterisk) (asterisk) (asterisk) (a cada 6 horas)
 */
export const checkExpiredSubscriptions = functions.pubsub
  .schedule('0 */6 * * *')
  .timeZone('America/Sao_Paulo')
  .onRun(async (context) => {
    console.log('🔍 Checking for expired subscriptions...')

    const now = admin.firestore.Timestamp.now()

    // Busca assinaturas ativas que já expiraram
    const expiredSubscriptions = await db
      .collection('subscriptions')
      .where('status', '==', 'active')
      .where('currentPeriodEnd', '<', now)
      .get()

    console.log(`📊 Found ${expiredSubscriptions.size} expired subscriptions`)

    if (expiredSubscriptions.empty) {
      console.log('✅ No expired subscriptions found')
      return null
    }

    // Atualiza em lote
    const batch = db.batch()
    const userUpdates: Promise<void>[] = []

    for (const doc of expiredSubscriptions.docs) {
      const subscription = doc.data()

      // Marca assinatura como expirada
      batch.update(doc.ref, {
        status: 'expired',
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      })

      // Remove status premium do usuário
      const profileRef = db.collection('profiles').doc(subscription.userId);
      userUpdates.push(
        profileRef.update({
          isPremium: false,
          canSeeWhoLiked: false,
          superLikesRemaining: 0,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }).then(() => {})
      );

      // Envia notificação
      userUpdates.push(
        sendNotification(subscription.userId, {
          title: '⏰ Assinatura Expirada',
          body: 'Sua assinatura premium expirou. Renove para continuar aproveitando os benefícios!',
        }),
      )

      console.log(`📝 Marking subscription ${doc.id} as expired for user ${subscription.userId}`)
    }

    // Executa todas as atualizações
    await batch.commit()
    await Promise.all(userUpdates)

    console.log(`✅ Successfully processed ${expiredSubscriptions.size} expired subscriptions`)
    return null
  })

/**
 * FUNÇÃO 3: resetDailyLimits
 *
 * Cron job que executa diariamente à meia-noite para resetar limites diários.
 *
 * NOTA: Os limites diários usam um campo de data (expiresAt) e são automaticamente
 * filtrados nas queries. Esta função serve apenas como checkpoint de logging.
 *
 * Timezone: America/Sao_Paulo
 * Schedule: 0 0 * * * (diariamente à meia-noite)
 */
export const resetDailyLimits = functions.pubsub
  .schedule('0 0 * * *')
  .timeZone('America/Sao_Paulo')
  .onRun(async (context) => {
    console.log('🔄 Daily limits reset checkpoint...')
    console.log('📅 Limits auto-expire by date field (expiresAt)')
    console.log('✅ No manual cleanup needed')

    // Os limites diários são gerenciados pelo campo expiresAt
    // e são automaticamente desconsiderados nas queries quando expirados
    // Esta função serve apenas como log de checkpoint

    return null
  })

/**
 * Função auxiliar para enviar notificações push via FCM
 */
async function sendNotification(
  userId: string,
  notification: {
    title: string
    body: string
  },
): Promise<void> {
  try {
    // Busca o FCM token do usuário
    const profileDoc = await db.collection('profiles').doc(userId).get()
    const fcmToken = profileDoc.data()?.fcmToken

    if (!fcmToken) {
      console.log(`⚠️ No FCM token found for user ${userId}`)
      return
    }

    // Envia a notificação
    await admin.messaging().send({
      token: fcmToken,
      notification: {
        title: notification.title,
        body: notification.body,
      },
      android: {
        priority: 'high',
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
          },
        },
      },
    })

    console.log(`📬 Notification sent to user ${userId}`)
  } catch (error) {
    console.error(`❌ Error sending notification to user ${userId}:`, error)
  }
}
