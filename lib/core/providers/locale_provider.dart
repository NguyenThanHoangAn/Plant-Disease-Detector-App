import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'app_locale';
  
  LocaleNotifier() : super(const Locale('vi')) {
    _loadLocale();
  }

  /// Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);
      
      if (languageCode != null) {
        state = Locale(languageCode);
      }
    } catch (e) {
      print('Error loading locale: $e');
    }
  }

  /// Change app locale and save to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
      state = locale;
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

  /// Toggle between Vietnamese and English
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'vi' 
        ? const Locale('en') 
        : const Locale('vi');
    await setLocale(newLocale);
  }
}
