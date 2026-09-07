import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beanza/app/controllers/language_controller.dart';
import 'package:beanza/app/translations/app_translations.dart';
import 'package:beanza/core/data/local_product_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    Get.clearTranslations();
    Get.addTranslations(AppTranslations().keys);
  });

  tearDown(() {
    Get.reset();
  });

  group('Widget Localization & RTL Layout Tests', () {
    testWidgets('Renders localized text and correct directionality in LTR (English)', (tester) async {
      SharedPreferences.setMockInitialValues({'app_language_code': 'en'});
      final prefs = await SharedPreferences.getInstance();
      final langController = LanguageController(prefs: prefs);
      Get.put<LanguageController>(langController);
      Get.locale = const Locale('en', 'US');

      await tester.pumpWidget(
        GetMaterialApp(
          translations: AppTranslations(),
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en'),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'EG'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('nav_home'.tr),
              ),
              body: Center(
                child: Text('welcome_title'.tr),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Welcome to Brewora'), findsOneWidget);

      final directionality = tester.widget<Directionality>(
        find.byType(Directionality).first,
      );
      expect(directionality.textDirection, equals(TextDirection.ltr));
    });

    testWidgets('Renders localized Egyptian Arabic text and RTL directionality in Arabic', (tester) async {
      SharedPreferences.setMockInitialValues({'app_language_code': 'ar'});
      final prefs = await SharedPreferences.getInstance();
      final langController = LanguageController(prefs: prefs);
      Get.put<LanguageController>(langController);
      Get.locale = const Locale('ar', 'EG');

      await tester.pumpWidget(
        GetMaterialApp(
          translations: AppTranslations(),
          locale: const Locale('ar', 'EG'),
          fallbackLocale: const Locale('en'),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'EG'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('nav_home'.tr),
              ),
              body: Center(
                child: Text('welcome_title'.tr),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('مرحباً بك في بريورا'), findsOneWidget);

      final directionality = tester.widget<Directionality>(
        find.byType(Directionality).first,
      );
      expect(directionality.textDirection, equals(TextDirection.rtl));
    });

    test('Product model returns English and Arabic based on active locale', () {
      final product = LocalProductCatalog.products.first;

      Get.locale = const Locale('en', 'US');
      expect(product.localizedName, equals(product.name));

      Get.locale = const Locale('ar', 'EG');
      expect(product.localizedName, isNotEmpty);
      expect(product.localizedName, equals(product.nameAr ?? product.name));
      expect(product.localizedDescription, isNotEmpty);
    });

    for (final width in [320.0, 360.0, 390.0, 412.0]) {
      testWidgets('Renders Arabic UI cleanly on viewport width $width without overflow', (tester) async {
        tester.view.physicalSize = Size(width, 800.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        Get.locale = const Locale('ar', 'EG');

        await tester.pumpWidget(
          GetMaterialApp(
            translations: AppTranslations(),
            locale: const Locale('ar', 'EG'),
            fallbackLocale: const Locale('en'),
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'EG'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(
              appBar: AppBar(
                title: Text('table_lobby_title'.tr),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'join_table_session_title'.tr,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'total_items_in_cart'.trParams({'count': '3'}),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('join_table_button'.tr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.textContaining('الترابيزة'), findsWidgets);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
