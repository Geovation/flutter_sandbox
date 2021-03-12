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
    _add();
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

  void _add() async {
    List geometryListData = await geometryList();
    mapController.addLine(
      LineOptions(
          geometry: geometryListData,
          lineColor: "#ff0000",
          lineWidth: 14.0,
          lineOpacity: 1,
          lineJoin: "round",
          draggable: false),
    );
  }

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

  void _add() async {
    List geometryListData = await geometryList();
    mapController.addLine(
      LineOptions(
          geometry: geometryListData,
          lineColor: "#ff0000",
          lineWidth: 14.0,
          lineOpacity: 1,
          lineJoin: "round",
          draggable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken: ACCESS_TOKEN,
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
        onStyleLoadedCallback: onStyleLoadedCallback,
      ),
    );
  }
}
