import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'logger_service.dart';

part 'geolocation_service.g.dart';

@riverpod
GeolocationService geolocationService(Ref ref) {
  return GeolocationService(logger: ref.watch(loggerServiceProvider));
}

class GeolocationService {
  final LoggerService _logger;

  GeolocationService({required LoggerService logger}) : _logger = logger;

  // Obtém a posição atual do dispositivo
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Verifica se o serviço está ativo
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _logger.logEvent("Geo_ServiceDisabled");
      throw Exception('Os serviços de localização estão desativados no dispositivo.');
    }

    // 2. Verifica e solicita permissões
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _logger.logEvent("Geo_PermissionDenied");
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _logger.logEvent("Geo_PermissionDeniedForever");
      throw Exception('Permissão de localização negada permanentemente. Ajuste nas configurações.');
    }

    // 3. Captura a localização
    _logger.logEvent("Geo_FetchingPosition");
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 10)),
      );
    } catch (e, stack) {
      _logger.logError(e, stack, context: "Failed to get current position");
      throw Exception('Falha ao obter a localização atual.');
    }
  }
}
