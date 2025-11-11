import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/auth_repository.dart';
import '../auth/controllers/auth_controller.dart';
import '../profile/controllers/profile_controller.dart';

class InitializationErrorScreen extends ConsumerWidget {
  final String errorMessage;

  const InitializationErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_outlined, color: Colors.red, size: 60),
              const SizedBox(height: 24),
              const Text(
                "Falha na Inicialização",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Não foi possível carregar os dados necessários. Verifique sua conexão com a internet.\n\nDetalhes Técnicos: $errorMessage",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              // Botão para tentar novamente
              ElevatedButton.icon(
                onPressed: () {
                  // Invalidar o provedor de perfil forçará uma nova tentativa de carregamento.
                  // Também invalidamos o authStateChangesProvider para garantir um reset completo da sequência de inicialização.
                  ref.invalidate(authStateChangesProvider);
                  ref.invalidate(currentUserProfileProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Tentar Novamente"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                ),
              ),
              const SizedBox(height: 16),
              // Botão de Logout (Caso o problema persista)
              TextButton(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signOut();
                },
                child: const Text("Sair da Conta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
