import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/ai/providers/gemini_provider.dart';
import '../config/config.dart';
import 'logger_service.dart';

part 'ai_service.g.dart';

@riverpod
Future<AiService> aiService(Ref ref) async {
  String apiKey;
  try {
    apiKey = Config.geminiKey;
  } catch (e) {
    throw Exception('Falha na Configuração do AiService: ');
  }

  final logger = ref.watch(loggerServiceProvider);
  final geminiModel = ref.watch(geminiProModelProvider);
  final service = AiService(apiKey: apiKey, logger: logger, geminiModel: geminiModel);

  final isValid = await service.validateApiKey();
  if (!isValid) {
    throw Exception('Falha na Validação da API Gemini');
  }

  return service;
}

class AiService {
  final String apiKey;
  final LoggerService logger;
  final GenerativeModel geminiModel;

  AiService({required this.apiKey, required this.logger, required this.geminiModel});

  Future<bool> validateApiKey() async {
    logger.logEvent('AI_KeyValidation_Start');
    try {
      final content = [Content.text('Test')];
      final response = await geminiModel.generateContent(content);

      if (response.text != null) {
        logger.logEvent('AI_KeyValidation_Success');
        return true;
      }
      return false;
    } catch (e, stack) {
      logger.logError(e, stack, context: 'AI_KeyValidation_Failed');
      return false;
    }
  }

  Future<String> generateText(String prompt, {double temperature = 0.7}) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: apiKey,
        generationConfig: GenerationConfig(temperature: temperature, maxOutputTokens: 1024),
      );

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? '';
    } catch (e, stack) {
      logger.logError(e, stack, context: 'Gemini_GenerateText_Failed');
      rethrow;
    }
  }

  Future<String> analyzeImage(List<int> imageBytes, String prompt, {double temperature = 0.7}) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: apiKey,
        generationConfig: GenerationConfig(temperature: temperature, maxOutputTokens: 1024),
      );

      final imagePart = DataPart('image/jpeg', Uint8List.fromList(imageBytes));
      final textPart = TextPart(prompt);

      final response = await model.generateContent([
        Content.multi([textPart, imagePart]),
      ]);

      return response.text ?? '';
    } catch (e, stack) {
      logger.logError(e, stack, context: 'Gemini_AnalyzeImage_Failed');
      rethrow;
    }
  }
}
