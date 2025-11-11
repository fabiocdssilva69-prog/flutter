/**
 * 🔧 SCRIPT DE CORREÇÃO COMPLETA DO FIRESTORE
 * 
 * Este script corrige TODOS os problemas identificados no banco de dados:
 * 1. Campos timestamp vs number
 * 2. accountType em português vs inglês
 * 3. Campos obrigatórios faltando
 * 4. boostedUntil formato incorreto
 * 
 * IMPORTANTE: Execute este script no Firebase Console > Firestore > Functions
 * ou via Firebase CLI
 */

import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();

interface ProfileCorrections {
  docId: string;
  corrections: {
    field: string;
    oldValue: any;
    newValue: any;
    reason: string;
  }[];
}

/**
 * Valores padrão corretos para profiles
 */
const DEFAULT_VALUES = {
  createdAt: 1698947000000,      // Nov 2, 2023 (number milliseconds)
  updatedAt: 1730483400000,      // Nov 2, 2025 (number milliseconds)
  boostedUntil: null,            // null para não-boosted
  isPremium: false,              // boolean
  isAvailable: true,             // boolean
  rating: 0,                     // number
  totalRatings: 0,               // number
  searchRadiusKm: 25,            // number
};

/**
 * Emails padrão para profiles de teste
 */
const DEFAULT_EMAILS: { [key: string]: string } = {
  'barber_001': 'carlos.barbeiro@example.com',
  'barber_002': 'joao.silva@example.com',
  'barber_003': 'thiago.alves@example.com',
  'barber_004': 'lucas.mendes@example.com',
  'barber_005': 'andre.santos@example.com',
  'barber_006': 'felipe.rodrigues@example.com',
  'barber_007': 'marcelo.ferreira@example.com',
  'barbershop_001': 'contato@barbearia-vintage.com',
  'barbershop_002': 'admin@cortemoderno.com',
  'barbershop_003': 'contato@stylebar.com',
};

/**
 * CORREÇÃO PRINCIPAL: Analisa e corrige todos os profiles
 */
async function fixAllProfiles(): Promise<ProfileCorrections[]> {
  console.log('🔍 Iniciando análise completa dos profiles...\n');
  
  const profilesRef = db.collection('profiles');
  const snapshot = await profilesRef.get();
  
  console.log(`📊 Total de documentos encontrados: ${snapshot.size}\n`);
  
  const allCorrections: ProfileCorrections[] = [];
  let totalFieldsFixed = 0;

  for (const doc of snapshot.docs) {
    const docId = doc.id;
    const data = doc.data();
    const corrections: ProfileCorrections['corrections'] = [];
    
    console.log(`\n🔍 Analisando: ${docId}`);
    console.log(`   accountType atual: ${data.accountType}`);

    // ========================================
    // CORREÇÃO 1: accountType (português → inglês)
    // ========================================
    if (data.accountType === 'barbeiro') {
      corrections.push({
        field: 'accountType',
        oldValue: 'barbeiro',
        newValue: 'barber',
        reason: 'Padronizar para inglês (barbeiro → barber)'
      });
    } else if (data.accountType === 'barbearia') {
      corrections.push({
        field: 'accountType',
        oldValue: 'barbearia',
        newValue: 'barbershop',
        reason: 'Padronizar para inglês (barbearia → barbershop)'
      });
    }

    // ========================================
    // CORREÇÃO 2: createdAt (Timestamp → number)
    // ========================================
    if (data.createdAt) {
      const createdAtType = typeof data.createdAt;
      if (createdAtType === 'object' && data.createdAt._seconds !== undefined) {
        // É um Timestamp, converter para number
        const milliseconds = data.createdAt._seconds * 1000 + Math.floor((data.createdAt._nanoseconds || 0) / 1000000);
        corrections.push({
          field: 'createdAt',
          oldValue: `Timestamp(${data.createdAt._seconds})`,
          newValue: milliseconds,
          reason: 'Converter Timestamp para number (milliseconds)'
        });
      }
    } else {
      // Campo não existe, adicionar
      corrections.push({
        field: 'createdAt',
        oldValue: null,
        newValue: DEFAULT_VALUES.createdAt,
        reason: 'Campo obrigatório faltando'
      });
    }

    // ========================================
    // CORREÇÃO 3: updatedAt (Timestamp → number)
    // ========================================
    if (data.updatedAt) {
      const updatedAtType = typeof data.updatedAt;
      if (updatedAtType === 'object' && data.updatedAt._seconds !== undefined) {
        const milliseconds = data.updatedAt._seconds * 1000 + Math.floor((data.updatedAt._nanoseconds || 0) / 1000000);
        corrections.push({
          field: 'updatedAt',
          oldValue: `Timestamp(${data.updatedAt._seconds})`,
          newValue: milliseconds,
          reason: 'Converter Timestamp para number (milliseconds)'
        });
      }
    } else {
      corrections.push({
        field: 'updatedAt',
        oldValue: null,
        newValue: DEFAULT_VALUES.updatedAt,
        reason: 'Campo obrigatório faltando'
      });
    }

    // ========================================
    // CORREÇÃO 4: boostedUntil (Timestamp/undefined → number/null)
    // ========================================
    if (data.boostedUntil !== undefined) {
      if (typeof data.boostedUntil === 'object' && data.boostedUntil !== null) {
        // É um Timestamp, converter para number
        const milliseconds = data.boostedUntil._seconds * 1000;
        corrections.push({
          field: 'boostedUntil',
          oldValue: `Timestamp(${data.boostedUntil._seconds})`,
          newValue: milliseconds,
          reason: 'Converter Timestamp para number (milliseconds)'
        });
      }
    } else {
      // Campo não existe, adicionar como null
      corrections.push({
        field: 'boostedUntil',
        oldValue: undefined,
        newValue: DEFAULT_VALUES.boostedUntil,
        reason: 'Campo obrigatório faltando (null para não-boosted)'
      });
    }

    // ========================================
    // CORREÇÃO 5: isPremium
    // ========================================
    if (data.isPremium === undefined) {
      corrections.push({
        field: 'isPremium',
        oldValue: undefined,
        newValue: DEFAULT_VALUES.isPremium,
        reason: 'Campo obrigatório faltando'
      });
    }

    // ========================================
    // CORREÇÃO 6: email
    // ========================================
    if (!data.email || data.email === '') {
      const defaultEmail = DEFAULT_EMAILS[docId] || `${docId}@example.com`;
      corrections.push({
        field: 'email',
        oldValue: data.email || null,
        newValue: defaultEmail,
        reason: 'Campo obrigatório faltando'
      });
    }

    // ========================================
    // CORREÇÃO 7: isAvailable
    // ========================================
    if (data.isAvailable === undefined) {
      corrections.push({
        field: 'isAvailable',
        oldValue: undefined,
        newValue: DEFAULT_VALUES.isAvailable,
        reason: 'Campo obrigatório faltando'
      });
    }

    // ========================================
    // CORREÇÃO 8: rating e totalRatings
    // ========================================
    if (data.rating === undefined) {
      corrections.push({
        field: 'rating',
        oldValue: undefined,
        newValue: DEFAULT_VALUES.rating,
        reason: 'Campo obrigatório faltando'
      });
    }
    if (data.totalRatings === undefined) {
      corrections.push({
        field: 'totalRatings',
        oldValue: undefined,
        newValue: DEFAULT_VALUES.totalRatings,
        reason: 'Campo obrigatório faltando'
      });
    }

    // ========================================
    // CORREÇÃO 9: searchRadiusKm
    // ========================================
    if (data.searchRadiusKm === undefined) {
      corrections.push({
        field: 'searchRadiusKm',
        oldValue: undefined,
        newValue: DEFAULT_VALUES.searchRadiusKm,
        reason: 'Campo obrigatório faltando'
      });
    }

    // ========================================
    // APLICAR CORREÇÕES
    // ========================================
    if (corrections.length > 0) {
      console.log(`   ⚠️  ${corrections.length} correções necessárias:`);
      
      const updateData: any = {};
      corrections.forEach(corr => {
        console.log(`      - ${corr.field}: ${corr.reason}`);
        updateData[corr.field] = corr.newValue;
      });

      // Executar update no Firestore
      try {
        await profilesRef.doc(docId).update(updateData);
        console.log(`   ✅ Correções aplicadas com sucesso!`);
        totalFieldsFixed += corrections.length;
      } catch (error) {
        console.error(`   ❌ Erro ao aplicar correções: ${error}`);
      }

      allCorrections.push({ docId, corrections });
    } else {
      console.log(`   ✅ Nenhuma correção necessária`);
    }
  }

  console.log(`\n${'='.repeat(60)}`);
  console.log(`📊 RESUMO FINAL:`);
  console.log(`   Total de profiles: ${snapshot.size}`);
  console.log(`   Profiles corrigidos: ${allCorrections.length}`);
  console.log(`   Total de campos corrigidos: ${totalFieldsFixed}`);
  console.log(`${'='.repeat(60)}\n`);

  return allCorrections;
}

/**
 * Validação: Verificar se todos os profiles estão corretos
 */
async function validateAllProfiles(): Promise<void> {
  console.log('🔍 Validando profiles após correções...\n');
  
  const profilesRef = db.collection('profiles');
  const snapshot = await profilesRef.get();
  
  let allValid = true;
  const issues: string[] = [];

  for (const doc of snapshot.docs) {
    const data = doc.data();
    const docId = doc.id;

    // Validações
    if (!['barber', 'barbershop'].includes(data.accountType)) {
      issues.push(`${docId}: accountType inválido (${data.accountType})`);
      allValid = false;
    }
    if (typeof data.createdAt !== 'number') {
      issues.push(`${docId}: createdAt não é number (${typeof data.createdAt})`);
      allValid = false;
    }
    if (typeof data.updatedAt !== 'number') {
      issues.push(`${docId}: updatedAt não é number (${typeof data.updatedAt})`);
      allValid = false;
    }
    if (data.boostedUntil !== null && typeof data.boostedUntil !== 'number') {
      issues.push(`${docId}: boostedUntil inválido (${typeof data.boostedUntil})`);
      allValid = false;
    }
    if (typeof data.isPremium !== 'boolean') {
      issues.push(`${docId}: isPremium não é boolean`);
      allValid = false;
    }
    if (!data.email || data.email === '') {
      issues.push(`${docId}: email faltando`);
      allValid = false;
    }
  }

  if (allValid) {
    console.log('✅ TODOS OS PROFILES ESTÃO VÁLIDOS!\n');
  } else {
    console.log('❌ ISSUES ENCONTRADOS:\n');
    issues.forEach(issue => console.log(`   - ${issue}`));
  }
}

/**
 * EXECUÇÃO PRINCIPAL
 */
export async function runFullDatabaseFix(): Promise<void> {
  console.log('🚀 Iniciando correção completa do banco de dados...\n');
  
  try {
    // Passo 1: Corrigir todos os profiles
    await fixAllProfiles();
    
    // Passo 2: Validar correções
    await validateAllProfiles();
    
    console.log('🎉 Correção completa do banco de dados finalizada!\n');
  } catch (error) {
    console.error('❌ Erro durante correção:', error);
    throw error;
  }
}

// Para executar via Firebase Functions:
// export const fixDatabase = functions.https.onRequest(async (req, res) => {
//   await runFullDatabaseFix();
//   res.send('Database fixed!');
// });

// Para executar via script node:
// runFullDatabaseFix().then(() => process.exit(0)).catch(err => {
//   console.error(err);
//   process.exit(1);
// });
