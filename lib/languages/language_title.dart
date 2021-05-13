import 'package:flutter/cupertino.dart';

class LanguageTitle extends ChangeNotifier {
  String languageTitle = "Language";

  get getLanguageTitle {
    return languageTitle;
  }

  set setLanguageTitle(String lang) {
    languageTitle = lang;
    notifyListeners();
  }
}
