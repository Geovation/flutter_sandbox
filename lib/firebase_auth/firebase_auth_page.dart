import 'package:flutter/material.dart';
import 'package:flutter_sandbox/firebase_auth/Components/rounded_button.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_login_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_register_page.dart';
import 'package:flutter_sandbox/screen_arguments.dart';

class FirebaseAuthPage extends StatelessWidget {
  static const id = 'firebase_auth_page';

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
