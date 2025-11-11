# 🚀 GUIA RÁPIDO - Cloud Functions

Comandos essenciais para trabalhar com Firebase Cloud Functions no BarberGO.

---

## 📦 SETUP INICIAL (Apenas uma vez)

```bash
# 1. Entrar no diretório functions
cd functions

# 2. Instalar dependências (454 packages)
npm install

# 3. Compilar TypeScript → JavaScript
npm run build
```

✅ **Resultado Esperado**: Pasta `functions/lib/` criada com arquivos `.js`

---

## 🛠️ DESENVOLVIMENTO LOCAL

### Compilar Código

```bash
cd functions
npm run build
```

### Watch Mode (recompila automaticamente)

```bash
cd functions
npm run build:watch
```

Deixe este terminal aberto durante o desenvolvimento. Toda vez que você editar um arquivo `.ts`, ele será recompilado automaticamente.

---

## 🔥 EMULADOR LOCAL

### Iniciar Emulador

```bash
cd c:\workspaces\fabiocdssilva69-prog\barbergo
firebase emulators:start
```

**Serviços Disponíveis**:
- Functions: http://localhost:5001
- Firestore: http://localhost:8080
- Auth: http://localhost:9099
- UI: http://localhost:4000 ← **Abrir no navegador**

### Testar Função Manualmente

1. Abra: http://localhost:4000 (Firebase Emulator UI)
2. Vá para **Firestore** → `profiles` collection
3. Edite um documento (mude o campo `name`)
4. Vá para **Logs** (canto esquerdo)
5. Observe: `Propagating changes for Profile {userId}`

---

## 🧪 TESTES

### Teste Automatizado (testProfilePropagation)

1. **Habilitar função de teste** no `functions/src/index.ts`:
   ```typescript
   // Descomente esta linha:
   export * from "./testTriggers";
   ```

2. **Recompilar**:
   ```bash
   cd functions
   npm run build
   ```

3. **Iniciar emulador**:
   ```bash
   firebase emulators:start
   ```

4. **Disparar teste via HTTP**:
   ```bash
   curl http://localhost:5001/barbergo-38c21/us-central1/testProfilePropagation
   ```

   **Ou abra no navegador**: http://localhost:5001/barbergo-38c21/us-central1/testProfilePropagation

5. **Ver resultado**: JSON com status de cada propagação (vacancy, application, chat_room).

⚠️ **IMPORTANTE**: Remova `export * from "./testTriggers"` antes do deploy em produção!

---

## 🚀 DEPLOY

### 1. Compilar Código

```bash
cd functions
npm run build
```

Verifique se **não há erros de TypeScript**.

### 2. Deploy Apenas Functions

```bash
cd c:\workspaces\fabiocdssilva69-prog\barbergo
firebase deploy --only functions
```

**Tempo estimado**: 2-5 minutos

### 3. Deploy Função Específica

```bash
firebase deploy --only functions:propagateProfileUpdate
```

### 4. Verificar Status

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

## 📊 MONITORAMENTO

### Ver Logs em Tempo Real

```bash
firebase functions:log
```

**Pressione Ctrl+C** para parar.

### Ver Logs Específicos

```bash
firebase functions:log --only propagateProfileUpdate
```

### Ver Logs das Últimas 2 Horas

```bash
firebase functions:log --since 2h
```

### Firebase Console (Interface Visual)

Acesse: https://console.firebase.google.com/project/barbergo-38c21/functions

Aqui você vê:
- 📈 Gráfico de invocações
- ⏱️ Tempo de execução médio
- ❌ Taxa de erros
- 💰 Custo estimado

---

## 🐛 TROUBLESHOOTING

### Erro: "Cannot find module 'firebase-admin'"

```bash
cd functions
npm install
```

### Erro: "tsc: command not found"

```bash
cd functions
npm install
```

O TypeScript já está instalado localmente no `node_modules/.bin/tsc`.

### Function não dispara

**Verificações**:
1. ✅ Deploy bem-sucedido? `firebase functions:list`
2. ✅ Document path correto? Deve ser `profiles/{userId}`
3. ✅ Logs têm erros? `firebase functions:log`
4. ✅ Campo realmente mudou? A função só dispara se `name` ou `location` mudarem.

### Emulator não inicia

**Causas Comuns**:
- Porta 5001 em uso (Skype, outro serviço)
- Firebase CLI desatualizado

**Soluções**:
```bash
# Atualizar Firebase CLI
npm install -g firebase-tools

# Usar portas alternativas
firebase emulators:start --port=5002
```

---

## 📝 CHECKLIST PRÉ-DEPLOY

Antes de fazer deploy em produção, verifique:

- [ ] ✅ `npm run build` compila sem erros
- [ ] ✅ Testado no emulador local
- [ ] ✅ Função de teste (`testTriggers`) **removida** ou comentada
- [ ] ✅ Logs do emulator não mostram erros críticos
- [ ] ✅ `firebase.json` aponta para `functions/` (source)
- [ ] ✅ `firebase.json` tem `predeploy: npm run build`

---

## 🎯 COMANDOS RÁPIDOS (COPIAR E COLAR)

### Desenvolvimento

```bash
# Terminal 1: Watch mode (recompila automaticamente)
cd functions && npm run build:watch

# Terminal 2: Emulador
cd c:\workspaces\fabiocdssilva69-prog\barbergo && firebase emulators:start

# Terminal 3: App Flutter
flutter run -d uwbekb8hpf6lamts
```

### Deploy

```bash
cd c:\workspaces\fabiocdssilva69-prog\barbergo
cd functions && npm run build && cd ..
firebase deploy --only functions
firebase functions:log --only propagateProfileUpdate
```

---

## 📚 PRÓXIMOS PASSOS

Após deploy bem-sucedido:

1. **Monitorar Logs**: Acompanhe por 24h para detectar erros
2. **Criar Alertas**: Configure alertas para taxa de erro > 5%
3. **Adicionar Testes**: Escreva testes unitários com Jest
4. **Rate Limiting**: Implemente limitação de taxa (Redis)
5. **Batch Processing**: Otimize para processar 500+ documentos

---

**Última Atualização**: 2025-10-22
**Versão**: 1.0.0
**Status**: ✅ Pronto para Deploy
