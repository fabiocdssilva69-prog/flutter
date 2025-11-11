// Script temporário para adicionar preciseLocation nas vagas existentes
// Execute: dart run lib/scripts/fix_vacancies_location.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

Future<void> main() async {
  print('🔧 Iniciando correção de preciseLocation nas vagas...');

  final db = FirebaseFirestore.instance;
  final vacancies = await db.collection('vacancies').get();

  int fixed = 0;
  int skipped = 0;

  for (var doc in vacancies.docs) {
    final data = doc.data();

    // Se já tem preciseLocation, pula
    if (data.containsKey('preciseLocation') && data['preciseLocation'] != null) {
      print('⏭️  Vaga ${doc.id} já tem preciseLocation, pulando...');
      skipped++;
      continue;
    }

    // Coordenadas padrão: Centro de São Paulo
    // TODO: No futuro, usar geocoding do locationCityState
    final geoPoint = const GeoPoint(-23.5505, -46.6333);
    final geoFirePoint = GeoFirePoint(geoPoint);

    try {
      await doc.reference.update({'preciseLocation': geoFirePoint.data});

      print('✅ Vaga ${doc.id} atualizada com preciseLocation');
      fixed++;
    } catch (e) {
      print('❌ Erro ao atualizar vaga ${doc.id}: $e');
    }
  }

  print('\n🎉 Correção completa!');
  print('   ✅ Vagas corrigidas: $fixed');
  print('   ⏭️  Vagas puladas: $skipped');
}
