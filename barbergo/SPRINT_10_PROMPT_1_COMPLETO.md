# Sprint 10 - Prompt 1/6: Definição do Estado Complexo (ChatState) ✅

## 📋 Objetivo

Criar um objeto de estado dedicado usando **Freezed** para gerenciar a paginação do histórico de chat de forma robusta e escalável.

## 🔄 Mudança Arquitetural

**Sprint 9 (Anterior):**
```dart
@riverpod
class ChatController extends _$ChatController {
  @override
  Stream<List<ChatMessage>> build(String personaKey) {
    return _repo.watchMessages(personaKey); // Observação passiva
  }
}
```

**Sprint 10 (Nova):**
```dart
@riverpod
class ChatController extends _$ChatController {
  @override
  Future<ChatStateData> build(String personaKey) async {
    return ChatStateData.initial(); // Controle imperativo
  }
  
  Future<void> loadMoreMessages() async {
    // Controle explícito sobre paginação
  }
}
```

**Motivo da Mudança:**
- ❌ **StreamNotifier:** Observação passiva → Dificulta controle de paginação
- ✅ **AsyncNotifier:** Controle imperativo → Permite `loadMoreMessages()` sob demanda

---

## 📁 Arquivo Criado

**Caminho:** `lib/src/features/ai/controllers/chat_state.dart`

### Estrutura do Estado

```dart
@freezed
class ChatStateData with _$ChatStateData {
  const ChatStateData._(); // Private constructor para métodos customizados
  
  const factory ChatStateData({
    /// Lista de mensagens carregadas (ordem cronológica)
    required List<ChatMessage> messages,
    
    /// Indica se há mais mensagens antigas no Firestore
    required bool hasMore,
    
    /// Indica se está carregando próxima página
    @Default(false) bool isLoadingMore,
  }) = _ChatStateData;

  /// Factory para estado inicial vazio
  factory ChatStateData.initial() => const ChatStateData(
        messages: [],
        hasMore: true,
        isLoadingMore: false,
      );
}
```

---

## 🎯 Propriedades do Estado

### 1. `List<ChatMessage> messages`

**Descrição:** Lista de mensagens carregadas até o momento.

**Ordem:** Cronológica (mais antiga → mais recente)
- `messages[0]` = Mensagem mais antiga (primeira página carregada)
- `messages[n]` = Mensagem mais recente (última mensagem enviada)

**Exemplo:**
```dart
final state = ChatStateData(
  messages: [
    ChatMessage(id: '1', content: 'Olá!', createdAt: DateTime(2025, 10, 1)),
    ChatMessage(id: '2', content: 'Tudo bem?', createdAt: DateTime(2025, 10, 2)),
    ChatMessage(id: '3', content: 'Sim!', createdAt: DateTime(2025, 10, 3)),
  ],
  hasMore: true,
  isLoadingMore: false,
);

print(state.messages.first.content); // 'Olá!' (mais antiga)
print(state.messages.last.content);  // 'Sim!' (mais recente)
```

---

### 2. `bool hasMore`

**Descrição:** Indica se ainda há mensagens antigas para carregar no Firestore.

**Comportamento:**
- `true` → Há mais mensagens antigas (mostrar "Pull to load more")
- `false` → Todas as mensagens foram carregadas (esconder indicador)

**Lógica de Atualização:**
```dart
// Na primeira carga ou loadMoreMessages():
if (loadedMessages.length < PAGE_SIZE) {
  hasMore = false; // Última página atingida
} else {
  hasMore = true; // Pode haver mais páginas
}
```

**Exemplo de UI:**
```dart
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(chatControllerProvider('business'));
  
  return state.when(
    data: (chatState) => ListView(
      children: [
        if (chatState.hasMore)
          TextButton(
            onPressed: () => ref.read(chatControllerProvider('business').notifier)
                                 .loadMoreMessages(),
            child: Text('Load older messages'),
          ),
        ...chatState.messages.map((msg) => ChatBubble(message: msg)),
      ],
    ),
  );
}
```

---

### 3. `bool isLoadingMore`

**Descrição:** Indica se está atualmente carregando a próxima página de mensagens.

**Finalidade:**
- **Prevenir:** Carregamentos duplicados (evita múltiplos `loadMoreMessages()` simultâneos)
- **UI Feedback:** Mostrar `CircularProgressIndicator` enquanto carrega

**Fluxo:**
```dart
Future<void> loadMoreMessages() async {
  if (!state.value.hasMore || state.value.isLoadingMore) return;
  
  // 1. Marca como carregando
  state = AsyncValue.data(state.value.copyWith(isLoadingMore: true));
  
  // 2. Busca mensagens antigas no Firestore
  final olderMessages = await _repo.loadMoreMessages(_personaKey, lastMessageId);
  
  // 3. Atualiza estado com novas mensagens
  state = AsyncValue.data(ChatStateData(
    messages: [...olderMessages, ...state.value.messages],
    hasMore: olderMessages.length >= PAGE_SIZE,
    isLoadingMore: false, // Remove indicador de loading
  ));
}
```

**Exemplo de UI:**
```dart
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(chatControllerProvider('business'));
  
  return state.when(
    data: (chatState) => ListView(
      children: [
        if (chatState.isLoadingMore)
          Center(child: CircularProgressIndicator()),
        else if (chatState.hasMore)
          TextButton(
            onPressed: () => ref.read(chatControllerProvider('business').notifier)
                                 .loadMoreMessages(),
            child: Text('Load older messages'),
          ),
        ...chatState.messages.map((msg) => ChatBubble(message: msg)),
      ],
    ),
  );
}
```

---

## 🏗️ Factory Method: `ChatStateData.initial()`

**Descrição:** Cria o estado inicial vazio quando o chat é aberto pela primeira vez.

**Valores Padrão:**
```dart
factory ChatStateData.initial() => const ChatStateData(
  messages: [],      // Nenhuma mensagem carregada
  hasMore: true,     // Assume que pode haver mensagens (evita chamada desnecessária)
  isLoadingMore: false, // Não está carregando
);
```

**Uso no Controller:**
```dart
@riverpod
class ChatController extends _$ChatController {
  @override
  Future<ChatStateData> build(String personaKey) async {
    _personaKey = personaKey;
    
    // 1. Retorna estado inicial vazio
    final initialState = ChatStateData.initial();
    
    // 2. Carrega primeira página em background
    final firstPage = await _repo.loadInitialMessages(_personaKey, PAGE_SIZE);
    
    // 3. Atualiza com dados reais
    return ChatStateData(
      messages: firstPage,
      hasMore: firstPage.length >= PAGE_SIZE,
      isLoadingMore: false,
    );
  }
}
```

---

## 📊 Diagrama de Estados

```
┌─────────────────────────────────────────────────────────┐
│                   ChatStateData                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Estado 1: Inicial (Empty)                              │
│  ┌────────────────────────────────────────────┐         │
│  │ messages: []                               │         │
│  │ hasMore: true                              │         │
│  │ isLoadingMore: false                       │         │
│  └────────────────────────────────────────────┘         │
│           ↓ loadInitialMessages()                       │
│                                                          │
│  Estado 2: Primeira Página Carregada                    │
│  ┌────────────────────────────────────────────┐         │
│  │ messages: [msg1, msg2, ..., msg20]         │         │
│  │ hasMore: true (20 msgs = PAGE_SIZE)        │         │
│  │ isLoadingMore: false                       │         │
│  └────────────────────────────────────────────┘         │
│           ↓ loadMoreMessages()                          │
│                                                          │
│  Estado 3: Carregando Mais (Loading)                    │
│  ┌────────────────────────────────────────────┐         │
│  │ messages: [msg1, msg2, ..., msg20]         │         │
│  │ hasMore: true                              │         │
│  │ isLoadingMore: true ← UI: Spinner          │         │
│  └────────────────────────────────────────────┘         │
│           ↓ mensagens antigas carregadas                │
│                                                          │
│  Estado 4: Segunda Página Carregada                     │
│  ┌────────────────────────────────────────────┐         │
│  │ messages: [msg-19, ..., msg1, ..., msg20]  │         │
│  │           ↑ antigas     ↑ recentes         │         │
│  │ hasMore: true (20 msgs = PAGE_SIZE)        │         │
│  │ isLoadingMore: false                       │         │
│  └────────────────────────────────────────────┘         │
│           ↓ loadMoreMessages() (novamente)              │
│                                                          │
│  Estado 5: Última Página (No More)                      │
│  ┌────────────────────────────────────────────┐         │
│  │ messages: [msg-39, ..., msg1, ..., msg20]  │         │
│  │ hasMore: false ← UI: Esconde "Load More"  │         │
│  │ isLoadingMore: false                       │         │
│  └────────────────────────────────────────────┘         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## ✅ Build e Validação

### Comandos Executados

```powershell
# Limpeza de cache
dart run build_runner clean

# Geração de código Freezed
dart run build_runner build --delete-conflicting-outputs
```

### Resultado do Build

```
✅ Build: 42s
✅ Outputs: 85 arquivos gerados
✅ Freezed: 1 novo arquivo (.freezed.dart)
✅ Erros de compilação: 0 (após rebuild completo)
```

### Arquivos Gerados

```
lib/src/features/ai/controllers/
├── chat_state.dart              ← Criado manualmente
└── chat_state.freezed.dart      ← Gerado automaticamente (Freezed)
```

---

## 🔍 Comparativo: Antes vs Depois

### **Antes (Sprint 9 - StreamNotifier)**

```dart
// Estado: Stream<List<ChatMessage>>
@override
Stream<List<ChatMessage>> build(String personaKey) {
  return _repo.watchMessages(personaKey); // Firestore stream completo
}

// Problema: Como implementar paginação?
// - Stream traz TODAS as mensagens de uma vez
// - Não há controle sobre quantas mensagens carregar
// - Performance ruim com históricos grandes (>100 mensagens)
```

**Limitações:**
- ❌ Sem controle sobre quantidade de mensagens carregadas
- ❌ Impossível implementar "Load More" sob demanda
- ❌ Performance degrada com históricos grandes
- ❌ Não há indicador de "carregando mais"

---

### **Depois (Sprint 10 - AsyncNotifier + ChatStateData)**

```dart
// Estado: ChatStateData (messages + hasMore + isLoadingMore)
@override
Future<ChatStateData> build(String personaKey) async {
  final firstPage = await _repo.loadInitialMessages(personaKey, 20);
  return ChatStateData(
    messages: firstPage,
    hasMore: firstPage.length >= 20,
    isLoadingMore: false,
  );
}

// Método imperativo para paginação
Future<void> loadMoreMessages() async {
  if (!state.value.hasMore || state.value.isLoadingMore) return;
  
  state = AsyncValue.data(state.value.copyWith(isLoadingMore: true));
  
  final olderMessages = await _repo.loadMoreMessages(
    _personaKey, 
    state.value.messages.first.id, // lastMessageId
    20, // PAGE_SIZE
  );
  
  state = AsyncValue.data(ChatStateData(
    messages: [...olderMessages, ...state.value.messages],
    hasMore: olderMessages.length >= 20,
    isLoadingMore: false,
  ));
}
```

**Vantagens:**
- ✅ Controle completo sobre quantidade de mensagens
- ✅ Paginação sob demanda (load more quando necessário)
- ✅ Performance otimizada (carrega apenas 20 mensagens por vez)
- ✅ Indicadores de estado (`isLoadingMore`, `hasMore`)
- ✅ Suporta históricos grandes (milhares de mensagens)

---

## 🚀 Próximos Passos

**Prompt 2/6:** Refatorar `ChatRepository` para suportar paginação com Firestore queries (`startAfterDocument`, `limit`).

**Mudanças Necessárias:**
1. Substituir `watchMessages()` por `loadInitialMessages()` e `loadMoreMessages()`
2. Implementar query com `limit(PAGE_SIZE)`
3. Adicionar suporte a `startAfterDocument()` para paginação
4. Remover Stream (não mais necessário)

**Arquivo a Modificar:** `lib/src/data/repositories/chat_repository.dart`

---

## 📝 Resumo

✅ **ChatStateData criado** com Freezed (42s build)  
✅ **3 propriedades:** `messages`, `hasMore`, `isLoadingMore`  
✅ **Factory method:** `ChatStateData.initial()`  
✅ **Private constructor:** Permite métodos customizados no futuro  
✅ **Documentação completa:** Cada propriedade explicada com exemplos  
✅ **Zero erros de compilação** após rebuild completo  

**Status:** ✅ **PROMPT 1/6 COMPLETO** → Pronto para Prompt 2 (ChatRepository)
