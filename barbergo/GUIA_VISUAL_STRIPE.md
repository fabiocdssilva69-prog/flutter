# 📸 GUIA VISUAL: Passo a Passo com Screenshots Simulados

**Objetivo:** Ver exatamente onde clicar no Stripe Dashboard

---

## 🎯 PARTE 1: OBTER SECRET KEY E PUBLISHABLE KEY

### PASSO 1: Login no Stripe

```
URL: https://dashboard.stripe.com
```

**Tela que você vai ver:**

```
┌─────────────────────────────────────────────┐
│  Stripe Dashboard                    [?] [⚙️] │
├─────────────────────────────────────────────┤
│                                              │
│  🔴 Test mode            [🟢 Go live →]     │
│                                              │
│  👈 IMPORTANTE: Verifique se está em        │
│     "Test mode" (bolinha vermelha)          │
│                                              │
└─────────────────────────────────────────────┘
```

---

### PASSO 2: Acessar API Keys

**Caminho:** Canto superior direito > **Developers** > **API keys**

**Ou acesse direto:**
```
https://dashboard.stripe.com/test/apikeys
```

**Tela que você vai ver:**

```
┌────────────────────────────────────────────────────────┐
│  Developers > API keys                                  │
├────────────────────────────────────────────────────────┤
│                                                         │
│  Standard keys                                          │
│  ─────────────────────────────────────────────────     │
│                                                         │
│  Publishable key                                        │
│  └─ pk_test_51Abc123...XYZ            [📋 Copy]       │
│     👆 COPIE ESTA KEY (PUBLISHABLE)                    │
│                                                         │
│  Secret key                                             │
│  └─ sk_test_••••••••••••••••           [👁️ Reveal]     │
│     👆 CLIQUE EM "Reveal" PRIMEIRO                     │
│                                                         │
└────────────────────────────────────────────────────────┘
```

**Após clicar em "Reveal":**

```
┌────────────────────────────────────────────────────────┐
│  Secret key                                             │
│  └─ sk_test_51Abc123...XYZ            [📋 Copy]       │
│     👆 COPIE ESTA KEY (SECRET)                         │
│     ⚠️  NUNCA compartilhe esta key!                    │
└────────────────────────────────────────────────────────┘
```

✅ **PRONTO! Você tem 2 keys:**
- Publishable Key (pk_test_...)
- Secret Key (sk_test_...)

---

## 🎯 PARTE 2: CRIAR WEBHOOK E OBTER WEBHOOK SECRET

### PASSO 3: Acessar Webhooks

**Caminho:** Menu **Developers** > **Webhooks**

**Ou acesse direto:**
```
https://dashboard.stripe.com/test/webhooks
```

**Tela que você vai ver:**

```
┌────────────────────────────────────────────────────────┐
│  Developers > Webhooks                                  │
├────────────────────────────────────────────────────────┤
│                                                         │
│  Endpoints receiving events from your account          │
│  ─────────────────────────────────────────────────     │
│                                                         │
│  You haven't added any endpoints yet                   │
│                                                         │
│  [+ Add endpoint]   👈 CLIQUE AQUI                     │
│                                                         │
└────────────────────────────────────────────────────────┘
```

---

### PASSO 4: Preencher Formulário do Webhook

**Tela do formulário:**

```
┌────────────────────────────────────────────────────────┐
│  Add an endpoint                                [✖️]     │
├────────────────────────────────────────────────────────┤
│                                                         │
│  Endpoint URL *                                         │
│  ┌───────────────────────────────────────────────┐    │
│  │ https://us-central1-barbergo.cloudfunctions   │    │
│  │ .net/stripeWebhook                             │    │
│  └───────────────────────────────────────────────┘    │
│  👆 COLE A URL DA SUA CLOUD FUNCTION                   │
│     (você vai obter após fazer deploy)                 │
│                                                         │
│  Description (optional)                                │
│  ┌───────────────────────────────────────────────┐    │
│  │ BarberGO Premium - Assinaturas                │    │
│  └───────────────────────────────────────────────┘    │
│                                                         │
│  Select events to listen to                           │
│  ┌───────────────────────────────────────────────┐    │
│  │ Filter events...              [Select events] │    │
│  └───────────────────────────────────────────────┘    │
│  👆 CLIQUE EM "Select events"                         │
│                                                         │
└────────────────────────────────────────────────────────┘
```

---

### PASSO 5: Selecionar Eventos

**Após clicar em "Select events":**

```
┌────────────────────────────────────────────────────────┐
│  Select events to send                      [Done]     │
├────────────────────────────────────────────────────────┤
│                                                         │
│  🔍 Filter events...                                   │
│  ┌───────────────────────────────────────────────┐    │
│  │ customer.subscription                         │    │
│  └───────────────────────────────────────────────┘    │
│  👆 DIGITE "customer.subscription" E PRESSIONE ENTER   │
│                                                         │
│  Results:                                              │
│  ☐ customer.subscription.created    👈 MARQUE         │
│  ☐ customer.subscription.deleted    👈 MARQUE         │
│  ☐ customer.subscription.updated    👈 MARQUE         │
│                                                         │
│  ─────────────────────────────────────────────────     │
│                                                         │
│  🔍 Filter events...                                   │
│  ┌───────────────────────────────────────────────┐    │
│  │ invoice.payment                               │    │
│  └───────────────────────────────────────────────┘    │
│  👆 AGORA DIGITE "invoice.payment"                     │
│                                                         │
│  Results:                                              │
│  ☐ invoice.payment_failed       👈 MARQUE             │
│  ☐ invoice.payment_succeeded    👈 MARQUE             │
│                                                         │
│                                          [Done]        │
│                                           👆 CLIQUE     │
└────────────────────────────────────────────────────────┘
```

**Resumo dos 5 eventos que você deve marcar:**
```
✅ customer.subscription.created
✅ customer.subscription.updated
✅ customer.subscription.deleted
✅ invoice.payment_succeeded
✅ invoice.payment_failed
```

---

### PASSO 6: Salvar e Copiar Webhook Secret

**Após clicar em "Add endpoint":**

```
┌────────────────────────────────────────────────────────┐
│  Endpoint details                                       │
├────────────────────────────────────────────────────────┤
│                                                         │
│  ✅ Endpoint successfully created                      │
│                                                         │
│  URL                                                   │
│  https://us-central1-barbergo.cloudfunctions.net/...  │
│                                                         │
│  Signing secret                                        │
│  └─ whsec_••••••••••••••••           [👁️ Reveal]     │
│     👆 CLIQUE EM "Reveal"                              │
│                                                         │
└────────────────────────────────────────────────────────┘
```

**Após clicar em "Reveal":**

```
┌────────────────────────────────────────────────────────┐
│  Signing secret                                        │
│  └─ whsec_abc123...XYZ              [📋 Copy]         │
│     👆 COPIE ESTA KEY (WEBHOOK SECRET)                 │
│                                                         │
│  ⚠️  Important: This is the only time you can view    │
│      this signing secret. Make sure to copy it now.   │
│                                                         │
└────────────────────────────────────────────────────────┘
```

✅ **PRONTO! Você tem a 3ª key:**
- Webhook Secret (whsec_...)

---

## 🎯 PARTE 3: CRIAR PRODUTOS NO STRIPE

### PASSO 7: Acessar Produtos

**Caminho:** Menu lateral > **Products**

**Ou acesse direto:**
```
https://dashboard.stripe.com/test/products
```

**Tela inicial:**

```
┌────────────────────────────────────────────────────────┐
│  Products                                               │
├────────────────────────────────────────────────────────┤
│                                                         │
│  Create and manage products for your business          │
│                                                         │
│  [+ Add product]     👈 CLIQUE AQUI 4 VEZES            │
│                       (1 para cada produto)            │
│                                                         │
└────────────────────────────────────────────────────────┘
```

---

### PASSO 8: Criar Produto 1 - Premium Mensal

**Formulário:**

```
┌────────────────────────────────────────────────────────┐
│  Add a product                                 [✖️]     │
├────────────────────────────────────────────────────────┤
│                                                         │
│  Name *                                                │
│  ┌───────────────────────────────────────────────┐    │
│  │ BarberGO Premium - Mensal                     │    │
│  └───────────────────────────────────────────────┘    │
│                                                         │
│  Description                                           │
│  ┌───────────────────────────────────────────────┐    │
│  │ Acesso completo a todas features premium      │    │
│  └───────────────────────────────────────────────┘    │
│                                                         │
│  Pricing                                               │
│  ┌───────────────────────────────────────────────┐    │
│  │ Pricing model: (•) Recurring  ( ) One-time   │    │
│  │                👆 SELECIONE RECURRING          │    │
│  │                                                │    │
│  │ Price: ┌────┐ BRL per ▼                       │    │
│  │        │19.90│      [month ▼]  👈 MONTHLY     │    │
│  │        └────┘                                  │    │
│  │        👆 DIGITE 19.90                         │    │
│  └───────────────────────────────────────────────┘    │
│                                                         │
│                                    [Save product]      │
│                                      👆 CLIQUE          │
└────────────────────────────────────────────────────────┘
```

---

### PASSO 9: Criar Produto 2 - Premium Anual

**Formulário (igual ao anterior, mas com mudanças):**

```
┌────────────────────────────────────────────────────────┐
│  Name:                                                 │
│  BarberGO Premium - Anual                              │
│                                                         │
│  Description:                                          │
│  12 meses com desconto (economize 20%)                 │
│                                                         │
│  Pricing:                                              │
│  (•) Recurring                                         │
│  Price: 191.04 BRL per year  👈 YEARLY                 │
│         👆 19.90 × 12 × 0.8 = 191.04                   │
│                                                         │
└────────────────────────────────────────────────────────┘
```

---

### PASSO 10: Criar Produto 3 - 5 Boosts

**Formulário:**

```
┌────────────────────────────────────────────────────────┐
│  Name:                                                 │
│  5 Boosts                                              │
│                                                         │
│  Description:                                          │
│  Apareça no topo por 30 minutos (5x)                   │
│                                                         │
│  Pricing:                                              │
│  ( ) Recurring  (•) One-time  👈 SELECIONE ONE-TIME   │
│  Price: 9.90 BRL                                       │
│                                                         │
└────────────────────────────────────────────────────────┘
```

---

### PASSO 11: Criar Produto 4 - 10 Super Likes

**Formulário:**

```
┌────────────────────────────────────────────────────────┐
│  Name:                                                 │
│  10 Super Likes                                        │
│                                                         │
│  Description:                                          │
│  Destaque-se com super likes extras                    │
│                                                         │
│  Pricing:                                              │
│  ( ) Recurring  (•) One-time                           │
│  Price: 8.90 BRL                                       │
│                                                         │
└────────────────────────────────────────────────────────┘
```

---

## ✅ RESUMO: O QUE VOCÊ DEVE TER AGORA

### 3 Keys do Stripe:

```
1. Publishable Key (pública - pode compartilhar):
   pk_test_51Abc123DefGhi456...XYZ

2. Secret Key (secreta - NUNCA compartilhe):
   sk_test_51Abc123DefGhi456...XYZ

3. Webhook Secret (secreta - NUNCA compartilhe):
   whsec_abc123def456...XYZ
```

### 4 Produtos criados:

```
✅ BarberGO Premium - Mensal (R$ 19,90/mês)
✅ BarberGO Premium - Anual (R$ 191,04/ano)
✅ 5 Boosts (R$ 9,90)
✅ 10 Super Likes (R$ 8,90)
```

---

## 🎯 PRÓXIMO PASSO

Agora execute um destes comandos:

### Opção A: Script Automático (RECOMENDADO)
```powershell
.\firebase_setup_automated.ps1
```

### Opção B: Comandos Manuais
Veja: **`PROMPTS_STRIPE_CONFIG.md`**

---

## 📞 LINKS ÚTEIS

| Recurso | URL |
|---------|-----|
| Stripe Dashboard | https://dashboard.stripe.com |
| API Keys (Test) | https://dashboard.stripe.com/test/apikeys |
| API Keys (Live) | https://dashboard.stripe.com/apikeys |
| Webhooks (Test) | https://dashboard.stripe.com/test/webhooks |
| Webhooks (Live) | https://dashboard.stripe.com/webhooks |
| Products (Test) | https://dashboard.stripe.com/test/products |
| Products (Live) | https://dashboard.stripe.com/products |
| Logs | https://dashboard.stripe.com/test/logs |
| Documentação | https://stripe.com/docs |

---

## 🎁 DICA: CARTÕES DE TESTE

Para testar pagamentos no modo teste:

### ✅ Pagamento Aprovado:
```
Número: 4242 4242 4242 4242
Validade: 12/25 (qualquer data futura)
CVC: 123 (qualquer 3 dígitos)
Nome: Seu Nome
CEP: 12345 (qualquer)
```

### ❌ Pagamento Recusado:
```
Número: 4000 0000 0000 0002
```

### ⏳ Requer Autenticação (3D Secure):
```
Número: 4000 0027 6000 3184
```

**Mais cartões:** https://stripe.com/docs/testing#cards

---

## 🎉 VOCÊ ESTÁ PRONTO!

Com as 3 keys e 4 produtos criados, você pode:

1. Executar o script de setup: `.\firebase_setup_automated.ps1`
2. Ou seguir os comandos manuais: `PROMPTS_STRIPE_CONFIG.md`

**Boa sorte! 🚀💰**
