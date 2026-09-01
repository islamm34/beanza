import 'package:flutter/material.dart';

class AppColors {
  // Dark Mode Colors
  static const Color darkBg = Color(0xFF080B09);
  static const Color darkCardBg = Color(0xFF111411);
  static const Color darkCardElevated = Color(0xFF171A17);
  static const Color darkSecondaryBg = Color(0xFF171A17);
  static const Color darkBorder = Color(0xFF2A302A);
  static const Color darkTextPrimary = Color(0xFFF5F2EA);
  static const Color darkTextSecondary = Color(0xFFA6A69F);

  // Light Mode Colors (Off-White Cafe Theme)
  static const Color lightBg = Color(0xFFF6F1E7);
  static const Color lightSecondaryBg = Color(0xFFEFE8DC);
  static const Color lightCardBg = Color(0xFFFFFDF8);
  static const Color lightCardElevated = Color(0xFFFAF6EF);
  static const Color lightBorder = Color(0xFFDED4C5);
  static const Color lightTextPrimary = Color(0xFF201611);
  static const Color lightTextSecondary = Color(0xFF746B63);

  // Brand Accents
  static const Color gold = Color(0xFFD0932F);
  static const Color goldBright = Color(0xFFF1B447);
  static const Color goldLight = Color(0xFFB6781E);
  static const Color primaryGreen = Color(0xFF31A93D);
  static const Color brightGreen = Color(0xFF55C948);
  static const Color primaryGreenLight = Color(0xFF278C35);

  // Backward compatibility alias constants
  static const Color espressoDark = Color(0xFF201611);
  static const Color coffeeBrown = Color(0xFFD0932F);
  static const Color coffeeLight = Color(0xFFB6781E);
  static const Color cream = Color(0xFFFFFDF8);
  static const Color warmBeige = Color(0xFFFAF6EF);
  static const Color softSand = Color(0xFFEFE8DC);
  static const Color caramel = Color(0xFFD0932F);
  static const Color coffeeGold = Color(0xFFD0932F);
  static const Color warmTan = Color(0xFFB6781E);
  static const Color textDark = Color(0xFF201611);
  static const Color textMuted = Color(0xFF746B63);
  static const Color textLight = Color(0xFFF5F2EA);
  static const Color textLightMuted = Color(0xFFA6A69F);

  // Status Colors
  static const Color success = Color(0xFF31A93D);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFF1B447);
  static const Color info = Color(0xFF29B6F6);

  // Transparent
  static const Color transparent = Color(0x00000000);

  // Dynamic Theme Helpers
  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBg : darkBg;
  }

  static Color getSecondaryBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSecondaryBg : darkSecondaryBg;
  }

  static Color getSurfaceColor(Brightness brightness) {
    return brightness == Brightness.light ? lightCardBg : darkCardBg;
  }

  static Color getElevatedSurfaceColor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightCardElevated
        : darkCardElevated;
  }

  static Color getBorderColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBorder : darkBorder;
  }

  static Color getTextColor(Brightness brightness) {
    return brightness == Brightness.light ? lightTextPrimary : darkTextPrimary;
  }

  static Color getTextMutedColor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightTextSecondary
        : darkTextSecondary;
  }

  static Color getGold(Brightness brightness) {
    return brightness == Brightness.light ? goldLight : gold;
  }

  static Color getGreen(Brightness brightness) {
    return brightness == Brightness.light ? primaryGreenLight : primaryGreen;
  }
}
