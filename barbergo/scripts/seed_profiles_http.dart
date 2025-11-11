import 'dart:convert';
import 'dart:io';

void main() async {
  const projectId = 'barbergo-38c21';
  const collection = 'profiles';

  print('🌱 Iniciando seed de perfis (via HTTP)...');
  print('📝 Criando 10 perfis...\n');

  final now = DateTime.now();

  final profiles = [
    {
      'id': 'barber_001',
      'name': 'Carlos Silva',
      'accountType': 'barber',
      'isPremium': true,
      'boostedUntil': now.add(const Duration(days: 7)).millisecondsSinceEpoch,
      'rating': 4.8,
      'reviewCount': 127,
      'bio': 'Especialista em cortes modernos e degradê',
      'location': {
        'address': 'Av. Paulista, 1000 - Bela Vista, São Paulo - SP',
        'latitude': -23.5630,
        'longitude': -46.6565,
      },
      'services': ['Corte', 'Barba', 'Sobrancelha'],
      'priceRange': {'min': 40.0, 'max': 80.0},
      'workingHours': {
        'monday': '09:00-19:00',
        'tuesday': '09:00-19:00',
        'wednesday': '09:00-19:00',
        'thursday': '09:00-19:00',
        'friday': '09:00-20:00',
        'saturday': '08:00-18:00',
        'sunday': 'Fechado',
      },
      'photoUrl': 'https://i.pravatar.cc/400?img=12',
      'createdAt': now.subtract(const Duration(days: 365)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
    },
    {
      'id': 'barber_002',
      'name': 'Rafael Costa',
      'accountType': 'barber',
      'isPremium': false,
      'rating': 4.6,
      'reviewCount': 89,
      'bio': 'Barbeiro tradicional, 10 anos de experiência',
      'location': {
        'address': 'R. Augusta, 2500 - Jardins, São Paulo - SP',
        'latitude': -23.5580,
        'longitude': -46.6620,
      },
      'services': ['Corte', 'Barba'],
      'priceRange': {'min': 35.0, 'max': 60.0},
      'workingHours': {
        'monday': '10:00-19:00',
        'tuesday': '10:00-19:00',
        'wednesday': '10:00-19:00',
        'thursday': '10:00-19:00',
        'friday': '10:00-20:00',
        'saturday': '09:00-17:00',
        'sunday': 'Fechado',
      },
      'photoUrl': 'https://i.pravatar.cc/400?img=33',
      'createdAt': now.subtract(const Duration(days: 730)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(hours: 5)).millisecondsSinceEpoch,
    },
    {
      'id': 'barber_003',
      'name': 'Thiago Alves',
      'accountType': 'barber',
      'isPremium': true,
      'boostedUntil': now.add(const Duration(days: 3)).millisecondsSinceEpoch,
      'rating': 4.9,
      'reviewCount': 203,
      'bio': 'Cortes estilosos e acabamento perfeito',
      'location': {
        'address': 'Av. Faria Lima, 3000 - Itaim Bibi, São Paulo - SP',
        'latitude': -23.5750,
        'longitude': -46.6890,
      },
      'services': ['Corte', 'Barba', 'Sobrancelha', 'Pigmentação'],
      'priceRange': {'min': 50.0, 'max': 100.0},
      'workingHours': {
        'monday': '09:00-20:00',
        'tuesday': '09:00-20:00',
        'wednesday': '09:00-20:00',
        'thursday': '09:00-20:00',
        'friday': '09:00-21:00',
        'saturday': '08:00-19:00',
        'sunday': '10:00-16:00',
      },
      'photoUrl': 'https://i.pravatar.cc/400?img=51',
      'createdAt': now.subtract(const Duration(days: 540)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(minutes: 15)).millisecondsSinceEpoch,
    },
    {
      'id': 'barbershop_001',
      'name': 'Barbearia Classic',
      'accountType': 'barbershop',
      'isPremium': true,
      'boostedUntil': now.add(const Duration(days: 15)).millisecondsSinceEpoch,
      'rating': 4.7,
      'reviewCount': 312,
      'bio': 'Barbearia tradicional desde 1985',
      'location': {
        'address': 'R. da Consolação, 2000 - Consolação, São Paulo - SP',
        'latitude': -23.5540,
        'longitude': -46.6590,
      },
      'services': ['Corte', 'Barba', 'Sobrancelha', 'Massagem', 'Hot Towel'],
      'priceRange': {'min': 45.0, 'max': 120.0},
      'workingHours': {
        'monday': 'Fechado',
        'tuesday': '10:00-20:00',
        'wednesday': '10:00-20:00',
        'thursday': '10:00-20:00',
        'friday': '10:00-21:00',
        'saturday': '09:00-20:00',
        'sunday': '10:00-18:00',
      },
      'photoUrl': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
      'createdAt': now.subtract(const Duration(days: 600)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
    },
    {
      'id': 'barber_004',
      'name': 'Lucas Mendes',
      'accountType': 'barber',
      'isPremium': false,
      'rating': 4.5,
      'reviewCount': 45,
      'bio': 'Jovem talento, especialista em fades',
      'location': {
        'address': 'R. Oscar Freire, 1500 - Pinheiros, São Paulo - SP',
        'latitude': -23.5680,
        'longitude': -46.6710,
      },
      'services': ['Corte', 'Barba', 'Design'],
      'priceRange': {'min': 30.0, 'max': 55.0},
      'workingHours': {
        'monday': '11:00-20:00',
        'tuesday': '11:00-20:00',
        'wednesday': '11:00-20:00',
        'thursday': '11:00-20:00',
        'friday': '11:00-21:00',
        'saturday': '09:00-18:00',
        'sunday': 'Fechado',
      },
      'photoUrl': 'https://i.pravatar.cc/400?img=60',
      'createdAt': now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(hours: 8)).millisecondsSinceEpoch,
    },
    {
      'id': 'barbershop_002',
      'name': 'Barbearia Premium',
      'accountType': 'barbershop',
      'isPremium': true,
      'boostedUntil': now.add(const Duration(days: 30)).millisecondsSinceEpoch,
      'rating': 4.9,
      'reviewCount': 567,
      'bio': 'Experiência premium em cortes masculinos',
      'location': {
        'address': 'Av. Brigadeiro Faria Lima, 2000 - Jardim Paulistano, São Paulo - SP',
        'latitude': -23.5700,
        'longitude': -46.6850,
      },
      'services': ['Corte', 'Barba', 'Sobrancelha', 'Massagem', 'Tratamento Capilar'],
      'priceRange': {'min': 80.0, 'max': 200.0},
      'workingHours': {
        'monday': '09:00-21:00',
        'tuesday': '09:00-21:00',
        'wednesday': '09:00-21:00',
        'thursday': '09:00-21:00',
        'friday': '09:00-22:00',
        'saturday': '08:00-20:00',
        'sunday': '10:00-18:00',
      },
      'photoUrl': 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=400',
      'createdAt': now.subtract(const Duration(days: 450)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(minutes: 30)).millisecondsSinceEpoch,
    },
    {
      'id': 'barber_005',
      'name': 'André Santos',
      'accountType': 'barber',
      'isPremium': false,
      'rating': 4.7,
      'reviewCount': 98,
      'bio': 'Criatividade e estilo em cada corte',
      'location': {
        'address': 'R. Haddock Lobo, 800 - Cerqueira César, São Paulo - SP',
        'latitude': -23.5615,
        'longitude': -46.6625,
      },
      'services': ['Corte', 'Barba', 'Coloração', 'Platinado'],
      'priceRange': {'min': 40.0, 'max': 90.0},
      'workingHours': {
        'monday': '10:00-19:00',
        'tuesday': '10:00-19:00',
        'wednesday': '10:00-19:00',
        'thursday': '10:00-19:00',
        'friday': '10:00-20:00',
        'saturday': '09:00-17:00',
        'sunday': 'Fechado',
      },
      'photoUrl': 'https://i.pravatar.cc/400?img=68',
      'createdAt': now.subtract(const Duration(days: 180)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(hours: 3)).millisecondsSinceEpoch,
    },
    {
      'id': 'barber_006',
      'name': 'Felipe Rodrigues',
      'accountType': 'barber',
      'isPremium': true,
      'boostedUntil': now.add(const Duration(days: 5)).millisecondsSinceEpoch,
      'rating': 4.8,
      'reviewCount': 156,
      'bio': 'Especialista em cabelos afro e cacheados',
      'location': {
        'address': 'Av. Ipiranga, 1000 - República, São Paulo - SP',
        'latitude': -23.5450,
        'longitude': -46.6430,
      },
      'services': ['Corte', 'Barba', 'Tratamento Afro', 'Dreads'],
      'priceRange': {'min': 45.0, 'max': 85.0},
      'workingHours': {
        'monday': '10:00-20:00',
        'tuesday': '10:00-20:00',
        'wednesday': '10:00-20:00',
        'thursday': '10:00-20:00',
        'friday': '10:00-21:00',
        'saturday': '09:00-19:00',
        'sunday': '10:00-16:00',
      },
      'photoUrl': 'https://i.pravatar.cc/400?img=15',
      'createdAt': now.subtract(const Duration(days: 270)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(hours: 4)).millisecondsSinceEpoch,
    },
    {
      'id': 'barbershop_003',
      'name': 'The Barber House',
      'accountType': 'barbershop',
      'isPremium': false,
      'rating': 4.6,
      'reviewCount': 234,
      'bio': 'Ambiente descontraído, cortes de qualidade',
      'location': {
        'address': 'R. Teodoro Sampaio, 2000 - Pinheiros, São Paulo - SP',
        'latitude': -23.5625,
        'longitude': -46.6780,
      },
      'services': ['Corte', 'Barba', 'Sobrancelha'],
      'priceRange': {'min': 35.0, 'max': 70.0},
      'workingHours': {
        'monday': '10:00-20:00',
        'tuesday': '10:00-20:00',
        'wednesday': '10:00-20:00',
        'thursday': '10:00-20:00',
        'friday': '10:00-21:00',
        'saturday': '09:00-19:00',
        'sunday': 'Fechado',
      },
      'photoUrl': 'https://images.unsplash.com/photo-1622286346003-c6e7c316c28a?w=400',
      'createdAt': now.subtract(const Duration(days: 420)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(hours: 6)).millisecondsSinceEpoch,
    },
    {
      'id': 'barber_007',
      'name': 'Marcelo Ferreira',
      'accountType': 'barber',
      'isPremium': true,
      'boostedUntil': now.add(const Duration(days: 10)).millisecondsSinceEpoch,
      'rating': 4.9,
      'reviewCount': 289,
      'bio': 'Master barber, 15 anos transformando estilos',
      'location': {
        'address': 'R. Estados Unidos, 1500 - Jardins, São Paulo - SP',
        'latitude': -23.5660,
        'longitude': -46.6750,
      },
      'services': ['Corte', 'Barba', 'Sobrancelha', 'Massagem', 'Tratamento'],
      'priceRange': {'min': 60.0, 'max': 120.0},
      'workingHours': {
        'monday': '09:00-20:00',
        'tuesday': '09:00-20:00',
        'wednesday': '09:00-20:00',
        'thursday': '09:00-20:00',
        'friday': '09:00-21:00',
        'saturday': '08:00-19:00',
        'sunday': '10:00-17:00',
      },
      'photoUrl': 'https://i.pravatar.cc/400?img=70',
      'createdAt': now.subtract(const Duration(days: 650)).millisecondsSinceEpoch,
      'updatedAt': now.subtract(const Duration(minutes: 45)).millisecondsSinceEpoch,
    },
  ];

  int successCount = 0;
  int errorCount = 0;

  for (var profile in profiles) {
    final profileId = profile['id'] as String;
    profile.remove('id');

    try {
      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection/$profileId',
      );

      final fields = _convertToFirestoreFields(profile);

      final response = await HttpClient().patchUrl(url)
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'fields': fields}));

      final responseData = await response.close();

      if (responseData.statusCode == 200) {
        print('✅ Criado: ${profile['name']} (${profile['accountType']})');
        successCount++;
      } else {
        print('❌ Erro ao criar $profileId: ${responseData.statusCode}');
        print('   ${await responseData.transform(utf8.decoder).join()}');
        errorCount++;
      }
    } catch (e) {
      print('❌ Erro ao criar $profileId: $e');
      errorCount++;
    }
  }

  print('\n============================================================');
  print('🎉 SEED CONCLUÍDO!');
  print('============================================================');
  print('✅ Criados com sucesso: $successCount perfis');
  if (errorCount > 0) {
    print('❌ Erros: $errorCount perfis');
  }
  print('============================================================');
}

Map<String, dynamic> _convertToFirestoreFields(Map<String, dynamic> data) {
  final fields = <String, dynamic>{};

  for (var entry in data.entries) {
    fields[entry.key] = _toFirestoreValue(entry.value);
  }

  return fields;
}

Map<String, dynamic> _toFirestoreValue(dynamic value) {
  if (value is String) {
    return {'stringValue': value};
  } else if (value is int) {
    return {'integerValue': value.toString()};
  } else if (value is double) {
    return {'doubleValue': value};
  } else if (value is bool) {
    return {'booleanValue': value};
  } else if (value is List) {
    return {
      'arrayValue': {'values': value.map(_toFirestoreValue).toList()},
    };
  } else if (value is Map) {
    return {
      'mapValue': {'fields': _convertToFirestoreFields(value as Map<String, dynamic>)},
    };
  } else {
    return {'nullValue': null};
  }
}
