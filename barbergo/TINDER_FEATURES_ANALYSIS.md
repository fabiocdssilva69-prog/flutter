# 🔥 Análise de Features: Tinder, Badoo, Happn → BarberGO

**Data:** 1 de Novembro de 2025  
**Objetivo:** Mapear funcionalidades dos apps de match líderes e adaptá-las para o contexto de recrutamento profissional do BarberGO

---

## 📊 APPS ANALISADOS

| App | Foco | Público | Downloads |
|-----|------|---------|-----------|
| 🔥 **Tinder** | Match rápido, visual | 18-35 anos | 530M+ |
| 💜 **Badoo** | Social, encontros | 25-40 anos | 500M+ |
| 💙 **Happn** | Geolocalização, "cruzou com você" | 20-35 anos | 100M+ |

---

## 🎯 FUNCIONALIDADES CORE (Já Implementadas no BarberGO)

### ✅ 1. SWIPE SYSTEM
**Apps:** Tinder, Badoo, Happn  
**Status BarberGO:** ✅ **IMPLEMENTADO**

```dart
// lib/src/features/discovery/controllers/swipe_controller.dart
Future<bool> swipe(String toUserId, bool liked) async {
  await swipeRepository.createSwipe(fromUserId, toUserId, liked);
  
  if (liked) {
    final hasReverseSwipe = await hasReverseSwipe(userId, toUserId);
    if (hasReverseSwipe) {
      await createMatch(user1: userId, user2: toUserId);
      // 🎉 É um Match!
    }
  }
}
```

**Adaptação BarberGO:**
- ✅ Barbeiro swipe em vagas (VacancyEntity)
- ✅ Barbearia swipe em barbeiros (ProfileEntity)
- ✅ Match = interesse mútuo (barbearia curtiu barbeiro E barbeiro curtiu vaga)

---

### ✅ 2. MATCH DETECTION
**Apps:** Tinder, Badoo, Happn  
**Status BarberGO:** ✅ **IMPLEMENTADO**

```dart
// lib/src/data/repositories/match_repository.dart
Future<String> createMatch({required String user1, required String user2}) async {
  final match = MatchEntity(
    matchId: '',
    user1Id: user1,
    user2Id: user2,
    createdAt: DateTime.now(),
    isActive: true,
  );
  
  final docRef = await db.collection('matches').add(match.toFirestore());
  return docRef.id;
}
```

**Diferencial BarberGO:**
- Match não é romântico, é **profissional**
- Match = "Barbearia quer contratar" + "Barbeiro quer trabalhar"
- Próximo passo: Chat para negociar salário, horários, benefícios

---

### ✅ 3. CHAT SYSTEM
**Apps:** Tinder, Badoo, Happn  
**Status BarberGO:** ✅ **IMPLEMENTADO**

```dart
// lib/src/features/chat/presentation/chat_screen.dart
// Chat em tempo real após match
// Barbeiro e Barbearia negociam contratação
```

**Diferencial BarberGO:**
- Chat focado em negociação profissional
- Mensagens sobre: salário, horários, benefícios, portfólio
- ❌ Não é chat romântico/casual

---

### ✅ 4. PROFILE CARDS
**Apps:** Tinder (visual), Badoo (detalhado), Happn (minimalista)  
**Status BarberGO:** ✅ **IMPLEMENTADO**

```dart
// lib/src/features/discovery/presentation/swipe_screen.dart
// Cards mostram:
// - Foto de perfil
// - Nome
// - Bio
// - Especialidades (barbeiros)
// - Detalhes da vaga (barbearias)
```

---

## 🚀 FUNCIONALIDADES PREMIUM (Para Implementar)

### 🔥 5. SUPER LIKE
**Apps:** Tinder (1 super like grátis/dia, ilimitado no Gold)  
**Status BarberGO:** ❌ **NÃO IMPLEMENTADO** → **ALTA PRIORIDADE**

**Como Funciona:**
- Usuário pode dar 1 super like especial por dia
- Notifica a outra pessoa imediatamente
- Mostra que você tem **interesse MUITO alto**

**Implementação BarberGO:**

```dart
// lib/src/domain/entities/swipe_entity.dart
class SwipeEntity {
  final String swipeId;
  final String fromUserId;
  final String toUserId;
  final bool liked;
  final bool isSuperLike; // 🆕 NOVO CAMPO
  final DateTime createdAt;
}

// lib/src/features/discovery/controllers/swipe_controller.dart
Future<bool> superLike(String toUserId) async {
  final userId = ref.read(authRepositoryProvider).currentUser?.uid;
  
  // Verificar quantos super likes usou hoje
  final superLikesToday = await swipeRepository.countSuperLikesToday(userId);
  
  if (superLikesToday >= 1 && !userIsPremium) {
    throw Exception('Você já usou seu Super Like de hoje! Assine Premium para ilimitados.');
  }
  
  // Criar swipe especial
  await swipeRepository.createSwipe(
    fromUserId: userId,
    toUserId: toUserId,
    liked: true,
    isSuperLike: true, // 🌟
  );
  
  // 🔔 Enviar notificação IMEDIATA para toUser
  await notificationService.sendSuperLikeNotification(toUserId, userId);
  
  return true;
}
```

**UI Proposta:**
```
┌────────────────────────────────┐
│   [Card do Barbeiro/Vaga]      │
│                                │
│   👎 Rejeitar                  │
│   ⭐ SUPER LIKE (1/dia)        │ ← NOVO
│   ❤️ Like                       │
└────────────────────────────────┘
```

**Benefícios:**
- 💰 Monetização: Super Likes ilimitados no plano Premium
- 🎯 Engajamento: Usuários retornam diariamente para usar o super like grátis
- 🔥 Destaque: Barbearia pode destacar barbeiro que REALMENTE quer contratar

**Esforço:** 6-8 horas  
**ROI:** Alto (feature premium key)

---

### 👀 6. "VER QUEM DEU LIKE EM VOCÊ"
**Apps:** Tinder Gold, Badoo Premium, Happn Premium  
**Status BarberGO:** ❌ **NÃO IMPLEMENTADO** → **ALTA PRIORIDADE**

**Como Funciona:**
- Versão Free: Você só descobre match após dar like mútuo
- Versão Premium: Você VÊ quem deu like ANTES de decidir

**Implementação BarberGO:**

```dart
// lib/src/features/likes/controllers/likes_received_controller.dart
@riverpod
class LikesReceivedController extends _$LikesReceivedController {
  @override
  Future<List<ProfileEntity>> build() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return [];
    
    // Buscar todos que deram like em mim
    final swipes = await ref.read(swipeRepositoryProvider).getSwipesForUser(userId);
    
    // Buscar perfis dos usuários que deram like
    final profiles = <ProfileEntity>[];
    for (final swipe in swipes) {
      if (swipe.liked) {
        final profile = await profileRepository.getProfile(swipe.fromUserId);
        if (profile != null) profiles.add(profile);
      }
    }
    
    return profiles;
  }
}

// lib/src/features/likes/screens/likes_received_screen.dart
class LikesReceivedScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesAsync = ref.watch(likesReceivedControllerProvider);
    final userIsPremium = ref.watch(userPremiumStatusProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Quem deu Like em Você')),
      body: likesAsync.when(
        data: (profiles) {
          if (!userIsPremium) {
            // 🔒 Usuário FREE vê quantidade mas perfis desfocados
            return Column(
              children: [
                Text('${profiles.length} pessoas deram like em você!'),
                Text('Assine Premium para ver quem são'),
                BlurredProfilesGrid(profiles), // ← Blur nos avatares
                ElevatedButton(
                  onPressed: () => navigateTo('/premium'),
                  child: Text('🔓 Ver Agora - Assinar Premium'),
                ),
              ],
            );
          }
          
          // ✅ Usuário PREMIUM vê tudo
          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (ctx, i) => ProfileCard(profile: profiles[i]),
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (e, _) => Text('Erro: $e'),
      ),
    );
  }
}
```

**UI Proposta:**

**Usuário FREE:**
```
┌────────────────────────────────┐
│  ❤️ Quem Deu Like em Você      │
├────────────────────────────────┤
│                                │
│  🎉 12 pessoas gostaram de     │
│     seu perfil!                │
│                                │
│  [Perfil desfocado 1]          │ ← Blur
│  [Perfil desfocado 2]          │ ← Blur
│  [Perfil desfocado 3]          │ ← Blur
│                                │
│  🔓 Ver quem são?              │
│  [Assinar Premium R$ 19,90/mês]│
└────────────────────────────────┘
```

**Usuário PREMIUM:**
```
┌────────────────────────────────┐
│  ❤️ Quem Deu Like em Você      │
├────────────────────────────────┤
│                                │
│  [Avatar] João Silva           │
│  Barbeiro há 5 anos            │
│  [💬 Dar Like de Volta]        │
│                                │
│  [Avatar] Maria Santos         │
│  Barbearia Premium Center      │
│  [💬 Dar Like de Volta]        │
│                                │
└────────────────────────────────┘
```

**Benefícios:**
- 💰 Monetização: Principal motivo de conversão para Premium
- 🎯 Engajamento: Usuários querem saber quem os curtiu
- 🚀 Acelera matches: Premium pode dar like direto em quem já curtiu

**Esforço:** 8-10 horas  
**ROI:** MUITO ALTO (70% das conversões Premium vêm desta feature no Tinder)

---

### 🔥 7. BOOST (APARECER MAIS NAS BUSCAS)
**Apps:** Tinder Boost, Badoo Rise Up  
**Status BarberGO:** ❌ **NÃO IMPLEMENTADO** → **MÉDIA PRIORIDADE**

**Como Funciona:**
- Usuário paga para ter perfil destacado por 30 minutos
- Aparece no topo da fila de discovery
- 10x mais visualizações

**Implementação BarberGO:**

```dart
// lib/src/domain/entities/profile_entity.dart
class ProfileEntity {
  // ... campos existentes
  DateTime? boostedUntil; // 🆕 NOVO CAMPO
  int boostsRemaining; // 🆕 Quantos boosts o usuário tem
}

// lib/src/features/boost/controllers/boost_controller.dart
@riverpod
class BoostController extends _$BoostController {
  @override
  FutureOr<void> build() {}
  
  Future<void> activateBoost() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return;
    
    final profile = await profileRepository.getProfile(userId);
    
    if (profile!.boostsRemaining <= 0) {
      throw Exception('Você não tem boosts! Compre mais ou assine Premium.');
    }
    
    // Ativar boost por 30 minutos
    final boostedUntil = DateTime.now().add(Duration(minutes: 30));
    
    await profileRepository.updateProfile(userId, {
      'boostedUntil': boostedUntil,
      'boostsRemaining': profile.boostsRemaining - 1,
    });
    
    // 📊 Analytics
    logEvent('Boost_Activated', {'userId': userId, 'duration': 30});
  }
}

// lib/src/features/discovery/controllers/discovery_controller.dart
// MODIFICAR para priorizar perfis boosted
Future<List<ProfileEntity>> getDiscoverableProfiles() async {
  final allProfiles = await profileRepository.getAllProfiles();
  
  final now = DateTime.now();
  
  // Separar boosted vs normal
  final boostedProfiles = allProfiles.where((p) => 
    p.boostedUntil != null && p.boostedUntil!.isAfter(now)
  ).toList();
  
  final normalProfiles = allProfiles.where((p) => 
    p.boostedUntil == null || p.boostedUntil!.isBefore(now)
  ).toList();
  
  // Boosted aparecem PRIMEIRO
  return [...boostedProfiles, ...normalProfiles];
}
```

**UI Proposta:**
```
┌────────────────────────────────┐
│  ⚡ Boost - Seja Visto 10x Mais│
├────────────────────────────────┤
│                                │
│  Seu perfil aparecerá no topo  │
│  da fila por 30 minutos!       │
│                                │
│  📈 Estimativa: +50 views      │
│                                │
│  Você tem: 2 Boosts             │
│                                │
│  [🚀 Ativar Boost Agora]       │
│                                │
│  Não tem boosts?               │
│  [💳 Comprar 5 Boosts - R$ 9,90]│
└────────────────────────────────┘
```

**Indicador no Card:**
```
┌────────────────────────────────┐
│  ⚡ PERFIL EM DESTAQUE          │ ← Badge amarelo
│  [Avatar] João Silva           │
│  Barbeiro especialista...      │
└────────────────────────────────┘
```

**Benefícios:**
- 💰 Monetização: R$ 9,90 por 5 boosts
- 🎯 Urgência: Barbeiros buscando emprego RÁPIDO pagam
- 📈 Engajamento: Barbearias com vaga urgente ativam boost

**Esforço:** 6-8 horas  
**ROI:** Médio-Alto (feature premium adicional)

---

### 📍 8. GEOLOCALIZAÇÃO INTELIGENTE (estilo Happn)
**Apps:** Happn (cruzou com você)  
**Status BarberGO:** ⚠️ **PARCIALMENTE IMPLEMENTADO** → **MELHORAR**

**Status Atual BarberGO:**
```dart
// ✅ Já temos geolocalização básica
// lib/src/domain/entities/profile_entity.dart
class ProfileEntity {
  final GeoFirePoint? location;
}

// ❌ MAS não filtramos por proximidade no discovery
```

**Melhoria Proposta:**

```dart
// lib/src/features/discovery/controllers/discovery_controller.dart
Future<List<ProfileEntity>> getNearbyProfiles({
  required double radiusKm,
}) async {
  final userId = ref.read(authRepositoryProvider).currentUser?.uid;
  final myProfile = await profileRepository.getProfile(userId);
  
  if (myProfile?.location == null) {
    // Sem localização, mostrar todos
    return getAllProfiles();
  }
  
  // Buscar perfis num raio de X km
  final nearbyProfiles = await profileRepository.getProfilesNearby(
    center: myProfile.location!,
    radiusKm: radiusKm,
  );
  
  // Ordenar por distância
  nearbyProfiles.sort((a, b) {
    final distA = myProfile.location!.distance(a.location!);
    final distB = myProfile.location!.distance(b.location!);
    return distA.compareTo(distB);
  });
  
  return nearbyProfiles;
}
```

**UI Proposta:**
```
┌────────────────────────────────┐
│  🔍 Filtros de Busca            │
├────────────────────────────────┤
│                                │
│  📍 Raio de Busca:             │
│  [5km] [10km] [25km] [50km]    │ ← Seletor
│  [Cidade toda] [Qualquer lugar]│
│                                │
│  [Aplicar Filtros]             │
└────────────────────────────────┘

┌────────────────────────────────┐
│  [Card Barbeiro]               │
│  João Silva                    │
│  📍 A 2.5 km de você           │ ← Distância
│  ⭐ 4.8 (32 avaliações)        │
└────────────────────────────────┘
```

**Diferencial BarberGO vs Happn:**
- **Happn:** "Você cruzou com esta pessoa" (casual, coincidência)
- **BarberGO:** "Esta barbearia está a 3km de você" (prático, facilita deslocamento)

**Benefícios:**
- 🚗 Barbeiro prefere trabalhar perto de casa
- 🏪 Barbearia prefere contratar quem mora perto (menos atraso)
- 📍 Match mais prático = maior conversão

**Esforço:** 4-5 horas  
**ROI:** Alto (melhora qualidade dos matches)

---

### 💬 9. MENSAGENS PRONTAS / ICEBREAKERS
**Apps:** Badoo, Bumble (primeira mensagem sugerida)  
**Status BarberGO:** ❌ **NÃO IMPLEMENTADO** → **BAIXA PRIORIDADE**

**Como Funciona:**
- App sugere mensagens iniciais
- Facilita início da conversa
- Reduz paralisia por "não saber o que dizer"

**Implementação BarberGO:**

```dart
// lib/src/features/chat/utils/icebreakers.dart
class Icebreakers {
  static List<String> getBarbeiroBarbearia() => [
    'Olá! Vi sua vaga e fiquei interessado. Podemos conversar sobre?',
    'Boa tarde! Qual o horário de funcionamento da barbearia?',
    'Olá! Você oferece comissão ou salário fixo?',
    'Oi! Pode me contar mais sobre o ambiente de trabalho?',
  ];
  
  static List<String> getBarbeariaBarber() => [
    'Olá! Gostei do seu portfólio. Vamos agendar uma entrevista?',
    'Boa tarde! Você tem disponibilidade para trabalhar aos sábados?',
    'Oi! Qual sua pretensão salarial?',
    'Olá! Tem experiência com barbearia clássica?',
  ];
}

// lib/src/features/chat/presentation/chat_screen.dart
// Botão "Sugestões" mostra mensagens prontas
```

**UI Proposta:**
```
┌────────────────────────────────┐
│  💬 Chat com João Silva        │
├────────────────────────────────┤
│                                │
│  [Mensagens aqui...]           │
│                                │
├────────────────────────────────┤
│  💡 Sugestões:                 │
│  • "Qual o salário oferecido?" │ ← Tap para enviar
│  • "Trabalha fins de semana?"  │
│  • "Tem vale transporte?"      │
│                                │
│  [Digite sua mensagem...] [>]  │
└────────────────────────────────┘
```

**Benefícios:**
- ⚡ Acelera início das conversas
- 🤝 Reduz ansiedade do primeiro contato
- 💼 Mensagens já focadas no contexto profissional

**Esforço:** 2-3 horas  
**ROI:** Baixo (nice-to-have, não critical)

---

### ⏱️ 10. LIMITE DE TEMPO PARA MENSAGEM (estilo Bumble)
**Apps:** Bumble (mulher tem 24h para enviar primeira mensagem)  
**Status BarberGO:** ❌ **NÃO IMPLEMENTADO** → **BAIXA PRIORIDADE**

**Como Funciona:**
- Após match, uma pessoa tem 24h para enviar mensagem
- Se não enviar, match expira
- Cria urgência

**Adaptação BarberGO:**
- ❌ **NÃO recomendado** para recrutamento
- Motivo: Contratação é decisão séria, não deve ter pressão artificial
- Melhor: Deixar ambos se comunicarem livremente

---

### 📸 11. STORIES (estilo Instagram)
**Apps:** Badoo (Stories), Tinder (Feed)  
**Status BarberGO:** ❌ **NÃO IMPLEMENTADO** → **FUTURA FASE**

**Como Funciona:**
- Usuários postam fotos/vídeos temporários (24h)
- Mostra trabalhos recentes, bastidores, dia a dia

**Implementação BarberGO:**

```dart
// FUTURA FASE - Não prioritário agora
// lib/src/domain/entities/story_entity.dart
class StoryEntity {
  final String storyId;
  final String userId;
  final String mediaUrl; // Imagem ou vídeo
  final DateTime createdAt;
  final DateTime expiresAt; // createdAt + 24h
  final List<String> viewedBy; // Quem visualizou
}
```

**Casos de Uso:**
- 💇 **Barbeiro:** Posta story mostrando corte que acabou de fazer
- 🏪 **Barbearia:** Posta story do ambiente, equipe, movimento do dia

**Benefícios:**
- 📈 Engajamento diário (usuários voltam para ver stories)
- 🎨 Portfólio dinâmico (além das fotos estáticas do perfil)
- 🤳 Conteúdo autêntico (bastidores do trabalho)

**Esforço:** 15-20 horas (feature complexa)  
**ROI:** Médio (engajamento, mas não critical para MVP)

---

### 🎮 12. GAMIFICAÇÃO / CONQUISTAS
**Apps:** Badoo (badges), Tinder (perfil completo)  
**Status BarberGO:** ❌ **NÃO IMPLEMENTADO** → **FUTURA FASE**

**Como Funciona:**
- Usuário ganha badges/conquistas por ações
- "Perfil 100% completo", "Primeiro match", "10 likes dados"

**Implementação BarberGO:**

```dart
// lib/src/domain/entities/achievement_entity.dart
enum Achievement {
  profileComplete, // ✅ Completou perfil 100%
  firstMatch, // 🎉 Primeiro match
  tenLikes, // ❤️ Deu 10 likes
  fiveChats, // 💬 Iniciou 5 conversas
  firstHire, // 🤝 Primeira contratação
  tenHires, // 👑 10 contratações
}

class AchievementEntity {
  final String userId;
  final Achievement achievement;
  final DateTime unlockedAt;
}
```

**UI Proposta:**
```
┌────────────────────────────────┐
│  🏆 Suas Conquistas            │
├────────────────────────────────┤
│                                │
│  ✅ Perfil Completo            │
│  ✅ Primeiro Match             │
│  ✅ 10 Likes Dados             │
│  🔒 Primeira Contratação       │ ← Ainda não
│  🔒 10 Contratações            │
│                                │
└────────────────────────────────┘
```

**Benefícios:**
- 🎮 Aumenta engajamento
- 🏆 Incentiva completar perfil
- 📊 Gamifica o processo de recrutamento

**Esforço:** 8-10 horas  
**ROI:** Baixo (nice-to-have, não critical)

---

### 🔔 13. NOTIFICAÇÕES PUSH INTELIGENTES
**Apps:** Todos (Tinder, Badoo, Happn)  
**Status BarberGO:** ⚠️ **PARCIALMENTE IMPLEMENTADO** → **MELHORAR**

**Status Atual:**
```dart
// ✅ Já temos Firebase Cloud Messaging configurado
// ❌ MAS não enviamos notificações estratégicas
```

**Melhoria Proposta:**

| Evento | Notificação | Timing |
|--------|-------------|--------|
| Novo Match | "🎉 Você deu match com João Silva!" | Imediato |
| Mensagem Recebida | "💬 João Silva enviou uma mensagem" | Imediato |
| Super Like Recebido | "⭐ Barbearia Premium te deu Super Like!" | Imediato |
| Like Recebido (Premium) | "❤️ 3 novas pessoas curtiram seu perfil" | Agregado (1x/dia) |
| Inatividade | "👋 Saudades! Volte para ver novos barbeiros" | 3 dias sem abrir |
| Perfil Incompleto | "📝 Complete seu perfil e receba 3x mais matches" | 1 dia após cadastro |
| Boost Expirou | "⚡ Seu boost acabou! Ative outro?" | Fim do boost |

**Implementação:**

```dart
// lib/src/core/services/notification_service.dart
class NotificationService {
  Future<void> sendMatchNotification(String userId, String matchName) async {
    await FirebaseMessaging.instance.send(
      to: userId,
      notification: Notification(
        title: '🎉 Novo Match!',
        body: 'Você deu match com $matchName!',
      ),
      data: {'type': 'match', 'matchName': matchName},
    );
  }
  
  Future<void> sendSuperLikeNotification(String userId, String senderName) async {
    await FirebaseMessaging.instance.send(
      to: userId,
      notification: Notification(
        title: '⭐ Super Like!',
        body: '$senderName te deu um Super Like!',
      ),
      data: {'type': 'superlike', 'senderId': senderName},
    );
  }
  
  // ... outras notificações
}
```

**Benefícios:**
- 📈 Aumenta retenção (usuários voltam ao app)
- ⚡ Acelera matches (notificação imediata)
- 🎯 Re-engajamento (notificação de inatividade)

**Esforço:** 5-6 horas  
**ROI:** ALTO (retenção é key metric)

---

## 📊 RESUMO: PRIORIZAÇÃO DE FEATURES

### 🔴 ALTA PRIORIDADE (Implementar Agora)

| Feature | Status Atual | Esforço | ROI | Prazo |
|---------|--------------|---------|-----|-------|
| **Super Like** | ❌ Não implementado | 6-8h | 🔥 Alto | 1 semana |
| **Ver Quem Deu Like** | ❌ Não implementado | 8-10h | 🔥🔥🔥 MUITO Alto | 1-2 semanas |
| **Notificações Push** | ⚠️ Parcial | 5-6h | 🔥🔥 Alto | 1 semana |
| **Geolocalização Inteligente** | ⚠️ Parcial | 4-5h | 🔥🔥 Alto | 3-5 dias |

**Total:** ~25-29 horas (~3-4 semanas)

---

### 🟡 MÉDIA PRIORIDADE (Próximas Sprints)

| Feature | Status Atual | Esforço | ROI | Prazo |
|---------|--------------|---------|-----|-------|
| **Boost** | ❌ Não implementado | 6-8h | 🔥 Médio-Alto | 1 semana |
| **Mensagens Prontas** | ❌ Não implementado | 2-3h | 🟡 Baixo | 1 dia |
| **Gamificação** | ❌ Não implementado | 8-10h | 🟡 Baixo | 1-2 semanas |

**Total:** ~16-21 horas (~2-3 semanas)

---

### 🟢 BAIXA PRIORIDADE (Futuras Fases)

| Feature | Status Atual | Esforço | ROI | Prazo |
|---------|--------------|---------|-----|-------|
| **Stories** | ❌ Não implementado | 15-20h | 🟡 Médio | 2-3 semanas |
| **Limite de Tempo para Mensagem** | ❌ Não implementado | ❌ Não recomendado | ❌ | N/A |

---

## 🎯 ROADMAP SUGERIDO

### **SPRINT ATUAL (1-2 semanas): CORE PREMIUM FEATURES**

**Objetivo:** Implementar features que geram receita

1. ✅ **Super Like** (6-8h)
   - Adicionar campo `isSuperLike` em SwipeEntity
   - Criar `superLike()` method em SwipeController
   - UI: Botão "⭐ Super Like" na tela de swipe
   - Limitar 1/dia para free, ilimitado para premium
   - Enviar notificação push quando alguém recebe super like

2. ✅ **Ver Quem Deu Like** (8-10h)
   - Criar `LikesReceivedController`
   - Criar `LikesReceivedScreen`
   - Free: Mostrar quantidade + perfis desfocados
   - Premium: Mostrar perfis completos + botão "Dar Like de Volta"

3. ✅ **Notificações Push Inteligentes** (5-6h)
   - Notificação de match
   - Notificação de mensagem
   - Notificação de super like
   - Notificação de inatividade (3 dias)

**Total:** 19-24 horas

---

### **PRÓXIMA SPRINT (2-3 semanas): DISCOVERY & ENGAGEMENT**

**Objetivo:** Melhorar qualidade dos matches e engajamento

4. ✅ **Geolocalização Inteligente** (4-5h)
   - Filtro por raio (5km, 10km, 25km, 50km, cidade toda)
   - Ordenar por distância
   - Mostrar distância no card

5. ✅ **Boost** (6-8h)
   - Campo `boostedUntil` em ProfileEntity
   - Botão "⚡ Ativar Boost" na tela de perfil
   - Modificar discovery para priorizar perfis boosted
   - Sistema de compra de boosts (5 boosts por R$ 9,90)

6. ✅ **Mensagens Prontas** (2-3h)
   - Lista de icebreakers para barbeiro→barbearia
   - Lista de icebreakers para barbearia→barbeiro
   - Botão "💡 Sugestões" na tela de chat

**Total:** 12-16 horas

---

### **SPRINT FUTURA (3-4 semanas): GAMIFICAÇÃO & SOCIAL**

**Objetivo:** Aumentar engajamento diário

7. ✅ **Gamificação** (8-10h)
   - Sistema de conquistas
   - Badges no perfil
   - Progresso visual

8. ✅ **Stories** (15-20h)
   - Upload de story (24h)
   - Visualização de stories
   - Contador de views

**Total:** 23-30 horas

---

## 💰 MODELO DE MONETIZAÇÃO

### **PLANO FREE**
- ✅ Swipes ilimitados
- ✅ 1 Super Like por dia
- ✅ Matches ilimitados
- ✅ Chat ilimitado
- ❌ Ver quem deu like (apenas quantidade)
- ❌ Boost

### **PLANO PREMIUM (R$ 19,90/mês)**
- ✅ Tudo do Free
- ✅ Super Likes ILIMITADOS
- ✅ **Ver quem deu like** ⭐ (killer feature)
- ✅ 1 Boost grátis por mês
- ✅ Filtros avançados
- ✅ Sem anúncios

### **COMPRAS AVULSAS**
- ⚡ 5 Boosts: R$ 9,90
- ⚡ 10 Boosts: R$ 17,90
- ⭐ 5 Super Likes: R$ 4,90
- ⭐ 10 Super Likes: R$ 8,90

---

## 📈 MÉTRICAS DE SUCESSO

### **Engajamento:**
- MAU (Monthly Active Users) > 1.000
- DAU/MAU ratio > 30% (usuários voltam 9+ dias/mês)
- Média de swipes/usuário/dia > 20
- Taxa de match > 5%

### **Monetização:**
- Conversão Free → Premium > 3%
- LTV (Lifetime Value) > R$ 60
- CAC (Customer Acquisition Cost) < R$ 30
- Payback < 2 meses

### **Retenção:**
- D1 (Day 1 Retention) > 40%
- D7 (Day 7 Retention) > 20%
- D30 (Day 30 Retention) > 10%

---

## 🎯 PRÓXIMA AÇÃO IMEDIATA

### **AGORA (hoje):**
1. ✅ Criar branch `feature/super-like`
2. ✅ Adicionar campo `isSuperLike` em SwipeEntity
3. ✅ Implementar `superLike()` em SwipeController
4. ✅ Criar UI do botão Super Like

### **ESTA SEMANA:**
1. ✅ Finalizar Super Like
2. ✅ Começar "Ver Quem Deu Like"
3. ✅ Testar notificações push

---

**Status:** 🚀 **READY TO BUILD!**  
**Foco:** Implementar features Premium que geram receita  
**Prazo:** 3-4 semanas para completar features de alta prioridade  

**Let's make BarberGO the Tinder of Professional Recruitment!** 💼✂️🔥
