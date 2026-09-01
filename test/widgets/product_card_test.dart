import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/core/widgets/buttons/favorite_button.dart';
import 'package:beanza/core/widgets/cards/product_card.dart';

void main() {
  group('ProductCard Widget', () {
    testWidgets('renders product details correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              imageUrl: 'http://example.com/image.jpg',
              name: 'Caramel Macchiato',
              category: 'Coffee',
              price: 6.25,
              rating: 4.7,
              reviewCount: 42,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Caramel Macchiato'), findsOneWidget);
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('6.25 EGP'), findsOneWidget);
      expect(find.text('4.7'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              imageUrl: 'http://example.com/image.jpg',
              name: 'Mocha',
              category: 'Coffee',
              price: 5.50,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Mocha'));
      expect(tapped, isTrue);
    });

    testWidgets('renders reactive FavoriteButton when productId is provided',
        (WidgetTester tester) async {
      Get.reset();
      final favCtrl = Get.put(FavoritesController());
      favCtrl.loadFavorites(['prod_1']);

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: ProductCard(
              productId: 'prod_1',
              imageUrl: 'http://example.com/image.jpg',
              name: 'Espresso',
              category: 'Coffee',
              price: 3.50,
              onTap: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

      await tester.tap(find.byType(FavoriteButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
      expect(favCtrl.isFavorite('prod_1'), isFalse);
    });
  });
}
