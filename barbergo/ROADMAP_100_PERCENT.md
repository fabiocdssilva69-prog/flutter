# 🚀 ROADMAP: Completar BarberGO para 100%

> **Data de Início:** 4 de Novembro de 2025
> **Status Atual:** 70% completo
> **Meta:** 100% MVP funcional e polido

---

## 🎯 VISÃO GERAL

### O que já funciona ✅
- Firebase (Auth, Firestore, Analytics, FCM, Storage)
- Sistema de Discovery (4 perfis carregando)
- Autenticação completa
- Sistema de Perfis
- Navegação (GoRouter)
- Geolocalização
- Notificações Push (token gerado)

### O que vamos completar 🚧
- Chat System (Inbox + Messages)
- Match Celebration
- Portfólio de Fotos
- Filtros Avançados
- Sistema de Reviews
- Analytics customizado
- UI/UX Polish
- Settings & Privacy

---

## 📋 FASES DE DESENVOLVIMENTO

### 🎯 FASE 1: CHAT SYSTEM COMPLETO (8-12h)
**Prioridade:** 🔴 CRÍTICA  
**Status:** 🚧 NÃO INICIADO

#### 1.1 Inbox Screen (Lista de Conversas)
**Arquivo:** `lib/src/features/chat/screens/inbox_screen.dart`

**Funcionalidades:**
- [ ] Lista de conversas ordenadas por última mensagem
- [ ] Badge de mensagens não lidas
- [ ] Preview da última mensagem
- [ ] Avatar + nome do outro usuário
- [ ] Pull-to-refresh
- [ ] Swipe para deletar conversa
- [ ] Empty state: "Nenhuma conversa ainda"

**Widgets necessários:**
```dart
// lib/src/features/chat/widgets/conversation_tile.dart
class ConversationTile extends StatelessWidget {
  final ChatRoomEntity room;
  final int unreadCount;
  final VoidCallback onTap;
  final VoidCallback onDelete;
}

// lib/src/features/chat/widgets/inbox_empty_state.dart
class InboxEmptyState extends StatelessWidget {
  // "Comece a conversar com seus matches!"
}
```

**Controller:**
```dart
// Já existe: chatRoomRepository.watchMyRooms(userId)
// Adicionar: markAsRead(roomId)
```

---

#### 1.2 Chat Screen (Mensagens)
**Arquivo:** `lib/src/features/chat/screens/chat_screen.dart`

**Funcionalidades:**
- [ ] Lista de mensagens (paginação reversa)
- [ ] Input de texto com botão enviar
- [ ] Envio de imagens (câmera + galeria)
- [ ] Indicador "digitando..." (Firestore presence)
- [ ] Marcação de lidas/não lidas
- [ ] Timestamp das mensagens
- [ ] Animação de scroll para nova mensagem
- [ ] AppBar com avatar + nome clicável (abre ProfileDetailScreen)

**Widgets necessários:**
```dart
// lib/src/features/chat/widgets/message_bubble.dart
class MessageBubble extends StatelessWidget {
  final DirectMessageEntity message;
  final bool isMine;
  final bool showTimestamp;
}

// lib/src/features/chat/widgets/chat_input.dart
class ChatInput extends StatefulWidget {
  final Function(String text) onSendText;
  final Function(String imagePath) onSendImage;
}

// lib/src/features/chat/widgets/typing_indicator.dart
class TypingIndicator extends StatelessWidget {
  // Animação de 3 pontinhos
}
```

**Novo Repository Method:**
```dart
// lib/src/data/repositories/chat_room_repository.dart

// Adicionar método de presença
Future<void> setTypingStatus(String roomId, String userId, bool isTyping) async {
  await _service.db
    .collection('chat_rooms')
    .doc(roomId)
    .update({
      'typing_$userId': isTyping,
      'typing_at_$userId': FieldValue.serverTimestamp(),
    });
}

Stream<bool> watchTypingStatus(String roomId, String otherUserId) {
  return _service.db
    .collection('chat_rooms')
    .doc(roomId)
    .snapshots()
    .map((snapshot) {
      if (!snapshot.exists) return false;
      final data = snapshot.data()!;
      final isTyping = data['typing_$otherUserId'] as bool? ?? false;
      
      // Se passou mais de 3 segundos, considera que não está mais digitando
      final typingAt = data['typing_at_$otherUserId'] as Timestamp?;
      if (typingAt != null) {
        final diff = DateTime.now().difference(typingAt.toDate());
        if (diff.inSeconds > 3) return false;
      }
      
      return isTyping;
    });
}
```

---

#### 1.3 Notificações de Chat
**Arquivo:** `lib/src/core/services/notification_service.dart`

**Adicionar:**
- [ ] Handler para FCM data messages (tipo: 'chat')
- [ ] Navigation para ChatScreen ao clicar na notificação
- [ ] Badge count no ícone do app (Android)

**Implementação:**
```dart
// No notification_service.dart

Future<void> handleNotificationTap(RemoteMessage message) async {
  final type = message.data['type'];
  
  if (type == 'chat') {
    final roomId = message.data['roomId'];
    final otherUserId = message.data['otherUserId'];
    
    // Navegar para ChatScreen
    // (Precisa de NavigatorKey global)
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go('/chat/$roomId', extra: otherUserId);
    }
  }
}
```

---

### 💘 FASE 2: MATCH CELEBRATION SCREEN (4-6h)
**Prioridade:** 🔴 CRÍTICA  
**Status:** 🚧 NÃO INICIADO

#### 2.1 Match Screen Animada
**Arquivo:** `lib/src/features/matches/screens/match_celebration_screen.dart`

**Funcionalidades:**
- [ ] Animação de entrada (fade + scale)
- [ ] Exibição dos 2 avatares lado a lado
- [ ] Texto: "É um Match!" com animação
- [ ] Botão "Enviar Mensagem" (abre chat)
- [ ] Botão "Continuar Buscando"
- [ ] Confetes/sparkles animados (package: confetti)

**Packages:**
```yaml
dependencies:
  confetti: ^0.7.0
  lottie: ^3.0.0 # Para animações JSON
```

**Exemplo de código:**
```dart
class MatchCelebrationScreen extends StatefulWidget {
  final ProfileEntity currentUser;
  final ProfileEntity matchedUser;

  @override
  _MatchCelebrationScreenState createState() => _MatchCelebrationScreenState();
}

class _MatchCelebrationScreenState extends State<MatchCelebrationScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    
    _controller.forward();
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade900, Colors.pink.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: [Colors.yellow, Colors.orange, Colors.pink, Colors.purple],
            ),
          ),
          
          // Content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatares sobrepostos
                  _buildOverlappingAvatars(),
                  
                  SizedBox(height: 32),
                  
                  // Texto "É um Match!"
                  Text(
                    'É um Match!',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  Text(
                    'Você e ${widget.matchedUser.name} curtiram um ao outro!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  
                  SizedBox(height: 48),
                  
                  // Botões
                  ElevatedButton.icon(
                    onPressed: _onSendMessage,
                    icon: Icon(Icons.chat_bubble),
                    label: Text('Enviar Mensagem'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple.shade900,
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Continuar Buscando',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOverlappingAvatars() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Avatar esquerdo
        Positioned(
          left: 0,
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(widget.currentUser.photos.first),
          ),
        ),
        // Avatar direito
        Positioned(
          right: 0,
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(widget.matchedUser.photos.first),
          ),
        ),
        // Coração no meio
        Icon(
          Icons.favorite,
          color: Colors.red,
          size: 48,
        ),
      ],
    );
  }
  
  void _onSendMessage() async {
    // Criar/buscar sala de chat
    final chatRepo = ref.read(chatRoomRepositoryProvider);
    final roomId = await chatRepo.createRoom(/* ... */);
    
    // Navegar para chat
    context.go('/chat/$roomId', extra: widget.matchedUser);
  }
}
```

---

### 📸 FASE 3: PORTFÓLIO DE FOTOS COMPLETO (6-8h)
**Prioridade:** 🟡 ALTA  
**Status:** 🚧 NÃO INICIADO

#### 3.1 Photo Manager Widget
**Arquivo:** `lib/src/features/profile/widgets/photo_manager.dart`

**Funcionalidades:**
- [ ] Grid de fotos (até 6 fotos)
- [ ] Botão "+" para adicionar foto
- [ ] Seleção múltipla (câmera ou galeria)
- [ ] Preview antes de enviar
- [ ] Compressão de imagens (package: flutter_image_compress)
- [ ] Reordenação drag-and-drop (package: reorderable_grid_view)
- [ ] Botão X para deletar foto
- [ ] Indicador de foto principal (primeira posição)

**Packages:**
```yaml
dependencies:
  image_picker: ^1.0.0
  flutter_image_compress: ^2.0.0
  reorderable_grid_view: ^2.0.0
  cached_network_image: ^3.3.0
```

**Implementação:**
```dart
class PhotoManager extends ConsumerStatefulWidget {
  final List<String> currentPhotos;
  final Function(List<String>) onPhotosChanged;
  
  @override
  _PhotoManagerState createState() => _PhotoManagerState();
}

class _PhotoManagerState extends ConsumerState<PhotoManager> {
  List<String> _photos = [];
  bool _isUploading = false;
  
  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.currentPhotos);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Fotos do Portfólio (${_photos.length}/6)', style: TextStyle(fontSize: 16)),
        SizedBox(height: 16),
        
        ReorderableGridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _photos.length + (_photos.length < 6 ? 1 : 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            if (index == _photos.length) {
              return _buildAddPhotoButton();
            }
            return _buildPhotoTile(_photos[index], index);
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final photo = _photos.removeAt(oldIndex);
              _photos.insert(newIndex, photo);
              widget.onPhotosChanged(_photos);
            });
          },
        ),
        
        if (_isUploading)
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
  
  Widget _buildPhotoTile(String photoUrl, int index) {
    return Stack(
      key: ValueKey(photoUrl),
      children: [
        // Foto
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          ),
        ),
        
        // Badge "Principal" na primeira foto
        if (index == 0)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('Principal', style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ),
        
        // Botão deletar
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _deletePhoto(index),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAddPhotoButton() {
    return GestureDetector(
      key: ValueKey('add_button'),
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
        child: Icon(Icons.add_a_photo, color: Colors.grey.shade600, size: 32),
      ),
    );
  }
  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    
    if (pickedFiles.isEmpty) return;
    
    setState(() => _isUploading = true);
    
    for (final file in pickedFiles) {
      if (_photos.length >= 6) break;
      
      // Comprimir imagem
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        '${file.path}_compressed.jpg',
        quality: 85,
      );
      
      if (compressedFile == null) continue;
      
      // Upload para Firebase Storage
      final storage = FirebaseStorage.instance;
      final userId = ref.read(authRepositoryProvider).currentUser!.uid;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = storage.ref().child('portfolio/$userId/$fileName');
      
      await ref.putFile(File(compressedFile.path));
      final downloadUrl = await ref.getDownloadURL();
      
      setState(() {
        _photos.add(downloadUrl);
      });
    }
    
    setState(() => _isUploading = false);
    widget.onPhotosChanged(_photos);
  }
  
  void _deletePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
      widget.onPhotosChanged(_photos);
    });
  }
}
```

---

### 🔍 FASE 4: FILTROS AVANÇADOS (8-10h)
**Prioridade:** 🟡 ALTA  
**Status:** 🚧 NÃO INICIADO

#### 4.1 Filter Screen
**Arquivo:** `lib/src/features/filters/screens/filter_screen.dart`

**Funcionalidades:**
- [ ] Slider de distância (5-100 km)
- [ ] Range slider de preço (R$ 20 - R$ 500)
- [ ] Dropdown de experiência mínima (0-10+ anos)
- [ ] Multi-select de serviços (corte, barba, design, etc)
- [ ] Toggle "Apenas Premium"
- [ ] Botão "Limpar Filtros"
- [ ] Botão "Aplicar" (salva no Firestore)

**Exemplo:**
```dart
class FilterScreen extends ConsumerStatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  double _maxDistance = 25;
  RangeValues _priceRange = RangeValues(20, 200);
  int _minExperience = 0;
  Set<String> _selectedServices = {};
  bool _premiumOnly = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtros'),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: Text('Limpar'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Distância
          Text('Distância Máxima: ${_maxDistance.round()} km'),
          Slider(
            value: _maxDistance,
            min: 5,
            max: 100,
            divisions: 19,
            onChanged: (value) => setState(() => _maxDistance = value),
          ),
          
          Divider(),
          
          // Preço
          Text('Faixa de Preço: R\$ ${_priceRange.start.round()} - R\$ ${_priceRange.end.round()}'),
          RangeSlider(
            values: _priceRange,
            min: 20,
            max: 500,
            divisions: 48,
            onChanged: (values) => setState(() => _priceRange = values),
          ),
          
          Divider(),
          
          // Experiência
          Text('Experiência Mínima'),
          DropdownButton<int>(
            value: _minExperience,
            isExpanded: true,
            items: [
              DropdownMenuItem(value: 0, child: Text('Qualquer')),
              DropdownMenuItem(value: 1, child: Text('1+ anos')),
              DropdownMenuItem(value: 3, child: Text('3+ anos')),
              DropdownMenuItem(value: 5, child: Text('5+ anos')),
              DropdownMenuItem(value: 10, child: Text('10+ anos')),
            ],
            onChanged: (value) => setState(() => _minExperience = value!),
          ),
          
          Divider(),
          
          // Serviços
          Text('Serviços', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Corte', 'Barba', 'Design', 'Coloração', 'Hidratação']
                .map((service) => FilterChip(
                      label: Text(service),
                      selected: _selectedServices.contains(service),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedServices.add(service);
                          } else {
                            _selectedServices.remove(service);
                          }
                        });
                      },
                    ))
                .toList(),
          ),
          
          Divider(),
          
          // Premium
          SwitchListTile(
            title: Text('Apenas Premium'),
            subtitle: Text('Mostrar apenas usuários premium'),
            value: _premiumOnly,
            onChanged: (value) => setState(() => _premiumOnly = value),
          ),
          
          SizedBox(height: 32),
          
          // Botão Aplicar
          ElevatedButton(
            onPressed: _applyFilters,
            child: Text('Aplicar Filtros'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
  
  void _applyFilters() {
    final filters = FilterPreferences(
      maxDistance: _maxDistance,
      minPrice: _priceRange.start.round(),
      maxPrice: _priceRange.end.round(),
      minExperience: _minExperience,
      services: _selectedServices.toList(),
      premiumOnly: _premiumOnly,
    );
    
    // Salvar no Firestore
    ref.read(filterControllerProvider.notifier).saveFilters(filters);
    
    Navigator.pop(context);
  }
  
  void _clearFilters() {
    setState(() {
      _maxDistance = 25;
      _priceRange = RangeValues(20, 200);
      _minExperience = 0;
      _selectedServices.clear();
      _premiumOnly = false;
    });
  }
}
```

---

### ⭐ FASE 5: SISTEMA DE REVIEWS (10-12h)
**Prioridade:** 🟡 MÉDIA  
**Status:** 🚧 NÃO INICIADO

#### 5.1 Review Entity
**Arquivo:** `lib/src/domain/entities/review_entity.dart`

```dart
import 'package:dart_mappable/dart_mappable.dart';
import '../../../core/utils/mappable_hooks.dart';

part 'review_entity.mapper.dart';

@MappableClass()
class ReviewEntity with ReviewEntityMappable {
  final String reviewId;
  final String reviewerId; // Quem deixou o review
  final String reviewerName;
  final String reviewerPhoto;
  final String reviewedUserId; // Quem recebeu o review
  final double rating; // 1.0 - 5.0
  final String? comment;
  @TimestampHook()
  final DateTime createdAt;
  
  ReviewEntity({
    required this.reviewId,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerPhoto,
    required this.reviewedUserId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
```

#### 5.2 Review Repository
**Arquivo:** `lib/src/data/repositories/review_repository.dart`

```dart
@riverpod
ReviewRepository reviewRepository(Ref ref) {
  return ReviewRepository(service: ref.watch(firestoreServiceProvider));
}

class ReviewRepository {
  final FirestoreService _service;
  ReviewRepository({required FirestoreService service}) : _service = service;
  
  static const String reviewsPath = 'reviews';
  
  // Criar review
  Future<void> createReview(ReviewEntity review) async {
    final docRef = _service.db.collection(reviewsPath).doc();
    final reviewWithId = review.copyWith(reviewId: docRef.id);
    await docRef.set(reviewWithId.toMap());
    
    // Atualizar média de rating no perfil
    await _updateProfileRating(review.reviewedUserId);
  }
  
  // Buscar reviews de um usuário
  Stream<List<ReviewEntity>> watchUserReviews(String userId) {
    return _service.db
        .collection(reviewsPath)
        .where('reviewedUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewEntity.fromMap(doc.data()))
            .toList());
  }
  
  // Calcular e atualizar rating médio
  Future<void> _updateProfileRating(String userId) async {
    final snapshot = await _service.db
        .collection(reviewsPath)
        .where('reviewedUserId', isEqualTo: userId)
        .get();
    
    if (snapshot.docs.isEmpty) return;
    
    final ratings = snapshot.docs.map((doc) => doc.data()['rating'] as double).toList();
    final average = ratings.reduce((a, b) => a + b) / ratings.length;
    final count = ratings.length;
    
    await _service.db.collection('profiles').doc(userId).update({
      'averageRating': average,
      'reviewCount': count,
    });
  }
}
```

#### 5.3 Leave Review Screen
**Arquivo:** `lib/src/features/reviews/screens/leave_review_screen.dart`

**Funcionalidades:**
- [ ] Rating stars (1-5)
- [ ] TextArea para comentário (opcional)
- [ ] Botão "Enviar Avaliação"
- [ ] Validação (rating obrigatório)

---

### 📊 FASE 6: ANALYTICS & MONITORING (4-6h)
**Prioridade:** 🟢 BAIXA  
**Status:** 🚧 NÃO INICIADO

#### 6.1 Custom Analytics Events
**Arquivo:** `lib/src/core/services/analytics_service.dart`

**Eventos a adicionar:**
```dart
// Discovery Events
Future<void> logProfileViewed(String profileId) async {
  await _analytics.logEvent(
    name: 'profile_viewed',
    parameters: {'profile_id': profileId},
  );
}

Future<void> logSwipeRight(String profileId) async {
  await _analytics.logEvent(
    name: 'swipe_right',
    parameters: {'profile_id': profileId},
  );
}

Future<void> logSwipeLeft(String profileId) async {
  await _analytics.logEvent(
    name: 'swipe_left',
    parameters: {'profile_id': profileId},
  );
}

// Match Events
Future<void> logMatchCreated(String matchId, String otherUserId) async {
  await _analytics.logEvent(
    name: 'match_created',
    parameters: {
      'match_id': matchId,
      'other_user_id': otherUserId,
    },
  );
}

// Chat Events
Future<void> logMessageSent(String chatId, String messageType) async {
  await _analytics.logEvent(
    name: 'message_sent',
    parameters: {
      'chat_id': chatId,
      'message_type': messageType, // 'text' | 'image'
    },
  );
}

// Booking Events (futuro)
Future<void> logBookingCreated(String bookingId) async {
  await _analytics.logEvent(
    name: 'booking_created',
    parameters: {'booking_id': bookingId},
  );
}
```

#### 6.2 Crashlytics Custom Logs
**Adicionar em lugares críticos:**
```dart
try {
  // Operação crítica
} catch (e, stackTrace) {
  FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Failed to load profiles');
  // Mostrar erro ao usuário
}
```

---

### 🎨 FASE 7: UX/UI POLISH (8-10h)
**Prioridade:** 🟡 ALTA  
**Status:** 🚧 NÃO INICIADO

#### 7.1 Loading States (Shimmer)
**Package:** `shimmer: ^3.0.0`

**Exemplo:**
```dart
// lib/src/core/widgets/profile_card_shimmer.dart
class ProfileCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(height: 400, color: Colors.white),
            SizedBox(height: 16),
            Container(height: 20, width: 200, color: Colors.white),
            SizedBox(height: 8),
            Container(height: 16, width: 150, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
```

#### 7.2 Empty States
**Arquivo:** `lib/src/core/widgets/empty_state.dart`

```dart
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          if (onAction != null) ...[
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel ?? 'Ação'),
            ),
          ],
        ],
      ),
    );
  }
}

// Uso:
EmptyState(
  icon: Icons.chat_bubble_outline,
  title: 'Nenhuma conversa',
  message: 'Comece a conversar com seus matches!',
  onAction: () => context.go('/discovery'),
  actionLabel: 'Buscar Matches',
)
```

#### 7.3 Hero Animations
**Adicionar em transições de tela:**
```dart
// Na lista de perfis
Hero(
  tag: 'profile_${profile.userId}',
  child: CircleAvatar(backgroundImage: NetworkImage(profile.photos.first)),
)

// Na tela de detalhes
Hero(
  tag: 'profile_${profile.userId}',
  child: Image.network(profile.photos.first),
)
```

---

### ⚙️ FASE 8: SETTINGS & PRIVACY (6-8h)
**Prioridade:** 🟢 BAIXA  
**Status:** 🚧 NÃO INICIADO

#### 8.1 Settings Screen
**Arquivo:** `lib/src/features/settings/screens/settings_screen.dart`

**Funcionalidades:**
- [ ] Notificações (toggle on/off)
- [ ] Privacidade (mostrar perfil em buscas)
- [ ] Bloqueio de usuários
- [ ] Denúncias/Reports
- [ ] Política de privacidade (webview)
- [ ] Termos de uso (webview)
- [ ] Exclusão de conta
- [ ] Logout

---

## 📆 CRONOGRAMA SUGERIDO

### Semana 1 (40h)
- **Dia 1-2:** FASE 1 - Chat System (12h)
- **Dia 3:** FASE 2 - Match Screen (6h)
- **Dia 4-5:** FASE 3 - Portfólio Fotos (8h)
- **Dia 5:** FASE 6 - Analytics (4h)
- **Weekend:** FASE 7 - UI Polish (10h)

### Semana 2 (32h)
- **Dia 1-2:** FASE 4 - Filtros (10h)
- **Dia 3-4:** FASE 5 - Reviews (12h)
- **Dia 5:** FASE 8 - Settings (6h)
- **Weekend:** Testes finais + Bug fixes (4h)

**Total:** ~72h de desenvolvimento

---

## ✅ CHECKLIST FINAL

### Antes de considerar 100%:
- [ ] Todos os fluxos críticos testados (login → discovery → match → chat)
- [ ] Notificações push funcionando
- [ ] Upload de fotos funcionando
- [ ] Filtros salvando e aplicando
- [ ] Reviews sendo criados e exibidos
- [ ] Analytics logando eventos
- [ ] Tratamento de erros em todas as telas
- [ ] Loading states em todas as operações assíncronas
- [ ] Empty states em todas as listas
- [ ] Remove debug routes (`/debug/seed`)
- [ ] Configurar ambientes (dev/prod)
- [ ] Testar em dispositivos reais (Android + iOS)

---

## 🚀 PRÓXIMAS ETAPAS (Pós-100%)

### Para v2.0:
- Sistema de Agendamento (reativar de `_inactive/`)
- Integração de Pagamentos (Stripe/Google/Apple)
- Tela de Upgrade Premium
- Deep Links / Dynamic Links
- Sistema de Referral
- Gamificação (badges, achievements)

---

> **Última Atualização:** 4 de Novembro de 2025
> **Mantido por:** Dev Team BarberGO
