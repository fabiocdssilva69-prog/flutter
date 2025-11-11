# 🚀 FIREBASE SETUP - COMANDOS RÁPIDOS

**Data:** 1 de Novembro de 2025  
**Status:** Fase 1 concluída (Firestore Rules + Collections)  
**Próximo:** Automatizar índices, Cloud Functions e Stripe

---

## ✅ JÁ CONCLUÍDO (FASE 1)

```
✅ Firestore Rules publicadas
✅ 4 Collections criadas com documentos exemplo:
   - subscriptions
   - super_likes
   - daily_limits
   - boost_activations
```

---

## 🎯 OPÇÃO ESCOLHIDA: SETUP AUTOMÁTICO

Execute o script PowerShell que vai guiar você por todas as etapas:

```powershell
.\firebase_setup_automated.ps1
```

**O script vai:**
1. ✅ Criar os 8 índices compostos (via `firestore.indexes.json`)
2. 🔐 Configurar environment variables do Stripe
3. ☁️ Deploy das 3 Cloud Functions
4. 🔌 Instalar Firebase Extension (Stripe Payments)
5. 🔍 Verificação final de tudo

**Tempo estimado:** 30-40 minutos (interativo)

---

## 📋 ARQUIVOS CRIADOS PARA AUTOMAÇÃO

### 1. `firestore.indexes.json`
Contém todos os 8 índices compostos necessários:
- subscriptions (2 índices)
- super_likes (2 índices)
- daily_limits (1 índice)
- boost_activations (2 índices)
- swipes (1 índice)

**Importar automaticamente:**
```bash
firebase firestore:indexes --import firestore.indexes.json
```

---

### 2. `functions/package.json`
Dependências das Cloud Functions:
- firebase-admin ^12.0.0
- firebase-functions ^4.6.0
- stripe ^14.11.0

**Instalar:**
```bash
cd functions
npm install
```

---

### 3. `functions/index.js`
**3 Cloud Functions implementadas:**

#### 📌 Function 1: `stripeWebhook` (HTTPS)
- Escuta eventos do Stripe
- Atualiza `subscriptions` collection
- Sincroniza flag `isPremium` no profile
- Eventos tratados:
  * `customer.subscription.created`
  * `customer.subscription.updated`
  * `customer.subscription.deleted`
  * `invoice.payment_succeeded`
  * `invoice.payment_failed`

#### 📌 Function 2: `checkExpiredSubscriptions` (Cron: 6h)
- Busca assinaturas expiradas (`status=active` && `expiresAt < now`)
- Marca como `expired`
- Remove flag premium do profile
- Executa a cada 6 horas

#### 📌 Function 3: `resetDailyLimits` (Cron: daily)
- Checkpoint de logging
- Daily limits expiram automaticamente pelo campo `date`
- Executa à meia-noite

**Deploy:**
```bash
firebase deploy --only functions
```

---

## 🔐 CONFIGURAR STRIPE KEYS

### Obter Keys do Stripe Dashboard:

1. Acesse: https://dashboard.stripe.com/test/apikeys
2. Copie:
   - **Secret Key** (sk_test_... ou sk_live_...)
   - **Publishable Key** (pk_test_... ou pk_live_...)
3. Vá em: Developers > Webhooks > Add endpoint
4. Copie o **Webhook Secret** (whsec_...)

### Configurar no Firebase:

```bash
firebase functions:config:set stripe.secret_key="sk_test_..."
firebase functions:config:set stripe.webhook_secret="whsec_..."
firebase functions:config:set stripe.publishable_key="pk_test_..."

firebase functions:config:set app.name="BarberGO"
firebase functions:config:set app.url="https://barbergo.app"
firebase functions:config:set app.support_email="suporte@barbergo.app"
```

**Verificar configuração:**
```bash
firebase functions:config:get
```

---

## 🔌 INSTALAR FIREBASE EXTENSION

### Run Payments with Stripe

```bash
firebase ext:install stripe/firestore-stripe-payments
```

**Configuração interativa:**
- Products collection: `products`
- Customer collection: `customers`
- Sync new users: `Yes`
- Delete Stripe customers: `No`

---

## 🧪 TESTAR LOCALMENTE

### 1. Emulator Suite (Functions + Firestore)

```bash
firebase emulators:start
```

**Acessar:**
- Firestore UI: http://localhost:4000
- Functions logs: http://localhost:4000/logs

### 2. Testar Webhook com Stripe CLI

**Instalar Stripe CLI:**
```bash
# Windows (via Scoop)
scoop install stripe

# Ou download: https://github.com/stripe/stripe-cli/releases
```

**Login:**
```bash
stripe login
```

**Forward webhook para local:**
```bash
stripe listen --forward-to http://localhost:5001/barbergo-project-id/us-central1/stripeWebhook
```

**Disparar evento de teste:**
```bash
stripe trigger customer.subscription.created
```

---

## 📊 CRIAR PRODUTOS NO STRIPE

### Via Dashboard:

1. Acesse: https://dashboard.stripe.com/test/products
2. Clique em "Add product"
3. Crie 4 produtos:

#### Produto 1: Premium Monthly
- Name: `BarberGO Premium - Mensal`
- Description: `Acesso completo a todas features premium`
- Price: `R$ 19,90`
- Billing period: `Monthly`
- Currency: `BRL`

#### Produto 2: Premium Yearly
- Name: `BarberGO Premium - Anual`
- Description: `12 meses com desconto (economize 20%)`
- Price: `R$ 191,04` (20% off)
- Billing period: `Yearly`
- Currency: `BRL`

#### Produto 3: Boosts Pack
- Name: `5 Boosts`
- Description: `Apareça no topo por 30 minutos (5x)`
- Price: `R$ 9,90`
- Type: `One-time`
- Currency: `BRL`

#### Produto 4: Super Likes Pack
- Name: `10 Super Likes`
- Description: `Destaque-se com super likes extras`
- Price: `R$ 8,90`
- Type: `One-time`
- Currency: `BRL`

### Via Stripe CLI (mais rápido):

```bash
# Premium Monthly
stripe products create \
  --name "BarberGO Premium - Mensal" \
  --description "Acesso completo a todas features premium"

stripe prices create \
  --product {product_id} \
  --unit-amount 1990 \
  --currency brl \
  --recurring[interval]=month

# Premium Yearly
stripe products create \
  --name "BarberGO Premium - Anual" \
  --description "12 meses com desconto (economize 20%)"

stripe prices create \
  --product {product_id} \
  --unit-amount 19104 \
  --currency brl \
  --recurring[interval]=year

# Boosts Pack
stripe products create \
  --name "5 Boosts" \
  --description "Apareça no topo por 30 minutos (5x)"

stripe prices create \
  --product {product_id} \
  --unit-amount 990 \
  --currency brl

# Super Likes Pack
stripe products create \
  --name "10 Super Likes" \
  --description "Destaque-se com super likes extras"

stripe prices create \
  --product {product_id} \
  --unit-amount 890 \
  --currency brl
```

---

## 🌐 CONFIGURAR WEBHOOK ENDPOINT (PRODUÇÃO)

1. Acesse: https://dashboard.stripe.com/test/webhooks
2. Clique em "Add endpoint"
3. URL: `https://us-central1-{seu-project-id}.cloudfunctions.net/stripeWebhook`
4. Events to send:
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_succeeded`
   - `invoice.payment_failed`
5. Copie o **Webhook Secret** (whsec_...)
6. Configure no Firebase:
```bash
firebase functions:config:set stripe.webhook_secret="whsec_..."
firebase deploy --only functions
```

---

## 🔒 CONFIGURAR API KEY RESTRICTIONS

### Firebase Console:

1. Project Settings > General
2. Scroll até "Your apps" > Web app
3. Clique em "API Keys"
4. Adicione restrições:

**Web API Key:**
- Application restrictions: HTTP referrers
- Website restrictions:
  * `barbergo.app/*`
  * `*.barbergo.app/*`
  * `localhost:*` (apenas dev)

**Android API Key:**
- Application restrictions: Android apps
- Package name: `com.barbergo.app`
- SHA-1: (do seu keystore)

**iOS API Key:**
- Application restrictions: iOS apps
- Bundle ID: `com.barbergo.app`

---

## 📱 CONFIGURAR FCM (PUSH NOTIFICATIONS)

1. Firebase Console > Project Settings > Cloud Messaging
2. Copie o **Server Key**
3. Configure no Firebase:
```bash
firebase functions:config:set notifications.fcm_server_key="..."
```

4. Ativar Firebase Cloud Messaging API:
   - Google Cloud Console > APIs & Services
   - Enable "Firebase Cloud Messaging API"

---

## 📈 CONFIGURAR FIREBASE ANALYTICS

1. Firebase Console > Analytics
2. Ativar Google Analytics
3. Criar 12 custom events (já implementados no código):

**Premium events:**
- `premium_screen_viewed`
- `premium_upsell_shown`
- `subscription_started`
- `subscription_canceled`

**Super Like events:**
- `super_like_sent`
- `super_like_received`
- `super_like_limit_reached`

**Likes screen events:**
- `likes_screen_viewed`
- `like_back_pressed`
- `likes_paywall_shown`

**Boost events:**
- `boost_activated`
- `boost_purchase`

---

## ✅ CHECKLIST FINAL

### Firestore:
- [x] Rules publicadas
- [x] 4 collections criadas
- [ ] 8 índices criados (via script)

### Cloud Functions:
- [ ] `stripeWebhook` deployed
- [ ] `checkExpiredSubscriptions` deployed (cron)
- [ ] `resetDailyLimits` deployed (cron)
- [ ] Environment variables configuradas

### Stripe:
- [ ] Conta criada/conectada
- [ ] 4 produtos criados
- [ ] Webhook endpoint configurado
- [ ] API keys obtidas
- [ ] Firebase Extension instalada

### Notificações:
- [ ] FCM Server Key configurado
- [ ] Firebase Cloud Messaging API habilitada

### Segurança:
- [ ] API Key restrictions configuradas (web, Android, iOS)
- [ ] App Check ativado (opcional)

### Analytics:
- [ ] Google Analytics ativado
- [ ] Custom events configurados

---

## 🚀 EXECUTAR SETUP AUTOMÁTICO AGORA

```powershell
.\firebase_setup_automated.ps1
```

**O script vai guiar você por todas as etapas restantes!**

---

## 💡 COMANDOS ÚTEIS

### Ver logs das Cloud Functions:
```bash
firebase functions:log
```

### Ver configuração atual:
```bash
firebase functions:config:get
```

### Testar function localmente:
```bash
firebase functions:shell
```

### Deploy apenas uma function:
```bash
firebase deploy --only functions:stripeWebhook
```

### Verificar status dos índices:
```bash
firebase firestore:indexes
```

### Deletar configuração:
```bash
firebase functions:config:unset stripe.secret_key
```

---

## 📞 TROUBLESHOOTING

### Problema: Webhook não recebe eventos
**Solução:**
1. Verificar URL no Stripe Dashboard
2. Verificar webhook secret nas env vars
3. Testar localmente com `stripe listen`

### Problema: Function timeout
**Solução:**
1. Aumentar timeout no `functions/index.js`:
```javascript
exports.stripeWebhook = functions
  .runWith({ timeoutSeconds: 120 })
  .https.onRequest(...)
```

### Problema: Rules negam acesso
**Solução:**
1. Testar no Firebase Console > Firestore > Rules > Playground
2. Verificar se usuário está autenticado
3. Verificar se campo `isPremium` está correto

---

## 🎉 RESULTADO ESPERADO

Após executar o script de automação, você terá:

✅ Firebase 100% configurado para premium features  
✅ Stripe integrado e funcionando  
✅ Cloud Functions rodando em produção  
✅ Notificações push configuradas  
✅ Analytics rastreando tudo  
✅ Segurança robusta (rules + restrictions)  

**Pronto para começar a implementação Flutter! 🚀**
