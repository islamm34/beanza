import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

class DarkTheme {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCardBg,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headingLarge.copyWith(
          color: AppColors.textLight,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.caramel,
        secondary: AppColors.caramel,
        surface: AppColors.darkCardBg,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.textLight,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: AppColors.textLight,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: AppColors.textLight,
        ),
        headlineLarge: AppTextStyles.headingLarge.copyWith(
          color: AppColors.textLight,
        ),
        headlineMedium: AppTextStyles.headingMedium.copyWith(
          color: AppColors.textLight,
        ),
        headlineSmall: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textLight,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textLight,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textLightMuted,
        ),
        labelLarge: AppTextStyles.buttonLarge.copyWith(
          color: AppColors.textLight,
        ),
        labelMedium: AppTextStyles.buttonMedium.copyWith(
          color: AppColors.textLight,
        ),
        labelSmall: AppTextStyles.buttonSmall.copyWith(
          color: AppColors.textLightMuted,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.caramel,
          foregroundColor: AppColors.textDark,
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
          foregroundColor: AppColors.caramel,
          side: const BorderSide(
            color: AppColors.caramel,
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
          foregroundColor: AppColors.caramel,
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSecondaryBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.darkSecondaryBg,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.darkSecondaryBg,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.caramel,
            width: 2,
          ),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLightMuted,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.caramel,
        size: 24,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCardBg,
        selectedItemColor: AppColors.caramel,
        unselectedItemColor: AppColors.textLightMuted,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkCardBg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.bottomSheetRadius,
        ),
        elevation: 16,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkCardBg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.largeRadius,
        ),
      ),
    );
  }
}
