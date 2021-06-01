import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  AppSettings();
  ThemeMode currentThemeMode = ThemeMode.light;

  set setThemeMode(ThemeMode mode) {
    currentThemeMode = mode;
    notifyListeners();
  }

  get getCurrentThemeMode {
    return currentThemeMode;
  }
}
