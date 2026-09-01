import 'dart:ui';

class AppHelpers {
  static String generateUUID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return url.startsWith('http://') || url.startsWith('https://');
    } catch (e) {
      return false;
    }
  }

  static String removeLeadingZero(String value) {
    if (value.startsWith('0') && value.length > 1) {
      return value.substring(1);
    }
    return value;
  }

  static String addCurrencySymbol(String value) {
    return '\$$value';
  }

  static double stringToDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }

  static int stringToInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }

  static bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  static String getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  static Color hexToColor(String hexColor) {
    return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  static T? tryCast<T>(dynamic value) {
    try {
      return value as T;
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic> flattenMap(Map<String, dynamic> map,
      {String prefix = ''}) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        result.addAll(flattenMap(value, prefix: newKey));
      } else {
        result[newKey] = value;
      }
    });
    return result;
  }

  static Map<String, dynamic> deepCopy(Map<String, dynamic> map) {
    return Map<String, dynamic>.from(
      map.map((key, value) {
        if (value is Map<String, dynamic>) {
          return MapEntry(key, deepCopy(value));
        } else if (value is List) {
          return MapEntry(key, List.from(value));
        }
        return MapEntry(key, value);
      }),
    );
  }
}
