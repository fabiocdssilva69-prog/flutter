# 🚀 Guia Rápido - 15 Minutos

Execute os comandos na ordem. **Total: ~15 minutos**

---

## ✅ PASSO 1: Corrigir Testes (3 min)

### 1.1. Executar build_runner (2 min)

```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

### 1.2. Corrigir providers nos testes (1 min)

**Abrir:** `test/features/discovery/swipe_screen_test.dart`

**Trocar TODAS as ocorrências** de:

```dart
discoverProfilesProvider.overrideWith((ref) async {
```

**Por:**

```dart
discoverProfilesProvider.overrideWith((ref) {
  return Stream.value([]);  // ou Stream.error() para erro
```

**Exemplo completo:**

```dart
// ❌ ERRADO (retorna Future)
discoverProfilesProvider.overrideWith((ref) async {
  throw Exception('Erro de teste');
}),

// ✅ CORRETO (retorna Stream)
discoverProfilesProvider.overrideWith((ref) {
  return Stream.error(Exception('Erro de teste'));
}),
```

**Aplicar em:**

- `test/features/discovery/swipe_screen_test.dart` (6 vezes)
- `test/features/matches/matches_screen_test.dart` (se houver)
- `test/features/chat/chat_screen_test.dart` (se houver)

### 1.3. Remover campo phoneNumber (se necessário)

**Se aparecer erro "No named parameter 'phoneNumber'"**, remover esse campo dos ProfileEntity de teste.

**Executar testes:**

```powershell
flutter test test/features/
```

---

## 🔥 PASSO 2: Cloud Functions (5 min)

### 2.1. Inicializar Functions (1 min)

```powershell
firebase init functions
# Escolher: TypeScript, Install dependencies
```

### 2.2. Criar detectMatch function (2 min)

**Arquivo:** `functions/src/index.ts`

```typescript
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

// Detectar match quando swipe é criado
export const detectMatch = functions.firestore
  .document("swipes/{swipeId}")
  .onCreate(async (snap, context) => {
    const swipe = snap.data();
    const { userId, targetUserId, liked } = swipe;

    // Só processa se foi like
    if (!liked) return null;

    // Verificar se o outro usuário também deu like
    const reverseSwipeQuery = await db
      .collection("swipes")
      .where("userId", "==", targetUserId)
      .where("targetUserId", "==", userId)
      .where("liked", "==", true)
      .limit(1)
      .get();

    // Se não encontrou like reverso, não há match
    if (reverseSwipeQuery.empty) {
      console.log("No match: like reverso não encontrado");
      return null;
    }

    // Criar match
    const matchId = [userId, targetUserId].sort().join("_");
    await db.collection("matches").doc(matchId).set({
      matchId,
      user1Id: userId,
      user2Id: targetUserId,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastMessageAt: admin.firestore.FieldValue.serverTimestamp(),
      unreadCountUser1: 0,
      unreadCountUser2: 0,
    });

    console.log(`✅ Match criado: ${matchId}`);
    return null;
  });

// Enviar notificação quando match é criado
export const sendMatchNotification = functions.firestore
  .document("matches/{matchId}")
  .onCreate(async (snap, context) => {
    const match = snap.data();
    const { user1Id, user2Id } = match;

    // Buscar perfis e tokens
    const [user1Doc, user2Doc] = await Promise.all([
      db.collection("profiles").doc(user1Id).get(),
      db.collection("profiles").doc(user2Id).get(),
    ]);

    const user1 = user1Doc.data();
    const user2 = user2Doc.data();

    if (!user1 || !user2) return null;

    const tokens: string[] = [];
    if (user1.fcmToken) tokens.push(user1.fcmToken);
    if (user2.fcmToken) tokens.push(user2.fcmToken);

    if (tokens.length === 0) return null;

    // Enviar notificações
    await admin.messaging().sendEachForMulticast({
      tokens,
      notification: {
        title: "🎉 Novo Match!",
        body: `Você e outro usuário deram match! Comece a conversar agora.`,
      },
      data: {
        type: "match",
        matchId: match.matchId,
      },
    });

    console.log(`🔔 Notificações enviadas: ${tokens.length}`);
    return null;
  });
```

### 2.3. Deploy (2 min)

```powershell
cd functions
npm install
cd ..
firebase deploy --only functions
```

**Verificar:**

```powershell
firebase functions:log
```

---

## 🎉 PASSO 3: Match Celebration (4 min)

### 3.1. Adicionar pacote (30s)

```powershell
flutter pub add confetti
```

### 3.2. Criar Dialog (2 min)

**Arquivo:** `lib/src/features/matches/presentation/widgets/match_celebration_dialog.dart`

```dart
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/profile_entity.dart';

class MatchCelebrationDialog extends StatefulWidget {
  final ProfileEntity currentUser;
  final ProfileEntity matchedUser;
  final VoidCallback onContinue;
  final VoidCallback onSendMessage;

  const MatchCelebrationDialog({
    super.key,
    required this.currentUser,
    required this.matchedUser,
    required this.onContinue,
    required this.onSendMessage,
  });

  @override
  State<MatchCelebrationDialog> createState() => _MatchCelebrationDialogState();
}

class _MatchCelebrationDialogState extends State<MatchCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Confetti
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();

    // Scale animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.1,
            colors: const [Colors.pink, Colors.red, Colors.purple, Colors.orange],
          ),
        ),

        // Dialog
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título
                  const Text(
                    '🎉 É um Match!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Avatars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAvatar(widget.currentUser.avatarUrl),
                      const SizedBox(width: 16),
                      const Icon(Icons.favorite, color: Colors.pink, size: 40),
                      const SizedBox(width: 16),
                      _buildAvatar(widget.matchedUser.avatarUrl),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Mensagem
                  Text(
                    'Você e ${widget.matchedUser.name} deram match!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 32),

                  // Botões
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onContinue,
                          child: const Text('Continuar explorando'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onSendMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                          ),
                          child: const Text('Enviar mensagem'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String? url) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: url != null ? CachedNetworkImageProvider(url) : null,
      child: url == null ? const Icon(Icons.person, size: 50) : null,
    );
  }
}
```

### 3.3. Integrar no SwipeScreen (1 min)

**Arquivo:** `lib/src/features/discovery/presentation/swipe_screen.dart`

**Adicionar import:**

```dart
import '../../../matches/presentation/widgets/match_celebration_dialog.dart';
import 'package:go_router/go_router.dart';
```

**Modificar o callback onSwipe:**

```dart
onSwipe: (previousIndex, currentIndex, direction) async {
  final profile = profiles[previousIndex];
  final liked = direction == CardSwiperDirection.right;

  // Swipe no controller
  await swipeController.swipe(
    targetUserId: profile.userId,
    liked: liked,
  );

  if (liked && mounted) {
    // Aguardar detecção de match (Cloud Function processa)
    await Future.delayed(const Duration(seconds: 2));
    
    // Verificar se houve match (simplificado - você pode fazer query real)
    // TODO: Implementar query real para verificar se match foi criado
    final hasMatch = false; // Substituir por query real
    
    if (hasMatch) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MatchCelebrationDialog(
          currentUser: ref.read(currentUserProfileProvider).value!,
          matchedUser: profile,
          onContinue: () => Navigator.pop(context),
          onSendMessage: () {
            Navigator.pop(context);
            final matchId = [currentUserId, profile.userId].sort().join('_');
            context.push('/chat/$matchId', extra: profile);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(liked ? '❤️ Você curtiu ${profile.name}' : '👋')),
      );
    }
  }
},
```

---

## 🔍 PASSO 4: Filtros de Descoberta (3 min)

### 4.1. Criar modelo (1 min)

**Arquivo:** `lib/src/features/discovery/models/discovery_filters.dart`

```dart
class DiscoveryFilters {
  final int radiusKm;
  final AccountType? accountType;
  final bool onlineOnly;

  const DiscoveryFilters({
    this.radiusKm = 25,
    this.accountType,
    this.onlineOnly = false,
  });

  DiscoveryFilters copyWith({
    int? radiusKm,
    AccountType? accountType,
    bool? onlineOnly,
  }) {
    return DiscoveryFilters(
      radiusKm: radiusKm ?? this.radiusKm,
      accountType: accountType ?? this.accountType,
      onlineOnly: onlineOnly ?? this.onlineOnly,
    );
  }
}
```

### 4.2. Criar UI (1 min)

**Arquivo:** `lib/src/features/discovery/presentation/widgets/filters_bottom_sheet.dart`

```dart
import 'package:flutter/material.dart';
import '../../models/discovery_filters.dart';
import '../../../../domain/entities/enums.dart';

class FiltersBottomSheet extends StatefulWidget {
  final DiscoveryFilters currentFilters;
  final Function(DiscoveryFilters) onApply;

  const FiltersBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  late DiscoveryFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filtros', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          // Raio
          const Text('Raio de busca:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 5, label: Text('5 km')),
              ButtonSegment(value: 10, label: Text('10 km')),
              ButtonSegment(value: 25, label: Text('25 km')),
            ],
            selected: {_filters.radiusKm},
            onSelectionChanged: (Set<int> selection) {
              setState(() => _filters = _filters.copyWith(radiusKm: selection.first));
            },
          ),
          const SizedBox(height: 16),

          // Tipo de conta
          const Text('Tipo de usuário:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          SegmentedButton<AccountType?>(
            segments: const [
              ButtonSegment(value: null, label: Text('Todos')),
              ButtonSegment(value: AccountType.barber, label: Text('Barbeiros')),
              ButtonSegment(value: AccountType.customer, label: Text('Clientes')),
            ],
            selected: {_filters.accountType},
            onSelectionChanged: (Set<AccountType?> selection) {
              setState(() => _filters = _filters.copyWith(accountType: selection.first));
            },
          ),
          const SizedBox(height: 16),

          // Online
          SwitchListTile(
            title: const Text('Apenas usuários online'),
            value: _filters.onlineOnly,
            onChanged: (value) {
              setState(() => _filters = _filters.copyWith(onlineOnly: value));
            },
          ),
          const SizedBox(height: 24),

          // Botão aplicar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_filters);
                Navigator.pop(context);
              },
              child: const Text('Aplicar Filtros'),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 4.3. Integrar no SwipeScreen (1 min)

**Adicionar no AppBar:**

```dart
AppBar(
  title: const Text('Descobrir'),
  actions: [
    IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => FiltersBottomSheet(
            currentFilters: const DiscoveryFilters(),
            onApply: (filters) {
              // TODO: Aplicar filtros no provider
              print('Filtros: raio=${filters.radiusKm}km');
            },
          ),
        );
      },
    ),
  ],
),
```

---

## ✅ CHECKLIST FINAL

```powershell
# 1. Testar tudo
flutter test test/features/

# 2. Verificar Cloud Functions
firebase functions:log --limit 10

# 3. Executar app
flutter run -d chrome
```

**Testes manuais:**

1. Login com 2 usuários
2. Dar like mútuo
3. Verificar se match foi criado no Firestore
4. Verificar se notificação foi enviada
5. Abrir filtros e testar mudanças

---

## 📊 TEMPO ESTIMADO

| Tarefa | Tempo |
|--------|-------|
| Corrigir testes | 3 min |
| Cloud Functions | 5 min |
| Match Celebration | 4 min |
| Filtros | 3 min |
| **TOTAL** | **15 min** |

---

## 🐛 TROUBLESHOOTING

**Erro: "phoneNumber" não existe**
→ Remover campo dos testes, ProfileEntity não tem esse campo

**Cloud Functions não executam**
→ Verificar logs: `firebase functions:log`
→ Verificar billing do Firebase

**Confetti não aparece**
→ Verificar se `confetti` package foi instalado

**Filtros não aplicam**
→ Implementar lógica no `discovery_controller.dart` para usar os filtros
