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
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void onStyleLoadedCallback() {
    _addRoute();
  }

  Future<List<LatLng>> getRouteList() async {
    final String response =
        await rootBundle.loadString('lib/mapbox/mapbox_asset/coordinates.json');
    final data = await json.decode(response);
    final List _coordinatesData = List.from(data['geometry']['coordinates']);
    List<LatLng> routeList = [];

    for (var i = 0; i < _coordinatesData.length; i++) {
      routeList.add(LatLng(_coordinatesData[i][0], _coordinatesData[i][1]));
    }
    return routeList;
  }

  void _addRoute() async {
    List routeList = await getRouteList();
    int midPoint = (routeList.length) ~/ 2;
    mapController.addLine(
      LineOptions(
          geometry: routeList,
          lineColor: "#ff0000",
          lineWidth: 8.0,
          lineOpacity: 1,
          lineJoin: "round",
          draggable: false),
    );
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: routeList[midPoint - 1], zoom: 13.0),
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
            CameraPosition(target: LatLng(51.52659, -0.12977), zoom: 12.0),
        onStyleLoadedCallback: onStyleLoadedCallback,
        trackCameraPosition: true,
      ),
    );
  }
}
