import 'package:flutter/widgets.dart';

import '../../localization/app_localizations.dart';

// Extensão no BuildContext para acesso rápido: context.l10n
extension LocalizationHelper on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw FlutterError("AppLocalizations not found in context.");
    }
    return localizations;
  }
}
