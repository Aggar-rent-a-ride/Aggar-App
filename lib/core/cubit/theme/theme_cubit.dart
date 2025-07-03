import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/core/cache/cache_helper.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial()) {
    _loadTheme();
  }

  static ThemeCubit of(BuildContext context) {
    return BlocProvider.of<ThemeCubit>(context);
  }

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // Load theme from cache
  void _loadTheme() {
    try {
      final savedTheme = CacheHelper().getData(key: 'theme_mode');
      print('Loaded theme from cache: $savedTheme'); // Debug print

      if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else {
        // If no saved theme, default to light
        _themeMode = ThemeMode.light;
        _saveTheme(); // Save default theme
      }

      emit(ThemeChangedState());
    } catch (e) {
      print('Error loading theme: $e');
      _themeMode = ThemeMode.light;
      _saveTheme(); // Save default theme
      emit(ThemeChangedState());
    }
  }

  // Save theme to cache
  void _saveTheme() {
    try {
      final themeString = _themeMode == ThemeMode.dark ? 'dark' : 'light';
      CacheHelper().saveData(key: 'theme_mode', value: themeString);
      print('Saved theme to cache: $themeString'); // Debug print
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(); // Save the new theme
    emit(ThemeChangedState());
  }

  // Method to manually set theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveTheme();
    emit(ThemeChangedState());
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
}
