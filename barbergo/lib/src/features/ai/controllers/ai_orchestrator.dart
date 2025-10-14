import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/ai_service.dart';
import '../providers/multi_ai_provider.dart';

part 'ai_orchestrator.g.dart';

/// Tipo de tarefa de IA
enum AITaskType {
  bioGeneration, // Bio curta
  imageAnalysis, // Análise de fotos
  smartMatching, // Matching complexo
  conversation, // Chat/conversação
  documentGeneration, // Contratos/documentos
  jsonStructured, // JSON estruturado
  quickSuggestion, // Sugestão rápida
}

/// Resultado de uma operação de IA
class AIResult {
  final String text;
  final AIModel usedModel;
  final Duration duration;
  final bool fromCache;

  AIResult({
    required this.text,
    required this.usedModel,
    required this.duration,
    this.fromCache = false,
  });
}

/// Orquestrador inteligente que decide qual modelo usar
@riverpod
class AIOrchestrator extends _$AIOrchestrator {
  @override
  Future<void> build() async {}

  /// Decide qual modelo usar baseado no tipo de task
  AIModel _selectModelForTask(AITaskType taskType) {
    switch (taskType) {
      // Gemini - Rápido e grátis (primário)
      case AITaskType.bioGeneration:
      case AITaskType.quickSuggestion:
      case AITaskType.imageAnalysis:
        return AIModel.gemini;

      // GPT-4 - Raciocínio complexo
      case AITaskType.smartMatching:
      case AITaskType.conversation:
      case AITaskType.jsonStructured:
        return AIModel.gpt4;

      // Claude - Documentos longos
      case AITaskType.documentGeneration:
        return AIModel.claude;
    }
  }

  /// Executa uma task de IA com o modelo apropriado
  Future<AIResult> executeTask({
    required AITaskType taskType,
    required String prompt,
    AIModel? forceModel, // Força uso de modelo específico
    int maxRetries = 2,
  }) async {
    state = const AsyncLoading();

    final selectedModel = forceModel ?? _selectModelForTask(taskType);
    final stopwatch = Stopwatch()..start();

    try {
      String result;

      // Tentar com o modelo selecionado
      try {
        result = await _executeWithModel(selectedModel, prompt, taskType);
      } catch (e) {
        // Se falhar, tentar fallback em cascata
        if (maxRetries > 0) {
          final fallbackModel = _getFallbackModel(selectedModel);
          result = await _executeWithModel(fallbackModel, prompt, taskType);
        } else {
          rethrow;
        }
      }

      stopwatch.stop();

      final aiResult = AIResult(
        text: result,
        usedModel: selectedModel,
        duration: stopwatch.elapsed,
      );

      state = const AsyncData(null);
      return aiResult;
    } catch (e, st) {
      stopwatch.stop();
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Executa com um modelo específico
  Future<String> _executeWithModel(
    AIModel model,
    String prompt,
    AITaskType taskType,
  ) async {
    switch (model) {
      case AIModel.gemini:
        final service = ref.read(aiServiceProvider.notifier);
        return await service.generateText(prompt: prompt);

      case AIModel.gpt4:
        final service = ref.read(gPTServiceProvider.notifier);
        return await service.generateText(prompt: prompt);

      case AIModel.claude:
        final service = ref.read(claudeServiceProvider.notifier);
        return await service.generateLongText(prompt: prompt);
    }
  }

  /// Retorna modelo de fallback
  AIModel _getFallbackModel(AIModel failedModel) {
    switch (failedModel) {
      case AIModel.gemini:
        return AIModel.gpt4; // Se Gemini falhar, tenta GPT
      case AIModel.gpt4:
        return AIModel.claude; // Se GPT falhar, tenta Claude
      case AIModel.claude:
        return AIModel.gemini; // Se Claude falhar, volta para Gemini
    }
  }

  /// Gera múltiplas opções usando modelos diferentes
  Future<Map<AIModel, String>> generateWithAllModels({
    required String prompt,
  }) async {
    state = const AsyncLoading();

    final results = <AIModel, String>{};

    // Tentar com todos os modelos em paralelo
    await Future.wait([
      _tryGenerate(
        AIModel.gemini,
        prompt,
      ).then((r) => results[AIModel.gemini] = r),
      _tryGenerate(AIModel.gpt4, prompt).then((r) => results[AIModel.gpt4] = r),
      _tryGenerate(
        AIModel.claude,
        prompt,
      ).then((r) => results[AIModel.claude] = r),
    ]);

    state = const AsyncData(null);
    return results;
  }

  Future<String> _tryGenerate(AIModel model, String prompt) async {
    try {
      return await _executeWithModel(model, prompt, AITaskType.quickSuggestion);
    } catch (e) {
      return 'Erro: ${e.toString()}';
    }
  }

  /// Executa análise de imagem (sempre usa Gemini Vision)
  Future<AIResult> analyzeImage({
    required List<int> imageBytes,
    required String prompt,
  }) async {
    state = const AsyncLoading();
    final stopwatch = Stopwatch()..start();

    try {
      final service = ref.read(aiServiceProvider.notifier);
      final result = await service.analyzeImage(
        imageBytes: imageBytes,
        prompt: prompt,
      );

      stopwatch.stop();

      final aiResult = AIResult(
        text: result,
        usedModel: AIModel.gemini,
        duration: stopwatch.elapsed,
      );

      state = const AsyncData(null);
      return aiResult;
    } catch (e, st) {
      stopwatch.stop();
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera documento longo (sempre usa Claude)
  Future<AIResult> generateDocument({
    required String documentType,
    required Map<String, dynamic> params,
  }) async {
    state = const AsyncLoading();
    final stopwatch = Stopwatch()..start();

    try {
      final service = ref.read(claudeServiceProvider.notifier);
      final result = await service.generateDocument(
        documentType: documentType,
        params: params,
      );

      stopwatch.stop();

      final aiResult = AIResult(
        text: result,
        usedModel: AIModel.claude,
        duration: stopwatch.elapsed,
      );

      state = const AsyncData(null);
      return aiResult;
    } catch (e, st) {
      stopwatch.stop();
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera JSON estruturado (sempre usa GPT-4)
  Future<Map<String, dynamic>> generateStructuredData({
    required String prompt,
  }) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(gPTServiceProvider.notifier);
      final result = await service.generateJSON(prompt: prompt);

      state = const AsyncData(null);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
