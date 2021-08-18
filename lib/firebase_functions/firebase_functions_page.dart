import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/app_settings.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FirebaseFunctionsPage extends StatefulWidget {
  static const id = 'firebase_functions_page';
  @override
  _FirebaseFunctionsPageState createState() => _FirebaseFunctionsPageState();
}

class _FirebaseFunctionsPageState extends State<FirebaseFunctionsPage> {
  FirebaseFunctions functions;
  String cloudFunctionData = '';

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
  void initState() {
    super.initState();
    functions = FirebaseFunctions.instance;
  }

  @override
  Widget build(BuildContext context) {
    final AppSettings appSettings = Provider.of<AppSettings>(context);
    final AppLocalizations localizations = AppLocalizations.of(context);
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'cloud_functions_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Cloud Functions');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

    Future<void> getGeoJSON() async {
      setState(() {
        cloudFunctionData = '-----${localizations.loadingCAPS}-----';
      });
      HttpsCallable callable = functions.httpsCallable('getGeoJSON');
      try {
        final results = await callable();
        setState(() {
          cloudFunctionData = results.data.toString();
        });
      } catch (error) {
        setState(() {
          cloudFunctionData = '';
        });
        await showErrorAlertDialog(
          context: context,
          titleText: 'Uh Oh!',
          messageText: error.message,
        );
      }
    }

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: (appSettings.getCurrentThemeMode == ThemeMode.light)
                  ? Colors.blue.shade50
                  : Colors.blue.shade900,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  cloudFunctionData,
                  style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              getGeoJSON();
            },
            child: Text(
              localizations.functionsFetchGeoJSON,
              semanticsLabel: localizations.semFunctionsPgSaveButton,
              style: GoogleFonts.lato(),
            ),
          ),
        ),
      ],
    );
  }
}
