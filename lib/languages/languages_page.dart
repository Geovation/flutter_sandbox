import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/currentLocale.dart';
import 'package:flutter_sandbox/languages/language_title.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({Key key}) : super(key: key);

  @override
  _LanguagesPageState createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  String _selectedLocale;

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'languages_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Languages');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    final CurrentLocale _currentLocale = Provider.of<CurrentLocale>(context);
    final LanguageTitle _languageTitle = Provider.of<LanguageTitle>(context);
    Map availableLocalesSL = _currentLocale.getAvailableLocaleSL;
    Map reversedAvailableLocaleLS = _currentLocale.getReversedAvailableLocaleLS;
    _selectedLocale = _currentLocale.getCurrentLocale;

    return Container(
      child: Center(
        child: DropdownButton(
          value: _selectedLocale,
          style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.red)),
          underline: Container(
            height: 2,
            color: Colors.redAccent,
          ),
          onChanged: (newValue) {
            setState(() {
              _selectedLocale = newValue;
              _currentLocale.setCurrentLocale = newValue;
              _languageTitle.setLanguageTitle = newValue;
            });
          },
          items: [
            DropdownMenuItem(
              value: reversedAvailableLocaleLS[availableLocalesSL["en"]],
              child: Text(
                availableLocalesSL["en"],
                style: GoogleFonts.lato(),
              ),
            ),
            DropdownMenuItem(
              value: reversedAvailableLocaleLS[availableLocalesSL["it"]],
              child: Text(
                availableLocalesSL["it"],
                style: GoogleFonts.lato(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
