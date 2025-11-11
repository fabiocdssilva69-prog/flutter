# 🚨 AÇÃO URGENTE: Como Criar Vagas

## 📱 O Que Aconteceu

Você tentou criar uma vaga mas recebeu:

```
❌ PERMISSION_DENIED
```

**Motivo:** Seu perfil é `barber` (Barbeiro), mas apenas `barbershop` (Barbearia) pode criar vagas!

---

## ✅ SOLUÇÃO RÁPIDA

### Opção 1: Criar Conta de Barbearia (5 minutos)

1. **Logout** do app
   - Perfil → Sair

2. **Registrar** nova conta
   - Email: `sua.barbearia@teste.com`
   - Senha: [sua senha]

3. **Onboarding** - Escolha:
   - ✅ Tipo: **Barbearia** 🏪
   - ✅ Nome: "Barbearia Teste Sprint 12"
   - ✅ Localização: "São Paulo, SP"
   - ✅ Email/Telefone: [seus dados]

4. **Concluir** cadastro

5. **Testar** criar vaga!

---

### Opção 2: Alterar Perfil Existente (Firebase Console)

⚠️ **Use apenas para testes rápidos!**

1. Abra: https://console.firebase.google.com/project/barbergo-38c21/firestore/data

2. Navegue: `profiles` → Seu `userId`

3. Edite campo `accountType`:
   ```
   DE:   barber
   PARA: barbershop
   ```

4. **Salve** as alterações

5. **Reinicie o app** (Hot Restart: `R`)

6. **Teste** criar vaga

---

## 🎯 Agora Vai Funcionar

Com perfil de **Barbearia**, você poderá:

- ✅ Criar vagas
- ✅ Pausar/Retomar vagas
- ✅ Ver lista de candidatos
- ✅ Aceitar/Rejeitar candidaturas

---

## 📊 Diferença Entre Perfis

### 💈 Barbeiro (barber)
- ❌ **NÃO PODE** criar vagas
- ✅ **PODE** ver feed de vagas
- ✅ **PODE** aplicar para vagas (swipe)
- ✅ **PODE** ver suas candidaturas

### 🏪 Barbearia (barbershop)
- ✅ **PODE** criar vagas ← **Você precisa disso!**
- ✅ **PODE** gerenciar vagas
- ✅ **PODE** ver candidatos
- ✅ **PODE** aceitar/rejeitar candidaturas

---

## 🔧 Status da Correção

**O que foi feito:**
- ✅ Adicionada validação no código
- ✅ Mensagem de erro clara
- ✅ App recompilando agora...

**Próximo teste:**
- Agora vai mostrar mensagem: *"Apenas perfis de Barbearia podem criar vagas"*
- Siga Opção 1 ou 2 acima
- Teste novamente!

---

**⏱️ Tempo estimado: 5 minutos para criar conta nova**
