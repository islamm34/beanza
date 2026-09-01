import 'package:get/get.dart';

import '../../core/data/local_product_catalog.dart';
import '../../core/models/product_model.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesController extends GetxController {
  final FavoritesRepository? repository;
  final RxSet<String> favoriteProductIds =
      <String>{'prod_1', 'prod_4', 'prod_15'}.obs;

  // Track target sync state per product to handle rapid repeated taps cleanly
  final Map<String, bool> _pendingSyncTargets = {};
  final Set<String> _inFlightSyncs = {};

  FavoritesController({this.repository});

  /// Synchronously checks whether a product is currently favorited.
  bool isFavorite(String productId) {
    return favoriteProductIds.contains(productId);
  }

  /// Replaces or initializes favorite product IDs from external storage or API.
  void loadFavorites(Iterable<String> productIds) {
    favoriteProductIds.assignAll(productIds);
  }

  /// Sets the favorites set directly.
  void setFavorites(Set<String> ids) {
    favoriteProductIds.assignAll(ids);
  }

  /// Optimistically toggles a product's favorite state, updates UI instantly,
  /// and synchronizes with the repository in the background with automatic rollback on error.
  Future<void> toggleFavorite(String productId) async {
    final wasFavorite = favoriteProductIds.contains(productId);
    final targetState = !wasFavorite;

    // 1. Instant optimistic visual state update
    if (targetState) {
      favoriteProductIds.add(productId);
    } else {
      favoriteProductIds.remove(productId);
    }

    // 2. Background repository synchronization if repository is present
    if (repository != null) {
      _pendingSyncTargets[productId] = targetState;

      if (!_inFlightSyncs.contains(productId)) {
        await _drainSyncQueue(productId, wasFavorite);
      }
    }
  }

  Future<void> _drainSyncQueue(
      String productId, bool originalStateBeforeAction) async {
    _inFlightSyncs.add(productId);

    while (_pendingSyncTargets.containsKey(productId)) {
      final shouldBeFavorite = _pendingSyncTargets.remove(productId)!;
      try {
        if (shouldBeFavorite) {
          await repository!.addProductToFavorites(productId);
        } else {
          await repository!.removeProductFromFavorites(productId);
        }
      } catch (error) {
        // If an error occurred and no newer tap arrived in the meantime, safely rollback
        if (!_pendingSyncTargets.containsKey(productId)) {
          if (originalStateBeforeAction) {
            favoriteProductIds.add(productId);
          } else {
            favoriteProductIds.remove(productId);
          }

          if (Get.context != null && !Get.testMode) {
            Get.snackbar(
              'Could not update favorites',
              'Please try again.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          }
        }
      }
    }

    _inFlightSyncs.remove(productId);
  }

  /// Derived list of favorite products reflecting [favoriteProductIds].
  List<Product> get favoriteProducts {
    return LocalProductCatalog.products
        .where((p) => favoriteProductIds.contains(p.id))
        .toList();
  }
}
