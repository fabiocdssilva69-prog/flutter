# 🔑 Guia Completo: Como Adicionar as API Keys

## ✅ Passo a Passo

### 1️⃣ Conseguir as API Keys

#### 🟢 Gemini API Key (GRÁTIS com Google One Ultra)
1. Acesse: https://makersuite.google.com/app/apikey
2. Faça login com sua conta Google (a mesma do Google One Ultra)
3. Clique em **"Get API Key"** ou **"Create API Key"**
4. Selecione um projeto existente ou crie um novo
5. Copie a chave (formato: `AIzaSy...`)
6. **Guarde essa chave!**

#### 🔵 OpenAI API Key (Incluído no seu Pro $200/mês)
1. Acesse: https://platform.openai.com/api-keys
2. Faça login com sua conta OpenAI Pro
3. Clique em **"Create new secret key"**
4. Dê um nome (ex: "BarberGO App")
5. **COPIE IMEDIATAMENTE** (não será mostrado novamente!)
6. Formato: `sk-proj-...`

#### 🟣 Claude API Key (~$5/mês)
1. Acesse: https://console.anthropic.com/settings/keys
2. Crie uma conta ou faça login
3. Configure **billing** primeiro: https://console.anthropic.com/settings/billing
4. Volte para Keys: https://console.anthropic.com/settings/keys
5. Clique em **"Create Key"**
6. Copie a chave (formato: `sk-ant-...`)

---

### 2️⃣ Adicionar as Keys no Arquivo .env

O arquivo `.env` já foi criado na raiz do projeto: `c:\workspaces\fabiocdssilva69-prog\barbergo\.env`

**Abra o arquivo** e substitua `sua_key_aqui` pelas suas chaves:

```env
# ANTES (como está agora):
GEMINI_API_KEY=sua_key_aqui
OPENAI_API_KEY=sua_key_aqui
ANTHROPIC_API_KEY=sua_key_aqui

# DEPOIS (com suas chaves reais):
GEMINI_API_KEY=AIzaSyC1234567890abcdef...
OPENAI_API_KEY=sk-proj-abc123xyz789...
ANTHROPIC_API_KEY=sk-ant-api03-xyz456...
```

⚠️ **IMPORTANTE**: 
- Não adicione espaços antes ou depois das chaves
- Não adicione aspas (" ou ') ao redor das chaves
- Mantenha exatamente este formato: `NOME=valor`

---

### 3️⃣ Verificar se está Funcionando

Depois de adicionar as keys, execute:

```bash
flutter run
```

Se as keys estiverem corretas, o app vai iniciar normalmente.

Se houver erro, você verá uma mensagem clara indicando qual key está faltando ou inválida.

---

## 🔒 Segurança

✅ **O arquivo `.env` está no `.gitignore`** - Suas keys NUNCA serão commitadas no Git

✅ **Só você tem acesso** - O arquivo fica apenas na sua máquina

✅ **Não precisa passar keys via comando** - Muito mais seguro que `--dart-define`

---

## 🧪 Teste Rápido das APIs

Depois de configurar, você pode testar cada API:

### Teste do Gemini (Bio Generator)
```dart
// Em qualquer tela, adicione um botão:
ElevatedButton(
  onPressed: () async {
    final bioGenerator = ref.read(bioGeneratorProvider.notifier);
    final bio = await bioGenerator.generate(
      name: 'Teste',
      specialties: ['Fade', 'Barba'],
      experienceYears: 5,
    );
    print('Bio gerada: $bio');
  },
  child: Text('Testar Gemini'),
)
```

### Teste do GPT-4 (Smart Matching)
```dart
// Teste de matching
final smartMatching = ref.read(smartMatchingControllerProvider.notifier);
final matches = await smartMatching.findBestMatches(
  barberProfile: currentProfile,
  availableVacancies: allVacancies,
  topN: 3,
);
print('Matches encontrados: ${matches.length}');
```

### Teste do Claude (Contract Generator)
```dart
// Teste de geração de contrato
final contractGen = ref.read(contractGeneratorProvider.notifier);
final terms = await contractGen.generateTermsOfService();
print('Termos gerados: ${terms.substring(0, 100)}...');
```

---

## 🐛 Troubleshooting

### Erro: "GEMINI_API_KEY não configurada"
✅ Solução: Verifique se você:
1. Copiou a key corretamente (sem espaços)
2. Salvou o arquivo `.env`
3. Reiniciou o app (`flutter run`)

### Erro: "API key invalid"
✅ Solução:
- **Gemini**: Verifique se a key começa com `AIzaSy`
- **OpenAI**: Verifique se começa com `sk-proj-` ou `sk-`
- **Claude**: Verifique se começa com `sk-ant-`

### Erro: "Billing not configured" (Claude)
✅ Solução: Configure billing em https://console.anthropic.com/settings/billing
- Adicione um cartão de crédito
- Custo estimado: ~$5/mês para 50 contratos

### App não inicia
✅ Solução:
```bash
# Limpe o cache e reconstrua
flutter clean
flutter pub get
flutter run
```

---

## 💡 Dicas

### Gemini (GRÁTIS)
- ✅ Use à vontade para bios, análises de imagens
- ✅ Limite: 1M tokens/mês (suficiente para 20.000+ bios)

### GPT-4 (Incluído no Pro)
- ✅ Use para análises complexas, matching
- ⚠️ Evite para tarefas simples (use Gemini)

### Claude (Pago)
- 💰 Use APENAS para contratos e documentos longos
- ✅ Contexto de 200k tokens (ideal para contratos CLT)
- 💡 Custo: ~$0.10 por contrato gerado

---

## 📊 Status Atual

Após seguir este guia, você terá:

✅ Arquivo `.env` configurado com suas 3 API keys
✅ App pronto para usar IA em todas as features
✅ Custo total: **~$5/mês** (apenas Claude)
✅ Sistema IA enterprise com 3 modelos otimizados

---

## 🚀 Próximos Passos

1. ✅ Adicione as keys no `.env`
2. ✅ Execute `flutter run`
3. ✅ Teste a geração de bio em Criar Perfil
4. ✅ Veja as vagas recomendadas na Home
5. ✅ Faça upload de fotos e veja a análise

**Pronto! Seu BarberGO com IA está funcionando!** 🎉
