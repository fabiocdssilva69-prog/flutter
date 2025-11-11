import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/map_location.dart';
import '../../../../domain/entities/profile_entity.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'store_locator_controller.g.dart';

/// Controller para Store Locator (Phase 2)
/// Permite encontrar barbearias/salões próximos
@riverpod
class StoreLocatorController extends _$StoreLocatorController {
  @override
  FutureOr<bool> build() async {
    // Inicializar
  }
    return true;
  }

  /// Buscar barbearias próximas no raio especificado
  Future<List<ProfileEntity>> searchNearbyStores({
    required LatLng userLocation,
    double radiusKm = 10.0,
    StoreSearchFilters? filters,
  }) async {
    state = const AsyncLoading();

    try {
      final profileRepo = ref.read(profileRepositoryProvider);
      
      // Buscar perfis de barbearias próximos
      // TODO: Implementar busca geoespacial real com GeoFirePoint
      final allProfiles = await profileRepo.getAllProfiles();
      
      // Filtrar por tipo (barbershops)
      final barbershops = allProfiles.where((p) => 
        p.accountType == AccountType.barbershop
      ).toList();
      
      // Aplicar filtros adicionais
      var filtered = barbershops;
      
      if (filters != null) {
        if (filters.minRating > 0) {
          filtered = filtered.where((p) => p.rating >= filters.minRating).toList();
        }
        
        if (filters.isOpenNow) {
          filtered = filtered.where((p) => p.isAvailable).toList();
        }
        
        if (filters.services.isNotEmpty) {
          filtered = filtered.where((p) => 
            p.serviceTypes.any((s) => filters.services.contains(s))
          ).toList();
        }
        
        if (filters.maxPrice != null && filters.maxPrice! > 0) {
          filtered = filtered.where((p) => 
            p.hourlyRate != null && p.hourlyRate! <= filters.maxPrice!
          ).toList();
        }
      }
      
      // Calcular distâncias e ordenar
      final withDistances = filtered.map((profile) {
        final distance = _calculateDistance(
          userLocation,
          LatLng(
            profile.geoLocation?.latitude ?? 0,
            profile.geoLocation?.longitude ?? 0,
          ),
        );
        return {'profile': profile, 'distance': distance};
      }).where((item) => 
        (item['distance'] as double) <= radiusKm
      ).toList();
      
      // Ordenar por distância
      withDistances.sort((a, b) => 
        (a['distance'] as double).compareTo(b['distance'] as double)
      );
      
      final result = withDistances.map((item) => 
        item['profile'] as ProfileEntity
      ).toList();
      
      state = const AsyncData(null);
      return result;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  /// Buscar lojas por nome ou serviço
  Future<List<ProfileEntity>> searchStoresByQuery({
    required String query,
    LatLng? userLocation,
  }) async {
    state = const AsyncLoading();

    try {
      final profileRepo = ref.read(profileRepositoryProvider);
      final allProfiles = await profileRepo.getAllProfiles();
      
      // Filtrar barbershops que correspondem à busca
      final results = allProfiles.where((p) {
        if (p.accountType != AccountType.barbershop) return false;
        
        final matchesName = p.name.toLowerCase().contains(query.toLowerCase());
        final matchesBio = p.bio.toLowerCase().contains(query.toLowerCase());
        final matchesServices = p.serviceTypes.any((s) => 
          s.toLowerCase().contains(query.toLowerCase())
        );
        
        return matchesName || matchesBio || matchesServices;
      }).toList();
      
      // Ordenar por relevância (matches no nome primeiro)
      results.sort((a, b) {
        final aNameMatch = a.name.toLowerCase().contains(query.toLowerCase());
        final bNameMatch = b.name.toLowerCase().contains(query.toLowerCase());
        if (aNameMatch && !bNameMatch) return -1;
        if (!aNameMatch && bNameMatch) return 1;
        
        // Se ambos ou nenhum tem match no nome, ordenar por rating
        return b.rating.compareTo(a.rating);
      });
      
      state = const AsyncData(null);
      return results;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  /// Obter detalhes completos de uma loja
  Future<StoreDetails?> getStoreDetails(String storeId) async {
    try {
      final profileRepo = ref.read(profileRepositoryProvider);
      final profile = await profileRepo.getProfileById(storeId);
      
      if (profile == null) return null;
      
      // Calcular estatísticas adicionais
      final stats = await _calculateStoreStats(profile);
      
      return StoreDetails(
        profile: profile,
        totalServices: profile.serviceTypes.length,
        averagePrice: profile.hourlyRate ?? 0,
        responseTime: '~30 min', // TODO: Calcular real
        bookingRate: stats['bookingRate'] ?? 0.0,
        repeatCustomerRate: stats['repeatRate'] ?? 0.0,
        popularTimes: stats['popularTimes'] ?? {},
      );
    } catch (e) {
      return null;
    }
  }

  /// Obter lojas favoritas do usuário
  Future<List<ProfileEntity>> getFavoriteStores() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];
    
    // TODO: Implementar sistema de favoritos
    // Por enquanto, retornar vazio
    return [];
  }

  /// Adicionar loja aos favoritos
  Future<bool> toggleFavorite(String storeId) async {
    // TODO: Implementar
    return true;
  }

  /// Comparar múltiplas lojas
  Future<StoreComparison> compareStores(List<String> storeIds) async {
    if (storeIds.length < 2 || storeIds.length > 4) {
      throw ArgumentError('Compare entre 2 e 4 lojas');
    }
    
    final profileRepo = ref.read(profileRepositoryProvider);
    final stores = <ProfileEntity>[];
    
    for (final id in storeIds) {
      final profile = await profileRepo.getProfileById(id);
      if (profile != null) stores.add(profile);
    }
    
    return StoreComparison(
      stores: stores,
      comparisonFields: {
        'rating': stores.map((s) => s.rating).toList(),
        'reviewCount': stores.map((s) => s.reviewCount).toList(),
        'priceRange': stores.map((s) => s.hourlyRate ?? 0).toList(),
        'serviceCount': stores.map((s) => s.serviceTypes.length).toList(),
      },
      recommendation: _generateRecommendation(stores),
    );
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  double _calculateDistance(LatLng point1, LatLng point2) {
    const earthRadius = 6371; // km
    
    final dLat = _toRadians(point2.latitude - point1.latitude);
    final dLon = _toRadians(point2.longitude - point1.longitude);
    
    final a = (dLat / 2) * (dLat / 2) +
        _toRadians(point1.latitude) * _toRadians(point2.latitude) *
        (dLon / 2) * (dLon / 2);
    
    final c = 2 * (a < 0 ? 0 : a > 1 ? 1 : a);
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * 3.141592653589793 / 180;

  Future<Map<String, dynamic>> _calculateStoreStats(ProfileEntity profile) async {
    // TODO: Calcular estatísticas reais do Firestore
    return {
      'bookingRate': 0.85, // 85% de agendamentos confirmados
      'repeatRate': 0.65, // 65% de clientes retornam
      'popularTimes': {
        'monday': '14:00-18:00',
        'tuesday': '14:00-18:00',
        'wednesday': '14:00-18:00',
        'thursday': '14:00-18:00',
        'friday': '10:00-20:00',
        'saturday': '09:00-18:00',
      },
    };
  }

  String _generateRecommendation(List<ProfileEntity> stores) {
    if (stores.isEmpty) return 'Nenhuma loja para comparar';
    
    // Encontrar melhor rated
    final bestRated = stores.reduce((a, b) => 
      a.rating > b.rating ? a : b
    );
    
    // Encontrar mais barato
    final cheapest = stores.where((s) => s.hourlyRate != null).reduce((a, b) => 
      (a.hourlyRate ?? double.infinity) < (b.hourlyRate ?? double.infinity) ? a : b
    );
    
    if (bestRated.userId == cheapest.userId) {
      return '${bestRated.name} é a melhor opção: melhor avaliação E melhor preço!';
    } else {
      return '${bestRated.name} tem melhor avaliação (${bestRated.rating}★), '
             'mas ${cheapest.name} é mais em conta (R\$${cheapest.hourlyRate}/h)';
    }
  }
}

/// Filtros de busca de lojas
class StoreSearchFilters {
  final double minRating;
  final bool isOpenNow;
  final Set<String> services;
  final double? maxPrice;
  final String sortBy; // distance, rating, price
  
  const StoreSearchFilters({
    this.minRating = 0,
    this.isOpenNow = false,
    this.services = const {},
    this.maxPrice,
    this.sortBy = 'distance',
  });
}

/// Detalhes completos de uma loja
class StoreDetails {
  final ProfileEntity profile;
  final int totalServices;
  final double averagePrice;
  final String responseTime;
  final double bookingRate;
  final double repeatCustomerRate;
  final Map<String, String> popularTimes;
  
  const StoreDetails({
    required this.profile,
    required this.totalServices,
    required this.averagePrice,
    required this.responseTime,
    required this.bookingRate,
    required this.repeatCustomerRate,
    required this.popularTimes,
  });
}

/// Comparação entre lojas
class StoreComparison {
  final List<ProfileEntity> stores;
  final Map<String, List<dynamic>> comparisonFields;
  final String recommendation;
  
  const StoreComparison({
    required this.stores,
    required this.comparisonFields,
    required this.recommendation,
  });
}

/// Provider para lojas próximas
@riverpod
Future<List<ProfileEntity>> nearbyStores(
  NearbyStoresRef ref,
  LatLng userLocation,
  double radiusKm,
) async {
  final controller = ref.watch(storeLocatorControllerProvider.notifier);
  return controller.searchNearbyStores(
    userLocation: userLocation,
    radiusKm: radiusKm,
  );
}

/// Provider para busca de lojas
@riverpod
Future<List<ProfileEntity>> searchStores(
  SearchStoresRef ref,
  String query,
) async {
  if (query.length < 2) return [];
  
  final controller = ref.watch(storeLocatorControllerProvider.notifier);
  return controller.searchStoresByQuery(query: query);
}

