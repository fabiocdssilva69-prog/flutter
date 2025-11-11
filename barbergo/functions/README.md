# 🔥 BarberGO Cloud Functions

Firebase Cloud Functions para manter a integridade dos dados desnormalizados no Firestore.

## 📋 Índice

- [Arquitetura](#-arquitetura)
- [Funções Implementadas](#-funções-implementadas)
- [Desenvolvimento Local](#-desenvolvimento-local)
- [Testes](#-testes)
- [Deploy](#-deploy)
- [Monitoramento](#-monitoramento)

---

## 🏗️ Arquitetura

### Stack Tecnológico

- **Runtime**: Node.js 18
- **Linguagem**: TypeScript 5.1+
- **SDK**: Firebase Admin SDK 12.0.0
- **Functions SDK**: Firebase Functions 5.0.0
- **Linter**: ESLint 8.57 (Google Style Guide)

### Estrutura de Diretórios

```
functions/
├── src/                    # Código TypeScript
│   ├── index.ts           # Entry point + Admin SDK init
│   └── profileTriggers.ts # Triggers de perfil
├── lib/                    # JavaScript compilado (gerado)
├── node_modules/          # Dependências npm
├── package.json           # Configuração npm
├── tsconfig.json          # Configuração TypeScript
├── eslint.config.mjs      # Configuração ESLint
└── .gitignore
```

---

## 🔧 Funções Implementadas

### 1. `propagateProfileUpdate`

**Trigger**: `onUpdate` em `profiles/{userId}`

**Descrição**: Propaga mudanças de **Nome** e **Localização** para todos os documentos relacionados, garantindo consistência dos dados desnormalizados.

**Dados Atualizados**:

| Coleção | Condição | Campos Atualizados |
|---------|----------|-------------------|
| `vacancies` | `barbershopId == userId` | `barbershopName`, `locationCityState` |
| `applications` | `barbershopId == userId` | `barbershopName` |
| `chat_rooms` | `participantIds` contém `userId` | `participants.{userId}.name` |

**Otimizações**:
- ✅ **Smart Detection**: Só executa se nome/localização mudaram
- ✅ **Atomic Writes**: Usa `WriteBatch` para garantir atomicidade
- ✅ **Account Type Check**: Só atualiza vagas se for barbearia
- ✅ **Nested Field Updates**: Usa notação de ponto para mapas

**Exemplo de Log**:
```
Propagating changes for Profile abc123. Name changed: true, Location changed: false
Successfully propagated changes for abc123.
```

---

## 💻 Desenvolvimento Local

### 1. Instalar Dependências

```bash
cd functions
npm install
```

### 2. Compilar TypeScript

```bash
npm run build
```

Isso gera os arquivos JavaScript em `functions/lib/`.

### 3. Rodar Emulador Local

```bash
npm run serve
```

Isso inicia:
- Firebase Functions Emulator (porta 5001)
- Firebase Auth Emulator (porta 9099)
- Firestore Emulator (porta 8080)

### 4. Watch Mode (Desenvolvimento)

```bash
npm run build:watch
```

Recompila automaticamente quando você edita arquivos `.ts`.

---

## 🧪 Testes

### Teste Manual no Emulator

1. Inicie o emulador:
   ```bash
   npm run serve
   ```

2. No app Flutter, configure o app para usar emuladores:
   ```dart
   // lib/main.dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   
   // APENAS EM DEBUG MODE
   if (kDebugMode) {
     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
     FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
   }
   ```

3. Edite um perfil no app e observe os logs do emulator.

### Verificação de Integridade

Após editar um perfil, verifique no Firestore:

```bash
# Exemplo: Verificar se a vaga foi atualizada
firebase firestore:get vacancies/{vacancyId}
```

---

## 🚀 Deploy

### Deploy de Tudo (Functions + Firestore + Hosting)

```bash
firebase deploy
```

### Deploy Apenas Functions

```bash
firebase deploy --only functions
```

### Deploy de Função Específica

```bash
firebase deploy --only functions:propagateProfileUpdate
```

### Verificar Status do Deploy

```bash
firebase functions:list
```

**Output Esperado**:
```
┌──────────────────────────┬────────────────┬─────────┐
│ Name                     │ Region         │ Status  │
├──────────────────────────┼────────────────┼─────────┤
│ propagateProfileUpdate   │ us-central1    │ ACTIVE  │
└──────────────────────────┴────────────────┴─────────┘
```

---

## 📊 Monitoramento

### 1. Logs em Tempo Real

```bash
npm run logs
```

### 2. Logs Específicos de Função

```bash
firebase functions:log --only propagateProfileUpdate
```

### 3. Firebase Console

Acesse: https://console.firebase.google.com/project/barbergo-38c21/functions

**Métricas Disponíveis**:
- Invocações (execuções)
- Tempo de execução médio
- Erros (500s, timeouts)
- Uso de memória

### 4. Alertas Recomendados

Configure alertas no Firebase Console para:
- ⚠️ Taxa de erro > 5%
- ⚠️ Tempo de execução > 30s
- ⚠️ Invocações > 10.000/dia (limite gratuito)

---

## 🔐 Segurança

### Admin SDK Privileges

- ✅ **Bypass de Security Rules**: As Cloud Functions rodam com privilégios administrativos
- ⚠️ **Validação Manual**: Sempre valide dados antes de escrever no Firestore
- 🔒 **Never Trust Client Data**: Mesmo que o cliente envie dados, re-valide no server

### Exemplo de Validação

```typescript
// ❌ RUIM (confia no cliente)
batch.update(doc.ref, afterData);

// ✅ BOM (valida e filtra)
batch.update(doc.ref, {
  barbershopName: String(afterData.name).trim(),
  locationCityState: String(afterData.location).trim(),
});
```

---

## 📝 Boas Práticas

### 1. Idempotência

✅ `propagateProfileUpdate` é **idempotente**: pode ser executada múltiplas vezes sem efeitos colaterais.

### 2. Atomicidade

✅ Usamos `WriteBatch` para garantir que todas as atualizações ocorram juntas (all-or-nothing).

### 3. Custos

⚠️ **Atenção**: Cada execução consome:
- 1 invocação (100k gratuitas/mês)
- N leituras Firestore (queries)
- M escritas Firestore (updates)

**Exemplo**: Se uma barbearia tem 50 vagas e 100 candidaturas, uma mudança de nome gera:
- 1 invocação Cloud Function
- 151 leituras Firestore (50 vagas + 100 candidaturas + 1 perfil)
- 150 escritas Firestore (50 vagas + 100 candidaturas)

### 4. Rate Limiting

Se um usuário editar o perfil repetidamente (ex: bot), considere adicionar rate limiting:

```typescript
// TODO: Implementar rate limiting com Redis
const lastUpdate = await redisClient.get(`profile:${userId}:lastUpdate`);
if (Date.now() - lastUpdate < 60000) {
  console.warn(`Rate limit exceeded for ${userId}`);
  return null;
}
```

---

## 🐛 Troubleshooting

### Erro: "Cannot find module 'firebase-admin'"

**Solução**:
```bash
cd functions
npm install
```

### Erro: "tsc: command not found"

**Solução**:
```bash
npm install -g typescript
```

### Function não está sendo disparada

**Verificações**:
1. ✅ Deploy bem-sucedido? `firebase functions:list`
2. ✅ Document path correto? Deve ser exatamente `profiles/{userId}`
3. ✅ Logs têm erros? `firebase functions:log`

### Timeout (60s exceeded)

**Causa**: Muitas operações em lote (ex: 10.000 vagas).

**Soluções**:
- Limite o batch size (ex: processar 500 por vez)
- Aumente o timeout no código:
  ```typescript
  export const propagateProfileUpdate = functions
    .runWith({ timeoutSeconds: 300 })
    .firestore.document(...)
  ```

---

## 📚 Referências

- [Firebase Functions Docs](https://firebase.google.com/docs/functions)
- [Firestore Triggers](https://firebase.google.com/docs/functions/firestore-events)
- [Admin SDK Reference](https://firebase.google.com/docs/reference/admin)
- [Google Cloud Functions Best Practices](https://cloud.google.com/functions/docs/bestpractices)

---

**Última Atualização**: 2025-10-22
**Versão**: 1.0.0
**Autor**: BarberGO Team
**Status**: ✅ Production Ready (Aguardando Deploy)
