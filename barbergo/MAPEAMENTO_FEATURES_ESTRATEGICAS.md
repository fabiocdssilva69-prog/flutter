# 🎯 MAPEAMENTO COMPLETO: FEATURES ESTRATÉGICAS vs CÓDIGO ATUAL

**Data:** 02/11/2025  
**Status:** Análise Completa - Pronto para Implementação

---

## 📊 RESUMO EXECUTIVO

### ✅ O QUE JÁ TEMOS (12 features implementadas)
- Sistema de Swipe/Discovery com priorização
- Matches e Chat básico
- Super Likes (free: 1/dia, premium: ilimitado)
- Boost (30 min, R$ 9,90 por 5)
- "Ver Quem Curtiu" (premium feature)
- Premium tiers (R$ 19,90/mês)
- Geolocalização básica (GeoFirePoint)
- Perfil com fotos/portfolio
- Sistema de avaliações
- Notificações push (FCM)
- Analytics (Firebase)
- Vagas/aplicações (BarberGo business logic)

### ❌ O QUE FALTA (18+ features estratégicas)
- ❌ AI Copilot para perfil
- ❌ Conversation coaching
- ❌ Prompts system (Hinge model)
- ❌ Comment on like
- ❌ Video/audio profiles
- ❌ Date planner
- ❌ "Available Now"
- ❌ Date perks partnerships
- ❌ Vouching system
- ❌ Anti-ghosting timers
- ❌ Burnout detection
- ❌ Behavioral reputation
- ❌ Profile A/B testing
- ❌ Algorithmic transparency
- ❌ Performance dashboard
- ❌ Speed dating events
- ❌ Group dates
- ❌ Hybrid matchmaking

---

## 🏗️ ARQUITETURA ATUAL

### Estrutura de Pastas (21 features)
```
lib/src/features/
├── ai/                    # 🔴 EM DESENVOLVIMENTO (erros compilação)
├── ai_assistant/          # 🟡 PARCIAL (Gemini integrado)
├── auth/                  # ✅ COMPLETO
├── barber/                # ✅ COMPLETO (business logic BarberGo)
├── chat/                  # ✅ COMPLETO (messaging básico)
├── core/                  # ✅ COMPLETO (services, utils)
├── debug/                 # ✅ COMPLETO (seed_screen)
├── discovery/             # ✅ COMPLETO (swipe, boost, super like)
├── filters/               # ✅ COMPLETO (filtros discovery)
├── firebase_demo/         # 🟢 DEMO
├── home/                  # ✅ COMPLETO
├── management/            # ✅ COMPLETO (vagas)
├── matches/               # ✅ COMPLETO (celebration, list)
├── notifications/         # ✅ COMPLETO (FCM)
├── onboarding/            # ✅ COMPLETO (tutorial, account type)
├── portfolio/             # ✅ COMPLETO
├── premium/               # ✅ COMPLETO (Stripe integration)
├── profile/               # ✅ COMPLETO
├── profiles/              # ✅ COMPLETO (create profile)
├── ratings/               # ✅ COMPLETO
└── vacancies/             # ✅ COMPLETO
```

### Providers/Controllers Principais
```dart
// Discovery & Swipe (✅ COMPLETO)
- discoverProfilesProvider         // Busca perfis com priorização
- swipeControllerProvider           // Like, Super Like, Dislike
- boostControllerProvider           // Boost 30min, R$ 9,90/5
- likesReceivedControllerProvider   // "Ver Quem Curtiu"

// Profile & Auth (✅ COMPLETO)
- currentUserProfileProvider        // Perfil atual
- profileControllerProvider         // CRUD perfil
- authRepositoryProvider            // Firebase Auth

// Chat & Matches (✅ COMPLETO)
- matchChatRepositoryProvider       // Chats do match
- userChatsProvider                 // Stream de chats
- chatControllerProvider            // Enviar mensagem

// Premium & Monetization (✅ COMPLETO)
- Stripe integration                // Premium R$ 19,90/mês
- Boost purchase                    // R$ 9,90 por 5 boosts

// AI (🔴 COM ERROS)
- aiServiceProvider                 // OpenAI GPT-4o-mini
- geminiServiceProvider             // Gemini Pro (Gemini API)
- chatControllerProvider (AI)       // ⚠️ ERRO: ChatMessage fields missing
```

---

## 📋 ANÁLISE DETALHADA POR PILAR ESTRATÉGICO

---

## **PILAR 1: ACTIONABLE INTELLIGENCE & TRANSPARENCY**

### 1️⃣ AI Copilot para Otimização de Perfil
**Status:** ❌ **NÃO IMPLEMENTADO** (mas temos infraestrutura AI)  
**Prioridade:** 🔥 ALTA - Phase 1 (MVP Differentiation)

**O que temos:**
```dart
// lib/src/features/ai_assistant/services/gemini_service.dart
class GeminiService {
  Future<String> sendMessage({
    required String message,
    String? context,
  }) async { ... }
  
  Future<String> analyzeHairstyle({
    required List<int> imageBytes,
    String? prompt,
  }) async { ... }
}

// lib/src/features/ai/providers/ai_service.dart
class AiService {
  Future<String> generateTextWithContext({
    required List<Map<String, String>> conversation,
    required String newMessage,
  }) async { ... }
}
```

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/ai_copilot/controllers/profile_optimization_controller.dart
@riverpod
class ProfileOptimizationController extends _$ProfileOptimizationController {
  // Analisar perfil e sugerir melhorias
  Future<ProfileAnalysis> analyzeProfile(ProfileEntity profile) async {
    final aiService = ref.read(aiServiceProvider.notifier);
    
    // Analisar bio, fotos, prompts
    final bioScore = await _analyzeBio(profile.bio);
    final photoScore = await _analyzePhotos(profile.portfolioUrls);
    final completeness = _calculateCompleteness(profile);
    
    return ProfileAnalysis(
      overallScore: (bioScore + photoScore + completeness) / 3,
      bioSuggestions: [...],
      photoSuggestions: [...],
      promptSuggestions: [...],
    );
  }
  
  // Gerar bio otimizada com IA
  Future<String> generateOptimizedBio(ProfileEntity profile) async {
    final prompt = '''
Você é um especialista em perfis de dating apps.
Analise este perfil e gere uma bio otimizada:

Nome: ${profile.name}
Idade: ${profile.age ?? 'N/A'}
Bio atual: ${profile.bio ?? 'Vazio'}
Interesses: ${profile.interests ?? []}

Gere uma bio:
- Autêntica e única
- 2-3 frases curtas
- Mostre personalidade
- Inclua call-to-action
''';
    
    return await aiService.generateText(prompt: prompt);
  }
}

// 🎯 NOVO: UI Screen
// lib/src/features/ai_copilot/screens/profile_optimization_screen.dart
class ProfileOptimizationScreen extends ConsumerWidget {
  // Dashboard com:
  // - Score do perfil (0-100)
  // - Sugestões de melhoria
  // - A/B test de fotos
  // - Preview de bio gerada por IA
}
```

**Complexidade:** Média  
**Tempo Estimado:** 3-4 horas  
**Dependências:** AI service já existe, só precisa novo controller + UI

---

### 2️⃣ Conversation Coaching (Real-time)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🔥 ALTA - Phase 2 (Intelligence & O2O)

**O que temos:**
```dart
// Chat básico funcional
// lib/src/features/chat/screens/chat_screen.dart
// lib/src/data/repositories/match_chat_repository.dart
```

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/ai_copilot/controllers/conversation_coach_controller.dart
@riverpod
class ConversationCoachController extends _$ConversationCoachController {
  // Analisar mensagem antes de enviar
  Future<MessageAnalysis> analyzeMessage(String message, List<ChatMessage> history) async {
    final aiService = ref.read(aiServiceProvider.notifier);
    
    final prompt = '''
Você é um coach de conversação para dating apps.
Analise esta mensagem que o usuário quer enviar:

Mensagem: "$message"
Histórico: ${history.map((m) => m.content).join('\n')}

Retorne JSON:
{
  "score": 0-100,
  "tone": "friendly|flirty|boring|aggressive",
  "suggestions": ["sugestão 1", "sugestão 2"],
  "icebreakers": ["alternativa 1", "alternativa 2"]
}
''';
    
    final response = await aiService.generateText(prompt: prompt);
    return MessageAnalysis.fromJson(jsonDecode(response));
  }
  
  // Sugerir próxima mensagem com base no contexto
  Future<List<String>> suggestNextMessage(List<ChatMessage> history) async { ... }
}

// 🎯 NOVO: Integrar no ChatScreen
// lib/src/features/chat/screens/chat_screen.dart
class ChatScreen extends ConsumerWidget {
  // Adicionar:
  // - Botão "AI Suggestions" acima do TextField
  // - Drawer lateral com sugestões em tempo real
  // - Badge de score da mensagem enquanto digita
  // - Ícone de aviso se mensagem tem tom inadequado
}
```

**Complexidade:** Média-Alta  
**Tempo Estimado:** 4-5 horas  
**Dependências:** Chat funcional + AI service

---

### 3️⃣ Profile A/B Testing
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 MÉDIA - Phase 3 (Trust & Advanced)

**O que temos:**
- ProfileEntity com portfolioUrls (lista de fotos)
- Analytics (Firebase)

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/ai_copilot/controllers/ab_test_controller.dart
@riverpod
class ABTestController extends _$ABTestController {
  // Criar teste A/B de 2 fotos de perfil
  Future<ABTest> createPhotoTest(String photo1Url, String photo2Url) async {
    final userId = ref.read(authRepositoryProvider).currentUser!.uid;
    
    // Alternar foto principal a cada X impressões
    final test = ABTest(
      testId: uuid.v4(),
      userId: userId,
      photoA: photo1Url,
      photoB: photo2Url,
      impressionsA: 0,
      impressionsB: 0,
      likesA: 0,
      likesB: 0,
      startedAt: DateTime.now(),
      duration: Duration(days: 7),
    );
    
    await _saveABTest(test);
    return test;
  }
  
  // Trackear impressão (quando perfil é visto)
  Future<void> trackImpression(String testId, bool isPhotoA) async { ... }
  
  // Trackear like recebido
  Future<void> trackLike(String testId, bool isPhotoA) async { ... }
  
  // Calcular winner após 7 dias
  Future<ABTestResult> calculateWinner(String testId) async {
    final test = await _getABTest(testId);
    
    final ctrA = test.likesA / test.impressionsA;
    final ctrB = test.likesB / test.impressionsB;
    
    return ABTestResult(
      winner: ctrA > ctrB ? 'A' : 'B',
      ctrA: ctrA,
      ctrB: ctrB,
      confidence: _calculateConfidence(test),
    );
  }
}
```

**Complexidade:** Média  
**Tempo Estimado:** 3-4 horas  
**Dependências:** Analytics + Firestore

---

### 4️⃣ Algorithmic Transparency ("Why am I seeing this?")
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 MÉDIA - Phase 2

**O que temos:**
```dart
// Discovery com filtros básicos
// lib/src/features/discovery/controllers/discovery_controller.dart
Future<List<ProfileEntity>> _fetchProfiles() async {
  // Filtros: accountType, location, age
  // Priorização: boosted > premium > free
}
```

**O que falta implementar:**
```dart
// 🎯 ATUALIZAR: lib/src/features/discovery/controllers/discovery_controller.dart
class DiscoveryController {
  // Adicionar campo de explicação
  Future<List<ProfileWithReason>> _fetchProfilesWithReasons() async {
    final profiles = await _fetchProfiles();
    
    return profiles.map((p) {
      final reasons = <String>[];
      
      if (p.isBoosted) reasons.add("Este perfil usou Boost (topo dos resultados)");
      if (p.hasActivePremium) reasons.add("Membro Premium");
      if (_isNearby(p)) reasons.add("A ${_distance(p).toStringAsFixed(1)} km de você");
      if (_hasCommonInterests(p)) reasons.add("Interesses em comum: ${_commonInterests(p).join(', ')}");
      if (p.superLikedYou) reasons.add("🔥 Deu Super Like em você!");
      
      return ProfileWithReason(profile: p, reasons: reasons);
    }).toList();
  }
}

// 🎯 NOVO: UI no ProfileCard
// lib/src/features/discovery/presentation/widgets/profile_card.dart
class ProfileCard extends StatelessWidget {
  // Adicionar botão "ℹ️" que abre bottomSheet com:
  // - Lista de razões (bullets)
  // - Gráfico de compatibilidade
  // - Link para ajustar preferências
}
```

**Complexidade:** Baixa  
**Tempo Estimado:** 2-3 horas  
**Dependências:** Discovery controller

---

### 5️⃣ Performance Dashboard
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 MÉDIA - Phase 4

**O que temos:**
- Analytics básico (Firebase)
- ProfileEntity com métricas de premium

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/analytics/controllers/user_metrics_controller.dart
@riverpod
class UserMetricsController extends _$UserMetricsController {
  Future<UserMetrics> getMetrics(String userId) async {
    // Agregar métricas do Firestore
    final swipes = await _getSwipeStats(userId); // last 30 days
    final matches = await _getMatchStats(userId);
    final messages = await _getMessageStats(userId);
    
    return UserMetrics(
      profileViews: swipes.totalViews,
      likesReceived: swipes.likesReceived,
      matchRate: matches.total / swipes.totalSwipes,
      avgResponseTime: messages.avgResponseTime,
      conversationStarters: messages.firstMessages,
      topPerformingPhoto: await _getTopPhoto(userId),
      peakActivityHours: await _getPeakHours(userId),
    );
  }
}

// 🎯 NOVO: lib/src/features/analytics/screens/dashboard_screen.dart
class DashboardScreen extends ConsumerWidget {
  // Dashboard com:
  // - Cards de métricas principais
  // - Gráficos (fl_chart)
  // - Comparação com média da plataforma
  // - Sugestões de melhoria
}
```

**Complexidade:** Média-Alta  
**Tempo Estimado:** 5-6 horas  
**Dependências:** Firestore queries, fl_chart package

---

## **PILAR 2: ONLINE-TO-OFFLINE (O2O) BRIDGE**

### 6️⃣ Date Planner (Calendar Integration)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🔥 ALTA - Phase 2

**O que temos:**
- Chat funcional
- Matches list

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/dates/controllers/date_planner_controller.dart
@riverpod
class DatePlannerController extends _$DatePlannerController {
  // Criar proposta de date
  Future<DateProposal> createDateProposal({
    required String matchId,
    required DateTime proposedDate,
    required String location,
    required String activity,
  }) async {
    final proposal = DateProposal(
      proposalId: uuid.v4(),
      matchId: matchId,
      proposedBy: userId,
      proposedDate: proposedDate,
      location: location,
      activity: activity,
      status: DateStatus.pending,
    );
    
    await _saveDateProposal(proposal);
    
    // Notificar outro usuário
    await ref.read(notificationsProvider).sendDateProposal(matchId, proposal);
    
    return proposal;
  }
  
  // Aceitar/rejeitar proposta
  Future<void> respondToProposal(String proposalId, bool accepted) async { ... }
  
  // Adicionar ao calendário (device_calendar package)
  Future<void> addToCalendar(DateProposal proposal) async {
    final calendar = ref.read(calendarServiceProvider);
    
    await calendar.createEvent(
      title: "Date com ${proposal.matchName}",
      description: proposal.activity,
      location: proposal.location,
      startDate: proposal.proposedDate,
      endDate: proposal.proposedDate.add(Duration(hours: 2)),
    );
  }
}

// 🎯 NOVO: lib/src/features/dates/screens/date_planner_screen.dart
class DatePlannerScreen extends ConsumerWidget {
  // UI com:
  // - Seletor de data/hora (calendar_date_picker2)
  // - Campo de local (Google Places autocomplete)
  // - Dropdown de atividade (café, jantar, cinema, etc)
  // - Lista de propostas pendentes
  // - Botão "Adicionar ao Calendário"
}
```

**Complexidade:** Alta  
**Tempo Estimado:** 6-7 horas  
**Dependências:** device_calendar, google_places_flutter

---

### 7️⃣ "Available Now" (Spontaneous Dates)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🔥 ALTA - Phase 2

**O que temos:**
- Geolocalização (GeoFirePoint)
- Push notifications (FCM)

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/dates/controllers/available_now_controller.dart
@riverpod
class AvailableNowController extends _$AvailableNowController {
  // Ativar "Disponível Agora" por 2 horas
  Future<void> setAvailableNow({
    required String activity, // "café", "drink", etc
    required int radiusKm,
  }) async {
    final userId = ref.read(authRepositoryProvider).currentUser!.uid;
    final profile = await ref.read(profileRepositoryProvider).getProfile(userId);
    
    await FirebaseFirestore.instance.collection('available_now').doc(userId).set({
      'userId': userId,
      'activity': activity,
      'location': profile.location!.geopoint,
      'radiusKm': radiusKm,
      'expiresAt': Timestamp.fromDate(DateTime.now().add(Duration(hours: 2))),
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    // Notificar matches próximos
    await _notifyNearbyMatches(userId, activity, radiusKm);
  }
  
  // Buscar quem está disponível próximo
  Stream<List<AvailableNowProfile>> watchAvailableNearby() {
    final myLocation = ref.read(currentUserProfileProvider).value!.location!;
    
    return FirebaseFirestore.instance
      .collection('available_now')
      .where('expiresAt', isGreaterThan: Timestamp.now())
      .snapshots()
      .asyncMap((snapshot) async {
        // Filtrar por distância (GeoFirePoint)
        final nearby = <AvailableNowProfile>[];
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final location = GeoFirePoint(data['location']);
          final distance = myLocation.distance(location);
          
          if (distance <= data['radiusKm']) {
            nearby.add(AvailableNowProfile.fromFirestore(doc));
          }
        }
        return nearby;
      });
  }
}

// 🎯 NOVO: lib/src/features/dates/screens/available_now_screen.dart
class AvailableNowScreen extends ConsumerWidget {
  // UI com:
  // - Botão "Ficar Disponível" (ativa por 2h)
  // - Mapa com pins de quem está disponível
  // - Lista de matches disponíveis com distância
  // - Chat rápido "Vamos nos encontrar em X?"
}
```

**Complexidade:** Alta  
**Tempo Estimado:** 7-8 horas  
**Dependências:** GeoFlutterFire, Firebase Cloud Functions

---

### 8️⃣ Date Perks Partnerships (Commission Model)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 MÉDIA - Phase 4 (Monetization)

**O que temos:**
- Stripe integration

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/partnerships/controllers/perks_controller.dart
@riverpod
class PerksController extends _$PerksController {
  // Listar perks próximos
  Future<List<DatePerk>> getPerksNearby(double lat, double lng, int radiusKm) async {
    // API backend com parceiros locais
    final response = await http.get('/api/perks?lat=$lat&lng=$lng&radius=$radiusKm');
    return (response.data as List).map((p) => DatePerk.fromJson(p)).toList();
  }
  
  // Resgatar cupom
  Future<PerkCoupon> redeemPerk(String perkId, String matchId) async {
    // Gerar cupom único
    final coupon = await http.post('/api/perks/$perkId/redeem', {
      'matchId': matchId,
      'userId': userId,
    });
    
    return PerkCoupon.fromJson(coupon.data);
  }
}

// Exemplos de perks:
// - 20% de desconto em restaurante X
// - 2x1 em cinema Y
// - Entrada grátis em evento Z
// - Drink cortesia em bar W
```

**Complexidade:** Alta (requer parcerias comerciais)  
**Tempo Estimado:** 10+ horas (+ negociações)  
**Dependências:** Backend API, contratos com parceiros

---

### 9️⃣ Location-based Date Suggestions
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 MÉDIA - Phase 2

**Implementação similar ao #8, mas com sugestões genéricas (Google Places API)**

---

## **PILAR 3: TRUST & ACCOUNTABILITY ECOSYSTEM**

### 🔟 Vouching System (Friend Testimonials)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🔥 ALTA - Phase 3

**O que temos:**
- ProfileEntity
- Social connections (matches)

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/trust/controllers/vouching_controller.dart
@riverpod
class VouchingController extends _$VouchingController {
  // Solicitar vouch de amigo (via link)
  Future<VouchRequest> requestVouch(String friendEmail) async {
    final vouchToken = uuid.v4();
    
    // Enviar email com link único
    await http.post('/api/vouch/request', {
      'userId': userId,
      'friendEmail': friendEmail,
      'token': vouchToken,
    });
    
    return VouchRequest(token: vouchToken, friendEmail: friendEmail);
  }
  
  // Amigo preenche vouch
  Future<void> submitVouch({
    required String token,
    required String relationship, // "amigo", "colega", "ex-colega"
    required int rating, // 1-5
    required List<String> traits, // ["confiável", "divertido", "pontual"]
    required String testimonial,
  }) async {
    await http.post('/api/vouch/submit', {
      'token': token,
      'relationship': relationship,
      'rating': rating,
      'traits': traits,
      'testimonial': testimonial,
    });
  }
  
  // Listar vouches do perfil
  Future<List<Vouch>> getVouches(String userId) async { ... }
}

// 🎯 NOVO: UI no ProfileScreen
// lib/src/features/profile/screens/profile_screen.dart
// Adicionar seção "Recomendações de Amigos" com:
// - Avatar + nome do amigo
// - Rating (estrelas)
// - Traits (badges coloridos)
// - Testimonial (texto)
```

**Complexidade:** Alta  
**Tempo Estimado:** 8-9 horas  
**Dependências:** Backend API, email service

---

### 1️⃣1️⃣ Anti-Ghosting 72h Timers
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🔥 ALTA - Phase 1 (MVP Differentiation)

**O que temos:**
- Chat funcional
- Firebase Cloud Functions

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/chat/controllers/anti_ghosting_controller.dart
@riverpod
class AntiGhostingController extends _$AntiGhostingController {
  // Iniciar timer de 72h após match
  Future<void> startTimer(String matchId) async {
    await FirebaseFirestore.instance.collection('match_timers').doc(matchId).set({
      'matchId': matchId,
      'startedAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(DateTime.now().add(Duration(hours: 72))),
      'firstMessageSent': false,
    });
  }
  
  // Atualizar quando primeira mensagem é enviada
  Future<void> markFirstMessageSent(String matchId) async {
    await FirebaseFirestore.instance.collection('match_timers').doc(matchId).update({
      'firstMessageSent': true,
    });
  }
  
  // Stream de tempo restante
  Stream<Duration> watchTimeRemaining(String matchId) {
    return FirebaseFirestore.instance
      .collection('match_timers')
      .doc(matchId)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        final expiresAt = (data!['expiresAt'] as Timestamp).toDate();
        final now = DateTime.now();
        return expiresAt.difference(now);
      });
  }
}

// ☁️ Cloud Function: Deletar match após 72h sem mensagem
exports.deleteGhostedMatches = functions.pubsub
  .schedule('every 1 hours')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    
    const expiredMatches = await db.collection('match_timers')
      .where('expiresAt', '<=', now)
      .where('firstMessageSent', '==', false)
      .get();
    
    for (const doc of expiredMatches.docs) {
      await db.collection('matches').doc(doc.data().matchId).delete();
      await doc.ref.delete();
    }
  });

// 🎯 ATUALIZAR: lib/src/features/matches/screens/matches_screen.dart
// Adicionar badge "⏱️ 48h restantes" em cada match
```

**Complexidade:** Média  
**Tempo Estimado:** 4-5 horas  
**Dependências:** Firebase Cloud Functions

---

### 1️⃣2️⃣ Burnout Detection (Engagement Patterns)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 MÉDIA - Phase 3

**O que temos:**
- Analytics básico

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/wellbeing/controllers/burnout_detector_controller.dart
@riverpod
class BurnoutDetectorController extends _$BurnoutDetectorController {
  Future<BurnoutAnalysis> detectBurnout(String userId) async {
    // Analisar últimos 30 dias
    final swipeActivity = await _getSwipeActivity(userId);
    final matchActivity = await _getMatchActivity(userId);
    final messageActivity = await _getMessageActivity(userId);
    
    // Detectar padrões:
    // 1. Swipes excessivos (>100/dia)
    // 2. Match rate caindo (<5%)
    // 3. Tempo de resposta aumentando
    // 4. Sessões muito longas (>2h/dia)
    
    final isBurntOut = swipeActivity.daily > 100 ||
                       matchActivity.rate < 0.05 ||
                       messageActivity.avgResponseTime > Duration(hours: 24);
    
    return BurnoutAnalysis(
      isBurntOut: isBurntOut,
      severity: _calculateSeverity(swipeActivity, matchActivity, messageActivity),
      suggestions: [
        "Faça uma pausa de 3 dias",
        "Revise seu perfil com o AI Copilot",
        "Seja mais seletivo nos likes",
      ],
    );
  }
  
  // Sugerir pausa automática
  Future<void> suggestBreak(String userId) async {
    // Notificação: "Detectamos que você pode estar cansado. Que tal uma pausa?"
    await ref.read(notificationsProvider).sendBurnoutAlert(userId);
  }
}
```

**Complexidade:** Média  
**Tempo Estimado:** 5-6 horas  
**Dependências:** Analytics, ML (opcional)

---

### 1️⃣3️⃣ Behavioral Reputation System
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 MÉDIA - Phase 3

**O que temos:**
- Sistema de avaliações (ratings)

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/features/trust/controllers/reputation_controller.dart
@riverpod
class ReputationController extends _$ReputationController {
  // Calcular score de reputação (0-100)
  Future<ReputationScore> calculateReputation(String userId) async {
    final profile = await ref.read(profileRepositoryProvider).getProfile(userId);
    
    // Fatores:
    // 1. Tempo de resposta médio (weight: 20%)
    // 2. Taxa de ghosting (weight: 30%)
    // 3. Avaliações de matches (weight: 25%)
    // 4. Vouches de amigos (weight: 15%)
    // 5. Completude do perfil (weight: 10%)
    
    final responseTime = await _getAvgResponseTime(userId);
    final ghostingRate = await _getGhostingRate(userId);
    final ratings = await _getAverageRating(userId);
    final vouches = await _getVouchCount(userId);
    final completeness = _profileCompleteness(profile);
    
    final score = (
      (1 - responseTime.inHours / 24) * 20 +
      (1 - ghostingRate) * 30 +
      (ratings / 5) * 25 +
      (min(vouches, 5) / 5) * 15 +
      completeness * 10
    ).round();
    
    return ReputationScore(
      overall: score,
      badge: _getBadge(score), // "Confiável", "Comunicativo", "Top Rated"
      breakdown: { ... },
    );
  }
}

// 🎯 ATUALIZAR: ProfileCard
// Mostrar badge de reputação: "⭐ Top Rated (95)" ou "✅ Confiável (82)"
```

**Complexidade:** Alta  
**Tempo Estimado:** 7-8 horas  
**Dependências:** Ratings, Analytics

---

## **CORE DIFFERENTIATION FEATURES**

### 1️⃣4️⃣ Prompts System (Hinge Model)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🔥🔥 CRÍTICA - Phase 1 (MVP Differentiation)

**O que temos:**
- ProfileEntity com bio

**O que falta implementar:**
```dart
// 🎯 NOVO: lib/src/domain/entities/prompt_response.dart
@MappableClass()
class PromptResponse with PromptResponseMappable {
  final String promptId;
  final String prompt; // "Meu talento secreto é..."
  final String response; // "Fazer café perfeito em 2 minutos"
  final DateTime createdAt;
}

// 🎯 ATUALIZAR: ProfileEntity
class ProfileEntity {
  // Adicionar:
  final List<PromptResponse> prompts; // 3 prompts obrigatórios
}

// 🎯 NOVO: lib/src/features/profile/controllers/prompts_controller.dart
@riverpod
class PromptsController extends _$PromptsController {
  // Lista de prompts disponíveis
  List<String> getAvailablePrompts() {
    return [
      "Meu talento secreto é...",
      "A maneira mais rápida de conquistar meu coração é...",
      "Eu sei que foi amor à primeira vista quando...",
      "Minha controvérsia favorita é...",
      "Juntos poderíamos...",
      "Eu quero alguém que...",
      "Meu movimento de dança característico é...",
      "Qual é a sua história mais constrangedora?",
      // + 50 prompts
    ];
  }
  
  // Validar que usuário escolheu 3 prompts
  bool validatePrompts(List<PromptResponse> prompts) {
    return prompts.length == 3 && prompts.every((p) => p.response.length >= 20);
  }
}

// 🎯 NOVO: UI no EditProfileScreen
// lib/src/features/profile/screens/edit_profile_screen.dart
// Adicionar seção "Mostre sua Personalidade":
// - 3 dropdowns com prompts
// - TextField para cada resposta (min 20 chars)
// - Preview de como aparece no card

// 🎯 ATUALIZAR: ProfileCard
// lib/src/features/discovery/presentation/widgets/profile_card.dart
// Mostrar prompts no swipe:
// ```
// ┌─────────────────────────┐
// │   [Foto Principal]       │
// │                          │
// │   João, 28               │
// │   📍 2 km de você        │
// ├─────────────────────────┤
// │ 💡 "Meu talento secreto  │
// │    é fazer café perfeito"│
// │                          │
// │ ❤️  "A maneira mais rápida│
// │    de conquistar meu     │
// │    coração é com comida" │
// │                          │
// │ 🎵 "Juntos poderíamos    │
// │    ir em todo show       │
// │    de rock da cidade"    │
// └─────────────────────────┘
// ```
```

**Complexidade:** Média  
**Tempo Estimado:** 4-5 horas  
**Dependências:** ProfileEntity migration

---

### 1️⃣5️⃣ Comment on Like (Deliberate Interaction)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🔥🔥 CRÍTICA - Phase 1 (MVP Differentiation)

**O que temos:**
- Swipe controller

**O que falta implementar:**
```dart
// 🎯 ATUALIZAR: SwipeEntity
@MappableClass()
class SwipeEntity with SwipeEntityMappable {
  // Adicionar:
  final String? comment; // Comentário opcional ao dar like
  final String? promptResponseId; // ID do prompt que comentou
}

// 🎯 ATUALIZAR: SwipeController
class SwipeController {
  // Novo método: like com comentário
  Future<bool> likeWithComment({
    required String toUserId,
    required String comment,
    String? promptResponseId,
  }) async {
    // Validar comentário (min 10 chars)
    if (comment.length < 10) {
      throw Exception('Comentário deve ter no mínimo 10 caracteres');
    }
    
    // Criar swipe com comentário
    await swipeRepository.createSwipe(
      toUserId: toUserId,
      liked: true,
      comment: comment,
      promptResponseId: promptResponseId,
    );
    
    // Se houver match, comentário aparece no chat automaticamente
    if (await _checkMatch(toUserId)) {
      await _sendCommentAsFirstMessage(toUserId, comment);
    } else {
      // Comentário aparece na tela "Ver Quem Curtiu"
      await _notifyLikeWithComment(toUserId, comment);
    }
  }
}

// 🎯 ATUALIZAR: SwipeScreen
// lib/src/features/discovery/presentation/swipe_screen.dart
// Adicionar botão "💬 Curtir com Comentário":
// - Ao clicar, abre bottomSheet
// - TextField para comentário
// - Preview do prompt que está comentando
// - Botão "Enviar Like"

// Exemplo UI:
// ```
// ┌─────────────────────────────┐
// │ 💬 Adicione um comentário    │
// ├─────────────────────────────┤
// │ Você está comentando:        │
// │ "Meu talento secreto é       │
// │  fazer café perfeito"        │
// │                              │
// │ ┌─────────────────────────┐ │
// │ │ Eu também amo café!      │ │
// │ │ Qual sua marca favorita? │ │
// │ └─────────────────────────┘ │
// │                              │
// │ [Cancelar]  [Enviar Like ❤️]│
// └─────────────────────────────┘
// ```
```

**Complexidade:** Média  
**Tempo Estimado:** 3-4 horas  
**Dependências:** Prompts system, Swipe controller

---

### 1️⃣6️⃣ Video/Audio Profiles
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 MÉDIA - Phase 1

**O que temos:**
- Firebase Storage
- ProfileEntity com portfolioUrls

**O que falta implementar:**
```dart
// 🎯 ATUALIZAR: ProfileEntity
class ProfileEntity {
  // Adicionar:
  final String? videoUrl; // URL do vídeo no Storage (max 30s)
  final String? audioUrl; // URL do áudio no Storage (max 60s)
}

// 🎯 NOVO: lib/src/features/profile/controllers/media_upload_controller.dart
@riverpod
class MediaUploadController extends _$MediaUploadController {
  // Upload de vídeo (max 30s, 50MB)
  Future<String> uploadVideo(File videoFile) async {
    // Validar duração e tamanho
    final metadata = await _getVideoMetadata(videoFile);
    if (metadata.duration > Duration(seconds: 30)) {
      throw Exception('Vídeo deve ter no máximo 30 segundos');
    }
    if (metadata.size > 50 * 1024 * 1024) {
      throw Exception('Vídeo deve ter no máximo 50MB');
    }
    
    // Compressão (video_compress package)
    final compressed = await _compressVideo(videoFile);
    
    // Upload to Firebase Storage
    final userId = ref.read(authRepositoryProvider).currentUser!.uid;
    final ref = FirebaseStorage.instance.ref('profiles/$userId/video.mp4');
    await ref.putFile(compressed);
    
    return await ref.getDownloadURL();
  }
  
  // Upload de áudio (voice note - max 60s)
  Future<String> uploadAudio(File audioFile) async { ... }
}

// 🎯 ATUALIZAR: ProfileCard
// lib/src/features/discovery/presentation/widgets/profile_card.dart
// Adicionar:
// - Botão play para vídeo (overlay sobre foto)
// - Player de áudio abaixo das fotos
// - Badge "🎥 Tem Vídeo" ou "🎤 Tem Áudio"

// 🎯 NOVO: lib/src/features/profile/screens/record_video_screen.dart
// Tela para gravar vídeo de 15-30s:
// - Timer visível
// - Efeitos/filtros (opcional)
// - Preview antes de salvar
// - Prompt: "Mostre sua personalidade em 30 segundos!"
```

**Complexidade:** Alta  
**Tempo Estimado:** 8-10 horas  
**Dependências:** camera, video_player, video_compress, audio_players

---

### 1️⃣7️⃣ Enhanced Discovery Algorithm
**Status:** ⚠️ **PARCIALMENTE IMPLEMENTADO**  
**Prioridade:** 🔥 ALTA - Phase 1

**O que temos:**
```dart
// Algoritmo básico com priorização
// lib/src/features/discovery/controllers/discovery_controller.dart
Future<List<ProfileEntity>> _fetchProfiles() async {
  // 1. Filtrar por accountType
  // 2. Filtrar por location (raio)
  // 3. Priorizar: boosted > premium > free
  // 4. Ordenar por distância
}
```

**O que falta implementar:**
```dart
// 🎯 ATUALIZAR: lib/src/features/discovery/controllers/discovery_controller.dart
class DiscoveryController {
  Future<List<ProfileEntity>> _fetchProfilesEnhanced() async {
    final userId = ref.read(authRepositoryProvider).currentUser!.uid;
    final myProfile = await ref.read(profileRepositoryProvider).getProfile(userId);
    final mySwipeHistory = await _getMySwipeHistory(userId);
    
    // 1. Filtrar candidatos base
    var candidates = await _getBaseCandidates(myProfile);
    
    // 2. Remover já swipados (últimas 24h)
    candidates = candidates.where((p) => 
      !mySwipeHistory.contains(p.userId)
    ).toList();
    
    // 3. Calcular score de compatibilidade para cada perfil
    final scored = candidates.map((p) {
      final score = _calculateCompatibilityScore(myProfile, p, mySwipeHistory);
      return ScoredProfile(profile: p, score: score);
    }).toList();
    
    // 4. Ordenar por score (com priorização de boost/premium)
    scored.sort((a, b) {
      // Boosted sempre no topo
      if (a.profile.isBoosted && !b.profile.isBoosted) return -1;
      if (!a.profile.isBoosted && b.profile.isBoosted) return 1;
      
      // Depois por score
      return b.score.compareTo(a.score);
    });
    
    return scored.map((s) => s.profile).toList();
  }
  
  // Calcular compatibilidade (0-100)
  double _calculateCompatibilityScore(
    ProfileEntity me,
    ProfileEntity them,
    List<String> mySwipeHistory,
  ) {
    double score = 0.0;
    
    // Fator 1: Distância (weight: 25%)
    final distance = me.location!.distance(them.location!);
    score += (1 - min(distance / 50, 1)) * 25; // 50km = 0 points
    
    // Fator 2: Interesses em comum (weight: 20%)
    final commonInterests = (me.interests ?? [])
      .toSet()
      .intersection((them.interests ?? []).toSet())
      .length;
    score += (commonInterests / 5) * 20; // Max 5 interesses
    
    // Fator 3: Atividade similar (weight: 15%)
    // Se eu dei like em perfis tipo X, mostre mais perfis tipo X
    final similarityToMyLikes = _calculateLikeSimilarity(them, mySwipeHistory);
    score += similarityToMyLikes * 15;
    
    // Fator 4: Completude do perfil (weight: 15%)
    score += _profileCompleteness(them) * 15;
    
    // Fator 5: Premium member (weight: 10%)
    if (them.hasActivePremium) score += 10;
    
    // Fator 6: Recência do perfil (weight: 10%)
    final daysSinceCreated = DateTime.now().difference(them.createdAt).inDays;
    score += max(0, 10 - daysSinceCreated / 3); // Perfis recentes = mais pontos
    
    // Fator 7: Taxa de resposta (weight: 5%)
    // TODO: Calcular baseado em histórico de chats
    
    return score.clamp(0, 100);
  }
}
```

**Complexidade:** Alta  
**Tempo Estimado:** 6-7 horas  
**Dependências:** Analytics, ML (opcional)

---

## **ADVANCED & MONETIZATION FEATURES**

### 1️⃣8️⃣ Spotify/Instagram Integration
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 BAIXA - Phase 3

**Implementação:**
```dart
// OAuth2 com Spotify API
// Mostrar top artistas/músicas no perfil
// Calcular compatibilidade musical
```

---

### 1️⃣9️⃣ Group Dates (Double Dates)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 BAIXA - Phase 3

---

### 2️⃣0️⃣ Speed Dating Virtual Events
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 BAIXA - Phase 3

---

### 2️⃣1️⃣ Hybrid Matchmaking (Human Coaches)
**Status:** ❌ **NÃO IMPLEMENTADO**  
**Prioridade:** 🟡 BAIXA - Phase 4 (Premium tier: R$ 99/mês)

---

## 📊 RESUMO DE PRIORIZAÇÃO

### **PHASE 1: MVP DIFFERENTIATION** (Semanas 1-2)
🔥🔥 **CRÍTICO** - Diferenciar de Tinder/Bumble AGORA

1. ✅ **Prompts System** (4-5h) - Core diferenciador
2. ✅ **Comment on Like** (3-4h) - Interação deliberada
3. ✅ **Anti-Ghosting 72h** (4-5h) - Trust desde o início
4. ✅ **Enhanced Discovery** (6-7h) - Matchmaking inteligente
5. ⚠️ **Video/Audio Profiles** (8-10h) - Autenticidade

**Total Phase 1:** 25-31 horas (~4-5 dias)

---

### **PHASE 2: INTELLIGENCE & O2O** (Semanas 3-4)
🔥 **ALTA** - Consolidar pilares estratégicos

6. ✅ **AI Copilot Perfil** (3-4h)
7. ✅ **Conversation Coaching** (4-5h)
8. ✅ **Date Planner** (6-7h)
9. ✅ **Available Now** (7-8h)
10. ✅ **Algorithmic Transparency** (2-3h)

**Total Phase 2:** 22-27 horas (~4 dias)

---

### **PHASE 3: TRUST & ADVANCED** (Semanas 5-6)
🟡 **MÉDIA** - Consolidar ecosystem

11. ✅ **Vouching System** (8-9h)
12. ✅ **Burnout Detection** (5-6h)
13. ✅ **Behavioral Reputation** (7-8h)
14. ✅ **Profile A/B Testing** (3-4h)
15. ⚠️ **Spotify/Instagram** (6-8h)

**Total Phase 3:** 29-35 horas (~5-6 dias)

---

### **PHASE 4: MONETIZATION & POLISH** (Semanas 7-8)
💰 **RECEITA** - Maximizar conversão premium

16. ✅ **Performance Dashboard** (5-6h)
17. ✅ **Date Perks Partnerships** (10+ horas + parcerias)
18. ✅ **Hybrid Matchmaking** (15+ horas)
19. ✅ **Group Dates** (8-10h)
20. ✅ **Speed Dating Events** (10-12h)
21. ✅ **QA & Polish** (20+ horas)

**Total Phase 4:** 68+ horas (~10-12 dias)

---

## 🎯 PRÓXIMOS PASSOS IMEDIATOS

### 1. Decidir Escopo da Sprint 1 (1h)
- Revisar Phase 1 features
- Definir quais implementar primeiro
- Criar tasks granulares

### 2. Implementar Prompts System (4-5h) 🔥🔥
- Criar PromptResponse entity
- Atualizar ProfileEntity schema
- Criar PromptsController
- UI no EditProfileScreen
- UI no ProfileCard
- Migrar 10 perfis existentes

### 3. Implementar Comment on Like (3-4h) 🔥🔥
- Atualizar SwipeEntity schema
- Atualizar SwipeController
- UI bottomSheet no SwipeScreen
- Notificação de like com comentário

### 4. Implementar Anti-Ghosting (4-5h) 🔥
- Criar match_timers collection
- Cloud Function para deletar matches
- UI timer badge nos matches
- Notificações de aviso

### 5. Enhanced Discovery Algorithm (6-7h) 🔥
- Implementar score de compatibilidade
- Calcular interesses em comum
- Ordenação multi-fator
- A/B test do algoritmo

---

## 📈 MÉTRICAS DE SUCESSO

### KPIs Phase 1 (MVP Differentiation)
- ✅ **Match Rate:** +30% vs baseline (prompts + comment)
- ✅ **First Message Rate:** +50% (anti-ghosting)
- ✅ **Profile Completeness:** 95% com 3 prompts
- ✅ **Comment on Like Usage:** >40% dos likes

### KPIs Phase 2 (Intelligence & O2O)
- ✅ **Date Conversion:** 15% dos matches viram dates reais
- ✅ **Available Now Usage:** 20% usuários ativos/semana
- ✅ **AI Suggestions Acceptance:** >60%

### KPIs Phase 3 (Trust & Advanced)
- ✅ **Vouch Completion:** 30% usuários com ≥1 vouch
- ✅ **Ghosting Rate:** -40% vs baseline
- ✅ **Behavioral Score:** Avg >75

### KPIs Phase 4 (Monetization)
- ✅ **Premium Conversion:** 8-10% usuários
- ✅ **Date Perks Usage:** R$ 50k/mês em comissões
- ✅ **MRR:** R$ 100k/mês

---

## ✅ CONCLUSÃO

**Temos uma base sólida (12 features)** ✅  
**Faltam 18+ features estratégicas** ❌  
**Prioridade:** Começar com Phase 1 (MVP Differentiation)  
**Estimativa Total:** 144+ horas (~3-4 semanas full-time)  

**Decisão do Usuário:** Qual phase começar? Ajustar escopo?

---

**Última Atualização:** 02/11/2025 05:32 AM  
**Próxima Revisão:** Após feedback do usuário
