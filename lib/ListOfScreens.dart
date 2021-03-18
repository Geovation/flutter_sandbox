import 'package:flutter/material.dart';
import 'package:flutter_sandbox/firebase_auth/firebase_auth_page.dart';
import 'package:flutter_sandbox/mapbox/mapbox_page.dart';

const List<String> screenNames = [
  "Mapbox Map",
  "Firebase Auth",
];

const Map<String, String> screenRoutes = {
  "Mapbox Map": MapboxMapPage.id,
  "Firebase Auth": FirebaseAuthPage.id,
};

class ListOfScreen extends StatelessWidget {
  static const id = 'list_of_screens';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screens"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: screenNames.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, screenRoutes[screenNames[index]]);
              },
              child: Card(
                child: ListTile(
                  title: Text('${screenNames[index]}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
