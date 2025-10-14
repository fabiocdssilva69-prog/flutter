import 'dart:html' as html;

/// Utilitário para detectar e configurar o browser sendo usado
///
/// Suporta:
/// - Perplexity Comet (navegador AI-first)
/// - Chrome/Chromium
/// - Edge
/// - Firefox
/// - Safari
class BrowserDetector {
  /// Detecta se está rodando no Perplexity Comet
  static bool isPerplexityComet() {
    try {
      final userAgent = html.window.navigator.userAgent;
      return userAgent.contains('PerplexityComet') ||
          userAgent.contains('Comet/') ||
          userAgent.contains('Perplexity');
    } catch (e) {
      return false;
    }
  }

  /// Detecta se é Chrome padrão
  static bool isChromeStandard() {
    try {
      final userAgent = html.window.navigator.userAgent;
      return userAgent.contains('Chrome') && !isPerplexityComet() && !isEdge();
    } catch (e) {
      return false;
    }
  }

  /// Detecta se é Microsoft Edge
  static bool isEdge() {
    try {
      final userAgent = html.window.navigator.userAgent;
      return userAgent.contains('Edg/');
    } catch (e) {
      return false;
    }
  }

  /// Detecta se é Firefox
  static bool isFirefox() {
    try {
      final userAgent = html.window.navigator.userAgent;
      return userAgent.contains('Firefox');
    } catch (e) {
      return false;
    }
  }

  /// Detecta se é Safari
  static bool isSafari() {
    try {
      final userAgent = html.window.navigator.userAgent;
      return userAgent.contains('Safari') && !userAgent.contains('Chrome');
    } catch (e) {
      return false;
    }
  }

  /// Retorna o nome do browser atual
  static String getCurrentBrowser() {
    if (isPerplexityComet()) return 'Perplexity Comet';
    if (isEdge()) return 'Microsoft Edge';
    if (isChromeStandard()) return 'Google Chrome';
    if (isFirefox()) return 'Firefox';
    if (isSafari()) return 'Safari';
    return 'Navegador Desconhecido';
  }

  /// Retorna ícone apropriado para o browser
  static String getBrowserIcon() {
    if (isPerplexityComet()) return '🚀';
    if (isEdge()) return '🔷';
    if (isChromeStandard()) return '🔵';
    if (isFirefox()) return '🦊';
    if (isSafari()) return '🧭';
    return '🌐';
  }

  /// Verifica se o browser suporta features de IA nativas
  static bool supportsNativeAI() {
    // Perplexity Comet tem features de IA nativas
    return isPerplexityComet();
  }

  /// Retorna configurações otimizadas para o browser atual
  static BrowserConfig getOptimizedConfig() {
    if (isPerplexityComet()) {
      return BrowserConfig(
        name: 'Perplexity Comet',
        supportsNativeAI: true,
        preferredAIModel: 'gpt-4o-mini', // Comet otimizado para mini
        recommendedTemperature: 0.7,
        enableSemanticSearch: true,
        enableRealtimeAnalysis: true,
      );
    }

    return BrowserConfig(
      name: getCurrentBrowser(),
      supportsNativeAI: false,
      preferredAIModel: 'gpt-4o-mini',
      recommendedTemperature: 0.7,
      enableSemanticSearch: false,
      enableRealtimeAnalysis: false,
    );
  }
}

/// Configurações do browser
class BrowserConfig {
  final String name;
  final bool supportsNativeAI;
  final String preferredAIModel;
  final double recommendedTemperature;
  final bool enableSemanticSearch;
  final bool enableRealtimeAnalysis;

  BrowserConfig({
    required this.name,
    required this.supportsNativeAI,
    required this.preferredAIModel,
    required this.recommendedTemperature,
    required this.enableSemanticSearch,
    required this.enableRealtimeAnalysis,
  });

  @override
  String toString() {
    return 'BrowserConfig($name, AI: $supportsNativeAI, Model: $preferredAIModel)';
  }
}
