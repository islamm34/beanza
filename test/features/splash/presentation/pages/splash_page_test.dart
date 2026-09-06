import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:beanza/features/splash/presentation/pages/splash_page.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(TableSessionController());
  });

  testWidgets('SplashPage renders SvgPicture logo and branding text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const SplashPage()),
          GetPage(
              name: '/scanner',
              page: () => const Scaffold(body: Text('Scanner'))),
          GetPage(
              name: '/home', page: () => const Scaffold(body: Text('Home'))),
        ],
      ),
    );

    // Verify SvgPicture is present
    expect(find.byType(SvgPicture), findsOneWidget);

    // Verify Brewora title text is present
    expect(find.text('BREWORA'), findsOneWidget);
    expect(find.text('Artisan Coffee, Delivered Fresh'), findsOneWidget);

    // Verify CircularProgressIndicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump to let the 1000ms delay timer complete and avoid pending timers leak
    await tester.pump(const Duration(seconds: 2));
  });
}
