import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_provider.g.dart';

/// Provider para o modelo Gemini Pro
///
/// IMPORTANTE: Configure a API key no arquivo .env:
/// - Adicione GOOGLE_GEMINI_API_KEY=sua_chave no arquivo .env
/// - O arquivo .env está no .gitignore (seguro)
@riverpod
GenerativeModel geminiProModel(Ref ref) {
  final apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'] ?? '';

  if (apiKey.isEmpty || apiKey == 'sua_key_aqui') {
    throw Exception(
      'GOOGLE_GEMINI_API_KEY não configurada. '
      'Adicione sua chave no arquivo .env na raiz do projeto',
    );
  }

  return GenerativeModel(
    model: 'gemini-2.0-flash-exp', // Modelo mais recente (experimental)
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
  final apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'] ?? '';

  if (apiKey.isEmpty) {
    throw Exception('GOOGLE_GEMINI_API_KEY não configurada.');
  }

  return GenerativeModel(
    model: 'gemini-2.0-flash-exp', // Flash 2.0 também suporta visão multimodal
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.4, // Mais preciso para análise de imagens
      topK: 32,
      topP: 0.9,
      maxOutputTokens: 2048,
    ),
  );
}
