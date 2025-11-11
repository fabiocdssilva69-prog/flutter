# 📱 PASSO A PASSO: TESTAR SISTEMA DE MATCHES

## 🎯 OBJETIVO
Testar o sistema de matches completo: swipe, match, confetti, chat e notificações.

---

## ✅ PRÉ-REQUISITOS (JÁ CONCLUÍDO)

- ✅ Cloud Functions deployadas
- ✅ App instalado no device `uwbekb8hpf6lamts`
- ✅ Flutter running
- ⏳ Aguardando app inicializar...

---

## 📋 PASSO 1: ABRIR FIREBASE CONSOLE

**Objetivo:** Preparar 2 perfis de teste para o match

### 1.1 Abrir Console
```
https://console.firebase.google.com/project/barbergo-38c21/firestore
```

### 1.2 Navegar para Profiles
1. No menu lateral, clique em **"Firestore Database"**
2. Clique na coleção **"profiles"**
3. Você verá uma lista de perfis existentes

### 1.3 Identificar 2 Perfis
Escolha 2 perfis diferentes:

**Perfil A (Você - Device Físico):**
- userId: `_______________` (anote aqui)
- name: `_______________`
- email: `_______________`
- fcmToken: ✅ Verificar se está preenchido

**Perfil B (Para dar match):**
- userId: `_______________` (anote aqui)
- name: `_______________`
- email: `_______________`
- fcmToken: ✅ Verificar se está preenchido

---

## 📋 PASSO 2: FAZER LOGIN NO APP

### 2.1 Aguardar App Abrir
O app está carregando no seu device `Redmi Note 8 Pro`.

### 2.2 Fazer Login
1. No device, você verá a tela de login
2. Digite o **email do Perfil A** (o que você anotou acima)
3. Digite a senha
4. Clique em **"Entrar"**

### 2.3 Verificar Home
Você deve ver a tela inicial com:
- ✅ Seu avatar no topo
- ✅ Menu inferior com 4 ícones
- ✅ Ícone de busca/descobrir

---

## 📋 PASSO 3: NAVEGAR PARA DESCOBRIR

### 3.1 Tap no Ícone de Busca
No menu inferior, clique no ícone de busca (lupa ou coração).

### 3.2 O Que Você Verá
- **AppBar:** "Descobrir" + ícone de filtro (lista)
- **Cards de perfil:** Fotos grandes com nome e bio
- **Botões inferiores:** ❌ (vermelho) e ❤️ (verde)

### 3.3 Verificar Se Perfil B Aparece
Role os cards até encontrar o **Perfil B** (o que você anotou no Passo 1).

**Se não aparecer:**
- Pode estar em outra posição
- Pode estar fora do raio de busca
- Você pode testar com outro perfil disponível

---

## 📋 PASSO 4: DAR LIKE NO PERFIL B

### 4.1 Dar Like
Quando o **Perfil B** estiver visível:

**Opção 1:** Swipe para direita (arrastar card para a direita)  
**Opção 2:** Tap no botão ❤️ verde

### 4.2 O Que Deve Acontecer
Você verá um **SnackBar** (mensagem rápida embaixo):
```
❤️ Você curtiu [Nome do Perfil B]
```

### 4.3 Verificar no Firestore
Volte para o Firebase Console:

1. Navegue para a coleção **"swipes"**
2. Deve ter um **novo documento**:
   ```
   userId: [seu userId - Perfil A]
   targetUserId: [userId do Perfil B]
   liked: true
   createdAt: [timestamp agora]
   ```

---

## 📋 PASSO 5: SIMULAR LIKE DO PERFIL B

Como você está sozinho testando, vamos **simular** que o Perfil B também curtiu você.

### 5.1 Abrir Firebase Console
Volte para **Firestore Database** → **"swipes"**

### 5.2 Criar Documento Manualmente
Clique em **"Add document"**

### 5.3 Preencher Campos

**Document ID:** Deixe auto-gerar (ou crie um ID qualquer)

**Fields:**
```
userId (string):       [userId do Perfil B]
targetUserId (string): [seu userId - Perfil A]
liked (boolean):       true
createdAt (timestamp): [now] (clique no relógio para timestamp atual)
```

### 5.4 Salvar
Clique em **"Save"**

---

## 📋 PASSO 6: AGUARDAR CLOUD FUNCTION

### 6.1 O Que Acontece Automaticamente
A Cloud Function **`detectMatch`** será executada:

1. Detecta que ambos curtiram um ao outro
2. Cria documento em **`/matches/`**
3. Dispara **`sendMatchNotification`**
4. Você recebe notificação push

### 6.2 Tempo de Espera
⏱️ Aguarde **2-5 segundos**

### 6.3 Verificar Logs (Opcional)
Se quiser ver a execução em tempo real:
```powershell
firebase functions:log --follow
```

Você verá:
```
✅ Match criado: [userId1]_[userId2]
🔔 Notificações enviadas: 2
```

---

## 📋 PASSO 7: VERIFICAR MATCH CRIADO

### 7.1 Abrir Firebase Console
Navegue para **Firestore Database** → **"matches"**

### 7.2 Encontrar Documento
Procure por um documento com ID:
```
[userId_menor]_[userId_maior]
```

Por exemplo, se os IDs são `abc123` e `def456`:
```
abc123_def456
```

### 7.3 Campos do Match
O documento deve ter:
```
matchId: "abc123_def456"
user1Id: "abc123"
user2Id: "def456"
createdAt: [timestamp]
lastMessageAt: [timestamp]
unreadCountUser1: 0
unreadCountUser2: 0
```

---

## 📋 PASSO 8: TESTAR CELEBRATION DIALOG NO APP

### 8.1 Voltar para o App
No device, volte para a tela de **Descobrir** (se saiu).

### 8.2 Dar Like em Outro Perfil
Como o match já foi criado manualmente, vamos testar com um **perfil novo**:

1. Encontre outro perfil disponível
2. Dê like (swipe direita ou ❤️)
3. **Volte ao Firebase Console**
4. Crie swipe reverso manualmente (igual Passo 5)

### 8.3 O Que Deve Acontecer

Após 2-3 segundos, você verá:

**🎊 MATCHCELEBRATIONDIALOG:**
- Animação de confetti caindo
- 2 avatares circulares (você + outro perfil)
- Coração rosa entre os avatares
- Texto: **"🎉 É um Match!"**
- Mensagem: **"Você e [Nome] deram match!"**
- 2 botões:
  - **"Continuar explorando"** (cinza)
  - **"Enviar mensagem"** (rosa)

---

## 📋 PASSO 9: TESTAR NAVEGAÇÃO PARA CHAT

### 9.1 Tap em "Enviar mensagem"
Clique no botão rosa **"Enviar mensagem"**

### 9.2 O Que Deve Acontecer
- Dialog fecha
- Você é redirecionado para a **tela de chat**
- AppBar mostra o nome do outro usuário
- Campo de texto na parte inferior

### 9.3 Enviar Mensagem
1. Digite: **"Oi, tudo bem?"**
2. Clique no botão de enviar (ícone de avião/seta)

### 9.4 Verificar no Firestore
Volte ao Firebase Console:

Navegue para:
```
matches/{matchId}/messages/
```

Deve ter um **novo documento**:
```
senderId: [seu userId]
text: "Oi, tudo bem?"
timestamp: [agora]
```

---

## 📋 PASSO 10: TESTAR FILTROS

### 10.1 Voltar para Descobrir
Navegue de volta para a tela de **Descobrir**

### 10.2 Abrir Filtros
Clique no **ícone de filtro** (lista) no AppBar

### 10.3 FiltersBottomSheet Abre
Você verá:

**Raio de Busca:**
- [ 5 km ] [ 10 km ] [ 25 km ]

**Tipo de Conta:**
- [ Todos ] [ Barbeiros ] [ Clientes ]

**Switch:**
- [ ] Apenas usuários online

**Botão:**
- [Aplicar Filtros]

### 10.4 Testar Controles

1. **Tap em "5 km"** → Deve ficar selecionado (visual muda)
2. **Tap em "Barbeiros"** → Deve ficar selecionado
3. **Ativar switch "Apenas online"** → Deve ligar
4. **Tap em "Aplicar Filtros"** → Bottom sheet fecha

### 10.5 Verificar Debug Output

Se você estiver com `flutter run` ativo no terminal, verá:
```
Filtros aplicados: raio=5km, tipo=AccountType.barber, online=true
```

**⚠️ Nota:** A implementação dos filtros no controller ainda está pendente,  
então os perfis mostrados **não mudarão** por enquanto. Isso é esperado.

---

## 📋 PASSO 11: VERIFICAR NOTIFICAÇÕES PUSH

### 11.1 Colocar App em Background
Pressione o botão **Home** do device (app fica em background).

### 11.2 Criar Mensagem Manualmente no Firestore

Vá ao Firebase Console:
```
matches/{matchId}/messages/
```

Clique em **"Add document"**

**Campos:**
```
senderId (string):    [userId do outro perfil - Perfil B]
text (string):        "Olá! Como você está?"
timestamp (timestamp): [now]
```

Clique em **"Save"**

### 11.3 O Que Deve Acontecer

Após 1-2 segundos, você verá uma **notificação push** no device:

**Título:** [Nome do Perfil B]  
**Corpo:** "Olá! Como você está?"

### 11.4 Tap na Notificação
Clique na notificação → O app deve abrir direto no chat.

---

## ✅ CHECKLIST FINAL DE VALIDAÇÃO

Marque cada item conforme testar:

### Matches
- [ ] Like registrado no Firestore (`/swipes/`)
- [ ] Match criado no Firestore (`/matches/`)
- [ ] MatchCelebrationDialog apareceu com confetti
- [ ] Animação de confetti funcionou (partículas caindo)
- [ ] Avatares dos 2 usuários visíveis
- [ ] Botão "Enviar mensagem" funcionou

### Chat
- [ ] Navegação para tela de chat funcionou
- [ ] Mensagem enviada aparece no Firestore
- [ ] Cloud Function `onNewMessage` executou
- [ ] Notificação push recebida

### Filtros
- [ ] FiltersBottomSheet abre ao clicar no ícone
- [ ] SegmentedButton de raio funciona (visual muda)
- [ ] SegmentedButton de tipo funciona
- [ ] Switch "Apenas online" funciona
- [ ] Botão "Aplicar Filtros" fecha o bottom sheet
- [ ] Debug log aparece no terminal

### Cloud Functions
- [ ] `detectMatch` executou (logs no Firebase)
- [ ] `sendMatchNotification` executou
- [ ] `onNewMessage` executou
- [ ] Sem erros nos logs

---

## 🐛 TROUBLESHOOTING RÁPIDO

### Problema: MatchCelebrationDialog não aparece

**Solução:**
1. Verifique se o match foi criado no Firestore (`/matches/`)
2. Aguarde 5 segundos após criar o swipe reverso
3. Dê like novamente em outro perfil
4. Verifique logs: `firebase functions:log`

### Problema: Notificação não recebida

**Solução:**
1. Verifique se `fcmToken` está preenchido no perfil
2. Verifique permissões de notificação no device (Configurações > Apps > BARBERGO)
3. Coloque app em **background** (não funciona em foreground no Android)
4. Verifique logs: `firebase functions:log --only onNewMessage`

### Problema: Confetti não aparece

**Solução:**
1. Verifique se package `confetti` está instalado: `flutter pub get`
2. Hot reload: Pressione `r` no terminal do Flutter
3. Hot restart: Pressione `R` no terminal do Flutter

### Problema: Erro ao navegar para chat

**Solução:**
1. Verifique se a rota `/chat/:matchId` existe no `app_router.dart`
2. Verifique logs de erro no terminal do Flutter
3. Faça rebuild completo: `flutter run -d uwbekb8hpf6lamts`

---

## 📞 COMANDOS ÚTEIS

### Ver Logs das Cloud Functions
```powershell
firebase functions:log --follow
firebase functions:log --only detectMatch
firebase functions:log --only sendMatchNotification
firebase functions:log --only onNewMessage
```

### Ver Logs do Flutter
```powershell
flutter logs -d uwbekb8hpf6lamts
```

### Hot Reload/Restart
No terminal onde `flutter run` está ativo:
- `r` = Hot reload (recarrega código)
- `R` = Hot restart (reinicia app)
- `q` = Quit (para app)

### Rebuild Completo
```powershell
flutter clean
flutter pub get
flutter run -d uwbekb8hpf6lamts
```

---

## 🎯 PRÓXIMOS PASSOS APÓS VALIDAÇÃO

Quando todos os itens do checklist estiverem ✅:

1. **Documentar bugs encontrados** (se houver)
2. **Implementar filtros no DiscoveryController**
3. **Adicionar testes de integração**
4. **Preparar para beta testing**

---

## 📊 STATUS ATUAL

**Sistema:** 🟢 ONLINE  
**Cloud Functions:** 🟢 3/3 ACTIVE  
**App Version:** Debug Build  
**Device:** Redmi Note 8 Pro (Android 11)

---

**Boa sorte nos testes!** 🚀

Se encontrar qualquer problema, me avise que eu ajudo a resolver.
