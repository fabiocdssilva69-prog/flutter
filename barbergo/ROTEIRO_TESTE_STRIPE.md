# 🧪 ROTEIRO DE TESTE - STRIPE CHECKOUT

## 🎯 Objetivo
Validar que o sistema de pagamento Stripe está funcionando corretamente.

---

## 📋 PRÉ-REQUISITOS

Antes de começar, tenha certeza:
- [ ] App instalado no dispositivo/emulador
- [ ] Firebase configurado (já está!)
- [ ] Stripe configurado (já está!)
- [ ] Internet funcionando

---

## 🚀 PASSO A PASSO

### **1. Abrir o App**
```bash
# No terminal
flutter run
```

Aguarde o app abrir no dispositivo.

---

### **2. Fazer Login (se necessário)**
```
- Abra o app
- Faça login com suas credenciais
- Ou crie uma conta nova
```

---

### **3. Navegar para Premium Screen**

**Opção A:** Menu → Premium  
**Opção B:** Banner "Upgrade Premium" na tela inicial  
**Opção C:** Quando tentar usar recurso premium (Ver Quem Curtiu)

---

### **4. Escolher Plano**

Você verá 2 opções:

```
┌──────────────────────────────────┐
│ 🔥 Premium Anual (MAIS POPULAR)  │
│ R$ 191,04/ano                    │
│ R$ 15,92/mês                     │
│ Economize 20%                    │
│ [ESCOLHER PLANO]                 │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│ Premium Mensal                   │
│ R$ 19,90/mês                     │
│ Sem compromisso                  │
│ [ASSINAR]                        │
└──────────────────────────────────┘
```

**Escolha:** Premium Mensal (mais rápido para testar)

---

### **5. Preencher Dados no Stripe**

O app vai abrir o navegador com a página de checkout.

**⚠️ USE APENAS ESTE CARTÃO DE TESTE:**

```
┌─────────────────────────────────────────┐
│ CARTÃO DE TESTE DO STRIPE               │
├─────────────────────────────────────────┤
│ Número: 4242 4242 4242 4242             │
│ Data:   12/25 (ou qualquer data futura) │
│ CVC:    123 (ou qualquer 3 dígitos)     │
│ CEP:    12345 (qualquer)                │
│ Nome:   Seu Nome                        │
└─────────────────────────────────────────┘
```

**IMPORTANTE:** 
- ❌ NÃO use cartão real!
- ✅ Use exatamente `4242 4242 4242 4242`
- ✅ Este é um cartão de teste do Stripe

---

### **6. Confirmar Pagamento**

```
1. Revise os dados
2. Clique em "Subscribe" ou "Pagar"
3. Aguarde 2-5 segundos
4. Você será redirecionado de volta ao app
```

---

## ✅ VALIDAÇÃO - Como Saber se Funcionou?

### **A) No App (IMEDIATO)**

Após o pagamento, volte para a Premium Screen.

**Deve aparecer:**
```
✅ "Você já é Premium!"
✅ Badge dourado no perfil
✅ "Super Likes Ilimitados"
✅ "Veja Quem Curtiu Você" desbloqueado
```

---

### **B) No Stripe Dashboard (1-2 min)**

1. Acesse: https://dashboard.stripe.com/test/events
2. Procure pelos eventos recentes (últimos 5 minutos):

```
✅ customer.subscription.created
   └─ Status: succeeded
   └─ Customer: cus_...
   └─ Subscription: sub_...

✅ invoice.payment_succeeded
   └─ Amount: R$ 19,90
   └─ Status: paid
```

3. Clique em cada evento para ver detalhes

---

### **C) No Firestore (2-3 min)**

1. Acesse: https://console.firebase.google.com/project/barbergo-38c21/firestore
2. Navegue: `profiles` → `[seu_user_id]`
3. Verifique os campos:

```json
{
  "isPremium": true,                    ✅ Ativado
  "premiumExpiresAt": "2025-12-01...",  ✅ Data futura
  "stripeCustomerId": "cus_...",        ✅ ID do Stripe
  "canSeeWhoLiked": true,               ✅ Recurso liberado
  "superLikesRemaining": -1,            ✅ -1 = Ilimitado
  "updatedAt": [timestamp recente]      ✅ Atualizado agora
}
```

---

### **D) Logs Cloud Function (3-5 min)**

```bash
# No terminal
firebase functions:log --only stripeWebhook --limit 10
```

**Deve aparecer:**
```
✅ Received Stripe event: customer.subscription.created
📝 Updating subscription: sub_... for customer: cus_...
✅ Subscription sub_... updated for user [user_id]
📬 Notification sent to user [user_id]
```

---

## ⚠️ TROUBLESHOOTING - Se Algo Der Errado

### **Erro 1: "Erro ao criar sessão de checkout"**

**Sintoma:** Mensagem de erro ao clicar em "Assinar"

**Causa:** Stripe não conseguiu criar sessão

**Solução:**
```bash
# Verificar se STRIPE_SECRET_KEY existe
cat functions/.env | grep STRIPE_SECRET_KEY

# Se estiver vazio, adicionar:
echo "STRIPE_SECRET_KEY=sk_test_51SVW..." >> functions/.env

# Re-deploy
firebase deploy --only functions:stripeWebhook
```

---

### **Erro 2: "isPremium não atualizado no Firestore"**

**Sintoma:** Pagamento processado no Stripe, mas isPremium ainda false

**Causa:** Webhook não recebeu evento ou falhou

**Solução:**
```bash
# 1. Ver logs do webhook
firebase functions:log --only stripeWebhook

# 2. Verificar webhook configurado no Stripe
# URL: https://us-central1-barbergo-38c21.cloudfunctions.net/stripeWebhook
# Events: customer.subscription.*, invoice.payment_*

# 3. Re-enviar evento manualmente no Stripe Dashboard
# https://dashboard.stripe.com/test/events → [evento] → "Resend"
```

---

### **Erro 3: "Cartão recusado"**

**Sintoma:** Stripe mostra "Your card was declined"

**Causa:** Cartão inválido ou não é o de teste

**Solução:**
- ✅ Use EXATAMENTE: `4242 4242 4242 4242`
- ✅ Não use cartão real
- ✅ Verifique se está no modo TEST do Stripe

---

### **Erro 4: "App não abre checkout"**

**Sintoma:** Clica em "Assinar" mas nada acontece

**Causa:** URL do checkout é null

**Solução:**
```bash
# Ver logs do app
flutter logs

# Procurar erro:
# "❌ Erro ao criar sessão de checkout"

# Verificar StripeService
# lib/src/services/stripe_service.dart
```

---

## 📊 CHECKLIST DE VALIDAÇÃO

Marque cada item conforme testa:

### **Fluxo Básico:**
- [ ] App abre sem erros
- [ ] Consegue navegar para Premium Screen
- [ ] Vê os 2 planos (Mensal e Anual)
- [ ] Clica em "Assinar Mensal"
- [ ] Navegador abre com checkout Stripe
- [ ] Preenche cartão de teste (4242...)
- [ ] Clica em "Subscribe"
- [ ] Aguarda processamento (2-5s)
- [ ] Retorna ao app

### **Validação no App:**
- [ ] Premium Screen mostra "Você já é Premium!"
- [ ] Badge dourado aparece no perfil
- [ ] Super Likes mostra "Ilimitado"
- [ ] "Ver Quem Curtiu" está desbloqueado

### **Validação no Stripe:**
- [ ] Evento `customer.subscription.created` aparece
- [ ] Evento `invoice.payment_succeeded` aparece
- [ ] Status dos eventos: `succeeded`
- [ ] Valor correto: R$ 19,90

### **Validação no Firestore:**
- [ ] `isPremium: true`
- [ ] `premiumExpiresAt` com data futura
- [ ] `stripeCustomerId` preenchido
- [ ] `canSeeWhoLiked: true`
- [ ] `superLikesRemaining: -1`

### **Validação nos Logs:**
- [ ] Webhook recebeu evento
- [ ] Subscription atualizada
- [ ] Perfil atualizado no Firestore
- [ ] Notificação enviada

---

## 🎯 RESULTADO ESPERADO

**✅ TESTE PASSOU** se:
1. Pagamento processado no Stripe (eventos aparecem)
2. isPremium = true no Firestore
3. App mostra recursos premium desbloqueados
4. Webhook logou sucesso nos logs

**❌ TESTE FALHOU** se:
1. Erro ao processar pagamento
2. isPremium ainda false após 5 minutos
3. Webhook não recebeu evento
4. Recursos premium não desbloqueados

---

## 🚀 PRÓXIMOS PASSOS

**Se teste passou:**
1. ✅ Testar plano anual (opcional)
2. ✅ Testar Analytics (próximo teste)
3. ✅ Configurar produtos de produção

**Se teste falhou:**
1. ❌ Revisar logs de erro
2. ❌ Verificar configuração Stripe
3. ❌ Re-testar após correções

---

## 📞 COMANDOS ÚTEIS

```bash
# Ver logs em tempo real
firebase functions:log --follow

# Ver apenas webhook
firebase functions:log --only stripeWebhook --follow

# Ver eventos Stripe
# https://dashboard.stripe.com/test/events

# Ver Firestore
# https://console.firebase.google.com/project/barbergo-38c21/firestore
```

---

**🎬 PRONTO PARA COMEÇAR?**

1. Certifique-se que o app está rodando: `flutter run`
2. Siga o roteiro passo a passo
3. Marque cada checkbox conforme avança
4. Anote qualquer erro encontrado
5. Compartilhe o resultado!

**BOA SORTE! 🚀**
