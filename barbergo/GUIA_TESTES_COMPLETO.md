# 🧪 GUIA COMPLETO DE TESTES - BARBERGO PREMIUM

**Data:** 01/11/2025  
**Objetivo:** Validar sistema completo (Cloud Functions + Stripe + Analytics)

---

## ✅ STATUS DAS CLOUD FUNCTIONS

**Deployadas corretamente:**
- ✅ sendMatchNotification (Firestore onCreate matches)
- ✅ checkExpiredBoosts (scheduled every 5 min)
- ✅ checkExpiringSubscriptions (scheduled daily)
- ✅ sendCustomNotification (callable)
- ✅ stripeWebhook (HTTPS v1 - funcionando)

**Com problema (trigger HTTPS em vez de Firestore):**
- ❌ sendSuperLikeNotification → Deveria ser onCreate swipes
- ❌ sendBoostActivatedNotification → Deveria ser onUpdate profiles
- ❌ sendSubscriptionRenewedNotification → Deveria ser onUpdate profiles

**Ação:** Deploy em andamento para corrigir...

---

## 🧪 TESTE 1: STRIPE CHECKOUT (CRÍTICO!)

### **Pré-requisitos:**
- [ ] App rodando no emulador/dispositivo
- [ ] Usuário logado no app
- [ ] Conexão com internet

### **Passo a passo:**

#### **1. Abrir Premium Screen:**
```
1. Abra o app
2. Faça login (se necessário)
3. Navegue para: Menu → Premium
   OU
   Clique no botão "Upgrade Premium" na tela principal
```

#### **2. Selecionar Plano:**
```
Você verá 2 opções:
- Premium Mensal: R$ 19,90/mês
- Premium Anual: R$ 191,04/ano (MAIS POPULAR)
```

Clique em **"Assinar"** ou **"Escolher Plano"**

#### **3. Checkout Stripe:**
```
O app vai abrir o navegador com a página de checkout do Stripe.

Preencha com o TESTCARD:
┌─────────────────────────────────────┐
│ Número do cartão: 4242 4242 4242 4242
│ Data: 12/25 (ou qualquer data futura)
│ CVC: 123 (ou qualquer 3 dígitos)
│ CEP: 12345 (ou qualquer número)
│ Nome: Seu Nome
└─────────────────────────────────────┘
```

**Importante:** Use EXATAMENTE `4242 4242 4242 4242` (é um cartão de teste do Stripe)

#### **4. Completar Pagamento:**
```
1. Clique em "Subscribe" ou "Pagar"
2. Aguarde 2-5 segundos
3. Você será redirecionado de volta ao app
```

### **✅ Verificar se Funcionou:**

#### **A) No Stripe Dashboard:**
```
1. Acesse: https://dashboard.stripe.com/test/events
2. Deve aparecer eventos recentes:
   ✅ customer.subscription.created
   ✅ invoice.payment_succeeded
3. Clique no evento para ver detalhes
```

#### **B) No Firestore:**
```
1. Acesse: https://console.firebase.google.com/project/barbergo-38c21/firestore
2. Navegue: profiles → [seu_user_id]
3. Verifique os campos:
   ✅ isPremium: true
   ✅ premiumExpiresAt: [data futura]
   ✅ stripeCustomerId: cus_...
   ✅ canSeeWhoLiked: true
   ✅ superLikesRemaining: -1 (ilimitado)
```

#### **C) No App:**
```
1. Volte para Premium Screen
2. Deve aparecer:
   ✅ "Você já é Premium!" 
   ✅ Badge dourado no perfil
   ✅ Super Likes ilimitados
```

#### **D) Logs Cloud Function:**
```powershell
firebase functions:log --only stripeWebhook --limit 10
```

Deve aparecer:
```
✅ Received Stripe event: customer.subscription.created
📝 Updating subscription: sub_... for customer: cus_...
✅ Subscription sub_... updated for user [user_id]
📬 Notification sent to user [user_id]
```

### **⚠️ Se der erro:**

**Erro 1: "Checkout URL is null"**
```
Causa: Stripe não conseguiu criar sessão
Solução: Verificar se STRIPE_SECRET_KEY está configurada
```

**Erro 2: "Payment failed"**
```
Causa: Cartão inválido ou problema no Stripe
Solução: Usar exatamente 4242 4242 4242 4242
```

**Erro 3: "isPremium não atualizado"**
```
Causa: stripeWebhook não recebeu evento
Solução: 
1. Verificar webhook configurado no Stripe
2. Verificar URL: https://us-central1-barbergo-38c21.cloudfunctions.net/stripeWebhook
3. Ver logs: firebase functions:log --only stripeWebhook
```

---

## 🧪 TESTE 2: ANALYTICS

### **Objetivo:** Verificar se eventos estão sendo rastreados

### **Passo a passo:**

#### **1. Habilitar DebugView:**
```powershell
# Android
adb shell setprop debug.firebase.analytics.app com.barbergo.app

# iOS (não necessário - já ativado no debug)
```

#### **2. Acessar DebugView:**
```
https://console.firebase.google.com/project/barbergo-38c21/analytics/app/android:com.barbergo.app/debugview
```

Deve aparecer seu dispositivo com eventos em tempo real

#### **3. Testar Eventos:**

**Evento 1: premium_screen_viewed**
```
1. No app, navegue para Premium Screen
2. No DebugView, deve aparecer:
   ✅ premium_screen_viewed
   - source: navigation
```

**Evento 2: checkout_started**
```
1. Clique em "Assinar Mensal" ou "Assinar Anual"
2. No DebugView, deve aparecer:
   ✅ checkout_started
   - plan: monthly ou yearly
   - price: 19.90 ou 191.04
```

**Evento 3: super_like_used**
```
1. Na tela de discovery, use Super Like
2. No DebugView, deve aparecer:
   ✅ super_like_used
   - targetId: [user_id]
   - superLikesRemaining: número
   - isPremium: true/false
```

**Evento 4: boost_activated**
```
1. Ative um boost
2. No DebugView, deve aparecer:
   ✅ boost_activated
   - boostsRemaining: número
   - source: button
```

### **✅ Verificar User Properties:**

No DebugView, verifique:
```
User Properties:
✅ is_premium: true/false
✅ subscription_plan: monthly/yearly
✅ super_likes_remaining: número
✅ boosts_remaining: número
```

### **⚠️ Se não aparecer eventos:**

```
1. Verificar se DebugView está no dispositivo correto
2. Verificar se firebase_analytics está habilitado no main.dart
3. Verificar logs: flutter run --verbose
4. Aguardar até 5 minutos (eventos podem demorar)
```

---

## 🧪 TESTE 3: NOTIFICAÇÕES (OPCIONAL)

### **Como testar sem FCM token:**

#### **Método 1: Trigger via Firestore**
```
1. Acesse: https://console.firebase.google.com/project/barbergo-38c21/firestore
2. Navegue: profiles → [seu_user_id]
3. Adicione campo: fcmToken (copiar do Firestore se já existe)
4. Criar documento em swipes:
   {
     "fromUserId": "outro_user_id",
     "toUserId": "[seu_user_id]",
     "liked": true,
     "isSuperLike": true,
     "createdAt": Timestamp.now()
   }
5. Verificar logs: firebase functions:log
```

#### **Método 2: Via código (mais simples)**
```dart
// No app, adicione temporariamente:
import 'package:firebase_messaging/firebase_messaging.dart';

// No initState ou onPressed de qualquer botão:
final token = await FirebaseMessaging.instance.getToken();
print('FCM Token: $token');

// Copie o token do console e use no Firebase Console
```

---

## 📊 CHECKLIST FINAL

### **Cloud Functions:**
- [ ] stripeWebhook funcionando (v1 HTTPS)
- [ ] sendMatchNotification deployado (v2 Firestore)
- [ ] checkExpiredBoosts deployado (v2 scheduled)
- [ ] Outras 3 functions corrigidas (aguardando deploy)

### **Stripe:**
- [ ] Checkout abre corretamente
- [ ] Pagamento processado com testcard 4242
- [ ] Webhook recebe eventos (ver Stripe Dashboard)
- [ ] isPremium atualizado no Firestore
- [ ] Notificação enviada ao usuário

### **Analytics:**
- [ ] DebugView habilitado
- [ ] premium_screen_viewed rastreado
- [ ] checkout_started rastreado
- [ ] super_like_used rastreado
- [ ] boost_activated rastreado
- [ ] User properties atualizadas

### **Notificações (Opcional):**
- [ ] FCM token obtido
- [ ] Notificação manual enviada (Firebase Console)
- [ ] Notificação automática (via Firestore trigger)

---

## 🚀 PRÓXIMOS PASSOS

**Depois dos testes:**
1. ✅ Corrigir problemas encontrados
2. ✅ Configurar produtos reais no Stripe (produção)
3. ✅ Configurar webhook de produção
4. ✅ Deploy final em produção
5. ✅ Monitorar métricas (conversão, retenção, receita)

---

## 📞 COMANDOS ÚTEIS

```powershell
# Ver logs em tempo real
firebase functions:log

# Ver logs de função específica
firebase functions:log --only stripeWebhook

# Listar functions
firebase functions:list

# Testar function localmente
firebase emulators:start --only functions

# Ver eventos Stripe
# https://dashboard.stripe.com/test/events

# Ver Analytics DebugView
# https://console.firebase.google.com/project/barbergo-38c21/analytics/debugview
```

---

**🎯 FOCO AGORA:** Testar Stripe Checkout!
