import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Configuração do ThemeData para o BarberGO.
/// Utiliza Material 3, modo escuro e a paleta definida em AppColors.
class AppTheme {
  /// Retorna o ThemeData escuro configurado com nossa paleta.
  static ThemeData get dark {
    // Definir um esquema de cores personalizado.
    final colorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.background,
      secondary: AppColors.primary,
      onSecondary: AppColors.background,
      error: AppColors.error,
      onError: AppColors.background,
      background: AppColors.background,
      onBackground: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      // TextTheme moderno e limpo, aplicando a cor de texto principal.
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),
    );
  }
}
