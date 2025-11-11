import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/error_boundary.dart';
import 'localization/app_localizations.dart';
import 'routing/app_router.dart';

class BarberGoApp extends ConsumerWidget {
  const BarberGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // NOVO: Inicializa o NotificationService observando-o.
    ref.watch(notificationServiceProvider);

    // Envolve o MaterialApp no ErrorBoundary para tratamento global de erros
    return ErrorBoundary(
      child: MaterialApp.router(
        title: 'BarberGO Connect',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,

        // Configuração de i18n
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt', 'BR'), // Define o padrão inicial

        routerConfig: router,
      ),
    );
  }
}
