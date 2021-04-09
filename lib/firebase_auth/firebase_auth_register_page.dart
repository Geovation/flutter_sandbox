import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/firebase_auth/Components/rounded_button.dart';
import 'package:flutter_sandbox/home_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FirebaseAuthRegistrationPage extends StatefulWidget {
  static const id = 'firebase_auth_registration_page';

  @override
  _FirebaseAuthRegistrationPageState createState() =>
      _FirebaseAuthRegistrationPageState();
}

class _FirebaseAuthRegistrationPageState
    extends State<FirebaseAuthRegistrationPage> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;

  Future<String> showErrorAlertDialog({
    @required BuildContext context,
    @required String titleText,
    @required String messageText,
  }) async {
    // set up the buttons
    final Widget gotItButton = TextButton(
      onPressed: () => Navigator.pop(context, 'Got it'),
      child: const Text('Got it'),
    );

    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(titleText),
      content: Text(messageText),
      actions: [
        gotItButton,
      ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    if (_auth != null) {
      if (_auth.currentUser != null) {
        bodyWidget = Center(
          child: RoundedButton(
            title: 'Sign out',
            colour: Colors.lightBlueAccent,
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamed(context, HomePage.id);
            },
          ),
        );
      } else {
        bodyWidget = ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Register',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, HomePage.id);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        showSpinner = false;
                      });

                      await showErrorAlertDialog(
                        context: context,
                        titleText: 'Uh Oh!',
                        messageText: e.code,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }
    } else {
      bodyWidget = Center(
        child: Text('Could not initiate firebase auth'),
      );
    }
    return bodyWidget;
  }
}
