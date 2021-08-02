import 'package:flutter/material.dart';

class PageNavigatorCustom extends ChangeNotifier {
  PageNavigatorCustom(this.fromIndex, this.currentIndex, this.pageController);
  int currentIndex;
  PageController pageController;
  Map<String, int> pageIndices = {
    "Firebase Crashlytics": 0,
    "Mapbox": 1,
    "Camera": 2,
    "Basic Widgets": 3,
    "GPS": 4,
    "Firestore": 5,
    "Cloud Functions": 6,
    "Google Maps": 7,
    "Basic Effects": 8,
    "Rive": 9,
    "License": 10,
    "Languages": 11,
    "FCM": 12,
    "Cloud Storage": 13,
    "Dark Mode": 14,
    "Draggable": 15,
    "Database": 16,
    "Charts": 17,
    "Dialog": 18,
    "Rest API": 19,
    "FirebaseAuthLogin": 20,
    "FirebaseAuthRegister": 21,
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
