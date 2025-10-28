// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// App color schemes and themes
class AppTheme {
  // Define accent colors
  static const List<Color> accentColors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];

  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color darkSurface = Color(0xFF1E1E1E);

  /// Creates light theme with specified accent color
  static ThemeData lightTheme(Color accentColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.light,
      ),
      cardTheme: CardThemeData(
        // ✅ FIXED: use CardThemeData
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  /// Creates dark theme with specified accent color
  static ThemeData darkTheme(Color accentColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.dark,
      ),
      cardTheme: CardThemeData(
        // ✅ FIXED: use CardThemeData
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  /// Button style for calculator buttons
  static ButtonStyle calculatorButtonStyle(BuildContext context,
      {bool isOperator = false}) {
    final theme = Theme.of(context);
    return ElevatedButton.styleFrom(
      backgroundColor:
          isOperator ? theme.colorScheme.primary : theme.colorScheme.surface,
      foregroundColor: isOperator
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSurface,
      elevation: 4,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  /// Text style for display
  static TextStyle displayTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w300,
      color: theme.colorScheme.onSurface,
      fontFamily: 'monospace',
    );
  }

  /// Text style for buttons
  static TextStyle buttonTextStyle(BuildContext context,
      {bool isOperator = false}) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: isOperator
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSurface,
    );
  }
}
