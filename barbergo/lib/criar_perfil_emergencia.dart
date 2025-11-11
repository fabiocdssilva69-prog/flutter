import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

/// Script de Emergência: Cria perfil faltante no Firestore
///
/// USAR APENAS se o usuário fez login mas não tem perfil (erro Timeout)
///
/// Para executar:
/// ```
/// dart run lib/criar_perfil_emergencia.dart
/// ```
Future<void> main() async {
  print('🔧 Iniciando script de emergência...\n');

  // Inicializa Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Verifica usuário logado
  final user = auth.currentUser;
  if (user == null) {
    print('❌ ERRO: Nenhum usuário está logado.');
    print('   Faça login no app primeiro, depois execute este script.\n');
    return;
  }

  print('✅ Usuário encontrado:');
  print('   UID: ${user.uid}');
  print('   Email: ${user.email}\n');

  // Verifica se perfil já existe
  final profileDoc = await firestore.collection('profiles').doc(user.uid).get();

  if (profileDoc.exists) {
    print('⚠️  Perfil JÁ EXISTE no Firestore!');
    print('   Dados atuais:');
    print('   ${profileDoc.data()}\n');

    print('❓ O problema não é perfil faltante.');
    print('   Verifique os logs do app para outros erros.\n');
    return;
  }

  print('🆕 Perfil NÃO EXISTE. Criando perfil padrão...\n');

  // VOCÊ PODE ALTERAR ESTES VALORES:
  final perfilPadrao = {
    'userId': user.uid,
    'email': user.email ?? 'sem-email@barbergo.com',
    'name': 'Usuário Teste', // 👈 ALTERE AQUI
    'accountType': 'barber', // 👈 'barber' ou 'barbershop'
    'bio': 'Perfil criado via script de emergência',
    'location': 'Florianópolis, SC',
    'contactPhone': '',
    'fcmToken': null,
    'avatarUrl': null,
    'portfolioUrls': [],
    'preciseLocation': null,
    'searchRadiusKm': 25,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };

  try {
    await firestore.collection('profiles').doc(user.uid).set(perfilPadrao);

    print('✅ PERFIL CRIADO COM SUCESSO!\n');
    print('📋 Dados salvos:');
    perfilPadrao.forEach((key, value) {
      print('   $key: $value');
    });
    print('\n🎉 Agora você pode fazer login normalmente no app!\n');
  } catch (e, stack) {
    print('❌ ERRO ao criar perfil:');
    print('   $e');
    print('   $stack\n');
  }
}
