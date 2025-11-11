# ⚡ QUICKSTART: Stripe Keys em 5 Minutos

**Objetivo:** Obter as 3 Stripe keys o mais rápido possível

---

## 🎯 VOCÊ PRECISA DE 3 KEYS

```
1. Secret Key       (sk_test_...)
2. Publishable Key  (pk_test_...)
3. Webhook Secret   (whsec_...)
```

---

## ⏱️ PASSO A PASSO (5 minutos)

### 1️⃣ Login no Stripe (30 segundos)

**URL:** <https://dashboard.stripe.com>m>

**Crie conta se não tiver:** <https://dashboard.stripe.com/register>r>

✅ Verifique: **🔴 Test mode** ativado (canto superior direito)

---

### 2️⃣ Obter Keys 1 e 2 (1 minuto)

**URL Direta:** <https://dashboard.stripe.com/test/apikeys>s>

```
┌─────────────────────────────────────────┐
│ Publishable key                         │
│ pk_test_51Abc...    [📋 Copy]  ← COPIE │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ Secret key                              │
│ sk_test_•••••       [👁️ Reveal] ← CLIQUE│
│ sk_test_51Abc...    [📋 Copy]  ← COPIE │
└─────────────────────────────────────────┘
```

✅ Cole as 2 keys em um arquivo de texto

---

### 3️⃣ Criar Webhook (2 minutos)

**URL Direta:** <https://dashboard.stripe.com/test/webhooks>s>

**Clique:** [+ Add endpoint]

**Preencha:**

```
Endpoint URL:
https://us-central1-{SEU_PROJECT_ID}.cloudfunctions.net/stripeWebhook
(você vai obter isso após deploy - por enquanto use qualquer URL)

Description:
BarberGO Premium

Events: (clique "Select events")
✅ customer.subscription.created
✅ customer.subscription.updated
✅ customer.subscription.deleted
✅ invoice.payment_succeeded
✅ invoice.payment_failed
```

**Clique:** [Add endpoint]

**Copie o Webhook Secret:**

```
┌─────────────────────────────────────────┐
│ Signing secret                          │
│ whsec_•••••         [👁️ Reveal] ← CLIQUE│
│ whsec_abc123...     [📋 Copy]  ← COPIE │
└─────────────────────────────────────────┘
```

✅ Cole no seu arquivo de texto

---

### 4️⃣ Criar 4 <https://dashboard.stripe.com/test/products>

**URL Direta:** <https://dashboard.stripe.com/test/products>

**Clique 4 vezes em:** [+ Add product]

**Produto 1:**

```
Name: BarberGO Premium - Mensal
Pricing: Recurring, 19.90 BRL, Monthly

```

**Produto 2:**

```
Name: BarberGO Premium - Anual

Pricing: Recurring, 191.04 BRL, Yearly
```

**Produto 3:**

```

Name: 5 Boosts
Pricing: One-time, 9.90 BRL
```

**Produto 4:**

```
Name: 10 Super Likes
Pricing: One-time, 8.90 BRL
```

---

## ✅ PRONTO! EXECUTE O SCRIPT

Você tem as 3 keys? Execute:

```powershell
.\firebase_setup_automated.ps1

```

**Quando perguntar:**

```
Você tem as Stripe keys? (s/n)
```

Digite: **s**

**Depois cole:**

```
Stripe Secret Key: sk_test_...

Stripe Webhook Secret: whsec_...
Stripe Publishable Key: pk_test_...
```

---

## 🎉 RESULTADO

Em 30-40 minutos você terá:

- ✅ Stripe configurado
- ✅ Firebase configurado
- ✅ Sistema de pagamento funcionando
- ✅ Pronto para monetizar!

---

## 📚 QUER MAIS DETALHES?

- **Guia Visual:** `GUIA_VISUAL_STRIPE.md`
- **Guia Completo:** `GUIA_OBTER_STRIPE_KEYS.md`
- **Comandos Prontos:** `PROMPTS_STRIPE_CONFIG.md`
- **Índice Geral:** `README_STRIPE_KEYS.md`

---

## 🆘 PRECISA DE AJUDA?

Leia o README:

```
README_STRIPE_KEYS.md
```

**Boa sorte! 🚀💰**
