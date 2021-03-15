import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'constants_mapbox.dart';

class MapboxMapPage extends StatefulWidget {
  @override
  _MapboxMapState createState() => _MapboxMapState();
}

class _MapboxMapState extends State<MapboxMapPage> {
  List _coordinatesData = [];
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _addRoute();
  }

  void onStyleLoadedCallback() {}

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('lib/mapbox/mapbox_asset/coordinates.json');
    final data = await json.decode(response);

    setState(() {
      _coordinatesData = List.from(data['geometry']['coordinates']);
    });
  }

  Future<List<LatLng>> geometryList() async {
    await readJson();
    List<LatLng> geometryVal = [];

    for (var i = 0; i < _coordinatesData.length; i++) {
      geometryVal.add(LatLng(_coordinatesData[i][0], _coordinatesData[i][1]));
    }
    return geometryVal;
  }

  void _addRoute() async {
    List geometryListData = await geometryList();
    int midPointOfGeometryListData = (geometryListData.length) ~/ 2;
    mapController.addLine(
      LineOptions(
          geometry: geometryListData,
          lineColor: "#ff0000",
          lineWidth: 8.0,
          lineOpacity: 1,
          lineJoin: "round",
          draggable: false),
    );
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: geometryListData[midPointOfGeometryListData], zoom: 20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken: ACCESS_TOKEN,
        onMapCreated: _onMapCreated,
        initialCameraPosition:
            CameraPosition(target: LatLng(0.0, 0.0), zoom: 1.0),
        onStyleLoadedCallback: onStyleLoadedCallback,
        zoomGesturesEnabled: true,
        trackCameraPosition: true,
      ),
    );
  }
}
