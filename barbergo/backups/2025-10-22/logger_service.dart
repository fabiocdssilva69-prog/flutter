import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_service.g.dart';

@riverpod
LoggerService loggerService(Ref ref) {
  return LoggerService();
}

class LoggerService {
  // Instâncias dos serviços do Firebase
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Log de eventos (Analytics)
  void logEvent(String eventName, {Map<String, Object>? parameters}) {
    if (kDebugMode) {
      // Usamos debugPrint se kDebugMode for true, pois print pode ter sido removido em Sprints anteriores.
      debugPrint("📊 [LOG EVENT] $eventName: ${parameters ?? ''}");
    }

    // 1. Sanitização do Nome do Evento
    String safeEventName = eventName;

    // Remove prefixos reservados que causam warnings no console.
    if (safeEventName.startsWith('firebase_') ||
        safeEventName.startsWith('google_') ||
        safeEventName.startsWith('ga_')) {
      if (kDebugMode) {
        debugPrint("⚠️ WARNING: Event name '$eventName' uses a reserved prefix. Renaming.");
      }
      // Renomeia automaticamente (Ex: firebase_error -> app_error)
      // Tentamos pegar a parte relevante após o prefixo.
      final parts = safeEventName.split('_');
      if (parts.length > 1) {
        safeEventName = 'app_${parts.sublist(1).join('_')}';
      } else {
        safeEventName = 'app_event_renamed';
      }
    }

    // Limita o comprimento a 40 caracteres (Limite do Firebase)
    if (safeEventName.length > 40) {
      safeEventName = safeEventName.substring(0, 40);
    }

    // 2. Sanitização dos Parâmetros
    // Nota: Map<String, Object> já garante non-null values por tipo
    final Map<String, Object>? safeParameters = parameters;

    try {
      _analytics.logEvent(name: safeEventName, parameters: safeParameters);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Failed to log event to Firebase Analytics: $e");
      }
    }
  }

  // Log de erros (Crashlytics)
  void logError(dynamic error, StackTrace stack, {String? context}) {
    if (kDebugMode) {
      print("❌ [LOG ERROR] ${context ?? ''}");
      print(error);
      print(stack);
    }

    // Envia para o Firebase Crashlytics (como não fatal, pois são erros tratados ou logados manualmente)
    // Os erros fatais são capturados automaticamente pelos handlers no main.dart.
    _crashlytics.recordError(error, stack, reason: context, fatal: false);
  }

  // Método auxiliar específico para interações de IA
  void logAiInteraction({required String persona, required Duration duration, required bool success}) {
    logEvent(
      "AI_Interaction",
      parameters: {"persona": persona, "duration_ms": duration.inMilliseconds, "success": success},
    );
  }
}
