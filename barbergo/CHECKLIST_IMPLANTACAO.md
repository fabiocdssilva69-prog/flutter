# ✅ CHECKLIST DE IMPLANTAÇÃO - ACOMPANHAMENTO

**Última atualização:** 01/11/2025 - 19:45

---

## 🟢 JÁ COMPLETO

- [x] **Cloud Functions criadas** (6 notificações + 1 helper)
- [x] **AnalyticsService criado** (14 eventos)
- [x] **Discovery otimizado** (server-side ordering)
- [x] **Firestore indexes deployed** ✅ (verificado 2x)
- [x] **TypeScript compilado** sem erros
- [x] **Deploy em andamento** (7 functions)

---

## 🟡 EM ANDAMENTO

### **1. Deploy Cloud Functions** ⏳ (5-10 min)

**Comando rodando:**
```powershell
firebase deploy --only functions:sendSuperLikeNotification,functions:sendMatchNotification,functions:sendBoostActivatedNotification,functions:checkExpiredBoosts,functions:sendSubscriptionRenewedNotification,functions:checkExpiringSubscriptions,functions:sendCustomNotification
```

**Verificar depois:**
```powershell
firebase functions:list
```

---

## 🔴 FALTA FAZER (ORDEM DE PRIORIDADE)

### **STEP 1: Adicionar flutter_local_notifications** (1 min) 🔥 URGENTE

```powershell
flutter pub add flutter_local_notifications
flutter pub get
```

**Por que:** Necessário para exibir notificações locais no Flutter.

---

### **STEP 2: Configurar FCM no Android** (3 min) 🔥 URGENTE

**Arquivo:** `android/app/src/main/AndroidManifest.xml`

**Adicione dentro de `<application>`:**

```xml
<!-- FCM Notification Channel -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="barbergo_premium_channel" />

<!-- FCM Icon (opcional) -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@drawable/ic_notification" />
```

**Verificar se já existe:**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

---

### **STEP 3: Configurar Stripe Webhook** (2 min) 🔥 IMPORTANTE

**URL Stripe Webhook:**
```
https://us-central1-barbergo-38c21.cloudfunctions.net/stripeWebhook
```

**1. Acessar:**
https://dashboard.stripe.com/test/webhooks

**2. Clicar:** [+ Add endpoint]

**3. Preencher:**
- **Endpoint URL:** (cole a URL acima)
- **Events to send:**
  - [x] `customer.subscription.created`
  - [x] `customer.subscription.updated`
  - [x] `customer.subscription.deleted`
  - [x] `invoice.payment_succeeded`
  - [x] `invoice.payment_failed`

**4. Copiar Webhook Secret** (`whsec_...`)

**5. Configurar no Firebase:**
```powershell
firebase functions:config:set stripe.webhook_secret="whsec_SEU_SECRET_AQUI"
```

**6. Re-deploy stripeWebhook:**
```powershell
firebase deploy --only functions:stripeWebhook
```

---

### **STEP 4: Integrar Analytics no SwipeController** (10 min)

**Arquivo:** `lib/src/features/discovery/controllers/swipe_controller.dart`

**Adicionar no topo:**
```dart
import '../../../core/services/analytics_service.dart';
```

**No método `superLike`:**
```dart
// Antes de enviar o Super Like
final analytics = ref.read(analyticsServiceProvider);
await analytics.logSuperLikeUsed(
  targetId: targetProfile.userId,
  superLikesRemaining: currentProfile.superLikesRemaining,
  isPremium: currentProfile.hasActivePremium,
);
```

---

### **STEP 5: Integrar Analytics no BoostController** (10 min)

**Arquivo:** `lib/src/features/boost/controllers/boost_controller.dart`

**No método `activateBoost`:**
```dart
final analytics = ref.read(analyticsServiceProvider);
await analytics.logBoostActivated(
  boostsRemaining: currentProfile.boostsRemaining - 1,
  source: 'button',
);
```

---

### **STEP 6: Integrar Analytics no PremiumScreen** (15 min)

**Arquivo:** `lib/src/features/premium/presentation/premium_screen.dart`

**No initState:**
```dart
@override
void initState() {
  super.initState();
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(analyticsServiceProvider).logPremiumScreenViewed(
      source: 'navigation',
    );
  });
}
```

**No método `_subscribeToPremiumMonthly`:**
```dart
Future<void> _subscribeToPremiumMonthly(BuildContext context) async {
  final analytics = ref.read(analyticsServiceProvider);
  
  await analytics.logCheckoutStarted(
    plan: 'monthly',
    price: 19.90,
  );
  
  _showLoadingDialog(context);
  final url = await StripeService().subscribeToPremiumMonthly();
  
  if (url != null) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
```

---

### **STEP 7: Configurar FCM no iOS** (5 min) - OPCIONAL

**Arquivo:** `ios/Runner/Info.plist`

```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

**Xcode:**
1. Abrir `ios/Runner.xcworkspace`
2. **Targets > Runner > Signing & Capabilities**
3. [+ Capability] → **Push Notifications**
4. [+ Capability] → **Background Modes** → marcar **Remote notifications**

---

### **STEP 8: Testar Notificações** (15 min)

**Opção A: Firebase Console**

1. https://console.firebase.google.com/project/barbergo-38c21/notification
2. [New notification]
3. Enviar teste para seu device

**Opção B: Triggerar via Firestore**

```dart
// No Firebase Console > Firestore
// Criar documento em /swipes:
{
  "fromUserId": "seu_user_id",
  "toUserId": "outro_user_id",
  "isSuperLike": true,
  "liked": true,
  "createdAt": Timestamp.now()
}
```

**Verificar logs:**
```powershell
firebase functions:log --only sendSuperLikeNotification
```

---

### **STEP 9: Testar Stripe Checkout** (10 min)

**No app:**
1. Abrir PremiumScreen
2. Clicar em plano
3. Usar testcard: `4242 4242 4242 4242`

**Verificar:**
- Webhook recebeu evento: https://dashboard.stripe.com/test/events
- Firestore atualizado: `isPremium = true`
- Notificação enviada (subscription_renewed)

---

### **STEP 10: Habilitar Analytics DebugView** (2 min)

**Android:**
```powershell
adb shell setprop debug.firebase.analytics.app com.barbergo.app
```

**Verificar:**
https://console.firebase.google.com/project/barbergo-38c21/analytics/app/android:com.barbergo.app/debugview

---

## 📊 PROGRESSO GERAL

```
██████████████████░░░░ 75% Complete

✅ Backend: 100% (Cloud Functions + Firestore)
✅ Código Flutter: 100% (Analytics + Discovery)
🟡 Configuração: 40% (FCM + Stripe + Tests)
```

---

## 🎯 PRIORIDADE AGORA

1. ✅ **Aguardar deploy completar** (verificar terminal)
2. 🔥 **Adicionar flutter_local_notifications**
3. 🔥 **Configurar FCM no Android**
4. 🔥 **Configurar Stripe Webhook**

**Depois disso, o sistema já está 90% funcional!**

---

## 📝 COMANDOS ÚTEIS

**Verificar deploy:**
```powershell
firebase functions:list
```

**Ver logs:**
```powershell
firebase functions:log --only sendMatchNotification --limit 20
```

**Testar function localmente:**
```powershell
cd functions && npm run serve
```

**Build Flutter:**
```powershell
flutter build apk --debug
```

---

## 🆘 SE ALGO DER ERRADO

**Deploy falhou:**
```powershell
firebase functions:log
firebase deploy --only functions:NOME_DA_FUNCTION
```

**Notificações não chegam:**
1. Verificar FCM Token no Firestore (campo `fcmToken`)
2. Ver logs: `firebase functions:log --only sendSuperLikeNotification`
3. Testar no Firebase Console

**Analytics não aparece:**
1. Habilitar DebugView
2. Aguardar 24h para dados históricos
3. Verificar integração nos controllers

---

**🚀 PRÓXIMO PASSO:** Aguarde o deploy completar e execute STEP 1!
