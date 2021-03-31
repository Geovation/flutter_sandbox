import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'basic_widget/basic_widget_page.dart';
import 'camera/camera_page.dart';
import 'firebase_auth/firebase_auth_page.dart';
import 'firebase_crashlytics/firebase_crashlytics_page.dart';
import 'mapbox/mapbox_page.dart';
import 'screen_arguments.dart';

bool isLoggedIn = false;

class FlutterSandboxLandingPage extends StatelessWidget {
  static const id = 'flutter_sandbox_page';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
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
              return FlutterSandboxPage();
            }
            isLoggedIn = true;
            return FlutterSandboxPage();
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
class FlutterSandboxPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
     Widget drawerView() {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Flutter Sandbox',
                style: TextStyle(fontSize: 30),
              ),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Demos'),
            ),
            ListTile(
              title: Text('Mapbox Map'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, MapboxMapPage.id);
              },
            ),
            ListTile(
              title: Text('Firebase Crashlytics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, FirebaseCrashlyticsPage.id);
              },
            ),
            ListTile(
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, CameraPage.id);
              },
            ),
            ListTile(
              title: Text('Basic Widgets'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, BasicWidgetsPage.id);
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Flutter Sandbox'), actions: <Widget>[
        isLoggedIn
            ? IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Log out',
          onPressed: () {
            _auth.signOut();
          },
        )
            : IconButton(
          icon: const Icon(Icons.login),
          tooltip: 'Log in',
          onPressed: () {
            Navigator.pushNamed(context, FirebaseAuthLandingPage.id,
                arguments: FirebaseAuthPageArgs(
                    fromPage: FlutterSandboxLandingPage.id));
          },
        )
      ]),
      drawer: drawerView(),
      body: Center(
        child: Text('Basic demos of various functionality in Flutter'),
      ),
    );
  }
}

