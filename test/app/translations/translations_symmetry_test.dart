import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/app/translations/app_translations.dart';
import 'package:beanza/app/translations/en_translations.dart';
import 'package:beanza/app/translations/ar_translations.dart';

void main() {
  group('Translations Symmetry & Quality Tests', () {
    test('enTranslations and arTranslations must have identical keys', () {
      final enKeys = enTranslations.keys.toSet();
      final arKeys = arTranslations.keys.toSet();

      final missingInAr = enKeys.difference(arKeys);
      final missingInEn = arKeys.difference(enKeys);

      expect(
        missingInAr,
        isEmpty,
        reason: 'Keys in enTranslations but missing in arTranslations: $missingInAr',
      );

      expect(
        missingInEn,
        isEmpty,
        reason: 'Keys in arTranslations but missing in enTranslations: $missingInEn',
      );
    });

    test('No translation strings should be empty or whitespace only', () {
      for (final entry in enTranslations.entries) {
        expect(
          entry.value.trim().isNotEmpty,
          isTrue,
          reason: 'English translation for key "${entry.key}" is empty',
        );
      }

      for (final entry in arTranslations.entries) {
        expect(
          entry.value.trim().isNotEmpty,
          isTrue,
          reason: 'Arabic translation for key "${entry.key}" is empty',
        );
      }
    });

    test('Parameters (@paramName) must match between English and Arabic translations', () {
      final paramRegex = RegExp(r'@[a-zA-Z0-9_]+');

      for (final key in enTranslations.keys) {
        final enVal = enTranslations[key]!;
        final arVal = arTranslations[key];
        if (arVal == null) continue;

        final enParams = paramRegex
            .allMatches(enVal)
            .map((m) => m.group(0)!)
            .toSet();
        final arParams = paramRegex
            .allMatches(arVal)
            .map((m) => m.group(0)!)
            .toSet();

        expect(
          arParams,
          equals(enParams),
          reason:
              'Parameter mismatch for key "$key": en has $enParams, ar has $arParams',
        );
      }
    });

    test('AppTranslations contains en and ar locale maps', () {
      final appTranslations = AppTranslations();
      final keys = appTranslations.keys;

      expect(keys.containsKey('en'), isTrue);
      expect(keys.containsKey('ar'), isTrue);
      expect(keys.containsKey('en_US'), isTrue);
      expect(keys.containsKey('ar_EG'), isTrue);
    });

    test('Table terminology uses الترابيزة in Arabic translations', () {
      expect(arTranslations['table_lobby_title']!.contains('الترابيزة'), isTrue);
      expect(arTranslations['join_table_session_title']!.contains('الترابيزة'), isTrue);
    });
  });
}
