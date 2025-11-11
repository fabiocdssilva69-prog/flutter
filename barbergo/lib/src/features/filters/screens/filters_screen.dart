import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/filter_preferences.dart';
import '../controllers/filter_controller.dart';
import '../widgets/distance_slider.dart';
import '../widgets/price_range_slider.dart';
import '../widgets/rating_filter.dart';
import '../widgets/service_type_chips.dart';

/// Tela de filtros avançados para descoberta de barbeiros
class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtersAsync = ref.watch(filterControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros'),
        actions: [
          // Botão de resetar filtros
          TextButton(
            onPressed: () async {
              final confirmed = await _showResetConfirmation(context);
              if (confirmed == true) {
                ref.read(filterControllerProvider.notifier).resetFilters();
              }
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
      body: filtersAsync.when(
        data: (filters) => _buildFiltersContent(context, ref, filters),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erro ao carregar filtros: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(filterControllerProvider),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildApplyButton(context, filtersAsync.valueOrNull),
    );
  }

  Widget _buildFiltersContent(BuildContext context, WidgetRef ref, FilterPreferences filters) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Badge de filtros ativos
        if (filters.hasActiveFilters)
          Card(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.filter_alt, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getActiveFiltersText(filters),
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (filters.hasActiveFilters) const SizedBox(height: 16),

        // Slider de distância
        DistanceSlider(
          value: filters.maxDistance,
          onChanged: (value) {
            ref.read(filterControllerProvider.notifier).updateMaxDistance(value);
          },
        ),

        const SizedBox(height: 24),

        // Range de preço
        PriceRangeSlider(
          minValue: filters.minPrice,
          maxValue: filters.maxPrice,
          onChanged: (min, max) {
            ref.read(filterControllerProvider.notifier).updatePriceRange(min, max);
          },
        ),

        const SizedBox(height: 24),

        // Filtro de rating
        RatingFilter(
          value: filters.minRating,
          onChanged: (rating) {
            ref.read(filterControllerProvider.notifier).updateMinRating(rating);
          },
        ),

        const SizedBox(height: 24),

        // Toggle de disponibilidade
        Card(
          child: SwitchListTile(
            title: const Text('Disponível agora'),
            subtitle: const Text('Mostrar apenas barbeiros disponíveis'),
            value: filters.availableNow,
            onChanged: (_) {
              ref.read(filterControllerProvider.notifier).toggleAvailableNow();
            },
            secondary: const Icon(Icons.access_time),
          ),
        ),

        const SizedBox(height: 24),

        // Tipos de serviço
        const Text('Tipos de Serviço', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ServiceTypeChips(
          selectedServices: filters.serviceTypes,
          onServiceToggled: (service, isSelected) {
            if (isSelected) {
              ref.read(filterControllerProvider.notifier).addServiceType(service);
            } else {
              ref.read(filterControllerProvider.notifier).removeServiceType(service);
            }
          },
        ),

        const SizedBox(height: 80), // Espaço para o botão fixo
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context, FilterPreferences? filters) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(filters);
          },
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: const Text('Aplicar Filtros', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  String _getActiveFiltersText(FilterPreferences filters) {
    final activeFilters = <String>[];

    if (filters.maxDistance != 50.0) {
      activeFilters.add('${filters.maxDistance.toInt()}km');
    }
    if (filters.minPrice != 20.0 || filters.maxPrice != 200.0) {
      activeFilters.add('R\$${filters.minPrice.toInt()}-${filters.maxPrice.toInt()}');
    }
    if (filters.minRating != 3.0) {
      activeFilters.add('${filters.minRating.toStringAsFixed(1)}+ ⭐');
    }
    if (filters.availableNow) {
      activeFilters.add('Disponível');
    }
    if (filters.serviceTypes.isNotEmpty) {
      activeFilters.add('${filters.serviceTypes.length} serviços');
    }

    return '${activeFilters.length} filtros ativos: ${activeFilters.join(', ')}';
  }

  Future<bool?> _showResetConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar filtros?'),
        content: const Text('Todos os filtros serão removidos e voltarão ao padrão.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Limpar')),
        ],
      ),
    );
  }
}
