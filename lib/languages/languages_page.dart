import 'package:flutter/material.dart';
import 'package:flutter_sandbox/currentLocale.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
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
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Languages');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    final CurrentLocale _currentLocale = Provider.of<CurrentLocale>(context);
    Map availableLocalesLS = _currentLocale.getAvailableLocaleSL;
    Map reversedAvailableLocaleSL = _currentLocale.getReversedAvailableLocaleLS;
    _selectedLocale = _currentLocale.getCurrentLocale;

    return Container(
      child: Center(
        child: DropdownButton(
          value: _selectedLocale,
          style: const TextStyle(color: Colors.red),
          underline: Container(
            height: 2,
            color: Colors.redAccent,
          ),
          onChanged: (newValue) {
            setState(() {
              _selectedLocale = newValue;
              _currentLocale.setCurrentLocale = newValue;
            });
          },
          items: [
            DropdownMenuItem(
              value: reversedAvailableLocaleSL[availableLocalesLS["en"]],
              child: Text(availableLocalesLS["en"]),
            ),
            DropdownMenuItem(
              value: reversedAvailableLocaleSL[availableLocalesLS["it"]],
              child: Text(availableLocalesLS["it"]),
            )
          ],
        ),
      ),
    );
  }
}
