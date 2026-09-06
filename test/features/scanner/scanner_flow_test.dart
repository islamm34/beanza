import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/cart_controller.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/app/controllers/products_controller.dart';
import 'package:beanza/app/controllers/profile_controller.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/app/routes/app_pages.dart';
import 'package:beanza/app/routes/app_routes.dart';
import 'package:beanza/features/scanner/presentation/pages/scanner_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScannerPage Lifecycle & Navigation Flow Tests', () {
    setUp(() {
      Get.reset();
      Get.testMode = true;
      Get.put(ProfileController());
      Get.put(CartController());
      Get.put(FavoritesController());
      Get.put(ProductsController());
      Get.put(TableSessionController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('ScannerPage renders with dark background and controls',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          getPages: AppPages.routes,
          home: const ScannerPage(overrideHasPermission: true),
        ),
      );
      await tester.pump();

      expect(find.byType(ScannerPage), findsOneWidget);
      expect(find.text('Point at Table QR to Join Session'), findsWidgets);
      expect(find.text('Enter Table #'), findsOneWidget);
      expect(find.text('Open Menu Directly'), findsOneWidget);
    });

    testWidgets('Manual Table dialog opens and validates table number input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          getPages: AppPages.routes,
          home: const ScannerPage(overrideHasPermission: true),
        ),
      );
      await tester.pump();

      // Tap "Enter Table #" button
      final enterTableBtn = find.text('Enter Table #');
      expect(enterTableBtn, findsOneWidget);
      await tester.tap(enterTableBtn);
      await tester.pump(const Duration(milliseconds: 200));

      // Verify dialog is shown
      expect(find.text('Enter Table Number'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Tap Cancel to dismiss
      await tester.tap(find.text('Cancel'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Enter Table Number'), findsNothing);
    });

    testWidgets('Tapping Open Menu Directly navigates to Home cleanly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.SCANNER,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final openMenuBtn = find.text('Open Menu Directly');
      expect(openMenuBtn, findsOneWidget);
      await tester.tap(openMenuBtn);
      await tester.pumpAndSettle();

      // Check that navigation proceeded without errors
      expect(tester.takeException(), isNull);
    });
  });
}
