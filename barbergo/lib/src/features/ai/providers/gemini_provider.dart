import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_provider.g.dart';

/// Provider para o modelo Gemini Pro
///
/// IMPORTANTE: Configure a API key no arquivo .env:
/// - Adicione GEMINI_API_KEY=sua_chave no arquivo .env
/// - O arquivo .env está no .gitignore (seguro)
@riverpod
GenerativeModel geminiProModel(Ref ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  if (apiKey.isEmpty || apiKey == 'sua_key_aqui') {
    throw Exception(
      'GEMINI_API_KEY não configurada. '
      'Adicione sua chave no arquivo .env na raiz do projeto',
    );
  }

  return GenerativeModel(
    model: 'models/gemini-1.5-flash', // Mais rápido e barato que o Pro
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.7, // Criatividade moderada
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 1024,
    ),
    safetySettings: [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
    ],
  );
}

/// Provider para o modelo Gemini Pro Vision (análise de imagens)
@riverpod
GenerativeModel geminiProVisionModel(Ref ref) {
  const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  if (apiKey.isEmpty) {
    throw Exception('GEMINI_API_KEY não configurada.');
  }

  return GenerativeModel(
    model: 'models/gemini-1.5-flash', // Flash também suporta visão
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.4, // Mais preciso para análise de imagens
      topK: 32,
      topP: 0.9,
      maxOutputTokens: 2048,
    ),
  );
}
