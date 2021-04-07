import 'package:flutter/material.dart';
import 'package:flutter_sandbox/basic_widget/basic_widget_page.dart';
import 'package:flutter_sandbox/camera/camera_page.dart';
import 'package:flutter_sandbox/firebase_crashlytics/firebase_crashlytics_page.dart';
import 'package:flutter_sandbox/gps/gps_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({
    Key key,
    @required int selectedIndex,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      switch (index) {
        case 0:
          if (_selectedIndex != index) {
            Navigator.pushNamed(context, FirebaseCrashlyticsPage.id);
          }
          break;
        case 1:
          if (_selectedIndex != index) {
            Navigator.pushNamed(context, MapboxMapPage.id);
          }
          break;
        case 2:
          if (_selectedIndex != index) {
            Navigator.pushNamed(context, CameraPage.id);
          }
          break;
        case 3:
          if (_selectedIndex != index) {
            Navigator.pushNamed(context, BasicWidgetsPage.id);
          }
          break;
        case 4:
          if (_selectedIndex != index) {
            Navigator.pushNamed(context, GPSPage.id);
          }
          break;

        default:
          print('default pressed');
          break;
      }
    }

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.error),
          label: 'Crashlytics',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapbox',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Camera',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets_rounded),
          label: 'Basic Widget',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gps_fixed),
          label: 'GPS',
          backgroundColor: Colors.pink,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }
}
