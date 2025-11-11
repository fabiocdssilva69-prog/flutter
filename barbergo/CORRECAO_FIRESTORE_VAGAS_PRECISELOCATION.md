# Correção: Adicionar preciseLocation nas Vagas Existentes

## Problema Identificado

**Data:** 09/Nov/2025 05:00  
**Erro:** MapperException ao carregar vagas  
**Logs:**
```
I/flutter: ❌ ERRO ao carregar vagas: MapperException: Failed to decode (VacancyEntity).preciseLocation: Parameter preciseLocation is missing.
```

## Análise

O campo `preciseLocation` foi adicionado ao `VacancyEntity` no Sprint 24 (geo-localização), mas:
1. ✅ Código atualizado: `preciseLocation` agora é opcional (`Map<String, dynamic>?`)
2. ✅ Mapper regenerado com build_runner
3. ❌ **Vagas existentes no Firestore NÃO têm o campo `preciseLocation`**

## Correção Aplicada no Código

**Arquivo:** `lib/src/domain/entities/vacancy_entity.dart`

**Antes:**
```dart
@MappableField(hook: GeoFirePointHook())
final Map<String, dynamic> preciseLocation; // OBRIGATÓRIO

VacancyEntity({
  required this.preciseLocation, // ← REQUIRED
  ...
});
```

**Depois:**
```dart
@MappableField(hook: GeoFirePointHook())
final Map<String, dynamic>? preciseLocation; // OPCIONAL

VacancyEntity({
  this.preciseLocation, // ← OPCIONAL
  ...
});

// Getter com null safety
GeoFirePoint get geoLocation {
  if (preciseLocation == null) {
    return GeoFirePoint(const GeoPoint(0, 0));
  }
  try {
    final geopoint = preciseLocation!['geopoint'];
    if (geopoint is GeoPoint) {
      return GeoFirePoint(geopoint);
    }
  } catch (e) {
    return GeoFirePoint(const GeoPoint(0, 0));
  }
  return GeoFirePoint(const GeoPoint(0, 0));
}
```

## Correção no Firestore (NECESSÁRIA)

### Opção 1: Adicionar campo manualmente no Firebase Console

1. Abrir Firebase Console: https://console.firebase.google.com
2. Projeto: BarberGO
3. Firestore Database → Coleção `vacancies`
4. Para cada documento de vaga:
   - Adicionar campo `preciseLocation` (map)
   - Estrutura:
     ```json
     {
       "preciseLocation": {
         "geopoint": {
           "_latitude": -23.5505,
           "_longitude": -46.6333
         },
         "geohash": "6gykzpj"
       }
     }
     ```

### Opção 2: Script de migração (criar arquivo separado)

```dart
// migration_add_precise_location.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

Future<void> migratePreciseLocation() async {
  final db = FirebaseFirestore.instance;
  final vacancies = await db.collection('vacancies').get();
  
  for (var doc in vacancies.docs) {
    final data = doc.data();
    
    // Se já tem preciseLocation, pula
    if (data.containsKey('preciseLocation')) continue;
    
    // Usar cidade/estado para criar coordenada padrão
    final locationCityState = data['locationCityState'] as String?;
    
    // Coordenadas padrão: Centro de São Paulo
    final geoPoint = const GeoPoint(-23.5505, -46.6333);
    final geoFirePoint = GeoFirePoint(geoPoint);
    
    await doc.reference.update({
      'preciseLocation': geoFirePoint.data,
    });
    
    print('✅ Vaga ${doc.id} atualizada com preciseLocation');
  }
  
  print('🎉 Migração completa!');
}
```

### Opção 3: Correção ao criar novas vagas

Atualizar `VacancyRepository.createVacancy()` para sempre incluir `preciseLocation`:

```dart
// lib/src/data/repositories/vacancy_repository.dart
Future<void> createVacancy(VacancyEntity vacancy) async {
  final data = vacancy.toMap();
  
  // Garantir que preciseLocation existe
  if (!data.containsKey('preciseLocation') || data['preciseLocation'] == null) {
    // Usar coordenada padrão baseada em locationCityState
    final geoPoint = const GeoPoint(-23.5505, -46.6333); // São Paulo
    final geoFirePoint = GeoFirePoint(geoPoint);
    data['preciseLocation'] = geoFirePoint.data;
  }
  
  await _db.collection('vacancies').add(data);
}
```

## Estado Atual

- ✅ Código atualizado (`preciseLocation` opcional)
- ✅ Mapper regenerado
- ⏳ Precisa rebuildar APK
- ⏳ Precisa adicionar campo nas vagas existentes no Firestore

## Próximos Passos

1. **Rebuildar APK** com código atualizado
2. **Corrigir vagas no Firestore** (escolher opção 1, 2 ou 3)
3. **Testar** carregamento da lista de vagas
4. **Validar** criação de novas vagas com preciseLocation

## Comandos

```powershell
# Regenerar código
dart run build_runner build --delete-conflicting-outputs

# Build APK
flutter build apk --release

# Instalar no dispositivo
flutter install -d uwbekb8hpf6lamts

# Monitorar logs
flutter logs -d uwbekb8hpf6lamts
```

## Validação

**Logs esperados após correção:**
```
I/flutter: 📦 Vagas carregadas: 1
```

**Logs atuais (ERRO):**
```
I/flutter: ❌ ERRO ao carregar vagas: MapperException: Failed to decode (VacancyEntity).preciseLocation: Parameter preciseLocation is missing.
```
