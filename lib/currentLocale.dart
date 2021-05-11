import 'package:flutter/material.dart';

class CurrentLocale extends ChangeNotifier {
  CurrentLocale(this.currentLocale);
  String currentLocale;

  // availableLocalesShortLong key value paris
  Map<String, String> availableLocalesSL = {
    "en": "English",
    "it": "Italian",
  };

  get getAvailableLocaleSL {
    return availableLocalesSL;
  }

  get getReversedAvailableLocaleLS {
    // reversedAvailableLocalesLongShort key value pairs
    Map<String, String> reversedAvailableLocalesLS =
        availableLocalesSL.map((key, value) => MapEntry(value, key));
    return reversedAvailableLocalesLS;
  }

  get getCurrentLocale {
    return currentLocale;
  }

  set setCurrentLocale(String locale) {
    currentLocale = locale;
    notifyListeners();
  }
}
