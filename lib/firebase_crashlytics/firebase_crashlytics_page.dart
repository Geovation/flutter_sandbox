import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class FirebaseCrashlyticsPage extends StatelessWidget {
  static const id = 'firebase_crashlytics_page';

  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Firebase Crashlytics');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    MediaQueryData deviceData = MediaQuery.of(context);

    FirebaseCrashlytics fci = FirebaseCrashlytics.instance;
    String message =
        'Press the button to simulate a crash. Restart the app for crashlytics to log the crash';

    Function onPressCrash = () async {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await fci.setCrashlyticsCollectionEnabled(true);
      if (fci.isCrashlyticsCollectionEnabled) {
        if (_auth.currentUser != null) {
          FirebaseCrashlytics.instance.setUserIdentifier(_auth.currentUser.uid);
        } else {
          FirebaseCrashlytics.instance.setUserIdentifier("");
        }
        FirebaseCrashlytics.instance.crash();
      }
    };

    if (kIsWeb) {
      message = 'Firebase Crashlytics does not support web apps.';
      onPressCrash = null;
    }

    Widget landscapeViewWidget = Card(
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: deviceData.size.height * 0.5,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: onPressCrash,
                    icon: Icon(Icons.error_rounded),
                    label: Text('Press to crash'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget portraitViewWidget = Card(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: deviceData.size.height * 0.3,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: deviceData.size.width * 0.6,
                    child: ElevatedButton.icon(
                      onPressed: onPressCrash,
                      icon: Icon(Icons.error_rounded),
                      label: Text('Press to crash'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return deviceData.orientation == Orientation.portrait
        ? portraitViewWidget
        : landscapeViewWidget;
  }
}
