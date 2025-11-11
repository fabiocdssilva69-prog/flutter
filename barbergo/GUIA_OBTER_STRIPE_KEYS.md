# 🔑 GUIA COMPLETO: Como Obter as Stripe Keys

**Data:** 1 de Novembro de 2025  
**Objetivo:** Configurar Stripe para aceitar pagamentos no BarberGO  
**Tempo estimado:** 15-20 minutos

---

## 📋 O QUE VOCÊ VAI PRECISAR

Ao final deste guia, você terá **3 keys do Stripe**:

1. **Secret Key** (sk_test_... ou sk_live_...)
2. **Publishable Key** (pk_test_... ou pk_live_...)
3. **Webhook Secret** (whsec_...)

---

## 🚀 PASSO 1: CRIAR CONTA STRIPE (5 min)

### Se você JÁ TEM conta Stripe

✅ Pule para o **PASSO 2**

### Se você NÃO TEM conta Stripe

1. Acesse: **<https://dashboard.stripe.com/register>**

2. Preencha o formulário:

   ```
   Email: seu@email.com
   Nome completo: Seu Nome
   País: Brazil
   Senha: (crie uma senha forte)
   ```

3. Clique em **"Create account"**

4. Verifique seu email (Stripe vai enviar um código)

5. **IMPORTANTE:** Por enquanto, use o **modo teste** (test mode)
   - Stripe começa automaticamente em modo teste
   - Você pode ativar modo produção depois
   - No modo teste, use cartões de teste (não cobra de verdade)

---

## 🔑 PASSO 2: OBTER SECRET KEY E PUBLISHABLE KEY (2 min)

### 2.1 - Acesse o Dashboard

1. Login em: **<https://dashboard.stripe.com>**

2. Verifique se está em **"Test mode"** (canto superior direito)

   ```
   🔴 Test mode (recomendado para início)
   ou
   🟢 Live mode (só use quando estiver pronto para produção)
   ```

### 2.2 - Acesse API Keys

1. Clique no canto superior direito no botão **"Developers"**

2. No menu lateral, clique em **"API keys"**

   OU acesse direto:
   - **Modo Teste:** <https://dashboard.stripe.com/test/apikeys>
   - **Modo Produção:** <https://dashboard.stripe.com/apikeys>

### 2.3 - Copiar as Keys

Você verá 2 keys visíveis:

#### 📌 PUBLISHABLE KEY (Pública - pode compartilhar)

```
pk_test_51Abc123...XYZ (modo teste)
ou
pk_live_51Abc123...XYZ (modo produção)
```

- Clique no ícone de **copiar** ao lado
- Cole em um arquivo de texto temporário
- ✅ Esta é a **PUBLISHABLE KEY**

#### 🔒 SECRET KEY (Secreta - NUNCA compartilhe!)

```
sk_test_51Abc123...XYZ (modo teste - começa com sk_test_)
ou
sk_live_51Abc123...XYZ (modo produção - começa com sk_live_)
```

- Clique em **"Reveal test key"** (ou "Reveal live key")
- Clique no ícone de **copiar**
- Cole no seu arquivo de texto
- ✅ Esta é a **SECRET KEY**

⚠️ **IMPORTANTE:** A Secret Key dá acesso total à sua conta Stripe. Nunca compartilhe no GitHub, Discord, ou qualquer lugar público!

---

## 🪝 PASSO 3: OBTER WEBHOOK SECRET (10 min)

### 3.1 - Por que precisamos do Webhook?

O webhook é como o Stripe "avisa" seu sistema quando algo acontece:

- Usuário assinou Premium ✅
- Pagamento foi aprovado 💰
- Assinatura foi cancelada ❌
- Pagamento falhou ⚠️

### 3.2 - Criar Webhook Endpoint

1. No menu **"Developers"**, clique em **"Webhooks"**

   OU acesse direto:
   - **Modo Teste:** <https://dashboard.stripe.com/test/webhooks>
   - **Modo Produção:** <https://dashboard.stripe.com/webhooks>

2. Clique no botão **"+ Add endpoint"**

### 3.3 - Configurar o Endpoint

#### Campo 1: Endpoint URL

**SE VOCÊ JÁ FEZ DEPLOY DAS CLOUD FUNCTIONS:**

```
https://us-central1-{SEU_PROJECT_ID}.cloudfunctions.net/stripeWebhook
```

**Exemplo:**

```
https://us-central1-barbergo-prod.cloudfunctions.net/stripeWebhook
```

**⚠️ NÃO SABE SEU PROJECT ID?**
Execute no terminal:

```bash
firebase projects:list
```

---

**SE VOCÊ AINDA NÃO FEZ DEPLOY (para testar localmente):**

```
http://localhost:5001/{SEU_PROJECT_ID}/us-central1/stripeWebhook
```

**MAS ATENÇÃO:** Localhost não funciona! Use **Stripe CLI** (explicado abaixo).

---

#### Campo 2: Description (opcional)

```
BarberGO Premium - Webhook para assinaturas
```

#### Campo 3: Events to send

Clique em **"Select events"** e marque os seguintes 5 eventos:

```
✅ customer.subscription.created
✅ customer.subscription.updated
✅ customer.subscription.deleted
✅ invoice.payment_succeeded
✅ invoice.payment_failed
```

**Como encontrar rapidamente:**

1. Use a busca (campo "Filter events")
2. Digite "customer.subscription"
3. Marque os 3 eventos de subscription
4. Digite "invoice.payment"
5. Marque os 2 eventos de invoice

#### Campo 4: API Version

```
Deixe em "Default" (última versão)
```

### 3.4 - Salvar e Copiar o Webhook Secret

1. Clique em **"Add endpoint"**

2. Na tela seguinte, você verá:

   ```
   Signing secret
   whsec_abc123...XYZ
   ```

3. Clique em **"Reveal"** (ao lado do webhook secret)

4. Clique no ícone de **copiar**

5. Cole no seu arquivo de texto

6. ✅ Esta é a **WEBHOOK SECRET**

---

## 📝 RESUMO: VOCÊ DEVE TER 3 KEYS AGORA

Verifique se você tem algo assim:

```
PUBLISHABLE KEY:
pk_test_51Abc123DefGhi456...XYZ

SECRET KEY:
sk_test_51Abc123DefGhi456...XYZ

WEBHOOK SECRET:
whsec_abc123def456...XYZ
```

✅ Se você tem as 3 keys, está pronto para o próximo passo!

---

## 🎯 PRÓXIMO PASSO: CONFIGURAR NO FIREBASE

Agora que você tem as 3 keys, você tem **2 opções**:

### OPÇÃO A: Usar o Script Automático (RECOMENDADO)

Execute o script que vai pedir as keys:

```powershell
.\firebase_setup_automated.ps1
```

Quando perguntar:

```
Você tem as Stripe keys? (s/n)
```

Digite: **s**

Depois cole cada key quando solicitado.

---

### OPÇÃO B: Configurar Manualmente

Execute os comandos no terminal (substitua pelas suas keys):

```bash
firebase functions:config:set stripe.secret_key="sk_test_..."
firebase functions:config:set stripe.webhook_secret="whsec_..."
firebase functions:config:set stripe.publishable_key="pk_test_..."
```

Verifique se foi configurado:

```bash
firebase functions:config:get
```

Deve mostrar:

```json
{
  "stripe": {
    "secret_key": "sk_test_...",
    "webhook_secret": "whsec_...",
    "publishable_key": "pk_test_..."
  }
}
```

---

## 🧪 PASSO 4: TESTAR LOCALMENTE (OPCIONAL)

### Se você quer testar antes de fazer deploy

#### 4.1 - Instalar Stripe CLI

**Windows (via Scoop):**

```powershell
scoop bucket add stripe https://github.com/stripe/scoop-stripe-cli.git
scoop install stripe
```

**Ou baixe direto:**
<https://github.com/stripe/stripe-cli/releases>

#### 4.2 - Login

```bash
stripe login
```

Vai abrir o navegador para autorizar.

#### 4.3 - Forward webhook para local

```bash
stripe listen --forward-to http://localhost:5001/{SEU_PROJECT_ID}/us-central1/stripeWebhook
```

#### 4.4 - Testar evento

Em outro terminal:

```bash
stripe trigger customer.subscription.created
```

Você deve ver os logs no terminal do `stripe listen`.

---

## 🔒 SEGURANÇA: O QUE FAZER E NÃO FAZER

### ✅ PODE

- Guardar as keys em arquivo `.env` (mas adicione ao `.gitignore`)
- Guardar em gerenciador de senhas (1Password, LastPass, etc)
- Compartilhar a Publishable Key (pk_...) - ela é pública
- Usar modo teste à vontade (não cobra de verdade)

### ❌ NÃO PODE

- Commitar Secret Key no GitHub
- Compartilhar Secret Key em Discord/Slack
- Compartilhar Webhook Secret publicamente
- Usar keys de produção em código de teste

---

## 🚨 SE ALGO DEU ERRADO

### Problema: "Invalid API Key"

**Solução:** Verifique se você copiou a key completa (às vezes corta no final)

### Problema: "Webhook signature verification failed"

**Solução:**

1. Verifique se o webhook secret está correto
2. Teste com Stripe CLI primeiro
3. Verifique se a URL do endpoint está correta

### Problema: "This API key cannot be used in test mode"

**Solução:** Você misturou keys de teste e produção. Use sempre do mesmo modo.

### Problema: Não consigo criar webhook porque não tenho URL

**Solução:**

1. Primeiro faça deploy das Cloud Functions
2. Depois crie o webhook com a URL gerada
3. Ou use Stripe CLI para testar localmente

---

## 🌍 PASSO 5 (FUTURO): ATIVAR MODO PRODUÇÃO

**⚠️ FAÇA ISSO APENAS QUANDO ESTIVER PRONTO PARA LANÇAR!**

Quando você estiver pronto para aceitar pagamentos reais:

1. Complete o cadastro no Stripe:
   - Dados da empresa
   - Informações bancárias (para receber pagamentos)
   - Documentação (pode pedir CNPJ/CPF, comprovantes, etc)

2. Ative o modo produção no dashboard

3. Repita os passos 2 e 3 deste guia, mas usando:
   - **Live API Keys** (sk_live_..., pk_live_...)
   - **Live Webhook** (criar novo endpoint em modo produção)

4. Atualize as environment variables no Firebase:

   ```bash
   firebase functions:config:set stripe.secret_key="sk_live_..."
   firebase functions:config:set stripe.webhook_secret="whsec_live_..."
   firebase functions:config:set stripe.publishable_key="pk_live_..."
   ```

5. Faça deploy novamente:

   ```bash
   firebase deploy --only functions
   ```

---

## 📞 SUPORTE

### Documentação Oficial Stripe

- API Keys: <https://stripe.com/docs/keys>
- Webhooks: <https://stripe.com/docs/webhooks>
- Testing: <https://stripe.com/docs/testing>

### Stripe Dashboard

- Teste: <https://dashboard.stripe.com/test>
- Produção: <https://dashboard.stripe.com>

### Stripe CLI

- Docs: <https://stripe.com/docs/stripe-cli>
- Download: <https://github.com/stripe/stripe-cli/releases>

---

## ✅ CHECKLIST FINAL

Antes de executar o script, verifique:

- [ ] Tenho uma conta Stripe (test mode OK por enquanto)
- [ ] Copiei a Secret Key (sk_test_...)
- [ ] Copiei a Publishable Key (pk_test_...)
- [ ] Criei um webhook endpoint
- [ ] Copiei o Webhook Secret (whsec_...)
- [ ] Guardei as 3 keys em local seguro
- [ ] Não commitei as keys no GitHub

**Se você marcou tudo, está pronto para rodar:**

```powershell
.\firebase_setup_automated.ps1
```

---

## 🎁 BONUS: CARTÕES DE TESTE

Para testar pagamentos no modo teste, use estes números de cartão:

### ✅ Pagamento Aprovado

```
Número: 4242 4242 4242 4242
Validade: qualquer data futura (ex: 12/25)
CVC: qualquer 3 dígitos (ex: 123)
CEP: qualquer (ex: 12345)
```

### ❌ Pagamento Recusado

```
Número: 4000 0000 0000 0002
```

### ⏳ Pagamento Requer Autenticação (3D Secure)

```
Número: 4000 0027 6000 3184
```

**Lista completa:** <https://stripe.com/docs/testing#cards>

---

## 🎉 TUDO PRONTO

Agora execute o script e cole suas keys quando solicitado:

```powershell
.\firebase_setup_automated.ps1
```

**Boa sorte! 🚀💰**
