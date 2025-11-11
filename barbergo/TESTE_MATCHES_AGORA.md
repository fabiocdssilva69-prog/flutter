# 🎯 TESTE DO SISTEMA DE MATCHES - GUIA RÁPIDO

## ✅ PRÉ-REQUISITOS COMPLETOS

### Firestore - Dados Criados:
- ✅ **Perfil A**: João Silva (barbeiro) - `PROFILE_A_UID`
- ✅ **Perfil B**: NOBRUS BARBERSHOP (você) - `6RYGS6HoEkhQgikNxUIkn7NpwmI3`
- ✅ **Perfil C**: Maria Santos (barbeiro) - `PROFILE_C_UID`
- ✅ **Collections**: swipes, matches, chats (vazias)
- ✅ **Firestore Rules**: Publicadas

### Cloud Functions:
- ✅ **detectMatch**: Detecta matches bidirecionais
- ✅ **sendMatchNotification**: Envia push notifications
- ✅ **onNewMessage**: Notifica novas mensagens

### App:
- ✅ Botões "Descobrir" e "Matches" na primeira aba
- ✅ SwipeScreen com animação de confetti
- ✅ MatchCelebrationDialog implementado
- ✅ Sistema de chat integrado

---

## 🚀 PASSO A PASSO DO TESTE

### **1. Reconectar Dispositivo e Executar App**
```powershell
# Reconecte o cabo USB do Redmi Note 8 Pro
# No terminal Flutter:
flutter run -d uwbekb8hpf6lamts
```

**Aguarde**: App compilar e abrir (≈2 minutos)

---

### **2. Navegar para Tela de Descobrir**

No app:
1. ✅ Você estará na **primeira aba** (tela de vagas/discovery)
2. 👀 **Procure no TOPO da tela** uma barra roxa/rosa
3. 👆 **Toque no botão "DESCOBRIR"** (primeiro botão, ícone explore)

**Resultado esperado**: 
- Tela muda para SwipeScreen
- Aparece "Descobrir" no AppBar
- Loading ou mensagem "Nenhum perfil disponível"

---

### **3. Verificar Perfis Carregados**

**Se aparecer "Nenhum perfil disponível":**

**Problema**: Seu perfil (NOBRUS BARBERSHOP) tem `accountType: "barbershop"`, então o app busca perfis com `accountType: "barber"`.

**Perfis esperados**:
- João Silva (barber) ✅
- Maria Santos (barber) ✅

**Se não aparecer nada**:
1. Verifique no Firebase Console se os perfis têm:
   - `accountType: "barber"` (João e Maria)
   - `accountType: "barbershop"` (NOBRUS)
2. Faça Hot Restart: Pressione `R` (maiúsculo) no terminal

---

### **4. Dar Like (Swipe para Direita)**

1. 👆 **Arraste o card para a DIREITA** (ou toque no botão ❤️)
2. ⏱️ **Aguarde 2-3 segundos** (Cloud Function processando)

**Logs esperados no terminal**:
```
I/flutter: Swipe registrado: PROFILE_A_UID (liked: true)
```

**No Firestore**:
- Nova entrada em `swipes/`: 
  - `fromUserId`: `6RYGS6HoEkhQgikNxUIkn7NpwmI3` (você)
  - `toUserId`: `PROFILE_A_UID` (João)
  - `liked`: `true`

---

### **5. Criar Swipe Reverso Manualmente (para Match)**

**No Firebase Console**:

1. Vá para **Firestore > swipes > Add document**
2. **Document ID**: (deixe auto-generate)
3. **Campos**:
```javascript
{
  "swipeId": "",  // Auto-gerado
  "fromUserId": "PROFILE_A_UID",  // João dá like em você
  "toUserId": "6RYGS6HoEkhQgikNxUIkn7NpwmI3",  // Você
  "liked": true,
  "createdAt": firebase.firestore.FieldValue.serverTimestamp()
}
```
4. **Clique em "Save"**

---

### **6. Aguardar Cloud Function (2-3 segundos)**

**O que acontece:**
1. Cloud Function `detectMatch` detecta os 2 likes
2. Cria documento em `matches/` com ID: `6RYGS6HoEkhQgikNxUIkn7NpwmI3_PROFILE_A_UID`
3. Campos do match:
   - `userIds`: [`6RYGS6HoEkhQgikNxUIkn7NpwmI3`, `PROFILE_A_UID`]
   - `user1`, `user2`, `createdAt`, `unreadCount`

**Verificar no Firebase Console**:
- Nova entrada em `matches/`

---

### **7. 🎊 VALIDAR MatchCelebrationDialog**

**No app, deve aparecer automaticamente**:

✅ **Animação de confetti** (3 segundos, explosão de partículas)
✅ **2 avatares circulares** (você + João Silva)
✅ **Ícone de coração rosa** entre os avatares
✅ **Texto**: "🎉 É um Match!"
✅ **Mensagem**: "Você e João Silva deram match!"
✅ **2 botões**:
   - "Continuar explorando" (fecha o dialog)
   - "Enviar mensagem" (navega para chat)

**Se não aparecer**:
- Verifique logs: `firebase functions:log --only detectMatch`
- Hot reload: Pressione `r` no terminal
- Deslize para próximo perfil e volte

---

### **8. Testar Navegação para Chat**

1. 👆 **Toque em "Enviar mensagem"**
2. **Resultado esperado**:
   - Dialog fecha
   - Navega para `/chat/6RYGS6HoEkhQgikNxUIkn7NpwmI3_PROFILE_A_UID`
   - Tela de chat abre com:
     - AppBar: "João Silva"
     - Campo de texto para mensagem
     - Botão de enviar

---

### **9. Testar Tela de Matches**

1. 👆 **Volte para tela inicial** (botão back)
2. 👆 **Toque no botão "MATCHES"** (segundo botão, ícone coração)
3. **Resultado esperado**:
   - Lista com 1 card: João Silva
   - Mostra avatar, nome, última mensagem
   - Toque no card → abre chat

---

## 🐛 TROUBLESHOOTING

### Problema: "Nenhum perfil disponível"

**Causa**: Perfis não criados ou accountType errado

**Solução**:
1. Verifique Firebase Console > profiles
2. Confirme:
   - João Silva: `accountType: "barber"` ✅
   - Maria Santos: `accountType: "barber"` ✅
   - NOBRUS: `accountType: "barbershop"` ✅
3. Hot Restart: `R` no terminal

---

### Problema: Match não criado após swipe reverso

**Causa**: Cloud Function não executou

**Solução**:
1. Verifique logs:
```powershell
firebase functions:log --only detectMatch
```
2. Confirme que os 2 swipes existem:
   - Você → João (`liked: true`)
   - João → Você (`liked: true`)
3. Verifique Firestore Rules (leitura/escrita permitidas)

---

### Problema: MatchCelebrationDialog não aparece

**Causa**: Verificação de match no código falhou

**Solução**:
1. Vá para SwipeScreen manualmente
2. Verifique se documento existe em `matches/`
3. Hot reload: `r` no terminal
4. Tente dar like novamente

---

### Problema: Confetti não anima

**Causa**: Package confetti não inicializado

**Solução**:
1. Hot Restart: `R` no terminal
2. Verifique console do Flutter:
```
I/flutter: ConfettiController initialized
```

---

## 📊 VALIDAÇÃO COMPLETA

### ✅ Checklist de Sucesso:

- [ ] App abriu sem erros
- [ ] Botões "Descobrir" e "Matches" visíveis
- [ ] SwipeScreen carregou 2 perfis (João e Maria)
- [ ] Swipe para direita registrou no Firestore
- [ ] Swipe reverso criado manualmente
- [ ] Cloud Function criou documento em `matches/`
- [ ] MatchCelebrationDialog apareceu com confetti
- [ ] Navegação para chat funcionou
- [ ] Tela de matches mostra 1 card
- [ ] Chat abre corretamente

### 📝 Logs Importantes:

**Terminal Flutter**:
```
I/flutter: Swipe registrado: PROFILE_A_UID (liked: true)
I/flutter: Match detectado! Mostrando celebração...
I/flutter: Navegando para chat: 6RYGS6HoEkhQgikNxUIkn7NpwmI3_PROFILE_A_UID
```

**Firebase Functions**:
```
Match criado: 6RYGS6HoEkhQgikNxUIkn7NpwmI3_PROFILE_A_UID
🔔 Notificações enviadas: 2
```

---

## 🎯 PRÓXIMOS PASSOS

Após validar o fluxo básico:

1. **Testar filtros** (FiltersBottomSheet)
2. **Testar chat** (enviar mensagens)
3. **Testar push notifications** (colocar app em background)
4. **Corrigir testes** (swipe_screen_test.dart)
5. **Otimizar queries** (adicionar geolocalização)

---

## 📞 SUPORTE

Se encontrar problemas:
1. Copie os logs do terminal Flutter
2. Verifique Firebase Console (Firestore + Functions)
3. Me envie prints das telas e logs

**Boa sorte com os testes! 🚀**
