import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:beanza/features/splash/presentation/pages/splash_page.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/core/models/table_session_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    Get.put(TableSessionController());
  });

  tearDown(() {
    Get.reset();
  });

  group('SplashPage Comprehensive & Responsive Tests', () {
    testWidgets(
        '1. SplashPage renders SvgPicture logo without exceptions with BoxFit.contain',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const SplashPage()),
            GetPage(
                name: '/scanner',
                page: () => const Scaffold(body: Text('Scanner Screen'))),
            GetPage(
                name: '/home',
                page: () => const Scaffold(body: Text('Home Screen'))),
          ],
        ),
      );

      // Verify SvgPicture is present and visible
      final svgFinder = find.byType(SvgPicture);
      expect(svgFinder, findsOneWidget);

      final svgWidget = tester.widget<SvgPicture>(svgFinder);
      expect(svgWidget.fit, equals(BoxFit.contain));
      expect(svgWidget.semanticsLabel, equals('Cafe logo'));

      // Verify no exceptions were thrown during build
      expect(tester.takeException(), isNull);

      // Advance clock to trigger navigation
      await tester.pump(const Duration(milliseconds: 3600));
      await tester.pumpAndSettle();

      // Verified navigation callback completed to Scanner (since no active session)
      expect(find.text('Scanner Screen'), findsOneWidget);
    });

    testWidgets(
        '2. SplashPage renders correctly in Light Mode (warm off-white background)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.light(),
          themeMode: ThemeMode.light,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const SplashPage()),
            GetPage(
                name: '/scanner',
                page: () => const Scaffold(body: Text('Scanner Screen'))),
          ],
        ),
      );
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(const Color(0xFFF6F1E7)));
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pump(const Duration(milliseconds: 3600));
      await tester.pumpAndSettle();
    });

    testWidgets(
        '3. SplashPage renders correctly in Dark Mode (near black background with subtle glow)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const SplashPage()),
            GetPage(
                name: '/scanner',
                page: () => const Scaffold(body: Text('Scanner Screen'))),
          ],
        ),
      );
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(const Color(0xFF080B09)));
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pump(const Duration(milliseconds: 3600));
      await tester.pumpAndSettle();
    });

    for (final width in [320.0, 360.0, 390.0, 412.0]) {
      testWidgets('Responsive rendering at ${width.toInt()}px without overflow',
          (WidgetTester tester) async {
        tester.view.physicalSize = Size(width * 2, 800 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const SplashPage()),
              GetPage(
                  name: '/scanner',
                  page: () => const Scaffold(body: Text('Scanner Screen'))),
            ],
          ),
        );
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.pump(const Duration(milliseconds: 3600));
        await tester.pumpAndSettle();
      });
    }

    testWidgets('5. Navigates to Home when active table session is present',
        (WidgetTester tester) async {
      final tableSessionController = Get.find<TableSessionController>();
      tableSessionController.currentSession.value = TableSession(
        sessionId: 'test_session_1',
        tableId: 'table_5',
        tableNumber: 'Table 5',
        createdAt: DateTime.now(),
        participants: [],
        orderItems: [],
      );

      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const SplashPage()),
            GetPage(
                name: '/scanner',
                page: () => const Scaffold(body: Text('Scanner Screen'))),
            GetPage(
                name: '/home',
                page: () => const Scaffold(body: Text('Home Screen'))),
          ],
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 3600));
      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);
    });
  });
}
