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
        _pageNavigator.getPageIndex("FirebaseCrashlytics");
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

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

    return Card(
      child: Container(
        child: Column(
          children: [
            Container(
              color: Colors.red.shade100,
              height: 200,
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
            ElevatedButton.icon(
              onPressed: onPressCrash,
              icon: Icon(Icons.error_rounded),
              label: Text('Press to crash'),
            ),
          ],
        ),
      ),
    );
  }
}
