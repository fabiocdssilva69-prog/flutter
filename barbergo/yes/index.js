const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {setGlobalOptions} = require("firebase-functions/v2");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();

setGlobalOptions({maxInstances: 10});

// Detectar match quando swipe é criado
exports.detectMatch = onDocumentCreated("swipes/{swipeId}",
    async (event) => {
      const snap = event.data;
      if (!snap) return null;
      const swipe = snap.data();
      const {userId, targetUserId, liked} = swipe;

      // Só processa se foi like
      if (!liked) return null;

      // Verificar se o outro usuário também deu like
      const reverseSwipeQuery = await db
          .collection("swipes")
          .where("userId", "==", targetUserId)
          .where("targetUserId", "==", userId)
          .where("liked", "==", true)
          .limit(1)
          .get();

      // Se não encontrou like reverso, não há match
      if (reverseSwipeQuery.empty) {
        console.log("No match: like reverso não encontrado");
        return null;
      }

      // Criar match
      const matchId = [userId, targetUserId].sort().join("_");
      await db.collection("matches").doc(matchId).set({
        matchId,
        user1Id: userId,
        user2Id: targetUserId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        lastMessageAt: admin.firestore.FieldValue.serverTimestamp(),
        unreadCountUser1: 0,
        unreadCountUser2: 0,
      });

      console.log(`✅ Match criado: ${matchId}`);
      return null;
    });

// Enviar notificação quando match é criado
exports.sendMatchNotification = onDocumentCreated("matches/{matchId}",
    async (event) => {
      const snap = event.data;
      if (!snap) return null;
      const match = snap.data();
      const {user1Id, user2Id} = match;

      // Buscar perfis e tokens
      const [user1Doc, user2Doc] = await Promise.all([
        db.collection("profiles").doc(user1Id).get(),
        db.collection("profiles").doc(user2Id).get(),
      ]);

      const user1 = user1Doc.data();
      const user2 = user2Doc.data();

      if (!user1 || !user2) return null;

      const tokens = [];
      if (user1.fcmToken) tokens.push(user1.fcmToken);
      if (user2.fcmToken) tokens.push(user2.fcmToken);

      if (tokens.length === 0) return null;

      // Enviar notificações
      await messaging().sendEachForMulticast({
        tokens,
        notification: {
          title: "🎉 Novo Match!",
          body: "Você e outro usuário deram match! Comece a conversar agora.",
        },
        data: {
          type: "match",
          matchId: match.matchId,
        },
      });

      console.log(`🔔 Notificações enviadas: ${tokens.length}`);
      return null;
    });

// Processar novas mensagens de chat e atualizar lista
exports.onNewMessage = onDocumentCreated(
    "matches/{matchId}/messages/{messageId}",
    async (event) => {
      const snapshot = event.data;
      if (!snapshot) return null;
      const messageData = snapshot.data();
      const matchId = event.params.matchId;
      const senderId = messageData.senderId;
      const matchRef = db.collection("matches").doc(matchId);

      // 1. Atualiza o 'lastMessage' e 'lastActivity' no documento de Match
      const lastMessageUpdate = {
        lastMessage: {
          text: messageData.text,
          timestamp: messageData.timestamp,
          senderId: senderId,
        },
        lastActivity: admin.firestore.FieldValue.serverTimestamp(),
      };

      // Atualiza o documento de match e busca os dados atuais em paralelo
      const [, matchDoc] = await Promise.all([
        matchRef.update(lastMessageUpdate),
        matchRef.get(),
      ]);

      // 2. Envia Notificação Push
      const matchData = matchDoc.data();
      const participants = matchData && matchData.participants ?
        matchData.participants : [];
      const recipientId = participants.find((id) => id !== senderId);

      if (!recipientId) return null;

      // Busca perfis em paralelo
      const [recipientProfileDoc, senderProfileDoc] = await Promise.all([
        db.collection("profiles").doc(recipientId).get(),
        db.collection("profiles").doc(senderId).get(),
      ]);

      const recipientData = recipientProfileDoc.data();
      const senderData = senderProfileDoc.data();
      const fcmToken = recipientData ? recipientData.fcmToken : null;
      const senderName = senderData && senderData.name ?
        senderData.name : "Usuário";

      if (!fcmToken) return null;

      const pushMessage = {
        token: fcmToken,
        notification: {title: senderName, body: messageData.text},
        data: {type: "CHAT_MESSAGE", matchId: matchId},
        android: {priority: "high"},
      };

      try {
        await messaging().send(pushMessage);
      } catch (error) {
        console.error("Error sending chat notification:", error);
      }
      return null;
    });
