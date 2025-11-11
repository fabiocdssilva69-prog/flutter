import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

/**
 * FUNÇÃO DE TESTE - NÃO DEPLOY EM PRODUÇÃO
 * 
 * Esta função de teste permite verificar manualmente se a propagação
 * de dados está funcionando corretamente no emulador.
 * 
 * Para testar:
 * 1. Inicie o emulador: `npm run serve`
 * 2. Acesse: http://localhost:4000 (Firebase Emulator UI)
 * 3. Dispare esta função manualmente com dados de teste
 */
export const testProfilePropagation = functions.https.onRequest(
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async (_request, response) => {
    try {
      const db = admin.firestore();

      // Dados de teste
      const testUserId = "test-barbershop-123";
      const oldName = "Barbearia Antiga";
      const newName = "Barbearia Nova";
      const location = "São Paulo, SP";

      console.log("=== TESTE DE PROPAGAÇÃO ===");
      console.log(`User ID: ${testUserId}`);
      console.log(`Old Name: ${oldName}`);
      console.log(`New Name: ${newName}`);

      // 1. Criar perfil de teste
      await db.collection("profiles").doc(testUserId).set({
        name: oldName,
        location: location,
        accountType: "barbershop",
        email: "test@barbergo.com",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // 2. Criar vaga de teste
      const vacancyRef = await db.collection("vacancies").add({
        barbershopId: testUserId,
        barbershopName: oldName,
        locationCityState: location,
        title: "Barbeiro Experiente",
        salary: 3000,
        isActive: true,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // 3. Criar candidatura de teste
      const applicationRef = await db.collection("applications").add({
        barbershopId: testUserId,
        barbershopName: oldName,
        barberId: "test-barber-456",
        vacancyId: vacancyRef.id,
        status: "pending",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // 4. Criar sala de chat de teste
      const chatRoomRef = await db.collection("chat_rooms").add({
        participantIds: [testUserId, "test-barber-456"],
        participants: {
          [testUserId]: {
            name: oldName,
            accountType: "barbershop",
          },
          "test-barber-456": {
            name: "João Barbeiro",
            accountType: "barber",
          },
        },
        lastMessage: "Olá!",
        lastMessageTimestamp: admin.firestore.FieldValue.serverTimestamp(),
        unreadCounts: {
          [testUserId]: 0,
          "test-barber-456": 1,
        },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log("✅ Dados de teste criados:");
      console.log(`   - Profile: ${testUserId}`);
      console.log(`   - Vacancy: ${vacancyRef.id}`);
      console.log(`   - Application: ${applicationRef.id}`);
      console.log(`   - Chat Room: ${chatRoomRef.id}`);

      // 5. Aguardar 2 segundos
      await new Promise((resolve) => setTimeout(resolve, 2000));

      // 6. Atualizar o perfil (DISPARA O TRIGGER)
      await db.collection("profiles").doc(testUserId).update({
        name: newName,
      });

      console.log(`🔥 Trigger disparado: Profile atualizado para "${newName}"`);

      // 7. Aguardar a função processar
      await new Promise((resolve) => setTimeout(resolve, 3000));

      // 8. Verificar se os dados foram propagados
      const vacancy = await db.collection("vacancies").doc(vacancyRef.id).get();
      const application = await db
        .collection("applications")
        .doc(applicationRef.id)
        .get();
      const chatRoom = await db
        .collection("chat_rooms")
        .doc(chatRoomRef.id)
        .get();

      const vacancyData = vacancy.data();
      const applicationData = application.data();
      const chatRoomData = chatRoom.data();

      const results = {
        profile: {updated: true, newName: newName},
        vacancy: {
          updated: vacancyData?.barbershopName === newName,
          expected: newName,
          actual: vacancyData?.barbershopName,
        },
        application: {
          updated: applicationData?.barbershopName === newName,
          expected: newName,
          actual: applicationData?.barbershopName,
        },
        chatRoom: {
          updated: chatRoomData?.participants[testUserId]?.name === newName,
          expected: newName,
          actual: chatRoomData?.participants[testUserId]?.name,
        },
      };

      console.log("=== RESULTADOS ===");
      console.log(JSON.stringify(results, null, 2));

      // Limpar dados de teste
      await db.collection("profiles").doc(testUserId).delete();
      await db.collection("vacancies").doc(vacancyRef.id).delete();
      await db.collection("applications").doc(applicationRef.id).delete();
      await db.collection("chat_rooms").doc(chatRoomRef.id).delete();

      console.log("🧹 Dados de teste removidos");

      response.status(200).json({
        success: true,
        message: "Teste de propagação concluído",
        results: results,
      });
    } catch (error) {
      console.error("❌ Erro no teste:", error);
      response.status(500).json({
        success: false,
        error: String(error),
      });
    }
  }
);
