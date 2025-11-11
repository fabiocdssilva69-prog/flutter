# 🚀 PLANO DE IMPLEMENTAÇÃO COMPLETO - BarberGO

**Status**: Fase de Desenvolvimento Massivo (Pintura e Sombreamento)
**Última Atualização**: $(Get-Date)

## 📋 ÍNDICE RÁPIDO

1. [Features Já Funcionando](#features-funcionando) ✅
2. [Features com Placeholder](#features-placeholder) ⚠️
3. [Features Não Conectadas](#features-desconectadas) ❌
4. [Bugs de Build](#bugs-build) 🐛
5. [Plano de Execução](#plano-execucao) 🎯

---

## ✅ FEATURES JÁ FUNCIONANDO

### 1. **Autenticação Firebase**
- ✅ Login/SignUp com email/password
- ✅ Google Sign-In
- ✅ Recuperação de senha
- ✅ AuthController completo
- ✅ Estado reativo com Riverpod

### 2. **Perfil Real-Time**
- ✅ ProfileTab no HomeScreen com dados do Firestore
- ✅ Avatar, nome, localização, matches count
- ✅ Stream de currentUserProfileProvider
- ✅ Loading/Error states

### 3. **Chat Real-Time**
- ✅ conversation_screen.dart com Firestore streams
- ✅ MessageController funcionando
- ✅ Envio/recebimento de mensagens
- ✅ Auto-scroll
- ✅ Detecção de sender

### 4. **Upload de Fotos**
- ✅ photos_screen.dart com MediaController
- ✅ ImagePicker integrado
- ✅ Upload para Firebase Storage
- ✅ Delete de fotos
- ✅ Grid com portfolioUrls

### 5. **Sistema de Rotas**
- ✅ go_router configurado
- ✅ Splash screen
- ✅ Tutorial screen
- ✅ Onboarding flow
- ✅ Auth redirects
- ✅ Error handling

### 6. **Componentes UI Reutilizáveis**
- ✅ BottomNavBar
- ✅ Avatar widget
- ✅ EmptyState
- ✅ ShimmerLoading
- ✅ ProfileCardShimmer
- ✅ FeatureCard

---

## ⚠️ FEATURES COM PLACEHOLDER (Precisam Implementação)

### 1. **Discovery/Swipe**
```dart
// lib/src/features/discovery/presentation/swipe_screen.dart
- ❌ Widget só tem Scaffold vazio
- ✅ SwipeController JÁ EXISTE (lógica pronta)
- ⚠️ FALTA: UI dos cards, AnimatedContainer, gestos, botões
```

**O que fazer:**
- Criar SwipeCard widget com Stack/Positioned
- Adicionar GestureDetector para drag
- AnimatedBuilder para rotação/escala
- Botões: like (💚), dislike (❌), super like (⭐)
- ProfileCard com foto, nome, idade, bio
- Indicator de cards restantes

### 2. **Matches Screen**
```dart
// lib/src/features/matches/presentation/matches_screen.dart
- ❌ Só tem Grid vazio
- ✅ matchesProvider JÁ EXISTE
- ⚠️ FALTA: UI da lista, avatares, last message, timestamp
```

**O que fazer:**
- ListView.builder com matchesProvider stream
- Match card: avatar + nome + última mensagem + hora
- Tap → abre ChatScreen
- Pull-to-refresh
- Empty state quando sem matches

### 3. **Notificações**
```dart
// lib/src/features/notifications/screens/notification_inbox_screen.dart
- ❌ Placeholder
- ❌ NotificationController não conectado
- ⚠️ FALTA: Lista de notificações, mark as read, tipos diferentes
```

**O que fazer:**
- Criar UI com diferentes tipos: match, message, like, super_like
- Mark as read ao tocar
- Badge count no ícone
- Navegação para tela relevante (chat, profile)

### 4. **Profile Detail Screen**
```dart
// lib/src/features/profile/screens/profile_detail_screen.dart
- ❌ Tela de visualização de outros perfis
- ⚠️ FALTA: Hero animation, galeria de fotos, botões de ação
```

**O que fazer:**
- Hero animation da foto principal
- PageView para galeria de fotos
- Botões: like, dislike, super like, denunciar
- Bio completa, interesses, trabalhos
- Scroll parallax no header

### 5. **Edit Profile Screen**
```dart
// lib/src/features/profile/screens/edit_profile_screen.dart
- ❌ Formulário de edição
- ⚠️ FALTA: Form com campos, validação, save button
```

**O que fazer:**
- TextFormFields: nome, bio, idade, localização
- MultiSelect para interesses
- Upload de novas fotos
- Reordenar fotos (drag & drop)
- Botão salvar com loading

---

## ❌ FEATURES NÃO CONECTADAS (Controller existe, UI faltando)

### 1. **Subscription/Monetização**
- ✅ SubscriptionController existe
- ✅ PurchaseController existe
- ✅ MonetizationController existe
- ❌ subscription_screen.dart não conectado

**Implementar:**
- Tela com cards de planos (Free, Plus, Premium)
- Botões de compra chamando subscriptionController.purchasePlan()
- Listagem de features por plano
- Botão "Restaurar compras"
- Status atual da assinatura

### 2. **Date Ideas (IA Recommendations)**
- ✅ DateIdeasController existe
- ❌ Nenhuma tela usando

**Implementar:**
- date_ideas_screen.dart
- Lista de sugestões de dates
- Filtros: tipo, preço, distância
- Botão "Sugerir com IA"
- Integração com Perplexity Comet API

### 3. **Compatibility Quiz**
- ✅ CompatibilityQuizController existe
- ❌ compatibility_quiz_screen.dart vazio

**Implementar:**
- Perguntas do quiz com opções múltiplas
- Progress bar
- Submit → calcular score
- Tela de resultados com %
- Salvar respostas no Firestore

### 4. **Store Locator (Google Maps)**
- ✅ StoreLocatorController existe
- ✅ O2OMapController existe
- ❌ store_locator_screen.dart placeholder

**Implementar:**
- GoogleMap widget
- Markers das barbearias
- Busca por localização
- InfoWindow com detalhes
- Navegação para tela de detalhes

### 5. **Safety Center**
- ✅ SafetyController existe
- ❌ safety_center_screen.dart placeholder

**Implementar:**
- Tela de denúncias
- Bloquear usuário
- Configurações de privacidade
- Tips de segurança
- Relatório de abuse

### 6. **Admin Dashboard**
- ✅ AdminController existe
- ❌ admin_dashboard_screen.dart placeholder

**Implementar:**
- Estatísticas: users, matches, revenue
- Gráficos (charts_flutter)
- Moderar conteúdo
- Gerenciar denúncias
- Logs de atividade

### 7. **AI Services (3 IAs)**

#### Gemini (Chat Artístico)
- ✅ ArtisticChatScreen JÁ EXISTE
- ❌ GeminiService não implementado
- ⚠️ FALTA: Classe real de service

**Implementar:**
```dart
// lib/src/data/services/gemini_service.dart
class GeminiService {
  Future<String> sendMessage(String prompt) async {
    // Integração com Google Gemini API
  }
}
```

#### Claude (Compatibility Analysis)
- ❌ ClaudeService não existe
- ❌ Nenhuma tela usando

**Implementar:**
```dart
// lib/src/data/services/claude_service.dart
class ClaudeService {
  Future<CompatibilityReport> analyzeProfiles(Profile p1, Profile p2) async {
    // Integração com Anthropic Claude API
  }
}
```

#### Perplexity Comet (Date Recommendations)
- ❌ CometService não existe
- ❌ Precisa integrar com DateIdeasController

**Implementar:**
```dart
// lib/src/data/services/comet_service.dart
class CometService {
  Future<List<DateIdea>> getRecommendations(Location loc, Preferences prefs) async {
    // Integração com Perplexity Comet API
  }
}
```

### 8. **Ratings & Reviews**
- ✅ RatingController existe
- ❌ rating_screen.dart não conectado

**Implementar:**
- Tela de avaliação pós-date
- Star rating (5 estrelas)
- TextArea para comentário
- Submit → salvar no Firestore
- Lista de reviews recebidas

### 9. **Vacancies (Barber Jobs)**
- ✅ VacancyController existe
- ✅ create_vacancy_screen.dart existe
- ❌ Lista de vagas não implementada

**Implementar:**
- vacancy_list_screen.dart
- Filtros: cidade, especialidade, salário
- Card com detalhes da vaga
- Botão candidatar-se
- Status da candidatura

---

## 🐛 BUGS DE BUILD (Riverpod Generator)

### Erros InvalidTypeException (10 controllers)

1. **booking_controller.dart**
2. **ai_dating_coach_controller.dart**
3. **analytics_controller.dart**
4. **date_ideas_controller.dart**
5. **o2o_map_controller.dart**
6. **anti_ghosting_controller.dart**
7. **advanced_matching_controller.dart**
8. **monetization_controller.dart**
9. **purchase_controller.dart**
10. **compatibility_quiz_controller.dart**

**Causa**: Tipo retornado não é válido para @riverpod

**Solução Padrão**:
```dart
// ❌ ERRADO
@riverpod
SomeClass someProvider(Ref ref) => SomeClass();

// ✅ CORRETO
@riverpod
Future<SomeClass> someProvider(Ref ref) async {
  return SomeClass();
}
// OU
@riverpod
Stream<SomeClass> someProvider(Ref ref) {
  return someStream;
}
```

### Erros "Directives must appear before declarations" (2 arquivos)

1. **image_picker_service.dart** (linha 238)
2. **app_utils.dart** (linha 295)

**Causa**: Import após código

**Solução**:
- Mover todos os `import` para o topo do arquivo
- Ordem: imports dart → package → relative

### Erro de Sintaxe (1 arquivo)

1. **purchase_repository.dart** (linha 232)

**Causa**: Parêntese faltando

**Solução**:
- Adicionar `)` na linha 232

---

## 🎯 PLANO DE EXECUÇÃO (Ordem Recomendada)

### **SPRINT 1: Consertar Build (PRIORIDADE MÁXIMA)**
⏱️ Estimativa: 1-2 horas

**Tarefas:**
1. ✅ Fixar purchase_repository.dart linha 232 (missing `)`)
2. ✅ Fixar image_picker_service.dart linha 238 (mover imports)
3. ✅ Fixar app_utils.dart linha 295 (mover imports)
4. ✅ Fixar 10 controllers com InvalidTypeException
5. ✅ Rodar `dart run build_runner build --delete-conflicting-outputs` até limpo

**Critério de Sucesso:** Build 100% sem erros

---

### **SPRINT 2: Discovery & Matches (CORE DO APP)**
⏱️ Estimativa: 4-6 horas

**Tarefas:**
1. ✅ Implementar SwipeScreen completo
   - SwipeCard widget com foto/nome/bio
   - GestureDetector para drag
   - Animações de rotação/escala
   - Botões de ação (like, dislike, super like)
   - Conectar com SwipeController

2. ✅ Implementar MatchesScreen completo
   - ListView com matchesProvider stream
   - Match card design
   - Navegação para ChatScreen
   - Pull-to-refresh

3. ✅ Implementar Profile Detail Screen
   - Hero animation
   - PageView galeria
   - Botões de ação
   - Parallax scroll

**Critério de Sucesso:** Usuário consegue dar swipe, dar match, ver perfil completo

---

### **SPRINT 3: Edit Profile & Notifications**
⏱️ Estimativa: 3-4 horas

**Tarefas:**
1. ✅ Implementar Edit Profile Screen
   - Form completo
   - Upload/reorder fotos
   - Validação
   - Salvar no Firestore

2. ✅ Implementar Notifications Inbox
   - Lista de notificações
   - Tipos diferentes (match, message, like)
   - Mark as read
   - Navegação

**Critério de Sucesso:** Usuário edita perfil e vê notificações

---

### **SPRINT 4: Monetização & Subscriptions**
⏱️ Estimativa: 3-5 horas

**Tarefas:**
1. ✅ Implementar Subscription Screen
   - Cards de planos (Free, Plus, Premium)
   - Botões de compra
   - Restaurar compras
   - Status da assinatura

2. ✅ Conectar com SubscriptionController
   - purchasePlan()
   - restorePurchases()
   - cancelSubscription()

3. ✅ Testar fluxo de compra (sandbox)

**Critério de Sucesso:** Usuário consegue assinar plano premium

---

### **SPRINT 5: Google Maps & Store Locator**
⏱️ Estimativa: 4-6 horas

**Tarefas:**
1. ✅ Adicionar google_maps_flutter ao pubspec
2. ✅ Configurar API keys (Android + iOS)
3. ✅ Implementar Store Locator Screen
   - GoogleMap widget
   - Markers das barbearias
   - InfoWindow
   - Busca por localização

4. ✅ Conectar com StoreLocatorController
5. ✅ Testar no emulador e device real

**Critério de Sucesso:** Mapa mostrando barbearias próximas

---

### **SPRINT 6: AI Services (3 IAs)**
⏱️ Estimativa: 6-8 horas

**Tarefas:**

#### 1. **Gemini Service (Chat Artístico)**
```bash
# Adicionar dependência
flutter pub add google_generative_ai
```

- ✅ Criar lib/src/data/services/gemini_service.dart
- ✅ Integrar API key do .env
- ✅ Conectar com ArtisticChatScreen
- ✅ Testar conversação

#### 2. **Claude Service (Compatibility Analysis)**
```bash
# Adicionar dependência
flutter pub add anthropic_sdk_dart
```

- ✅ Criar lib/src/data/services/claude_service.dart
- ✅ Criar compatibility_analysis_screen.dart
- ✅ Conectar com CompatibilityQuizController
- ✅ Testar análise de compatibilidade

#### 3. **Perplexity Comet (Date Recommendations)**
```bash
# Usar dio para HTTP requests
```

- ✅ Criar lib/src/data/services/comet_service.dart
- ✅ Criar date_ideas_screen.dart
- ✅ Conectar com DateIdeasController
- ✅ Testar sugestões

**Critério de Sucesso:** 3 IAs funcionando e respondendo

---

### **SPRINT 7: Compatibility Quiz & Ratings**
⏱️ Estimativa: 3-4 horas

**Tarefas:**
1. ✅ Implementar Compatibility Quiz Screen
   - Perguntas do quiz
   - Progress bar
   - Submit e cálculo de score
   - Tela de resultados

2. ✅ Implementar Rating Screen
   - Star rating
   - Comentário
   - Submit review
   - Lista de reviews recebidas

**Critério de Sucesso:** Usuário completa quiz e avalia outros

---

### **SPRINT 8: Vacancies & Safety**
⏱️ Estimativa: 3-4 horas

**Tarefas:**
1. ✅ Implementar Vacancy List Screen
   - Lista de vagas
   - Filtros
   - Botão candidatar-se

2. ✅ Implementar Safety Center Screen
   - Denunciar usuário
   - Bloquear
   - Configurações de privacidade

**Critério de Sucesso:** Barbeiros veem vagas, usuários denunciam abusos

---

### **SPRINT 9: Admin Dashboard**
⏱️ Estimativa: 4-6 horas

**Tarefas:**
1. ✅ Implementar Admin Dashboard Screen
   - Estatísticas
   - Gráficos (charts_flutter)
   - Moderar conteúdo
   - Gerenciar denúncias

2. ✅ Adicionar permissões de admin no Firestore
3. ✅ Testar todas as funções

**Critério de Sucesso:** Admin consegue moderar plataforma

---

### **SPRINT 10: Animações & Polish**
⏱️ Estimativa: 4-5 horas

**Tarefas:**
1. ✅ Adicionar Hero animations entre telas
2. ✅ Page transitions customizadas (go_router)
3. ✅ Loading states com Shimmer em todas as telas
4. ✅ Micro-interactions (ripple, hover effects)
5. ✅ Haptic feedback em ações importantes
6. ✅ Success/Error snackbars consistentes

**Critério de Sucesso:** App fluido e polido

---

### **SPRINT 11: Testes & Refino (FINAL)**
⏱️ Estimativa: 8-10 horas

**Tarefas:**
1. ✅ Testar TODOS os fluxos no emulador
2. ✅ Testar em device real (Android + iOS)
3. ✅ Corrigir bugs encontrados
4. ✅ Otimizar performance (build time, load time)
5. ✅ Revisar UX/UI inconsistências
6. ✅ Preparar para produção (release build)
7. ✅ Documentação final

**Critério de Sucesso:** App 100% funcional, sem crashes, pronto pra lançar

---

## 📊 RESUMO EXECUTIVO

| Categoria | Status | Count |
|-----------|--------|-------|
| ✅ Funcionando | Completo | 6 features |
| ⚠️ Placeholder | Precisa UI | 5 features |
| ❌ Não Conectado | Controller pronto | 9 features |
| 🐛 Build Errors | Bloqueando | 13 arquivos |
| **TOTAL** | **Para Implementar** | **20 features** |

---

## 🎯 META FINAL

**Entregar app 100% funcional com:**
- ✅ Autenticação completa
- ✅ Swipe/Match funcionando
- ✅ Chat real-time
- ✅ Upload de fotos/vídeos
- ✅ Google Maps integrado
- ✅ 3 IAs funcionando (Gemini, Claude, Comet)
- ✅ Sistema de pagamentos
- ✅ Notificações
- ✅ Admin dashboard
- ✅ Animações polidas
- ✅ Zero bugs críticos

**Prazo Estimado:** 40-60 horas de dev
**Sprints:** 11 sprints
**Metodologia:** Implementar agressivamente, testar no final

---

**PRÓXIMO PASSO:** Começar Sprint 1 (Consertar Build) 🚀
