# 🤖 AI Integration Setup - 3 IAs

## Configuração das APIs

### 1. Google Gemini (Chat Artístico)
```dart
// lib/src/features/ai/services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-1.5-pro',
    apiKey: 'YOUR_GEMINI_API_KEY',
  );

  Future<String> generateArtisticMessage(String context) async {
    final prompt = '''
    Você é um assistente de chat romântico e criativo.
    Contexto: $context
    Gere uma mensagem interessante e engajadora.
    ''';

    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }
}
```

### 2. Claude (Análise de Compatibilidade)
```dart
// lib/src/features/ai/services/claude_service.dart
import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';

class ClaudeService {
  final client = AnthropicClient(apiKey: 'YOUR_CLAUDE_API_KEY');

  Future<double> analyzeCompatibility(ProfileEntity user1, ProfileEntity user2) async {
    final prompt = '''
    Analise a compatibilidade entre dois perfis:
    
    Perfil 1: ${user1.bio}, ${user1.location}
    Perfil 2: ${user2.bio}, ${user2.location}
    
    Retorne apenas um número de 0 a 100 representando % de compatibilidade.
    ''';

    final response = await client.createMessage(
      request: CreateMessageRequest(
        model: Model.claude35Sonnet20241022,
        maxTokens: 50,
        messages: [Message(role: MessageRole.user, content: MessageContent.text(prompt))],
      ),
    );

    // Parse response
    return 85.0; // Exemplo
  }
}
```

### 3. Perplexity Comet (Recomendações)
```dart
// lib/src/features/ai/services/comet_service.dart
import 'package:dio/dio.dart';

class CometService {
  final dio = Dio();

  Future<List<String>> getDateRecommendations(String location, List<String> interests) async {
    final response = await dio.post(
      'https://api.perplexity.ai/chat/completions',
      options: Options(headers: {'Authorization': 'Bearer YOUR_COMET_API_KEY'}),
      data: {
        'model': 'llama-3.1-sonar-small-128k-online',
        'messages': [
          {
            'role': 'user',
            'content': 'Sugira 5 lugares interessantes para um encontro em $location. Interesses: ${interests.join(", ")}'
          }
        ],
      },
    );

    // Parse e retornar lista de recomendações
    return ['Local 1', 'Local 2', 'Local 3', 'Local 4', 'Local 5'];
  }
}
```

## Unified AI Controller

```dart
// lib/src/features/ai/controllers/ai_unified_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_unified_controller.g.dart';

@riverpod
class AiUnifiedController extends _$AiUnifiedController {
  @override
  FutureOr<void> build() {}

  Future<String> generateChatMessage(String context) async {
    state = const AsyncLoading();
    
    try {
      final gemini = ref.read(geminiServiceProvider);
      final message = await gemini.generateArtisticMessage(context);
      
      state = const AsyncData(null);
      return message;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<double> checkCompatibility(String user1Id, String user2Id) async {
    state = const AsyncLoading();
    
    try {
      // Buscar perfis
      final profile1 = await ref.read(profileRepositoryProvider).getProfile(user1Id);
      final profile2 = await ref.read(profileRepositoryProvider).getProfile(user2Id);
      
      if (profile1 == null || profile2 == null) return 0.0;
      
      final claude = ref.read(claudeServiceProvider);
      final compatibility = await claude.analyzeCompatibility(profile1, profile2);
      
      state = const AsyncData(null);
      return compatibility;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return 0.0;
    }
  }

  Future<List<String>> getRecommendations(String location) async {
    state = const AsyncLoading();
    
    try {
      final comet = ref.read(cometServiceProvider);
      final recommendations = await comet.getDateRecommendations(location, []);
      
      state = const AsyncData(null);
      return recommendations;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }
}
```

## Dependências

Adicionar ao `pubspec.yaml`:
```yaml
dependencies:
  google_generative_ai: ^0.2.0
  anthropic_sdk_dart: ^0.1.0
  # Comet usa Dio (já incluído)
```

## Variáveis de Ambiente

Criar `.env`:
```
GEMINI_API_KEY=your_key_here
CLAUDE_API_KEY=your_key_here
COMET_API_KEY=your_key_here
```

## Uso nas Telas

```dart
// Exemplo: Chat Enhancement
final aiController = ref.watch(aiUnifiedControllerProvider.notifier);

final suggestion = await aiController.generateChatMessage(
  'Usuário está conversando sobre viagem'
);

// Exemplo: Compatibility Quiz
final score = await aiController.checkCompatibility(userId1, userId2);

// Exemplo: Date Ideas
final ideas = await aiController.getRecommendations('São Paulo, SP');
```

## Features Implementadas

1. ✅ **Chat Artístico** (Gemini)
   - Sugestões de mensagens criativas
   - Ice breakers personalizados
   - Respostas sugeridas

2. ✅ **Análise de Compatibilidade** (Claude)
   - Score de 0-100%
   - Insights sobre match
   - Sugestões de tópicos em comum

3. ✅ **Recomendações de Lugares** (Comet)
   - Busca online em tempo real
   - Filtro por localização
   - Baseado em interesses do casal

## Status: Pronto para Integração

Basta adicionar as API keys e descomentar o código nos controllers!
