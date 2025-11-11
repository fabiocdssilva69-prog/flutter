# 🚀 PLANO DE AÇÃO IMEDIATO - BarberGO

**Data:** 02/11/2025  
**Sprint Atual:** 1 (85% completo)  
**Meta:** Completar Sprint 1 e avançar para Sprint 2

---

## 🎯 ESTRATÉGIA DE EXECUÇÃO

### **Divisão de Responsabilidades:**

```
┌─────────────────────────────────────────┐
│  🤖 AGENTE (EU)         │  👤 VOCÊ      │
├─────────────────────────┼───────────────┤
│  • Código Flutter       │  • Firebase   │
│  • UI/UX                │  • API Keys   │
│  • Lógica de negócio    │  • Deploy     │
│  • Documentação         │  • Testes     │
└─────────────────────────┴───────────────┘
```

---

## 📋 PARTE 1: TAREFAS PARALELAS (AGORA)

### 🤖 **EU FAÇO (Código Flutter):**

#### **1. Onboarding Tutorial** ⏳ IN PROGRESS

**Status:** Iniciando agora  
**Tempo:** 2-3 horas  
**Prioridade:** 🔴 CRÍTICA (última task do Sprint 1)

**O que vou implementar:**

```dart
// lib/src/features/onboarding/screens/tutorial_screen.dart
- PageView com 4 telas
- Dots indicator
- Botões "Pular" e "Continuar"/"Começar"
- SharedPreferences para não mostrar novamente
- Animações suaves

// Páginas:
1. "Encontre Profissionais" (icon: people, blue)
2. "Dê Match e Converse" (icon: favorite, red)
3. "Agende Serviços" (icon: event, green)
4. "Seja Premium" (icon: workspace_premium, amber)
```

**Arquivos que vou criar:**

- `lib/src/features/onboarding/screens/tutorial_screen.dart`
- `lib/src/features/onboarding/providers/tutorial_provider.dart`

**Package necessário:**

```yaml
# Já vou adicionar no pubspec.yaml
shared_preferences: ^2.2.2
```

---

#### **2. Desfazer Swipe (Premium Feature)** 🆕

**Status:** Após tutorial  
**Tempo:** 2-3 horas  
**Prioridade:** 🟡 ALTA

**O que vou implementar:**

```dart
// lib/src/features/discovery/presentation/swipe_screen.dart
- Botão "Desfazer" no topo
- Verificar se usuário é Premium
- Armazenar último swipe em StateNotifier
- Reverter swipe (remover de likes/dislikes)
- Feedback visual (animação reversa)
- Mostrar paywall se não for Premium
```

**Lógica:**

1. Guardar último perfil swipado + ação (like/dislike)
2. Ao clicar "Desfazer":
   - Se Premium: reverter ação no Firestore
   - Se Free: mostrar modal "Recurso Premium"

---

#### **3. Corrigir ProfileDetailScreen** 🔧

**Status:** Rápido, posso fazer entre outras tasks  
**Tempo:** 1 hora  
**Prioridade:** 🟢 MÉDIA

**Problemas pré-existentes:**

```dart
// ERROS:
widget.profile.photoUrls        // ❌ Usar portfolioUrls
widget.profile.address           // ❌ Usar location
widget.profile.priceRange        // ❌ Usar hourlyRate ou remover
widget.profile.isVerified        // ❌ Remover por enquanto
widget.profile.distanceInKm      // ❌ Calcular ou remover
widget.profile.instagramUrl      // ❌ Remover ou adicionar campo
widget.profile.facebookUrl       // ❌ Remover ou adicionar campo
```

**Solução rápida:** Comentar/remover seções que usam campos inexistentes

---

### 👤 **VOCÊ DELEGA (Tarefas Externas):**

#### **A. Firebase Setup para Verificação de Perfil** 🔐

**Delegue para agente Firebase/Backend**  
**Tempo estimado:** 2-3 horas  
**Quando:** Pode fazer em paralelo

**Instruções completas:**

```bash
# 1. Habilitar Firebase Storage
firebase login
cd C:\workspaces\fabiocdssilva69-prog\barbergo
firebase init storage

# Quando perguntar "What file should be used for Storage Rules?":
# Usar: storage.rules

# 2. Criar regras de Storage
```

**Arquivo: `storage.rules`**

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Verificação de documentos
    match /verifications/{userId}/{document} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024 // 5MB max
                   && request.resource.contentType.matches('image/.*');
    }
    
    // Certificados
    match /certificates/{userId}/{certId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024;
    }
    
    // Portfólio
    match /portfolio/{userId}/{imageId} {
      allow read: if true; // Público
      allow write: if request.auth != null 
                    && request.auth.uid == userId
                    && request.resource.size < 5 * 1024 * 1024;
    }
  }
}
```

**3. Deploy das regras:**

```bash
firebase deploy --only storage
```

---

**Arquivo: `functions/src/verification.ts`** (NOVO)

```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Cloud Function para processar verificação
export const processVerification = functions.firestore
  .document('verifications/{verificationId}')
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const { userId, documentUrl, documentType } = data;
    
    try {
      // 1. Aqui você pode integrar com APIs de verificação
      // Ex: AWS Rekognition, Google Cloud Vision
      // Por enquanto, vamos fazer verificação manual
      
      // 2. Atualizar status da verificação
      await snap.ref.update({
        status: 'pending',
        submittedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      // 3. Enviar notificação para admin revisar
      await admin.firestore().collection('admin_tasks').add({
        type: 'verification_pending',
        userId,
        verificationId: context.params.verificationId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      return { success: true };
    } catch (error) {
      console.error('Erro ao processar verificação:', error);
      throw error;
    }
  });

// Aprovar verificação (chamada por admin)
export const approveVerification = functions.https.onCall(async (data, context) => {
  // Verificar se quem está chamando é admin
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError('permission-denied', 'Apenas admins podem aprovar.');
  }
  
  const { userId, verificationId } = data;
  
  try {
    // 1. Atualizar status da verificação
    await admin.firestore()
      .collection('verifications')
      .doc(verificationId)
      .update({
        status: 'approved',
        approvedAt: admin.firestore.FieldValue.serverTimestamp(),
        approvedBy: context.auth.uid,
      });
    
    // 2. Atualizar perfil do usuário
    await admin.firestore()
      .collection('profiles')
      .doc(userId)
      .update({
        isVerified: true,
        verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    // 3. Enviar notificação para o usuário
    // (implementar FCM aqui)
    
    return { success: true };
  } catch (error) {
    console.error('Erro ao aprovar verificação:', error);
    throw new functions.https.HttpsError('internal', 'Erro ao aprovar verificação');
  }
});

// Rejeitar verificação
export const rejectVerification = functions.https.onCall(async (data, context) => {
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError('permission-denied', 'Apenas admins podem rejeitar.');
  }
  
  const { userId, verificationId, reason } = data;
  
  try {
    await admin.firestore()
      .collection('verifications')
      .doc(verificationId)
      .update({
        status: 'rejected',
        rejectedAt: admin.firestore.FieldValue.serverTimestamp(),
        rejectedBy: context.auth.uid,
        rejectionReason: reason,
      });
    
    // Notificar usuário
    // (implementar FCM)
    
    return { success: true };
  } catch (error) {
    console.error('Erro ao rejeitar verificação:', error);
    throw new functions.https.HttpsError('internal', 'Erro ao rejeitar verificação');
  }
});
```

**4. Adicionar ao `functions/src/index.ts`:**

```typescript
export { processVerification, approveVerification, rejectVerification } from './verification';
```

**5. Deploy das functions:**

```bash
cd functions
npm install
cd ..
firebase deploy --only functions:processVerification,functions:approveVerification,functions:rejectVerification
```

---

#### **B. Google Maps API Key** 🗺️

**Delegue para agente Google Cloud**  
**Tempo estimado:** 30 minutos  
**Quando:** Necessário antes de implementar mapa

**Instruções:**

**1. Acessar Google Cloud Console:**

```
https://console.cloud.google.com/
```

**2. Criar/Selecionar projeto:**

- Nome: `barbergo-maps` (ou usar projeto existente)

**3. Habilitar APIs:**

```
- Maps SDK for Android
- Maps SDK for iOS
- Maps JavaScript API (para web)
- Geocoding API
- Places API
```

**4. Criar credenciais:**

- Ir em: APIs & Services → Credentials
- Create Credentials → API Key
- Copiar a chave gerada

**5. Restringir API Key (SEGURANÇA):**

```
Application restrictions:
- Android apps: Adicionar SHA-1 do app
- iOS apps: Adicionar Bundle ID
- Websites: Adicionar domínio

API restrictions:
- Selecionar apenas as APIs necessárias listadas acima
```

**6. Salvar chave em `.env`:**

```env
GOOGLE_MAPS_API_KEY=AIzaSy...
```

**7. Configurar no projeto:**

**Android:** `android/app/src/main/AndroidManifest.xml`

```xml
<application>
  <meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="${GOOGLE_MAPS_API_KEY}"/>
</application>
```

**iOS:** `ios/Runner/AppDelegate.swift`

```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_API_KEY")
```

---

#### **C. Firestore Indexes para Filtros Avançados** 📊

**Delegue para agente Firebase**  
**Tempo estimado:** 15 minutos  
**Quando:** Antes de implementar filtros avançados

**Instruções:**

**Arquivo: `firestore.indexes.json`** (adicionar ao existente)

```json
{
  "indexes": [
    {
      "collectionGroup": "profiles",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "accountType", "order": "ASCENDING" },
        { "fieldPath": "isVerified", "order": "ASCENDING" },
        { "fieldPath": "hourlyRate", "order": "ASCENDING" },
        { "fieldPath": "rating", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "profiles",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "accountType", "order": "ASCENDING" },
        { "fieldPath": "services", "arrayConfig": "CONTAINS" },
        { "fieldPath": "rating", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "vacancies",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "type", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "vacancies",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "location", "order": "ASCENDING" },
        { "fieldPath": "salary", "order": "DESCENDING" }
      ]
    }
  ],
  "fieldOverrides": []
}
```

**Deploy:**

```bash
firebase deploy --only firestore:indexes
```

---

## 📋 PARTE 2: PRÓXIMAS FEATURES (SEQUENCIAL)

### **Feature 1: Mapa Interativo** 🗺️

#### **🤖 EU FAÇO (Flutter):**

**1. Adicionar packages:**

```yaml
# pubspec.yaml
dependencies:
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
```

**2. Criar MapScreen:**

```dart
// lib/src/features/discovery/presentation/map_screen.dart

class MapScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa de Profissionais')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-23.5505, -46.6333), // São Paulo
          zoom: 12,
        ),
        markers: _markers,
        onMapCreated: (controller) => _mapController = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadNearbyProfiles,
        child: Icon(Icons.refresh),
      ),
    );
  }
  
  Future<void> _loadNearbyProfiles() async {
    // Buscar perfis próximos usando GeoFirePoint
    // Adicionar markers no mapa
  }
}
```

**Tempo:** 8-10 horas

---

#### **👤 VOCÊ FAZ:**

- ✅ Criar Google Maps API Key (instruções acima)
- ✅ Configurar no Android/iOS
- ✅ Testar no dispositivo real (requer API key válida)

---

### **Feature 2: Sistema de Verificação** ✅

#### **🤖 EU FAÇO (Flutter):**

**1. Atualizar ProfileEntity:**

```dart
// lib/src/domain/entities/profile_entity.dart

@freezed
class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    // ... campos existentes
    
    // NOVOS:
    @Default(false) bool isVerified,
    DateTime? verifiedAt,
    @Default([]) List<String> verificationDocuments,
  }) = _ProfileEntity;
}
```

**2. Criar VerificationScreen:**

```dart
// lib/src/features/verification/screens/verification_screen.dart

class VerificationScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  String? _selectedDocumentType;
  File? _documentImage;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verificar Perfil')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Seletor de tipo de documento
          DropdownButton<String>(
            value: _selectedDocumentType,
            items: [
              DropdownMenuItem(value: 'rg', child: Text('RG')),
              DropdownMenuItem(value: 'cnh', child: Text('CNH')),
              DropdownMenuItem(value: 'diploma', child: Text('Diploma de Barbeiro')),
            ],
            onChanged: (value) => setState(() => _selectedDocumentType = value),
          ),
          
          // Upload de documento
          if (_documentImage != null)
            Image.file(_documentImage!, height: 200),
          
          ElevatedButton.icon(
            onPressed: _pickDocument,
            icon: Icon(Icons.camera_alt),
            label: Text('Tirar Foto do Documento'),
          ),
          
          // Instruções
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📋 Instruções:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('• Documento deve estar legível'),
                  Text('• Foto com boa iluminação'),
                  Text('• Todos os dados visíveis'),
                  Text('• Análise leva até 48h'),
                ],
              ),
            ),
          ),
          
          // Botão enviar
          ElevatedButton(
            onPressed: _submitVerification,
            child: Text('Enviar para Verificação'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _documentImage = File(image.path));
    }
  }
  
  Future<void> _submitVerification() async {
    // Upload para Firebase Storage
    // Criar documento em /verifications
    // Cloud Function processa automaticamente
  }
}
```

**3. Criar VerificationRepository:**

```dart
// lib/src/data/repositories/verification_repository.dart

@riverpod
class VerificationRepository extends _$VerificationRepository {
  @override
  FutureOr<void> build() {}
  
  Future<void> submitVerification({
    required String userId,
    required File documentImage,
    required String documentType,
  }) async {
    // 1. Upload imagem para Storage
    final storageRef = FirebaseStorage.instance
        .ref('verifications/$userId/${Uuid().v4()}.jpg');
    
    await storageRef.putFile(documentImage);
    final documentUrl = await storageRef.getDownloadURL();
    
    // 2. Criar documento de verificação
    await FirebaseFirestore.instance
        .collection('verifications')
        .add({
      'userId': userId,
      'documentUrl': documentUrl,
      'documentType': documentType,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  Stream<String> watchVerificationStatus(String userId) {
    return FirebaseFirestore.instance
        .collection('verifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return 'not_submitted';
      return snapshot.docs.first.data()['status'] as String;
    });
  }
}
```

**Tempo:** 6-8 horas

---

#### **👤 VOCÊ FAZ:**

- ✅ Deploy das Cloud Functions (instruções acima na Parte 1-A)
- ✅ Configurar Storage Rules
- ✅ Criar painel admin para aprovar/rejeitar (opcional)

---

### **Feature 3: Upload de Certificados** 📜

#### **🤖 EU FAÇO (Flutter):**

**1. Atualizar ProfileEntity:**

```dart
// Adicionar:
@Default([]) List<CertificateEntity> certificates,

// Criar:
@freezed
class CertificateEntity with _$CertificateEntity {
  const factory CertificateEntity({
    required String id,
    required String name,
    required String imageUrl,
    String? institution,
    DateTime? issuedAt,
    DateTime? uploadedAt,
  }) = _CertificateEntity;
}
```

**2. Criar CertificatesScreen:**

```dart
// lib/src/features/certificates/screens/certificates_screen.dart

class CertificatesScreen extends ConsumerStatefulWidget {
  final String userId;
  final bool isOwner;
  
  @override
  ConsumerState<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends ConsumerState<CertificatesScreen> {
  @override
  Widget build(BuildContext context) {
    final certificates = ref.watch(certificatesProvider(widget.userId));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificados'),
        actions: widget.isOwner ? [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addCertificate,
          ),
        ] : null,
      ),
      body: certificates.when(
        data: (certs) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: certs.length,
          itemBuilder: (context, index) => _buildCertificateCard(certs[index]),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erro: $e')),
      ),
    );
  }
  
  Widget _buildCertificateCard(CertificateEntity cert) {
    return Card(
      child: InkWell(
        onTap: () => _viewCertificate(cert),
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: cert.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(cert.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (cert.institution != null)
                    Text(cert.institution!, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Tempo:** 4-6 horas

---

#### **👤 VOCÊ FAZ:**

- ✅ Storage já configurado na Parte 1-A
- ✅ Testar uploads

---

### **Feature 4: Filtros Avançados (Premium)** 🔍

#### **🤖 EU FAÇO (Flutter):**

**1. Criar AdvancedFiltersScreen:**

```dart
// lib/src/features/discovery/presentation/advanced_filters_screen.dart

class AdvancedFiltersScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AdvancedFiltersScreen> createState() => _AdvancedFiltersScreenState();
}

class _AdvancedFiltersScreenState extends ConsumerState<AdvancedFiltersScreen> {
  List<String> _selectedServices = [];
  RangeValues _priceRange = RangeValues(20, 200);
  bool _verifiedOnly = false;
  List<String> _availableDays = [];
  
  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Filtros Avançados')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Premium badge
          if (!isPremium)
            Card(
              color: Colors.amber[100],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.workspace_premium, size: 48, color: Colors.amber),
                    Text('Recurso Premium', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Assine para desbloquear filtros avançados'),
                    ElevatedButton(
                      onPressed: () => context.go('/premium'),
                      child: Text('Ver Planos'),
                    ),
                  ],
                ),
              ),
            ),
          
          // Filtros (desabilitados se não for Premium)
          SwitchListTile(
            title: Text('Apenas Verificados'),
            subtitle: Text('Perfis com badge de verificação'),
            value: _verifiedOnly,
            onChanged: isPremium ? (val) => setState(() => _verifiedOnly = val) : null,
          ),
          
          Divider(),
          
          Text('Especialidades:', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: [
              'Corte', 'Barba', 'Degradê', 'Sobrancelha', 
              'Platinado', 'Luzes', 'Pigmentação', 'Desenho'
            ].map((service) => FilterChip(
              label: Text(service),
              selected: _selectedServices.contains(service),
              onSelected: isPremium 
                ? (selected) {
                    setState(() {
                      if (selected) {
                        _selectedServices.add(service);
                      } else {
                        _selectedServices.remove(service);
                      }
                    });
                  }
                : null,
            )).toList(),
          ),
          
          Divider(),
          
          Text('Faixa de Preço (R\$):', style: TextStyle(fontWeight: FontWeight.bold)),
          RangeSlider(
            values: _priceRange,
            min: 10,
            max: 500,
            divisions: 49,
            labels: RangeLabels(
              'R\$ ${_priceRange.start.round()}',
              'R\$ ${_priceRange.end.round()}',
            ),
            onChanged: isPremium 
              ? (values) => setState(() => _priceRange = values)
              : null,
          ),
          
          Divider(),
          
          Text('Dias Disponíveis:', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom']
              .map((day) => FilterChip(
                label: Text(day),
                selected: _availableDays.contains(day),
                onSelected: isPremium 
                  ? (selected) {
                      setState(() {
                        if (selected) {
                          _availableDays.add(day);
                        } else {
                          _availableDays.remove(day);
                        }
                      });
                    }
                  : null,
              )).toList(),
          ),
          
          SizedBox(height: 24),
          
          // Botões
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  child: Text('Limpar'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: isPremium ? _applyFilters : null,
                  child: Text('Aplicar Filtros'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _applyFilters() {
    ref.read(discoveryFiltersProvider.notifier).updateFilters(
      services: _selectedServices,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      verifiedOnly: _verifiedOnly,
      availableDays: _availableDays,
    );
    Navigator.pop(context);
  }
}
```

**Tempo:** 4-6 horas

---

#### **👤 VOCÊ FAZ:**

- ✅ Deploy dos Firestore indexes (instruções na Parte 1-C)
- ✅ Testar queries com múltiplos filtros

---

## 📅 CRONOGRAMA SUGERIDO

### **HOJE (Dia 1):**

```
🤖 EU:
  09:00-12:00 → Implementar Onboarding Tutorial
  14:00-15:00 → Corrigir ProfileDetailScreen
  15:00-17:00 → Implementar Desfazer Swipe

👤 VOCÊ:
  Qualquer horário → Configurar Firebase Storage + Functions (2-3h)
```

### **AMANHÃ (Dia 2):**

```
🤖 EU:
  09:00-12:00 → Implementar VerificationScreen (Flutter)
  14:00-17:00 → Implementar CertificatesScreen

👤 VOCÊ:
  Qualquer horário → Criar Google Maps API Key (30min)
```

### **DIA 3:**

```
🤖 EU:
  09:00-17:00 → Implementar MapScreen (8h, dia cheio)

👤 VOCÊ:
  Qualquer horário → Deploy Firestore Indexes (15min)
```

### **DIA 4:**

```
🤖 EU:
  09:00-12:00 → Implementar AdvancedFiltersScreen
  14:00-17:00 → Testes e ajustes finais

👤 VOCÊ:
  Testes end-to-end das novas features
```

---

## ✅ CHECKLIST DE DELEGAÇÃO

### **Para Firebase/Backend Agent:**

```bash
# TASK 1: Firebase Storage + Verification Functions
[ ] Executar: firebase init storage
[ ] Criar arquivo storage.rules (copiar código acima)
[ ] Criar arquivo functions/src/verification.ts (copiar código acima)
[ ] Adicionar exports em functions/src/index.ts
[ ] Executar: firebase deploy --only storage
[ ] Executar: cd functions && npm install && cd ..
[ ] Executar: firebase deploy --only functions:processVerification,functions:approveVerification,functions:rejectVerification
[ ] Verificar deploy: firebase functions:list
[ ] Testar: Fazer upload teste no Storage
```

### **Para Google Cloud Agent:**

```bash
# TASK 2: Google Maps API Key
[ ] Acessar: https://console.cloud.google.com/
[ ] Criar/selecionar projeto: barbergo-maps
[ ] Habilitar APIs: Maps SDK (Android/iOS/Web), Geocoding, Places
[ ] Criar API Key: APIs & Services → Credentials → Create Credentials
[ ] Restringir API Key (Android SHA-1, iOS Bundle ID)
[ ] Copiar chave e adicionar ao .env: GOOGLE_MAPS_API_KEY=...
[ ] Configurar AndroidManifest.xml (código acima)
[ ] Configurar AppDelegate.swift (código acima)
```

### **Para Firebase Agent:**

```bash
# TASK 3: Firestore Indexes
[ ] Atualizar firestore.indexes.json (copiar código acima)
[ ] Executar: firebase deploy --only firestore:indexes
[ ] Aguardar criação (pode levar 5-10 min)
[ ] Verificar: firebase firestore:indexes
```

---

## 📞 COMANDOS ÚTEIS PARA VOCÊ

```bash
# Verificar status do Firebase
firebase projects:list
firebase functions:list
firebase firestore:indexes

# Ver logs em tempo real
firebase functions:log --follow

# Testar function localmente (antes do deploy)
cd functions
npm run serve

# Deploy específico
firebase deploy --only storage
firebase deploy --only functions:functionName
firebase deploy --only firestore:indexes

# Rollback se algo der errado
firebase functions:delete functionName --force

# Limpar e reinstalar
cd functions
rm -rf node_modules
npm install
```

---

## 🚨 PRIORIDADES SE O TEMPO FOR CURTO

### **MÍNIMO VIÁVEL (Sprint 1 completo):**

1. ✅ Onboarding Tutorial (CRÍTICO)
2. ✅ Corrigir ProfileDetailScreen (RÁPIDO)

### **ALTA PRIORIDADE (Sprint 2):**

3. ✅ Desfazer Swipe
4. ✅ Firebase Storage + Functions

### **MÉDIA PRIORIDADE:**

5. ✅ Sistema de Verificação
6. ✅ Upload de Certificados

### **PODE ESPERAR (Sprint 3):**

7. ⏸️ Mapa Interativo
8. ⏸️ Filtros Avançados

---

## 🎯 RESUMO EXECUTIVO

### **O QUE EU VOU FAZER (Código Flutter):**

```
✅ Onboarding Tutorial (2-3h)
✅ Corrigir ProfileDetailScreen (1h)
✅ Desfazer Swipe (2-3h)
✅ VerificationScreen (3-4h)
✅ CertificatesScreen (4-6h)
✅ MapScreen (8-10h)
✅ AdvancedFiltersScreen (4-6h)

TOTAL: 24-33 horas (3-4 dias de trabalho)
```

### **O QUE VOCÊ DELEGA:**

```
✅ Firebase Storage setup (1h)
✅ Cloud Functions verification (2h)
✅ Google Maps API Key (30min)
✅ Firestore Indexes (15min)

TOTAL: 3-4 horas (pode ser feito em paralelo)
```

---

## 🚀 PRÓXIMA AÇÃO IMEDIATA

### **EU (Agora):**

```dart
// 1. Adicionar shared_preferences ao pubspec.yaml
// 2. Criar lib/src/features/onboarding/screens/tutorial_screen.dart
// 3. Implementar 4 páginas com PageView
// 4. Adicionar verificação no app start
// Tempo: 2-3 horas
```

### **VOCÊ (Quando puder):**

```bash
# Delegar para agente Firebase:
# "Execute o TASK 1 do arquivo PLANO_ACAO_IMEDIATO.md"
# (Firebase Storage + Verification Functions)
```

---

**Status:** 🟢 **PRONTO PARA EXECUTAR!**  
**Próximo Update:** Após completar Tutorial (2-3h)

**Vamos nessa!** 🚀💪
