import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme.dart';
import '../../../core/constants.dart';

/// Provider for managing app settings (theme mode and accent color)
class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = AppTheme.accentColors.first;
  
  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  
  /// Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme mode
    final themeIndex = prefs.getInt(AppConstants.themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    
    // Load accent color
    final colorIndex = prefs.getInt(AppConstants.accentColorKey) ?? 0;
    if (colorIndex < AppTheme.accentColors.length) {
      _accentColor = AppTheme.accentColors[colorIndex];
    }
    
    notifyListeners();
  }
  
  /// Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.themeKey, _themeMode.index);
    await prefs.setInt(AppConstants.accentColorKey, 
        AppTheme.accentColors.indexOf(_accentColor));
  }
  
  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    _saveSettings();
  }
  
  /// Set accent color
  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
    _saveSettings();
  }
  
  /// Toggle between light and dark theme
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    notifyListeners();
    _saveSettings();
  }
}