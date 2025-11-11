import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

const db = admin.firestore()
const messaging = admin.messaging()

// ========================================
// PROCESSAR NOVA VERIFICAÇÃO SUBMETIDA
// ========================================
export const processVerification = functions.firestore
  .document('verifications/{verificationId}')
  .onCreate(async (snap, context) => {
    const verificationId = context.params.verificationId
    const data = snap.data()

    console.log(`📋 Nova verificação recebida: ${verificationId}`)
    console.log(`👤 Usuário: ${data.userId}`)
    console.log(`📄 Tipo: ${data.documentType}`)

    try {
      // 1. Atualizar status inicial
      await snap.ref.update({
        status: 'pending',
        submittedAt: admin.firestore.FieldValue.serverTimestamp(),
        processedAt: null,
      })

      // 2. Criar task para admin revisar
      await db.collection('admin_tasks').add({
        type: 'verification_review',
        userId: data.userId,
        verificationId: verificationId,
        documentUrl: data.documentUrl,
        documentType: data.documentType,
        status: 'pending',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      })

      // 3. Enviar notificação para o usuário
      const userDoc = await db.collection('users').doc(data.userId).get()
      const fcmToken = userDoc.data()?.fcmToken

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
        })
      }

      console.log(`✅ Verificação processada com sucesso: ${verificationId}`)
      return { success: true }
    } catch (error) {
      console.error(`❌ Erro ao processar verificação ${verificationId}:`, error)

      // Marcar como erro
      await snap.ref.update({
        status: 'error',
        error: String(error),
      })

      throw error
    }
  })

// ========================================
// APROVAR VERIFICAÇÃO (Chamado por Admin)
// ========================================
export const approveVerification = functions.https.onCall(async (data, context) => {
  console.log('✅ Tentativa de aprovar verificação:', data)

  // 1. Validar autenticação
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Usuário não autenticado')
  }

  // 2. Validar se é admin
  const callerDoc = await db.collection('users').doc(context.auth.uid).get()
  const isAdmin = callerDoc.data()?.role === 'admin' || callerDoc.data()?.isAdmin === true

  if (!isAdmin) {
    throw new functions.https.HttpsError('permission-denied', 'Apenas administradores podem aprovar verificações')
  }

  const { userId, verificationId } = data

  if (!userId || !verificationId) {
    throw new functions.https.HttpsError('invalid-argument', 'userId e verificationId são obrigatórios')
  }

  try {
    console.log(`👤 Admin ${context.auth.uid} aprovando verificação de ${userId}`)

    // 3. Atualizar documento de verificação
    await db.collection('verifications').doc(verificationId).update({
      status: 'approved',
      approvedAt: admin.firestore.FieldValue.serverTimestamp(),
      approvedBy: context.auth.uid,
      processedAt: admin.firestore.FieldValue.serverTimestamp(),
    })

    // 4. Atualizar perfil do usuário
    await db.collection('profiles').doc(userId).update({
      isVerified: true,
      verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
    })

    // 5. Atualizar documento de usuário (se existir)
    const userRef = db.collection('users').doc(userId)
    const userDoc = await userRef.get()

    if (userDoc.exists) {
      await userRef.update({
        isVerified: true,
        verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      })
    }

    // 6. Atualizar task do admin
    const adminTasks = await db
      .collection('admin_tasks')
      .where('verificationId', '==', verificationId)
      .where('status', '==', 'pending')
      .get()

    const batch = db.batch()
    adminTasks.docs.forEach((doc) => {
      batch.update(doc.ref, {
        status: 'completed',
        completedAt: admin.firestore.FieldValue.serverTimestamp(),
      })
    })
    await batch.commit()

    // 7. Enviar notificação para o usuário
    const fcmToken = userDoc.data()?.fcmToken

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
      })
    }

    console.log(`✅ Verificação ${verificationId} aprovada com sucesso`)
    return { success: true, message: 'Verificação aprovada com sucesso' }
  } catch (error) {
    console.error('❌ Erro ao aprovar verificação:', error)
    throw new functions.https.HttpsError('internal', `Erro ao aprovar verificação: ${error}`)
  }
})

// ========================================
// REJEITAR VERIFICAÇÃO (Chamado por Admin)
// ========================================
export const rejectVerification = functions.https.onCall(async (data, context) => {
  console.log('❌ Tentativa de rejeitar verificação:', data)

  // 1. Validar autenticação
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Usuário não autenticado')
  }

  // 2. Validar se é admin
  const callerDoc = await db.collection('users').doc(context.auth.uid).get()
  const isAdmin = callerDoc.data()?.role === 'admin' || callerDoc.data()?.isAdmin === true

  if (!isAdmin) {
    throw new functions.https.HttpsError('permission-denied', 'Apenas administradores podem rejeitar verificações')
  }

  const { userId, verificationId, reason } = data

  if (!userId || !verificationId || !reason) {
    throw new functions.https.HttpsError('invalid-argument', 'userId, verificationId e reason são obrigatórios')
  }

  try {
    console.log(`👤 Admin ${context.auth.uid} rejeitando verificação de ${userId}`)

    // 3. Atualizar documento de verificação
    await db.collection('verifications').doc(verificationId).update({
      status: 'rejected',
      rejectedAt: admin.firestore.FieldValue.serverTimestamp(),
      rejectedBy: context.auth.uid,
      rejectionReason: reason,
      processedAt: admin.firestore.FieldValue.serverTimestamp(),
    })

    // 4. Atualizar task do admin
    const adminTasks = await db
      .collection('admin_tasks')
      .where('verificationId', '==', verificationId)
      .where('status', '==', 'pending')
      .get()

    const batch = db.batch()
    adminTasks.docs.forEach((doc) => {
      batch.update(doc.ref, {
        status: 'rejected',
        completedAt: admin.firestore.FieldValue.serverTimestamp(),
        rejectionReason: reason,
      })
    })
    await batch.commit()

    // 5. Enviar notificação para o usuário
    const userDoc = await db.collection('users').doc(userId).get()
    const fcmToken = userDoc.data()?.fcmToken

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
      })
    }

    console.log(`❌ Verificação ${verificationId} rejeitada com sucesso`)
    return { success: true, message: 'Verificação rejeitada' }
  } catch (error) {
    console.error('❌ Erro ao rejeitar verificação:', error)
    throw new functions.https.HttpsError('internal', `Erro ao rejeitar verificação: ${error}`)
  }
})
