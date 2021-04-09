import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/firebase_auth/Components/rounded_button.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_login_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_register_page.dart';
import 'package:flutter_sandbox/screen_arguments.dart';
import 'package:provider/provider.dart';

class FirebaseAuthLandingPage extends StatelessWidget {
  static const id = 'firebase_auth_page';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      return FirebaseAuthLoggedOutState();
    } else {
      return FirebaseAuthLoggedInState();
    }
  }
}

class FirebaseAuthLoggedOutState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthPageArgs args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                if (args != null) {
                  Navigator.pushNamed(context, FirebaseAuthLoginPage.id,
                      arguments: FirebaseAuthPageArgs(fromPage: args.fromPage));
                } else {
                  Navigator.pushNamed(context, FirebaseAuthLoginPage.id);
                }
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                if (args != null) {
                  Navigator.pushNamed(context, FirebaseAuthRegistrationPage.id,
                      arguments: FirebaseAuthPageArgs(fromPage: args.fromPage));
                } else {
                  Navigator.pushNamed(context, FirebaseAuthRegistrationPage.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseAuthLoggedInState extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Firebase Auth'),
        ),
        body: Center(
          child: RoundedButton(
            title: 'Sign out',
            colour: Colors.lightBlueAccent,
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ));
  }
}
