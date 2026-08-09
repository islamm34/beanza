import 'package:intl/intl.dart';

class AppFormatters {
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  static String formatCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol);
    return formatter.format(amount);
  }

  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateTime(DateTime dateTime, {String format = 'MMM dd, yyyy HH:mm'}) {
    return DateFormat(format).format(dateTime);
  }

  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }

  static String formatPhoneNumber(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    return phone;
  }

  static String formatCardNumber(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    return digits.replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)} ').trim();
  }

  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  static String formatPoints(int points) {
    return '$points pts';
  }

  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).toStringAsFixed(0)} m';
    }
    return '${distanceInKm.toStringAsFixed(1)} km';
  }

  static String formatDuration(Duration duration) {
    if (duration.inMinutes == 0) {
      return '${duration.inSeconds}s';
    } else if (duration.inHours == 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
  }

  static String truncateText(String text, int length) {
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
