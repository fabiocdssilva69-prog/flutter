# 🎯 Próximos Passos - Implementação de UI

## 📋 Status Atual
✅ **Backend 100% Completo** - Todas as entidades, repositories e controllers funcionando  
⏳ **Frontend 0%** - Precisa implementar telas de Swipe e Chat

---

## 🚀 PASSO 1: Tela de Swipe (2-3 horas)

### 1.1 Criar Widget de Card de Perfil

**Caminho**: `lib/src/features/discovery/presentation/widgets/profile_card.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/profile_entity.dart';

class ProfileCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: profile.avatarUrl != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(profile.avatarUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profile.bio ?? 'Sem descrição',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      profile.location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### 1.2 Criar Tela de Swipe

**Caminho**: `lib/src/features/discovery/presentation/swipe_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../controllers/discovery_controller.dart';
import '../controllers/swipe_controller.dart';
import 'widgets/profile_card.dart';

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen> {
  final CardSwiperController _swiperController = CardSwiperController();

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(discoverProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir'),
        centerTitle: true,
      ),
      body: profilesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erro ao carregar perfis',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (profiles) {
          if (profiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum perfil disponível',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tente aumentar o raio de busca',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Cards de perfil
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CardSwiper(
                  controller: _swiperController,
                  cardsCount: profiles.length,
                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                    return ProfileCard(profile: profiles[index]);
                  },
                  onSwipe: (previousIndex, currentIndex, direction) {
                    final profile = profiles[previousIndex];
                    final liked = direction == CardSwiperDirection.right;

                    // Registrar swipe no backend
                    ref.read(swipeControllerProvider.notifier).swipe(
                          profile.userId,
                          liked,
                        );

                    // Mostrar feedback visual
                    if (liked) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❤️ Você curtiu ${profile.name}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }

                    return true;
                  },
                  isLoop: false,
                  numberOfCardsDisplayed: 2,
                  backCardOffset: const Offset(0, 40),
                  padding: const EdgeInsets.all(24.0),
                  scale: 0.9,
                ),
              ),

              // Botões de ação na parte inferior
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botão de dislike
                    FloatingActionButton(
                      heroTag: 'dislike',
                      onPressed: () => _swiperController.swipe(CardSwiperDirection.left),
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.close, color: Colors.red, size: 32),
                    ),
                    const SizedBox(width: 40),
                    // Botão de like
                    FloatingActionButton(
                      heroTag: 'like',
                      onPressed: () => _swiperController.swipe(CardSwiperDirection.right),
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.favorite, color: Colors.green, size: 32),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

---

### 1.3 Adicionar ao Bottom Navigation

**Caminho**: `lib/src/features/home/presentation/home_screen.dart` (ou onde está sua navegação principal)

```dart
// Adicione esta tela na lista de telas do BottomNavigationBar:

final List<Widget> _screens = [
  const HomeTabScreen(),
  const SwipeScreen(), // ← ADICIONE AQUI
  const MatchesScreen(), // Implementar depois
  const ProfileScreen(),
];

// E adicione o item no BottomNavigationBar:
BottomNavigationBarItem(
  icon: const Icon(Icons.explore),
  label: 'Descobrir',
),
```

---

## 🚀 PASSO 2: Tela de Matches (1-2 horas)

### 2.1 Criar Widget de Match Card

**Caminho**: `lib/src/features/matches/presentation/widgets/match_card.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../data/models/match_entity.dart';
import '../../../../domain/entities/profile_entity.dart';

class MatchCard extends StatelessWidget {
  final MatchEntity match;
  final ProfileEntity otherUserProfile;

  const MatchCard({
    super.key,
    required this.match,
    required this.otherUserProfile,
  });

  @override
  Widget build(BuildContext context) {
    final unreadCount = match.unreadCount[otherUserProfile.userId] ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: otherUserProfile.avatarUrl != null
              ? CachedNetworkImageProvider(otherUserProfile.avatarUrl!)
              : null,
          child: otherUserProfile.avatarUrl == null
              ? Text(otherUserProfile.name[0].toUpperCase())
              : null,
        ),
        title: Text(
          otherUserProfile.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: match.lastMessageAt != null
            ? Text(
                timeago.format(match.lastMessageAt!, locale: 'pt_BR'),
                style: const TextStyle(fontSize: 12),
              )
            : const Text('Novo match!'),
        trailing: unreadCount > 0
            ? Badge(
                label: Text('$unreadCount'),
                child: const Icon(Icons.chat_bubble),
              )
            : const Icon(Icons.chat_bubble_outline),
        onTap: () {
          // Navegar para tela de chat
          Navigator.pushNamed(
            context,
            '/chat',
            arguments: {
              'chatId': match.matchId,
              'otherUser': otherUserProfile,
            },
          );
        },
      ),
    );
  }
}
```

---

### 2.2 Criar Tela de Lista de Matches

**Caminho**: `lib/src/features/matches/presentation/matches_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/match_repository.dart';
import '../../../features/auth/data/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import 'widgets/match_card.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      return const Center(child: Text('Usuário não autenticado'));
    }

    final matchesStream = ref.watch(matchRepositoryProvider).watchUserMatches(currentUser.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          }

          final matches = snapshot.data ?? [];

          if (matches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum match ainda',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Continue dando likes para encontrar matches!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final otherUserId = match.getOtherUserId(currentUser.uid);

              // Buscar perfil do outro usuário
              return FutureBuilder(
                future: ref.read(profileRepositoryProvider).getProfile(otherUserId),
                builder: (context, profileSnapshot) {
                  if (!profileSnapshot.hasData) {
                    return const SizedBox();
                  }

                  final otherUserProfile = profileSnapshot.data!;
                  return MatchCard(
                    match: match,
                    otherUserProfile: otherUserProfile,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## 🚀 PASSO 3: Tela de Chat (2-3 horas)

### 3.1 Criar Widget de Mensagem

**Caminho**: `lib/src/features/chat/presentation/widgets/message_bubble.dart`

```dart
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../data/models/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? Theme.of(context).primaryColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeago.format(message.createdAt, locale: 'pt_BR'),
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### 3.2 Criar Tela de Chat

**Caminho**: `lib/src/features/chat/presentation/chat_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/match_chat_repository.dart';
import '../../../features/auth/data/auth_repository.dart';
import '../../../domain/entities/profile_entity.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final ProfileEntity otherUser;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUser,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    _messageController.clear();

    await ref.read(matchChatRepositoryProvider).sendMessage(
          chatId: widget.chatId,
          senderId: currentUser.uid,
          text: text,
        );

    // Scroll para o final
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado')),
      );
    }

    final messagesStream = ref
        .watch(matchChatRepositoryProvider)
        .watchChatMessages(widget.chatId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.otherUser.avatarUrl != null
                  ? NetworkImage(widget.otherUser.avatarUrl!)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(widget.otherUser.name),
          ],
        ),
      ),
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: StreamBuilder(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma mensagem ainda. Diga oi! 👋'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUser.uid;

                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),

          // Input de mensagem
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📦 DEPENDÊNCIAS NECESSÁRIAS

Adicione no `pubspec.yaml` (se ainda não tiver):

```yaml
dependencies:
  # Já tem
  flutter_card_swiper: ^7.0.2
  cached_network_image: ^3.3.1
  
  # Adicionar se não tiver
  timeago: ^3.6.1  # Para "há 5 minutos", "há 1 hora", etc
```

Execute:
```bash
flutter pub get
```

---

## 🎨 CONFIGURAR TIMEAGO (Português)

**Caminho**: `lib/main.dart`

```dart
import 'package:timeago/timeago.dart' as timeago;

void main() {
  // Configurar timeago para português
  timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  
  runApp(const MyApp());
}
```

---

## 📱 TESTAR O SISTEMA

### 1. Testar Swipe:
1. Abrir app em 2 dispositivos/emuladores diferentes
2. Fazer login com usuários diferentes
3. Swipe right (like) no perfil do outro usuário
4. Fazer o mesmo no outro dispositivo
5. ✅ Deve aparecer match!

### 2. Testar Chat:
1. Após match, abrir tela de Matches
2. Clicar no card do match
3. Enviar mensagem
4. ✅ Mensagem deve aparecer em tempo real no outro dispositivo

---

## 🐛 PROBLEMAS COMUNS

### Erro: "No MaterialLocalizations found"
**Solução**: Adicionar no `MaterialApp`:
```dart
MaterialApp(
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('pt', 'BR'),
  ],
  // ...
)
```

### Erro: "Navigator operation requested with a context that does not include a Navigator"
**Solução**: Usar `Navigator.pushNamed` dentro do `onTap` do MatchCard

### Mensagens não aparecem em tempo real
**Solução**: Verificar se `watchChatMessages` está sendo usado com `StreamBuilder`

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### Swipe Screen
- [ ] Criar `profile_card.dart` widget
- [ ] Criar `swipe_screen.dart`
- [ ] Adicionar ao bottom navigation
- [ ] Testar swipe left/right
- [ ] Testar detecção de match

### Matches Screen
- [ ] Criar `match_card.dart` widget
- [ ] Criar `matches_screen.dart`
- [ ] Adicionar ao bottom navigation
- [ ] Testar navegação para chat

### Chat Screen
- [ ] Criar `message_bubble.dart` widget
- [ ] Criar `chat_screen.dart`
- [ ] Configurar rota `/chat`
- [ ] Testar envio de mensagens
- [ ] Testar recebimento em tempo real

---

## 🚀 DEPOIS DE IMPLEMENTAR

Quando terminar a UI, volte aqui e marque como concluído! Daí partimos para:

1. **Cloud Functions** (detectar match automaticamente)
2. **Push Notifications** (notificar sobre matches e mensagens)
3. **Geolocalização** (filtrar perfis por distância)

**Boa sorte! 🎉**
