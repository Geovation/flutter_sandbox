import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/firebase_auth/Components/rounded_button.dart';

class FirebaseAuthSignedInPage extends StatelessWidget {
  static const id = 'firebase_auth_signed_in_page';
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Container(
                height: 100,
                child: Text(
                  'Welcome! You are in the secret room now.',
                  style: TextStyle(
                      color: Colors.blueGrey.shade900, fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            RoundedButton(
              title: 'Sign out',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
