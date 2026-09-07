import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beanza/app/controllers/language_controller.dart';
import 'package:beanza/app/translations/app_translations.dart';

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

  group('LanguageController Tests', () {
    test('Initializes with English when no language stored', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final controller = LanguageController(prefs: prefs);

      expect(controller.currentLanguage, equals('en'));
      expect(controller.isArabic, isFalse);
      expect(controller.isEnglish, isTrue);
      expect(controller.currentLocale, equals(const Locale('en', 'US')));
      expect(controller.textDirection, equals(TextDirection.ltr));
    });

    test('Initializes with Arabic when ar is saved in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'app_language_code': 'ar',
      });
      final prefs = await SharedPreferences.getInstance();
      final controller = LanguageController(prefs: prefs);

      expect(controller.currentLanguage, equals('ar'));
      expect(controller.isArabic, isTrue);
      expect(controller.isEnglish, isFalse);
      expect(controller.currentLocale, equals(const Locale('ar', 'EG')));
      expect(controller.textDirection, equals(TextDirection.rtl));
    });

    test('changeLanguage switches locale and persists to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final controller = LanguageController(prefs: prefs);

      await controller.changeLanguage('ar');

      expect(controller.currentLanguage, equals('ar'));
      expect(controller.isArabic, isTrue);
      expect(prefs.getString('app_language_code'), equals('ar'));
      expect(controller.textDirection, equals(TextDirection.rtl));

      await controller.changeLanguage('en');

      expect(controller.currentLanguage, equals('en'));
      expect(controller.isEnglish, isTrue);
      expect(prefs.getString('app_language_code'), equals('en'));
      expect(controller.textDirection, equals(TextDirection.ltr));
    });

    test('toggleLanguage alternates between English and Arabic', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final controller = LanguageController(prefs: prefs);

      expect(controller.currentLanguage, equals('en'));

      await controller.toggleLanguage();
      expect(controller.currentLanguage, equals('ar'));
      expect(controller.isArabic, isTrue);

      await controller.toggleLanguage();
      expect(controller.currentLanguage, equals('en'));
      expect(controller.isEnglish, isTrue);
    });
  });
}
