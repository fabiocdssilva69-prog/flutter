import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/map_location.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'o2o_map_controller.g.dart';

/// Controller para O2O Map Integration (Phase 2)
@riverpod
class O2OMapController extends _$O2OMapController {
  @override
  FutureOr<bool> build() {
    return true; // Inicializar
  }

  /// Buscar locais próximos para encontro
  Future<List<MapLocation>> searchNearbyDateSpots({
    required LatLng userLocation,
    LocationSearchFilters? filters,
  }) async {
    state = const AsyncLoading();

    try {
      final effectiveFilters = filters ?? const LocationSearchFilters();

      // TODO: Integrar com Google Places API real
      // Por enquanto, retornar dados simulados
      final mockLocations = _generateMockLocations(userLocation, effectiveFilters);

      state = const AsyncData(null);
      return mockLocations;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  /// Gerar sugestões de encontro baseadas em perfis
  Future<List<DateLocationSuggestion>> generateDateSuggestions({
    required String matchId,
    required String matchName,
    LatLng? userLocation,
    LatLng? matchLocation,
  }) async {
    if (userLocation == null || matchLocation == null) return [];

    // Calcular ponto intermediário
    final midpoint = _calculateMidpoint(userLocation, matchLocation);

    // Buscar locais próximos ao ponto intermediário
    final locations = await searchNearbyDateSpots(
      userLocation: midpoint,
      filters: const LocationSearchFilters(
        categories: {'restaurante', 'café', 'parque'},
        minRating: 4.0,
        radiusMeters: 3000,
      ),
    );

    // Criar sugestões
    return locations.take(5).map((location) {
      return DateLocationSuggestion(
        suggestionId: _generateId(),
        matchId: matchId,
        location: location,
        reason: _generateReason(location),
        compatibilityScore: _calculateCompatibility(location),
        suggestedTime: _suggestBestTime(location),
        tips: _generateTips(location),
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  /// Buscar barbearias próximas (O2O)
  Future<List<MapLocation>> searchNearbyBarbershops({required LatLng userLocation, double radiusKm = 5.0}) async {
    state = const AsyncLoading();

    try {
      // TODO: Integrar com banco de dados de barbearias
      final barbershops = _generateMockBarbershops(userLocation, radiusKm);

      state = const AsyncData(null);
      return barbershops;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  /// Calcular rota entre dois pontos
  Future<Map<String, dynamic>> calculateRoute({required LatLng origin, required LatLng destination}) async {
    // TODO: Integrar com Google Directions API
    final distance = _calculateDistance(origin, destination);
    final duration = (distance / 40).ceil(); // ~40km/h média

    return {
      'distance': distance,
      'distanceText': '${distance.toStringAsFixed(1)} km',
      'duration': duration,
      'durationText': '$duration min',
      'polylinePoints': [], // TODO: Pontos reais da rota
    };
  }

  /// Obter localização atual do usuário
  Future<LatLng?> getUserLocation() async {
    final profile = ref.read(currentUserProfileProvider).value;
    if (profile?.geoLocation == null) return null;

    final geo = profile!.geoLocation!;
    return LatLng(geo.latitude, geo.longitude);
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  List<MapLocation> _generateMockLocations(LatLng center, LocationSearchFilters filters) {
    final random = DateTime.now().millisecond;

    return [
      MapLocation(
        locationId: 'loc_1',
        type: LocationType.dateSpot,
        name: 'Café Aconchego',
        address: 'Rua das Flores, 123',
        latitude: center.latitude + 0.001,
        longitude: center.longitude + 0.001,
        rating: 4.5,
        reviewCount: 234,
        category: 'café',
        priceLevel: 2,
        isOpenNow: true,
        distanceMeters: 150,
        photoUrls: [],
      ),
      MapLocation(
        locationId: 'loc_2',
        type: LocationType.dateSpot,
        name: 'Restaurante Bella Vista',
        address: 'Av. Principal, 456',
        latitude: center.latitude - 0.002,
        longitude: center.longitude + 0.002,
        rating: 4.7,
        reviewCount: 567,
        category: 'restaurante',
        priceLevel: 3,
        isOpenNow: true,
        distanceMeters: 420,
        photoUrls: [],
      ),
      MapLocation(
        locationId: 'loc_3',
        type: LocationType.dateSpot,
        name: 'Parque Central',
        address: 'Centro',
        latitude: center.latitude + 0.003,
        longitude: center.longitude - 0.001,
        rating: 4.3,
        reviewCount: 123,
        category: 'parque',
        priceLevel: 1,
        isOpenNow: true,
        distanceMeters: 800,
        photoUrls: [],
      ),
      MapLocation(
        locationId: 'loc_4',
        type: LocationType.dateSpot,
        name: 'Bar do João',
        address: 'Rua Alegre, 789',
        latitude: center.latitude - 0.001,
        longitude: center.longitude - 0.002,
        rating: 4.1,
        reviewCount: 89,
        category: 'bar',
        priceLevel: 2,
        isOpenNow: true,
        distanceMeters: 650,
        photoUrls: [],
      ),
    ];
  }

  List<MapLocation> _generateMockBarbershops(LatLng center, double radiusKm) {
    return [
      MapLocation(
        locationId: 'barber_1',
        type: LocationType.barbershop,
        name: 'Barbearia Clássica',
        address: 'Rua dos Barbeiros, 100',
        latitude: center.latitude + 0.002,
        longitude: center.longitude + 0.002,
        rating: 4.8,
        reviewCount: 456,
        category: 'barbearia',
        priceLevel: 2,
        isOpenNow: true,
        distanceMeters: 500,
        phoneNumber: '(48) 99999-0001',
        photoUrls: [],
      ),
      MapLocation(
        locationId: 'barber_2',
        type: LocationType.barbershop,
        name: 'BarberShop Premium',
        address: 'Av. Estilo, 200',
        latitude: center.latitude - 0.003,
        longitude: center.longitude + 0.001,
        rating: 4.9,
        reviewCount: 789,
        category: 'barbearia',
        priceLevel: 3,
        isOpenNow: true,
        distanceMeters: 1200,
        phoneNumber: '(48) 99999-0002',
        photoUrls: [],
      ),
    ];
  }

  LatLng _calculateMidpoint(LatLng point1, LatLng point2) {
    return LatLng((point1.latitude + point2.latitude) / 2, (point1.longitude + point2.longitude) / 2);
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    // Haversine simplificado (aproximação)
    const earthRadius = 6371; // km

    final dLat = _toRadians(point2.latitude - point1.latitude);
    final dLon = _toRadians(point2.longitude - point1.longitude);

    final a =
        (dLat / 2) * (dLat / 2) + _toRadians(point1.latitude) * _toRadians(point2.latitude) * (dLon / 2) * (dLon / 2);

    final c =
        2 *
        (a < 0
            ? 0
            : a > 1
            ? 1
            : a);

    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * 3.141592653589793 / 180;

  String _generateReason(MapLocation location) {
    if (location.category == 'café') {
      return 'Ambiente aconchegante, perfeito para conversar';
    } else if (location.category == 'restaurante') {
      return 'Ótimas avaliações, comida deliciosa';
    } else if (location.category == 'parque') {
      return 'Lugar tranquilo para caminhar e conversar';
    }
    return 'Local bem avaliado e próximo';
  }

  double _calculateCompatibility(MapLocation location) {
    // Score baseado em rating e reviews
    final ratingScore = location.rating / 5.0;
    final reviewScore = (location.reviewCount / 500).clamp(0.0, 1.0);

    return (ratingScore * 0.7) + (reviewScore * 0.3);
  }

  String _suggestBestTime(MapLocation location) {
    if (location.category == 'café') {
      return 'Manhã (9h-11h) ou tarde (15h-17h)';
    } else if (location.category == 'restaurante') {
      return 'Almoço (12h-14h) ou jantar (19h-21h)';
    } else if (location.category == 'parque') {
      return 'Final da tarde (17h-19h)';
    }
    return 'Qualquer horário';
  }

  List<String> _generateTips(MapLocation location) {
    return [
      'Chegue alguns minutos antes',
      'Confirme a reserva com antecedência',
      'Verifique opções de estacionamento',
      'Vista-se adequadamente para o local',
    ];
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

/// Provider para localizações próximas
@riverpod
Future<List<MapLocation>> nearbyDateSpots(NearbyDateSpotsRef ref, LatLng userLocation) async {
  final controller = ref.watch(o2OMapControllerProvider.notifier);
  return controller.searchNearbyDateSpots(userLocation: userLocation);
}
