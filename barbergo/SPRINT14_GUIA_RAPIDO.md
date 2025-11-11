# 🚀 Sprint 14 - Guia Rápido de Referência

## ✅ O Que Foi Implementado

Sistema de **validação de API Key da OpenAI** em duas camadas com inicialização assíncrona.

---

## 🔑 Como Funciona

### 1️⃣ Validação Estática (Regex)
**Onde:** `lib/src/core/config/config.dart`

```dart
// Formato esperado: sk-proj-[100+ caracteres alfanuméricos]
static String get openAIKey {
  final key = dotenv.env['OPENAI_API_KEY'];
  if (!_openAIKeyFormat.hasMatch(key)) {
    throw Exception("Formato inválido da chave da OpenAI");
  }
  return key;
}
```

**Detecta:**
- ✅ Chave ausente no `.env`
- ✅ Formato incorreto (não começa com `sk-proj-`)
- ✅ Tamanho insuficiente (< 100 caracteres)

---

### 2️⃣ Validação Dinâmica (API Test)
**Onde:** `lib/src/core/services/ai_service.dart`

```dart
@riverpod
Future<AiService> aiService(Ref ref) async {
  final apiKey = Config.openAIKey; // Validação estática
  final service = AiService(apiKey: apiKey, logger: logger);
  
  final isValid = await service.validateApiKey(); // Validação dinâmica
  
  if (!isValid) {
    throw Exception("Chave inválida ou cota excedida");
  }
  
  return service;
}
```

**Método de Validação:**
```dart
Future<bool> validateApiKey() async {
  try {
    final response = await _dio.get('models'); // GET /v1/models
    return response.statusCode == 200;
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      // Chave inválida
    } else if (e.response?.statusCode == 429) {
      // Cota excedida
    }
    return false;
  }
}
```

**Detecta:**
- ✅ Chave inválida (401 Unauthorized)
- ✅ Cota excedida (429 Rate Limited)
- ✅ Problemas de rede (timeout 10s)

---

### 3️⃣ Cascata Assíncrona

```
Config.openAIKey (estática)
    ↓ throws se inválido
AiService Provider (dinâmica)
    ↓ throws se não conectar
Persona Providers (async)
    ↓ throws se AiService falhou
ChatController.build() (async)
    ↓ entra em AsyncError
UI mostra erro ao usuário
```

---

## 📁 Arquivos Modificados

| Arquivo | Mudança | Tipo |
|---------|---------|------|
| `core/config/config.dart` | Adicionado Regex validation | Estático |
| `core/services/ai_service.dart` | Provider → FutureProvider + validateApiKey() | Assíncrono |
| `features/ai/personas/business_consultant_persona.dart` | Provider → FutureProvider | Assíncrono |
| `features/ai/personas/artistic_chatbot_persona.dart` | Provider → FutureProvider | Assíncrono |
| `features/ai/personas/writing_assistant_persona.dart` | Provider → FutureProvider | Assíncrono |
| `features/ai/controllers/chat_controller.dart` | aiPersona → FutureProvider + build() async | Assíncrono |

---

## 🛠️ Como Usar

### No Código

```dart
// Antes (síncrono)
final aiService = ref.watch(aiServiceProvider);

// Depois (assíncrono)
final aiService = await ref.read(aiServiceProvider.future);
```

### Na UI

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final chatState = ref.watch(chatControllerProvider('artistic'));
  
  return chatState.when(
    loading: () => CircularProgressIndicator(), // Validando API...
    data: (data) => ChatView(data), // Tudo OK, chat funcional
    error: (error, stack) => ErrorView(error), // Chave inválida!
  );
}
```

---

## 🔍 Troubleshooting

### Erro: "Formato inválido da chave da OpenAI"
**Causa:** Regex validation failed  
**Solução:** Verifique se a chave no `.env` segue o padrão `sk-proj-XXXXX...` com 100+ caracteres

### Erro: "Falha na Validação (Dinâmica) do AiService"
**Causa:** API test failed (401, 429, ou timeout)  
**Soluções:**
- 401: Chave expirada ou inválida → Gerar nova chave no OpenAI
- 429: Cota excedida → Aguardar ou upgradar plano
- Timeout: Sem internet → Verificar conexão

### Erro: "Usuário não autenticado"
**Causa:** Tentativa de usar chat sem login  
**Solução:** Fazer login primeiro

---

## 📊 Logs Gerados

```
AI_KeyValidation_Start → Iniciou validação
AI_KeyValidation_Success → Validação OK
AI_KeyValidation_Failed → Validação falhou
  └─ reason: "Authentication Failed (Invalid Key)"
  └─ reason: "Quota Exceeded or Rate Limited"
  └─ reason: "Network Error or Timeout"
```

---

## 🧪 Como Testar

### Teste 1: Chave Válida
1. Configure chave válida no `.env`
2. Inicie o app
3. Abra qualquer chat de IA
4. **Esperado:** Chat carrega normalmente

### Teste 2: Chave Inválida (Formato)
1. Configure chave com formato errado: `sk-wrong-format`
2. Inicie o app
3. Abra qualquer chat de IA
4. **Esperado:** Erro "Formato inválido da chave da OpenAI"

### Teste 3: Chave Inválida (API)
1. Configure chave com formato correto mas inválida
2. Inicie o app
3. Abra qualquer chat de IA
4. **Esperado:** Erro "Falha na Validação (Dinâmica)"

### Teste 4: Sem Internet
1. Configure chave válida
2. Desabilite internet
3. Inicie o app
4. Abra qualquer chat de IA
5. **Esperado:** Timeout após 10 segundos

---

## 📦 Dependências Adicionadas

```yaml
# pubspec.yaml
dependencies:
  dio: ^5.7.0 # HTTP client para validação de API
```

**Instalada:** dio 5.9.0

---

## 🏗️ Build Runner

Sempre execute após mudanças em providers `@riverpod`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Gera:**
- `*.g.dart` files com código dos providers
- Necessário quando assinaturas mudam (sync → async)

---

## 💡 Dicas

### Performance
- Validação dinâmica ocorre **uma vez** na inicialização
- Timeout de 10s evita travar o app indefinidamente
- Resultado é cacheado pelo FutureProvider

### Segurança
- API key nunca exposta em logs
- Validação local (Regex) antes de chamada de rede
- Mensagens de erro genéricas para usuário final

### UX
- Loading indicator durante validação
- Mensagens de erro claras
- Retry automático não implementado (fail-fast)

---

## 📚 Recursos

- [Riverpod Async Providers](https://riverpod.dev/docs/concepts/providers#futureprovider)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)

---

**✅ Sprint 14 Concluída - Sistema de Validação Robusto Implementado**

_Fail-fast, async-first, production-ready_ 🚀
