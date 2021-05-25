import 'package:flutter/material.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Page Navigator Custom', () {
    test('Initial state', () {
      final _pageController = PageController(initialPage: 0);
      final PageNavigatorCustom _pageNavigator =
          PageNavigatorCustom(0, 0, _pageController);
      expect(_pageNavigator.getCurrentPageIndex, 0);
    });

    test('Current screen should change', () {
      final _pageController = PageController(initialPage: 0);
      final PageNavigatorCustom _pageNavigator =
          PageNavigatorCustom(0, 0, _pageController);
      _pageNavigator.setCurrentPageIndex = 2;
      expect(_pageNavigator.getCurrentPageIndex, 2);
    });

    test('Get page index by providing name', () {
      final _pageController = PageController(initialPage: 0);
      final PageNavigatorCustom _pageNavigator =
          PageNavigatorCustom(0, 0, _pageController);
      int rivePageIndex = _pageNavigator.getPageIndex('Rive');
      expect(rivePageIndex, 9);
    });
  });
}
