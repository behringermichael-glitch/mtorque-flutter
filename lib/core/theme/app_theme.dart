import 'package:flutter/material.dart';

final class AppTheme {
  AppTheme._();

  static const Color tlDark = Color(0xFF2F3855);
  static const Color tlBackground = Color(0xFFF2EDE7);

  static const Color dashboardCyan = Color(0xFF00BCD4);
  static const Color strengthBlue = Color(0xFF3B82F6);
  static const Color enduranceRed = Color(0xFFEF4444);
  static const Color bothViolet = Color(0xFF8B5CF6);
  static const Color statsOrange = Color(0xFFFF9800);
  static const Color settingsGreen = Color(0xFF4CAF50);

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: tlDark,
      onPrimary: tlBackground,
      secondary: dashboardCyan,
      onSecondary: tlDark,
      error: Color(0xFFB3261E),
      onError: Colors.white,
      surface: tlBackground,
      onSurface: tlDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tlBackground,
      canvasColor: tlBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: tlBackground,
        foregroundColor: tlDark,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0x14000000),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dividerColor: const Color(0x1F2F3855),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: tlBackground,
      onPrimary: tlDark,
      secondary: dashboardCyan,
      onSecondary: tlDark,
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      surface: tlDark,
      onSurface: tlBackground,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tlDark,
      canvasColor: tlDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: tlDark,
        foregroundColor: tlBackground,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF3B4566),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF3B4566),
        indicatorColor: Color(0x22F2EDE7),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dividerColor: const Color(0x33F2EDE7),
    );
  }
}