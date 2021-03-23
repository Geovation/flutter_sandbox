import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'screen_arguments.dart';

const List<String> screenNames = [
  "Mapbox Map",
  "Firebase Auth",
  "Firebase Crashlytics",
];

const Map<String, String> screenRoutes = {
  "Mapbox Map": MapboxMapPage.id,
  "Firebase Auth": FirebaseAuthPage.id,
  "Firebase Crashlytics": FirebaseCrashlyticsPage.id,
};

class ListOfScreen extends StatelessWidget {
  static const id = 'list_of_screens';

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
              return ListInLoggedOutState();
            }
            return ListInLoggedInState();
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

class ListInLoggedInState extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Screens"), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Log out',
          onPressed: () {
            _auth.signOut();
          },
        ),
      ]),
      body: SafeArea(
        child: ListView.builder(
          itemCount: screenNames.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, screenRoutes[screenNames[index]]);
              },
              child: Card(
                child: ListTile(
                  title: Text('${screenNames[index]}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ListInLoggedOutState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Screens"), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.login),
          tooltip: 'Log in',
          onPressed: () {
            Navigator.pushNamed(context, FirebaseAuthPage.id,
                arguments: FirebaseAuthPageArgs(fromPage: ListOfScreen.id));
          },
        ),
      ]),
      body: SafeArea(
        child: ListView.builder(
          itemCount: screenNames.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, screenRoutes[screenNames[index]]);
              },
              child: Card(
                child: ListTile(
                  title: Text('${screenNames[index]}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
