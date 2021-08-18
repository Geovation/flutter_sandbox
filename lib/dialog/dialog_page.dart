import 'dart:io' show Platform;

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum Path { tinkerer, dreamer, builder }

class DialogPage extends StatefulWidget {
  const DialogPage({Key key}) : super(key: key);

  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  Widget getAlertDialog(BuildContext context, AppLocalizations localizations) {
    Widget alert = Container();

    if (kIsWeb || Platform.isAndroid) {
      alert = AlertDialog(
        title: Text('Material Alert'),
        content: Text(localizations.dpWhichButtonWillYouPress),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.dpYes),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.dpNo),
          ),
        ],
      );
    } else {
      alert = CupertinoAlertDialog(
        title: Text('Cupertino Alert'),
        content: Text(localizations.dpWhichButtonWillYouPress),
        actions: [
          CupertinoDialogAction(
            child: Text(localizations.dpYes),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text(localizations.dpNo),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }

    return alert;
  }

  Widget getSimpleDialog(BuildContext context, AppLocalizations localizations) {
    Widget alert = SimpleDialog(
      title: Text(localizations.dpSelectYourPath),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            print(Path.tinkerer);
          },
          child: Text(localizations.dpTinkerer),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            print(Path.dreamer);
          },
          child: Text(localizations.dpDreamer),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            print(Path.builder);
          },
          child: Text(localizations.dpBuilder),
        ),
      ],
    );

    return alert;
  }

  Widget _buildElevatedButton(
      {VoidCallback onPressedCallBack, Widget childWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
      child: ElevatedButton(
        onPressed: onPressedCallBack,
        child: childWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'dialog_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex = _pageNavigator.getPageIndex('Dialog');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _buildElevatedButton(
            onPressedCallBack: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    getAlertDialog(context, localizations),
              );
            },
            childWidget: Text(
              'Show Alert Dialog',
              style: GoogleFonts.lato(),
            ),
          ),
          _buildElevatedButton(
            onPressedCallBack: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    getSimpleDialog(context, localizations),
              );
            },
            childWidget: Text(
              'Simple Dialog',
              style: GoogleFonts.lato(),
            ),
          ),
          _buildElevatedButton(
            onPressedCallBack: () {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.success,
                onConfirmBtnTap: () {},
                text: localizations.dpYouWillBeSuccessful,
                autoCloseDuration: Duration(seconds: 4),
                confirmBtnTextStyle: GoogleFonts.lato(),
              );
            },
            childWidget: Text(
              'Cool Alert: Success',
              style: GoogleFonts.lato(),
            ),
          ),
          _buildElevatedButton(
            onPressedCallBack: () {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.error,
                title: localizations.dpOopsie,
                text: localizations.dpAvoidErrorsInFuture,
                loopAnimation: false,
              );
            },
            childWidget: Text(
              'Cool Alert: Error',
              style: GoogleFonts.lato(),
            ),
          ),
          _buildElevatedButton(
            onPressedCallBack: () {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.warning,
                text: localizations.dpYouJustWentSideways,
              );
            },
            childWidget: Text(
              'Cool Alert: Warning',
              style: GoogleFonts.lato(),
            ),
          ),
          _buildElevatedButton(
            onPressedCallBack: () {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.loading,
              );
            },
            childWidget: Text(
              'Cool Alert: Loading',
              style: GoogleFonts.lato(),
            ),
          ),
          _buildElevatedButton(
            onPressedCallBack: () {
              var _message = '';
              CoolAlert.show(
                context: context,
                type: CoolAlertType.custom,
                barrierDismissible: true,
                confirmBtnText: 'Save',
                widget: TextFormField(
                  decoration: InputDecoration(
                    hintText: localizations.dpEnterYourPhoneNumber,
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => _message = value,
                ),
                onConfirmBtnTap: () async {
                  if (_message.length < 5) {
                    await CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      text: localizations.dpPleaseInputAtLeast5Digits,
                    );
                    return;
                  }
                  Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: 1000));
                  await CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text:
                        "${localizations.dpPhoneNumber} '$_message' ${localizations.dpHasNotBeenSaved}",
                  );
                },
              );
            },
            childWidget: Text(
              'Cool Alert: Custom',
              style: GoogleFonts.lato(),
            ),
          ),
        ],
      ),
    );
  }
}
