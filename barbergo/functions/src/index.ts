import * as admin from 'firebase-admin'

/**
 * Inicializa o SDK Admin do Firebase.
 *
 * CRITICAL: Este código deve ser executado ANTES de qualquer operação Firestore.
 * A verificação `admin.apps.length === 0` garante que não haja múltiplas inicializações
 * (útil para testes e emuladores).
 */
if (admin.apps.length === 0) {
  admin.initializeApp()
}

export * from './applicationTriggers'; // NOVO - Sprint 22 Prompt 4/6
export * from './notifications'; // Sistema de notificações push (6 tipos)
/**
 * Exporta todas as Cloud Functions definidas nos arquivos de triggers.
 *
 * Cada arquivo de trigger (profileTriggers.ts, etc.) exporta suas próprias funções,
 * e este index.ts as re-exporta para o Firebase Functions reconhecê-las.
 */
export * from './profileTriggers'
export * from './stripeTriggers'; // Funções de integração com Stripe
export * from './verification'; // Sistema de verificação de perfil (3 funções)

/**
 * APENAS PARA DESENVOLVIMENTO/TESTES
 * Descomente a linha abaixo para habilitar a função de teste no emulador.
 * IMPORTANTE: Não faça deploy desta função em produção!
 */
// export * from "./testTriggers";
