import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeedScreen extends StatefulWidget {
  const SeedScreen({super.key});

  @override
  State<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<SeedScreen> {
  bool _isSeeding = false;
  final List<String> _logs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seed Database'), backgroundColor: Colors.deepPurple),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isSeeding ? null : _seedProfiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isSeeding
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('🌱 Criar 10 Perfis Falsos', style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  Color textColor = Colors.white;
                  if (log.startsWith('✅')) textColor = Colors.green;
                  if (log.startsWith('❌')) textColor = Colors.red;
                  if (log.startsWith('🎉')) textColor = Colors.yellow;

                  return Text(
                    log,
                    style: TextStyle(color: textColor, fontFamily: 'monospace', fontSize: 12),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
    });
  }

  Future<void> _seedProfiles() async {
    setState(() {
      _isSeeding = true;
      _logs.clear();
    });

    _addLog('🌱 Iniciando seed de perfis...');
    _addLog('📝 Criando 10 perfis...\n');

    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();

    final profiles = [
      {
        'id': 'barber_001',
        'name': 'Carlos Silva',
        'accountType': 'barber',
        'isPremium': true,
        'boostedUntil': Timestamp.fromDate(now.add(const Duration(days: 7))),
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
        'avatarUrl': 'https://i.pravatar.cc/400?img=12',
        'portfolioUrls': ['https://i.pravatar.cc/400?img=12'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 365))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(hours: 2))),
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
        'avatarUrl': 'https://i.pravatar.cc/400?img=33',
        'portfolioUrls': ['https://i.pravatar.cc/400?img=33'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 730))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(hours: 5))),
      },
      {
        'id': 'barber_003',
        'name': 'Thiago Alves',
        'accountType': 'barber',
        'isPremium': true,
        'boostedUntil': Timestamp.fromDate(now.add(const Duration(days: 3))),
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
        'avatarUrl': 'https://i.pravatar.cc/400?img=51',
        'portfolioUrls': ['https://i.pravatar.cc/400?img=51'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 540))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(minutes: 15))),
      },
      {
        'id': 'barbershop_001',
        'name': 'Barbearia Classic',
        'accountType': 'barbershop',
        'isPremium': true,
        'boostedUntil': Timestamp.fromDate(now.add(const Duration(days: 15))),
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
        'avatarUrl': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
        'portfolioUrls': ['https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 600))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(hours: 1))),
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
        'avatarUrl': 'https://i.pravatar.cc/400?img=60',
        'portfolioUrls': ['https://i.pravatar.cc/400?img=60'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 30))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(hours: 8))),
      },
      {
        'id': 'barbershop_002',
        'name': 'Barbearia Premium',
        'accountType': 'barbershop',
        'isPremium': true,
        'boostedUntil': Timestamp.fromDate(now.add(const Duration(days: 30))),
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
        'avatarUrl': 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=400',
        'portfolioUrls': ['https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=400'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 450))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(minutes: 30))),
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
        'avatarUrl': 'https://i.pravatar.cc/400?img=68',
        'portfolioUrls': ['https://i.pravatar.cc/400?img=68'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 180))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(hours: 3))),
      },
      {
        'id': 'barber_006',
        'name': 'Felipe Rodrigues',
        'accountType': 'barber',
        'isPremium': true,
        'boostedUntil': Timestamp.fromDate(now.add(const Duration(days: 5))),
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
        'avatarUrl': 'https://i.pravatar.cc/400?img=15',
        'portfolioUrls': ['https://i.pravatar.cc/400?img=15'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 270))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(hours: 4))),
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
        'avatarUrl': 'https://images.unsplash.com/photo-1622286346003-c6e7c316c28a?w=400',
        'portfolioUrls': ['https://images.unsplash.com/photo-1622286346003-c6e7c316c28a?w=400'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 420))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(hours: 6))),
      },
      {
        'id': 'barber_007',
        'name': 'Marcelo Ferreira',
        'accountType': 'barber',
        'isPremium': true,
        'boostedUntil': Timestamp.fromDate(now.add(const Duration(days: 10))),
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
        'avatarUrl': 'https://i.pravatar.cc/400?img=70',
        'portfolioUrls': ['https://i.pravatar.cc/400?img=70'],
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 650))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(minutes: 45))),
      },
    ];

    int successCount = 0;
    int errorCount = 0;

    for (var profile in profiles) {
      final profileId = profile['id'] as String;
      profile.remove('id');

      try {
        await firestore.collection('profiles').doc(profileId).set(profile);
        _addLog('✅ Criado: ${profile['name']} (${profile['accountType']})');
        successCount++;
      } catch (e) {
        _addLog('❌ Erro ao criar $profileId: $e');
        errorCount++;
      }
    }

    _addLog('\n============================================================');
    _addLog('🎉 SEED CONCLUÍDO!');
    _addLog('============================================================');
    _addLog('✅ Criados com sucesso: $successCount perfis');
    if (errorCount > 0) {
      _addLog('❌ Erros: $errorCount perfis');
    }
    _addLog('============================================================');

    setState(() {
      _isSeeding = false;
    });
  }
}
