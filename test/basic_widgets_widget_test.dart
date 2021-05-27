import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/basic_widget/basic_widget_page.dart';
import 'package:flutter_sandbox/currentLocale.dart';
import 'package:flutter_sandbox/languages/language_title.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Basic Widgets Slider widget test', (WidgetTester tester) async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();
    final _pageController = PageController(initialPage: 0);
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PageNavigatorCustom(0, 0, _pageController)),
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => CurrentLocale('en')),
        ChangeNotifierProvider(create: (_) => LanguageTitle()),
        Provider<FirebaseAnalytics>.value(value: analytics),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Sandbox',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: Scaffold(
            appBar: AppBar(
              title: Text('Basic Widgets'),
            ),
            body: BasicWidgetsPage(),
          ),
        );
      },
    ));

    final continuousSlider = find.byKey(Key('continuous_slider'));
    final discreteSlider = find.byKey(ValueKey('discrete_slider'));

    await tester.drag(continuousSlider, Offset(100.0, 0.0));
    await tester.drag(discreteSlider, Offset(100.0, 0.0));
    await tester.pumpAndSettle();

    expect(find.text('0.0'), findsNothing);
  });
}
