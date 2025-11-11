import * as admin from "firebase-admin";

/**
 * Função auxiliar para buscar o token FCM do usuário no perfil.
 * 
 * @param userId - ID do usuário (barbeiro ou barbearia)
 * @returns Token FCM se disponível, ou null
 */
export async function getFcmToken(userId: string): Promise<string | null> {
  const profileDoc = await admin
    .firestore()
    .collection("profiles")
    .doc(userId)
    .get();

  const token = profileDoc.data()?.fcmToken;

  // Garante que o token é uma string válida
  return typeof token === "string" && token.length > 0 ? token : null;
}

/**
 * Interface para dados de notificação salvos no Inbox
 */
interface NotificationData {
  type: string;
  title: string;
  message: string;
  contextData?: Record<string, unknown>;
}

/**
 * Função auxiliar para salvar notificação na subcoleção 'notifications' (Inbox).
 * 
 * Esta função cria um registro persistente da notificação que o usuário
 * pode acessar mesmo se não estiver online quando a notificação push for enviada.
 * 
 * @param userId - ID do usuário que receberá a notificação
 * @param notification - Dados da notificação (type, title, message, contextData)
 */
export async function saveToInbox(
  userId: string,
  notification: NotificationData
): Promise<void> {
  await admin
    .firestore()
    .collection("profiles")
    .doc(userId)
    .collection("notifications")
    .add({
      ...notification,
      isRead: false,
      // Usa o timestamp do servidor para consistência
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
}

/**
 * Função auxiliar para enviar a mensagem FCM (Firebase Cloud Messaging).
 * 
 * Envia notificação push para dispositivos iOS e Android com configurações
 * específicas de prioridade e som.
 * 
 * @param token - Token FCM do dispositivo de destino
 * @param title - Título da notificação
 * @param body - Corpo da notificação
 * @param data - Dados adicionais (opcional) para navegação ou contexto
 */
export async function sendFcmMessage(
  token: string,
  title: string,
  body: string,
  data?: Record<string, string>
): Promise<void> {
  const message: admin.messaging.Message = {
    token: token,
    notification: {
      title: title,
      body: body,
    },
    data: data,
    // Configurações de prioridade e som
    android: {priority: "high"},
    apns: {payload: {aps: {sound: "default", badge: 1}}},
  };

  try {
    await admin.messaging().send(message);
    console.log(
      `FCM sent successfully to user (token ending in ${token.slice(-4)})`
    );
  } catch (error) {
    console.error(`Error sending FCM message:`, error);
  }
}
