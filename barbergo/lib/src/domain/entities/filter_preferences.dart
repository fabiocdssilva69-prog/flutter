import 'package:dart_mappable/dart_mappable.dart';

part 'filter_preferences.mapper.dart';

/// Preferências de filtro para busca de barbeiros
@MappableClass()
class FilterPreferences with FilterPreferencesMappable {
  /// Distância máxima em km (1-100)
  final double maxDistance;

  /// Preço mínimo em R$
  final double minPrice;

  /// Preço máximo em R$
  final double maxPrice;

  /// Avaliação mínima (1-5 estrelas)
  final double minRating;

  /// Filtrar apenas barbeiros disponíveis agora
  final bool availableNow;

  /// Tipos de serviço selecionados (ex: 'Corte', 'Barba', 'Coloração')
  final List<String> serviceTypes;

  const FilterPreferences({
    this.maxDistance = 50.0,
    this.minPrice = 20.0,
    this.maxPrice = 200.0,
    this.minRating = 3.0,
    this.availableNow = false,
    this.serviceTypes = const [],
  });

  /// Retorna valores padrão (sem filtros aplicados)
  static const FilterPreferences defaults = FilterPreferences();

  /// Verifica se algum filtro está ativo
  bool get hasActiveFilters {
    return maxDistance != 50.0 ||
        minPrice != 20.0 ||
        maxPrice != 200.0 ||
        minRating != 3.0 ||
        availableNow ||
        serviceTypes.isNotEmpty;
  }

  /// Limpa todos os filtros
  FilterPreferences clearAll() {
    return FilterPreferences.defaults;
  }
}
