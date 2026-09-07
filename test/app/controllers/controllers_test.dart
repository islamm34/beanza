import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/cart_controller.dart';
import 'package:beanza/app/controllers/explore_controller.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/app/controllers/orders_controller.dart';
import 'package:beanza/app/controllers/product_details_controller.dart';
import 'package:beanza/app/controllers/products_controller.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/app/router/app_router.dart';
import 'package:beanza/app/routes/app_pages.dart';
import 'package:beanza/app/routes/app_routes.dart';
import 'package:beanza/core/data/local_product_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GetX CartController Unit Tests', () {
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

    test('clearing cart resets all items and totals without negative values',
        () {
      final product = LocalProductCatalog.products.first;
      cartController.addProduct(product);
      expect(cartController.cartItems, isNotEmpty);

      cartController.clearCart();
      expect(cartController.cartItems, isEmpty);
      expect(cartController.itemCount, 0);
      expect(cartController.subtotal, 0.0);
      expect(cartController.total, 0.0);
    });
  });

  group('GetX FavoritesController Unit Tests', () {
    late FavoritesController favoritesController;

    setUp(() {
      Get.reset();
      favoritesController = Get.put(FavoritesController());
    });

    test('toggles favorite status and avoids duplicates', () {
      const productId = 'prod_99';
      expect(favoritesController.isFavorite(productId), isFalse);

      favoritesController.toggleFavorite(productId);
      expect(favoritesController.isFavorite(productId), isTrue);

      favoritesController.toggleFavorite(productId);
      expect(favoritesController.isFavorite(productId), isFalse);
    });
  });

  group('GetX ProductsController Unit Tests', () {
    late ProductsController productsController;

    setUp(() {
      Get.reset();
      productsController = Get.put(ProductsController());
    });

    test('All category + empty search returns all products', () {
      productsController.setCategory('All');
      productsController.setSearchQuery('');
      expect(productsController.filteredProducts.length,
          LocalProductCatalog.products.length);
    });

    test('filters products by specific category', () {
      productsController.setCategory('Hot Coffee');
      expect(
        productsController.filteredProducts
            .every((p) => p.category == 'Hot Coffee'),
        isTrue,
      );
    });

    test(
        'filters products by search query with case-insensitivity and trimming',
        () {
      productsController.setCategory('All');
      productsController.setSearchQuery('   LATTE   ');
      expect(productsController.filteredProducts, isNotEmpty);
      expect(
        productsController.filteredProducts.every(
          (p) =>
              p.name.toLowerCase().contains('latte') ||
              p.category.toLowerCase().contains('latte'),
        ),
        isTrue,
      );
    });

    test('combines search and category filtering simultaneously', () {
      productsController.setCategory('Hot Coffee');
      productsController.setSearchQuery('Espresso');

      final results = productsController.filteredProducts;
      expect(results, isNotEmpty);
      expect(results.every((p) => p.category == 'Hot Coffee'), isTrue);
      expect(results.any((p) => p.name == 'Espresso'), isTrue);
    });

    test('resets filters correctly', () {
      productsController.setCategory('Iced Coffee');
      productsController.setSearchQuery('mocha');
      productsController.resetFilters();

      expect(productsController.selectedCategory.value, 'All');
      expect(productsController.searchQuery.value, '');
      expect(productsController.filteredProducts.length,
          LocalProductCatalog.products.length);
    });
  });

  group('GetX ProductDetailsController & Calculation Unit Tests', () {
    late ProductDetailsController detailsController;

    setUp(() {
      Get.reset();
      Get.put(CartController());
      detailsController = Get.put(ProductDetailsController());
    });

    test('calculates price based on size multiplier, milk, and extra add-ons',
        () {
      final product = LocalProductCatalog.products.first; // basePrice: 3.50
      detailsController.initProduct(product);

      // Select Medium size (multiplier 1.25 -> 4.375)
      detailsController.selectSize(product.sizes[1]);
      // Add extra shot (+1.00 -> 5.375)
      detailsController.toggleExtra(product.extras.first);

      expect(detailsController.unitPrice, 5.375);

      // Increase quantity to 3
      detailsController.incrementQuantity();
      detailsController.incrementQuantity();
      expect(detailsController.quantity.value, 3);
      expect(detailsController.totalPrice, 5.375 * 3);
    });
  });

  group('GetX OrdersController Unit Tests', () {
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
      expect(ordersController.orders.first.total, 13.3);
    });
  });

  group('GetX TableSessionController Unit Tests', () {
    late TableSessionController tableController;

    setUp(() {
      Get.reset();
      Get.put(CartController());
      tableController = Get.put(TableSessionController());
    });

    test('joins table session with participant name', () {
      expect(tableController.hasActiveSession, isFalse);

      tableController.joinTableSession(
        tableId: '12',
        tableNumber: '12',
        participantName: 'Ahmed',
      );

      expect(tableController.hasActiveSession, isTrue);
      expect(tableController.tableNumber, '12');
      expect(tableController.currentParticipant.value?.displayName, 'Ahmed');
      expect(tableController.participantCount, 1);
    });

    test('adds item to table order and computes subtotals correctly', () {
      tableController.joinTableSession(
        tableId: '12',
        tableNumber: '12',
        participantName: 'Ahmed',
      );

      final product = LocalProductCatalog.products.first;
      tableController.addItemToTableOrder(
        product: product,
        size: product.sizes.first,
        milk: product.milkOptions.first,
        quantity: 2,
      );

      expect(tableController.totalItemCount, 2);
      expect(tableController.subtotal, greaterThan(0));
    });

    test('handles participant done status and table readiness state machine',
        () {
      tableController.joinTableSession(
        tableId: '12',
        tableNumber: '12',
        participantName: 'Ahmed',
      );

      final meId = tableController.currentParticipant.value!.participantId;
      expect(tableController.allParticipantsDone, isFalse);

      final product = LocalProductCatalog.products.first;
      tableController.addItemToTableOrder(
        product: product,
        size: product.sizes.first,
        milk: product.milkOptions.first,
        quantity: 1,
      );

      tableController.markParticipantDone(meId);

      expect(tableController.allParticipantsDone, isTrue);
      expect(tableController.readinessMessage, contains('Everyone is ready'));

      tableController.markParticipantEditing(meId);
      expect(tableController.allParticipantsDone, isFalse);
    });

    test('leaving table session clears active table data', () {
      tableController.joinTableSession(
        tableId: '12',
        tableNumber: '12',
        participantName: 'Ahmed',
      );
      expect(tableController.hasActiveSession, isTrue);

      tableController.leaveTableSession();
      expect(tableController.hasActiveSession, isFalse);
      expect(tableController.currentSession.value, isNull);
    });

    test('Routes.HOME points to AppRouter main navigation shell', () {
      final homeRoute =
          AppPages.routes.firstWhere((r) => r.name == Routes.HOME);
      final pageWidget = homeRoute.page();
      expect(pageWidget, isA<AppRouter>());
    });
  });

  group('GetX ExploreController Unit Tests', () {
    late ExploreController exploreController;

    setUp(() {
      Get.reset();
      exploreController = Get.put(ExploreController());
    });

    test('loads products and filters by category', () {
      exploreController.setCategory('Hot Coffee');
      expect(
        exploreController.filteredProducts
            .every((p) => p.category == 'Hot Coffee'),
        isTrue,
      );
    });

    test('filters by search query', () {
      exploreController.setSearchQuery('Latte');
      expect(
        exploreController.filteredProducts.any(
          (p) => p.name.toLowerCase().contains('latte'),
        ),
        isTrue,
      );
    });

    test('applies advanced filters and sorting options', () {
      exploreController.applyAdvancedFilters(
        maxPriceVal: 5.0,
        minRatingVal: 4.8,
        hotVal: true,
        icedVal: false,
      );
      exploreController.setSort(ExploreSortOption.priceHighToLow);

      final results = exploreController.filteredProducts;
      expect(
          results.every((p) => p.basePrice <= 5.0 && p.rating >= 4.8), isTrue);
    });

    test('resets all explore filters correctly', () {
      exploreController.setCategory('Iced Coffee');
      exploreController.setSearchQuery('Cold');
      exploreController.applyAdvancedFilters(
        maxPriceVal: 6.0,
        minRatingVal: 4.5,
        hotVal: false,
        icedVal: true,
      );
      exploreController.resetAll();

      expect(exploreController.selectedCategory.value, 'All');
      expect(exploreController.searchQuery.value, '');
      expect(exploreController.activeFilterCount, 0);
      expect(exploreController.filteredProducts.length,
          LocalProductCatalog.products.length);
    });
  });
}
