import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tutorial_provider.g.dart';

/// Provider que verifica se o usuário já completou o tutorial
@riverpod
Future<bool> tutorialCompleted(Ref ref) async {
  debugPrint('🔍 TUTORIAL PROVIDER: Verificando status do tutorial');
  try {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('tutorial_completed') ?? false;
    debugPrint('🔍 TUTORIAL PROVIDER: tutorial_completed = $completed');
    return completed;
  } catch (e, stackTrace) {
    debugPrint('❌ TUTORIAL PROVIDER ERROR: $e');
    debugPrint('❌ TUTORIAL PROVIDER STACK: $stackTrace');
    return false;
  }
}

/// Provider para marcar o tutorial como completo
@riverpod
class TutorialController extends _$TutorialController {
  @override
  Future<bool> build() async {
    debugPrint('🏗️ TUTORIAL CONTROLLER: Build iniciado');
    final value = ref.watch(tutorialCompletedProvider).value ?? false;
    debugPrint('🏗️ TUTORIAL CONTROLLER: Valor inicial = $value');
    return value;
  }

  /// Marca o tutorial como completado
  Future<void> completeTutorial() async {
    debugPrint('✅ TUTORIAL CONTROLLER: completeTutorial() chamado');
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.setBool('tutorial_completed', true);
      debugPrint('✅ TUTORIAL CONTROLLER: tutorial_completed salvo = $result');
      
      debugPrint('♻️ TUTORIAL CONTROLLER: Invalidando tutorialCompletedProvider');
      ref.invalidate(tutorialCompletedProvider);
      debugPrint('♻️ TUTORIAL CONTROLLER: Provider invalidado com sucesso');
    } catch (e, stackTrace) {
      debugPrint('❌ TUTORIAL CONTROLLER ERROR: $e');
      debugPrint('❌ TUTORIAL CONTROLLER STACK: $stackTrace');
    }
  }
}
