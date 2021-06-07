import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class FirebaseCrashlyticsPage extends StatelessWidget {
  static const id = 'firebase_crashlytics_page';

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'crashlytics_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Firebase Crashlytics');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    MediaQueryData deviceData = MediaQuery.of(context);
    final AppLocalizations localizations = AppLocalizations.of(context);

    FirebaseCrashlytics fci = FirebaseCrashlytics.instance;
    String message = AppLocalizations.of(context).firebaseCrashlyticsMessage;

    Function onPressCrash = () async {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await fci.setCrashlyticsCollectionEnabled(true);
      if (fci.isCrashlyticsCollectionEnabled) {
        if (_auth.currentUser != null) {
          FirebaseCrashlytics.instance.setUserIdentifier(_auth.currentUser.uid);
        } else {
          FirebaseCrashlytics.instance.setUserIdentifier('');
          analytics.logEvent(
            name: 'crashlytics_page',
            parameters: {
              'isCrashPressed': true,
            },
          );
        }
        FirebaseCrashlytics.instance.crash();
      }
    };

    if (kIsWeb) {
      message = localizations.firebaseCrashlyticsWebMessage;
      onPressCrash = null;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            width: deviceData.orientation == Orientation.portrait
                ? deviceData.size.width * 0.9
                : deviceData.size.width * 0.7,
            height: deviceData.size.height * 0.3,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton.icon(
            onPressed: onPressCrash,
            icon: Icon(Icons.error_rounded),
            label: Text(localizations.firebaseCrashlyticsButton),
          ),
        ),
      ],
    );
  }
}
