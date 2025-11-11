# 🚀 BarberGO - Roadmap Firebase Completo

## 📊 Estado Atual do Projeto

### ✅ Implementado e Funcionando

- **Firebase Auth**: Login/registro com email/senha
- **Firestore**: Collection `/profiles` com dados de usuários
- **Firebase Storage**: Upload de avatares com compressão (71% redução)
- **FCM**: Push notifications com Mutex (atomic operation)
- **Analytics**: Eventos customizados rastreados
- **Crashlytics**: Monitoramento de erros ativo

### ⚠️ Implementado com Problemas

- **Storage Delete**: Erro `object-not-found` ao tentar deletar arquivos inexistentes
  - **Causa**: Media controller tenta deletar avatar antigo que nunca existiu
  - **Solução**: Verificação `exists()` antes de deletar (JÁ IMPLEMENTADA)
  
- **watchProfile**: Múltiplas chamadas (6x) causando queries desnecessárias
  - **Causa**: Múltiplos widgets ouvindo o mesmo provider
  - **Solução**: `keepAlive: true` JÁ CONFIGURADO, logs de debug REMOVIDOS

### 🚧 Pendente de Implementação

- Social Auth (Google, Apple, Facebook)
- Sistema de Swipe/Cards
- Matches bidirecionais
- Chat em tempo real
- Cloud Functions
- Gerador de dados de teste
- Regras de segurança granulares

---

## 🎯 FASE 1: Autenticação Completa

### Status: ✅ 100% CONCLUÍDO

#### ✅ Já Implementado

```dart
// Email/Senha funcionando
AuthController.signIn(email, password)
AuthController.signUp(email, password)

// ✅ Social Auth implementado
AuthController.signInWithGoogle()
AuthController.signInWithApple()
AuthController.resetPassword(email)
AuthController.sendEmailVerification()
```

#### 🎉 Concluído em 29/10/2025

**1.1 Social Authentication**

**Google Sign-In** (Flutter):

```yaml
# pubspec.yaml
dependencies:
  google_sign_in: ^6.2.1
```

```dart
// lib/src/features/auth/controllers/auth_controller.dart
Future<bool> signInWithGoogle() async {
  state = const AsyncLoading();
  
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return false;
    
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    
    // Criar perfil se não existir
    final profileExists = await ref.read(profileRepositoryProvider)
        .getProfile(userCredential.user!.uid);
    
    if (profileExists == null) {
      // Redirecionar para onboarding
    }
    
    state = const AsyncData(null);
    return true;
  } catch (e, stack) {
    state = AsyncError(e, stack);
    return false;
  }
}
```

**Apple Sign-In** (Flutter):

```yaml
dependencies:
  sign_in_with_apple: ^6.1.0
```

**1.2 Recuperação de Senha**

```dart
Future<bool> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return true;
  } catch (e) {
    return false;
  }
}
```

**1.3 Verificação de Email**

```dart
Future<void> sendEmailVerification() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && !user.emailVerified) {
    await user.sendEmailVerification();
  }
}
```

---

## 🎯 FASE 2: Storage & Mídia Completo

### Status: 60% Concluído

#### ✅ Já Implementado

- Upload de avatar com compressão
- Estrutura de pastas `/images/{folder}/{userId}/{filename}`

#### 🚧 Problema Atual

```
[LOG ERROR] FirebaseStorage upload failed: object-not-found
```

**Diagnóstico**: Provavelmente **regras do Firebase Storage** estão bloqueando.

**Solução 1: Verificar Regras do Storage**

Acesse Firebase Console → Storage → Rules:

```text
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /images/{folder}/{userId}/{filename} {
      // Permitir leitura para todos autenticados
      allow read: if request.auth != null;
      
      // Permitir escrita apenas no próprio diretório
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Solução 2: Organizar Pastas por Tipo**

```dart
// lib/src/core/services/image_upload_service.dart

enum StorageFolder {
  avatars,
  portfolio,
  barbershops,
  services;
  
  String get path => switch (this) {
    StorageFolder.avatars => 'avatars',
    StorageFolder.portfolio => 'portfolio',
    StorageFolder.barbershops => 'barbershops',
    StorageFolder.services => 'services',
  };
}

Future<String?> uploadImage(
  XFile imageFile,
  String userId, {
  required StorageFolder folder,
}) async {
  final fileName = "${_uuid.v4()}.jpg";
  final ref = _storage.ref().child('${folder.path}/$userId/$fileName');
  
  // ... resto do código
}
```

#### 🔨 Próximas Ações

**2.1 Upload Múltiplo de Portfolio**

```dart
Future<List<String>> uploadMultipleImages(
  List<XFile> images,
  String userId,
) async {
  final urls = <String>[];
  
  for (final image in images) {
    final url = await uploadImage(
      image,
      userId,
      folder: StorageFolder.portfolio,
    );
    if (url != null) urls.add(url);
  }
  
  return urls;
}
```

**2.2 Limites de Tamanho**

```dart
static const int maxAvatarSizeKB = 2048; // 2MB
static const int maxPortfolioSizeKB = 5120; // 5MB

Future<bool> validateFileSize(XFile file, int maxSizeKB) async {
  final bytes = await file.length();
  final sizeKB = bytes / 1024;
  return sizeKB <= maxSizeKB;
}
```

---

## 🎯 FASE 3: Firestore - Estrutura Completa

### Status: ✅ 70% CONCLUÍDO

#### ✅ Já Implementado

- Collection `/profiles` com todos os campos
- ✅ **Collection `/swipes`** - SwipeEntity + SwipeRepository
- ✅ **Collection `/matches`** - MatchEntity + MatchRepository  
- ✅ **Collection `/chats`** - ChatEntity + MatchChatRepository
- ✅ **Subcollection `/chats/{chatId}/messages`** - MessageEntity com CRUD completo
- ✅ **Firestore Security Rules** - Regras granulares para todas as collections

#### 🔨 Collections a Criar

**3.1 Collection: /swipes**

```javascript
{
  fromUserId: "6RYGS6HoEkhQgikNxUIkn7NpwmI3",
  toUserId: "abc123def456",
  liked: true,  // true = like, false = dislike
  createdAt: Timestamp,
}
```

**Índices necessários**:

- `fromUserId` (Ascending) + `toUserId` (Ascending)
- `toUserId` (Ascending) + `fromUserId` (Ascending)

**3.2 Collection: /matches**

```javascript
{
  userIds: ["userId1", "userId2"],  // Array para facilitar queries
  user1: "userId1",
  user2: "userId2",
  createdAt: Timestamp,
  lastMessageAt: Timestamp,
  unreadCount: {
    userId1: 0,
    userId2: 1
  }
}
```

**3.3 Collection: /chats**

```javascript
{
  matchId: "matchId123",
  participants: ["userId1", "userId2"],
  lastMessage: "Oi, tudo bem?",
  lastMessageAt: Timestamp,
  createdAt: Timestamp
}
```

**Subcollection: /chats/{chatId}/messages**

```javascript
{
  senderId: "userId1",
  text: "Olá!",
  imageUrl: null,  // Opcional
  createdAt: Timestamp,
  read: false
}
```

**3.4 Collection: /bookings** (Agendamentos)

```javascript
{
  barberId: "barberId",
  customerId: "customerId",
  serviceId: "serviceId",
  status: "pending",  // pending, confirmed, cancelled, completed
  scheduledAt: Timestamp,
  duration: 60,  // minutos
  price: 50.00,
  notes: "Corte degradê",
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

**3.5 Regras de Segurança Completas**

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper Functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    function isParticipant(userIds) {
      return request.auth.uid in userIds;
    }
    
    // Profiles
    match /profiles/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && isOwner(userId);
      allow update: if isSignedIn() && isOwner(userId);
      allow delete: if false;  // Nunca permitir delete direto
    }
    
    // Swipes
    match /swipes/{swipeId} {
      allow read: if isSignedIn() && (
        resource.data.fromUserId == request.auth.uid ||
        resource.data.toUserId == request.auth.uid
      );
      allow create: if isSignedIn() && request.resource.data.fromUserId == request.auth.uid;
      allow update, delete: if false;
    }
    
    // Matches
    match /matches/{matchId} {
      allow read: if isSignedIn() && isParticipant(resource.data.userIds);
      allow create: if false;  // Apenas Cloud Function cria matches
      allow update: if isSignedIn() && isParticipant(resource.data.userIds);
      allow delete: if false;
    }
    
    // Chats
    match /chats/{chatId} {
      allow read: if isSignedIn() && isParticipant(resource.data.participants);
      allow create: if isSignedIn() && isParticipant(request.resource.data.participants);
      allow update: if isSignedIn() && isParticipant(resource.data.participants);
      
      // Messages subcollection
      match /messages/{messageId} {
        allow read: if isSignedIn() && isParticipant(get(/databases/$(database)/documents/chats/$(chatId)).data.participants);
        allow create: if isSignedIn() && request.resource.data.senderId == request.auth.uid;
        allow update: if isSignedIn();  // Para marcar como lida
        allow delete: if false;
      }
    }
    
    // Bookings
    match /bookings/{bookingId} {
      allow read: if isSignedIn() && (
        resource.data.barberId == request.auth.uid ||
        resource.data.customerId == request.auth.uid
      );
      allow create: if isSignedIn() && request.resource.data.customerId == request.auth.uid;
      allow update: if isSignedIn() && (
        resource.data.barberId == request.auth.uid ||
        resource.data.customerId == request.auth.uid
      );
      allow delete: if false;
    }
  }
}
```

---

## 🎯 FASE 4: Cloud Functions

### Status: 0% Concluído

#### 🔨 Funções a Implementar

**4.1 Auto-update updatedAt**

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.updateProfileTimestamp = functions.firestore
  .document('profiles/{profileId}')
  .onUpdate((change, context) => {
    return change.after.ref.set({
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });
  });
```

**4.2 Detectar Matches Bidirecionais**

```javascript
exports.detectMatch = functions.firestore
  .document('swipes/{swipeId}')
  .onCreate(async (snap, context) => {
    const swipe = snap.data();
    
    // Verifica se o outro usuário já deu like de volta
    const reverseSwipe = await admin.firestore()
      .collection('swipes')
      .where('fromUserId', '==', swipe.toUserId)
      .where('toUserId', '==', swipe.fromUserId)
      .where('liked', '==', true)
      .get();
    
    if (!reverseSwipe.empty && swipe.liked) {
      // É um match! Criar documento em /matches
      await admin.firestore().collection('matches').add({
        userIds: [swipe.fromUserId, swipe.toUserId],
        user1: swipe.fromUserId,
        user2: swipe.toUserId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        lastMessageAt: null,
        unreadCount: {
          [swipe.fromUserId]: 0,
          [swipe.toUserId]: 0
        }
      });
      
      // Enviar push notification para ambos
      await sendMatchNotification(swipe.fromUserId, swipe.toUserId);
    }
  });
```

**4.3 Enviar Push Notification em Match**

```javascript
async function sendMatchNotification(userId1, userId2) {
  const profile1 = await admin.firestore().collection('profiles').doc(userId1).get();
  const profile2 = await admin.firestore().collection('profiles').doc(userId2).get();
  
  const token1 = profile1.data().fcmToken;
  const token2 = profile2.data().fcmToken;
  
  if (token1) {
    await admin.messaging().send({
      token: token1,
      notification: {
        title: 'Novo Match! 🎉',
        body: `Você deu match com ${profile2.data().name}!`
      },
      data: {
        type: 'match',
        matchId: userId2
      }
    });
  }
  
  if (token2) {
    await admin.messaging().send({
      token: token2,
      notification: {
        title: 'Novo Match! 🎉',
        body: `Você deu match com ${profile1.data().name}!`
      },
      data: {
        type: 'match',
        matchId: userId1
      }
    });
  }
}
```

**4.4 Notificação de Nova Mensagem**

```javascript
exports.sendMessageNotification = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    const message = snap.data();
    const chatId = context.params.chatId;
    
    const chat = await admin.firestore().collection('chats').doc(chatId).get();
    const recipientId = chat.data().participants.find(id => id !== message.senderId);
    
    const recipientProfile = await admin.firestore()
      .collection('profiles')
      .doc(recipientId)
      .get();
    
    const senderProfile = await admin.firestore()
      .collection('profiles')
      .doc(message.senderId)
      .get();
    
    if (recipientProfile.data().fcmToken) {
      await admin.messaging().send({
        token: recipientProfile.data().fcmToken,
        notification: {
          title: senderProfile.data().name,
          body: message.text
        },
        data: {
          type: 'message',
          chatId: chatId
        }
      });
    }
  });
```

---

## 🎯 FASE 5: Sistema de Swipe & Matches

### Status: ✅ 60% CONCLUÍDO (Backend Completo)

#### ✅ Já Implementado

- ✅ **SwipeController** - Lógica de swipe com detecção automática de match
- ✅ **DiscoverProfilesProvider** - Stream de profiles disponíveis para swipe
- ✅ **SwipeRepository** - CRUD de swipes com hasReverseSwipe()
- ✅ **MatchRepository** - Criação automática de matches bidirecionais
- ✅ Dependência `flutter_card_swiper: ^7.0.2` já está no pubspec.yaml

#### 🔨 Implementação Flutter (PRÓXIMO PASSO)

**5.1 Adicionar Dependência**

```yaml
# pubspec.yaml
dependencies:
  flutter_card_swiper: ^7.0.1  # Ou flutter_tindercard
```

**5.2 Controller de Swipes**

```dart
// lib/src/features/discovery/controllers/swipe_controller.dart
@riverpod
class SwipeController extends _$SwipeController {
  @override
  FutureOr<void> build() {}
  
  Future<bool> swipe(String toUserId, bool liked) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;
    
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance.collection('swipes').add({
        'fromUserId': userId,
        'toUserId': toUserId,
        'liked': liked,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
    
    return !state.hasError;
  }
}

// Provider para listar profiles disponíveis para swipe
@riverpod
Stream<List<ProfileEntity>> discoverProfiles(Ref ref) {
  final currentUser = ref.watch(authRepositoryProvider).currentUser;
  if (currentUser == null) return const Stream.empty();
  
  final currentProfile = ref.watch(currentUserProfileProvider).value;
  if (currentProfile == null) return const Stream.empty();
  
  // Buscar profiles do tipo oposto em um raio de X km
  final accountTypeFilter = currentProfile.accountType == AccountType.barber
      ? AccountType.customer
      : AccountType.barber;
  
  return FirebaseFirestore.instance
      .collection('profiles')
      .where('accountType', isEqualTo: accountTypeFilter.name)
      .limit(20)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => ProfileEntity.fromMap(doc.data()))
            .where((profile) => profile.userId != currentUser.uid)
            .toList();
      });
}
```

**5.3 Tela de Swipe**

```dart
// lib/src/features/discovery/presentation/swipe_screen.dart
class SwipeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(discoverProfilesProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Descobrir')),
      body: profilesAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erro: $e')),
        data: (profiles) {
          if (profiles.isEmpty) {
            return Center(child: Text('Nenhum perfil disponível'));
          }
          
          return CardSwiper(
            cardsCount: profiles.length,
            cardBuilder: (context, index) => ProfileCard(profiles[index]),
            onSwipe: (previousIndex, currentIndex, direction) {
              final profile = profiles[previousIndex];
              final liked = direction == CardSwiperDirection.right;
              
              ref.read(swipeControllerProvider.notifier).swipe(
                profile.userId,
                liked,
              );
              
              return true;
            },
          );
        },
      ),
    );
  }
}
```

---

## 🎯 FASE 6: Chat em Tempo Real

### Status: 0% Concluído

#### 🔨 Implementação

**6.1 Controller de Chat**

```dart
// lib/src/features/chat/controllers/chat_controller.dart
@riverpod
Stream<List<MessageEntity>> chatMessages(Ref ref, String chatId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => MessageEntity.fromMap(doc.data()))
            .toList();
      });
}

@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<void> build() {}
  
  Future<bool> sendMessage(String chatId, String text) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return false;
    
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': userId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
      
      // Atualizar última mensagem no chat
      await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageAt': FieldValue.serverTimestamp(),
      });
    });
    
    return !state.hasError;
  }
}
```

---

## 🎯 FASE 7: Gerador de Dados de Teste

### Status: 0% Concluído

#### 🔨 Script Node.js

```javascript
// scripts/seed_profiles.js
const admin = require('firebase-admin');
const { faker } = require('@faker-js/faker');

admin.initializeApp();
const db = admin.firestore();

const locations = [
  'Centro, Florianópolis',
  'Trindade, Florianópolis',
  'Campeche, Florianópolis',
  'Ingleses, Florianópolis',
  'Lagoa da Conceição, Florianópolis',
  'Canasvieiras, Florianópolis'
];

async function generateProfiles(count = 50) {
  const batch = db.batch();
  
  for (let i = 0; i < count; i++) {
    const accountType = i % 2 === 0 ? 'barber' : 'customer';
    const ref = db.collection('profiles').doc();
    
    batch.set(ref, {
      userId: ref.id,
      email: faker.internet.email(),
      name: faker.person.fullName(),
      accountType: accountType,
      bio: faker.lorem.sentence(),
      location: faker.helpers.arrayElement(locations),
      contactPhone: faker.phone.number('(##) #####-####'),
      portfolioUrls: [],
      searchRadiusKm: 25,
      avatarUrl: `https://i.pravatar.cc/300?img=${i}`,
      preciseLocation: {
        geopoint: new admin.firestore.GeoPoint(
          -27.5954 + (Math.random() - 0.5) * 0.1,
          -48.5480 + (Math.random() - 0.5) * 0.1
        ),
        geohash: faker.string.alphanumeric(9)
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
  }
  
  await batch.commit();
  console.log(`✅ ${count} perfis criados com sucesso!`);
}

generateProfiles(100).then(() => process.exit(0));
```

**Executar**:

```bash
npm install firebase-admin @faker-js/faker
node scripts/seed_profiles.js
```

---

## 📋 Checklist de Implementação

### Curto Prazo (Sprint Atual)

- [ ] Corrigir erro Storage `object-not-found`
- [ ] Implementar Social Auth (Google)
- [ ] Criar collections `/swipes` e `/matches`
- [ ] Implementar tela básica de swipe

### Médio Prazo (2-3 Sprints)

- [ ] Cloud Function para detectar matches
- [ ] Sistema de chat em tempo real
- [ ] Gerador de dados de teste
- [ ] Push notifications completas

### Longo Prazo (4+ Sprints)

- [ ] Sistema de agendamentos
- [ ] Integração com pagamentos
- [ ] Remote Config
- [ ] Internacionalização
- [ ] Backup automático

---

## 🔧 Comandos Úteis

### Firestore

```bash
# Export backup
firebase firestore:export gs://barbergo-38c21.appspot.com/backups

# Import backup
firebase firestore:import gs://barbergo-38c21.appspot.com/backups/2025-10-29
```

### Cloud Functions

```bash
# Deploy todas as functions
firebase deploy --only functions

# Deploy função específica
firebase deploy --only functions:detectMatch

# Logs em tempo real
firebase functions:log --follow
```

### Storage

```bash
# Deploy regras
firebase deploy --only storage
```

---

## 📚 Documentação de Referência

- [Firebase Auth](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Cloud Functions](https://firebase.google.com/docs/functions)
- [Cloud Messaging (FCM)](https://firebase.google.com/docs/cloud-messaging)
- [Firebase Storage](https://firebase.google.com/docs/storage)
- [Security Rules](https://firebase.google.com/docs/rules)

---

**Última Atualização**: 29/10/2025  
**Versão do App**: Sprint 30
