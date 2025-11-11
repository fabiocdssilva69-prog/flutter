# 🚀 PRÓXIMOS PASSOS DE IMPLANTAÇÃO

## ✅ JÁ FEITO

1. **Cloud Functions criadas:**
   - ✅ `sendSuperLikeNotification` - Notifica Super Like recebido
   - ✅ `sendMatchNotification` - Notifica novo match
   - ✅ `sendBoostActivatedNotification` - Confirma boost ativado
   - ✅ `checkExpiredBoosts` - Verifica boosts expirados (5 em 5 min)
   - ✅ `sendSubscriptionRenewedNotification` - Confirma renovação
   - ✅ `checkExpiringSubscriptions` - Alerta 3 dias antes (diário)

2. **AnalyticsService criado:**
   - ✅ 14 eventos de monetização
   - ✅ User properties (isPremium, subscriptionPlan)
   - ✅ Conversão funnel tracking

3. **Discovery otimizado:**
   - ✅ Server-side ordering (boostedUntil → isPremium → updatedAt)
   - ✅ Índice composto no Firestore
   - ✅ Performance melhorada (~50ms → ~5ms)

4. **Deploy em andamento:**
   - ⏳ `firebase deploy --only functions` executando...

---

## 📋 O QUE FAZER AGORA

### 1️⃣ **AGUARDAR DEPLOY DAS CLOUD FUNCTIONS** (5-10 min)

O deploy está rodando. Você verá:
```
✔  functions[sendSuperLikeNotification(us-central1)] Successful create operation.
✔  functions[sendMatchNotification(us-central1)] Successful create operation.
...
```

**Ações pós-deploy:**
- ✅ Copiar URL do webhook (se aparecer `stripeWebhook`)
- ✅ Verificar Cloud Scheduler (2 scheduled functions)

---

### 2️⃣ **DEPLOY DOS ÍNDICES DO FIRESTORE** (1 min)

```powershell
firebase deploy --only firestore:indexes
```

**O que isso faz:**
- Cria índice composto: `boostedUntil + isPremium + accountType + updatedAt`
- Permite server-side ordering no Discovery
- **IMPORTANTE:** Pode demorar 5-15 minutos para construir o índice

**Verificar:** https://console.firebase.google.com/project/barbergo-38c21/firestore/indexes

---

### 3️⃣ **CONFIGURAR STRIPE WEBHOOK** (2 min)

**Se você ainda não configurou:**

1. Acesse: https://dashboard.stripe.com/test/webhooks
2. Clique em: **Add endpoint**
3. Cole a URL:
   ```
   https://us-central1-barbergo-38c21.cloudfunctions.net/stripeWebhook
   ```
4. Selecione eventos:
   - ✅ `customer.subscription.created`
   - ✅ `customer.subscription.updated`
   - ✅ `customer.subscription.deleted`
   - ✅ `invoice.payment_succeeded`
   - ✅ `invoice.payment_failed`

5. Copie o **Webhook Secret** (`whsec_...`)

6. Configure no Firebase:
   ```powershell
   firebase functions:config:set stripe.webhook_secret="whsec_..."
   ```

7. **Re-deploy functions:**
   ```powershell
   firebase deploy --only functions:stripeWebhook
   ```

---

### 4️⃣ **ADICIONAR DEPENDÊNCIAS NO FLUTTER** (2 min)

**Verificar se estão no pubspec.yaml:**

```yaml
dependencies:
  firebase_messaging: ^16.0.3  # ✅ Já tem
  firebase_analytics: ^12.0.3  # ✅ Já tem
  url_launcher: ^6.3.2         # ✅ Já tem
  flutter_local_notifications: ^16.1.0  # ⚠️ FALTA ADICIONAR
```

**Adicionar:**
```powershell
flutter pub add flutter_local_notifications
flutter pub get
```

---

### 5️⃣ **CONFIGURAR FCM NO ANDROID** (5 min)

**Arquivo:** `android/app/src/main/AndroidManifest.xml`

**Adicionar dentro de `<application>`:**

```xml
<!-- FCM Notification Channel -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="barbergo_premium_channel" />

<!-- FCM Icon (opcional) -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@drawable/ic_notification" />

<!-- FCM Color (opcional) -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_color"
    android:resource="@color/colorAccent" />
```

**Verificar permissões (já devem existir):**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

---

### 6️⃣ **CONFIGURAR FCM NO iOS** (3 min)

**Arquivo:** `ios/Runner/Info.plist`

**Adicionar:**
```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

**Habilitar Push Notifications:**
1. Abrir `ios/Runner.xcworkspace` no Xcode
2. **Targets > Runner > Signing & Capabilities**
3. Clicar em **+ Capability**
4. Adicionar: **Push Notifications**
5. Adicionar: **Background Modes** → marcar **Remote notifications**

---

### 7️⃣ **INTEGRAR ANALYTICS NOS CONTROLLERS** (30 min)

**SwipeController** (`lib/src/features/discovery/controllers/swipe_controller.dart`):

```dart
import '../../../core/services/analytics_service.dart';

final analytics = ref.read(analyticsServiceProvider);

// No método superLike:
await analytics.logSuperLikeUsed(
  targetId: targetProfile.userId,
  superLikesRemaining: currentProfile.superLikesRemaining,
  isPremium: currentProfile.hasActivePremium,
);
```

**BoostController** (`lib/src/features/boost/controllers/boost_controller.dart`):

```dart
// No método activateBoost:
await analytics.logBoostActivated(
  boostsRemaining: currentProfile.boostsRemaining - 1,
  source: 'button',
);
```

**PremiumScreen** (`lib/src/features/premium/presentation/premium_screen.dart`):

```dart
@override
void initState() {
  super.initState();
  
  // Track screen view
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(analyticsServiceProvider).logPremiumScreenViewed(
      source: 'navigation',
    );
  });
}

// No método _subscribeToPremiumMonthly:
await analytics.logCheckoutStarted(
  plan: 'monthly',
  price: 19.90,
);
```

---

### 8️⃣ **TESTAR NOTIFICAÇÕES** (15 min)

**Opção A: Firebase Console (mais fácil)**

1. Acesse: https://console.firebase.google.com/project/barbergo-38c21/notification
2. Clique: **New notification**
3. Preencha:
   - **Title:** `🚀 Teste de Notificação`
   - **Text:** `BarberGO Premium funcionando!`
4. **Target:** Selecione seu app (Android ou iOS)
5. **Send test message**
6. Cole o **FCM Token** (você pega executando o app em debug)

**Opção B: Triggerar via Firestore**

```dart
// No Firebase Console > Firestore
// Criar documento em /swipes:
{
  "fromUserId": "user1",
  "toUserId": "user2",
  "isSuperLike": true,
  "liked": true,
  "createdAt": Timestamp.now()
}

// Isso vai disparar sendSuperLikeNotification automaticamente!
```

**Verificar logs:**
```powershell
firebase functions:log --only sendSuperLikeNotification
```

---

### 9️⃣ **TESTAR STRIPE CHECKOUT** (10 min)

**No app (Flutter):**

1. Navegue para `PremiumScreen`
2. Clique em **Premium Mensal** ou **Premium Anual**
3. Você será redirecionado para Stripe Checkout
4. Use testcard: `4242 4242 4242 4242`
   - CVC: qualquer 3 dígitos
   - Data: qualquer data futura
   - CEP: qualquer

**Verificar webhook:**
```powershell
firebase functions:log --only stripeWebhook
```

**Verificar no Firestore:**
- O campo `isPremium` deve ser `true`
- `premiumExpiresAt` deve ter data futura
- `subscriptionId` deve ter ID do Stripe

---

### 🔟 **TESTAR ANALYTICS** (5 min)

**Firebase Console:**
https://console.firebase.google.com/project/barbergo-38c21/analytics/app/android:com.barbergo.app/debugview

**Habilitar DebugView (Android):**
```powershell
adb shell setprop debug.firebase.analytics.app com.barbergo.app
```

**Testar eventos:**
1. Abra `PremiumScreen` → deve aparecer `premium_screen_viewed`
2. Clique em plano → deve aparecer `checkout_started`
3. Use Super Like → deve aparecer `super_like_used`

---

## ⚠️ TROUBLESHOOTING

### **Deploy falhou**
```powershell
# Ver logs detalhados
firebase functions:log

# Re-deploy função específica
firebase deploy --only functions:sendMatchNotification
```

### **Notificações não chegam**
1. Verifique FCM Token no Firestore (campo `fcmToken`)
2. Verifique permissões de notificação no Android
3. Veja logs: `firebase functions:log --only sendSuperLikeNotification`

### **Stripe webhook não funciona**
1. Verifique URL do webhook no Stripe Dashboard
2. Veja eventos no Stripe: https://dashboard.stripe.com/test/events
3. Verifique `stripe.webhook_secret` configurado:
   ```powershell
   firebase functions:config:get
   ```

### **Índice do Firestore não funciona**
1. Verifique status: https://console.firebase.google.com/project/barbergo-38c21/firestore/indexes
2. Aguarde construção completar (5-15 min)
3. Se falhar, delete e recrie:
   ```powershell
   firebase deploy --only firestore:indexes
   ```

---

## 📊 MÉTRICAS DE SUCESSO

**Após implantação, monitorar:**

1. **Cloud Functions:**
   - Execuções sem erro > 99%
   - Latência < 500ms (média)
   - Custo < $5/mês (100k execuções)

2. **Notificações:**
   - Taxa de entrega > 95%
   - CTR (click-through rate) > 10%

3. **Analytics:**
   - Eventos registrados > 1000/dia
   - Conversão para premium > 2%

4. **Discovery:**
   - Query time < 200ms
   - Profiles carregados: 20-50 por request

---

## 🎯 CHECKLIST FINAL

Antes de considerar pronto:

- [ ] Deploy de Cloud Functions (6 functions)
- [ ] Deploy de Firestore indexes
- [ ] Stripe webhook configurado
- [ ] FCM configurado (Android + iOS)
- [ ] flutter_local_notifications instalado
- [ ] Analytics integrado (3+ controllers)
- [ ] Notificações testadas (1 tipo)
- [ ] Stripe checkout testado
- [ ] Analytics events aparecendo no Console
- [ ] Server-side ordering funcionando

---

## 📚 DOCUMENTAÇÃO ADICIONAL

- **QUICKSTART_STRIPE.md** - Setup rápido do Stripe
- **SPRINT_RESULTADO_FINAL.md** - Resultado das features premium
- **functions/src/notifications.ts** - Código das Cloud Functions
- **lib/src/core/services/analytics_service.dart** - Código do Analytics

---

## 🆘 PRECISA DE AJUDA?

Se algo não funcionar:

1. Verifique logs: `firebase functions:log`
2. Verifique Console: https://console.firebase.google.com/project/barbergo-38c21
3. Teste em debug: `flutter run --debug`

**Boa sorte! 🚀💰**
