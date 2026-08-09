import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

class LightTheme {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightCardBg,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headingLarge.copyWith(
          color: AppColors.textDark,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: AppColors.espressoDark,
        secondary: AppColors.caramel,
        surface: AppColors.lightCardBg,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.textDark,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: AppColors.textDark,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: AppColors.textDark,
        ),
        headlineLarge: AppTextStyles.headingLarge.copyWith(
          color: AppColors.textDark,
        ),
        headlineMedium: AppTextStyles.headingMedium.copyWith(
          color: AppColors.textDark,
        ),
        headlineSmall: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textDark,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textDark,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDark,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textMuted,
        ),
        labelLarge: AppTextStyles.buttonLarge.copyWith(
          color: AppColors.textDark,
        ),
        labelMedium: AppTextStyles.buttonMedium.copyWith(
          color: AppColors.textDark,
        ),
        labelSmall: AppTextStyles.buttonSmall.copyWith(
          color: AppColors.textMuted,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.espressoDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          textStyle: AppTextStyles.buttonMedium,
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.espressoDark,
          side: const BorderSide(
            color: AppColors.espressoDark,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.espressoDark,
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSecondaryBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.softSand,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.softSand,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.espressoDark,
            width: 2,
          ),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textMuted,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDark,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.espressoDark,
        size: 24,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightCardBg,
        selectedItemColor: AppColors.espressoDark,
        unselectedItemColor: AppColors.textMuted,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightCardBg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.bottomSheetRadius,
        ),
        elevation: 16,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightCardBg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.largeRadius,
        ),
      ),
    );
  }
}
