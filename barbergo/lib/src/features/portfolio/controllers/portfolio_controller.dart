import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/portfolio_item_entity.dart';
import '../repositories/portfolio_repository.dart';

part 'portfolio_controller.g.dart';

@riverpod
Stream<List<PortfolioItemEntity>> userPortfolio(UserPortfolioRef ref) {
  final repository = ref.watch(portfolioRepositoryProvider);
  return repository.watchUserPortfolio();
}

@riverpod
Stream<List<PortfolioItemEntity>> portfolio(PortfolioRef ref, String userId) {
  final repository = ref.watch(portfolioRepositoryProvider);
  return repository.watchPortfolio(userId);
}

@riverpod
class PortfolioController extends _$PortfolioController {
  @override
  FutureOr<void> build() {}

  /// Upload single image to portfolio
  Future<PortfolioItemEntity> uploadImage({
    required String imagePath,
    String? description,
    List<String> tags = const [],
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(portfolioRepositoryProvider);
      return await repository.uploadImage(imagePath: imagePath, description: description, tags: tags);
    });

    if (state.hasError) {
      throw state.error!;
    }

    return state.value as PortfolioItemEntity;
  }

  /// Upload multiple images in batch
  Future<List<PortfolioItemEntity>> uploadMultipleImages({
    required List<String> imagePaths,
    String? description,
    List<String> tags = const [],
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(portfolioRepositoryProvider);
      return await repository.uploadMultipleImages(imagePaths: imagePaths, description: description, tags: tags);
    });

    if (state.hasError) {
      throw state.error!;
    }

    return state.value as List<PortfolioItemEntity>;
  }

  /// Delete portfolio item
  Future<void> deletePortfolioItem(String itemId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(portfolioRepositoryProvider);
      await repository.deletePortfolioItem(itemId);
    });

    if (state.hasError) {
      throw state.error!;
    }
  }

  /// Update portfolio item (description, tags)
  Future<void> updatePortfolioItem({required String itemId, String? description, List<String>? tags}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(portfolioRepositoryProvider);
      await repository.updatePortfolioItem(itemId: itemId, description: description, tags: tags);
    });

    if (state.hasError) {
      throw state.error!;
    }
  }

  /// Reorder portfolio items
  Future<void> reorderPortfolio(List<String> itemIds) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(portfolioRepositoryProvider);
      await repository.reorderPortfolio(itemIds);
    });

    if (state.hasError) {
      throw state.error!;
    }
  }

  /// Like/Unlike portfolio item
  Future<void> toggleLike(String userId, String itemId) async {
    final repository = ref.read(portfolioRepositoryProvider);
    await repository.likePortfolioItem(userId, itemId);
  }
}
