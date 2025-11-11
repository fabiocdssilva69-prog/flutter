import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

/// Script de Teste: Lê perfil do Firestore e mostra dados brutos
Future<void> main() async {
  print('🔍 Testando leitura do perfil...\n');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;
  final userId = '6RYGS6HoEkhQgikNxUIkn7NpwmI3';

  try {
    print('📥 Buscando documento: profiles/$userId\n');

    final doc = await firestore.collection('profiles').doc(userId).get();

    if (!doc.exists) {
      print('❌ DOCUMENTO NÃO EXISTE!');
      print('   Caminho: profiles/$userId');
      print('   Verifique se criou no local correto.\n');
      return;
    }

    print('✅ DOCUMENTO ENCONTRADO!\n');
    print('📋 Dados brutos:\n');

    final data = doc.data();
    if (data == null) {
      print('   (dados null)\n');
      return;
    }

    // Mostra cada campo com tipo
    data.forEach((key, value) {
      final type = value.runtimeType.toString();
      print('   $key: $value (tipo: $type)');
    });

    print('\n🔍 VERIFICAÇÃO DE CAMPOS CRÍTICOS:\n');

    // Verifica campos obrigatórios
    final requiredFields = ['userId', 'email', 'name', 'accountType', 'createdAt'];

    for (final field in requiredFields) {
      if (data.containsKey(field)) {
        print('   ✅ $field: OK');
      } else {
        print('   ❌ $field: FALTANDO!');
      }
    }

    print('\n🔧 VERIFICAÇÃO DE TIMESTAMPS:\n');

    final createdAt = data['createdAt'];
    if (createdAt is Timestamp) {
      print('   ✅ createdAt é Timestamp');
      print('      Valor: ${createdAt.toDate()}');
    } else {
      print('   ⚠️  createdAt NÃO é Timestamp!');
      print('      Tipo: ${createdAt.runtimeType}');
      print('      Valor: $createdAt');
    }

    final updatedAt = data['updatedAt'];
    if (updatedAt == null) {
      print('   ✅ updatedAt é null (OK)');
    } else if (updatedAt is Timestamp) {
      print('   ✅ updatedAt é Timestamp');
      print('      Valor: ${updatedAt.toDate()}');
    } else {
      print('   ⚠️  updatedAt NÃO é Timestamp!');
      print('      Tipo: ${updatedAt.runtimeType}');
      print('      Valor: $updatedAt');
    }

    print('\n✅ Teste concluído!\n');
  } catch (e, stack) {
    print('❌ ERRO ao ler perfil:');
    print('   $e');
    print('\n📋 Stack trace:');
    print('   $stack\n');
  }
}
