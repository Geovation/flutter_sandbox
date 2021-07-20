import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  AppSettings(this.currentThemeMode);

  ThemeMode currentThemeMode;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isFirstRun = true;

  Future<void> saveDarkModePref(bool isDarkModeOn) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("isDarkModeOn", isDarkModeOn);
    print(prefs.containsKey("isDarkModeOn"));
  }

  set setThemeMode(ThemeMode mode) {
    currentThemeMode = mode;
    notifyListeners();
  }

  get getCurrentThemeMode {
    if (isFirstRun) {
      isFirstRun = false;
      return currentThemeMode;
    } else {
      return currentThemeMode;
    }
  }
}
