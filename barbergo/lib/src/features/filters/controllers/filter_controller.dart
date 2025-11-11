import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/filter_repository.dart';
import '../../../domain/entities/filter_preferences.dart';

part 'filter_controller.g.dart';

/// Provider que observa as preferências de filtro do usuário atual
@riverpod
Stream<FilterPreferences> userFilterPreferences(Ref ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    return Stream.value(FilterPreferences.defaults);
  }

  return ref.watch(filterRepositoryProvider).watchFilterPreferences(user.uid);
}

/// Controller para gerenciar preferências de filtro
@riverpod
class FilterController extends _$FilterController {
  @override
  FutureOr<FilterPreferences> build() async {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) {
      return FilterPreferences.defaults;
    }

    final repository = ref.watch(filterRepositoryProvider);
    return await repository.loadFilterPreferences(user.uid);
  }

  /// Atualiza a distância máxima
  Future<void> updateMaxDistance(double distance) async {
    final currentState = state.value ?? FilterPreferences.defaults;
    final updated = currentState.copyWith(maxDistance: distance);
    await _savePreferences(updated);
  }

  /// Atualiza a faixa de preço
  Future<void> updatePriceRange(double min, double max) async {
    final currentState = state.value ?? FilterPreferences.defaults;
    final updated = currentState.copyWith(minPrice: min, maxPrice: max);
    await _savePreferences(updated);
  }

  /// Atualiza o rating mínimo
  Future<void> updateMinRating(double rating) async {
    final currentState = state.value ?? FilterPreferences.defaults;
    final updated = currentState.copyWith(minRating: rating);
    await _savePreferences(updated);
  }

  /// Toggle disponibilidade imediata
  Future<void> toggleAvailableNow() async {
    final currentState = state.value ?? FilterPreferences.defaults;
    final updated = currentState.copyWith(availableNow: !currentState.availableNow);
    await _savePreferences(updated);
  }

  /// Adiciona um tipo de serviço
  Future<void> addServiceType(String serviceType) async {
    final currentState = state.value ?? FilterPreferences.defaults;
    if (currentState.serviceTypes.contains(serviceType)) return;

    final updated = currentState.copyWith(serviceTypes: [...currentState.serviceTypes, serviceType]);
    await _savePreferences(updated);
  }

  /// Remove um tipo de serviço
  Future<void> removeServiceType(String serviceType) async {
    final currentState = state.value ?? FilterPreferences.defaults;
    final updated = currentState.copyWith(
      serviceTypes: currentState.serviceTypes.where((s) => s != serviceType).toList(),
    );
    await _savePreferences(updated);
  }

  /// Reseta todos os filtros para o padrão
  Future<void> resetFilters() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) return FilterPreferences.defaults;

      final repository = ref.read(filterRepositoryProvider);
      await repository.clearFilterPreferences(user.uid);
      return FilterPreferences.defaults;
    });
  }

  /// Salva as preferências no Firestore
  Future<void> _savePreferences(FilterPreferences preferences) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) return preferences;

      final repository = ref.read(filterRepositoryProvider);
      await repository.saveFilterPreferences(user.uid, preferences);
      return preferences;
    });
  }
}
