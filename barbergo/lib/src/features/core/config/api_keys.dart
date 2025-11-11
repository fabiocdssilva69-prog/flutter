/// API Keys configuration
/// IMPORTANTE: Este arquivo contém chaves sensíveis.
/// NÃO commitar este arquivo no Git se tiver keys reais.
library;

class ApiKeys {
  // Gemini AI
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  static bool get isGeminiConfigured => geminiApiKey != 'YOUR_GEMINI_API_KEY_HERE' && geminiApiKey.isNotEmpty;

  // Perplexity AI
  static const String perplexityApiKey = 'YOUR_PERPLEXITY_API_KEY_HERE';
  static bool get isPerplexityConfigured =>
      perplexityApiKey != 'YOUR_PERPLEXITY_API_KEY_HERE' && perplexityApiKey.isNotEmpty;

  // Google One Ultra
  static const String googleOneUltraApiKey = 'YOUR_GOOGLE_ONE_ULTRA_API_KEY_HERE';
  static bool get isGoogleOneUltraConfigured =>
      googleOneUltraApiKey != 'YOUR_GOOGLE_ONE_ULTRA_API_KEY_HERE' && googleOneUltraApiKey.isNotEmpty;

  // Payment gateways (futuro)
  static const String stripePublishableKey = 'YOUR_STRIPE_KEY_HERE';
  static const String mercadoPagoAccessToken = 'YOUR_MERCADO_PAGO_TOKEN_HERE';
}
