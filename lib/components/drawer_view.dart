import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/basic_widget/basic_widget_page.dart';
import 'package:flutter_sandbox/camera/camera_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_login_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_register_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/gps/gps_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';
import 'package:flutter_sandbox/screen_arguments.dart';
import 'package:provider/provider.dart';

bool isLoggedIn = false;

class DrawerView extends StatelessWidget {
  const DrawerView({
    Key key,
    @required int selectedIndex,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: DrawerUpdate(selectedIndex: _selectedIndex),
    );
  }
}

class DrawerUpdate extends StatelessWidget {
  const DrawerUpdate({
    Key key,
    @required int selectedIndex,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return StreamBuilder(
        stream: auth.onAuthStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              isLoggedIn = false;
              return DrawerWindow(selectedIndex: _selectedIndex);
            }
            isLoggedIn = true;
            return DrawerWindow(selectedIndex: _selectedIndex);
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
  static const id = 'drawer_window';
  const DrawerWindow({
    Key key,
    @required int selectedIndex,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final int _selectedIndex;

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
          Navigator.pop(context);
          if (_selectedIndex != 0) {
            Navigator.pushNamed(context, FirebaseCrashlyticsPage.id);
          }
        },
      ),
      ListTile(
        selected: _selectedIndex == 1,
        title: Text('Mapbox Map'),
        onTap: () {
          Navigator.pop(context);
          if (_selectedIndex != 1) {
            Navigator.pushNamed(context, MapboxMapPage.id);
          }
        },
      ),
      ListTile(
        selected: _selectedIndex == 2,
        title: Text('Camera'),
        onTap: () {
          Navigator.pop(context);
          if (_selectedIndex != 2) {
            Navigator.pushNamed(context, CameraPage.id);
          }
        },
      ),
      ListTile(
        selected: _selectedIndex == 3,
        title: Text('Basic Widgets'),
        onTap: () {
          Navigator.pop(context);
          if (_selectedIndex != 3) {
            Navigator.pushNamed(context, BasicWidgetsPage.id);
          }
        },
      ),
      ListTile(
        selected: _selectedIndex == 4,
        title: Text('GPS'),
        onTap: () {
          Navigator.pop(context);
          if (_selectedIndex != 4) {
            Navigator.pushNamed(context, GPSPage.id);
          }
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
            Navigator.pop(context);
            _auth.signOut();
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
            Navigator.pop(context);
            Navigator.pushNamed(context, FirebaseAuthLoginPage.id,
                arguments: FirebaseAuthPageArgs(fromPage: DrawerWindow.id));
          },
        ),
      );
      listViewItems.add(
        ListTile(
          title: Text('Register'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, FirebaseAuthRegistrationPage.id,
                arguments: FirebaseAuthPageArgs(fromPage: DrawerWindow.id));
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
