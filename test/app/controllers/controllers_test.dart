import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/cart_controller.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/app/controllers/orders_controller.dart';
import 'package:beanza/app/controllers/product_details_controller.dart';
import 'package:beanza/app/controllers/products_controller.dart';
import 'package:beanza/core/data/local_product_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GetX CartController', () {
    late CartController cartController;

    setUp(() {
      Get.reset();
      cartController = Get.put(CartController());
    });

    test('starts with empty cart', () {
      expect(cartController.cartItems, isEmpty);
      expect(cartController.subtotal, 0.0);
      expect(cartController.total, 0.0);
    });

    test('adds product and calculates total correctly', () {
      final product = LocalProductCatalog.products.first;
      cartController.addToCart(
        product: product,
        size: product.sizes.first,
        milk: product.milkOptions.first,
        quantity: 2,
      );

      expect(cartController.cartItems.length, 1);
      expect(cartController.itemCount, 2);
      expect(cartController.subtotal, product.basePrice * 2);
    });

    test('increments and decrements item quantity', () {
      final product = LocalProductCatalog.products.first;
      cartController.addToCart(
        product: product,
        size: product.sizes.first,
        milk: product.milkOptions.first,
        quantity: 1,
      );

      final itemId = cartController.cartItems.first.id;
      cartController.incrementQuantity(itemId);
      expect(cartController.cartItems.first.quantity, 2);

      cartController.decrementQuantity(itemId);
      expect(cartController.cartItems.first.quantity, 1);

      cartController.decrementQuantity(itemId);
      expect(cartController.cartItems, isEmpty);
    });
  });

  group('GetX FavoritesController', () {
    late FavoritesController favoritesController;

    setUp(() {
      Get.reset();
      favoritesController = Get.put(FavoritesController());
    });

    test('toggles favorite status', () {
      const productId = 'prod_99';
      expect(favoritesController.isFavorite(productId), isFalse);

      favoritesController.toggleFavorite(productId);
      expect(favoritesController.isFavorite(productId), isTrue);

      favoritesController.toggleFavorite(productId);
      expect(favoritesController.isFavorite(productId), isFalse);
    });
  });

  group('GetX ProductsController', () {
    late ProductsController productsController;

    setUp(() {
      Get.reset();
      productsController = Get.put(ProductsController());
    });

    test('filters products by category', () {
      productsController.setCategory('Hot Coffee');
      expect(
        productsController.filteredProducts
            .every((p) => p.category == 'Hot Coffee'),
        isTrue,
      );
    });

    test('filters products by search query', () {
      productsController.setSearchQuery('Espresso');
      expect(
        productsController.filteredProducts.any(
          (p) => p.name.toLowerCase().contains('espresso'),
        ),
        isTrue,
      );
    });
  });

  group('GetX ProductDetailsController & Calculation', () {
    late ProductDetailsController detailsController;

    setUp(() {
      Get.reset();
      Get.put(CartController());
      detailsController = Get.put(ProductDetailsController());
    });

    test('calculates price based on size multiplier and extra add-ons', () {
      final product = LocalProductCatalog.products.first; // basePrice: 3.50
      detailsController.initProduct(product);

      // Select Medium size (multiplier 1.25 -> 4.375)
      detailsController.selectSize(product.sizes[1]);
      // Add extra shot (+1.00 -> 5.375)
      detailsController.toggleExtra(product.extras.first);

      expect(detailsController.unitPrice, 5.375);
    });
  });

  group('GetX OrdersController', () {
    late OrdersController ordersController;

    setUp(() {
      Get.reset();
      Get.put(CartController());
      ordersController = Get.put(OrdersController());
    });

    test('creates new order and adds to orders list', () {
      final order = ordersController.placeOrder(
        items: [],
        subtotal: 10.0,
        tax: 0.8,
        deliveryFee: 2.5,
        total: 13.3,
        deliveryAddress: '123 Coffee Lane',
      );

      expect(ordersController.orders.length, 1);
      expect(ordersController.orders.first.id, order.id);
    });
  });
}
