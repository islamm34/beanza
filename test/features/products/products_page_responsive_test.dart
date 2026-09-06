import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/cart_controller.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/app/controllers/product_details_controller.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/core/data/local_product_catalog.dart';
import 'package:beanza/features/products/presentation/pages/products_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductsPage Responsive Viewports & RTL Layout Tests', () {
    late ProductDetailsController detailsController;

    setUp(() {
      Get.reset();
      Get.put(CartController());
      Get.put(FavoritesController());
      detailsController = Get.put(ProductDetailsController());
      Get.put(TableSessionController());
    });

    tearDown(() {
      Get.reset();
    });

    final testViewports = [
      {'name': '320px (Narrow/Small Phone)', 'size': const Size(320, 640)},
      {'name': '360px (Standard Android)', 'size': const Size(360, 780)},
      {'name': '390px (iPhone 13/14)', 'size': const Size(390, 844)},
      {'name': '412px (Pixel/Large Device)', 'size': const Size(412, 915)},
    ];

    for (final vp in testViewports) {
      final name = vp['name'] as String;
      final size = vp['size'] as Size;

      testWidgets('Renders without overflow on $name in Light Mode (LTR)',
          (WidgetTester tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final product = LocalProductCatalog.products.first;
        detailsController.initProduct(product);

        await tester.pumpWidget(
          GetMaterialApp(
            theme: ThemeData.light(),
            home: ProductsPage(productId: product.id),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ProductsPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Renders without overflow on $name in Dark Mode (Arabic RTL)',
          (WidgetTester tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final product = LocalProductCatalog.products.first;
        detailsController.initProduct(product);

        await tester.pumpWidget(
          GetMaterialApp(
            theme: ThemeData.dark(),
            locale: const Locale('ar', 'EG'),
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: ProductsPage(productId: product.id),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ProductsPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets(
        'Handles large customization prices and multi-digit values without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320 * 2.0, 640 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final product = LocalProductCatalog.products.first;
      detailsController.initProduct(product);

      // Add multiple extras to create a large multi-digit price
      for (final extra in product.extras) {
        detailsController.toggleExtra(extra);
      }
      for (int i = 0; i < 5; i++) {
        detailsController.incrementQuantity();
      }

      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: ProductsPage(productId: product.id),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProductsPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
