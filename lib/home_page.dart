import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/app_settings.dart';
import 'package:flutter_sandbox/basic_effects/basic_effects_page.dart';
import 'package:flutter_sandbox/camera/camera_page.dart';
import 'package:flutter_sandbox/dark_mode/dark_mode_screen.dart';
import 'package:flutter_sandbox/draggable/draggable_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_login_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_register_page.dart';
import 'package:flutter_sandbox/firebase_cloud_messaging/firebase_cloud_messaging_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/firebase_firestore/firestore_page.dart';
import 'package:flutter_sandbox/firebase_functions/firebase_functions_page.dart';
import 'package:flutter_sandbox/firebase_storage/firebase_storage_page.dart';
import 'package:flutter_sandbox/google_maps/google_maps_page.dart';
import 'package:flutter_sandbox/gps/gps_page.dart';
import 'package:flutter_sandbox/languages/language_title.dart';
import 'package:flutter_sandbox/languages/languages_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:flutter_sandbox/rive/rive_page.dart';
import 'package:flutter_sandbox/sandbox_license/sandbox_license_page.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'basic_widget/basic_widget_page.dart';

class HomePage extends StatefulWidget {
  static const id = 'home';
  final List<CameraDescription> cameraList;

  HomePage({
    Key key,
    @required this.cameraList,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _title = 'Firebase Crashlytics';
  int currentPageIndex;

  String licenseMIT = 'MIT License\n\n' +
      'Copyright (c) 2020 Rive\n\n' +
      'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n' +
      'The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n' +
      'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.';

  String licenseCCBy4 =
      "CC BY 4.0\n\nmernaz zare on LottieFiles: https://lottiefiles.com/60190-loader-89";

  Stream<LicenseEntry> licenses() async* {
    yield FlutterLicense(['rocket_reload_run7.riv, truck_run7.riv'],
        [LicenseParagraph(licenseMIT, 0)]);

    yield FlutterLicense(['loader-89'], [LicenseParagraph(licenseCCBy4, 0)]);
  }

  void addLicenses() {
    LicenseRegistry.addLicense(licenses);
  }

  @override
  void initState() {
    addLicenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    final PageController _pageController = _pageNavigator.pageController;
    currentPageIndex = _pageNavigator.getCurrentPageIndex;
    final LanguageTitle _languageTitle = Provider.of<LanguageTitle>(context);

    void _onPageChanged(int pageIndex) {
      setState(() {
        currentPageIndex = pageIndex;
        _pageNavigator.setCurrentPageIndex = pageIndex;

        switch (pageIndex) {
          case 0:
            _title = AppLocalizations.of(context).firebaseCrashlyticsTitle;
            break;
          case 1:
            _title = AppLocalizations.of(context).mapboxMapTitle;
            break;
          case 2:
            _title = AppLocalizations.of(context).cameraTitle;
            break;
          case 3:
            _title = AppLocalizations.of(context).basicWidgetsTitle;
            break;
          case 4:
            _title = AppLocalizations.of(context).gpsTitle;
            break;
          case 5:
            _title = AppLocalizations.of(context).firestoreTitle;
            break;
          case 6:
            _title = AppLocalizations.of(context).cloudFunctionsTitle;
            break;
          case 7:
            _title = AppLocalizations.of(context).googleMapsTitle;
            break;
          case 8:
            _title = AppLocalizations.of(context).basicEffectsTitle;
            break;
          case 9:
            _title = AppLocalizations.of(context).riveTitle;
            break;
          case 10:
            _title = AppLocalizations.of(context).thankYouTitle;
            break;
          case 11:
            _title = AppLocalizations.of(context).languagesTitle;
            break;
          case 12:
            _title = AppLocalizations.of(context).fcmTitle;
            break;
          case 13:
            _title = AppLocalizations.of(context).cloudStorageTitle;
            break;
          case 14:
            _title = AppLocalizations.of(context).darkModeTitle;
            break;
          case 15:
            _title = AppLocalizations.of(context).draggableTitle;
            break;
          case 16:
            _title = AppLocalizations.of(context).loginTitle;
            break;
          case 17:
            _title = AppLocalizations.of(context).registerTitle;
            break;
          default:
            _title = AppLocalizations.of(context).sandboxTitle;
            break;
        }
      });
    }

    if (_languageTitle.getLanguageTitle != null) {
      // updates the language page title when app language is toggled
      _onPageChanged(currentPageIndex);
    }

    List<Widget> _screens = [
      FirebaseCrashlyticsPage(),
      MapboxMapPage(),
      CameraPage(cameras: widget.cameraList),
      BasicWidgetsPage(),
      GPSPage(),
      FirestorePage(),
      FirebaseFunctionsPage(),
      GoogleMapsPage(),
      BasicEffectsPage(),
      RivePage(),
      SandboxLicensePage(),
      LanguagesPage(),
      FcmPage(),
      FirebaseStoragePage(),
      DarkModeScreen(),
      DraggablePage(),
      // always add new screen above this comment so that auth remains the last two items.
      FirebaseAuthLoginPage(),
      FirebaseAuthRegistrationPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _screens,
        onPageChanged: _onPageChanged,
      ),
      drawer: DrawerView(),
      bottomNavigationBar: BottomNavBarView(currentPageIndex),
    );
  }
}

class BottomNavBarView extends StatelessWidget {
  BottomNavBarView(this.currentPageIndex);
  final int currentPageIndex;
  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    final PageController _pageController = _pageNavigator.getPageController;

    void _onBottomNavItemTapped(int index) {
      _pageNavigator.setCurrentPageIndex = index;
      _pageController.jumpToPage(_pageNavigator.getCurrentPageIndex);
      if (index == 4) {
        Scaffold.of(context).openDrawer();
      }
    }

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.error),
          label: AppLocalizations.of(context).bottomNavCrashlyticsTitle,
          backgroundColor: Theme.of(context).accentColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: AppLocalizations.of(context).bottomNavMapboxTitle,
          backgroundColor: Theme.of(context).accentColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: AppLocalizations.of(context).cameraTitle,
          backgroundColor: Theme.of(context).accentColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets_rounded),
          label: AppLocalizations.of(context).basicWidgetsTitle,
          backgroundColor: Theme.of(context).accentColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.extension_rounded),
          label: AppLocalizations.of(context).bottomNavExtraTitle,
          backgroundColor: Theme.of(context).accentColor,
        ),
      ],
      currentIndex: (currentPageIndex < 4) ? currentPageIndex : 4,
      selectedItemColor: Colors.black,
      onTap: _onBottomNavItemTapped,
    );
  }
}

class DrawerView extends StatelessWidget {
  const DrawerView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return StreamBuilder(
        stream: auth.onAuthStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return DrawerWindow();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class DrawerWindow extends StatelessWidget {
  const DrawerWindow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppSettings appSettings = Provider.of<AppSettings>(context);
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    final PageController _pageController = _pageNavigator.getPageController;
    Auth authProvider = Provider.of<Auth>(context);
    final _auth = FirebaseAuth.instance;

    List<Widget> listViewItems = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(AppLocalizations.of(context).demosTitle),
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 0,
        title: Text(AppLocalizations.of(context).firebaseCrashlyticsTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 0) {
            _pageController.jumpToPage(
                _pageNavigator.getPageIndex('Firebase Crashlytics'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 1,
        title: Text(AppLocalizations.of(context).mapboxMapTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 1) {
            _pageController.jumpToPage(_pageNavigator.getPageIndex('Mapbox'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 2,
        title: Text(AppLocalizations.of(context).cameraTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 2) {
            _pageController.jumpToPage(_pageNavigator.getPageIndex('Camera'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 3,
        title: Text(AppLocalizations.of(context).basicWidgetsTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 3) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Basic Widgets'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 4,
        title: Text(AppLocalizations.of(context).gpsTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 4) {
            _pageController.jumpToPage(_pageNavigator.getPageIndex('GPS'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 5,
        title: Text(AppLocalizations.of(context).firestoreTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 5) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Firestore'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 6,
        title: Text(AppLocalizations.of(context).cloudFunctionsTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 6) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Cloud Functions'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 7,
        title: Text(AppLocalizations.of(context).googleMapsTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 7) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Google Maps'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 8,
        title: Text(AppLocalizations.of(context).basicEffectsTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 8) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Basic Effects'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 9,
        title: Text(AppLocalizations.of(context).riveTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 9) {
            _pageController.jumpToPage(_pageNavigator.getPageIndex('Rive'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 10,
        title: Text(AppLocalizations.of(context).licenseTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 10) {
            _pageController.jumpToPage(_pageNavigator.getPageIndex('License'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 11,
        title: Text(AppLocalizations.of(context).languagesTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 11) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Languages'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 12,
        title: Text(AppLocalizations.of(context).fcmTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 12) {
            _pageController.jumpToPage(_pageNavigator.getPageIndex('FCM'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 13,
        title: Text(AppLocalizations.of(context).cloudStorageTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 13) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Cloud Storage'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 14,
        title: Text(AppLocalizations.of(context).darkModeTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 14) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Dark Mode'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 15,
        title: Text(AppLocalizations.of(context).draggableTitle),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 15) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Draggable'));
          }
          Navigator.pop(context);
        },
      ),
      Divider(
        thickness: 2,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(AppLocalizations.of(context).accountTitle),
      ),
    ];

    if (authProvider.getUserLoginStatus) {
      listViewItems.insert(
        0,
        DrawerHeader(
          decoration: BoxDecoration(
            color: (appSettings.getCurrentThemeMode == ThemeMode.light)
                ? Colors.redAccent.shade400
                : Colors.redAccent.shade700,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 60,
                ),
                radius: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_auth.currentUser.email),
              ),
            ],
          ),
        ),
      );

      listViewItems.add(
        ListTile(
          title: Text(AppLocalizations.of(context).logOut),
          onTap: () {
            _auth.signOut();
            authProvider.setUserLoginStatus = false;
            Navigator.pop(context);
          },
        ),
      );
    } else {
      listViewItems.insert(
        0,
        DrawerHeader(
          decoration: BoxDecoration(
            color: (appSettings.getCurrentThemeMode == ThemeMode.light)
                ? Colors.grey.shade400
                : Colors.grey.shade700,
          ),
          child: Column(
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 60,
                ),
                radius: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text('Flutter Sandbox'),
            ],
          ),
        ),
      );

      listViewItems.add(
        ListTile(
          title: Text(AppLocalizations.of(context).firebaseAuthLogIn),
          onTap: () {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('FirebaseAuthLogin'));
            Navigator.pop(context);
          },
        ),
      );
      listViewItems.add(
        ListTile(
          title: Text(AppLocalizations.of(context).firebaseAuthRegister),
          onTap: () {
            _pageController.jumpToPage(
                _pageNavigator.getPageIndex('FirebaseAuthRegister'));
            Navigator.pop(context);
          },
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: listViewItems,
      ),
    );
  }
}

class FlutterLicense extends LicenseEntry {
  FlutterLicense(this.packages, this.paragraphs);
  final packages;
  final paragraphs;
}
