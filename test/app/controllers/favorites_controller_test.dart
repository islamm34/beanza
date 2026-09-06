import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/features/favorites/domain/entities/favorites_entity.dart';
import 'package:beanza/features/favorites/domain/repositories/favorites_repository.dart';

class FakeFavoritesRepository implements FavoritesRepository {
  final List<String> addedProductCalls = [];
  final List<String> removedProductCalls = [];
  bool shouldThrowError = false;

  @override
  Future<void> addProductToFavorites(String productId) async {
    if (shouldThrowError) {
      throw Exception('Server unreachable');
    }
    addedProductCalls.add(productId);
  }

  @override
  Future<void> removeProductFromFavorites(String productId) async {
    if (shouldThrowError) {
      throw Exception('Server unreachable');
    }
    removedProductCalls.add(productId);
  }

  @override
  Future<List<FavoriteCafeEntity>> getFavoriteCafes() async => [];

  @override
  Future<List<FavoriteProductEntity>> getFavoriteProducts() async => [];

  @override
  Future<void> addCafeToFavorites(String cafeId) async {}

  @override
  Future<void> removeCafeFromFavorites(String cafeId) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritesController Comprehensive Unit Tests', () {
    late FakeFavoritesRepository fakeRepository;
    late FavoritesController controller;

    setUp(() {
      Get.reset();
      Get.testMode = true;
      fakeRepository = FakeFavoritesRepository();
      controller = Get.put(FavoritesController(repository: fakeRepository));
      controller.loadFavorites(['prod_1', 'prod_4']);
    });

    tearDown(() {
      Get.reset();
    });

    test('1. Adding a product updates isFavorite immediately', () {
      const newProductId = 'prod_99';
      expect(controller.isFavorite(newProductId), isFalse);

      // Synchronous check immediately after invocation
      controller.toggleFavorite(newProductId);
      expect(controller.isFavorite(newProductId), isTrue);
    });

    test('2. Removing a product updates isFavorite immediately', () {
      const existingProductId = 'prod_1';
      expect(controller.isFavorite(existingProductId), isTrue);

      controller.toggleFavorite(existingProductId);
      expect(controller.isFavorite(existingProductId), isFalse);
    });

    test('3. The repository receives the correct product ID and new state',
        () async {
      const testId = 'prod_77';
      await controller.toggleFavorite(testId);

      expect(fakeRepository.addedProductCalls, contains(testId));
      expect(fakeRepository.removedProductCalls, isEmpty);

      await controller.toggleFavorite(testId);
      expect(fakeRepository.removedProductCalls, contains(testId));
    });

    test('4. Duplicate Favorite IDs are not created', () {
      controller.loadFavorites(['prod_1', 'prod_1', 'prod_2']);
      expect(controller.favoriteProductIds.length, 2);

      controller.toggleFavorite('prod_3');
      expect(controller.favoriteProductIds.where((id) => id == 'prod_3').length,
          1);
    });

    test('5. A persistence failure restores the previous state', () async {
      const testId = 'prod_fail';
      expect(controller.isFavorite(testId), isFalse);

      fakeRepository.shouldThrowError = true;

      await controller.toggleFavorite(testId);

      // When async error finishes, it should safely rollback to false
      expect(controller.isFavorite(testId), isFalse);
    });

    test('6. Initial saved Favorites load correctly', () {
      final initialIds = {'prod_10', 'prod_20', 'prod_30'};
      controller.setFavorites(initialIds);

      expect(controller.isFavorite('prod_10'), isTrue);
      expect(controller.isFavorite('prod_20'), isTrue);
      expect(controller.isFavorite('prod_30'), isTrue);
      expect(controller.isFavorite('prod_1'), isFalse);
    });

    test('7. Rapid repeated toggles produce the correct final state', () async {
      const testId = 'prod_rapid';
      expect(controller.isFavorite(testId), isFalse);

      // Fire 5 rapid toggles without awaiting in between
      final f1 = controller.toggleFavorite(testId); // -> true
      final f2 = controller.toggleFavorite(testId); // -> false
      final f3 = controller.toggleFavorite(testId); // -> true
      final f4 = controller.toggleFavorite(testId); // -> false
      final f5 = controller.toggleFavorite(testId); // -> true (final)

      // Immediate synchronous state should reflect final tap
      expect(controller.isFavorite(testId), isTrue);

      await Future.wait([f1, f2, f3, f4, f5]);

      // Final settled state must still be true
      expect(controller.isFavorite(testId), isTrue);
    });

    test('8. Different products can update independently', () async {
      const idA = 'prod_A';
      const idB = 'prod_B';

      expect(controller.isFavorite(idA), isFalse);
      expect(controller.isFavorite(idB), isFalse);

      final taskA = controller.toggleFavorite(idA);
      final taskB = controller.toggleFavorite(idB);

      expect(controller.isFavorite(idA), isTrue);
      expect(controller.isFavorite(idB), isTrue);

      await Future.wait([taskA, taskB]);

      expect(fakeRepository.addedProductCalls, contains(idA));
      expect(fakeRepository.addedProductCalls, contains(idB));

      // Toggle A off while B remains on
      await controller.toggleFavorite(idA);
      expect(controller.isFavorite(idA), isFalse);
      expect(controller.isFavorite(idB), isTrue);
    });
  });
}
