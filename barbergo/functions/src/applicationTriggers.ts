import * as functions from "firebase-functions";
import { getFcmToken, saveToInbox, sendFcmMessage } from "./notificationUtils";

/**
 * Trigger: Nova candidatura criada. Notifica a Barbearia.
 * 
 * Dispara quando um barbeiro se candidata a uma vaga, enviando:
 * 1. Notificação persistente no Inbox da barbearia
 * 2. Push notification via FCM (se token disponível)
 * 
 * @event onCreate - applications/{applicationId}
 */
export const notifyNewApplication = functions.firestore
  .document("applications/{applicationId}")
  .onCreate(async (snapshot) => {
    const applicationData = snapshot.data();
    const barbershopId = applicationData.barbershopId;

    const title = "🎉 Nova Candidatura Recebida!";
    const body =
      "Você recebeu uma nova candidatura para a vaga. " +
      "Verifique seu painel de gestão.";

    // 1. Salva no Inbox da Barbearia
    await saveToInbox(barbershopId, {
      type: "applicationReceived",
      title: title,
      message: body,
      contextData: {vacancyId: applicationData.vacancyId},
    });

    // 2. Envia FCM Push
    const token = await getFcmToken(barbershopId);
    if (token) {
      await sendFcmMessage(token, title, body, {
        screen: "vacancyDetails",
        id: applicationData.vacancyId,
      });
    } else {
      console.log(
        `No FCM token found for barbershop ${barbershopId}. Skipping push.`
      );
    }

    return null;
  });

/**
 * Trigger: Candidatura atualizada (Aceita/Rejeitada). Notifica o Barbeiro.
 * 
 * Dispara quando a barbearia muda o status da candidatura, enviando:
 * 1. Notificação persistente no Inbox do barbeiro
 * 2. Push notification via FCM (se token disponível)
 * 
 * Comportamento especial para status 'accepted':
 * - Mensagem menciona abertura do chat (integração Sprint 21)
 * - Direciona usuário para a tela de Inbox
 * 
 * @event onUpdate - applications/{applicationId}
 */
export const notifyApplicationStatusChange = functions.firestore
  .document("applications/{applicationId}")
  .onUpdate(async (change) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();

    // Verifica se o status realmente mudou
    if (beforeData.status === afterData.status) {
      return null;
    }

    const barberId = afterData.barberId;
    const barbershopName = afterData.barbershopName;
    let title: string;
    let body: string;

    if (afterData.status === "accepted") {
      title = "✅ Candidatura Aceita!";
      // Mensagem reflete a abertura do chat (Sprint 21)
      body =
        `${barbershopName} aceitou sua candidatura! ` +
        "Abra o Inbox para conversar.";
    } else if (afterData.status === "rejected") {
      title = "❌ Candidatura Rejeitada";
      body =
        `${barbershopName} analisou sua candidatura, ` +
        "mas decidiu não prosseguir. Continue buscando!";
    } else {
      return null; // Ignora outras mudanças (ex: pending)
    }

    // 1. Salva no Inbox do Barbeiro
    await saveToInbox(barberId, {
      type: "applicationStatusUpdate",
      title: title,
      message: body,
      contextData: {status: afterData.status},
    });

    // 2. Envia FCM Push
    const token = await getFcmToken(barberId);
    if (token) {
      // Define a tela de destino com base no status
      const screen = afterData.status === "accepted" ? "inbox" : "myApplications";
      await sendFcmMessage(token, title, body, {screen: screen});
    } else {
      console.log(
        `No FCM token found for barber ${barberId}. Skipping push.`
      );
    }

    return null;
  });
