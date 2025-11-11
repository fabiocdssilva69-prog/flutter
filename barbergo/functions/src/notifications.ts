import * as admin from 'firebase-admin'
import { onDocumentCreated, onDocumentUpdated } from 'firebase-functions/v2/firestore'
import { HttpsError, onCall } from 'firebase-functions/v2/https'
import { onSchedule } from 'firebase-functions/v2/scheduler'

// Verificar se admin já foi inicializado
if (!admin.apps.length) {
  admin.initializeApp()
}

const db = admin.firestore()
const messaging = admin.messaging()

// ========================================
// 1. SUPER LIKE RECEBIDO
// ========================================
export const sendSuperLikeNotification = onDocumentCreated({
  document: 'swipes/{swipeId}',
  region: 'us-central1',
}, async (event) => {
  const swipe = event.data?.data()
  if (!swipe) return

  // Verificar se é Super Like
  if (!swipe.isSuperLike || !swipe.liked) {
    return
  }

  try {
    // Buscar perfil do destinatário (quem recebeu o Super Like)
    const targetDoc = await db.collection('profiles').doc(swipe.toUserId).get()
    const targetProfile = targetDoc.data()

    if (!targetProfile?.fcmToken) {
      console.log('❌ Target user sem FCM Token')
      return
    }

    // Buscar perfil do remetente (quem enviou)
    const senderDoc = await db.collection('profiles').doc(swipe.fromUserId).get()
    const senderProfile = senderDoc.data()

    const message = {
      notification: {
        title: '💫 Super Like!',
        body: `${senderProfile?.name || 'Alguém'} te deu um Super Like!`,
      },
      data: {
        type: 'super_like',
        targetId: swipe.fromUserId,
        timestamp: Date.now().toString(),
        clickAction: '/likes-received',
      },
      token: targetProfile.fcmToken,
    }

    await messaging.send(message)
    console.log('✅ Super Like notification sent to', swipe.toUserId)
  } catch (error) {
    console.error('❌ Error sending Super Like notification:', error)
  }
})

// ========================================
// 2. NOVO MATCH
// ========================================
export const sendMatchNotification = onDocumentCreated({
  document: 'matches/{matchId}',
  region: 'us-central1',
}, async (event) => {
  const match = event.data?.data()
  if (!match) return

  const matchId = event.params.matchId

  try {
    // Buscar perfis dos 2 usuários
    const [profile1Doc, profile2Doc] = await Promise.all([
      db.collection('profiles').doc(match.user1Id).get(),
      db.collection('profiles').doc(match.user2Id).get(),
    ])

    const profile1 = profile1Doc.data()
    const profile2 = profile2Doc.data()

    // Preparar mensagens para ambos os usuários
    const messages: admin.messaging.Message[] = []

    if (profile1?.fcmToken) {
      messages.push({
        notification: {
          title: '🎉 Novo Match!',
          body: `Você deu match com ${profile2?.name || 'alguém'}!`,
        },
        data: {
          type: 'match',
          chatId: match.chatId || matchId,
          targetId: match.user2Id,
          timestamp: Date.now().toString(),
          clickAction: `/chat/${match.chatId || matchId}`,
        },
        token: profile1.fcmToken,
      })
    }

    if (profile2?.fcmToken) {
      messages.push({
        notification: {
          title: '🎉 Novo Match!',
          body: `Você deu match com ${profile1?.name || 'alguém'}!`,
        },
        data: {
          type: 'match',
          chatId: match.chatId || matchId,
          targetId: match.user1Id,
          timestamp: Date.now().toString(),
          clickAction: `/chat/${match.chatId || matchId}`,
        },
        token: profile2.fcmToken,
      })
    }

    if (messages.length > 0) {
      const results = await messaging.sendEach(messages)
      console.log(`✅ Match notifications sent: ${results.successCount}/${messages.length}`)
    }
  } catch (error) {
    console.error('❌ Error sending Match notification:', error)
  }
})

// ========================================
// 3. BOOST ATIVADO
// ========================================
export const sendBoostActivatedNotification = onDocumentUpdated({
  document: 'profiles/{profileId}',
  region: 'us-central1',
}, async (event) => {
  const before = event.data?.before.data()
  const after = event.data?.after.data()
  if (!before || !after) return

  const profileId = event.params.profileId

  // Verificar se boost foi ativado (antes null, depois com data)
  const wasNotBoosted = !before.boostedUntil || before.boostedUntil?.toDate() < new Date()
  const isNowBoosted = after.boostedUntil && after.boostedUntil?.toDate() > new Date()

  if (!wasNotBoosted || !isNowBoosted) {
    return
  }

  try {
    const fcmToken = after.fcmToken
    if (!fcmToken) {
      console.log('❌ User sem FCM Token')
      return
    }

    const message = {
      notification: {
        title: '🚀 Boost Ativado!',
        body: 'Seu perfil está em destaque por 30 minutos!',
      },
      data: {
        type: 'boost_activated',
        timestamp: Date.now().toString(),
        clickAction: '/discovery',
      },
      token: fcmToken,
    }

    await messaging.send(message)
    console.log('✅ Boost activated notification sent to', profileId)
  } catch (error) {
    console.error('❌ Error sending Boost activated notification:', error)
  }
})

// ========================================
// 4. BOOST EXPIRADO (Cloud Scheduler)
// ========================================
export const checkExpiredBoosts = onSchedule({
  schedule: 'every 5 minutes',
  region: 'us-central1',
}, async () => {
  const now = admin.firestore.Timestamp.now()

  try {
    // Buscar perfis com boost expirado
    const expiredProfilesSnapshot = await db
      .collection('profiles')
      .where('boostedUntil', '<=', now)
      .where('boostedUntil', '!=', null)
      .get()

    console.log(`🔍 Found ${expiredProfilesSnapshot.size} expired boosts`)

    const updatePromises: Promise<admin.firestore.WriteResult>[] = []
    const notificationPromises: Promise<string>[] = []

    for (const doc of expiredProfilesSnapshot.docs) {
      const profile = doc.data()

      // Limpar boost no Firestore
      updatePromises.push(
        doc.ref.update({
          boostedUntil: null,
        }),
      )

      // Enviar notificação
      if (profile.fcmToken) {
        const message = {
          notification: {
            title: '⏰ Boost Expirado',
            body: 'Seu Boost expirou. Ative outro para continuar em destaque!',
          },
          data: {
            type: 'boost_expired',
            timestamp: Date.now().toString(),
            clickAction: '/boost',
          },
          token: profile.fcmToken,
        }

        notificationPromises.push(messaging.send(message))
      }
    }

    await Promise.all([...updatePromises, ...notificationPromises])
    console.log(`✅ Processed ${expiredProfilesSnapshot.size} expired boosts`)
  } catch (error) {
    console.error('❌ Error checking expired boosts:', error)
  }
})

// ========================================
// 5. ASSINATURA RENOVADA (Stripe Webhook)
// ========================================
export const sendSubscriptionRenewedNotification = onDocumentUpdated({
  document: 'profiles/{profileId}',
  region: 'us-central1',
}, async (event) => {
  const before = event.data?.before.data()
  const after = event.data?.after.data()
  if (!before || !after) return

  const profileId = event.params.profileId

  // Verificar se assinatura foi renovada
  // (premiumExpiresAt mudou E isPremium é true)
  const isNowActive = after.isPremium && after.premiumExpiresAt?.toDate() > new Date()
  const expirationChanged = before.premiumExpiresAt?.toMillis() !== after.premiumExpiresAt?.toMillis()

  if (!expirationChanged || !isNowActive) {
    return
  }

  try {
    const fcmToken = after.fcmToken
    if (!fcmToken) {
      console.log('❌ User sem FCM Token')
      return
    }

    const message = {
      notification: {
        title: '✅ Assinatura Renovada',
        body: 'Seu BarberGO Premium foi renovado com sucesso!',
      },
      data: {
        type: 'subscription_renewed',
        timestamp: Date.now().toString(),
        clickAction: '/premium',
      },
      token: fcmToken,
    }

    await messaging.send(message)
    console.log('✅ Subscription renewed notification sent to', profileId)
  } catch (error) {
    console.error('❌ Error sending Subscription renewed notification:', error)
  }
})

// ========================================
// 6. ASSINATURA EXPIRANDO (Cloud Scheduler)
// ========================================
export const checkExpiringSubscriptions = onSchedule(
  {
    schedule: 'every 24 hours',
    timeZone: 'America/Sao_Paulo',
    region: 'us-central1',
  },
  async () => {
    try {
      // Data de hoje + 3 dias
      const threeDaysFromNow = new Date()
      threeDaysFromNow.setDate(threeDaysFromNow.getDate() + 3)
      threeDaysFromNow.setHours(23, 59, 59, 999) // Fim do dia

      const threeDaysTimestamp = admin.firestore.Timestamp.fromDate(threeDaysFromNow)
      const nowTimestamp = admin.firestore.Timestamp.now()

      // Buscar assinaturas expirando em 3 dias
      const expiringProfilesSnapshot = await db
        .collection('profiles')
        .where('isPremium', '==', true)
        .where('premiumExpiresAt', '<=', threeDaysTimestamp)
        .where('premiumExpiresAt', '>', nowTimestamp)
        .get()

      console.log(`🔍 Found ${expiringProfilesSnapshot.size} expiring subscriptions`)

      const notificationPromises: Promise<string>[] = []

      for (const doc of expiringProfilesSnapshot.docs) {
        const profile = doc.data()

        if (!profile.fcmToken) continue

        const expiresAt = profile.premiumExpiresAt?.toDate()
        const daysRemaining = Math.ceil((expiresAt.getTime() - Date.now()) / (1000 * 60 * 60 * 24))

        const message = {
          notification: {
            title: '⚠️ Assinatura Expirando',
            body: `Seu Premium expira em ${daysRemaining} dias. Renove para continuar aproveitando!`,
          },
          data: {
            type: 'subscription_expiring',
            daysRemaining: daysRemaining.toString(),
            timestamp: Date.now().toString(),
            clickAction: '/premium',
          },
          token: profile.fcmToken,
        }

        notificationPromises.push(messaging.send(message))
      }

      await Promise.all(notificationPromises)
      console.log(`✅ Sent ${notificationPromises.length} expiring subscription notifications`)
    } catch (error) {
      console.error('❌ Error checking expiring subscriptions:', error)
    }
  },
)

// ========================================
// HELPER: Enviar notificação manual
// ========================================
export const sendCustomNotification = onCall({
  region: 'us-central1',
}, async (request) => {
  // Verificar autenticação
  if (!request.auth) {
    throw new HttpsError('unauthenticated', 'Must be authenticated')
  }

  const { userId, title, body, type } = request.data

  try {
    const profileDoc = await db.collection('profiles').doc(userId).get()
    const profile = profileDoc.data()

    if (!profile?.fcmToken) {
      throw new HttpsError('not-found', 'User FCM token not found')
    }

    const message = {
      notification: {
        title: title || 'BarberGO',
        body: body || '',
      },
      data: {
        type: type || 'custom',
        timestamp: Date.now().toString(),
      },
      token: profile.fcmToken,
    }

    await messaging.send(message)
    console.log('✅ Custom notification sent to', userId)

    return { success: true }
  } catch (error) {
    console.error('❌ Error sending custom notification:', error)
    throw new HttpsError('internal', 'Failed to send notification')
  }
})
