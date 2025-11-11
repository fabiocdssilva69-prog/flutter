# ⚠️ AÇÃO URGENTE: Atualizar URL do Webhook

**Tempo estimado:** 2 minutos  
**Status atual:** Webhook com URL temporária  
**Ação:** Atualizar para URL da Cloud Function

---

## 🎯 URL CORRETA

```
https://us-central1-barbergo-38c21.cloudfunctions.net/stripeWebhook
```

**📋 Copie esta URL agora!**

---

## 📝 PASSO A PASSO (2 minutos)

### 1️⃣ Acessar Webhooks no Stripe

**URL direta:** https://dashboard.stripe.com/test/webhooks

```
┌─────────────────────────────────────────────────────────┐
│  Stripe Dashboard                                       │
│  🔴 Test mode                                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Webhooks                              [+ Add endpoint] │
│                                                         │
│  📍 brilliant-rhythm                         [...]      │
│     https://us-central1-barbergo...          ← ESTE    │
│     5 events • Created today                            │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**👆 Clique nos 3 pontinhos [...]**

---

### 2️⃣ Clicar em "Update details"

```
┌─────────────────────────────────────────┐
│  [...]                                  │
├─────────────────────────────────────────┤
│  👁️  View details                       │
│  ✏️  Update details          ← CLIQUE   │
│  🗑️  Delete endpoint                    │
└─────────────────────────────────────────┘
```

---

### 3️⃣ Atualizar a URL

```
┌──────────────────────────────────────────────────────────┐
│  Update endpoint                                         │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  Endpoint URL                                            │
│  ┌────────────────────────────────────────────────────┐ │
│  │ https://us-central1-barbergo-38c21...             │ │
│  │ cloudfunctions.net/stripeWebhook                   │ │
│  └────────────────────────────────────────────────────┘ │
│  👆 COLE A URL CORRETA AQUI                             │
│                                                          │
│  Description (optional)                                  │
│  ┌────────────────────────────────────────────────────┐ │
│  │ BarberGO Premium Webhook                           │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  Events to send                                          │
│  ✅ customer.subscription.created                        │
│  ✅ customer.subscription.updated                        │
│  ✅ customer.subscription.deleted                        │
│  ✅ invoice.payment_succeeded                            │
│  ✅ invoice.payment_failed                               │
│                                                          │
│                               [Cancel]  [Update endpoint]│
└──────────────────────────────────────────────────────────┘
```

**👆 Clique em [Update endpoint]**

---

### 4️⃣ Verificar Sucesso

```
┌─────────────────────────────────────────────────────────┐
│  ✅ Endpoint updated successfully                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  brilliant-rhythm                                       │
│                                                         │
│  Endpoint URL                                           │
│  https://us-central1-barbergo-38c21.                   │
│  cloudfunctions.net/stripeWebhook                       │
│                                                         │
│  Signing secret                                         │
│  whsec_4wNyW55w4ER33aTIsPUol8R0ibsXrutY                │
│                                                         │
│  Events                                                 │
│  • customer.subscription.created                        │
│  • customer.subscription.updated                        │
│  • customer.subscription.deleted                        │
│  • invoice.payment_succeeded                            │
│  • invoice.payment_failed                               │
│                                                         │
│  Status: ✅ Active                                      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**✅ PRONTO! Webhook configurado corretamente!**

---

## 🧪 TESTAR O WEBHOOK

### Opção 1: Via Stripe Dashboard

1. Na página do webhook, clique em **"Send test webhook"**
2. Selecione evento: `customer.subscription.created`
3. Clique em **"Send test webhook"**
4. Verifique se retorna `200 OK`

### Opção 2: Via Stripe CLI

```bash
# Instalar Stripe CLI (se não tiver)
scoop install stripe

# Fazer login
stripe login

# Testar webhook
stripe trigger customer.subscription.created

# Ver logs no Firebase
firebase functions:log --only stripeWebhook
```

### Opção 3: Via Firebase Logs

```bash
# Ver logs da função em tempo real
firebase functions:log --only stripeWebhook --follow
```

---

## ✅ COMO SABER SE ESTÁ FUNCIONANDO?

### 1. Status no Stripe Dashboard

```
Status: ✅ Active
Recent deliveries: 200 OK
```

### 2. Logs no Firebase

```bash
firebase functions:log --only stripeWebhook
```

**Output esperado:**
```
✅ Received Stripe event: customer.subscription.created
📝 Updating subscription: sub_1SOk... for customer: cus_...
✅ Subscription sub_1SOk... updated for user abc123
📬 Notification sent to user abc123
```

### 3. Firestore Console

Verificar se collections foram atualizadas:

```
subscriptions/{subscriptionId}
  status: "active"
  userId: "abc123"
  
profiles/{userId}
  isPremium: true
```

---

## 🆘 TROUBLESHOOTING

### Erro: "Webhook signature verification failed"

**Problema:** Webhook Secret está incorreto

**Solução:**
```bash
# Obter novo Webhook Secret
# No Stripe Dashboard: Webhooks > brilliant-rhythm > Signing secret

# Atualizar no Firebase
firebase functions:config:set stripe.webhook_secret="whsec_NEW_SECRET"

# Redeploy
firebase deploy --only functions:stripeWebhook
```

### Erro: "404 Not Found"

**Problema:** URL do webhook está incorreta

**Solução:**
1. Verificar URL: `firebase functions:list | grep stripeWebhook`
2. Copiar URL exata
3. Atualizar no Stripe Dashboard

### Erro: "Function timeout"

**Problema:** Função está demorando muito

**Solução:**
```bash
# Ver logs detalhados
firebase functions:log --only stripeWebhook --limit 50

# Verificar erros no código
# Se necessário, aumentar timeout em functions/src/stripeTriggers.ts
```

---

## 📊 VERIFICAÇÃO FINAL

Execute este checklist:

- [ ] Webhook URL atualizada no Stripe
- [ ] Status mostra "✅ Active"
- [ ] Teste via "Send test webhook" retorna 200 OK
- [ ] Logs do Firebase mostram evento recebido
- [ ] Collection `subscriptions` é atualizada
- [ ] Collection `profiles` é atualizada (isPremium: true)

---

## 🎉 PARABÉNS!

Quando todos os checkboxes acima estiverem ✅, seu sistema de pagamentos está **100% OPERACIONAL**!

**Próximo passo:** Implementar a UI de assinatura no Flutter 🚀

---

**Dúvidas?** Consulte: `STRIPE_SETUP_COMPLETO.md`
