import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/cart_controller.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/app/controllers/product_details_controller.dart';
import 'package:beanza/core/data/local_product_catalog.dart';
import 'package:beanza/core/widgets/buttons/favorite_button.dart';
import 'package:beanza/core/widgets/cards/product_card.dart';
import 'package:beanza/features/favorites/presentation/pages/favorites_page.dart';
import 'package:beanza/features/home/presentation/widgets/home_product_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Instant Favorites Reactive Widget Tests', () {
    late FavoritesController favoritesController;

    setUp(() {
      Get.reset();
      favoritesController = Get.put(FavoritesController());
      Get.put(CartController());
      Get.put(ProductDetailsController());
      favoritesController.loadFavorites(
          ['prod_1']); // initial: prod_1 is favorite, prod_2 is not
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
        '1-5. Two cards with same product ID update instantly & synchronously together without navigation',
        (WidgetTester tester) async {
      final product =
          LocalProductCatalog.products.firstWhere((p) => p.id == 'prod_2');

      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // First card with prod_2
                  SizedBox(
                    height: 240,
                    width: 200,
                    child: ProductCard(
                      productId: product.id,
                      imageUrl: product.image,
                      name: product.name,
                      category: product.category,
                      price: product.basePrice,
                      onTap: () {},
                    ),
                  ),
                  // Second card with same prod_2
                  SizedBox(
                    height: 240,
                    width: 200,
                    child: HomeProductCard(
                      product: product,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Initially unselected (Icons.favorite_border_rounded)
      expect(find.byIcon(Icons.favorite_border_rounded), findsNWidgets(2));
      expect(find.byIcon(Icons.favorite_rounded), findsNothing);

      // Tap first heart button
      final firstHeart = find.byType(FavoriteButton).first;
      await tester.tap(firstHeart);
      await tester.pumpAndSettle();

      // Both cards must change instantly to filled heart
      expect(find.byIcon(Icons.favorite_rounded), findsNWidgets(2));
      expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
      expect(favoritesController.isFavorite('prod_2'), isTrue);

      // Tap second heart button to unfavorite
      final secondHeart = find.byType(FavoriteButton).last;
      await tester.tap(secondHeart);
      await tester.pumpAndSettle();

      // Both cards immediately return to unselected border heart
      expect(find.byIcon(Icons.favorite_border_rounded), findsNWidgets(2));
      expect(find.byIcon(Icons.favorite_rounded), findsNothing);
      expect(favoritesController.isFavorite('prod_2'), isFalse);

      // Verify no exceptions occurred
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        '6-7. FavoritesPage automatically updates when item is added and disappears when removed',
        (WidgetTester tester) async {
      favoritesController.loadFavorites(['prod_1']);

      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const FavoritesPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Initially only prod_1 is displayed
      expect(find.byType(ProductCard), findsOneWidget);

      // Add prod_2 programmatically or from another screen
      favoritesController.toggleFavorite('prod_2');
      await tester.pumpAndSettle();

      // FavoritesPage updates automatically without reopening screen
      expect(find.byType(ProductCard), findsNWidgets(2));

      // Remove prod_1 by tapping its FavoriteButton on FavoritesPage
      final heartButtons = find.byType(FavoriteButton);
      expect(heartButtons, findsNWidgets(2));

      await tester.tap(heartButtons.first);
      await tester.pumpAndSettle();

      // prod_1 disappears immediately from the list
      expect(find.byType(ProductCard), findsOneWidget);
      expect(favoritesController.isFavorite('prod_1'), isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('8. Works seamlessly in both Light Mode and Dark Mode',
        (WidgetTester tester) async {
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        favoritesController.loadFavorites(['prod_1']);

        await tester.pumpWidget(
          GetMaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: mode,
            home: Scaffold(
              body: Center(
                child: FavoriteButton(
                  productId: 'prod_1',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

        // Tap to toggle off
        await tester.tap(find.byType(FavoriteButton));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets(
        '9-10. Only the FavoriteButton widget rebuilds, no improper Obx exceptions',
        (WidgetTester tester) async {
      int gridBuildCount = 0;

      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                gridBuildCount++;
                return ListView(
                  children: [
                    SizedBox(
                      height: 240,
                      width: 200,
                      child: ProductCard(
                        productId: 'prod_1',
                        imageUrl: 'assets/images/coffee/espresso.jpg',
                        name: 'Espresso',
                        category: 'Hot Coffee',
                        price: 3.50,
                        onTap: () {},
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final initialBuildCount = gridBuildCount;

      // Toggle favorite on card
      await tester.tap(find.byType(FavoriteButton));
      await tester.pumpAndSettle();

      // Parent list did not rebuild; only FavoriteButton reactively refreshed
      expect(gridBuildCount, equals(initialBuildCount));
      expect(tester.takeException(), isNull);
    });
  });
}
