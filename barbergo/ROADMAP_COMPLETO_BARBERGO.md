# 🚀 ROADMAP COMPLETO - BARBERGO APP

## 📊 STATUS ATUAL

✅ **Phase 1-2 COMPLETAS** (15 correções)

- Sistema de Swipe funcionando
- Cache otimizado (5 min TTL)
- Preload de imagens
- Analytics tracking
- Cálculo de distância
- Retry logic + offline mode

---

## 🎯 FASES DE DESENVOLVIMENTO (10 Phases Restantes)

### **PHASE 3: Sistema de Chat Completo** 🔄 Próxima

**Arquivos a criar:**

```
lib/src/features/chat/
├── screens/
│   ├── chat_list_screen.dart        # Lista de conversas
│   ├── chat_screen.dart              # Tela de conversa individual
│   └── chat_settings_screen.dart     # Configurações do chat
├── widgets/
│   ├── message_bubble.dart           # Balão de mensagem
│   ├── chat_input.dart               # Input de texto + anexos
│   ├── typing_indicator.dart         # "Fulano está digitando..."
│   ├── message_image.dart            # Preview de imagem
│   └── message_audio.dart            # Player de áudio
├── controllers/
│   ├── chat_controller.dart          # Lógica do chat
│   └── message_controller.dart       # Envio/recebimento
└── repositories/
    └── chat_repository.dart          # Firestore queries
```

**Features:**

- [x] Text messages
- [ ] Image messages (Firebase Storage)
- [ ] Audio messages (gravação + upload)
- [ ] Read receipts (✓✓ azul)
- [ ] Typing indicator
- [ ] Message deletion
- [ ] Link preview
- [ ] Emoji picker

**Firebase Collections:**

```javascript
// chats/{chatId}
{
  participants: ['userId1', 'userId2'],
  lastMessage: 'Olá!',
  lastMessageTime: Timestamp,
  unreadCount: { userId1: 0, userId2: 3 },
  createdAt: Timestamp
}

// chats/{chatId}/messages/{messageId}
{
  senderId: 'userId',
  text: 'Olá!',
  type: 'text', // text, image, audio
  mediaUrl: null, // URL do Storage
  createdAt: Timestamp,
  readBy: ['userId1']
}
```

**Instruções para você (Firebase):**

1. As Firestore Rules para `chats` **já estão configuradas** ✅
2. Configure Storage Rules para uploads:
   - Vá: <https://console.firebase.google.com/project/barbergo-38c21/storage/rules>
   - Cole:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /chat_media/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 10 * 1024 * 1024; // 10MB max
    }
    
    match /portfolio/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 20 * 1024 * 1024; // 20MB max
    }
  }
}
```

**Estimativa:** 4-6 horas de desenvolvimento

---

### **PHASE 4: Upload de Portfólio** 📸

**Arquivos a criar:**

```
lib/src/features/portfolio/
├── screens/
│   ├── portfolio_screen.dart         # Grid de fotos
│   └── portfolio_upload_screen.dart  # Upload múltiplo
├── widgets/
│   ├── portfolio_grid.dart           # Grid responsivo
│   ├── image_preview.dart            # Preview antes upload
│   └── upload_progress.dart          # Progress indicator
└── controllers/
    └── portfolio_controller.dart     # Upload + delete
```

**Features:**

- [ ] Image picker (múltiplas fotos)
- [ ] Compressão de imagem (flutter_image_compress)
- [ ] Upload paralelo para Storage
- [ ] Grid gallery com zoom
- [ ] Delete imagens
- [ ] Reordenar fotos (drag & drop)
- [ ] Video support (opcional)

**Packages necessários:**

```yaml
dependencies:
  image_picker: ^1.0.7
  flutter_image_compress: ^2.1.0
  photo_view: ^0.14.0
  reorderables: ^0.6.0
```

**Firestore:**

```javascript
// profiles/{userId}
{
  portfolioUrls: [
    'gs://barbergo-38c21.../photo1.jpg',
    'gs://barbergo-38c21.../photo2.jpg'
  ],
  portfolioCount: 10
}
```

**Instruções para você:**

1. Storage Rules **já configuradas acima** ✅
2. Instalar packages: `flutter pub add image_picker flutter_image_compress photo_view`

**Estimativa:** 3-4 horas

---

### **PHASE 5: Profile Details & Edit** ✏️

**Arquivos a criar:**

```
lib/src/features/profile/
├── screens/
│   ├── profile_detail_screen.dart    # Ver perfil completo
│   ├── edit_profile_screen.dart      # Editar perfil
│   └── working_hours_screen.dart     # Horários de atendimento
└── widgets/
    ├── profile_header.dart           # Avatar + nome
    ├── bio_editor.dart               # Textarea com contador
    ├── location_picker.dart          # Mapa para localização
    └── service_list.dart             # Lista de serviços
```

**Features:**

- [ ] Edit bio (max 500 chars)
- [ ] Change avatar
- [ ] Edit location (Google Maps autocomplete)
- [ ] Working hours picker
- [ ] Service list (corte, barba, etc)
- [ ] Price range
- [ ] Social media links

**Packages:**

```yaml
dependencies:
  google_maps_flutter: ^2.5.3
  google_places_autocomplete_text_field: ^0.1.2
```

**Instruções para você:**

1. Ativar Google Maps API:
   - Vá: <https://console.cloud.google.com/apis/library>
   - Habilite: "Maps SDK for Android" + "Places API"
2. Adicionar API key no `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_API_KEY_AQUI"/>
```

**Estimativa:** 4-5 horas

---

### **PHASE 6: Match Management** 💕

**Arquivos a criar:**

```
lib/src/features/matches/
├── screens/
│   ├── matches_screen.dart           # Lista de matches
│   └── match_detail_screen.dart      # Perfil do match
├── widgets/
│   ├── match_card.dart               # Card com foto
│   ├── match_animation.dart          # "It's a Match!"
│   └── match_actions.dart            # Unmatch/block/report
└── controllers/
    └── match_controller.dart         # CRUD matches
```

**Features:**

- [ ] Lista de matches com foto + última mensagem
- [ ] Animação "It's a Match!" (Lottie)
- [ ] Unmatch com confirmação
- [ ] Block user
- [ ] Report user (abuse)
- [ ] Sort por última interação

**Packages:**

```yaml
dependencies:
  lottie: ^3.0.0
```

**Firestore Rules:** Já configuradas ✅

**Instruções:**

1. Baixar animação Lottie:
   - Site: <https://lottiefiles.com/>
   - Buscar: "match animation"
   - Salvar em: `assets/animations/match.json`
2. Adicionar no `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/animations/
```

**Estimativa:** 3-4 horas

---

### **PHASE 7: AI Assistant Integration** 🤖

**Arquivos a criar:**

```
lib/src/features/ai_assistant/
├── screens/
│   ├── ai_chat_screen.dart           # Chat com IA
│   └── style_suggestions_screen.dart # Sugestões de corte
├── widgets/
│   ├── ai_message_bubble.dart        # Balão IA diferenciado
│   ├── style_card.dart               # Card de sugestão
│   └── ai_typing_indicator.dart      # "IA pensando..."
├── controllers/
│   └── ai_controller.dart            # API calls
└── services/
    ├── gemini_service.dart           # Google Gemini API
    └── perplexity_service.dart       # Perplexity API
```

**Features:**

- [ ] Chat com IA (Gemini)
- [ ] Sugestões de corte baseadas em foto
- [ ] Recomendações de barbearia
- [ ] Tips de manutenção
- [ ] Histórico de conversas

**APIs necessárias:**

```dart
// lib/src/core/config/api_keys.dart
class ApiKeys {
  static const geminiApiKey = 'SUA_KEY_AQUI';
  static const perplexityApiKey = 'SUA_KEY_AQUI';
}
```

**Packages:**

```yaml
dependencies:
  google_generative_ai: ^0.2.2
  http: ^1.2.0
```

**Instruções para você:**

1. **Google Gemini API Key:**
   - Vá: <https://makersuite.google.com/app/apikey>
   - Crie API key
   - Cole em `lib/src/core/config/api_keys.dart`

2. **Perplexity API Key:**
   - Vá: <https://www.perplexity.ai/settings/api>
   - Gere key
   - Cole em `api_keys.dart`

**Estimativa:** 5-6 horas

---

### **PHASE 8: Notifications System** 🔔

**Arquivos a criar:**

```
lib/src/features/notifications/
├── screens/
│   └── notifications_screen.dart     # Lista de notificações
├── widgets/
│   ├── notification_card.dart        # Card de notificação
│   └── notification_badge.dart       # Badge com contador
├── controllers/
│   └── notification_controller.dart  # Mark as read
└── services/
    └── fcm_handler.dart              # Push notifications
```

**Features:**

- [ ] Lista de notificações com ícones
- [ ] Badge de não lidas
- [ ] Mark as read
- [ ] Push notifications (FCM)
- [ ] Deep links para chat/match
- [ ] Notification settings

**Firestore Rules:** Já configuradas ✅ (`profiles/{userId}/notifications`)

**Instruções:**

1. FCM **já está configurado** ✅
2. Testar notificações:
   - Vá: <https://console.firebase.google.com/project/barbergo-38c21/notification>
   - Envie notificação de teste

**Estimativa:** 2-3 horas

---

### **PHASE 9: Advanced Filters** 🔍

**Arquivos a criar:**

```
lib/src/features/discovery/
├── screens/
│   └── filters_screen.dart           # Tela de filtros
└── widgets/
    ├── distance_slider.dart          # Slider de distância
    ├── price_range_slider.dart       # Range de preço
    ├── rating_filter.dart            # Filtro por rating
    └── availability_filter.dart      # Disponível agora
```

**Features:**

- [ ] Distance slider (1-100km)
- [ ] Price range (R$20-R$200)
- [ ] Minimum rating (3-5 stars)
- [ ] Availability filter
- [ ] Service type filter
- [ ] Save filter preferences

**Firestore Query:**

```dart
// Exemplo de query com filtros
final query = FirebaseFirestore.instance
    .collection('profiles')
    .where('accountType', isEqualTo: 'barber')
    .where('preciseLocation', isNotNull: true)
    .where('rating', isGreaterThanOrEqualTo: minRating)
    .orderBy('rating', descending: true)
    .limit(20);
```

**Estimativa:** 2-3 horas

---

### **PHASE 10: Booking System** 📅

**Arquivos a criar:**

```
lib/src/features/booking/
├── screens/
│   ├── booking_screen.dart           # Agendar horário
│   ├── calendar_screen.dart          # Calendário
│   └── booking_list_screen.dart      # Meus agendamentos
├── widgets/
│   ├── time_slot_picker.dart         # Grid de horários
│   ├── booking_card.dart             # Card de agendamento
│   └── booking_confirmation.dart     # Confirmação
└── controllers/
    └── booking_controller.dart       # CRUD bookings
```

**Features:**

- [ ] Calendar view (table_calendar)
- [ ] Time slot picker
- [ ] Service selection
- [ ] Booking confirmation
- [ ] Reminders (24h before)
- [ ] Cancel booking
- [ ] Reschedule

**Packages:**

```yaml
dependencies:
  table_calendar: ^3.0.9
```

**Firestore Collections:**

```javascript
// bookings/{bookingId}
{
  barberId: 'userId',
  clientId: 'userId',
  serviceType: 'Corte + Barba',
  date: Timestamp,
  duration: 60, // minutes
  price: 80,
  status: 'confirmed', // pending, confirmed, cancelled
  createdAt: Timestamp
}
```

**Instruções:**

1. Criar collection `bookings` no Firestore
2. Adicionar rules:

```javascript
match /bookings/{bookingId} {
  allow read: if isAuthenticated() 
              && (resource.data.barberId == request.auth.uid 
                  || resource.data.clientId == request.auth.uid);
  allow create: if isAuthenticated();
  allow update, delete: if isAuthenticated() 
                        && (resource.data.barberId == request.auth.uid 
                            || resource.data.clientId == request.auth.uid);
}
```

**Estimativa:** 5-6 horas

---

### **PHASE 11: Reviews & Ratings** ⭐

**Arquivos a criar:**

```
lib/src/features/reviews/
├── screens/
│   ├── reviews_screen.dart           # Lista de reviews
│   └── write_review_screen.dart      # Escrever review
├── widgets/
│   ├── review_card.dart              # Card de review
│   ├── star_rating.dart              # Rating interativo
│   └── photo_review.dart             # Review com foto
└── controllers/
    └── review_controller.dart        # CRUD reviews
```

**Features:**

- [ ] Star rating (1-5)
- [ ] Review text (max 500 chars)
- [ ] Photo reviews
- [ ] Barbershop responses
- [ ] Helpful votes
- [ ] Sort by date/rating

**Firestore:**

```javascript
// reviews/{reviewId}
{
  barberId: 'userId',
  clientId: 'userId',
  rating: 5,
  text: 'Excelente!',
  photos: ['url1', 'url2'],
  response: 'Obrigado!', // Resposta da barbearia
  helpfulCount: 10,
  createdAt: Timestamp
}
```

**Instruções:**

1. Criar collection `reviews`
2. Adicionar rules:

```javascript
match /reviews/{reviewId} {
  allow read: if isAuthenticated();
  allow create: if isAuthenticated() 
                && request.resource.data.clientId == request.auth.uid;
  allow update: if isAuthenticated() 
                && (resource.data.clientId == request.auth.uid 
                    || resource.data.barberId == request.auth.uid);
  allow delete: if isAuthenticated() 
                && resource.data.clientId == request.auth.uid;
}
```

**Estimativa:** 3-4 horas

---

### **PHASE 12: Premium Features** 💎

**Arquivos a criar:**

```
lib/src/features/premium/
├── screens/
│   ├── subscription_screen.dart      # Planos premium
│   ├── super_likes_screen.dart       # Super likes
│   └── boost_screen.dart             # Boost de perfil
├── widgets/
│   ├── plan_card.dart                # Card de plano
│   └── premium_badge.dart            # Badge premium
└── services/
    └── revenue_cat_service.dart      # Subscriptions
```

**Features:**

- [ ] Subscription plans (Mensal, Anual)
- [ ] Super likes (5/day)
- [ ] Profile boost (aparecer mais)
- [ ] See who liked you
- [ ] Unlimited swipes
- [ ] Ad-free experience

**Packages:**

```yaml
dependencies:
  purchases_flutter: ^6.0.0 # RevenueCat
```

**Instruções:**

1. **Criar conta RevenueCat:**
   - Vá: <https://app.revenuecat.com/signup>
   - Crie projeto "BarberGo"
   - Configure produtos:
     - `barbergo_monthly` - R$19,90/mês
     - `barbergo_annual` - R$179,90/ano

2. **Configurar no app:**

```dart
// lib/main.dart
await Purchases.configure(
  PurchasesConfiguration('YOUR_REVENUECAT_KEY')
);
```

**Estimativa:** 4-5 horas

---

## 📦 PACKAGES NECESSÁRIOS (RESUMO)

Adicione no `pubspec.yaml`:

```yaml
dependencies:
  # Chat & Media
  image_picker: ^1.0.7
  flutter_image_compress: ^2.1.0
  photo_view: ^0.14.0
  path_provider: ^2.1.2
  
  # Maps & Location
  google_maps_flutter: ^2.5.3
  google_places_autocomplete_text_field: ^0.1.2
  
  # Animations
  lottie: ^3.0.0
  
  # AI
  google_generative_ai: ^0.2.2
  http: ^1.2.0
  
  # Calendar
  table_calendar: ^3.0.9
  
  # Subscriptions
  purchases_flutter: ^6.0.0
  
  # Utils
  reorderables: ^0.6.0
```

Instale tudo de uma vez:

```bash
flutter pub add image_picker flutter_image_compress photo_view path_provider google_maps_flutter lottie google_generative_ai http table_calendar purchases_flutter reorderables
```

---

## 🔥 FIREBASE SETUP COMPLETO

### 1. Firestore Rules (ATUALIZAR)

Vá: <https://console.firebase.google.com/project/barbergo-38c21/firestore/rules>

**ADICIONE** estas novas collections (após as rules existentes):

```javascript
// Bookings
match /bookings/{bookingId} {
  allow read: if isAuthenticated() 
              && (resource.data.barberId == request.auth.uid 
                  || resource.data.clientId == request.auth.uid);
  allow create: if isAuthenticated();
  allow update, delete: if isAuthenticated() 
                        && (resource.data.barberId == request.auth.uid 
                            || resource.data.clientId == request.auth.uid);
}

// Reviews
match /reviews/{reviewId} {
  allow read: if isAuthenticated();
  allow create: if isAuthenticated() 
                && request.resource.data.clientId == request.auth.uid;
  allow update: if isAuthenticated() 
                && (resource.data.clientId == request.auth.uid 
                    || resource.data.barberId == request.auth.uid);
  allow delete: if isAuthenticated() 
                && resource.data.clientId == request.auth.uid;
}
```

### 2. Storage Rules

Vá: <https://console.firebase.google.com/project/barbergo-38c21/storage/rules>

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Chat media (images/audio)
    match /chat_media/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 10 * 1024 * 1024; // 10MB
    }
    
    // Portfolio images
    match /portfolio/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 20 * 1024 * 1024; // 20MB
    }
    
    // Review photos
    match /review_photos/{reviewId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
                   && request.resource.size < 5 * 1024 * 1024; // 5MB
    }
  }
}
```

### 3. Cloud Functions (Opcional - Match Notification)

Crie arquivo `functions/index.js`:

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Detectar match e criar document
exports.detectMatch = functions.firestore
  .document('swipes/{swipeId}')
  .onCreate(async (snap, context) => {
    const swipe = snap.data();
    
    if (!swipe.liked) return null; // Só processar likes
    
    // Verificar se há swipe recíproco
    const reciprocalSwipe = await admin.firestore()
      .collection('swipes')
      .where('fromUserId', '==', swipe.toUserId)
      .where('toUserId', '==', swipe.fromUserId)
      .where('liked', '==', true)
      .get();
    
    if (reciprocalSwipe.empty) return null;
    
    // Criar match
    const matchRef = admin.firestore().collection('matches').doc();
    await matchRef.set({
      userIds: [swipe.fromUserId, swipe.toUserId],
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
    
    // Enviar push notification
    const fcmToken = await admin.firestore()
      .collection('fcmTokens')
      .where('userId', '==', swipe.toUserId)
      .get();
    
    if (!fcmToken.empty) {
      await admin.messaging().send({
        token: fcmToken.docs[0].data().token,
        notification: {
          title: "It's a Match! 💕",
          body: "Você tem um novo match!"
        }
      });
    }
    
    return null;
  });
```

Instruções:

```bash
cd functions
npm install firebase-functions firebase-admin
firebase deploy --only functions
```

---

## 🎨 UI/UX IMPROVEMENTS

### Temas & Cores

Crie `lib/src/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';

class AppTheme {
  // Cores principais (inspirado no Tinder)
  static const Color primaryRed = Color(0xFFE94057);
  static const Color secondaryPink = Color(0xFFF27121);
  static const Color darkGray = Color(0xFF1F1F1F);
  static const Color lightGray = Color(0xFFF3F3F3);
  
  static ThemeData get light => ThemeData(
    primaryColor: primaryRed,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: primaryRed,
      secondary: secondaryPink,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: darkGray,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
  
  static ThemeData get dark => ThemeData(
    primaryColor: primaryRed,
    scaffoldBackgroundColor: darkGray,
    colorScheme: ColorScheme.dark(
      primary: primaryRed,
      secondary: secondaryPink,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      color: Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
```

---

## 📝 ORDEM DE EXECUÇÃO RECOMENDADA

### **SPRINT 1** (Esta Semana - 12-15h)

1. ✅ Phase 3: Chat System (6h)
2. ✅ Phase 4: Portfolio Upload (4h)
3. ✅ Phase 6: Match Management (3h)

### **SPRINT 2** (Próxima Semana - 12-15h)

4. ✅ Phase 5: Profile Details (5h)
5. ✅ Phase 8: Notifications (3h)
6. ✅ Phase 9: Filters (3h)

### **SPRINT 3** (Semana 3 - 15-18h)

7. ✅ Phase 10: Booking System (6h)
8. ✅ Phase 7: AI Assistant (6h)
9. ✅ Phase 11: Reviews (4h)

### **SPRINT 4** (Semana 4 - 8-10h)

10. ✅ Phase 12: Premium Features (5h)
11. ✅ Polish & Bug Fixes (3h)
12. ✅ Testing & QA (2h)

---

## 🚀 COMEÇAR AGORA

**Próximos passos imediatos:**

1. **Instalar packages:**

```bash
flutter pub add image_picker flutter_image_compress photo_view path_provider google_maps_flutter lottie google_generative_ai http table_calendar purchases_flutter reorderables
```

2. **Atualizar Firestore Rules** (copiar do documento FIRESTORE_RULES_CORRIGIDAS_FINAL.md + adicionar bookings/reviews)

3. **Configurar Storage Rules** (copiar do roadmap acima)

4. **Criar API Keys file:**

```dart
// lib/src/core/config/api_keys.dart
class ApiKeys {
  static const geminiApiKey = 'SUA_KEY_AQUI';
  static const perplexityApiKey = 'SUA_KEY_AQUI';
  static const googleMapsApiKey = 'SUA_KEY_AQUI';
  static const revenueCatApiKey = 'SUA_KEY_AQUI';
}
```

5. **Começar Phase 3 (Chat System)**

---

**Me avise quando:**

1. ✅ Instalar os packages
2. ✅ Atualizar Firestore Rules
3. ✅ Configurar Storage Rules
4. ✅ Obter API keys necessárias

**Então começaremos a implementar Phase 3 (Chat System)!** 🚀
