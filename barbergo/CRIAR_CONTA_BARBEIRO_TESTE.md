# 🎯 GUIA RÁPIDO: Criar Conta de Barbeiro para Testes

**Objetivo:** Criar uma segunda conta (barbeiro) para testar candidaturas a vagas

---

## ⚡ MÉTODO MAIS RÁPIDO (Pelo App)

### 1. No celular, abra o app BarberGo

### 2. Na tela de login, procure o botão **"Criar conta"** ou **"Cadastre-se"**

### 3. Preencha os dados sugeridos:

```
📧 Email:     barbeiro1@teste.com
🔒 Senha:     teste123
👤 Nome:      João Silva
📱 Telefone:  11987654321
🔖 Tipo:      Barbeiro (barber)
```

### 4. Após criar, faça login com essa nova conta

### 5. Teste a candidatura:
- Vá para "Explorar Vagas" ou "Feed"
- Encontre a vaga criada anteriormente
- Clique em "Candidatar-se"

---

## 🌐 MÉTODO ALTERNATIVO (Firebase Console)

Se o app não tiver tela de cadastro ou estiver com problema:

### Passo 1: Criar usuário no Authentication

1. Abra: https://console.firebase.google.com/project/barbergo-38c21/authentication/users

2. Clique em **"Add user"**

3. Preencha:
   - **Email:** `barbeiro1@teste.com`
   - **Password:** `teste123`

4. Clique em **"Add user"**

5. **IMPORTANTE:** Copie o **"User UID"** gerado (algo como `xYz123AbC...`)

### Passo 2: Criar perfil no Firestore

1. Abra: https://console.firebase.google.com/project/barbergo-38c21/firestore/databases/-default-/data/~2Fprofiles

2. Clique em **"Add document"**

3. No campo **"Document ID"**, cole o UID que você copiou

4. Adicione os seguintes campos (clique em "Add field" para cada um):

| Field | Type | Value |
|-------|------|-------|
| `accountType` | string | `barber` |
| `name` | string | `João Silva` |
| `email` | string | `barbeiro1@teste.com` |
| `phone` | string | `11987654321` |
| `createdAt` | timestamp | *[clique no relógio para usar data atual]* |

5. Clique em **"Save"**

### Passo 3: Fazer login no app

1. Abra o app no celular
2. Faça login com:
   - **Email:** `barbeiro1@teste.com`
   - **Senha:** `teste123`

---

## 📋 DADOS DE TESTE SUGERIDOS

### Conta Barbeiro 1:
```yaml
Email:    barbeiro1@teste.com
Senha:    teste123
Nome:     João Silva
Telefone: 11987654321
Tipo:     barber
```

### Conta Barbeiro 2 (se precisar):
```yaml
Email:    barbeiro2@teste.com
Senha:    teste123
Nome:     Maria Santos
Telefone: 11976543210
Tipo:     barber
```

### Conta Barbearia (adicional):
```yaml
Email:    barbearia2@teste.com
Senha:    teste123
Nome:     Cortes Modernos
Telefone: 11965432109
Tipo:     barbershop
```

---

## ✅ VERIFICAÇÃO

Após criar a conta de barbeiro, verifique no Firebase Console:

### 1. Authentication deve mostrar:
- ✅ `fabiocds.silva69@gmail.com` (barbearia)
- ✅ `barbeiro1@teste.com` (barbeiro)

### 2. Firestore → profiles deve ter 2 documentos:
- ✅ `6RYGS6HoEkhQgikNxUIkn7NpwmI3` → accountType: "barbershop"
- ✅ `[novo UID]` → accountType: "barber"

---

## 🎯 TESTE DE CANDIDATURA

Com a conta de barbeiro criada:

### 1. Login como Barbeiro
- Abra o app
- Login: `barbeiro1@teste.com` / `teste123`

### 2. Encontrar Vaga
- Navegue para "Explorar Vagas" ou "Feed"
- Procure a vaga: "Barbeiro" ou "Biguaçu"
- *(Vaga criada anteriormente: `vacancy_1760839982450`)*

### 3. Candidatar-se
- Clique na vaga
- Clique em "Candidatar-se"
- ✅ Deve criar uma candidatura (`applications` collection)

### 4. Verificar pelo lado da Barbearia
- Saia e faça login como barbearia: `fabiocds.silva69@gmail.com`
- Vá em "Gestão → Minhas Vagas"
- Clique na vaga criada
- ✅ Deve mostrar a candidatura de "João Silva"

---

## 🚨 PROBLEMAS COMUNS

### "Erro ao criar conta"
- Verifique se o email já não existe no Authentication
- Delete o usuário antigo e tente novamente

### "Perfil não encontrado após login"
- Verifique se o documento foi criado na collection `profiles` (minúsculo!)
- Verifique se o Document ID é exatamente o UID do Authentication
- Verifique se o campo `accountType` está correto: `"barber"` (minúsculo, string)

### "Não consigo ver vagas"
- Verifique se há vagas ativas (`isActive: true`)
- Verifique a conexão com internet
- Reinicie o app

### "Erro ao candidatar-se"
- Verifique se as regras do Firestore foram deployadas
- Verifique se `applications` é collection raiz (não subcoleção)
- Verifique nos logs: `adb logcat | Select-String "Firestore"`

---

## 🛠️ FERRAMENTAS ÚTEIS

### Ver logs do app:
```powershell
adb logcat | Select-String -Pattern "flutter|Firestore|Auth"
```

### Ver usuários cadastrados:
```powershell
firebase auth:export usuarios.json --project barbergo-38c21
cat usuarios.json
```

### Ver profiles no Firestore:
Acesse: https://console.firebase.google.com/project/barbergo-38c21/firestore/databases/-default-/data/~2Fprofiles

---

## 📞 PRÓXIMOS PASSOS

Após criar conta de barbeiro e testar candidatura:

1. ✅ Criar candidatura
2. ✅ Ver candidatura pela barbearia
3. ✅ Testar aceitar/rejeitar candidatura
4. ✅ Testar sistema de matching
5. ✅ Testar notificações (se implementado)

---

**💡 Dica:** Mantenha as credenciais de teste anotadas para futuros testes!

**🔗 Links Úteis:**
- Firebase Console: https://console.firebase.google.com/project/barbergo-38c21
- Authentication: https://console.firebase.google.com/project/barbergo-38c21/authentication/users
- Firestore: https://console.firebase.google.com/project/barbergo-38c21/firestore
