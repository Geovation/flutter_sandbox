import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/camera/camera_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_login_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_register_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_signed_in_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/gps/gps_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';

import 'basic_widget/basic_widget_page.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Sandbox',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: FirebaseCrashlyticsPage.id,
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
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello world',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
