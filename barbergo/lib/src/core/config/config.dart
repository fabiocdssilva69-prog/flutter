import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Classe de configuração centralizada para gerenciar variáveis de ambiente
/// e chaves de API de forma segura.
///
/// As chaves são carregadas do arquivo .env (nunca commitado no git)
/// ou de variáveis de ambiente do sistema (CI/CD).
///
/// **Atualmente usa apenas Google Gemini API.**
class Config {
  /// Carrega as variáveis de ambiente do arquivo .env
  ///
  /// Este método deve ser chamado no início do app (main.dart)
  /// antes de qualquer uso das chaves de API.
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: ".env");
      print("✅ Config: Arquivo .env carregado com sucesso");
    } catch (e) {
      print("ℹ️ Config: Could not load .env file (this might be expected if variables are set via CI/CD): $e");
    }
  }

  // Regex para validar o formato da chave Google Gemini (AIza...)
  static final RegExp _geminiKeyFormat = RegExp(r'^AIza[a-zA-Z0-9_-]{35}$');

  /// Retorna a chave de API do Google Gemini (obrigatória)
  ///
  /// Esta é a única chave de API suportada no momento.
  /// Utilizada para integração com Gemini 2.0 Flash.
  ///
  /// Throws [Exception] se a chave não estiver configurada ou for placeholder
  static String get geminiKey {
    final key = dotenv.env['GOOGLE_GEMINI_API_KEY'];

    // 1. Verifica se a chave existe e não é o placeholder
    if (key == null || key.isEmpty || key.contains('YOUR_') || key.contains('HERE')) {
      throw Exception("GOOGLE_GEMINI_API_KEY não encontrada ou ainda está com o valor padrão no .env.");
    }

    // 2. Verifica o formato usando Regex
    if (!_geminiKeyFormat.hasMatch(key)) {
      throw Exception(
        "GOOGLE_GEMINI_API_KEY possui um formato inválido. Deve começar com 'AIza' e ter o comprimento correto.",
      );
    }

    return key;
  }

  /// Verifica se a chave Gemini está configurada corretamente
  static bool get isConfigured {
    try {
      geminiKey;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retorna um resumo do status das configurações (para debug)
  static Map<String, dynamic> get configStatus => {
    'gemini_configured': isConfigured,
    'gemini_key_length': isConfigured ? geminiKey.length : 0,
    'gemini_key_prefix': isConfigured ? geminiKey.substring(0, 8) : 'N/A',
  };
}
