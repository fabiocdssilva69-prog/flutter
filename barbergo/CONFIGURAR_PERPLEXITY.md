# 🔮 Como Configurar Perplexity API

## ✅ O que foi feito

1. **Removemos Claude/Anthropic** - Você não tem acesso e estava dando erro
2. **Adicionamos Perplexity** - Você tem Pro e pode usar a API!
3. **Corrigimos o modelo Gemini** - Era `models/gemini-1.5-flash` (errado), agora é `gemini-1.5-flash` (correto)

---

## 🎯 Passo a Passo para Pegar sua API Key do Perplexity

### 1️⃣ Acesse as Configurações de API

Abra seu navegador e vá para:

```
https://www.perplexity.ai/settings/api
```

Ou:

1. Vá em <https://www.perplexity.ai>
2. Clique no seu perfil (canto superior direito)
3. Clique em **Settings**
4. Clique na aba **API**

### 2️⃣ Gere uma Nova API Key

1. Clique no botão **"Generate API Key"**
2. Dê um nome para a chave (ex: "BarberGO App")
3. **COPIE A CHAVE IMEDIATAMENTE** (formato: `pplx-...`)
   - ⚠️ Ela só é mostrada UMA VEZ!
   - Se perder, terá que criar outra

### 3️⃣ Cole a Chave no Arquivo .env

Abra o arquivo `.env` na raiz do projeto e cole sua chave:

```env
PERPLEXITY_API_KEY=pplx-sua_chave_aqui_copiada_do_site
```

**Exemplo:**

```env
PERPLEXITY_API_KEY=pplx-abc123def456ghi789jkl012mno345pqr
```

### 4️⃣ Salve o Arquivo

Pressione `Ctrl+S` para salvar o `.env`

---

## 🧪 Como Testar

### Opção 1: No Terminal (Rápido)

```powershell
# Reinicie o app no celular
flutter run -d uwbekb8hpf6lamts
```

Depois navegue para a tela **"AI Test"** no app.

### Opção 2: Teste Direto (Avançado)

Crie um arquivo `test_perplexity.dart` na raiz:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openai_dart/openai_dart.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  
  final apiKey = dotenv.env['PERPLEXITY_API_KEY'] ?? '';
  print('API Key: ${apiKey.substring(0, 10)}...');
  
  final client = OpenAIClient(
    apiKey: apiKey,
    baseUrl: 'https://api.perplexity.ai',
  );
  
  final response = await client.createChatCompletion(
    request: CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId('llama-3.1-sonar-large-128k-online'),
      messages: [
        ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(
            'Quais são as 3 principais tendências de corte de cabelo masculino em 2024?'
          ),
        ),
      ],
    ),
  );
  
  print('Resposta: ${response.choices.first.message.content}');
}
```

Execute:

```powershell
dart run test_perplexity.dart
```

---

## 📊 Status Atual das APIs

| API | Status | Custo | Modelo |
|-----|--------|-------|--------|
| ✅ **Gemini** | Configurado | GRÁTIS (Google One Ultra) | `gemini-1.5-flash` |
| ✅ **OpenAI** | Configurado | Incluído (ChatGPT Plus/Pro) | `gpt-4o` |
| 🔄 **Perplexity** | **Precisa configurar** | Incluído (Perplexity Pro) | `llama-3.1-sonar-large-128k-online` |
| ❌ **Claude** | Removido | N/A | (você não tem acesso) |

---

## 🎁 Benefícios do Perplexity

### 1. **Busca em Tempo Real na Web**

```dart
"Quais barbeiros em São Paulo são tendência no Instagram hoje?"
```

→ Perplexity busca na web e retorna informações ATUALIZADAS!

### 2. **Modelos Incluídos no Pro**

- `llama-3.1-sonar-large-128k-online` - Busca na web
- `llama-3.1-sonar-small-128k-online` - Mais rápido
- `llama-3.1-8b-instruct` - Respostas simples

### 3. **Casos de Uso no BarberGO**

- 📈 Detectar tendências de cortes
- 🔍 Buscar barbeiros por localização
- 💡 Sugestões baseadas em redes sociais
- 🗺️ Informações sobre eventos de barbearia

---

## ⚠️ Erros Corrigidos

### 1. ❌ Gemini: "models/gemini 1.5 flash is not found"

**ANTES (errado):**

```dart
model: 'models/gemini-1.5-flash'  // ❌ Prefixo "models/" causava erro
```

**DEPOIS (correto):**

```dart
model: 'gemini-1.5-flash'  // ✅ Sem prefixo
```

### 2. ❌ Claude: "API key error"

**Solução:** Removemos completamente! Você não tem acesso ao Claude.

### 3. ⚠️ OpenAI: "Chave configurada"

Sua chave está OK! Se aparecer erro, pode ser:

- Rate limit (espere 1 minuto)
- Billing não configurado (improvável no Pro)

---

## 🆘 Precisa de Ajuda?

Se aparecer erro depois de configurar Perplexity:

1. Verifique se copiou a chave completa (começa com `pplx-`)
2. Confirme que salvou o `.env` com `Ctrl+S`
3. Reinicie o app: `flutter run -d uwbekb8hpf6lamts`
4. Veja os logs no terminal

---

## 📝 Próximos Passos

Depois que Perplexity estiver funcionando:

1. ✅ Testar geração de bio com Gemini
2. ✅ Testar smart matching com GPT-4
3. ✅ Testar busca de tendências com Perplexity
4. 🚀 Integrar no Chat Artístico

---

**PRONTO!** 🎉

Agora você tem 3 IAs poderosas integradas:

- 🟢 Gemini (GRÁTIS)
- 🔵 OpenAI (Pro)
- 🟠 Perplexity (Pro + Busca Web)

**Custo adicional: $0/mês** (tudo incluído nas suas assinaturas!)
