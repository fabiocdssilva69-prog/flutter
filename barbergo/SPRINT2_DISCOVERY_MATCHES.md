# 🎯 SPRINT 2 - Discovery & Matches (EM ANDAMENTO)

**Objetivo**: Implementar o CORE do app - Swipe, Matches e Profile Detail

**Status**: ✅ INICIADO - Implementando SwipeScreen

---

## ✅ Checklist de Implementação

### 1. SwipeScreen - Tela de Swipe (CORE)

- [ ] Criar SwipeCard widget
  - [ ] Stack com foto de fundo
  - [ ] Gradient overlay no bottom
  - [ ] Nome, idade, distância
  - [ ] Bio preview
  - [ ] Indicadores de foto (dots)
  
- [ ] Implementar gestos
  - [ ] GestureDetector para drag
  - [ ] AnimatedBuilder para rotação
  - [ ] Threshold para like/dislike
  - [ ] Animação de saída (fade out + scale)
  
- [ ] Botões de ação
  - [ ] Dislike (❌ vermelho)
  - [ ] Super Like (⭐ azul)
  - [ ] Like (💚 verde)
  - [ ] Rewind (↩️ amarelo) - premium
  
- [ ] Conectar com SwipeController
  - [ ] candidateProfilesProvider stream
  - [ ] swipe() method
  - [ ] superLike() method
  
- [ ] Estados
  - [ ] Loading (shimmer)
  - [ ] Empty (sem mais perfis)
  - [ ] Error

---

### 2. MatchesScreen - Lista de Matches

- [ ] ListView de matches
  - [ ] matchesProvider stream
  - [ ] Avatar circular
  - [ ] Nome + última mensagem
  - [ ] Timestamp relativo
  - [ ] Badge de unread
  
- [ ] Pull to refresh

- [ ] Tap → navegar para ChatScreen

- [ ] Empty state (sem matches)

---

### 3. ProfileDetailScreen - Ver Perfil Completo

- [ ] Hero animation da foto principal

- [ ] PageView para galeria
  - [ ] Swipe horizontal nas fotos
  - [ ] Indicadores de página
  
- [ ] Scroll vertical
  - [ ] Header com foto (parallax)
  - [ ] Nome, idade, distância
  - [ ] Bio completa
  - [ ] Interesses (chips)
  - [ ] Trabalhos/educação
  
- [ ] Botões de ação (bottom)
  - [ ] Dislike
  - [ ] Super Like
  - [ ] Like
  - [ ] Denunciar (menu)

---

## 📂 Arquivos a Modificar

1. `lib/src/features/discovery/presentation/swipe_screen.dart` - REESCREVER
2. `lib/src/features/matches/presentation/matches_screen.dart` - REESCREVER
3. `lib/src/features/profile/screens/profile_detail_screen.dart` - CRIAR
4. `lib/src/core/widgets/swipe_card.dart` - CRIAR
5. `lib/src/routing/app_router.dart` - Adicionar rota de profile detail

---

## 🎯 Meta

Usuário consegue:
- ✅ Ver perfis de candidatos
- ✅ Dar swipe (like/dislike/super like)
- ✅ Ver lista de matches
- ✅ Abrir perfil completo de alguém
- ✅ Dar like direto do perfil

**Prazo**: 4-6 horas
**Prioridade**: MÁXIMA (CORE DO APP)
