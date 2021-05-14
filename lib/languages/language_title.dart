import 'package:flutter/cupertino.dart';

class LanguageTitle extends ChangeNotifier {
  String languageTitle;

  get getLanguageTitle {
    return languageTitle;
  }

  set setLanguageTitle(String lang) {
    languageTitle = lang;
    notifyListeners();
  }
}
