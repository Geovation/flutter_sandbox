import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sandbox/app_settings.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/basic_effects/basic_effects_page.dart';
import 'package:flutter_sandbox/camera/camera_page.dart';
import 'package:flutter_sandbox/currentLocale.dart';
import 'package:flutter_sandbox/dark_mode/dark_mode_screen.dart';
import 'package:flutter_sandbox/database/sembast/person_dao.dart';
import 'package:flutter_sandbox/draggable/draggable_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_login_page.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_register_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/firebase_firestore/firestore_page.dart';
import 'package:flutter_sandbox/google_maps/google_maps_page.dart';
import 'package:flutter_sandbox/gps/gps_page.dart';
import 'package:flutter_sandbox/home_page.dart';
import 'package:flutter_sandbox/languages/language_title.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:flutter_sandbox/rive/rive_page.dart';
import 'package:flutter_sandbox/sandbox_license/sandbox_license_page.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'basic_widget/basic_widget_page.dart';
import 'home_page.dart';

List<CameraDescription> cameraList;

var flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.data}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'flutter_sandbox_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

Function selectNotification;
Function onDidReceiveLocalNotification;

void main() {
  runApp(InitApp());
}

class InitApp extends StatelessWidget {
  Future<void> _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (!kIsWeb) {
      cameraList = await availableCameras();
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } else {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      // Use the returned token to send messages to users from your custom server
      String token = await messaging.getToken(
        vapidKey:
            'BJb4oODa08l2HMt49p_WQkO50sDSZfVcaLBgvyS3mivJO74guGHYR1Uww_mlwbF6T1tU4M5Ba5XjSiZUZM2RZzc',
      );
      print(token);
    }
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    return Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(debugShowCheckedModeBanner: false, home: Splash());
        } else {
          // Loading is done, return the app:
          return MyApp();
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/lottie/loading.json',
            width: deviceSize.width * 0.6, fit: BoxFit.fill),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final _pageController = PageController(initialPage: 0);
  final fcmDemoPage = 12;

  @override
  void initState() {
    super.initState();

    selectNotification = (String payload) {
      _pageController.jumpToPage(fcmDemoPage);
    };

    onDidReceiveLocalNotification =
        (int id, String title, String body, String payload) async {
      // display a dialog with the notification details, tap ok to go to another page
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                _pageController.jumpToPage(fcmDemoPage);
              },
            )
          ],
        ),
      );
    };

    if (!kIsWeb) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('launch_background');
      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
              onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);

      Future<void> initiateFlutterLocalNotificationPlugin() async {
        await flutterLocalNotificationsPlugin.initialize(initializationSettings,
            onSelectNotification: selectNotification);
      }

      initiateFlutterLocalNotificationPlugin();
    }

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        if (message.data["isDemo"] == "true") {
          _pageController
              .jumpToPage(fcmDemoPage); // update number to FCM page index
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data["isDemo"] == "true") {
        _pageController
            .jumpToPage(fcmDemoPage); // update number to FCM page index
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PageNavigatorCustom(0, 0, _pageController)),
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => CurrentLocale('en')),
        ChangeNotifierProvider(create: (_) => LanguageTitle()),
        ChangeNotifierProvider(create: (_) => AppSettings()),
        Provider<FirebaseAnalytics>.value(value: analytics),
        ChangeNotifierProvider(create: (_) => PersonDao()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Sandbox',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(Provider.of<CurrentLocale>(context).getCurrentLocale),
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme(
                primary: Colors.orange,
                primaryVariant: Colors.orange.shade300,
                secondary: Colors.deepOrangeAccent,
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
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme(
                primary: Colors.orange.shade900,
                primaryVariant: Colors.orange.shade700,
                secondary: Colors.red.shade800,
                secondaryVariant: Colors.deepOrangeAccent.shade700,
                surface: Colors.grey.shade900,
                background: Colors.grey.shade800,
                error: Colors.redAccent,
                onPrimary: Colors.black,
                onSecondary: Colors.white,
                onSurface: Colors.grey,
                onBackground: Colors.grey,
                onError: Colors.white,
                brightness: Brightness.dark),
            primaryColorDark: Color(0xFFF57C00),
            primaryColorLight: Color(0xFFFFE0B2),
            primaryColor: Colors.orange.shade900,
            accentColor: Color(0xFFFF5252),
            dividerColor: Color(0xFFBDBDBD),
            bottomAppBarColor: Color(0xFFFF5252),
            buttonColor: Color(0xFFFF5252),
          ),
          themeMode: Provider.of<AppSettings>(context).getCurrentThemeMode,
          initialRoute: HomePage.id,
          routes: {
            MapboxMapPage.id: (context) => MapboxMapPage(),
            FirebaseAuthLoginPage.id: (context) => FirebaseAuthLoginPage(),
            FirebaseAuthRegistrationPage.id: (context) =>
                FirebaseAuthRegistrationPage(),
            FirebaseCrashlyticsPage.id: (context) => FirebaseCrashlyticsPage(),
            CameraPage.id: (context) => CameraPage(cameras: cameraList),
            BasicWidgetsPage.id: (context) => BasicWidgetsPage(),
            GPSPage.id: (context) => GPSPage(),
            HomePage.id: (context) => HomePage(cameraList: cameraList),
            FirestorePage.id: (context) => FirestorePage(),
            GoogleMapsPage.id: (context) => GoogleMapsPage(),
            BasicEffectsPage.id: (context) => BasicEffectsPage(),
            RivePage.id: (context) => RivePage(),
            SandboxLicensePage.id: (context) => SandboxLicensePage(),
            DarkModeScreen.id: (context) => DarkModeScreen(),
            DraggablePage.id: (context) => DraggablePage(),
          },
        );
      },
    );
  }
}
