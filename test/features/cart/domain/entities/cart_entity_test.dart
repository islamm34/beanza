import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/features/cart/domain/entities/cart_entity.dart';

void main() {
  group('CartItemEntity', () {
    test('calculates totalPrice correctly as price * quantity', () {
      final cartItem = CartItemEntity(
        id: 'c1',
        productId: 'p1',
        productName: 'Cappuccino',
        price: 5.50,
        quantity: 3,
        selectedSize: 'Medium',
        customizations: const ['Extra Shot'],
        imageUrl: 'http://example.com/cappuccino.jpg',
      );

      expect(cartItem.totalPrice, 16.50);
    });
  });

  group('CartSummaryEntity', () {
    test('holds cart summary breakdown values accurately', () {
      final cartItem = CartItemEntity(
        id: 'c1',
        productId: 'p1',
        productName: 'Americano',
        price: 4.00,
        quantity: 2,
        selectedSize: 'Large',
        customizations: const [],
        imageUrl: 'http://example.com/americano.jpg',
      );

      final summary = CartSummaryEntity(
        items: [cartItem],
        subtotal: 8.00,
        tax: 0.80,
        deliveryFee: 2.00,
        discount: 1.00,
        total: 9.80,
      );

      expect(summary.items.length, 1);
      expect(summary.subtotal, 8.00);
      expect(summary.total, 9.80);
    });
  });
}
