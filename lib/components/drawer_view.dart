import 'package:flutter/material.dart';
import 'package:flutter_sandbox/basic_widget/basic_widget_page.dart';
import 'package:flutter_sandbox/camera/camera_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({
    Key key,
    @required int selectedIndex,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              'Flutter Sandbox',
              style: TextStyle(fontSize: 30),
            ),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Demos'),
          ),
          ListTile(
            selected: _selectedIndex == 0,
            title: Text('Firebase Crashlytics'),
            onTap: () {
              Navigator.pop(context);
              if (_selectedIndex != 0) {
                Navigator.pushNamed(context, FirebaseCrashlyticsPage.id);
              }
            },
          ),
          ListTile(
            selected: _selectedIndex == 1,
            title: Text('Mapbox Map'),
            onTap: () {
              Navigator.pop(context);
              if (_selectedIndex != 1) {
                Navigator.pushNamed(context, MapboxMapPage.id);
              }
            },
          ),
          ListTile(
            selected: _selectedIndex == 2,
            title: Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              if (_selectedIndex != 2) {
                Navigator.pushNamed(context, CameraPage.id);
              }
            },
          ),
          ListTile(
            selected: _selectedIndex == 3,
            title: Text('Basic Widgets'),
            onTap: () {
              Navigator.pop(context);
              if (_selectedIndex != 3) {
                Navigator.pushNamed(context, BasicWidgetsPage.id);
              }
            },
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Accounts'),
          ),
        ],
      ),
    );
  }
}
