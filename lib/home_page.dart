import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/camera/camera_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_login_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_register_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/gps/gps_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';
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
  int _selectedIndex = 0;
  final _pageController = PageController(initialPage: 0);
  String _title = 'Firebase Crashlytics';

  void _onPageChanged(int pageIndex) {
    setState(() {
      _selectedIndex = pageIndex;
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
          _title = 'Login';
          break;
        case 6:
          _title = 'Register';
          break;
        default:
          _title = 'Sandbox';
          break;
      }
    });
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      FirebaseCrashlyticsPage(),
      MapboxMapPage(),
      CameraPage(cameras: widget.cameraList),
      BasicWidgetsPage(),
      GPSPage(),
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
          icon: Icon(Icons.security_rounded),
          label: 'Auth',
          backgroundColor: Colors.pink,
        ),
      ],
      currentIndex: (_selectedIndex < _screens.length - 1)
          ? _selectedIndex
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
      drawer: DrawerView(
          pageControllerRef: _pageController,
          selectedIndex: _selectedIndex,
          screensLength: _screens.length),
      bottomNavigationBar: _bottomNavBar,
    );
  }
}

bool isLoggedIn = false;

class DrawerView extends StatelessWidget {
  const DrawerView({
    Key key,
    @required PageController pageControllerRef,
    @required int selectedIndex,
    @required int screensLength,
  })  : _refPageController = pageControllerRef,
        _selectedIndex = selectedIndex,
        _screensLength = screensLength,
        super(key: key);

  final PageController _refPageController;
  final int _selectedIndex;
  final int _screensLength;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Auth(),
        child: DrawerUpdate(
            pageControllerRef: _refPageController,
            selectedIndex: _selectedIndex,
            screensLength: _screensLength));
  }
}

class DrawerUpdate extends StatelessWidget {
  const DrawerUpdate({
    Key key,
    @required PageController pageControllerRef,
    @required int selectedIndex,
    @required int screensLength,
  })  : _refPageController = pageControllerRef,
        _selectedIndex = selectedIndex,
        _screensLength = screensLength,
        super(key: key);

  final PageController _refPageController;
  final int _selectedIndex;
  final int _screensLength;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return StreamBuilder(
        stream: auth.onAuthStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;

            isLoggedIn = (user == null) ? false : true;
            return DrawerWindow(
                pageControllerRef: _refPageController,
                selectedIndex: _selectedIndex,
                screensLength: _screensLength);
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
    @required PageController pageControllerRef,
    @required int selectedIndex,
    @required int screensLength,
  })  : _refPageController = pageControllerRef,
        _selectedIndex = selectedIndex,
        _screensLength = screensLength,
        super(key: key);

  final PageController _refPageController;
  final int _selectedIndex;
  final int _screensLength;

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    List<Widget> listViewItems = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Demos'),
      ),
      ListTile(
        selected: _selectedIndex == 0,
        title: Text('Firebase Crashlytics'),
        onTap: () {
          if (_selectedIndex != 0) {
            _refPageController.jumpToPage(0);
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _selectedIndex == 1,
        title: Text('Mapbox Map'),
        onTap: () {
          if (_selectedIndex != 1) {
            _refPageController.jumpToPage(1);
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _selectedIndex == 2,
        title: Text('Camera'),
        onTap: () {
          if (_selectedIndex != 2) {
            _refPageController.jumpToPage(2);
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _selectedIndex == 3,
        title: Text('Basic Widgets'),
        onTap: () {
          if (_selectedIndex != 3) {
            _refPageController.jumpToPage(3);
          }
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: _selectedIndex == 4,
        title: Text('GPS'),
        onTap: () {
          if (_selectedIndex != 4) {
            _refPageController.jumpToPage(4);
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

    if (isLoggedIn) {
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
            _refPageController.jumpToPage(_screensLength - 2);
            Navigator.pop(context);
          },
        ),
      );
      listViewItems.add(
        ListTile(
          title: Text('Register'),
          onTap: () {
            _refPageController.jumpToPage(_screensLength - 1);
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
