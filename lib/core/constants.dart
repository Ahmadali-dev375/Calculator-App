/// App-wide constants for consistent styling and sizing
class AppConstants {
  // Button dimensions
  static const double buttonHeight = 70.0;
  static const double buttonWidth = 70.0;
  static const double buttonBorderRadius = 20.0;

  // Spacing and padding
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Display dimensions
  static const double displayHeight = 120.0;
  static const double displayPadding = 20.0;

  // Grid layout
  static const int buttonGridColumns = 4;
  static const double buttonSpacing = 12.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);

  // Text sizes
  static const double displayTextSize = 48.0;
  static const double buttonTextSize = 24.0;
  static const double titleTextSize = 20.0;

  // History settings
  static const int maxHistoryItems = 1000;

  // SharedPreferences keys
  static const String themeKey = 'theme_mode';
  static const String accentColorKey = 'accent_color';
  static const String historyKey = 'calculation_history';
}
