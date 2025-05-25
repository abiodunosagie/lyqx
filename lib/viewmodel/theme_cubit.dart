import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  // Load saved theme from shared preferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      switch (savedTheme) {
        case 'light':
          emit(ThemeMode.light);
          break;
        case 'dark':
          emit(ThemeMode.dark);
          break;
        case 'system':
        default:
          emit(ThemeMode.system);
          break;
      }
    } catch (e) {
      // If loading fails, default to system theme
      emit(ThemeMode.system);
    }
  }

  // Save theme to shared preferences
  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String themeString;

      switch (themeMode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }

      await prefs.setString(_themeKey, themeString);
    } catch (e) {
      // Handle save error silently
      debugPrint('Failed to save theme: $e');
    }
  }

  // Set light theme
  Future<void> setLightTheme() async {
    emit(ThemeMode.light);
    await _saveTheme(ThemeMode.light);
  }

  // Set dark theme
  Future<void> setDarkTheme() async {
    emit(ThemeMode.dark);
    await _saveTheme(ThemeMode.dark);
  }

  // Set system theme (follows device settings)
  Future<void> setSystemTheme() async {
    emit(ThemeMode.system);
    await _saveTheme(ThemeMode.system);
  }

  // Toggle between light and dark (ignores system)
  Future<void> toggleTheme() async {
    switch (state) {
      case ThemeMode.light:
        await setDarkTheme();
        break;
      case ThemeMode.dark:
      case ThemeMode.system:
        await setLightTheme();
        break;
    }
  }

  // Get current theme as string for display
  String get currentThemeString {
    switch (state) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  // Check if current theme is dark (considering system theme)
  bool isDarkMode(BuildContext context) {
    switch (state) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }
}
