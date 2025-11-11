import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  print('🌱 Iniciando seed de perfis...\n');

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC2Bc5zn-00KeQO8sb0uV1zkXeJXpql2GQ',
      appId: '1:419635741185:android:8c77f0b01a4dca08f4e0f0',
      messagingSenderId: '419635741185',
      projectId: 'barbergo-38c21',
      storageBucket: 'barbergo-38c21.firebasestorage.app',
    ),
  );

  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();

  // Lista de perfis fake
  final profiles = [
    {
      'id': 'barber_001',
      'name': 'Carlos Silva',
      'accountType': 'barber',
      'email': 'carlos.silva@example.com',
      'phone': '+55 11 98765-4321',
      'bio': 'Barbeiro especializado em cortes modernos e degradês. 10 anos de experiência.',
      'photoUrl': 'https://i.pravatar.cc/300?img=12',
      'rating': 4.8,
      'reviewCount': 127,
      'isPremium': true,
      'boostedUntil': now.add(Duration(days: 7)),
      'services': ['Corte', 'Barba', 'Sobrancelha', 'Platinado'],
      'priceRange': {'min': 30, 'max': 80},
      'location': {
        'address': 'Rua Augusta, 1500 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5505,
        'longitude': -46.6333,
      },
      'workingHours': {
        'monday': {'start': '09:00', 'end': '19:00'},
        'tuesday': {'start': '09:00', 'end': '19:00'},
        'wednesday': {'start': '09:00', 'end': '19:00'},
        'thursday': {'start': '09:00', 'end': '19:00'},
        'friday': {'start': '09:00', 'end': '20:00'},
        'saturday': {'start': '08:00', 'end': '18:00'},
      },
      'createdAt': now.subtract(Duration(days: 180)),
      'updatedAt': now.subtract(Duration(hours: 2)),
    },
    {
      'id': 'barber_002',
      'name': 'Rafael Costa',
      'accountType': 'barber',
      'email': 'rafael.costa@example.com',
      'phone': '+55 21 99876-5432',
      'bio': 'Especialista em barbas e cortes clássicos. Atendimento personalizado.',
      'photoUrl': 'https://i.pravatar.cc/300?img=15',
      'rating': 4.6,
      'reviewCount': 89,
      'isPremium': false,
      'boostedUntil': null,
      'services': ['Corte', 'Barba', 'Massagem'],
      'priceRange': {'min': 25, 'max': 60},
      'location': {
        'address': 'Av. Paulista, 2500 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5629,
        'longitude': -46.6544,
      },
      'workingHours': {
        'tuesday': {'start': '10:00', 'end': '18:00'},
        'wednesday': {'start': '10:00', 'end': '18:00'},
        'thursday': {'start': '10:00', 'end': '18:00'},
        'friday': {'start': '10:00', 'end': '19:00'},
        'saturday': {'start': '09:00', 'end': '17:00'},
      },
      'createdAt': now.subtract(Duration(days: 90)),
      'updatedAt': now.subtract(Duration(hours: 5)),
    },
    {
      'id': 'barber_003',
      'name': 'Thiago Alves',
      'accountType': 'barber',
      'email': 'thiago.alves@example.com',
      'phone': '+55 11 97654-3210',
      'bio': 'Barbeiro tradicional com toque moderno. Especialidade em degradês.',
      'photoUrl': 'https://i.pravatar.cc/300?img=33',
      'rating': 4.9,
      'reviewCount': 203,
      'isPremium': true,
      'boostedUntil': now.add(Duration(days: 3)),
      'services': ['Corte', 'Barba', 'Coloração', 'Design'],
      'priceRange': {'min': 40, 'max': 100},
      'location': {
        'address': 'Rua Oscar Freire, 800 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5618,
        'longitude': -46.6699,
      },
      'workingHours': {
        'monday': {'start': '08:00', 'end': '20:00'},
        'tuesday': {'start': '08:00', 'end': '20:00'},
        'wednesday': {'start': '08:00', 'end': '20:00'},
        'thursday': {'start': '08:00', 'end': '20:00'},
        'friday': {'start': '08:00', 'end': '21:00'},
        'saturday': {'start': '07:00', 'end': '19:00'},
      },
      'createdAt': now.subtract(Duration(days: 365)),
      'updatedAt': now.subtract(Duration(minutes: 30)),
    },
    {
      'id': 'barbershop_001',
      'name': 'Barbearia Classic',
      'accountType': 'barbershop',
      'email': 'contato@classic.com',
      'phone': '+55 11 3456-7890',
      'bio': 'Barbearia tradicional desde 1985. Ambiente acolhedor e profissionais experientes.',
      'photoUrl': 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=300',
      'rating': 4.7,
      'reviewCount': 312,
      'isPremium': true,
      'boostedUntil': now.add(Duration(days: 15)),
      'services': ['Corte', 'Barba', 'Sobrancelha', 'Relaxamento'],
      'priceRange': {'min': 35, 'max': 90},
      'location': {
        'address': 'Rua da Consolação, 3000 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5489,
        'longitude': -46.6588,
      },
      'workingHours': {
        'monday': {'start': '09:00', 'end': '19:00'},
        'tuesday': {'start': '09:00', 'end': '19:00'},
        'wednesday': {'start': '09:00', 'end': '19:00'},
        'thursday': {'start': '09:00', 'end': '19:00'},
        'friday': {'start': '09:00', 'end': '20:00'},
        'saturday': {'start': '08:00', 'end': '18:00'},
        'sunday': {'start': '09:00', 'end': '14:00'},
      },
      'createdAt': now.subtract(Duration(days: 500)),
      'updatedAt': now.subtract(Duration(hours: 1)),
    },
    {
      'id': 'barber_004',
      'name': 'Lucas Mendes',
      'accountType': 'barber',
      'email': 'lucas.mendes@example.com',
      'phone': '+55 11 96543-2109',
      'bio': 'Jovem talento especializado em cortes estilosos e modernos.',
      'photoUrl': 'https://i.pravatar.cc/300?img=51',
      'rating': 4.5,
      'reviewCount': 45,
      'isPremium': false,
      'boostedUntil': null,
      'services': ['Corte', 'Barba', 'Platinado'],
      'priceRange': {'min': 30, 'max': 70},
      'location': {
        'address': 'Rua Haddock Lobo, 500 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5647,
        'longitude': -46.6629,
      },
      'workingHours': {
        'monday': {'start': '10:00', 'end': '18:00'},
        'wednesday': {'start': '10:00', 'end': '18:00'},
        'thursday': {'start': '10:00', 'end': '18:00'},
        'friday': {'start': '10:00', 'end': '20:00'},
        'saturday': {'start': '09:00', 'end': '16:00'},
      },
      'createdAt': now.subtract(Duration(days: 30)),
      'updatedAt': now.subtract(Duration(hours: 8)),
    },
    {
      'id': 'barbershop_002',
      'name': 'Barbearia Premium',
      'accountType': 'barbershop',
      'email': 'contato@premium.com',
      'phone': '+55 11 3333-4444',
      'bio': 'Barbearia de alto padrão com serviços exclusivos e ambiente sofisticado.',
      'photoUrl': 'https://images.unsplash.com/photo-1621605815971-fbc98d665033?w=300',
      'rating': 4.9,
      'reviewCount': 567,
      'isPremium': true,
      'boostedUntil': now.add(Duration(days: 30)),
      'services': ['Corte Premium', 'Barba Luxo', 'Spa Facial', 'Massagem', 'Tratamento Capilar'],
      'priceRange': {'min': 60, 'max': 200},
      'location': {
        'address': 'Av. Brigadeiro Faria Lima, 3000 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5781,
        'longitude': -46.6825,
      },
      'workingHours': {
        'monday': {'start': '08:00', 'end': '20:00'},
        'tuesday': {'start': '08:00', 'end': '20:00'},
        'wednesday': {'start': '08:00', 'end': '20:00'},
        'thursday': {'start': '08:00', 'end': '20:00'},
        'friday': {'start': '08:00', 'end': '21:00'},
        'saturday': {'start': '08:00', 'end': '19:00'},
        'sunday': {'start': '10:00', 'end': '16:00'},
      },
      'createdAt': now.subtract(Duration(days: 730)),
      'updatedAt': now.subtract(Duration(minutes: 15)),
    },
    {
      'id': 'barber_005',
      'name': 'André Santos',
      'accountType': 'barber',
      'email': 'andre.santos@example.com',
      'phone': '+55 11 95432-1098',
      'bio': 'Barbeiro criativo com especialização em design de barba e cortes artísticos.',
      'photoUrl': 'https://i.pravatar.cc/300?img=68',
      'rating': 4.7,
      'reviewCount': 98,
      'isPremium': false,
      'boostedUntil': null,
      'services': ['Corte Artístico', 'Design de Barba', 'Coloração'],
      'priceRange': {'min': 35, 'max': 85},
      'location': {
        'address': 'Rua dos Pinheiros, 1200 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5658,
        'longitude': -46.6918,
      },
      'workingHours': {
        'tuesday': {'start': '11:00', 'end': '19:00'},
        'wednesday': {'start': '11:00', 'end': '19:00'},
        'thursday': {'start': '11:00', 'end': '19:00'},
        'friday': {'start': '11:00', 'end': '21:00'},
        'saturday': {'start': '10:00', 'end': '18:00'},
      },
      'createdAt': now.subtract(Duration(days: 120)),
      'updatedAt': now.subtract(Duration(hours: 3)),
    },
    {
      'id': 'barber_006',
      'name': 'Felipe Rodrigues',
      'accountType': 'barber',
      'email': 'felipe.rodrigues@example.com',
      'phone': '+55 11 94321-0987',
      'bio': 'Especialista em cortes afro e cacheados. Valorizo a naturalidade dos fios.',
      'photoUrl': 'https://i.pravatar.cc/300?img=70',
      'rating': 4.8,
      'reviewCount': 156,
      'isPremium': true,
      'boostedUntil': now.add(Duration(days: 5)),
      'services': ['Corte Afro', 'Barba', 'Finalização Cachos', 'Hidratação'],
      'priceRange': {'min': 40, 'max': 95},
      'location': {
        'address': 'Av. Rebouças, 2500 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5594,
        'longitude': -46.6719,
      },
      'workingHours': {
        'monday': {'start': '09:00', 'end': '18:00'},
        'tuesday': {'start': '09:00', 'end': '18:00'},
        'wednesday': {'start': '09:00', 'end': '18:00'},
        'thursday': {'start': '09:00', 'end': '18:00'},
        'friday': {'start': '09:00', 'end': '19:00'},
        'saturday': {'start': '08:00', 'end': '17:00'},
      },
      'createdAt': now.subtract(Duration(days: 200)),
      'updatedAt': now.subtract(Duration(hours: 4)),
    },
    {
      'id': 'barbershop_003',
      'name': 'The Barber House',
      'accountType': 'barbershop',
      'email': 'contact@barberhouse.com',
      'phone': '+55 11 2222-3333',
      'bio': 'Barbearia moderna com equipe qualificada. Experiência única para nossos clientes.',
      'photoUrl': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300',
      'rating': 4.6,
      'reviewCount': 234,
      'isPremium': false,
      'boostedUntil': null,
      'services': ['Corte', 'Barba', 'Sobrancelha', 'Luzes'],
      'priceRange': {'min': 32, 'max': 75},
      'location': {
        'address': 'Rua Bela Cintra, 1500 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5592,
        'longitude': -46.6621,
      },
      'workingHours': {
        'monday': {'start': '09:00', 'end': '19:00'},
        'tuesday': {'start': '09:00', 'end': '19:00'},
        'wednesday': {'start': '09:00', 'end': '19:00'},
        'thursday': {'start': '09:00', 'end': '19:00'},
        'friday': {'start': '09:00', 'end': '20:00'},
        'saturday': {'start': '08:00', 'end': '18:00'},
      },
      'createdAt': now.subtract(Duration(days: 300)),
      'updatedAt': now.subtract(Duration(hours: 6)),
    },
    {
      'id': 'barber_007',
      'name': 'Marcelo Ferreira',
      'accountType': 'barber',
      'email': 'marcelo.ferreira@example.com',
      'phone': '+55 11 93210-9876',
      'bio': 'Barbeiro clássico com 15 anos de experiência. Atendimento de qualidade garantido.',
      'photoUrl': 'https://i.pravatar.cc/300?img=8',
      'rating': 4.9,
      'reviewCount': 289,
      'isPremium': true,
      'boostedUntil': now.add(Duration(days: 10)),
      'services': ['Corte Clássico', 'Barba Tradicional', 'Navalha', 'Sobrancelha'],
      'priceRange': {'min': 38, 'max': 88},
      'location': {
        'address': 'Av. São João, 1800 - São Paulo, SP',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5447,
        'longitude': -46.6406,
      },
      'workingHours': {
        'monday': {'start': '08:30', 'end': '19:00'},
        'tuesday': {'start': '08:30', 'end': '19:00'},
        'wednesday': {'start': '08:30', 'end': '19:00'},
        'thursday': {'start': '08:30', 'end': '19:00'},
        'friday': {'start': '08:30', 'end': '20:00'},
        'saturday': {'start': '08:00', 'end': '18:00'},
      },
      'createdAt': now.subtract(Duration(days: 450)),
      'updatedAt': now.subtract(Duration(hours: 1)),
    },
  ];

  print('📝 Criando ${profiles.length} perfis...\n');

  int successCount = 0;
  int errorCount = 0;

  for (var profile in profiles) {
    try {
      final profileId = profile['id'] as String;
      final profileData = Map<String, dynamic>.from(profile);
      profileData.remove('id');

      await firestore.collection('profiles').doc(profileId).set(profileData);

      print('✅ Criado: ${profile['name']} (${profile['accountType']})');
      successCount++;
    } catch (e) {
      print('❌ Erro ao criar ${profile['name']}: $e');
      errorCount++;
    }
  }

  print('\n${'=' * 60}');
  print('🎉 SEED CONCLUÍDO!');
  print('=' * 60);
  print('✅ Criados com sucesso: $successCount perfis');
  if (errorCount > 0) {
    print('❌ Erros: $errorCount perfis');
  }
  print('=' * 60);

  exit(0);
}
