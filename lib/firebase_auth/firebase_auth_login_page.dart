import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/app_settings.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/firebase_auth/Components/rounded_button.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:flutter_sandbox/services/authentication.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class FirebaseAuthLoginPage extends StatefulWidget {
  static const id = 'firebase_auth_login_page';
  @override
  _FirebaseAuthLoginPageState createState() => _FirebaseAuthLoginPageState();
}

class _FirebaseAuthLoginPageState extends State<FirebaseAuthLoginPage> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email = "";
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
      child: Text(AppLocalizations.of(context).gotIt),
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
        _pageNavigator.getPageIndex("FirebaseAuthLogin");
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
                  title: AppLocalizations.of(context).firebaseAuthLogIn,
                  colour: (appSettings.getCurrentThemeMode == ThemeMode.light)
                      ? Colors.deepOrangeAccent
                      : Colors.deepOrangeAccent.shade700,
                  onPressed: () async {
                    if (email.isNotEmpty && password.isNotEmpty) {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          analytics.logLogin();
                          authProvider.setUserLoginStatus = true;
                          _pageController
                              .jumpToPage(_pageNavigator.getFromIndex);
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
                    } else {
                      await showErrorAlertDialog(
                        context: context,
                        titleText: 'Uh Oh!',
                        messageText: AppLocalizations.of(context)
                            .firebaseAuthEmptyFieldError,
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SignInButton(
                  (appSettings.getCurrentThemeMode == ThemeMode.light)
                      ? Buttons.Google
                      : Buttons.GoogleDark,
                  onPressed: () async {
                    User user = await Authentication.socialGoogleSignIn(
                        context: context);
                    if (user != null) {
                      analytics.logLogin();
                      authProvider.setUserLoginStatus = true;
                      _pageController.jumpToPage(_pageNavigator.getFromIndex);
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
