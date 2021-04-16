import 'package:flutter/material.dart';

class PageNavigatorCustom extends ChangeNotifier {
  PageNavigatorCustom(this.fromIndex, this.currentIndex, this.pageController);
  int currentIndex;
  PageController pageController;
  Map<String, int> pageIndices = {
    "FirebaseCrashlytics": 0,
    "Mapbox": 1,
    "Camera": 2,
    "BasicWidgets": 3,
    "GPS": 4,
    "Firestore": 5,
    "Cloud Functions": 6,
    "Google Maps": 7,
    "FirebaseAuthLogin": 8,
    "FirebaseAuthRegister": 9,
  };
  int fromIndex;

  get getFromIndex {
    return fromIndex;
  }

  get getCurrentPageIndex {
    return currentIndex;
  }

  get getPageController {
    return pageController;
  }

  set setFromIndex(int index) {
    fromIndex = index;
  }

  set setCurrentPageIndex(int index) {
    currentIndex = index;
  }

  int getPageIndex(String pageName) {
    return pageIndices[pageName];
  }
}
