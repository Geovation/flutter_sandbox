import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class SandboxLicensePage extends StatelessWidget {
  static const id = 'sandbox_license_page';
  const SandboxLicensePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'sandbox_license_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex = _pageNavigator.getPageIndex('License');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    return LicensePage(
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Image(image: AssetImage('assets/logo/geovation_logo.png'))),
      ),
      applicationVersion: '0.0.1',
    );
  }
}
