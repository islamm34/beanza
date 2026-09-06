import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/cart_controller.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/app/controllers/orders_controller.dart';
import 'package:beanza/app/controllers/product_details_controller.dart';
import 'package:beanza/app/controllers/products_controller.dart';
import 'package:beanza/app/controllers/profile_controller.dart';
import 'package:beanza/app/controllers/rewards_controller.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/app/routes/app_pages.dart';
import 'package:beanza/app/routes/app_routes.dart';
import 'package:beanza/core/data/local_product_catalog.dart';
import 'package:beanza/features/scanner/presentation/pages/scanner_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Full User Journey Critical Navigation Flow', () {
    late CartController cartController;
    late TableSessionController tableController;
    late ProductDetailsController detailsController;
    late OrdersController ordersController;

    setUp(() {
      Get.reset();
      Get.testMode = true;
      cartController = Get.put(CartController());
      Get.put(FavoritesController());
      Get.put(ProductsController());
      detailsController = Get.put(ProductDetailsController());
      ordersController = Get.put(OrdersController());
      Get.put(RewardsController());
      Get.put(ProfileController());
      tableController = Get.put(TableSessionController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
        'Step-by-step navigation journey from Scanner to Table Lobby, Menu, Cart, Checkout, and Tracking',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.SCANNER,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump();

      // 1. Scanner Screen
      expect(find.byType(ScannerPage), findsOneWidget);
      expect(Get.currentRoute, Routes.SCANNER);

      // 2. Scanner -> Name Entry
      Get.toNamed(Routes.NAME_ENTRY,
          arguments: {'tableId': '12', 'tableNumber': '12'});
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.NAME_ENTRY);
      expect(find.text('Join Table Session'), findsOneWidget);

      // 3. Join Table -> Table Lobby (Overview)
      tableController.joinTableSession(
        tableId: '12',
        tableNumber: '12',
        participantName: 'Karim',
      );
      Get.toNamed(Routes.TABLE_OVERVIEW);
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.TABLE_OVERVIEW);
      expect(find.text('Table 12'), findsOneWidget);

      // 4. Table Lobby -> Smart Menu (Home)
      Get.toNamed(Routes.HOME);
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.HOME);
      expect(tableController.hasActiveSession, isTrue);

      // 5. Home -> Product Details (Drink Builder)
      final product = LocalProductCatalog.products.first;
      detailsController.initProduct(product);
      Get.toNamed(Routes.PRODUCTS, arguments: {'productId': product.id});
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.PRODUCTS);

      // 6. Add product to Table Order and go to Shared Cart
      tableController.addItemToTableOrder(
        product: product,
        size: product.sizes.first,
        milk: product.milkOptions.first,
        quantity: 1,
      );
      Get.toNamed(Routes.CART);
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.CART);
      expect(find.text('Table 12 Cart'), findsOneWidget);

      // 7. Shared Cart -> Checkout (Review Order)
      Get.toNamed(Routes.CHECKOUT);
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.CHECKOUT);
      expect(find.text('Review Table 12 Order'), findsOneWidget);

      // 8. Checkout -> Order Tracking
      final order = ordersController.placeOrder(
        items: cartController.cartItems,
        subtotal: 10.0,
        tax: 0.8,
        deliveryFee: 0.0,
        total: 10.8,
        deliveryAddress: 'Table 12',
      );
      Get.toNamed(Routes.ORDER_TRACKING, arguments: {'orderId': order.id});
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.ORDER_TRACKING);
      expect(find.text('Live Order Tracking'), findsOneWidget);

      // 9. Order Tracking -> Payment Methods
      Get.toNamed(Routes.PAYMENT_METHODS);
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.PAYMENT_METHODS);
      expect(find.text('Payment & Split • تقسيم الحساب'), findsOneWidget);

      // Verify no unhandled exceptions across the entire flow
      expect(tester.takeException(), isNull);
    });
  });
}
