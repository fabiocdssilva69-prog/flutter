// 🤖 EXEMPLOS PRÁTICOS - Gemini AI Integration
// Copie e cole estes exemplos no seu código

// ============================================
// 1. GERADOR DE BIO PROFISSIONAL
// ============================================

// lib/src/features/profile/providers/bio_generator_provider.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bio_generator_provider.g.dart';

@riverpod
class BioGenerator extends _$BioGenerator {
  @override
  FutureOr<String?> build() => null;
  
  Future<String> generate({
    required String name,
    required List<String> specialties,
    required int experienceYears,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      const apiKey = String.fromEnvironment('GEMINI_API_KEY');
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
      
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
- Sem usar emojis
''';
      
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final bio = response.text ?? 'Profissional experiente em barbearia';
      
      state = AsyncValue.data(bio);
      return bio;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

// ============================================
// 2. MATCHING INTELIGENTE
// ============================================

// lib/src/features/matching/providers/smart_matching_provider.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';

part 'smart_matching_provider.g.dart';

class MatchScore {
  final String vacancyId;
  final double score; // 0-100
  final String reason;
  
  MatchScore({
    required this.vacancyId,
    required this.score,
    required this.reason,
  });
  
  factory MatchScore.fromJson(Map<String, dynamic> json) => MatchScore(
    vacancyId: json['vacancyId'] as String,
    score: (json['score'] as num).toDouble(),
    reason: json['reason'] as String,
  );
}

@riverpod
class SmartMatching extends _$SmartMatching {
  @override
  FutureOr<List<MatchScore>> build(String barberId) async {
    return [];
  }
  
  Future<List<MatchScore>> findBestMatches({
    required ProfileEntity barberProfile,
    required List<VacancyEntity> availableVacancies,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      const apiKey = String.fromEnvironment('GEMINI_API_KEY');
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
      
      final prompt = '''
Analise o perfil do barbeiro e sugira as 5 melhores vagas, ordenadas por relevância:

PERFIL DO BARBEIRO:
- Nome: ${barberProfile.name}
- Especialidades: ${barberProfile.specialties?.join(', ') ?? 'Não especificado'}
- Localização: ${barberProfile.city}, ${barberProfile.neighborhood}
- Bio: ${barberProfile.bio ?? 'Sem bio'}

VAGAS DISPONÍVEIS:
${availableVacancies.map((v) => '''
- ID: ${v.vacancyId}
  Título: ${v.title}
  Tipo: ${v.type.name}
  Horário: ${v.workHours}
  ${v.commissionPercentage != null ? 'Comissão: ${v.commissionPercentage}%' : ''}
''').join('\n')}

Retorne APENAS um JSON array no formato:
[
  {
    "vacancyId": "id_da_vaga",
    "score": 85,
    "reason": "Breve explicação do match"
  }
]

Considere: proximidade, especialidades compatíveis, tipo de vaga preferido.
''';
      
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      // Extrair JSON da resposta
      final text = response.text ?? '[]';
      final jsonStart = text.indexOf('[');
      final jsonEnd = text.lastIndexOf(']') + 1;
      final jsonStr = text.substring(jsonStart, jsonEnd);
      
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      final matches = jsonList
          .map((json) => MatchScore.fromJson(json as Map<String, dynamic>))
          .toList();
      
      state = AsyncValue.data(matches);
      return matches;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return [];
    }
  }
}

// ============================================
// 3. ANÁLISE DE PORTFÓLIO
// ============================================

// lib/src/features/portfolio/providers/portfolio_analysis_provider.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'portfolio_analysis_provider.g.dart';

class PortfolioAnalysis {
  final List<String> detectedStyles;
  final double qualityScore; // 0-10
  final List<String> suggestions;
  
  PortfolioAnalysis({
    required this.detectedStyles,
    required this.qualityScore,
    required this.suggestions,
  });
  
  factory PortfolioAnalysis.fromText(String text) {
    // Parse do texto retornado pelo Gemini
    final lines = text.split('\n');
    return PortfolioAnalysis(
      detectedStyles: _extractStyles(text),
      qualityScore: _extractScore(text),
      suggestions: _extractSuggestions(text),
    );
  }
  
  static List<String> _extractStyles(String text) {
    // Implementar parsing
    return ['fade', 'degradê', 'barba'];
  }
  
  static double _extractScore(String text) {
    // Implementar parsing
    return 8.5;
  }
  
  static List<String> _extractSuggestions(String text) {
    // Implementar parsing
    return ['Adicionar mais fotos de cortes clássicos'];
  }
}

@riverpod
class PortfolioAnalyzer extends _$PortfolioAnalyzer {
  @override
  FutureOr<PortfolioAnalysis?> build() => null;
  
  Future<PortfolioAnalysis> analyze(List<String> imageUrls) async {
    state = const AsyncValue.loading();
    
    try {
      const apiKey = String.fromEnvironment('GEMINI_API_KEY');
      final model = GenerativeModel(
        model: 'gemini-pro-vision',
        apiKey: apiKey,
      );
      
      // Carregar imagens
      final images = <DataPart>[];
      for (final url in imageUrls.take(5)) {
        // Baixar e converter para bytes
        final bytes = await _downloadImage(url);
        images.add(DataPart('image/jpeg', bytes));
      }
      
      final prompt = '''
Analise essas fotos de trabalhos de barbearia e forneça:

1. ESTILOS IDENTIFICADOS (fade, degradê, barba, navalhado, etc)
2. QUALIDADE GERAL (nota de 0 a 10)
3. SUGESTÕES DE MELHORIA (máximo 3)

Forneça uma análise profissional e construtiva.
''';
      
      final content = [
        Content.multi([
          TextPart(prompt),
          ...images,
        ])
      ];
      
      final response = await model.generateContent(content);
      final analysis = PortfolioAnalysis.fromText(response.text ?? '');
      
      state = AsyncValue.data(analysis);
      return analysis;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
  
  Future<List<int>> _downloadImage(String url) async {
    // Implementar download da imagem
    throw UnimplementedError();
  }
}

// ============================================
// 4. ASSISTENTE DE NEGOCIAÇÃO
// ============================================

// lib/src/features/chat/providers/negotiation_assistant_provider.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'negotiation_assistant_provider.g.dart';

@riverpod
class NegotiationAssistant extends _$NegotiationAssistant {
  @override
  FutureOr<String?> build() => null;
  
  Future<String> suggestResponse({
    required String conversationContext,
    required String lastMessage,
    required String userRole, // 'barber' ou 'barbershop'
  }) async {
    state = const AsyncValue.loading();
    
    try {
      const apiKey = String.fromEnvironment('GEMINI_API_KEY');
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
      
      final prompt = '''
Você é um assistente de negociação para o app BarberGO, que conecta barbeiros e barbearias.

CONTEXTO DA CONVERSA:
$conversationContext

ÚLTIMA MENSAGEM RECEBIDA:
"$lastMessage"

PAPEL DO USUÁRIO: $userRole

Sugira UMA resposta profissional que:
- Seja cordial e respeitosa
- Ajude a avançar na negociação
- Demonstre interesse genuíno
- Seja direta e clara
- Tenha no máximo 100 caracteres

Retorne APENAS a mensagem sugerida, sem explicações adicionais.
''';
      
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final suggestion = response.text ?? 'Obrigado pela mensagem!';
      
      state = AsyncValue.data(suggestion);
      return suggestion;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

// ============================================
// 5. UI - EXEMPLO DE USO
// ============================================

// lib/src/features/profile/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bioState = ref.watch(bioGeneratorProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Bio',
                hintText: 'Conte sobre você...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Botão de geração automática com IA
            ElevatedButton.icon(
              onPressed: bioState.isLoading ? null : () async {
                await ref.read(bioGeneratorProvider.notifier).generate(
                  name: 'João Silva',
                  specialties: ['Fade', 'Barba'],
                  experienceYears: 5,
                );
              },
              icon: bioState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: const Text('Gerar Bio com IA'),
            ),
            
            // Mostrar resultado
            if (bioState.hasValue && bioState.value != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sugestão da IA:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(bioState.value!),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 6. CONFIGURAÇÃO - .ENV
// ============================================

/*
Crie um arquivo .env na raiz do projeto:

GEMINI_API_KEY=sua_api_key_aqui

E adicione ao .gitignore:
.env

Para usar no Flutter:
dart run --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY
*/

// ============================================
// 7. TESTES UNITÁRIOS
// ============================================

// test/features/profile/bio_generator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('BioGenerator', () {
    test('should generate professional bio', () async {
      final container = ProviderContainer();
      
      final bio = await container
          .read(bioGeneratorProvider.notifier)
          .generate(
            name: 'Test User',
            specialties: ['Fade', 'Barba'],
            experienceYears: 3,
          );
      
      expect(bio.isNotEmpty, true);
      expect(bio.length, lessThanOrEqualTo(150));
    });
  });
}
