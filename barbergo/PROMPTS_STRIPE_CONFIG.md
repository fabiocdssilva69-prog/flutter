# 🎯 PROMPTS PRONTOS: Configurar Stripe em 5 Minutos

**COPIE E COLE ESTES COMANDOS NA ORDEM**

---

## ✅ ANTES DE COMEÇAR

Leia o arquivo: **`GUIA_OBTER_STRIPE_KEYS.md`**

Você precisa ter **3 keys** do Stripe:
- Secret Key (sk_test_...)
- Publishable Key (pk_test_...)
- Webhook Secret (whsec_...)

---

## 📋 OPÇÃO 1: CONFIGURAÇÃO RÁPIDA (1 COMANDO)

Execute o script automático que vai pedir as keys:

```powershell
.\firebase_setup_automated.ps1
```

**O script vai perguntar:**
```
Você tem as Stripe keys? (s/n)
```

**Responda:** `s`

**Depois cole suas keys quando solicitado:**
```
Stripe Secret Key (sk_...): [COLE AQUI]
Stripe Webhook Secret (whsec_...): [COLE AQUI]
Stripe Publishable Key (pk_...): [COLE AQUI]
```

✅ PRONTO! O script configura tudo automaticamente.

---

## 📋 OPÇÃO 2: CONFIGURAÇÃO MANUAL (4 COMANDOS)

### PASSO 1: Configurar Stripe Keys

```bash
firebase functions:config:set stripe.secret_key="SUA_SECRET_KEY_AQUI"
```

```bash
firebase functions:config:set stripe.webhook_secret="SEU_WEBHOOK_SECRET_AQUI"
```

```bash
firebase functions:config:set stripe.publishable_key="SUA_PUBLISHABLE_KEY_AQUI"
```

### PASSO 2: Configurar App Info

```bash
firebase functions:config:set app.name="BarberGO" app.url="https://barbergo.app" app.support_email="suporte@barbergo.app"
```

### PASSO 3: Verificar se foi configurado

```bash
firebase functions:config:get
```

**Deve mostrar:**
```json
{
  "stripe": {
    "secret_key": "sk_test_...",
    "webhook_secret": "whsec_...",
    "publishable_key": "pk_test_..."
  },
  "app": {
    "name": "BarberGO",
    "url": "https://barbergo.app",
    "support_email": "suporte@barbergo.app"
  }
}
```

✅ Se você vê isso, está configurado!

---

## 🔍 PASSO 4: CRIAR ÍNDICES FIRESTORE

```bash
firebase firestore:indexes --import firestore.indexes.json
```

✅ Aguarde 2-3 minutos (criação de índices é assíncrona)

---

## ☁️ PASSO 5: DEPLOY DAS CLOUD FUNCTIONS

### 5.1 - Instalar dependências:

```bash
cd functions
npm install
cd ..
```

### 5.2 - Fazer deploy:

```bash
firebase deploy --only functions
```

⏱️ Tempo estimado: 3-5 minutos

**Você verá algo assim:**
```
✔  functions[stripeWebhook(us-central1)] Successful create operation.
✔  functions[checkExpiredSubscriptions(us-central1)] Successful create operation.
✔  functions[resetDailyLimits(us-central1)] Successful create operation.

✔  Deploy complete!
```

✅ Copie a URL da função `stripeWebhook` que aparece no log:
```
https://us-central1-{seu-project-id}.cloudfunctions.net/stripeWebhook
```

---

## 🪝 PASSO 6: CONFIGURAR WEBHOOK NO STRIPE

### 6.1 - Acesse o Stripe Dashboard:

**Modo Teste:**
```
https://dashboard.stripe.com/test/webhooks
```

**Modo Produção (só quando estiver pronto):**
```
https://dashboard.stripe.com/webhooks
```

### 6.2 - Criar Webhook:

1. Clique em **"+ Add endpoint"**

2. **Endpoint URL:** Cole a URL da função que você copiou:
   ```
   https://us-central1-{seu-project-id}.cloudfunctions.net/stripeWebhook
   ```

3. **Description:**
   ```
   BarberGO Premium - Assinaturas e Pagamentos
   ```

4. **Events to send:** Marque estes 5 eventos:
   ```
   ✅ customer.subscription.created
   ✅ customer.subscription.updated
   ✅ customer.subscription.deleted
   ✅ invoice.payment_succeeded
   ✅ invoice.payment_failed
   ```

5. Clique em **"Add endpoint"**

6. **IMPORTANTE:** Na tela seguinte, copie o **Signing secret** (whsec_...)

7. Se você usou o webhook secret antigo, atualize:
   ```bash
   firebase functions:config:set stripe.webhook_secret="whsec_NOVO_AQUI"
   firebase deploy --only functions
   ```

---

## 🔌 PASSO 7: INSTALAR FIREBASE EXTENSION (STRIPE)

```bash
firebase ext:install stripe/firestore-stripe-payments
```

**Responda as perguntas:**

```
? What is your Stripe API secret key?
sk_test_... (cole sua Secret Key)

? What is the name of the Cloud Firestore collection where you want to store Stripe product and pricing information?
products

? What is the name of the Cloud Firestore collection where you want to store Stripe customer information?
customers

? Do you want to automatically sync new users to Stripe customer objects?
Yes

? Do you want to automatically delete Stripe customer objects when a user is deleted?
No

? Do you want to configure Stripe tax behavior?
No
```

✅ Extension instalada!

---

## 📦 PASSO 8: CRIAR PRODUTOS NO STRIPE

### Via Stripe Dashboard:

Acesse: https://dashboard.stripe.com/test/products

Crie 4 produtos clicando em **"+ Add product"**:

### Produto 1: Premium Mensal
```
Name: BarberGO Premium - Mensal
Description: Acesso completo a todas features premium
Pricing:
  - Model: Recurring
  - Price: 19.90 BRL
  - Billing period: Monthly
```

### Produto 2: Premium Anual (20% desconto)
```
Name: BarberGO Premium - Anual
Description: 12 meses com desconto (economize 20%)
Pricing:
  - Model: Recurring
  - Price: 191.04 BRL (19.90 × 12 × 0.8)
  - Billing period: Yearly
```

### Produto 3: Pack de 5 Boosts
```
Name: 5 Boosts
Description: Apareça no topo por 30 minutos (5x)
Pricing:
  - Model: One-time
  - Price: 9.90 BRL
```

### Produto 4: Pack de 10 Super Likes
```
Name: 10 Super Likes
Description: Destaque-se com super likes extras
Pricing:
  - Model: One-time
  - Price: 8.90 BRL
```

---

## 🧪 PASSO 9: TESTAR WEBHOOK (OPCIONAL)

### 9.1 - Instalar Stripe CLI:

**Windows (via Scoop):**
```powershell
scoop bucket add stripe https://github.com/stripe/scoop-stripe-cli.git
scoop install stripe
```

**Ou baixe:** https://github.com/stripe/stripe-cli/releases

### 9.2 - Login:
```bash
stripe login
```

### 9.3 - Testar evento:
```bash
stripe trigger customer.subscription.created
```

### 9.4 - Ver logs:
```bash
firebase functions:log
```

✅ Você deve ver logs da função `stripeWebhook` processando o evento.

---

## 🎯 VERIFICAÇÃO FINAL

Execute estes comandos para verificar se tudo está OK:

### Verificar configuração:
```bash
firebase functions:config:get
```

### Verificar índices:
```bash
firebase firestore:indexes
```

### Verificar functions deployed:
```bash
firebase functions:list
```

**Você deve ver:**
```
stripeWebhook (HTTPS)
checkExpiredSubscriptions (Scheduled)
resetDailyLimits (Scheduled)
```

### Ver logs em tempo real:
```bash
firebase functions:log --follow
```

---

## 🚨 TROUBLESHOOTING RÁPIDO

### Erro: "Invalid API Key"
```bash
# Verifique se copiou a key completa
firebase functions:config:get

# Se estiver errado, configure novamente
firebase functions:config:set stripe.secret_key="sk_test_NOVA_KEY"
firebase deploy --only functions
```

### Erro: "Webhook signature verification failed"
```bash
# Atualize o webhook secret
firebase functions:config:set stripe.webhook_secret="whsec_NOVO"
firebase deploy --only functions
```

### Erro: "Functions folder not found"
```bash
# Verifique se a pasta existe
ls functions

# Se não existir, o arquivo functions/index.js já foi criado
# Só falta criar package.json (já foi criado também)
```

### Ver erros das functions:
```bash
firebase functions:log --only stripeWebhook
```

---

## ✅ CHECKLIST COMPLETO

- [ ] Obtive as 3 Stripe keys (secret, publishable, webhook)
- [ ] Configurei as keys no Firebase Functions
- [ ] Criei os índices Firestore
- [ ] Fiz deploy das 3 Cloud Functions
- [ ] Configurei o webhook no Stripe Dashboard
- [ ] Instalei a Firebase Extension (Stripe Payments)
- [ ] Criei os 4 produtos no Stripe
- [ ] Testei o webhook (opcional)
- [ ] Verifiquei os logs (tudo OK)

**Se você marcou tudo, seu Firebase está 100% configurado! 🎉**

---

## 🎁 COMANDOS ÚTEIS

### Ver todas as configurações:
```bash
firebase functions:config:get
```

### Deletar uma configuração:
```bash
firebase functions:config:unset stripe.secret_key
```

### Deploy apenas uma function:
```bash
firebase deploy --only functions:stripeWebhook
```

### Ver logs de uma function específica:
```bash
firebase functions:log --only stripeWebhook --limit 50
```

### Testar function localmente:
```bash
firebase emulators:start --only functions
```

---

## 🚀 PRÓXIMO PASSO

Agora você pode começar a implementar as features premium no Flutter!

Veja o arquivo **`ROADMAP_PREMIUM_FEATURES.md`** para o plano de implementação.

**Boa sorte! 🎉💰**
