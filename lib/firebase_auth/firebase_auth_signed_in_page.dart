import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                  AppLocalizations.of(context).firebaseSignedInSecretMessage,
                  style: TextStyle(
                      color: Colors.blueGrey.shade900, fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            RoundedButton(
              title: AppLocalizations.of(context).firebaseAuthSignOut,
              colour: Colors.deepOrangeAccent,
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
