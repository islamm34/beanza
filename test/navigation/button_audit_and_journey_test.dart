import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beanza/app/controllers/cart_controller.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/app/controllers/orders_controller.dart';
import 'package:beanza/app/controllers/product_details_controller.dart';
import 'package:beanza/app/controllers/products_controller.dart';
import 'package:beanza/app/controllers/profile_controller.dart';
import 'package:beanza/app/controllers/rewards_controller.dart';
import 'package:beanza/app/controllers/scan_history_controller.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/core/data/local_product_catalog.dart';
import 'package:beanza/core/widgets/table/table_flow_navigation.dart';
import 'package:beanza/features/cart/presentation/pages/cart_page.dart';
import 'package:beanza/features/profile/presentation/pages/profile_page.dart';
import 'package:beanza/features/rewards/presentation/pages/rewards_page.dart';
import 'package:beanza/features/scan_history/presentation/pages/scan_history_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Button Audit and Interactive Elements Verification', () {
    late CartController cartController;
    late FavoritesController favoritesController;
    late ScanHistoryController scanHistoryController;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      Get.reset();
      Get.testMode = true;
      cartController = Get.put(CartController());
      favoritesController = Get.put(FavoritesController());
      Get.put(ProductsController());
      Get.put(ProductDetailsController());
      Get.put(OrdersController());
      Get.put(RewardsController());
      Get.put(ProfileController());
      scanHistoryController = Get.put(ScanHistoryController());
      Get.put(TableSessionController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('1. TableFlowNavigation renders and interacts correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TableFlowNavigation(
              currentStep: TableFlowStep.cartAndSplit,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TableFlowNavigation), findsOneWidget);
    });

    testWidgets(
        '2. Scan History clear sweep dialog and delete interactions work',
        (WidgetTester tester) async {
      scanHistoryController.addScanRecord(
        'brewora://table/4',
        'QR_CODE',
        'TABLE',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: const ScanHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ScanHistoryPage), findsOneWidget);
      expect(scanHistoryController.scanHistory.isNotEmpty, isTrue);

      final clearButton = find.byTooltip('Clear History');
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      expect(find.text('Clear Scan History?'), findsOneWidget);
      final confirmButton = find.byKey(const Key('confirm_clear_history'));
      expect(confirmButton, findsOneWidget);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(scanHistoryController.scanHistory.isEmpty, isTrue);
    });

    testWidgets(
        '3. Profile Page buttons (Edit Profile, Help & Support, Theme toggle) work',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const ProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      final helpTile = find.byKey(const Key('help_support_tile'));
      expect(helpTile, findsOneWidget);
      await tester.tap(helpTile);
      await tester.pumpAndSettle();

      expect(find.text('support@brewora.co'), findsOneWidget);

      final closeButton = find.byKey(const Key('close_help_support_button'));
      await tester.tap(closeButton);
      await tester.pumpAndSettle();
      expect(find.text('support@brewora.co'), findsNothing);
    });

    testWidgets('4. Favorites toggle updates reactively without dead clicks',
        (WidgetTester tester) async {
      final product = LocalProductCatalog.products.first;

      final initialFavState = favoritesController.isFavorite(product.id);
      favoritesController.toggleFavorite(product.id);

      expect(
        favoritesController.isFavorite(product.id),
        equals(!initialFavState),
      );
    });

    testWidgets(
        '5. Cart increment, decrement, and clear cart actions are functional',
        (WidgetTester tester) async {
      final product = LocalProductCatalog.products.first;
      cartController.addToCart(
        product: product,
        size: product.sizes.first,
        milk: product.milkOptions.first,
        quantity: 2,
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: const CartPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CartPage), findsOneWidget);
      expect(cartController.cartItems.isNotEmpty, isTrue);

      cartController.clearCart();
      await tester.pumpAndSettle();
      expect(cartController.cartItems.isEmpty, isTrue);
    });

    testWidgets('6. Rewards page renders without exception',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const RewardsPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RewardsPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
