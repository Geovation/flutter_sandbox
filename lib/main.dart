import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/basic_effects/basic_effects_page.dart';
import 'package:flutter_sandbox/camera/camera_page.dart';
import 'package:flutter_sandbox/constants.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_login_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_register_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_signed_in_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/firebase_firestore/firestore_page.dart';
import 'package:flutter_sandbox/google_maps/google_maps_page.dart';
import 'package:flutter_sandbox/gps/gps_page.dart';
import 'package:flutter_sandbox/home_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:flutter_sandbox/rive/rive_page.dart';
import 'package:provider/provider.dart';

import 'basic_widget/basic_widget_page.dart';
import 'home_page.dart';

List<CameraDescription> cameraList;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (!kIsWeb) {
    cameraList = await availableCameras();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(initialPage: 0);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PageNavigatorCustom(0, 0, _pageController)),
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Sandbox',
        theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme(
              primary: kPrimary,
              primaryVariant: Colors.orange.shade300,
              secondary: kSecondary,
              secondaryVariant: Colors.deepOrangeAccent.shade400,
              surface: Colors.white,
              background: Colors.white,
              error: Colors.redAccent,
              onPrimary: Colors.black,
              onSecondary: Colors.white,
              onSurface: Colors.grey,
              onBackground: Colors.grey,
              onError: Colors.white,
              brightness: Brightness.light),
          primaryColorDark: Color(0xFFF57C00),
          primaryColorLight: Color(0xFFFFE0B2),
          primaryColor: Color(0xFFFF9800),
          accentColor: Color(0xFFFF5252),
          dividerColor: Color(0xFFBDBDBD),
          bottomAppBarColor: Color(0xFFFF5252),
          buttonColor: Color(0xFFFF5252),
        ),
        initialRoute: HomePage.id,
        routes: {
          MapboxMapPage.id: (context) => MapboxMapPage(),
          FirebaseAuthLandingPage.id: (context) => FirebaseAuthLandingPage(),
          FirebaseAuthLoginPage.id: (context) => FirebaseAuthLoginPage(),
          FirebaseAuthRegistrationPage.id: (context) =>
              FirebaseAuthRegistrationPage(),
          FirebaseAuthSignedInPage.id: (context) => FirebaseAuthSignedInPage(),
          FirebaseCrashlyticsPage.id: (context) => FirebaseCrashlyticsPage(),
          CameraPage.id: (context) => CameraPage(cameras: cameraList),
          BasicWidgetsPage.id: (context) => BasicWidgetsPage(),
          GPSPage.id: (context) => GPSPage(),
          HomePage.id: (context) => HomePage(cameraList: cameraList),
          FirestorePage.id: (context) => FirestorePage(),
          GoogleMapsPage.id: (context) => GoogleMapsPage(),
          BasicEffectsPage.id: (context) => BasicEffectsPage(),
          RivePage.id: (context) => RivePage(),
        },
      ),
    );
  }
}
