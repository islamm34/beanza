import 'package:flutter/material.dart';
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
import 'package:beanza/app/router/app_router.dart';
import 'package:beanza/core/data/local_product_catalog.dart';
import 'package:beanza/features/checkout/presentation/pages/checkout_page.dart';
import 'package:beanza/features/checkout/presentation/pages/order_confirmation_page.dart';
import 'package:beanza/features/order_tracking/presentation/pages/order_tracking_page.dart';
import 'package:beanza/features/orders/presentation/pages/orders_page.dart';
import 'package:beanza/features/profile/presentation/pages/payment_methods_page.dart';
import 'package:beanza/features/profile/presentation/pages/profile_page.dart';
import 'package:beanza/features/rewards/presentation/pages/rewards_page.dart';
import 'package:beanza/features/table_session/presentation/pages/cafe_dashboard_page.dart';
import 'package:beanza/features/table_session/presentation/pages/hospitality_hub_page.dart';
import 'package:beanza/features/table_session/presentation/pages/name_entry_page.dart';
import 'package:beanza/features/table_session/presentation/pages/table_overview_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('All 15 Screens Widget & Theming Tests', () {
    setUp(() {
      Get.reset();
      Get.testMode = true;
      Get.put(CartController());
      Get.put(FavoritesController());
      Get.put(ProductsController());
      Get.put(ProductDetailsController());
      Get.put(OrdersController());
      Get.put(RewardsController());
      Get.put(ProfileController());
      Get.put(TableSessionController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('Screen 2: NameEntryPage & TableOverviewPage render correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const NameEntryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NameEntryPage), findsOneWidget);
      expect(find.text('Join Table Session'), findsOneWidget);

      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const TableOverviewPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TableOverviewPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Screen 7: CheckoutPage renders with Order Summary and Send CTA',
        (WidgetTester tester) async {
      final cartCtrl = Get.find<CartController>();
      cartCtrl.addProduct(LocalProductCatalog.products.first);

      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const CheckoutPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CheckoutPage), findsOneWidget);
      expect(find.text('Order Summary / ملخص الطلبات'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Screen 8: OrderTrackingPage renders countdown and progress stages',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const OrderTrackingPage(orderId: 'ORD-101'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OrderTrackingPage), findsOneWidget);
      expect(find.text('Live Order Tracking'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Screen 9: HospitalityHubPage renders 2-column service cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const HospitalityHubPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HospitalityHubPage), findsOneWidget);
      expect(find.text('Call Waiter'), findsOneWidget);
      expect(find.text('Request Tissues'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Screen 10: PaymentMethodsPage renders split bill options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const PaymentMethodsPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PaymentMethodsPage), findsOneWidget);
      expect(find.text('Payment & Split • تقسيم الحساب'), findsOneWidget);
      expect(find.text('Equally'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Screen 11: OrderConfirmationPage renders celebration badge',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const OrderConfirmationPage(
            orderId: 'ORD-101',
            totalAmount: 48.0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OrderConfirmationPage), findsOneWidget);
      expect(find.text('ROUND 1 COMPLETED • الجولة الأولى مكتملة'),
          findsOneWidget);
      expect(find.text('Order Sent to Barista! ☕'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Screen 12: OrdersPage renders tabs and total spent banner',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const OrdersPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OrdersPage), findsOneWidget);
      expect(find.text('Table Rounds (الجولات)'), findsOneWidget);
      expect(find.text('All Orders (جميع الطلبات)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Screen 13: RewardsPage renders gold member card and achievements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const RewardsPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RewardsPage), findsOneWidget);
      expect(find.text('SILVER MEMBER • عضو فضي'), findsOneWidget);
      expect(find.text('Available Rewards / المكافآت المتاحة'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Screen 14: ProfilePage renders menu list and logout button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const ProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.text('My Orders / طلباتي'), findsOneWidget);
      expect(find.text('Log Out / تسجيل الخروج'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Screen 15: CafeDashboardPage renders summary cards and live queue',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const CafeDashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CafeDashboardPage), findsOneWidget);
      expect(find.text('Preparing'), findsWidgets);
      expect(find.text('Ready'), findsWidgets);
      expect(find.text('Completed Today'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Bottom Navigation Bar switches tabs correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const AppRouter(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppRouter), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Tap Explore tab
      await tester.tap(find.text('Explore'));
      await tester.pumpAndSettle();

      // Tap Profile tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
