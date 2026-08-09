import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils', () {
    test('isToday returns true for current date', () {
      final now = DateTime.now();
      expect(AppDateUtils.isToday(now), isTrue);
    });

    test('isYesterday returns true for yesterday date', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(AppDateUtils.isYesterday(yesterday), isTrue);
    });

    test('isThisYear returns true for dates in current year', () {
      final now = DateTime.now();
      expect(AppDateUtils.isThisYear(now), isTrue);
    });

    test('getRelativeTime returns correct relative time string', () {
      final now = DateTime.now();
      expect(AppDateUtils.getRelativeTime(now), 'Just now');
      expect(
        AppDateUtils.getRelativeTime(now.subtract(const Duration(minutes: 5))),
        '5m ago',
      );
      expect(
        AppDateUtils.getRelativeTime(now.subtract(const Duration(hours: 3))),
        '3h ago',
      );
      expect(
        AppDateUtils.getRelativeTime(now.subtract(const Duration(days: 1))),
        'Yesterday',
      );
      expect(
        AppDateUtils.getRelativeTime(now.subtract(const Duration(days: 4))),
        '4d ago',
      );
    });

    test('daysBetween calculates difference in days', () {
      final from = DateTime(2026, 1, 1);
      final to = DateTime(2026, 1, 10);
      expect(AppDateUtils.daysBetween(from, to), 9);
    });

    test('isFutureDate and isPastDate classify dates correctly', () {
      final future = DateTime.now().add(const Duration(days: 5));
      final past = DateTime.now().subtract(const Duration(days: 5));

      expect(AppDateUtils.isFutureDate(future), isTrue);
      expect(AppDateUtils.isPastDate(past), isTrue);
    });
  });
}
