import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class FcmPage extends StatefulWidget {
  const FcmPage({Key key}) : super(key: key);
  static const id = 'fcm_page';

  @override
  _FcmPageState createState() => _FcmPageState();
}

class _FcmPageState extends State<FcmPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings;
  String _token = "";

  Future<void> requestPermissions() async {
    settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> getToken() async {
    String token;
    if (kIsWeb) {
      token = await messaging.getToken(
        vapidKey:
            'BJb4oODa08l2HMt49p_WQkO50sDSZfVcaLBgvyS3mivJO74guGHYR1Uww_mlwbF6T1tU4M5Ba5XjSiZUZM2RZzc',
      );
    } else {
      token = await messaging.getToken();
    }
    print(token);
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'fcm_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex = _pageNavigator.getPageIndex('FCM');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  _token,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )),
        ),
        Semantics(
          button: true,
          label: localizations.fcmGetToken,
          child: ElevatedButton(
            onPressed: () async {
              await getToken();
            },
            child: Text('${localizations.fcmGetToken}'),
          ),
        ),
      ],
    );
  }
}
