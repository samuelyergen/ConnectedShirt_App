import 'package:flutter/material.dart';

/// Class that represents our Theme Service.
///
/// Class that can be used to work with the theme, it is mainly
/// used to toggle from Light to Dark mode.
class ThemeService with ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  bool _isDarkMode = false;

  ThemeService();

  ThemeMode get mode => _mode;

  bool get isDarkMode => _isDarkMode;

  /// Function to toggleThemeMode.
  ///
  /// Function that enables the user to switch between the ThemeMode.dark
  /// and the ThemeMode.light.
  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _isDarkMode = _mode == ThemeMode.light ? false : true;
    notifyListeners();
  }
}
