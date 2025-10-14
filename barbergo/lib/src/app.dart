import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart'; // Importação adicionada

class BarberGoApp extends ConsumerWidget {
  const BarberGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider); // Assiste ao router

    // Usa MaterialApp.router
    return MaterialApp.router(
      title: 'BarberGO Connect',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: router, // Conecta o router
    );
  }
}
