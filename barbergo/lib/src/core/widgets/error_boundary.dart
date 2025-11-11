import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';

/// Widget que configura um error boundary global para o aplicativo.
///
/// Este widget substitui a "Red Screen of Death" do Flutter por uma UI
/// de fallback amigável ao usuário quando ocorrem erros de renderização.
///
/// A captura e logging dos erros já são feitos globalmente no main.dart
/// via FlutterError.onError e PlatformDispatcher.onError.
class ErrorBoundary extends ConsumerWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define a UI de erro que substitui o widget que crashou
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return _buildFallbackUI(details);
    };

    return child;
  }

  /// Constrói a UI de fallback exibida quando ocorre um erro
  Widget _buildFallbackUI(FlutterErrorDetails details) {
    // UI de Fallback genérica e amigável
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              const Text(
                "Ops, algo deu errado!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Ocorreu um erro inesperado. Nossa equipe já foi notificada automaticamente.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Em um cenário real, poderíamos adicionar um botão para recarregar o estado
              ElevatedButton(
                onPressed: () {
                  // TODO: Implementar lógica de retry/refresh quando necessário
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text("Tentar Novamente (Em breve)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
