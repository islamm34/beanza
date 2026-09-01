import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/core/utils/formatters.dart';

void main() {
  group('AppFormatters', () {
    test('formatPrice formats double to price string with 2 decimal places',
        () {
      expect(AppFormatters.formatPrice(5.9), '\$5.90');
      expect(AppFormatters.formatPrice(12.99), '\$12.99');
      expect(AppFormatters.formatPrice(0), '\$0.00');
    });

    test('formatPhoneNumber formats 10-digit phone strings', () {
      expect(AppFormatters.formatPhoneNumber('1234567890'), '(123) 456-7890');
      expect(
          AppFormatters.formatPhoneNumber('11234567890'), '+1 (123) 456-7890');
    });

    test('formatCardNumber spaces card numbers into groups of 4', () {
      expect(AppFormatters.formatCardNumber('1234567812345678'),
          '1234 5678 1234 5678');
    });

    test('formatPercentage formats multiplier into percentage', () {
      expect(AppFormatters.formatPercentage(0.15), '15.0%');
      expect(AppFormatters.formatPercentage(1.0), '100.0%');
    });

    test('formatPoints appends pts suffix', () {
      expect(AppFormatters.formatPoints(250), '250 pts');
    });

    test('formatDistance formats meters vs kilometers', () {
      expect(AppFormatters.formatDistance(0.5), '500 m');
      expect(AppFormatters.formatDistance(2.34), '2.3 km');
    });

    test('formatDuration formats duration into human readable string', () {
      expect(AppFormatters.formatDuration(const Duration(seconds: 45)), '45s');
      expect(AppFormatters.formatDuration(const Duration(minutes: 15)), '15m');
      expect(
          AppFormatters.formatDuration(const Duration(hours: 2, minutes: 30)),
          '2h 30m');
    });

    test('truncateText truncates text over specified length', () {
      expect(AppFormatters.truncateText('Hello World', 5), 'Hello...');
      expect(AppFormatters.truncateText('Short', 10), 'Short');
    });

    test('capitalizeFirstLetter capitalizes first character', () {
      expect(AppFormatters.capitalizeFirstLetter('espresso'), 'Espresso');
      expect(AppFormatters.capitalizeFirstLetter(''), '');
    });
  });
}
