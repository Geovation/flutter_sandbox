import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/app_settings.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/firebase_auth/Components/rounded_button.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

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
      onPressed: () =>
          Navigator.pop(context, AppLocalizations.of(context).gotIt),
      child: Text(
        AppLocalizations.of(context).gotIt,
        style: GoogleFonts.lato(),
      ),
    );

    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(
        titleText,
        style: GoogleFonts.lato(),
      ),
      content: Text(
        messageText,
        style: GoogleFonts.lato(),
      ),
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
    final AppSettings appSettings = Provider.of<AppSettings>(context);
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    final PageController _pageController = _pageNavigator.getPageController;
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex("FirebaseAuthRegister");
    Auth authProvider = Provider.of<Auth>(context);
    Widget bodyWidget;
    if (_auth != null) {
      if (_auth.currentUser != null) {
        bodyWidget = Center(
          child: RoundedButton(
            title: AppLocalizations.of(context).firebaseAuthSignOut,
            colour: (appSettings.getCurrentThemeMode == ThemeMode.light)
                ? Colors.deepOrangeAccent
                : Colors.deepOrangeAccent.shade700,
            onPressed: () {
              _auth.signOut();
              authProvider.setUserLoginStatus = false;
              _pageController.jumpToPage(_pageNavigator.getFromIndex);
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
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .firebaseAuthEnterYourEmail),
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
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .firebaseAuthEnterYourPassword),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: AppLocalizations.of(context).firebaseAuthRegister,
                  colour: (appSettings.getCurrentThemeMode == ThemeMode.light)
                      ? Colors.deepOrangeAccent
                      : Colors.deepOrangeAccent.shade700,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        analytics.logSignUp(signUpMethod: 'Email & Password');
                        authProvider.setUserLoginStatus = true;
                        _pageController.jumpToPage(_pageNavigator.getFromIndex);
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
        child: Text(
          AppLocalizations.of(context).firebaseAuthInitiationError,
          style: GoogleFonts.lato(),
        ),
      );
    }
    return bodyWidget;
  }
}
