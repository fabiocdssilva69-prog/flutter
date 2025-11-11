# 🚀 ROADMAP: Premium Features (Inspiradas no Tinder/Badoo)

**Data:** 1 de Novembro de 2025  
**Objetivo:** Implementar features premium que geram receita e melhoram engajamento  
**Baseado em:** Análise completa em `TINDER_FEATURES_ANALYSIS.md`

---

## 🎯 VISÃO GERAL

**Core Insight:** Apps de match lucram com 3 pilares:
1. 💎 **Premium Subscription** (receita recorrente)
2. 💰 **In-App Purchases** (boosts, super likes avulsos)
3. 📈 **Ads** (para usuários free)

**Meta BarberGO:**
- 3% de conversão Free → Premium (R$ 19,90/mês)
- R$ 100-200/mês em compras avulsas
- LTV > R$ 60 por usuário

---

## 📅 CRONOGRAMA DE IMPLEMENTAÇÃO

### **FASE 11: PREMIUM FEATURES CORE** (2-3 semanas)
**Período:** 4-24 de Novembro  
**Objetivo:** Implementar features que justificam assinatura Premium

#### ✅ Task 11.1: Super Like System (6-8h)
**Responsável:** Dev Backend + Frontend  
**Prioridade:** 🔴 CRÍTICA

**Backend:**
```dart
// lib/src/domain/entities/swipe_entity.dart
class SwipeEntity {
  final String swipeId;
  final String fromUserId;
  final String toUserId;
  final bool liked;
  final bool isSuperLike; // 🆕 NOVO
  final DateTime createdAt;
}

// lib/src/features/discovery/controllers/swipe_controller.dart
Future<bool> superLike(String toUserId) async {
  final userId = currentUser.uid;
  
  // Verificar limite (1/dia para free)
  final superLikesToday = await countSuperLikesToday(userId);
  final isPremium = await checkPremiumStatus(userId);
  
  if (superLikesToday >= 1 && !isPremium) {
    throw SuperLikeLimitException('Assine Premium para Super Likes ilimitados!');
  }
  
  // Criar swipe especial
  await swipeRepository.createSwipe(
    fromUserId: userId,
    toUserId: toUserId,
    liked: true,
    isSuperLike: true,
  );
  
  // 🔔 Notificar destinatário
  await notificationService.sendSuperLike(toUserId, userId);
  
  // Verificar match
  final hasReverseSwipe = await hasReverseSwipe(userId, toUserId);
  if (hasReverseSwipe) {
    await createMatch(userId, toUserId);
  }
  
  return true;
}
```

**Frontend:**
```dart
// lib/src/features/discovery/presentation/swipe_screen.dart
// Adicionar botão Super Like entre os botões Like/Dislike

Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    IconButton(
      icon: Icon(Icons.close, size: 40, color: Colors.red),
      onPressed: () => controller.dislike(profile.id),
    ),
    IconButton(
      icon: Icon(Icons.star, size: 50, color: Colors.amber), // ⭐
      onPressed: () => _handleSuperLike(profile.id),
    ),
    IconButton(
      icon: Icon(Icons.favorite, size: 40, color: Colors.green),
      onPressed: () => controller.like(profile.id),
    ),
  ],
)

Future<void> _handleSuperLike(String profileId) async {
  try {
    await ref.read(swipeControllerProvider.notifier).superLike(profileId);
    
    // Mostrar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('⭐ Super Like enviado!')),
    );
  } on SuperLikeLimitException catch (e) {
    // Mostrar paywall
    showDialog(
      context: context,
      builder: (_) => PremiumUpsellDialog(
        title: 'Super Likes Ilimitados',
        description: e.message,
      ),
    );
  }
}
```

**Testes:**
- [ ] Usuário free pode enviar 1 super like/dia
- [ ] Usuário premium pode enviar super likes ilimitados
- [ ] Notificação é enviada imediatamente
- [ ] Super like aparece destacado no card do destinatário
- [ ] Contador de super likes reseta à meia-noite

**Definição de Pronto:**
- ✅ Backend implementado e testado
- ✅ UI com botão Super Like funcional
- ✅ Paywall aparece quando limite atingido
- ✅ Notificação push funcionando
- ✅ Analytics trackando super_like_sent/received

---

#### ✅ Task 11.2: "Ver Quem Deu Like" (8-10h)
**Responsável:** Dev Backend + Frontend  
**Prioridade:** 🔴 CRÍTICA (killer feature)

**Backend:**
```dart
// lib/src/features/likes/controllers/likes_received_controller.dart
@riverpod
class LikesReceivedController extends _$LikesReceivedController {
  @override
  Future<List<ProfileWithSwipe>> build() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return [];
    
    // Buscar todos os swipes onde toUserId = eu
    final swipes = await ref.read(swipeRepositoryProvider)
      .getSwipesForUser(userId);
    
    // Filtrar apenas likes (não dislikes)
    final likes = swipes.where((s) => s.liked).toList();
    
    // Buscar perfis dos usuários
    final profilesWithSwipes = <ProfileWithSwipe>[];
    for (final swipe in likes) {
      final profile = await profileRepository.getProfile(swipe.fromUserId);
      if (profile != null) {
        profilesWithSwipes.add(ProfileWithSwipe(
          profile: profile,
          swipe: swipe,
        ));
      }
    }
    
    return profilesWithSwipes;
  }
  
  /// Dar like de volta (só premium vê quem deu like antes)
  Future<void> likeBack(String profileId) async {
    final userId = currentUser.uid;
    await ref.read(swipeControllerProvider.notifier).like(profileId);
    
    // Refresh lista
    ref.invalidateSelf();
  }
}
```

**Frontend:**
```dart
// lib/src/features/likes/screens/likes_received_screen.dart
class LikesReceivedScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesAsync = ref.watch(likesReceivedControllerProvider);
    final isPremium = ref.watch(premiumStatusProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('❤️ Quem Curtiu Você'),
      ),
      body: likesAsync.when(
        data: (likes) {
          if (likes.isEmpty) {
            return Center(
              child: Text('Ninguém curtiu você ainda 😢'),
            );
          }
          
          if (!isPremium) {
            // 🔒 FREE USER: Mostrar quantidade mas blur nos perfis
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '🎉 ${likes.length} pessoas curtiram você!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: likes.length,
                    itemBuilder: (ctx, i) => BlurredProfileCard(
                      profile: likes[i].profile,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => context.push('/premium'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    child: Text(
                      '🔓 Ver Quem São - Assinar Premium',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          }
          
          // ✅ PREMIUM USER: Mostrar tudo
          return ListView.builder(
            itemCount: likes.length,
            itemBuilder: (ctx, i) {
              final item = likes[i];
              return LikeReceivedCard(
                profile: item.profile,
                swipe: item.swipe,
                onLikeBack: () => ref.read(likesReceivedControllerProvider.notifier)
                  .likeBack(item.profile.id),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}

// Widget para usuário free (perfil desfocado)
class BlurredProfileCard extends StatelessWidget {
  final ProfileEntity profile;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          // Imagem desfocada
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Image.network(
              profile.photoUrl ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          // Ícone de cadeado
          Center(
            child: Icon(Icons.lock, size: 50, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
```

**Testes:**
- [ ] Free user vê quantidade de likes mas perfis desfocados
- [ ] Premium user vê todos os perfis completos
- [ ] Botão "Dar Like de Volta" funciona
- [ ] Dar like de volta cria match se mútuo
- [ ] Paywall aparece corretamente para free users

**Definição de Pronto:**
- ✅ Tela implementada com blur para free
- ✅ Tela funcional completa para premium
- ✅ Botão de upsell para premium
- ✅ Analytics trackando likes_screen_viewed, premium_upsell_shown

---

#### ✅ Task 11.3: Sistema de Assinatura Premium (10-12h)
**Responsável:** Dev Backend + Frontend + Integrações  
**Prioridade:** 🔴 CRÍTICA

**Integrações:**
- [ ] Stripe (web)
- [ ] Google Play Billing (Android)
- [ ] Apple In-App Purchase (iOS)

**Backend:**
```dart
// lib/src/features/premium/controllers/subscription_controller.dart
@riverpod
class SubscriptionController extends _$SubscriptionController {
  @override
  Future<SubscriptionStatus> build() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return SubscriptionStatus.free;
    
    // Buscar status no Firestore
    final doc = await firestore.collection('subscriptions').doc(userId).get();
    
    if (!doc.exists) return SubscriptionStatus.free;
    
    final data = doc.data()!;
    final expiresAt = (data['expiresAt'] as Timestamp).toDate();
    
    if (expiresAt.isAfter(DateTime.now())) {
      return SubscriptionStatus.premium;
    } else {
      return SubscriptionStatus.expired;
    }
  }
  
  Future<void> subscribe(SubscriptionPlan plan) async {
    final userId = currentUser.uid;
    
    // Iniciar processo de pagamento
    final paymentResult = await PaymentService.processPayment(plan);
    
    if (paymentResult.success) {
      // Ativar premium no Firestore
      await firestore.collection('subscriptions').doc(userId).set({
        'plan': plan.name,
        'status': 'active',
        'startedAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 30)),
        ),
        'autoRenew': true,
      });
      
      // Atualizar flag premium no perfil
      await firestore.collection('profiles').doc(userId).update({
        'isPremium': true,
      });
      
      ref.invalidateSelf();
    }
  }
  
  Future<void> cancelSubscription() async {
    final userId = currentUser.uid;
    
    await firestore.collection('subscriptions').doc(userId).update({
      'autoRenew': false,
      'canceledAt': FieldValue.serverTimestamp(),
    });
    
    ref.invalidateSelf();
  }
}
```

**Frontend:**
```dart
// lib/src/features/premium/screens/premium_screen.dart
class PremiumScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('💎 BarberGO Premium')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber, Colors.orange],
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.star, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Turbine Seu Recrutamento',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Encontre a vaga perfeita 3x mais rápido',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            // Features
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  PremiumFeatureTile(
                    icon: Icons.visibility,
                    title: 'Ver Quem Curtiu Você',
                    description: 'Veja todos os barbeiros/barbearias interessados antes de decidir',
                  ),
                  PremiumFeatureTile(
                    icon: Icons.star,
                    title: 'Super Likes Ilimitados',
                    description: 'Destaque-se com quantos super likes quiser',
                  ),
                  PremiumFeatureTile(
                    icon: Icons.flash_on,
                    title: '1 Boost Grátis por Mês',
                    description: 'Apareça no topo da fila por 30 minutos',
                  ),
                  PremiumFeatureTile(
                    icon: Icons.tune,
                    title: 'Filtros Avançados',
                    description: 'Filtre por distância, experiência, especialidade',
                  ),
                  PremiumFeatureTile(
                    icon: Icons.block,
                    title: 'Sem Anúncios',
                    description: 'Experiência premium sem interrupções',
                  ),
                ],
              ),
            ),
            
            // Pricing
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'R\$ 19,90',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  Text('por mês'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _subscribe(ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                    ),
                    child: Text(
                      'Assinar Agora',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cancele quando quiser',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _subscribe(WidgetRef ref) async {
    await ref.read(subscriptionControllerProvider.notifier).subscribe(
      SubscriptionPlan.monthly,
    );
    
    // Mostrar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Premium ativado! Bem-vindo!')),
    );
  }
}
```

**Testes:**
- [ ] Fluxo de assinatura completo funciona
- [ ] Status premium persiste após login
- [ ] Renovação automática funciona
- [ ] Cancelamento funciona (termina no fim do período)
- [ ] Features premium são desbloqueadas

**Definição de Pronto:**
- ✅ Integração com Stripe funcionando
- ✅ Tela de premium implementada
- ✅ Status premium persiste em Firestore
- ✅ Features premium funcionam apenas para assinantes
- ✅ Analytics trackando subscription_started, subscription_canceled

---

### **FASE 12: BOOST & DISCOVERY INTELIGENTE** (1-2 semanas)
**Período:** 25 Nov - 8 Dez  
**Objetivo:** Melhorar qualidade dos matches e monetização adicional

#### ✅ Task 12.1: Sistema de Boost (6-8h)

**Backend:**
```dart
// Adicionar em ProfileEntity
class ProfileEntity {
  // ... campos existentes
  DateTime? boostedUntil;
  int boostsRemaining;
}

// lib/src/features/boost/controllers/boost_controller.dart
Future<void> activateBoost() async {
  final profile = await getMyProfile();
  
  if (profile.boostsRemaining <= 0) {
    throw InsufficientBoostsException('Compre mais boosts!');
  }
  
  final boostedUntil = DateTime.now().add(Duration(minutes: 30));
  
  await profileRepository.updateProfile(userId, {
    'boostedUntil': boostedUntil,
    'boostsRemaining': profile.boostsRemaining - 1,
  });
  
  logEvent('boost_activated');
}
```

#### ✅ Task 12.2: Geolocalização Inteligente (4-5h)

**Filtro por distância:**
```dart
Future<List<ProfileEntity>> getNearbyProfiles(double radiusKm) async {
  final myLocation = await getMyLocation();
  
  return await profileRepository.getProfilesNearby(
    center: myLocation,
    radiusKm: radiusKm,
  );
}
```

---

### **FASE 13: NOTIFICAÇÕES & RE-ENGAGEMENT** (1 semana)
**Período:** 9-15 Dez  
**Objetivo:** Aumentar retenção e DAU/MAU

#### ✅ Task 13.1: Notificações Push Estratégicas (5-6h)

| Evento | Mensagem | Timing |
|--------|----------|--------|
| Match | "🎉 Match! Você e João Silva se curtiram" | Imediato |
| Super Like | "⭐ Barbearia X te deu Super Like!" | Imediato |
| Mensagem | "💬 Nova mensagem de Maria" | Imediato |
| Inatividade | "Volte! 5 novos barbeiros esperando" | 3 dias |

---

### **FASE 14: GAMIFICAÇÃO** (1-2 semanas)
**Período:** 16-30 Dez  
**Objetivo:** Aumentar engajamento e completude de perfis

#### ✅ Task 14.1: Sistema de Conquistas (8-10h)

```dart
enum Achievement {
  profileComplete,
  firstMatch,
  tenLikes,
  fiveChats,
  firstHire,
}
```

---

## 📊 MÉTRICAS DE ACOMPANHAMENTO

### **KPIs de Produto:**
- MAU (Monthly Active Users): 1.000+
- DAU/MAU ratio: 30%+
- Swipes/usuário/dia: 20+
- Taxa de match: 5%+
- Conversão Free→Premium: 3%+

### **KPIs de Receita:**
- MRR (Monthly Recurring Revenue): R$ 5.000+
- ARPU (Average Revenue Per User): R$ 5+
- LTV (Lifetime Value): R$ 60+
- Churn rate: < 10%/mês

### **KPIs de Engajamento:**
- D1 Retention: 40%+
- D7 Retention: 20%+
- D30 Retention: 10%+
- Session length: 5+ minutos

---

## 🎯 PRÓXIMOS PASSOS IMEDIATOS

### **HOJE:**
1. ✅ Revisar `TINDER_FEATURES_ANALYSIS.md`
2. ✅ Criar branch `feature/phase-11-premium`
3. ✅ Começar Task 11.1 (Super Like)

### **ESTA SEMANA:**
1. ✅ Implementar Super Like (2 dias)
2. ✅ Implementar "Ver Quem Deu Like" (3 dias)
3. ✅ Testar ambas features

### **PRÓXIMAS 2 SEMANAS:**
1. ✅ Implementar Sistema de Assinatura (5 dias)
2. ✅ Boost System (2 dias)
3. ✅ Geolocalização Inteligente (1 dia)

---

**Status:** 🚀 **READY TO START!**  
**Prioridade Máxima:** Super Like + Ver Quem Deu Like (features que geram receita)  
**Prazo MVP Premium:** 24 de Novembro (3 semanas)
