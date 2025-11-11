import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'localization_controller.g.dart';

// Translations database
final _translations = {
  'pt': {
    'app_name': 'BarberGo',
    'home': 'Início',
    'bookings': 'Agendamentos',
    'profile': 'Perfil',
    'search': 'Buscar',
    'book_now': 'Agendar',
    'cancel': 'Cancelar',
    'confirm': 'Confirmar',
    'welcome': 'Bem-vindo',
    'select_barber': 'Selecione um barbeiro',
    'select_service': 'Selecione um serviço',
    'select_time': 'Selecione um horário',
    'my_bookings': 'Meus Agendamentos',
    'no_bookings': 'Nenhum agendamento',
    'booking_confirmed': 'Agendamento confirmado!',
    'booking_cancelled': 'Agendamento cancelado',
    'error_occurred': 'Ocorreu um erro',
    'try_again': 'Tentar novamente',
  },
  'en': {
    'app_name': 'BarberGo',
    'home': 'Home',
    'bookings': 'Bookings',
    'profile': 'Profile',
    'search': 'Search',
    'book_now': 'Book Now',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'welcome': 'Welcome',
    'select_barber': 'Select a barber',
    'select_service': 'Select a service',
    'select_time': 'Select a time',
    'my_bookings': 'My Bookings',
    'no_bookings': 'No bookings',
    'booking_confirmed': 'Booking confirmed!',
    'booking_cancelled': 'Booking cancelled',
    'error_occurred': 'An error occurred',
    'try_again': 'Try again',
  },
  'es': {
    'app_name': 'BarberGo',
    'home': 'Inicio',
    'bookings': 'Citas',
    'profile': 'Perfil',
    'search': 'Buscar',
    'book_now': 'Reservar',
    'cancel': 'Cancelar',
    'confirm': 'Confirmar',
    'welcome': 'Bienvenido',
    'select_barber': 'Seleccionar un barbero',
    'select_service': 'Seleccionar un servicio',
    'select_time': 'Seleccionar una hora',
    'my_bookings': 'Mis Citas',
    'no_bookings': 'Sin citas',
    'booking_confirmed': 'Cita confirmada!',
    'booking_cancelled': 'Cita cancelada',
    'error_occurred': 'Ocurrió un error',
    'try_again': 'Intentar de nuevo',
  },
};

@riverpod
class LocalizationController extends _$LocalizationController {
  @override
  Locale build() {
    return const Locale('pt', 'BR');
  }

  void changeLanguage(String languageCode) {
    Locale newLocale;
    switch (languageCode) {
      case 'pt':
        newLocale = const Locale('pt', 'BR');
        break;
      case 'en':
        newLocale = const Locale('en', 'US');
        break;
      case 'es':
        newLocale = const Locale('es', 'ES');
        break;
      default:
        newLocale = const Locale('pt', 'BR');
    }
    state = newLocale;
  }

  String translate(String key) {
    final languageCode = state.languageCode;
    return _translations[languageCode]?[key] ?? key;
  }
}

// Extension method for easy translations
extension LocalizationExtension on String {
  String tr(BuildContext context) {
    // In a real app, use context to get the provider
    return _translations['pt']?[this] ?? this;
  }
}

// Supported locales
const supportedLocales = [
  Locale('pt', 'BR'),
  Locale('en', 'US'),
  Locale('es', 'ES'),
];
