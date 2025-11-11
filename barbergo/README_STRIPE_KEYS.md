# 🎯 README: Como Configurar o Stripe Keys

**Você está aqui porque precisa configurar o Stripe para aceitar pagamentos no BarberGO.**

---

## 📚 DOCUMENTAÇÃO DISPONÍVEL

Criamos **4 guias** para te ajudar. Escolha o que melhor se adapta ao seu estilo:

### 1️⃣ **GUIA_VISUAL_STRIPE.md** 📸
**Para quem:** Prefere ver "onde clicar" com simulações de tela  
**Tempo:** 10 minutos  
**Conteúdo:**
- Screenshots simulados de cada tela do Stripe
- Exatamente onde clicar
- O que você vai ver em cada passo

👉 **Use este se:** Você nunca usou Stripe antes

---

### 2️⃣ **GUIA_OBTER_STRIPE_KEYS.md** 📖
**Para quem:** Quer entender TODO o processo em detalhes  
**Tempo:** 15-20 minutos  
**Conteúdo:**
- Passo a passo completo desde criar conta
- Explicações detalhadas de cada key
- Dicas de segurança
- Troubleshooting completo
- Como testar localmente com Stripe CLI
- Como migrar de test para produção

👉 **Use este se:** É sua primeira vez configurando Stripe OU quer entender tudo

---

### 3️⃣ **PROMPTS_STRIPE_CONFIG.md** ⚡
**Para quem:** Já tem as keys, só quer comandos prontos  
**Tempo:** 5 minutos  
**Conteúdo:**
- Comandos prontos para copiar/colar
- 2 opções: script automático OU manual
- Checklist para verificar se funcionou
- Comandos úteis para debug

👉 **Use este se:** Você já obteve as 3 keys do Stripe, só precisa configurar no Firebase

---

### 4️⃣ **DELEGACAO_FIREBASE_PREMIUM.md** 📦
**Para quem:** Documentação técnica completa (backend)  
**Tempo:** 1 hora (implementação completa)  
**Conteúdo:**
- Schemas Firestore completos
- Cloud Functions com código
- Firebase Extensions
- Security Rules
- Notification templates
- Analytics events

👉 **Use este se:** Você é o desenvolvedor que vai implementar tudo

---

## 🚀 FLUXO RECOMENDADO

### Se você NUNCA configurou Stripe:

```
1. Leia: GUIA_VISUAL_STRIPE.md (10 min)
   └─ Você vai obter as 3 keys

2. Execute: .\firebase_setup_automated.ps1
   └─ Script pede as keys e configura tudo

3. Resultado: Firebase 100% configurado!
```

---

### Se você JÁ TEM as Stripe keys:

```
1. Leia: PROMPTS_STRIPE_CONFIG.md (2 min)

2. Execute: .\firebase_setup_automated.ps1
   └─ OU siga os comandos manuais do guia

3. Resultado: Firebase configurado!
```

---

### Se você quer DELEGAR para um agente/dev:

```
1. Envie: DELEGACAO_FIREBASE_PREMIUM.md
   └─ Contém TUDO que precisa ser feito

2. Agente executa tudo em ~1 hora

3. Resultado: Backend completo pronto!
```

---

## ✅ CHECKLIST RÁPIDO

Antes de executar qualquer script, certifique-se que você tem:

```
☐ Conta Stripe criada
☐ Modo "Test mode" ativado (bolinha vermelha)
☐ Publishable Key copiada (pk_test_...)
☐ Secret Key copiada (sk_test_...)
☐ Webhook criado no Stripe Dashboard
☐ Webhook Secret copiado (whsec_...)
☐ 4 produtos criados (Premium Mensal, Anual, Boosts, Super Likes)
```

**Se você marcou tudo, execute:**
```powershell
.\firebase_setup_automated.ps1
```

---

## 🎯 O QUE VOCÊ VAI OBTER

Após configurar tudo, você terá:

### No Stripe:
✅ Conta configurada  
✅ 4 produtos criados (2 assinaturas + 2 one-time)  
✅ Webhook ativo recebendo eventos  

### No Firebase:
✅ Environment variables configuradas  
✅ 3 Cloud Functions deployed (webhook + 2 crons)  
✅ Firebase Extension instalada (Stripe Payments)  
✅ 8 índices Firestore criados  
✅ 4 collections criadas (subscriptions, super_likes, daily_limits, boost_activations)  

### No BarberGO:
✅ Sistema de assinatura Premium funcionando  
✅ Super Likes (1 grátis/dia)  
✅ "Ver Quem Curtiu" (blur para free)  
✅ Sistema de Boost  
✅ Pronto para monetizar! 💰  

---

## 💡 DICAS IMPORTANTES

### 🔴 Use Test Mode Primeiro
- Não cobra dinheiro de verdade
- Cartões de teste: 4242 4242 4242 4242
- Perfeito para desenvolvimento

### 🔒 Segurança das Keys
- **Publishable Key (pk_...):** Pode compartilhar, vai no app
- **Secret Key (sk_...):** NUNCA compartilhe, só no servidor
- **Webhook Secret (whsec_...):** NUNCA compartilhe, só no servidor

### 💰 Quando Migrar para Produção
- Complete o cadastro no Stripe (dados bancários)
- Obtenha novas keys de produção (sk_live_..., pk_live_...)
- Crie novo webhook para produção
- Atualize environment variables
- Faça novo deploy das functions

---

## 📞 PRECISA DE AJUDA?

### Problema: Não sei qual guia usar
**Resposta:** Use o fluxo recomendado acima

### Problema: Erro ao executar o script
**Resposta:** Veja troubleshooting em `GUIA_OBTER_STRIPE_KEYS.md`

### Problema: Webhook não funciona
**Resposta:** Execute os comandos de verificação em `PROMPTS_STRIPE_CONFIG.md`

### Problema: Quer testar localmente
**Resposta:** Instale Stripe CLI (instruções em `GUIA_OBTER_STRIPE_KEYS.md`)

---

## 🎁 RECURSOS ÚTEIS

| Recurso | Link |
|---------|------|
| Stripe Dashboard | https://dashboard.stripe.com |
| Teste API Keys | https://dashboard.stripe.com/test/apikeys |
| Documentação Stripe | https://stripe.com/docs |
| Cartões de Teste | https://stripe.com/docs/testing |
| Stripe CLI Download | https://github.com/stripe/stripe-cli/releases |
| Firebase Console | https://console.firebase.google.com |

---

## 🚀 COMEÇAR AGORA

### Passo 1: Escolha seu guia
- Iniciante? → `GUIA_VISUAL_STRIPE.md`
- Tem pressa? → `PROMPTS_STRIPE_CONFIG.md`
- Quer entender tudo? → `GUIA_OBTER_STRIPE_KEYS.md`

### Passo 2: Obtenha as 3 keys
- Publishable Key
- Secret Key
- Webhook Secret

### Passo 3: Execute o script
```powershell
.\firebase_setup_automated.ps1
```

### Passo 4: Comece a monetizar! 🎉💰

---

## 📊 RESULTADO ESPERADO

**Tempo total:** 30-40 minutos  
**Dificuldade:** Fácil (com os guias)  
**Resultado:** Sistema de pagamento 100% funcional  

**Boa sorte! 🚀**
