import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/google_ml_kit/face_detection_view.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'barcode_scanner_view.dart';

class GoogleMLKitPage extends StatefulWidget {
  static const id = "google_ml_kit_page";
  final List<CameraDescription> cameras;
  const GoogleMLKitPage({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  @override
  _GoogleMLKitPageState createState() => _GoogleMLKitPageState();
}

class _GoogleMLKitPageState extends State<GoogleMLKitPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget onSelectedWindow(int index, AppLocalizations localizations) {
    Widget indexedWidget;
    switch (index) {
      case 0:
        indexedWidget = BarcodeScannerView(
          cameras: widget.cameras,
        );
        break;
      case 1:
        indexedWidget = FaceDetectionView(
          cameras: widget.cameras,
        );
        break;
    }
    return indexedWidget;
  }

  Widget gradientButton(String text, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFFF6F00),
                      Color(0xFFFB8C00),
                      Color(0xFFFF7043),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: onPressed,
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'page_google_ml_kit');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Google ML Kit');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    final AppLocalizations localizations = AppLocalizations.of(context);

    final List<Tab> googleMLKitTabs = <Tab>[
      Tab(text: localizations.googMLKitBarcodeScanner),
      Tab(text: localizations.googleMLKitFaceDetector),
    ];

    return (kIsWeb)
        ? Center(
            child: Text(
              "ML Kit not yet supported on this platform.",
              style: GoogleFonts.lato(),
            ),
          )
        : Scaffold(
            body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                gradientButton("Barcode Scanner", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BarcodeScannerView(
                                cameras: widget.cameras,
                                title: localizations.googMLKitBarcodeScanner,
                              )));
                }),
                gradientButton("Face Detector", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FaceDetectionView(
                                cameras: widget.cameras,
                                title: localizations.googleMLKitFaceDetector,
                              )));
                }),
              ],
            ),
          ));
  }
}
