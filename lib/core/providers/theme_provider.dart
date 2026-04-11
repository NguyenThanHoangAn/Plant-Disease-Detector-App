import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app theme (light/dark)
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  static const String _themeKey = 'app_theme_dark';
  
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  /// Load saved theme from SharedPreferences
  /// true = dark mode, false = light mode
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      state = isDark;
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  /// Change app theme and save to SharedPreferences
  Future<void> setTheme(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
      state = isDark;
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    await setTheme(!state);
  }
}
