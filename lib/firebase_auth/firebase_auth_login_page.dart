import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/ListOfScreens.dart';
import 'package:flutter_sandbox/firebase_auth/Components/rounded_button.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_signed_in_page.dart';
import 'package:flutter_sandbox/screen_arguments.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FirebaseAuthLoginPage extends StatefulWidget {
  static const id = 'firebase_auth_login_page';
  @override
  _FirebaseAuthLoginPageState createState() => _FirebaseAuthLoginPageState();
}

class _FirebaseAuthLoginPageState extends State<FirebaseAuthLoginPage> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
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
    final FirebaseAuthPageArgs args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth"),
      ),
      body: ModalProgressHUD(
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
                title: 'Log In',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      if (args != null) {
                        if (args.fromPage == ListOfScreen.id) {
                          Navigator.pushNamed(context, ListOfScreen.id);
                        }
                      } else {
                        Navigator.pushNamed(
                            context, FirebaseAuthSignedInPage.id);
                      }
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
      ),
    );
  }
}
