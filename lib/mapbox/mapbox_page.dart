import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

import 'Models/Placemarks.dart';
import 'constants_mapbox.dart';

class MapboxMapPage extends StatefulWidget {
  static const id = 'mapbox_page';

  @override
  _MapboxMapState createState() => _MapboxMapState();
}

class _MapboxMapState extends State<MapboxMapPage> {
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;
    mapController.setSymbolIconAllowOverlap(true);
  }

  void onStyleLoadedCallback() {
    _addRoute();
    _addImageFromAsset("locationIcon", "assets/symbols/location_icon.png");
    _addImageFromAsset("bankIcon", "assets/symbols/bank.png");
    _addImageFromAsset("stationIcon", "assets/symbols/station.png");
    _addImageFromAsset("lseIcon", "assets/symbols/lse.jpg");
    _addImageFromAsset("churchIcon", "assets/symbols/church.jpg");
    _addStartEndSymbols("assets/symbols/location_icon.png");
    _addPlaceSymbols();
  }

  Future<void> _addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> _addPlaceSymbols() async {
    List<Placemarks> placemarks = await getPlacemarkList();

    for (var i = 0; i < placemarks.length; i++) {
      mapController.addSymbol(SymbolOptions(
        geometry:
            LatLng(placemarks[i].coordinates[0], placemarks[i].coordinates[1]),
        iconImage: "assets/symbols/" + placemarks[i].iconName,
        iconAnchor: "center",
      ));
    }
  }

  Future<List<Placemarks>> getPlacemarkList() async {
    final String response = await rootBundle.loadString(
        'lib/mapbox/mapbox_asset/multiple_markers_coordinates.json');
    final data = await json.decode(response);
    return (data['placemarks'] as List)
        .map((p) => Placemarks.fromJson(p))
        .toList();
  }

  Future<void> _addStartEndSymbols(String iconImage) async {
    List routeList = await getRouteList();
    mapController.addSymbols([
      SymbolOptions(
        geometry: routeList[0],
        iconImage: iconImage,
        iconAnchor: "bottom",
      ),
      SymbolOptions(
        geometry: routeList[routeList.length - 1],
        iconImage: iconImage,
        iconAnchor: "bottom",
      )
    ]);
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
        CameraPosition(target: routeList[midPoint - 1], zoom: 13.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'mapbox_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex = _pageNavigator.getPageIndex("Mapbox");
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

    return MapboxMap(
      accessToken: ACCESS_TOKEN_MAPBOX,
      onMapCreated: _onMapCreated,
      initialCameraPosition:
          CameraPosition(target: LatLng(51.52659, -0.12977), zoom: 12.0),
      onStyleLoadedCallback: onStyleLoadedCallback,
      trackCameraPosition: true,
    );
  }
}
