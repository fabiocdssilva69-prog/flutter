# 🚀 GUIA RÁPIDO DE EXECUÇÃO - CONFIGURAÇÃO FIREBASE

**Status:** ✅ Arquivos criados no projeto  
**Próximo passo:** Deploy no Firebase

---

## ✅ ARQUIVOS JÁ CRIADOS NO PROJETO

```
✅ storage.rules (raiz) - Regras de segurança do Storage
✅ functions/src/verification.ts - 3 Cloud Functions de verificação
✅ functions/src/index.ts - Exports atualizados
⏳ firestore.indexes.json - Precisa ser atualizado
```

---

## 🚀 EXECUTAR AGORA (4 COMANDOS)

### 1️⃣ Deploy Storage Rules (2 min)

```powershell
cd C:\workspaces\fabiocdssilva69-prog\barbergo
firebase deploy --only storage
```

**Resultado esperado:**
```
✔ Deploy complete!
Resources:
  storage: deployed
```

---

### 2️⃣ Deploy Cloud Functions (5-10 min)

```powershell
# Instalar dependências
cd functions
npm install
cd ..

# Deploy das 3 novas functions
firebase deploy --only functions:processVerification,functions:approveVerification,functions:rejectVerification
```

**Resultado esperado:**
```
✔ functions[processVerification(us-central1)]: Successful create operation.
✔ functions[approveVerification(us-central1)]: Successful create operation.
✔ functions[rejectVerification(us-central1)]: Successful create operation.
```

---

### 3️⃣ Verificar Deploy (1 min)

```powershell
# Ver todas as functions deployadas
firebase functions:list

# Deve mostrar:
# processVerification
# approveVerification
# rejectVerification
# (+ outras functions já existentes)
```

---

### 4️⃣ Atualizar Firestore Indexes (5 min)

Abra o arquivo `firestore.indexes.json` e adicione os novos índices:

```json
{
  "indexes": [
    {
      "collectionGroup": "verifications",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "submittedAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "admin_tasks",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "type", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

Depois deploy:

```powershell
firebase deploy --only firestore:indexes
```

Aguardar 5-10 min até ficarem ACTIVE:

```powershell
firebase firestore:indexes
```

---

## 🔗 LINKS ÚTEIS

- **Storage Console:** https://console.firebase.google.com/project/barbergo-38c21/storage
- **Functions Console:** https://console.firebase.google.com/project/barbergo-38c21/functions
- **Indexes Console:** https://console.firebase.google.com/project/barbergo-38c21/firestore/indexes

---

## 📊 O QUE FOI CONFIGURADO

### ✅ Storage Rules (6 categorias)

```
/verifications/{userId}/*    - Documentos de verificação (5MB, imagens)
/certificates/{userId}/*     - Certificados de cursos (5MB, imagens/PDF)
/portfolio/{userId}/*        - Fotos de trabalhos (5MB, público)
/profile_photos/{userId}/*   - Fotos de perfil (3MB, público)
/chat_attachments/*          - Anexos de chat (10MB)
```

### ✅ Cloud Functions (3 funções)

```
processVerification         - Trigger onCreate em /verifications
  → Marca como pending
  → Cria admin_task
  → Envia notificação ao usuário
  
approveVerification        - Callable function (admin only)
  → Atualiza status para approved
  → Marca isVerified = true no perfil
  → Envia notificação de sucesso
  
rejectVerification         - Callable function (admin only)
  → Atualiza status para rejected
  → Salva motivo da rejeição
  → Envia notificação ao usuário
```

### ⏳ Firestore Indexes (2 novos)

```
verifications              - Queries por status + data
admin_tasks               - Queries por tipo + status + data
```

---

## 🧪 TESTAR APÓS DEPLOY

### Teste 1: Storage Rules

1. Acesse: https://console.firebase.google.com/project/barbergo-38c21/storage
2. Clique em "Files"
3. Tente fazer upload manual de uma imagem
4. Verifique se as regras estão aplicadas

### Teste 2: Cloud Functions

```powershell
# Ver logs em tempo real
firebase functions:log --follow

# Ver logs específicos
firebase functions:log --only processVerification --limit 20
```

### Teste 3: Indexes

```powershell
# Status dos índices
firebase firestore:indexes

# Deve mostrar:
# verifications: ACTIVE
# admin_tasks: ACTIVE
```

---

## 🚨 SE ALGO DER ERRADO

### Erro: "Permission denied" no Storage

```powershell
firebase deploy --only storage
```

### Erro: "Function deployment failed"

```powershell
cd functions
rm -rf node_modules
npm install
npm run build
cd ..
firebase deploy --only functions
```

### Erro: TypeScript

```powershell
cd functions
npm run build

# Se houver erros de tipo, verificar verification.ts
```

---

## ⏭️ PRÓXIMOS PASSOS

Após completar o deploy:

1. ✅ **Notificar desenvolvedor Flutter** que Cloud Functions estão prontas
2. ✅ **Testar sistema de verificação** no app
3. ✅ **Configurar Google Maps API** (ainda não feito)

---

## 📞 COMANDOS RÁPIDOS DE VERIFICAÇÃO

```powershell
# Status geral
firebase projects:list
firebase use

# Verificar Storage
firebase storage:buckets:list

# Verificar Functions
firebase functions:list

# Verificar Indexes
firebase firestore:indexes

# Logs
firebase functions:log --follow
```

---

**Tempo estimado:** 15-20 minutos  
**Status:** 🔴 PRONTO PARA EXECUTAR  

🚀 **EXECUTAR COMANDOS ACIMA!**
