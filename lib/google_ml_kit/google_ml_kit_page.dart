import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/google_ml_kit/barcode_scanner_view.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    _tabController = TabController(vsync: this, length: 1);
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
    }
    return indexedWidget;
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
    ];

    return (kIsWeb)
        ? Center(
            child: Text(
              "ML Kit not yet supported on this platform.",
              style: GoogleFonts.lato(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 55,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.grey.shade50,
                isScrollable: true,
                tabs: googleMLKitTabs,
                labelStyle: GoogleFonts.lato(),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                onSelectedWindow(0, localizations),
              ],
            ),
          );
  }
}
