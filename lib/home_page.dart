import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/camera/camera_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_login_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_register_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/firebase_firestore/firestore_page.dart';
import 'package:flutter_sandbox/firebase_functions/firebase_functions_page.dart';
import 'package:flutter_sandbox/gps/gps_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
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

  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    final PageController _pageController = _pageNavigator.pageController;
    void _onBottomNavItemTapped(int index) {
      setState(() {
        _pageNavigator.setCurrentPageIndex = index;
        _pageController.jumpToPage(_pageNavigator.getCurrentPageIndex);
      });
    }

    void _onPageChanged(int pageIndex) {
      setState(() {
        _pageNavigator.setCurrentPageIndex = pageIndex;

        switch (pageIndex) {
          case 0:
            _title = 'Firebase Crashlytics';
            break;
          case 1:
            _title = 'Mapbox Map';
            break;
          case 2:
            _title = 'Camera';
            break;
          case 3:
            _title = 'Basic Widgets';
            break;
          case 4:
            _title = 'GPS';
            break;
          case 5:
            _title = 'Firestore';
            break;
          case 6:
            _title = 'Cloud Functions';
            break;
          case 7:
            _title = 'Login';
            break;
          case 8:
            _title = 'Register';
            break;
          default:
            _title = 'Sandbox';
            break;
        }
      });
    }

    List<Widget> _screens = [
      FirebaseCrashlyticsPage(),
      MapboxMapPage(),
      CameraPage(cameras: widget.cameraList),
      BasicWidgetsPage(),
      GPSPage(),
      FirestorePage(),
      FirebaseFunctionsPage(),
      // always add new screen above this comment so that auth remains the last two items.
      FirebaseAuthLoginPage(),
      FirebaseAuthRegistrationPage(),
    ];

    BottomNavigationBar _bottomNavBar = BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.error),
          label: 'Crashlytics',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapbox',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Camera',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets_rounded),
          label: 'Basic Widgets',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gps_fixed),
          label: 'GPS',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note_add),
          label: 'Firestore',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.extension_rounded),
          label: 'Extra',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.security_rounded),
          label: 'Auth',
          backgroundColor: Colors.pink,
        ),
      ],
      currentIndex: (_pageNavigator.getCurrentPageIndex < _screens.length - 1)
          ? _pageNavigator.getCurrentPageIndex
          : _screens.length - 2,
      selectedItemColor: Colors.black,
      onTap: _onBottomNavItemTapped,
    );

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
      bottomNavigationBar: _bottomNavBar,
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
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    final PageController _pageController = _pageNavigator.getPageController;
    Auth authProvider = Provider.of<Auth>(context);
    final _auth = FirebaseAuth.instance;

    List<Widget> listViewItems = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Demos'),
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 0,
        title: Text('Firebase Crashlytics'),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 0) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('FirebaseCrashlytics'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 1,
        title: Text('Mapbox Map'),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 1) {
            _pageController.jumpToPage(_pageNavigator.getPageIndex('Mapbox'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 2,
        title: Text('Camera'),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 2) {
            _pageController.jumpToPage(_pageNavigator.getPageIndex('Camera'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 3,
        title: Text('Basic Widgets'),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 3) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('BasicWidgets'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 4,
        title: Text('GPS'),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 4) {
            _pageController.jumpToPage(_pageNavigator.getPageIndex('GPS'));
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _pageNavigator.getCurrentPageIndex == 5,
        title: Text('Firestore'),
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
        title: Text('Cloud Functions'),
        onTap: () {
          if (_pageNavigator.getCurrentPageIndex != 6) {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('Cloud Functions'));
          }
          Navigator.pop(context);
        },
      ),
      Divider(
        thickness: 2,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Accounts'),
      ),
    ];

    if (authProvider.getUserLoginStatus) {
      listViewItems.insert(
        0,
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.orangeAccent),
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
          title: Text('Log out'),
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
          decoration: BoxDecoration(color: Colors.grey),
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
          title: Text('Log in'),
          onTap: () {
            _pageController
                .jumpToPage(_pageNavigator.getPageIndex('FirebaseAuthLogin'));
            Navigator.pop(context);
          },
        ),
      );
      listViewItems.add(
        ListTile(
          title: Text('Register'),
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
