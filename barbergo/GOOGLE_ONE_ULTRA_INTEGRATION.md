# 🚀 Integração Google One Ultra - BarberGO

## 📋 Visão Geral
Este documento descreve como aproveitar os recursos premium do Google One Ultra (30TB + Gemini Pro) no projeto BarberGO.

---

## 🎯 Recursos Disponíveis

### 1. **Gemini Pro API** 🤖
**Benefício:** IA avançada do Google para funcionalidades inteligentes

#### Casos de Uso no BarberGO:

##### A. **Geração Automática de Bio Profissional**
```dart
// Exemplo de implementação
Future<String> generateProfessionalBio({
  required String name,
  required List<String> specialties,
  required int experienceYears,
}) async {
  final prompt = '''
  Crie uma bio profissional e atraente para um barbeiro com as seguintes características:
  Nome: $name
  Especialidades: ${specialties.join(', ')}
  Anos de experiência: $experienceYears
  
  A bio deve ser em português, ter no máximo 150 caracteres, e destacar expertise e personalidade.
  ''';
  
  // Chamar Gemini API
  final response = await geminiAPI.generateContent(prompt);
  return response.text;
}
```

##### B. **Matching Inteligente Barbeiro-Barbearia**
```dart
// Sistema de recomendação baseado em IA
Future<List<MatchScore>> intelligentMatching({
  required String barberId,
  required List<VacancyEntity> availableVacancies,
}) async {
  final barberProfile = await getBarberProfile(barberId);
  
  final prompt = '''
  Analise o perfil do barbeiro e sugira as 5 melhores vagas:
  
  Barbeiro:
  - Especialidades: ${barberProfile.specialties}
  - Localização: ${barberProfile.city}, ${barberProfile.neighborhood}
  - Bio: ${barberProfile.bio}
  
  Vagas disponíveis: ${jsonEncode(availableVacancies)}
  
  Retorne um JSON com score (0-100) e justificativa para cada vaga.
  ''';
  
  final response = await geminiAPI.generateContent(prompt);
  return parseMatchScores(response.text);
}
```

##### C. **Análise de Portfólio com Visão Computacional**
```dart
// Análise automática de fotos do portfólio
Future<PortfolioAnalysis> analyzePortfolio(List<String> imageUrls) async {
  final analysis = await geminiVision.analyzeImages(
    images: imageUrls,
    prompt: '''
    Analise essas fotos de trabalhos de barbearia e identifique:
    1. Estilos principais (fade, degradê, barba, etc)
    2. Nível de qualidade (1-10)
    3. Especialidades detectadas
    4. Sugestões de melhoria
    ''',
  );
  
  return PortfolioAnalysis.fromJson(analysis);
}
```

##### D. **Chat Assistente para Negociação**
```dart
// Assistente IA para ajudar nas negociações
class NegotiationAssistant {
  Future<String> suggestResponse({
    required String conversationContext,
    required String lastMessage,
    required String userRole, // 'barber' ou 'barbershop'
  }) async {
    final prompt = '''
    Você é um assistente de negociação para o app BarberGO.
    
    Contexto: $conversationContext
    Última mensagem: $lastMessage
    Papel do usuário: $userRole
    
    Sugira uma resposta profissional, cordial e que ajude a fechar o acordo.
    ''';
    
    final response = await geminiAPI.generateContent(prompt);
    return response.text;
  }
}
```

---

### 2. **Firebase Storage Premium** 📸
**Benefício:** 30TB para armazenamento de mídia

#### Implementação Otimizada:

```dart
// lib/src/data/repositories/storage_repository.dart
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  /// Upload de imagem de portfólio com compressão inteligente
  Future<String> uploadPortfolioImage({
    required String userId,
    required File imageFile,
  }) async {
    // Comprimir imagem mantendo qualidade
    final compressedImage = await compressImage(imageFile, quality: 85);
    
    final ref = _storage
        .ref()
        .child('portfolios')
        .child(userId)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    await ref.putFile(
      compressedImage,
      SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': userId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
    
    return await ref.getDownloadURL();
  }
  
  /// Upload múltiplo com progress tracking
  Future<List<String>> uploadMultipleImages({
    required String userId,
    required List<File> images,
    Function(double)? onProgress,
  }) async {
    final urls = <String>[];
    
    for (int i = 0; i < images.length; i++) {
      final url = await uploadPortfolioImage(
        userId: userId,
        imageFile: images[i],
      );
      urls.add(url);
      
      if (onProgress != null) {
        onProgress((i + 1) / images.length);
      }
    }
    
    return urls;
  }
  
  /// Galeria da barbearia
  Future<String> uploadBarbershopGallery({
    required String barbershopId,
    required File imageFile,
  }) async {
    final ref = _storage
        .ref()
        .child('barbershops')
        .child(barbershopId)
        .child('gallery')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
```

---

### 3. **Cloud Functions Premium** ⚡
**Benefício:** Mais poder de processamento e execuções

#### Funções Recomendadas:

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// 1. Notificação de novo match
exports.onNewMatch = functions.firestore
  .document('Matches/{matchId}')
  .onCreate(async (snap, context) => {
    const match = snap.data();
    const participants = match.participants;
    
    // Enviar notificação push para ambos
    for (const userId of participants) {
      await sendPushNotification(userId, {
        title: '🎉 Novo Match!',
        body: 'Você tem uma nova conexão no BarberGO',
        data: { matchId: context.params.matchId }
      });
    }
  });

// 2. Atualizar estatísticas de perfil
exports.updateProfileStats = functions.firestore
  .document('Reviews/{reviewId}')
  .onCreate(async (snap, context) => {
    const review = snap.data();
    const targetId = review.targetId;
    
    // Calcular média de avaliações
    const reviews = await admin.firestore()
      .collection('Reviews')
      .where('targetId', '==', targetId)
      .get();
    
    const avgRating = reviews.docs
      .reduce((sum, doc) => sum + doc.data().rating, 0) / reviews.size;
    
    // Atualizar perfil
    await admin.firestore()
      .collection('Profiles')
      .doc(targetId)
      .update({
        averageRating: avgRating,
        totalReviews: reviews.size
      });
  });

// 3. Limpar vagas expiradas (scheduled function)
exports.cleanupExpiredVacancies = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    
    const expiredVacancies = await admin.firestore()
      .collection('Vacancies')
      .where('createdAt', '<', thirtyDaysAgo)
      .where('isActive', '==', false)
      .get();
    
    const batch = admin.firestore().batch();
    expiredVacancies.docs.forEach(doc => batch.delete(doc.ref));
    
    await batch.commit();
    console.log(`Deleted ${expiredVacancies.size} expired vacancies`);
  });

// 4. Gemini AI Integration - Bio Generator
exports.generateBio = functions.https.onCall(async (data, context) => {
  // Verificar autenticação
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const { name, specialties, experienceYears } = data;
  
  // Chamar Gemini API
  const { GoogleGenerativeAI } = require('@google/generative-ai');
  const genAI = new GoogleGenerativeAI(functions.config().gemini.api_key);
  const model = genAI.getGenerativeModel({ model: 'gemini-pro' });
  
  const prompt = `Crie uma bio profissional para um barbeiro:
  Nome: ${name}
  Especialidades: ${specialties.join(', ')}
  Experiência: ${experienceYears} anos
  
  Máximo 150 caracteres, em português, destacando expertise.`;
  
  const result = await model.generateContent(prompt);
  return { bio: result.response.text() };
});
```

---

### 4. **BigQuery para Analytics** 📊
**Benefício:** Análises avançadas de dados

#### Setup:

```bash
# Habilitar BigQuery no Firebase Console
# Export automático de eventos do Analytics

# Queries úteis para o BarberGO:
```

```sql
-- 1. Taxa de conversão de matches
SELECT 
  DATE(timestamp) as date,
  COUNT(DISTINCT user_id) as total_users,
  COUNT(DISTINCT IF(event_name = 'match_created', user_id, NULL)) as users_with_match,
  ROUND(COUNT(DISTINCT IF(event_name = 'match_created', user_id, NULL)) / 
        COUNT(DISTINCT user_id) * 100, 2) as conversion_rate
FROM `barbergo-38c21.analytics_*`
WHERE event_name IN ('app_open', 'match_created')
GROUP BY date
ORDER BY date DESC;

-- 2. Vagas mais populares por cidade
SELECT 
  user_properties.value.string_value as city,
  COUNT(*) as vacancy_views,
  AVG(event_params.value.int_value) as avg_time_on_page
FROM `barbergo-38c21.analytics_*`,
  UNNEST(event_params) as event_params,
  UNNEST(user_properties) as user_properties
WHERE event_name = 'vacancy_view'
  AND user_properties.key = 'city'
GROUP BY city
ORDER BY vacancy_views DESC;

-- 3. Análise de retenção de usuários
SELECT
  user_pseudo_id,
  MIN(DATE(TIMESTAMP_MICROS(event_timestamp))) as first_seen,
  MAX(DATE(TIMESTAMP_MICROS(event_timestamp))) as last_seen,
  COUNT(DISTINCT DATE(TIMESTAMP_MICROS(event_timestamp))) as active_days
FROM `barbergo-38c21.analytics_*`
GROUP BY user_pseudo_id
HAVING active_days > 1
ORDER BY active_days DESC;
```

---

## 🛠️ Configuração Passo a Passo

### 1. Configurar Gemini Pro API

```bash
# No Firebase Functions
cd functions
npm install @google/generative-ai

# Configurar API Key
firebase functions:config:set gemini.api_key="SUA_API_KEY_AQUI"
```

### 2. Adicionar dependências Flutter

```yaml
# pubspec.yaml
dependencies:
  google_generative_ai: ^0.2.0
  firebase_storage: ^11.0.0
  cloud_functions: ^4.0.0
  firebase_analytics: ^10.0.0
```

### 3. Implementar Provider para Gemini

```dart
// lib/src/data/providers/gemini_provider.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_provider.g.dart';

@riverpod
GenerativeModel geminiModel(GeminiModelRef ref) {
  // API Key deve vir de variável de ambiente ou Firebase Remote Config
  const apiKey = String.fromEnvironment('GEMINI_API_KEY');
  
  return GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
  );
}

@riverpod
class GeminiService extends _$GeminiService {
  @override
  Future<void> build() async {}
  
  Future<String> generateBio({
    required String name,
    required List<String> specialties,
    required int experienceYears,
  }) async {
    final model = ref.read(geminiModelProvider);
    
    final prompt = '''
    Crie uma bio profissional e atraente para um barbeiro:
    Nome: $name
    Especialidades: ${specialties.join(', ')}
    Anos de experiência: $experienceYears
    
    Requisitos:
    - Máximo 150 caracteres
    - Em português brasileiro
    - Tom profissional mas amigável
    - Destacar expertise e diferencial
    ''';
    
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    
    return response.text ?? 'Bio não pôde ser gerada';
  }
}
```

---

## 💰 Estimativa de Custos e Economias

### Com Google One Ultra:

| Recurso | Uso Estimado/Mês | Custo Normal | Com Plano Ultra |
|---------|------------------|--------------|-----------------|
| Firebase Storage | 100GB | $2.50 | **Incluído (30TB)** |
| Gemini Pro API | 10k requests | $30.00 | **$0 (créditos)** |
| Cloud Functions | 1M invocations | $0.40 | **$0.40** |
| BigQuery | 100GB processado | $5.00 | **Incluído** |
| **TOTAL** | - | **$37.90** | **~$0.40/mês** |

**Economia mensal: ~$37.50** 💰

---

## 📱 Features Premium Sugeridas

### 1. **AI-Powered Search** 🔍
```dart
// Busca semântica de barbeiros
"Barbeiro especialista em fade e degradê perto de mim"
→ Gemini analisa e retorna os mais relevantes
```

### 2. **Smart Recommendations** 🎯
```dart
// Sistema de recomendação personalizado
"Mostrar vagas que combinam com meu perfil"
→ IA analisa histórico e sugere as melhores
```

### 3. **Auto-Complete Profiles** ✨
```dart
// Completar perfil automaticamente
Gemini sugere: especialidades, bio, horários ideais
```

### 4. **Virtual Interview Prep** 🎤
```dart
// Preparação para entrevistas
IA simula perguntas e dá feedback
```

---

## 🚀 Próximos Passos

1. **Imediato:**
   - [ ] Configurar Gemini API Key
   - [ ] Implementar gerador de bio
   - [ ] Testar upload de imagens no Storage

2. **Curto Prazo (1-2 semanas):**
   - [ ] Implementar matching inteligente
   - [ ] Configurar Cloud Functions
   - [ ] Setup BigQuery analytics

3. **Médio Prazo (1 mês):**
   - [ ] Análise de portfólio com visão
   - [ ] Chat assistente
   - [ ] Dashboard de analytics

---

## 📚 Recursos Adicionais

- [Gemini API Documentation](https://ai.google.dev/docs)
- [Firebase Storage Best Practices](https://firebase.google.com/docs/storage/best-practices)
- [Cloud Functions Guide](https://firebase.google.com/docs/functions)
- [BigQuery for Firebase](https://firebase.google.com/docs/bigquery)

---

## 👥 Suporte para Agentes

Para dúvidas sobre implementação, consulte:
- **Documentação interna:** `/docs`
- **Code samples:** `/examples/gemini_integration`
- **Issues:** Use labels `gemini`, `premium-features`

---

**Última atualização:** ${DateTime.now().toString().split(' ')[0]}
**Mantenedor:** Equipe BarberGO
