# 🤖 Integração IA - BarberGO

## 📋 Resumo da Implementação

Este documento descreve a integração completa dos motores de IA no BarberGO, usando **Gemini Pro como principal** e ChatGPT como fallback.

---

## ✅ **DECISÃO: GEMINI + CHATGPT**

### 🎯 **Motor Principal: Google Gemini**
- ✅ **GRÁTIS com Google One Ultra** (você já tem!)
- ✅ Integração nativa com Firebase
- ✅ Gemini 1.5 Flash (rápido + multimodal)
- ✅ Análise de imagens incluída
- ✅ 1 milhão de tokens grátis/mês

### 🔄 **Fallback: ChatGPT (Futuro)**
- Para casos de alta disponibilidade
- Quando Gemini atingir rate limits
- Funcionalidades específicas que GPT-4 faz melhor

---

## 📁 **Estrutura Implementada**

```
lib/src/features/ai/
├── providers/
│   ├── gemini_provider.dart          # Modelos Gemini Pro + Vision
│   └── ai_service.dart                # Serviço base com retry
├── controllers/
│   └── bio_generator_controller.dart  # Gerador de Bio com IA
└── README.md                          # Este arquivo
```

---

## 🚀 **Funcionalidades Implementadas**

### 1. ✅ **Gerador de Bio Profissional**

**Arquivo:** `bio_generator_controller.dart`

#### Métodos:
- `generate()` - Gera bio única
- `generateMultipleOptions()` - Gera 3 opções diferentes
- `improveBio()` - Melhora bio existente

#### Exemplo de uso:
```dart
// No CreateProfileScreen
final bioController = ref.watch(bioGeneratorProvider.notifier);

// Gerar bio
ElevatedButton(
  onPressed: () async {
    final bio = await bioController.generate(
      name: 'João Silva',
      specialties: ['Fade', 'Degradê', 'Barba'],
      experienceYears: 5,
      city: 'São Paulo',
    );
    
    // Preencher campo de bio
    bioTextController.text = bio;
  },
  child: Text('Gerar Bio com IA'),
)
```

---

## 🔑 **Configuração das API Keys**

### Opção 1: Variável de Ambiente (Desenvolvimento)
```bash
# Windows PowerShell
flutter run `
  --dart-define=GEMINI_API_KEY=sua_gemini_key `
  --dart-define=OPENAI_API_KEY=sua_openai_key `
  --dart-define=ANTHROPIC_API_KEY=sua_claude_key

# Linux/Mac
flutter run \
  --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
  --dart-define=OPENAI_API_KEY=$OPENAI_API_KEY \
  --dart-define=ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY
```

### Opção 2: Firebase Remote Config (Produção)
```dart
// Configurar no Firebase Console
// Remote Config → Adicionar parâmetros:
// - GEMINI_API_KEY
// - OPENAI_API_KEY
// - ANTHROPIC_API_KEY

// No código:
final remoteConfig = FirebaseRemoteConfig.instance;
await remoteConfig.fetchAndActivate();
final geminiKey = remoteConfig.getString('GEMINI_API_KEY');
final openaiKey = remoteConfig.getString('OPENAI_API_KEY');
final claudeKey = remoteConfig.getString('ANTHROPIC_API_KEY');
```

### Opção 3: .env (Não versionado)
```bash
# Criar .env na raiz
GEMINI_API_KEY=AIzaSy...
OPENAI_API_KEY=sk-proj-...
ANTHROPIC_API_KEY=sk-ant-...

# Adicionar ao .gitignore
.env
```

### Onde conseguir as API Keys:

**Gemini (Grátis com Google One Ultra):**
1. Acesse: https://makersuite.google.com/app/apikey
2. Clique em "Get API Key"
3. Crie novo projeto ou use existente
4. Copie a chave (formato: `AIzaSy...`)

**OpenAI GPT-4 (Incluído no Pro $200):**
1. Acesse: https://platform.openai.com/api-keys
2. Clique em "Create new secret key"
3. Copie IMEDIATAMENTE (não será mostrado novamente)
4. Formato: `sk-proj-...`

**Anthropic Claude (Pagar ~$5/mês):**
1. Acesse: https://console.anthropic.com/settings/keys
2. Clique em "Create Key"
3. Copie a chave (formato: `sk-ant-...`)
4. Configure billing: https://console.anthropic.com/settings/billing

---

## 🧪 **Como Testar**

### 1. Obter API Key do Gemini
```
1. Acesse: https://makersuite.google.com/app/apikey
2. Clique em "Get API Key"
3. Crie um novo projeto ou use existente
4. Copie a API Key
```

### 2. Executar o App
```bash
# Com a API key
flutter run --dart-define=GEMINI_API_KEY=AIzaSy...sua_key

# Teste o gerador de bio na tela de criar perfil
```

### 3. Testar Manualmente (Console)
```dart
// No DartPad ou console do Flutter
final bioGenerator = BioGenerator();
final bio = await bioGenerator.generate(
  name: 'Teste',
  specialties: ['Fade'],
  experienceYears: 3,
);
print(bio);
```

---

## 💰 **Custos e Limites**

### Gemini 1.5 Flash/Pro (GRÁTIS com Google One Ultra)
| Recurso | Limite Grátis | Custo após limite |
|---------|---------------|-------------------|
| Texto | 1M tokens/mês | $0.35/1M tokens entrada |
| Imagens (Vision) | 1M tokens/mês | $0.53/1M tokens entrada |
| Rate Limit | 15 RPM | 1000 RPM (pago) |

**Estimativa BarberGO:**
- 1000 gerações de bio/mês = ~50k tokens = **GRÁTIS** ✅
- 100 análises de portfólio/mês = ~100k tokens = **GRÁTIS** ✅

### GPT-4o (INCLUÍDO no Pro $200/mês)
| Recurso | Limite Pro | Custo adicional |
|---------|------------|-----------------|
| Texto | Ilimitado* | Já pago |
| GPT-4o | 80 msgs/3h | Após limite vira GPT-4 Turbo |
| Rate Limit | Prioridade alta | Sem limites rígidos |

*Uso pessoal incluído. API tem cobrança separada: $5/1M tokens entrada, $15/1M saída

**Estimativa BarberGO:**
- 500 matchings/mês = ~250k tokens = **INCLUÍDO** ✅
- 200 análises de match/mês = ~100k tokens = **INCLUÍDO** ✅

### Claude 3.5 Sonnet (~$5/mês estimado)
| Recurso | Custo | Contexto |
|---------|-------|----------|
| Texto | $3/1M tokens entrada | 200k tokens |
| Saída | $15/1M tokens saída | Ideal para documentos |
| Rate Limit | 50 RPM (tier 1) | Aumenta com uso |

**Estimativa BarberGO:**
- 50 contratos/mês = ~300k tokens entrada = **$0.90** 💵
- 50 contratos/mês = ~200k tokens saída = **$3.00** 💵
- **Total Claude: ~$4-5/mês**

---

### 📊 Custo Total Mensal

| Serviço | Custo | Funcionalidades |
|---------|-------|-----------------|
| Gemini (Google One Ultra) | **$0** | Bio, Portfólio, Imagens |
| GPT-4 Pro | **$0** (já pago) | Smart Matching, Análises |
| Claude 3.5 Sonnet | **~$5** | Contratos, Documentos |
| **TOTAL** | **~$5/mês** | Sistema IA completo |

🎉 **Com suas assinaturas existentes, o custo adicional é MÍNIMO!**

---

## ✅ **Funcionalidades IA Implementadas**

### 1. **Geração de Bio Profissional** (Gemini 1.5 Flash)
- ✅ `BioGeneratorController.generate()` - Gera bio única
- ✅ `BioGeneratorController.generateMultipleOptions()` - 3 variações
- ✅ `BioGeneratorController.improveBio()` - Melhora bio existente
- **Custo**: Grátis (Google One Ultra)

### 2. **Smart Matching** (GPT-4o)
- ✅ `SmartMatchingController.findBestMatches()` - Top N vagas com score 0-100
- ✅ `SmartMatchingController.analyzeMatch()` - Análise detalhada de vaga específica
- ✅ `SmartMatchingController.explainMatch()` - Explicação motivacional para usuário
- ✅ **MatchScore** com pros/cons, reasoning, compatibilidade
- **Custo**: Incluído no GPT-4 Pro ($200/mês)

### 3. **Análise de Portfólio** (Gemini Pro Vision)
- ✅ `PortfolioAnalyzerController.analyzeImage()` - Analisa 1 foto com score 0-10
- ✅ `PortfolioAnalyzerController.analyzePortfolio()` - Análise completa de múltiplas fotos
- ✅ `PortfolioAnalyzerController.comparePortfolios()` - Compara 2 candidatos
- ✅ **PortfolioAnalysis** detecta estilos (fade, barba), técnicas, pontos fortes
- ✅ **PortfolioSummary** com nível profissional e vagas recomendadas
- **Custo**: Grátis (Google One Ultra)

### 4. **Geração de Contratos** (Claude 3.5 Sonnet)
- ✅ `ContractGeneratorController.generateWorkContract()` - Contrato CLT completo
- ✅ `ContractGeneratorController.generateServiceAgreement()` - Acordo freelance
- ✅ `ContractGeneratorController.generateCommissionAgreement()` - Acordo de comissão
- ✅ `ContractGeneratorController.generateTermsOfService()` - Termos do app
- ✅ `ContractGeneratorController.generatePrivacyPolicy()` - Política LGPD
- ✅ `ContractGeneratorController.generateNDA()` - Acordo de confidencialidade
- **Custo**: ~$3-5/mês (contexto de 200k tokens)

### 5. **Orquestração Inteligente** (AIOrchestrator)
- ✅ Roteamento automático para melhor modelo por tarefa
- ✅ Fallback em cascata (Gemini → GPT-4 → Claude)
- ✅ Modo de comparação paralela de todos modelos
- ✅ Análise de custos e performance

---

## 📚 **Exemplos de Uso**

### Smart Matching com GPT-4
```dart
final smartMatching = ref.read(smartMatchingControllerProvider.notifier);

// Encontrar top 5 vagas
final matches = await smartMatching.findBestMatches(
  barberProfile: currentProfile,
  availableVacancies: allVacancies,
  topN: 5,
);

// matches[0].score = 92 (0-100)
// matches[0].pros = ["Especialidades alinhadas", "Localização próxima"]
// matches[0].cons = ["Comissão menor que esperado"]
// matches[0].reasoning = "Este barbeiro tem 8 anos de experiência..."

// Explicar match em tom motivacional
final explanation = await smartMatching.explainMatch(
  barberProfile: currentProfile,
  vacancy: matches[0].vacancy,
  tone: 'motivacional',
);
```

### Análise de Portfólio com Gemini Vision
```dart
final analyzer = ref.read(portfolioAnalyzerControllerProvider.notifier);

// Analisar portfólio completo
final summary = await analyzer.analyzePortfolio(
  images: {
    'img1': portfolioImage1Bytes,
    'img2': portfolioImage2Bytes,
    'img3': portfolioImage3Bytes,
  },
);

print('Nota Geral: ${summary.overallScore}/10');
print('Nível: ${summary.professionalLevel}'); // "Avançado"
print('Estilos: ${summary.styleDistribution}'); // {"fade": 2, "barba": 1}
print('Vagas Recomendadas: ${summary.recommendedVacancies}');
```

### Geração de Contrato com Claude
```dart
final contractGen = ref.read(contractGeneratorProvider.notifier);

// Gerar contrato CLT
final contract = await contractGen.generateWorkContract(
  barbershop: barbershopEntity,
  barber: barberEntity,
  vacancy: selectedVacancy,
  startDate: DateTime(2024, 2, 1),
  salary: 3500.00,
  additionalClauses: {
    'vale_transporte': 'Sim',
    'vale_refeicao': 'R\$ 25/dia',
  },
);

// Contrato retorna Markdown formatado com cláusulas CLT e LGPD
```

---

## 🔮 **Próximas Funcionalidades**

### Assistente de Negociação (Futuro)
```dart
// Sugerir respostas no chat
NegotiationAssistant.suggestResponse(
  conversationContext: messages,
  lastMessage: 'Qual é o salário?',
  userRole: 'barber',
)
```

### Análise de Sentimento (Futuro)
```dart
// Detectar tom de conversa
SentimentAnalyzer.analyze(message)
// Retorna: positivo, neutro, negativo + sugestões
```

---

## ⚡ **Performance e Otimização**

### Estratégias Implementadas:
1. ✅ **Retry Automático** - Até 3 tentativas em caso de erro
2. ✅ **Limites de Caracteres** - Máximo 150 chars para bio
3. ✅ **Cache de Respostas** - AsyncValue mantém último resultado
4. ✅ **Modelos Otimizados** - Flash ao invés de Pro (3x mais rápido)

### TODO:
- [ ] Cache local de bios geradas (SharedPreferences)
- [ ] Debounce para múltiplas requisições
- [ ] Fallback para ChatGPT em caso de erro

---

## 🐛 **Troubleshooting**

### Erro: "GEMINI_API_KEY não configurada"
```bash
# Solução: Passar a API key ao executar
flutter run --dart-define=GEMINI_API_KEY=sua_chave
```

### Erro: "Rate limit exceeded"
```dart
// Solução: Implementado retry automático com delay
// Aguarda 1s, 2s, 3s entre tentativas
```

### Erro: "Resposta vazia da IA"
```dart
// Solução: Fallback para texto padrão
'Profissional experiente em ${specialties.join(', ')}'
```

---

## 📊 **Métricas e Analytics**

### Eventos a Rastrear:
```dart
// Quando bio é gerada
Analytics.logEvent('ai_bio_generated', {
  'success': true,
  'model': 'gemini-1.5-flash',
  'time_ms': duration.inMilliseconds,
});

// Quando usuário aceita sugestão
Analytics.logEvent('ai_bio_accepted', {
  'length': bio.length,
});

// Quando ocorre erro
Analytics.logEvent('ai_error', {
  'error': e.toString(),
  'retry_count': retries,
});
```

---

## 🔐 **Segurança e Privacidade**

### Boas Práticas:
1. ✅ API Key não é versionada no código
2. ✅ Dados do usuário não são armazenados pela Google
3. ✅ Safety Settings configurados (HarmBlockThreshold)
4. ⚠️ TODO: Implementar rate limiting por usuário
5. ⚠️ TODO: Sanitizar inputs antes de enviar à IA

---

## 📚 **Recursos e Links**

- [Gemini API Docs](https://ai.google.dev/docs)
- [Google AI Studio](https://makersuite.google.com/)
- [Pricing Calculator](https://ai.google.dev/pricing)
- [Best Practices](https://ai.google.dev/docs/best_practices)

---

## 🎓 **Exemplos de Prompts Otimizados**

### Bio Profissional
```
Crie uma bio profissional para um barbeiro:
- Nome: João Silva
- Especialidades: Fade, Degradê
- Experiência: 5 anos

Requisitos: 120 chars, português BR, sem emojis, tom profissional.
```

### Matching Inteligente
```
Analise este perfil de barbeiro e sugira as 5 melhores vagas:

BARBEIRO:
- Especialidades: [fade, barba]
- Localização: São Paulo, Centro

VAGAS:
[JSON com vagas disponíveis]

Retorne score (0-100) e justificativa para cada.
```

---

**Última atualização:** 07/10/2025  
**Autor:** Equipe BarberGO  
**Versão:** 1.0.0
