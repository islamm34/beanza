import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  static const Color lightBg = Color(0xFFFAF8F5);
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightSecondaryBg = Color(0xFFF5F2F0);

  // Dark Mode Colors
  static const Color darkBg = Color(0xFF1A1410);
  static const Color darkCardBg = Color(0xFF2B2420);
  static const Color darkSecondaryBg = Color(0xFF3D3530);

  // Primary Coffee Browns
  static const Color espressoDark = Color(0xFF2C1810);
  static const Color coffeeBrown = Color(0xFF6F4E37);
  static const Color coffeeLight = Color(0xFF8B6F47);

  // Secondary Cream/Beige
  static const Color cream = Color(0xFFFFF8F0);
  static const Color warmBeige = Color(0xFFF5E6D3);
  static const Color softSand = Color(0xFFE8D5C0);

  // Accent Colors
  static const Color caramel = Color(0xFFD4A574);
  static const Color coffeeGold = Color(0xFFB8860B);
  static const Color warmTan = Color(0xFFA0826D);

  // Text Colors
  static const Color textDark = Color(0xFF2C1810);
  static const Color textMuted = Color(0xFF8B7D77);
  static const Color textLight = Color(0xFFF5F2F0);
  static const Color textLightMuted = Color(0xFFC4BFBA);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF2196F3);

  // Transparent
  static const Color transparent = Color(0x00000000);

  // Get text color based on theme brightness
  static Color getTextColor(Brightness brightness) {
    return brightness == Brightness.light ? textDark : textLight;
  }

  static Color getTextMutedColor(Brightness brightness) {
    return brightness == Brightness.light ? textMuted : textLightMuted;
  }

  static Color getSurfaceColor(Brightness brightness) {
    return brightness == Brightness.light ? lightCardBg : darkCardBg;
  }

  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBg : darkBg;
  }
}
