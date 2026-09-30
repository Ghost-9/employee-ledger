import 'package:flutter/material.dart';

class AppColors {
  // Primary modern palette
  static const Color primary = Color(0xFF1D4ED8); // Refined Royal Blue
  static const Color primaryLight = Color(0xFFEFF6FF); // Soft blue tint
  static const Color primaryDark = Color(0xFF0F172A); // Slate 900
  static const Color accent = Color(0xFF3B82F6); // Blue 500

  // Status colors
  static const Color pending = Color(0xFFEAB308);
  static const Color completed = Color(0xFF10B981); // Emerald
  static const Color progress = Color(0xFFF97316); // Amber
  static const Color darkGrey = Color(0xFF334155); // Slate 700
  static const Color lightGrey = Color(0xFF94A3B8); // Slate 400

  // UI element colors
  static const Color scaffoldBackground = Colors.white;
  static const Color homeScaffold = Color(0xFFF8FAFC); // Slate 50
  static const Color cardBackground = Colors.white;
  static const Color sidebarBackground = Colors.white;
  static const Color sidebarText = Colors.white;
  static const Color blueLight3 = Color(0xFFEFF6FF);
  static const Color buttonPrimary = Color(0xFF1D4ED8);
  static const Color buttonSecondary = Color(0xFF64748B);
  static const Color buttonSuccess = Color(0xFF10B981);
  static const Color buttonDanger = Color(0xFFEF4444);
  static const Color textFormField = Color(0xFFE2E8F0);

  static const Color color8 = Color(0xFF1E293B);
  static const Color color1 = Color(0xFF1D4ED8);
}

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: AppColors.primaryDark,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 22,
    color: AppColors.primaryDark,
    letterSpacing: -0.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.color8,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.darkGrey,
  );
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.homeScaffold,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        surface: AppColors.homeScaffold,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
        titleTextStyle: TextStyle(
          color: AppColors.primaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryDark),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTextStyles.displayMedium,
        contentTextStyle: AppTextStyles.bodyLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textFormField),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textFormField),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.lightGrey,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }
}
