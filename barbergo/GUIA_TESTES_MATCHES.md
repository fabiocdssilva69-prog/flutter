# 🧪 GUIA DE TESTES - SISTEMA DE MATCHES

## ⚡ TESTE RÁPIDO (5 MINUTOS)

### Pré-requisitos
- ✅ Cloud Functions deployadas (CONCLUÍDO)
- ✅ App compilado sem erros
- ⏳ 2 dispositivos (físicos ou emuladores)

---

## 📱 CENÁRIO 1: Match entre 2 Usuários

### Passo 1: Preparar Usuários no Firebase Console

1. **Abrir Firebase Console:**
   ```
   https://console.firebase.google.com/project/barbergo-38c21/firestore
   ```

2. **Verificar Perfis Existentes:**
   - Coleção: `profiles`
   - Selecionar 2 perfis existentes:
     - **User A:** Anote o `userId` (ex: `abc123`)
     - **User B:** Anote o `userId` (ex: `def456`)

3. **Verificar FCM Tokens:**
   - Ambos devem ter `fcmToken` preenchido
   - Se vazio: Fazer login no app para gerar token

---

### Passo 2: Login no Device 1 (User A)

1. **Iniciar app no device:**
   ```powershell
   flutter run -d uwbekb8hpf6lamts
   ```

2. **Login:**
   - Email: `<email-user-a>`
   - Senha: `<senha-user-a>`

3. **Navegar para Descobrir:**
   - Tap no ícone de busca
   - Verificar se User B aparece nos cards

4. **Dar Like no User B:**
   - Swipe para direita OU
   - Tap no botão de coração verde
   - **Resultado esperado:** SnackBar "❤️ Você curtiu [Nome User B]"

5. **Verificar Firestore:**
   ```
   Firebase Console → Firestore → swipes/
   Deve ter documento:
   - userId: abc123
   - targetUserId: def456
   - liked: true
   - createdAt: timestamp
   ```

---

### Passo 3: Login no Device 2 (User B)

1. **Iniciar app no segundo device:**
   ```powershell
   # Listar devices disponíveis:
   flutter devices
   
   # Selecionar outro device:
   flutter run -d <device-id>
   ```

2. **Login:**
   - Email: `<email-user-b>`
   - Senha: `<senha-user-b>`

3. **Navegar para Descobrir:**
   - Verificar se User A aparece nos cards

4. **Dar Like no User A:**
   - Swipe para direita OU
   - Tap no botão de coração verde
   - **Aguardar 2-3 segundos** (Cloud Function processar)

---

### Passo 4: Validar Match

**✅ O que deve acontecer:**

1. **MatchCelebrationDialog aparece:**
   - 🎊 Animação de confetti explosivo
   - 🖼️ 2 avatares circulares (User A e User B)
   - 💖 Ícone de coração rosa entre avatares
   - 📝 Texto: "🎉 É um Match!"
   - 📄 Mensagem: "Você e [Nome] deram match!"

2. **Botões disponíveis:**
   - **"Continuar explorando"** → Fecha dialog, volta para swipe
   - **"Enviar mensagem"** → Navega para tela de chat

3. **Notificações Push (ambos devices):**
   - Título: "🎉 Novo Match!"
   - Body: "Você e outro usuário deram match! Comece a conversar agora."

4. **Documento no Firestore:**
   ```
   Firebase Console → Firestore → matches/
   Document ID: abc123_def456 (ordenado alfabeticamente)
   Campos:
   - matchId: "abc123_def456"
   - user1Id: "abc123"
   - user2Id: "def456"
   - createdAt: timestamp
   - lastMessageAt: timestamp
   - unreadCountUser1: 0
   - unreadCountUser2: 0
   ```

---

### Passo 5: Testar Chat

1. **No Device 1 ou 2:**
   - Tap no botão "Enviar mensagem"

2. **Tela de Chat abre:**
   - AppBar com nome do outro usuário
   - Campo de texto para mensagem

3. **Enviar mensagem:**
   - Digitar: "Oi, tudo bem?"
   - Tap no botão de enviar

4. **Verificar no outro device:**
   - Notificação push deve aparecer
   - Título: "[Nome do remetente]"
   - Body: "Oi, tudo bem?"

5. **Verificar Firestore:**
   ```
   Firebase Console → Firestore → matches/abc123_def456/messages/
   Deve ter documento:
   - text: "Oi, tudo bem?"
   - senderId: abc123
   - timestamp: timestamp
   ```

---

## 🔍 CENÁRIO 2: Testar Filtros

### Passo 1: Abrir Filtros

1. **Na tela de Descobrir:**
   - Tap no ícone de filtro (filter_list) no AppBar

2. **FiltersBottomSheet abre:**
   - SegmentedButton "Raio de Busca": [5 km] [10 km] [25 km]
   - SegmentedButton "Tipo de Conta": [Todos] [Barbeiros] [Clientes]
   - Switch "Apenas usuários online"
   - Botão "Aplicar Filtros"

---

### Passo 2: Testar Controles

1. **Alterar Raio:**
   - Tap em "5 km"
   - Verificar seleção visual

2. **Alterar Tipo:**
   - Tap em "Barbeiros"
   - Verificar seleção visual

3. **Toggle Online:**
   - Ativar switch "Apenas usuários online"
   - Verificar estado ativo

4. **Aplicar:**
   - Tap em "Aplicar Filtros"
   - BottomSheet fecha

---

### Passo 3: Verificar Debug Output

```powershell
# No terminal do Flutter:
flutter logs

# Deve mostrar:
Filtros aplicados: raio=5km, tipo=AccountType.barber, online=true
```

**⚠️ Nota:** A implementação dos filtros no controller está pendente.  
**TODO:** Modificar `DiscoveryController` para aceitar `DiscoveryFilters` como parâmetro.

---

## 📊 CENÁRIO 3: Verificar Logs das Cloud Functions

### Passo 1: Abrir Firebase Functions Logs

```powershell
firebase functions:log --limit 20
```

### Passo 2: Logs Esperados

**Após match criado:**
```
Function execution started
✅ Match criado: abc123_def456
Function execution took 1234 ms, finished with status: 'ok'
```

**Após notificação enviada:**
```
Function execution started
🔔 Notificações enviadas: 2
Function execution took 567 ms, finished with status: 'ok'
```

**Após mensagem enviada:**
```
Function execution started
💬 Notificação de mensagem enviada para: def456
Function execution took 890 ms, finished with status: 'ok'
```

---

## 🐛 TROUBLESHOOTING

### Problema 1: MatchCelebrationDialog não aparece

**Sintoma:** Like dado, mas dialog não abre  
**Causas possíveis:**
1. Cloud Function `detectMatch` não executou
2. Match não foi criado no Firestore
3. Aguardou menos de 2 segundos

**Solução:**
```powershell
# Verificar logs da Cloud Function:
firebase functions:log --only detectMatch

# Verificar manualmente no Firestore:
Firebase Console → Firestore → matches/

# Aumentar delay no código (se necessário):
await Future.delayed(const Duration(seconds: 3));
```

---

### Problema 2: Notificação push não recebida

**Sintoma:** Match criado, mas notificação não chega  
**Causas possíveis:**
1. FCM token vazio ou inválido
2. Permissões de notificação negadas
3. App em primeiro plano (Android suprime notificações)

**Solução:**
```powershell
# Verificar FCM token no Firestore:
Firebase Console → Firestore → profiles/{userId} → fcmToken

# Verificar logs da Cloud Function:
firebase functions:log --only sendMatchNotification

# Testar com app em background
```

---

### Problema 3: Confetti não aparece

**Sintoma:** Dialog abre, mas sem confetti  
**Causas possíveis:**
1. Package confetti não instalado
2. ConfettiController não inicializado

**Solução:**
```powershell
# Verificar instalação:
flutter pub get

# Verificar pubspec.yaml:
dependencies:
  confetti: ^0.8.0

# Hot reload:
r (no terminal do flutter)
```

---

### Problema 4: Erro ao navegar para chat

**Sintoma:** Tap em "Enviar mensagem" → erro  
**Causas possíveis:**
1. Rota `/chat/{matchId}` não configurada
2. go_router não instalado

**Solução:**
```dart
// Verificar app_router.dart:
GoRoute(
  path: '/chat/:matchId',
  builder: (context, state) {
    final matchId = state.pathParameters['matchId']!;
    final matchedUser = state.extra as ProfileEntity?;
    return ChatScreen(matchId: matchId, matchedUser: matchedUser);
  },
),
```

---

## ✅ CHECKLIST DE VALIDAÇÃO FINAL

Após executar todos os cenários, verificar:

- [ ] Match detection funciona (documento criado em `/matches/`)
- [ ] MatchCelebrationDialog aparece com confetti
- [ ] Notificações push recebidas em ambos devices
- [ ] Botão "Enviar mensagem" navega para chat
- [ ] Mensagem enviada gera notificação no destinatário
- [ ] FiltersBottomSheet abre e fecha corretamente
- [ ] Controles de filtro respondem aos taps
- [ ] Debug logs aparecem ao aplicar filtros
- [ ] Cloud Functions logs mostram execuções bem-sucedidas
- [ ] Sem crashes ou freezes durante testes

---

## 🎯 PRÓXIMOS TESTES (Avançado)

### Load Testing
1. **Criar 50+ perfis no Firestore**
2. **Swipe rápido em sequência** (10 likes em 10 segundos)
3. **Verificar performance:** Memory leaks, frame drops

### Edge Cases
1. **Match simultâneo:** Ambos dão like ao mesmo tempo
2. **Offline mode:** Dar like sem internet, verificar sync
3. **Match expirado:** Criar match antigo (7+ dias), testar comportamento

### Security
1. **Firestore Rules:** Testar acesso não autorizado
2. **FCM Token:** Tentar enviar notificação com token inválido
3. **Duplicate matches:** Criar 2 matches com mesmo matchId

---

## 📞 COMANDOS ÚTEIS

```powershell
# Ver logs em tempo real:
firebase functions:log --follow

# Ver apenas erros:
firebase functions:log --filter ERROR

# Limpar cache do Flutter:
flutter clean && flutter pub get

# Rebuild completo:
flutter run --release

# Verificar conectividade Firestore:
firebase firestore:indexes

# Testar Cloud Functions localmente:
firebase emulators:start --only functions,firestore
```

---

## 🎓 DICAS PARA TESTES EFICIENTES

1. **Use 2 emuladores** em vez de devices físicos (mais rápido)
2. **Crie perfis de teste dedicados** (evite usar contas reais)
3. **Mantenha Firebase Console aberto** (monitorar Firestore em tempo real)
4. **Use hot reload** durante testes (sem rebuild completo)
5. **Teste em diferentes estados** (foreground, background, terminated)
6. **Documente bugs** em arquivo BUGS.md (facilita tracking)

---

**Gerado em:** ${new Date().toLocaleString('pt-BR')}  
**Status do Sistema:** 🟢 PRONTO PARA TESTES  
**Documentação Completa:** DEPLOY_COMPLETO_SUCESSO.md
