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

      case 'checkout.session.completed':
        await handleCheckoutCompleted(event.data.object as Stripe.Checkout.Session)
        break

      // Boleto/PIX: pagamento confirmado assincronamente (após geração do boleto)
      case 'checkout.session.async_payment_succeeded':
        await handleCheckoutCompleted(event.data.object as Stripe.Checkout.Session)
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
// Mapa de priceId → badge e benefícios
const SILVER_PRICE_IDS = new Set([
  'price_1ShGe4Pru6X3lyL9EYUlrwuz', // silver mensal
  'price_1ShGe4Pru6X3lyL9z8DSuDMD', // silver anual
])
const GOLD_PRICE_IDS = new Set([
  'price_1ShGe3Pru6X3lyL9tvExYkyc', // gold mensal
  'price_1ShGe3Pru6X3lyL97BKkZ2yH', // gold anual
])

/**
 * Encontra o usuário pelo stripeCustomerId ou pelo email do cliente Stripe
 */
async function findUserDoc(customerId: string, customerEmail?: string | null): Promise<FirebaseFirestore.DocumentSnapshot | null> {
  // 1. Tenta pelo stripeCustomerId em perfis
  let snap = await db.collection('perfis').where('stripeCustomerId', '==', customerId).limit(1).get()
  if (!snap.empty) return snap.docs[0]

  // 2. Fallback: busca pelo email em perfis
  if (customerEmail) {
    snap = await db.collection('perfis').where('email', '==', customerEmail).limit(1).get()
    if (!snap.empty) {
      await snap.docs[0].ref.update({ stripeCustomerId: customerId })
      return snap.docs[0]
    }

    // 3. Fallback: busca em users pelo email, depois retorna o perfis correspondente
    const userSnap = await db.collection('users').where('email', '==', customerEmail).limit(1).get()
    if (!userSnap.empty) {
      const userId = userSnap.docs[0].id
      const profileDoc = await db.collection('perfis').doc(userId).get()
      if (profileDoc.exists) {
        await profileDoc.ref.update({ stripeCustomerId: customerId })
        return profileDoc
      }
    }
  }

  console.error(`❌ User not found — customerId: ${customerId}, email: ${customerEmail}`)
  return null
}

async function handleSubscriptionUpdate(subscription: Stripe.Subscription) {
  const customerId = subscription.customer as string
  const subscriptionId = subscription.id
  const priceId = subscription.items.data[0]?.price.id ?? ''
  const isActive = subscription.status === 'active'

  console.log(`📝 Updating subscription: ${subscriptionId} for customer: ${customerId}`)

  // Busca email do cliente no Stripe para fallback
  const stripe = getStripe()
  const stripeCustomer = await stripe.customers.retrieve(customerId) as Stripe.Customer
  const customerEmail = stripeCustomer.email

  const profileDoc = await findUserDoc(customerId, customerEmail)
  if (!profileDoc) return

  const userId = profileDoc.id

  const isPastDue = subscription.status === 'past_due'
  const isEffectivelyActive = isActive || isPastDue // mantém badge durante grace period

  // Determina badge baseado no priceId
  let verificationBadge = 'none'
  let badgeGrantedBy = 'subscription'
  if (isEffectivelyActive && GOLD_PRICE_IDS.has(priceId)) {
    verificationBadge = 'gold'
  } else if (isEffectivelyActive && SILVER_PRICE_IDS.has(priceId)) {
    verificationBadge = 'silver'
  }

  // Salva assinatura no Firestore
  await db.collection('subscriptions').doc(subscriptionId).set({
    userId,
    stripeCustomerId: customerId,
    stripeSubscriptionId: subscriptionId,
    stripePriceId: priceId,
    status: subscription.status,
    currentPeriodStart: admin.firestore.Timestamp.fromDate(new Date((subscription as any).current_period_start * 1000)),
    currentPeriodEnd: admin.firestore.Timestamp.fromDate(new Date((subscription as any).current_period_end * 1000)),
    cancelAtPeriodEnd: (subscription as any).cancel_at_period_end,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true })

  const isGold = verificationBadge === 'gold'
  const isSilver = verificationBadge === 'silver'
  const periodEnd = (subscription as any).current_period_end
  const badgeExpiresAt = periodEnd
    ? admin.firestore.Timestamp.fromDate(new Date(periodEnd * 1000))
    : null

  // Grace period: 3 dias após pagamento atrasado antes de remover o selo
  const GRACE_DAYS = 3
  const badgeGraceUntil = isPastDue
    ? admin.firestore.Timestamp.fromDate(new Date(Date.now() + GRACE_DAYS * 24 * 60 * 60 * 1000))
    : null

  // Benefícios por plano (conforme tela "Conquiste Seu Selo")
  const benefitUpdate = isEffectivelyActive ? {
    superLikesRemaining: isGold ? 15  : isSilver ? 10 : 1,
    magicLikesRemaining: isGold ? 15  : isSilver ? 5  : 0,
    replaysRemaining:    isGold ? -1  : isSilver ? 5  : 0, // Gold = ILIMITADO
    boostsRemaining:     isGold ? 10  : isSilver ? 5  : 0,
  } : {
    // Cancelado/expirado — volta ao free
    superLikesRemaining: 1,
    magicLikesRemaining: 0,
    replaysRemaining: 0,
    boostsRemaining: 0,
  }

  // Atualiza perfil — badge + isPremium + grace period + benefícios
  await profileDoc.ref.update({
    isPremium: isActive,           // true apenas quando active (não past_due)
    hasActivePremium: isEffectivelyActive, // true durante grace period
    stripeCustomerId: customerId,
    verificationBadge,
    badgeGrantedBy: isEffectivelyActive ? badgeGrantedBy : null,
    badgeExpiresAt,
    badgeGraceUntil,               // null quando active, data quando past_due, null quando cancelado
    canSeeWhoLiked: isEffectivelyActive,
    ...benefitUpdate,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  })

  if (isPastDue) {
    console.log(`⏳ Subscription ${subscriptionId} past_due — grace period até ${badgeGraceUntil?.toDate().toISOString()}`)
    await sendNotification(userId, {
      title: '⚠️ Pagamento Atrasado',
      body: `Seu pagamento está atrasado. Você tem ${GRACE_DAYS} dias antes de perder o selo.`,
    })
  }

  console.log(`✅ Subscription ${subscriptionId} → badge=${verificationBadge} for user ${userId}`)

  await sendNotification(userId, {
    title: isActive ? `🎉 Selo ${verificationBadge === 'gold' ? 'Gold' : 'Silver'} Ativo!` : '😢 Assinatura Cancelada',
    body: isActive ? 'Aproveite todos os benefícios premium do BarberGO.' : 'Sua assinatura foi cancelada.',
  })
}

/**
 * Marca uma assinatura como cancelada no Firestore
 */
async function handleSubscriptionCanceled(subscription: Stripe.Subscription) {
  const subscriptionId = subscription.id
  const customerId = subscription.customer as string

  console.log(`🚫 Canceling subscription: ${subscriptionId}`)

  const stripe = getStripe()
  const stripeCustomer = await stripe.customers.retrieve(customerId) as Stripe.Customer
  const profileDoc = await findUserDoc(customerId, stripeCustomer.email)
  if (!profileDoc) return

  const userId = profileDoc.id

  await db.collection('subscriptions').doc(subscriptionId).update({
    status: 'canceled',
    canceledAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  })

  // Remove badge de assinatura e isPremium — volta ao free
  await profileDoc.ref.update({
    isPremium: false,
    hasActivePremium: false,
    verificationBadge: 'none',
    badgeGrantedBy: null,
    badgeExpiresAt: null,
    canSeeWhoLiked: false,
    superLikesRemaining: 1,
    magicLikesRemaining: 0,
    replaysRemaining: 0,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  })

  console.log(`✅ Subscription canceled — badge removido para user ${userId}`)

  await sendNotification(userId, {
    title: '😢 Assinatura Cancelada',
    body: 'Sua assinatura foi cancelada. Esperamos você de volta!',
  })
}

/**
 * Processa checkout de pagamento único (boosts e super likes)
 */
async function handleCheckoutCompleted(session: Stripe.Checkout.Session) {
  const customerId = session.customer as string
  const mode = session.mode

  console.log(`💳 Checkout completed: ${session.id} (mode: ${mode}, payment_status: ${session.payment_status})`)

  // Ignora se for assinatura (já processado por outros eventos)
  if (mode !== 'payment') {
    console.log(`ℹ️ Checkout mode is ${mode}, skipping (handled by subscription events)`)
    return
  }

  // Boleto/PIX são assíncronos — só processa quando realmente pago
  if (session.payment_status !== 'paid') {
    console.log(`⏳ Payment not yet confirmed (${session.payment_status}) — aguardando async_payment_succeeded`)
    return
  }

  // Tenta identificar usuário por: client_reference_id, stripeCustomerId, ou email
  let profileDoc: FirebaseFirestore.DocumentSnapshot | null = null

  // Opção 1: client_reference_id = Firebase UID (configurado no Stripe Dashboard)
  const clientRef = session.client_reference_id
  if (clientRef) {
    const doc = await db.collection('perfis').doc(clientRef).get()
    if (doc.exists) profileDoc = doc
  }

  // Opção 2: stripeCustomerId ou email fallback
  if (!profileDoc && customerId) {
    const email = session.customer_details?.email
    profileDoc = await findUserDoc(customerId, email)
  }

  if (!profileDoc) {
    console.error('❌ User not found for checkout session')
    return
  }
  const userId = profileDoc.id

  // Recupera os line items do checkout
  const stripe = getStripe()
  const lineItems = await stripe.checkout.sessions.listLineItems(session.id, { limit: 100 })

  if (!lineItems.data || lineItems.data.length === 0) {
    console.warn('⚠️ No line items found in checkout session')
    return
  }

  let totalBoosts = 0
  let totalSuperLikes = 0
  let totalMagicMatches = 0
  let totalReplays = 0

  // Processa cada item comprado
  for (const item of lineItems.data) {
    const priceId = item.price?.id
    if (!priceId) continue

    const consumable = getConsumableFromPriceId(priceId)
    if (consumable) {
      totalBoosts += consumable.boosts
      totalSuperLikes += consumable.superLikes
      totalMagicMatches += consumable.magicMatches
      totalReplays += consumable.replays
      console.log(`📦 Item: ${priceId} → Boosts:${consumable.boosts} SL:${consumable.superLikes} MM:${consumable.magicMatches} R:${consumable.replays}`)
    }
  }

  const hasAny = totalBoosts > 0 || totalSuperLikes > 0 || totalMagicMatches > 0 || totalReplays > 0

  if (hasAny) {
    const updates: Record<string, admin.firestore.FieldValue | admin.firestore.Timestamp> = {
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }

    if (totalBoosts > 0)       updates.boostsRemaining       = admin.firestore.FieldValue.increment(totalBoosts)
    if (totalSuperLikes > 0)   updates.superLikesRemaining   = admin.firestore.FieldValue.increment(totalSuperLikes)
    if (totalMagicMatches > 0) updates.magicLikesRemaining   = admin.firestore.FieldValue.increment(totalMagicMatches)
    if (totalReplays > 0)      updates.replaysRemaining      = admin.firestore.FieldValue.increment(totalReplays)

    await profileDoc.ref.update(updates)

    console.log(`✅ Consumables added for ${userId}: Boosts+${totalBoosts} SL+${totalSuperLikes} MM+${totalMagicMatches} R+${totalReplays}`)

    const items = []
    if (totalBoosts > 0)       items.push(`${totalBoosts} Boosts`)
    if (totalSuperLikes > 0)   items.push(`${totalSuperLikes} Super Likes`)
    if (totalMagicMatches > 0) items.push(`${totalMagicMatches} Magic Matches`)
    if (totalReplays > 0)      items.push(`${totalReplays} Replays`)

    await sendNotification(userId, {
      title: '🎉 Compra Realizada!',
      body: `Você recebeu: ${items.join(', ')}`,
    })
  }
}

/**
 * Mapeia Price ID para quantidade de consumíveis
 */
interface ConsumableFull {
  boosts: number
  superLikes: number
  magicMatches: number
  replays: number
}

function getConsumableFromPriceId(priceId: string): ConsumableFull | null {
  const consumables: Record<string, ConsumableFull> = {
    // Boosts
    'price_1TYWCSPru6X3lyL99IbkwdWd': { boosts: 5,  superLikes: 0,  magicMatches: 0, replays: 0 }, // R$ 4,90 (atual)
    'price_1ShGe2Pru6X3lyL9rNLIbjDx': { boosts: 5,  superLikes: 0,  magicMatches: 0, replays: 0 }, // R$ 9,90 (arquivado)
    'price_1ShGe3Pru6X3lyL9B0MVE8Fv': { boosts: 10, superLikes: 0,  magicMatches: 0, replays: 0 },
    'price_1Si6drPru6X3lyL9ibzPA4sa': { boosts: 10, superLikes: 0,  magicMatches: 0, replays: 0 }, // 10 Boosts (v2)
    'price_1ShGe2Pru6X3lyL90Rb0xJMD': { boosts: 20, superLikes: 0,  magicMatches: 0, replays: 0 },

    // Super Likes
    'price_1ShGe1Pru6X3lyL9uyCNuWqL': { boosts: 0, superLikes: 10, magicMatches: 0, replays: 0 },
    'price_1ShGe2Pru6X3lyL9kwLldKir': { boosts: 0, superLikes: 20, magicMatches: 0, replays: 0 },
    'price_1ShGe2Pru6X3lyL9w9mlMEGO': { boosts: 0, superLikes: 50, magicMatches: 0, replays: 0 },

    // Magic Matches
    'price_1SiG6gPru6X3lyL97lcmsJyz': { boosts: 0, superLikes: 0, magicMatches: 3,  replays: 0 },
    'price_1SiGA3Pru6X3lyL9B44FEjiP': { boosts: 0, superLikes: 0, magicMatches: 10, replays: 0 },
    'price_1SiGAnPru6X3lyL9BCVP7QpF': { boosts: 0, superLikes: 0, magicMatches: 25, replays: 0 },

    // Replays
    'price_1SiGBKPru6X3lyL9pICCh4vo': { boosts: 0, superLikes: 0, magicMatches: 0, replays: 10 },
    'price_1SiGBrPru6X3lyL98xhCYUDS': { boosts: 0, superLikes: 0, magicMatches: 0, replays: 20 },
    'price_1SiGCTPru6X3lyL96zJfPmTT': { boosts: 0, superLikes: 0, magicMatches: 0, replays: 50 },
  }

  return consumables[priceId] || null
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

  const stripe = getStripe()
  const stripeCustomer = await stripe.customers.retrieve(customerId) as Stripe.Customer
  const profileDoc = await findUserDoc(customerId, stripeCustomer.email)

  if (profileDoc) {
    await sendNotification(profileDoc.id, {
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
      const profileRef = db.collection('perfis').doc(subscription.userId);
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
 * Roda diariamente às 2h (horário Brasília) e remove selos de perfis
 * cujo grace period de pagamento atrasado expirou.
 *
 * Fluxo: past_due → badgeGraceUntil = now+3d → esta função remove após 3 dias
 */
export const removeExpiredGracePeriodBadges = functions.pubsub
  .schedule('0 2 * * *')
  .timeZone('America/Sao_Paulo')
  .onRun(async () => {
    const now = admin.firestore.Timestamp.now()
    console.log(`🔍 Verificando grace periods expirados em ${now.toDate().toISOString()}`)

    // Busca perfis com grace period expirado (badgeGraceUntil < now)
    const query = await db.collection('perfis')
      .where('badgeGraceUntil', '<=', now)
      .where('isPremium', '==', false) // assinatura não está mais ativa
      .get()

    if (query.empty) {
      console.log('✅ Nenhum grace period expirado')
      return null
    }

    console.log(`⚠️ ${query.size} perfis com grace period expirado`)

    const batch = db.batch()
    const notifyUsers: string[] = []

    for (const doc of query.docs) {
      const data = doc.data()
      const badge = data.verificationBadge

      // Só remove se ainda tiver badge (evita dupla execução)
      if (badge && badge !== 'none') {
        batch.update(doc.ref, {
          verificationBadge: 'none',
          badgeGrantedBy: null,
          badgeExpiresAt: null,
          badgeGraceUntil: null,
          hasActivePremium: false,
          canSeeWhoLiked: false,
          superLikesRemaining: 1,
          magicLikesRemaining: 0,
          replaysRemaining: 0,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        })
        notifyUsers.push(doc.id)
        console.log(`🗑️ Removendo selo ${badge} do usuário ${doc.id}`)
      } else {
        // Grace period expirou mas já não tem badge — só limpa o campo
        batch.update(doc.ref, { badgeGraceUntil: null })
      }
    }

    await batch.commit()

    // Notifica usuários removidos
    for (const userId of notifyUsers) {
      await sendNotification(userId, {
        title: '😢 Selo Removido',
        body: 'Seu pagamento não foi regularizado e o selo premium foi removido. Renove sua assinatura para recuperá-lo.',
      })
    }

    console.log(`✅ Grace period: ${notifyUsers.length} selos removidos`)
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
    const profileDoc = await db.collection('perfis').doc(userId).get()
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
