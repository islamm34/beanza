import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/features/products/domain/entities/products_entity.dart';

void main() {
  group('ProductEntity', () {
    test('supports price getter fallback from basePrice', () {
      final product = ProductEntity(
        id: 'p1',
        name: 'Espresso',
        description: 'Rich dark roast espresso',
        basePrice: 4.50,
        imageUrl: 'http://example.com/espresso.jpg',
        rating: 4.8,
        reviewCount: 120,
        variants: const [],
        category: 'Coffee',
        isAvailable: true,
      );

      expect(product.basePrice, 4.50);
      expect(product.price, 4.50);
    });

    test('supports value equality', () {
      final product1 = ProductEntity(
        id: 'p1',
        name: 'Latte',
        description: 'Smooth steamed milk and espresso',
        basePrice: 5.25,
        imageUrl: 'http://example.com/latte.jpg',
        rating: 4.9,
        reviewCount: 85,
        variants: const [],
        category: 'Coffee',
        isAvailable: true,
      );

      final product2 = ProductEntity(
        id: 'p1',
        name: 'Latte',
        description: 'Smooth steamed milk and espresso',
        basePrice: 5.25,
        imageUrl: 'http://example.com/latte.jpg',
        rating: 4.9,
        reviewCount: 85,
        variants: const [],
        category: 'Coffee',
        isAvailable: true,
      );

      expect(product1, equals(product2));
    });
  });
}
