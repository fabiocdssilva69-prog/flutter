import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo do BarberGo
            Image.asset(
              'assets/icons/app_icon.png',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                // Fallback para ícone caso imagem não carregue
                return const Icon(Icons.cut_outlined, size: 80, color: AppColors.primary);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "BarberGO",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Conectando barbeiros e barbearias",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
