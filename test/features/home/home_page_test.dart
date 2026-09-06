import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/cart_controller.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/app/controllers/product_details_controller.dart';
import 'package:beanza/app/controllers/products_controller.dart';
import 'package:beanza/app/controllers/profile_controller.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/core/data/local_product_catalog.dart';
import 'package:beanza/features/home/presentation/pages/home_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomePage Regression & GetX Widget Tests', () {
    late ProductsController productsController;
    late FavoritesController favoritesController;

    setUp(() {
      Get.reset();
      Get.put(ProfileController());
      productsController = Get.put(ProductsController());
      favoritesController = Get.put(FavoritesController());
      Get.put(CartController());
      Get.put(TableSessionController());
      Get.put(ProductDetailsController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
        'HomePage renders successfully without throwing GetX exceptions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify page renders essential sections
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('Featured Coffee Menu'), findsOneWidget);
      expect(find.text('All'), findsWidgets);

      // Verify no pending exception occurred
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Updating selectedCategory observable updates category chips without GetX error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Select category Hot Coffee
      productsController.setCategory('Hot Coffee');
      await tester.pumpAndSettle();

      expect(productsController.selectedCategory.value, 'Hot Coffee');
      expect(
          productsController.filteredProducts
              .every((p) => p.category == 'Hot Coffee'),
          isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Updating searchQuery filters products reactively',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.light(),
          home: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Search for specific coffee
      productsController.setSearchQuery('Cappuccino');
      await tester.pumpAndSettle();

      expect(find.text('Cappuccino'), findsWidgets);
      expect(tester.takeException(), isNull);

      // Reset query
      productsController.setSearchQuery('');
      await tester.pumpAndSettle();
      expect(productsController.filteredProducts.length,
          LocalProductCatalog.products.length);
    });

    testWidgets('Toggling favorite on a product updates only favorite state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      const testProductId = 'prod_99';
      expect(favoritesController.isFavorite(testProductId), isFalse);

      favoritesController.toggleFavorite(testProductId);
      await tester.pumpAndSettle();

      expect(favoritesController.isFavorite(testProductId), isTrue);
      expect(tester.takeException(), isNull);
    });
  });
}
