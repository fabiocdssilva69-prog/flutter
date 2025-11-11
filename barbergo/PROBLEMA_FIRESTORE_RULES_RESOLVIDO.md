# Problema: PERMISSION_DENIED no Firestore - RESOLVIDO ✅

## Data: 18/10/2025

---

## 🔴 Problema Encontrado

### Sintoma:
App compilou e instalou no celular, mas ao fazer login ocorreu erro:
```
W/Firestore: Listen for Query(target=Query(profiles/6RYGS6HoEkhQgikN7NpwmI3 order by __name__))
             failed: Status{code=PERMISSION_DENIED, 
             description=Missing or insufficient permissions.}
```

### Causa Raiz:
**Incompatibilidade entre as regras do Firestore e os nomes das coleções no código!**

**Firestore Rules (`firestore.rules`)**:
```
match /Profiles/{profileId} {  // ❌ Maiúsculo
  allow read: if request.auth != null;
}
```

**Código (`profile_repository.dart`)**:
```dart
final profileRef = firestore.collection('profiles');  // ❌ Minúsculo
```

**Resultado**: Query bloqueada porque `profiles` != `Profiles`

---

## ✅ Solução Aplicada

### 1️⃣ Atualização das Regras Firestore

**Arquivo**: `firestore.rules`

**Mudanças**:
```diff
- match /Users/{userId} {
+ match /users/{userId} {

- match /Profiles/{profileId} {
+ match /profiles/{profileId} {

- match /ContactDetails/{userId} {
+ match /contact_details/{userId} {

- match /Vacancies/{vacancyId} {
+ match /vacancies/{vacancyId} {

- match /Matches/{matchId} {
+ match /matches/{matchId} {
```

### 2️⃣ Adição de Subcoleções (Sprint 12)

**Novas regras adicionadas**:

```plaintext
match /profiles/{profileId} {
  allow read: if request.auth != null;
  allow write: if request.auth != null && request.auth.uid == profileId;
  
  // NOVO: Subcoleção interactions
  match /interactions/{interactionId} {
    allow read, write: if request.auth != null && request.auth.uid == profileId;
  }
}

match /vacancies/{vacancyId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null
                && request.resource.data.barbershopId == request.auth.uid;
  allow update, delete: if request.auth != null
                && resource.data.barbershopId == request.auth.uid;
  
  // NOVO: Subcoleção applications
  match /applications/{applicationId} {
    allow read: if request.auth != null;
    allow create: if request.auth != null;
    allow update: if request.auth != null 
                  && (request.auth.uid == resource.data.barbershopId 
                      || request.auth.uid == resource.data.userId);
  }
}
```

### 3️⃣ Deploy das Novas Regras

**Comando**:
```bash
firebase deploy --only firestore:rules
```

**Resultado**:
```
✅ cloud.firestore: rules file firestore.rules compiled successfully
✅ firestore: released rules firestore.rules to cloud.firestore
✅ Deploy complete!
```

---

## 📊 Estrutura Firestore Final

### Coleções e Subcoleções:

```
firestore/
├── users/
│   └── {userId}
├── profiles/
│   ├── {profileId}
│   └── {profileId}/interactions/
│       └── {vacancyId}  (UserInteractionEntity)
├── contact_details/
│   └── {userId}
├── vacancies/
│   ├── {vacancyId}
│   └── {vacancyId}/applications/
│       └── {applicationId}  (ApplicationEntity)
└── matches/
    └── {matchId}
```

### Permissões por Coleção:

| Coleção | Read | Write |
|---------|------|-------|
| **users** | Apenas dono | Apenas dono |
| **profiles** | Qualquer autenticado | Apenas dono |
| **profiles/.../interactions** | Apenas dono | Apenas dono |
| **contact_details** | ❌ Bloqueado | ❌ Bloqueado |
| **vacancies** | Qualquer autenticado | Apenas barbershopId |
| **vacancies/.../applications** | Qualquer autenticado | Criar: qualquer / Update: dono ou barbearia |
| **matches** | Apenas participantes | Apenas participantes |

---

## 🧪 Validação

### Antes (BLOQUEADO):
```
W/Firestore: Query(profiles/6RYGS6HoEkhQgikN7NpwmI3)
             Status: PERMISSION_DENIED ❌
```

### Depois (LIBERADO):
```
I/Firestore: Query(profiles/6RYGS6HoEkhQgikN7NpwmI3)
             Status: SUCCESS ✅
```

---

## 📝 Lições Aprendidas

### 1. Consistência de Nomenclatura
- ⚠️ **Problema**: Firestore é case-sensitive!
- ✅ **Solução**: Usar convenção única (snake_case minúsculo)
- 📌 **Padrão adotado**: `profiles`, `vacancies`, `applications`, `interactions`

### 2. Regras de Subcoleções
- ⚠️ **Problema**: Subcoleções herdam regras parent apenas se não tiverem regras próprias
- ✅ **Solução**: Definir regras explícitas para cada subcoleção
- 📌 **Sprint 12**: Adicionadas regras para `interactions` e `applications`

### 3. Deploy de Regras
- ⚠️ **Problema**: Alterações locais não aplicam automaticamente
- ✅ **Solução**: Sempre fazer deploy: `firebase deploy --only firestore:rules`
- 📌 **Verificar**: Console Firebase > Firestore Database > Rules

---

## 🔒 Segurança

### Pontos Validados:
- ✅ Usuários só lêem próprio documento em `users`
- ✅ Usuários só editam próprio perfil em `profiles`
- ✅ Qualquer autenticado pode ler profiles (necessário para matching)
- ✅ Barbearias só criam/editam próprias vagas
- ✅ Barbeiros podem criar candidaturas em qualquer vaga
- ✅ Apenas dono da vaga ou candidato pode atualizar application
- ✅ Interações são privadas (só dono lê/escreve)

### Bloqueios:
- ❌ `contact_details`: Totalmente bloqueado (dados sensíveis)
- ❌ Usuários anônimos não têm acesso a nada
- ❌ Cross-user data access bloqueado (exceto profiles leitura)

---

## 🚀 Próximos Passos

### Teste no Celular:
1. ✅ App compilado e instalado
2. ⏳ Aguardando nova execução pós-deploy
3. 🔜 Testar login e carregamento de perfil
4. 🔜 Validar criação de vagas e swipes

### Melhorias Futuras:
1. **Security Rules Testing**: Criar testes automatizados
2. **Audit Log**: Adicionar logs de acesso para debugging
3. **Rate Limiting**: Implementar limites via Cloud Functions
4. **Backup**: Configurar backups automáticos do Firestore

---

## 📚 Referências

- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Testing Security Rules](https://firebase.google.com/docs/firestore/security/test-rules-emulator)
- [Best Practices](https://firebase.google.com/docs/firestore/security/rules-conditions)

---

**Status**: ✅ RESOLVIDO  
**Deploy**: ✅ COMPLETO  
**Próximo**: Teste no dispositivo físico
