import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  AppSettings(this.currentThemeMode);

  ThemeMode currentThemeMode;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveDarkModePref(bool isDarkModeOn) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("isDarkModeOn", isDarkModeOn);
  }

  set setThemeMode(ThemeMode mode) {
    currentThemeMode = mode;
    notifyListeners();
  }

  get getCurrentThemeMode {
    return currentThemeMode;
  }
}
