import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/app_settings.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class DarkModeScreen extends StatefulWidget {
  static const id = 'dark_mode_screen';
  const DarkModeScreen({Key key}) : super(key: key);

  @override
  _DarkModeScreenState createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  bool isDarkModeOn = false;

  @override
  Widget build(BuildContext context) {
    final AppSettings appSettings = Provider.of<AppSettings>(context);
    Size deviceSizeData = MediaQuery.of(context).size;
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'dark_mode_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Dark Mode');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    isDarkModeOn = (appSettings.getCurrentThemeMode == ThemeMode.dark);
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Center(
      child: Container(
        width: deviceSizeData.width * 0.7,
        height: deviceSizeData.height * 0.3,
        decoration: BoxDecoration(
          color: isDarkModeOn
              ? Colors.orangeAccent.shade100
              : Colors.orangeAccent.shade700,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Semantics(
            label: localizations.semDarkModePgSwitch,
            value: isDarkModeOn
                ? localizations.semDarkModePgDarkModeOn
                : localizations.semDarkModePgDarkModeOff,
            child: Switch(
                value: isDarkModeOn,
                activeColor: Colors.orangeAccent.shade700,
                onChanged: (bool newValue) {
                  setState(() {
                    isDarkModeOn = newValue;
                  });
                  appSettings.saveDarkModePref(isDarkModeOn);
                  if (isDarkModeOn) {
                    appSettings.setThemeMode = ThemeMode.dark;
                  } else {
                    appSettings.setThemeMode = ThemeMode.light;
                  }
                }),
          ),
        ),
      ),
    );
  }
}
