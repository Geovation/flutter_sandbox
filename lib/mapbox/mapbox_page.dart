import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'Models/Placemarks.dart';
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
    _addImageFromAsset("assetImage", "assets/symbols/location_icon.png");
    _addImageFromAsset("assetImage", "assets/symbols/bank.png");
    _addImageFromAsset("assetImage", "assets/symbols/station.png");
    _addImageFromAsset("assetImage", "assets/symbols/lse.jpg");
    _addImageFromAsset("assetImage", "assets/symbols/church.jpg");
    _addStartEndSymbols("assets/symbols/location_icon.png");
    _addPlaceSymbols();
  }

  Future<void> _addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> _addPlaceSymbols() async {
    List<Placemarks> placemarksList = await getPlacemarkList();
    List<LatLng> placemarksCoordinatesList =
        getPlacemarkCoordinates(placemarksList);

    int listSize = placemarksCoordinatesList.length;
    List<int> symbolsToAddNumbers = Iterable<int>.generate(listSize).toList();
    mapController.symbols.forEach(
        (s) => symbolsToAddNumbers.removeWhere((i) => i == s.data['count']));

    if (symbolsToAddNumbers.isNotEmpty) {
      final List<SymbolOptions> symbolOptionsList = symbolsToAddNumbers
          .map((i) => _getSymbolPlaceOptions(
              placemarksList, i, placemarksCoordinatesList))
          .toList();
      mapController.addSymbols(symbolOptionsList,
          symbolsToAddNumbers.map((i) => {'count': i}).toList());
    }
  }

  List<LatLng> getPlacemarkCoordinates(List<Placemarks> placemarks) {
    List<LatLng> pointsList = [];

    for (var i = 0; i < placemarks.length; i++) {
      pointsList.add(
          LatLng(placemarks[i].coordinates[0], placemarks[i].coordinates[1]));
    }
    return pointsList;
  }

  SymbolOptions _getSymbolPlaceOptions(
      List<Placemarks> placemarks, int symbolCount, List<LatLng> pointList) {
    String iconImageSource =
        "assets/symbols/" + placemarks[symbolCount].iconName.toString();
    print(iconImageSource);

    return SymbolOptions(
      geometry: pointList[symbolCount],
      iconImage: iconImageSource,
      iconAnchor: "center",
    );
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
    int listSize = 2;
    List<int> symbolsToAddNumbers = Iterable<int>.generate(listSize).toList();
    mapController.symbols.forEach(
        (s) => symbolsToAddNumbers.removeWhere((i) => i == s.data['count']));

    if (symbolsToAddNumbers.isNotEmpty) {
      final List<SymbolOptions> symbolOptionsList = symbolsToAddNumbers
          .map((i) => _getSymbolOptions(iconImage, i, routeList))
          .toList();
      mapController.addSymbols(symbolOptionsList,
          symbolsToAddNumbers.map((i) => {'count': i}).toList());
    }
  }

  SymbolOptions _getSymbolOptions(
      String iconImage, int symbolCount, List routeList) {
    LatLng geometry;
    if (symbolCount == 0) {
      geometry = routeList[0];
    } else {
      geometry = routeList[routeList.length - 1];
    }

    return SymbolOptions(
      geometry: geometry,
      iconImage: iconImage,
      iconAnchor: "bottom",
    );
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
