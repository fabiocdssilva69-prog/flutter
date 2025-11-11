import 'package:dart_mappable/dart_mappable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_location.mapper.dart';

/// Entidade para localizações no mapa O2O (Phase 2)
@MappableClass()
class MapLocation with MapLocationMappable {
  /// ID da localização
  final String locationId;

  /// Tipo de localização
  final LocationType type;

  /// Nome do local
  final String name;

  /// Endereço completo
  final String address;

  /// Latitude
  final double latitude;

  /// Longitude
  final double longitude;

  /// Rating (0-5)
  final double rating;

  /// Número de reviews
  final int reviewCount;

  /// Categoria (restaurante, café, parque, etc)
  final String category;

  /// Faixa de preço (1-4, $-$$$$)
  final int priceLevel;

  /// Horários de funcionamento
  final Map<String, String>? openingHours;

  /// Telefone
  final String? phoneNumber;

  /// Website
  final String? website;

  /// Fotos URLs
  final List<String> photoUrls;

  /// Se está aberto agora
  final bool isOpenNow;

  /// Distância do usuário (em metros)
  final double? distanceMeters;

  const MapLocation({
    required this.locationId,
    required this.type,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.category,
    this.priceLevel = 2,
    this.openingHours,
    this.phoneNumber,
    this.website,
    this.photoUrls = const [],
    this.isOpenNow = true,
    this.distanceMeters,
  });

  /// Converter para LatLng do Google Maps
  LatLng get latLng => LatLng(latitude, longitude);

  /// Texto amigável de distância
  String get distanceText {
    if (distanceMeters == null) return '';
    if (distanceMeters! < 1000) return '${distanceMeters!.toInt()}m';
    return '${(distanceMeters! / 1000).toStringAsFixed(1)}km';
  }

  /// Texto de faixa de preço
  String get priceText => '\$' * priceLevel;

  /// Ícone baseado na categoria
  String get iconEmoji {
    switch (category.toLowerCase()) {
      case 'restaurante':
      case 'restaurant':
        return '🍽️';
      case 'café':
      case 'cafe':
      case 'coffee':
        return '☕';
      case 'bar':
        return '🍺';
      case 'parque':
      case 'park':
        return '🌳';
      case 'cinema':
      case 'movie':
        return '🎬';
      case 'museu':
      case 'museum':
        return '🏛️';
      case 'shopping':
      case 'mall':
        return '🛍️';
      default:
        return '📍';
    }
  }
}

/// Tipos de localização
enum LocationType {
  /// Lugar sugerido para encontro
  dateSpot,

  /// Perfil de barbearia (O2O)
  barbershop,

  /// Localização de usuário
  userLocation,

  /// Ponto de interesse
  pointOfInterest,
}

/// Sugestão de encontro baseada em localização
@MappableClass()
class DateLocationSuggestion with DateLocationSuggestionMappable {
  /// ID da sugestão
  final String suggestionId;

  /// ID do match
  final String matchId;

  /// Localização sugerida
  final MapLocation location;

  /// Motivo da sugestão
  final String reason;

  /// Score de compatibilidade (0.0 - 1.0)
  final double compatibilityScore;

  /// Melhor horário para visitar
  final String? suggestedTime;

  /// Dicas para o encontro
  final List<String> tips;

  /// Timestamp de criação
  final DateTime createdAt;

  const DateLocationSuggestion({
    required this.suggestionId,
    required this.matchId,
    required this.location,
    required this.reason,
    required this.compatibilityScore,
    this.suggestedTime,
    this.tips = const [],
    required this.createdAt,
  });
}

/// Filtros para busca de localizações
@MappableClass()
class LocationSearchFilters with LocationSearchFiltersMappable {
  /// Categorias desejadas
  final Set<String> categories;

  /// Faixa de preço máxima
  final int maxPriceLevel;

  /// Rating mínimo
  final double minRating;

  /// Raio de busca (metros)
  final double radiusMeters;

  /// Apenas locais abertos agora
  final bool openNowOnly;

  /// Ordenação (distance, rating, reviews)
  final String sortBy;

  const LocationSearchFilters({
    this.categories = const {'restaurante', 'café', 'bar', 'parque'},
    this.maxPriceLevel = 3,
    this.minRating = 3.5,
    this.radiusMeters = 5000, // 5km
    this.openNowOnly = false,
    this.sortBy = 'distance',
  });
}
