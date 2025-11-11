import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

/**
 * Função disparada quando um documento em 'profiles/{userId}' é atualizado.
 *
 * Propaga as mudanças de Nome e Localização para todos os documentos
 * relacionados no banco de dados (vacancies, applications, chat_rooms),
 * garantindo a integridade dos dados desnormalizados.
 *
 * @event onUpdate - Dispara apenas quando um perfil existente é modificado
 * @param userId - ID do usuário cujo perfil foi atualizado
 */
export const propagateProfileUpdate = functions.firestore
  .document('profiles/{userId}')
  .onUpdate(async (change, context) => {
    const userId = context.params.userId
    const beforeData = change.before.data()
    const afterData = change.after.data()

    // Verificamos se os campos relevantes (nome, localização) realmente mudaram.
    const nameChanged = beforeData.name !== afterData.name
    const locationChanged = beforeData.location !== afterData.location

    if (!nameChanged && !locationChanged) {
      console.log(`Profile ${userId} updated, but no critical fields changed. ` + 'Skipping propagation.')
      return null
    }

    console.log(
      `Propagating changes for Profile ${userId}. ` +
        `Name changed: ${nameChanged}, Location changed: ${locationChanged}`,
    )

    const db = admin.firestore()
    // Usamos WriteBatch para garantir atomicidade nas atualizações
    const batch = db.batch()

    // 1. Atualizar Vagas e Candidaturas (apenas se for Barbearia)
    if (afterData.accountType === 'barbershop') {
      // Atualiza 'vacancies'
      const vacanciesSnapshot = await db.collection('vacancies').where('barbershopId', '==', userId).get()

      vacanciesSnapshot.forEach((doc) => {
        batch.update(doc.ref, {
          barbershopName: afterData.name,
          locationCityState: afterData.location,
        })
      })

      // Atualiza 'applications'
      const applicationsSnapshot = await db.collection('applications').where('barbershopId', '==', userId).get()

      applicationsSnapshot.forEach((doc) => {
        batch.update(doc.ref, {
          barbershopName: afterData.name,
        })
      })
    }

    // 2. Atualizar Salas de Chat (Nome do participante - para ambos os tipos de conta)
    const chatRoomsSnapshot = await db.collection('chat_rooms').where('participantIds', 'array-contains', userId).get()

    chatRoomsSnapshot.forEach((doc) => {
      // Usamos notação de ponto para atualizar campos aninhados no mapa 'participants'.
      batch.update(doc.ref, {
        [`participants.${userId}.name`]: afterData.name,
      })
    })

    // Executa todas as atualizações atomicamente
    try {
      await batch.commit()
      console.log(`Successfully propagated changes for ${userId}.`)
    } catch (error) {
      console.error(`Error propagating changes for ${userId}:`, error)
    }

    return null
  })
