import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'package:flutter_sandbox/pageNavigatorCustom.dart';

class RivePage extends StatefulWidget {
  static const id = "rive_page";
  @override
  _RivePageState createState() => _RivePageState();
}

class _RivePageState extends State<RivePage> {
  final riveFileName =
      'assets/rive/truck_run7.riv'; // available animations: idle, bouncing, windshield_wipers, and broken
  Artboard _artboard;
  List<String> animationNames = [
    'idle',
    'bouncing',
    'windshield_wipers',
    'broken'
  ];
  List<bool> animationToggles = [
    true,
    false,
    false,
    false,
  ];

  CustomAnimation _wipersController, _bouncingController, _brokenController;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  @override
  void dispose() {
    if (_wipersController != null) {
      _wipersController.dispose();
    }

    if (_bouncingController != null) {
      _bouncingController.dispose();
    }

    if (_brokenController != null) {
      _brokenController.dispose();
    }

    super.dispose();
  }

  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile.import(bytes);

    if (file != null) {
      // Select an animation by its name
      setState(() {
        _artboard = file.mainArtboard;
        _artboard.addController(SimpleAnimation(animationNames[0]));
      });
    }
  }

  void _wipersChange(bool wipersOn) {
    if (_wipersController == null) {
      _artboard.addController(
        _wipersController = CustomAnimation(animationNames[2]),
      );
    }
    if (wipersOn) {
      _wipersController.start();
    } else {
      _wipersController.stop();
    }
  }

  void _bouncingChange(bool bouncingOn) {
    if (_bouncingController == null) {
      _artboard.addController(
        _bouncingController = CustomAnimation(animationNames[1]),
      );
    }
    if (bouncingOn) {
      _bouncingController.start();
    } else {
      _bouncingController.stop();
    }
  }

  void _brokenChange(bool brokenOn) {
    if (_brokenController == null) {
      _artboard.addController(
        _brokenController = CustomAnimation(animationNames[3]),
      );
    }
    if (brokenOn) {
      _brokenController.start();
    } else {
      _brokenController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex = _pageNavigator.getPageIndex('Rive');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

    Widget paddedTextForToggleButton(String text) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      );
    }

    Widget riveAnimationView() {
      return OrientationBuilder(builder: (context, orientation) {
        final bool isLandscape = (orientation == Orientation.landscape);
        return Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: isLandscape ? Axis.horizontal : Axis.vertical,
          children: [
            Container(
              width: isLandscape ? _width * 0.5 : _width,
              height: isLandscape ? _height : _height * 0.6,
              child: Rive(
                artboard: _artboard,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              child: ToggleButtons(
                direction: isLandscape ? Axis.vertical : Axis.horizontal,
                color: Colors.blueGrey,
                selectedColor: Colors.deepOrange,
                selectedBorderColor: Colors.deepOrangeAccent,
                borderColor: Colors.blueGrey,
                hoverColor: Colors.orange.shade100,
                splashColor: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(15),
                children: [
                  paddedTextForToggleButton('Idle'),
                  paddedTextForToggleButton('Bouncing'),
                  paddedTextForToggleButton('Wipers'),
                  paddedTextForToggleButton('Broken'),
                ],
                isSelected: animationToggles,
                onPressed: (int index) {
                  setState(() {
                    animationToggles[animationToggles.indexOf(true)] = false;
                    animationToggles[index] = true;
                  });

                  switch (index) {
                    case 0:
                      _wipersChange(false);
                      _bouncingChange(false);
                      _brokenChange(false);
                      break;
                    case 1:
                      _wipersChange(false);
                      _bouncingChange(true);
                      _brokenChange(false);
                      break;
                    case 2:
                      _wipersChange(true);
                      _bouncingChange(false);
                      _brokenChange(false);
                      break;
                    case 3:
                      _wipersChange(false);
                      _bouncingChange(false);
                      _brokenChange(true);
                      break;
                  }
                },
              ),
            )
          ],
        );
      });
    }

    return _artboard != null
        ? riveAnimationView()
        : GFLoader(
            type: GFLoaderType.circle,
          );
  }
}

class CustomAnimation extends SimpleAnimation {
  CustomAnimation(String animationName) : super(animationName);

  start() {
    instance.animation.loop = Loop.loop;
    isActive = true;
  }

  stop() => instance.animation.loop = Loop.oneShot;
}
