import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/app_settings.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class DraggablePage extends StatefulWidget {
  static const id = "draggable_page";
  const DraggablePage({Key key}) : super(key: key);

  @override
  _DraggablePageState createState() => _DraggablePageState();
}

class _DraggablePageState extends State<DraggablePage> {
  TextStyle containerTextStyle = TextStyle(color: Colors.white, fontSize: 20);
  Random randomGen = Random();
  int currentRandomNumber = 1;
  int currentScore = 0;
  @override
  Widget build(BuildContext context) {
    currentRandomNumber = randomGen.nextInt(100);

    final AppSettings appSettings = Provider.of<AppSettings>(context);
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Draggable');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

    AppLocalizations localizations = AppLocalizations.of(context);
    Size deviceDataSize = MediaQuery.of(context).size;
    SnackBar correctTextSnackBar = SnackBar(
      content: Text("${localizations.draggableCorrect}!"),
      duration: Duration(milliseconds: 500),
    );
    SnackBar wrongTextSnackBar = SnackBar(
      content: Text("${localizations.draggableWrong}!"),
      duration: Duration(milliseconds: 500),
    );
    ScaffoldMessengerState scaffoldMessengerContext =
        ScaffoldMessenger.of(context);

    return Column(
      children: [
        Text(
          '$currentScore',
          style: TextStyle(fontSize: 30),
        ),
        Spacer(
          flex: 1,
        ),
        Draggable(
          data: currentRandomNumber,
          child: Container(
            width: deviceDataSize.width * 0.22,
            height: deviceDataSize.height * 0.12,
            decoration: BoxDecoration(
              color: (appSettings.getCurrentThemeMode == ThemeMode.light)
                  ? Colors.orange.shade400
                  : Colors.orange.shade700,
            ),
            child: Center(
              child: Text(
                '$currentRandomNumber',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          feedback: Material(
            elevation: 5,
            child: Container(
              width: deviceDataSize.width * 0.22,
              height: deviceDataSize.height * 0.12,
              decoration: BoxDecoration(
                color: (appSettings.getCurrentThemeMode == ThemeMode.light)
                    ? Colors.orange.shade400
                    : Colors.orange.shade700,
              ),
              child: Center(
                child: Text(
                  '$currentRandomNumber',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        Spacer(
          flex: 2,
        ),
        Row(
          children: [
            Spacer(
              flex: 1,
            ),
            Container(
              width: deviceDataSize.width * 0.27,
              height: deviceDataSize.height * 0.15,
              decoration: BoxDecoration(
                color: (appSettings.getCurrentThemeMode == ThemeMode.light)
                    ? Colors.blueGrey.shade400
                    : Colors.blueGrey.shade700,
              ),
              child: DragTarget(
                builder: (context, List<int> candidateData, rejectedData) {
                  return Center(
                      child: Text(localizations.draggableOdd,
                          style: containerTextStyle));
                },
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (data) {
                  setState(() {
                    currentRandomNumber = randomGen.nextInt(100);
                  });
                  if (data % 2 != 0) {
                    scaffoldMessengerContext.showSnackBar(correctTextSnackBar);
                    setState(() {
                      currentScore++;
                    });
                  } else {
                    scaffoldMessengerContext.showSnackBar(wrongTextSnackBar);
                  }
                },
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Container(
              width: deviceDataSize.width * 0.27,
              height: deviceDataSize.height * 0.15,
              decoration: BoxDecoration(
                color: (appSettings.getCurrentThemeMode == ThemeMode.light)
                    ? Colors.blueGrey.shade400
                    : Colors.blueGrey.shade700,
              ),
              child: DragTarget(
                builder: (context, List<int> candidateData, rejectedData) {
                  return Center(
                      child: Text(localizations.draggableEven,
                          style: containerTextStyle));
                },
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (data) {
                  setState(() {
                    currentRandomNumber = randomGen.nextInt(100);
                  });
                  if (data % 2 == 0) {
                    setState(() {
                      currentScore++;
                    });
                    scaffoldMessengerContext.showSnackBar(correctTextSnackBar);
                  } else {
                    scaffoldMessengerContext.showSnackBar(wrongTextSnackBar);
                  }
                },
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }
}
