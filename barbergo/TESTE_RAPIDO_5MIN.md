# 🧪 TESTE RÁPIDO - 5 MINUTOS

**Sistema 100% operacional - Vamos testar agora!**

---

## 🎯 VOCÊ VAI TESTAR 3 CENÁRIOS

```
✅ Teste 1: Assinatura Premium (2 min)
✅ Teste 2: Compra de Boosts (1 min)
✅ Teste 3: Verificar Webhook (1 min)
```

---

## 🚀 TESTE 1: ASSINATURA PREMIUM MENSAL

### Passo 1: Criar Sessão de Checkout (30 seg)

**Firebase Console:**
```
https://console.firebase.google.com/project/barbergo-38c21/firestore
```

**Navegue até:**
```
Firestore Database
  └── customers
       └── [+ Start collection]
```

**Dados:**
```
Collection ID: customers
Document ID: test_user_001
```

**Depois, adicione subcoleção:**
```
Collection: checkout_sessions
Document: [auto-ID]

Campos:
{
  "price": "price_1SOktGLOjlvmVFrXmpINUDN4",
  "success_url": "https://barbergo.app/success",
  "cancel_url": "https://barbergo.app/cancel",
  "mode": "subscription"
}
```

### Passo 2: Aguardar Extensão (5 seg)

**A extensão criará automaticamente:**
```
✅ Campo 'url' com link do Stripe Checkout
✅ Campo 'sessionId'
✅ Campo 'created' com timestamp
```

**Você verá algo assim:**
```json
{
  "price": "price_1SOktGLOjlvmVFrXmpINUDN4",
  "success_url": "https://barbergo.app/success",
  "cancel_url": "https://barbergo.app/cancel",
  "mode": "subscription",
  "url": "https://checkout.stripe.com/c/pay/cs_test_...",
  "sessionId": "cs_test_...",
  "created": "Timestamp"
}
```

### Passo 3: Completar Pagamento (1 min)

**Copie a URL** e abra no navegador

**Use cartão de teste:**
```
Número: 4242 4242 4242 4242
Validade: 12/34 (qualquer data futura)
CVV: 123
Nome: Teste BarberGO
CEP: 12345
```

**Clique:** [Assinar]

### Passo 4: Verificar Criação da Assinatura (30 seg)

**Volte ao Firestore Console**

**Verifique:**
```
customers
  └── test_user_001
       └── subscriptions
            └── sub_xxxxx (NOVO DOCUMENTO!)
                 ├── status: "active"
                 ├── currentPeriodStart: Timestamp
                 ├── currentPeriodEnd: Timestamp (1 mês depois)
                 ├── stripeLink: "https://dashboard.stripe.com/..."
                 └── price: "price_1SOktGLOjlvmVFrXmpINUDN4"
```

✅ **SUCESSO:** Se o documento `subscriptions/sub_xxxxx` foi criado!

---

## 🎮 TESTE 2: COMPRA DE BOOSTS (1 MIN)

**Repita o processo acima, mas use esses dados:**

```json
{
  "price": "price_1SOkxNLOjlvmVFrXQlNv9kyI",
  "success_url": "https://barbergo.app/success",
  "cancel_url": "https://barbergo.app/cancel",
  "mode": "payment"
}
```

**Diferença:**
- `mode: "payment"` (não é assinatura recorrente)
- Não cria documento em `subscriptions`
- Cria documento em `payments` (compra única)

**Verifique:**
```
customers
  └── test_user_001
       └── payments
            └── pi_xxxxx (NOVO!)
                 ├── status: "succeeded"
                 ├── amount: 990 (R$ 9,90 em centavos)
                 └── price: "price_1SOkxNLOjlvmVFrXQlNv9kyI"
```

---

## 🔔 TESTE 3: VERIFICAR WEBHOOK (1 MIN)

**Stripe Dashboard:**
```
https://dashboard.stripe.com/test/webhooks/we_1SOjVYLOjlvmVFrX5X4ebO2O
```

**Clique em:** "Entregas de eventos" (Event deliveries)

**Você deve ver (para cada pagamento):**

```
┌─────────────────────────────────────────────────────────┐
│ ✅ checkout.session.completed          2025-11-01 14:32 │
│    Status: 200 OK                                       │
│    Response time: 234ms                                 │
├─────────────────────────────────────────────────────────┤
│ ✅ customer.subscription.created       2025-11-01 14:32 │
│    Status: 200 OK                                       │
│    Response time: 187ms                                 │
├─────────────────────────────────────────────────────────┤
│ ✅ invoice.payment_succeeded           2025-11-01 14:32 │
│    Status: 200 OK                                       │
│    Response time: 156ms                                 │
└─────────────────────────────────────────────────────────┘
```

**Se aparecer ❌ com erro:**

1. Clique no evento com erro
2. Veja a mensagem de erro
3. Verifique logs da Cloud Function:
   ```bash
   firebase functions:log --only stripeWebhook --follow
   ```

---

## 🎨 VISUAL DOS LOGS (Firebase Console)

**Firebase Console → Functions → stripeWebhook → Logs**

**Você deve ver:**

```
✅ Received Stripe event: customer.subscription.created
✅ Handling subscription update: sub_xxxxx
✅ Updated subscription in Firestore for user: test_user_001
✅ User premium status updated

✅ Received Stripe event: invoice.payment_succeeded
✅ Payment succeeded for subscription: sub_xxxxx
✅ Amount: R$ 19.90
```

**Se aparecer erro:**
```
❌ Error processing webhook: [mensagem do erro]
```

**Soluções comuns:**
- Webhook Secret incorreto → Reconfigurar em Firebase
- Timeout → Aumentar tempo limite da função
- User not found → Criar perfil antes de assinar

---

## 💳 CARTÕES DE TESTE EXTRAS

**Sucesso (BRL):**
```
4000 0076 4000 0002  ✅ Cartão brasileiro válido
```

**Falha (recusado):**
```
4000 0000 0000 0002  ❌ Cartão recusado
```

**Requer autenticação 3D:**
```
4000 0025 0000 3155  🔐 Simula 3D Secure
```

**Saldo insuficiente:**
```
4000 0000 0000 9995  💸 Fundos insuficientes
```

---

## 🎁 TESTE RÁPIDO VIA DASHBOARD (ALTERNATIVA)

**Se preferir testar sem Firestore manual:**

1. Stripe Dashboard → **Products**
2. Clique em "Premium Mensal"
3. Clique em **"Create payment link"**
4. Copie o link e abra no navegador
5. Complete pagamento com cartão de teste
6. Verifique no Firestore se `subscriptions` foi criado

---

## ✅ CHECKLIST DE VALIDAÇÃO

Marque conforme testa:

- [ ] ✅ Teste 1: Assinatura criada no Firestore
- [ ] ✅ Teste 2: Pagamento único registrado
- [ ] ✅ Teste 3: Webhook retornando 200 OK
- [ ] ✅ Logs da função sem erros
- [ ] ✅ Dashboard Stripe mostrando pagamentos
- [ ] ✅ Dados corretos no Firestore (datas, valores, status)

---

## 🔥 PRÓXIMO PASSO: TESTE NO APP FLUTTER

Quando estiver pronto, podemos criar:

**Opção 1: Tela de Teste Simples** (10 min)
- 4 botões (1 por produto)
- Abre Checkout URL
- Mostra status da assinatura

**Opção 2: UI Premium Completa** (2-3 dias)
- Tela de Premium com animações
- Modal de seleção de plano
- Badge premium no perfil
- Recursos premium funcionais

**Me avise quando terminar os testes e qual opção você quer!**

---

## 📊 ACOMPANHAR MÉTRICAS APÓS TESTE

**Stripe Dashboard:**
```
https://dashboard.stripe.com/test/dashboard
```

**Visualize:**
- 💰 Receita total (deve mostrar R$ 19,90 + R$ 9,90 = R$ 29,80)
- 📈 MRR (Monthly Recurring Revenue): R$ 19,90
- 👥 Clientes: 1
- 📋 Assinaturas ativas: 1

**Firebase Firestore:**
```
customers → test_user_001
  ├── subscriptions: 1 documento
  └── payments: 1 documento
```

---

## 🆘 PROBLEMAS COMUNS

### Problema 1: Webhook não criou assinatura no Firestore

**Solução:**
```bash
# Ver logs da função
firebase functions:log --only stripeWebhook --follow

# Reprocessar webhook manualmente
# Dashboard Stripe → Webhook → Evento → "Resend"
```

### Problema 2: Campo 'url' não aparece em checkout_sessions

**Solução:**
- Aguarde 5-10 segundos (extensão pode demorar)
- Verifique se extensão está instalada:
  ```
  Firebase Console → Extensions → stripe/firestore-stripe-payments
  ```
- Verifique logs da extensão

### Problema 3: Pagamento não aparece no Firestore

**Causas:**
- Webhook não está ativo
- Webhook Secret errado
- Função com erro (ver logs)

**Solução:**
```bash
# Verificar webhook
firebase functions:config:get

# Deve mostrar:
# stripe.webhook_secret: "whsec_..."
```

---

## 🎉 RESULTADO ESPERADO

Após os 3 testes, você terá:

```
✅ 1 assinatura ativa (Premium Mensal R$ 19,90)
✅ 1 pagamento único (5 Boosts R$ 9,90)
✅ Webhooks funcionando (200 OK)
✅ Dados no Firestore sincronizados
✅ Sistema validado e pronto para produção
```

**🚀 TOTAL: R$ 29,80 em pagamentos de teste processados!**

---

**Agora execute os testes e me avise os resultados! 🧪💰**
