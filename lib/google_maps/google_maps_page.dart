import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class GoogleMapsPage extends StatefulWidget {
  static const id = "google_maps_page";
  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  Completer<GoogleMapController> _controller = Completer();
  PermissionStatus locationPermissionStatus;
  bool isLocationEnabled = false;
  void requestForLocation() async {
    await Permission.location.request();
    checkLocationStatus();
  }

  void checkLocationStatus() async {
    locationPermissionStatus = await Permission.location.status;

    if (locationPermissionStatus.isDenied) {
      requestForLocation();
    } else if (locationPermissionStatus.isGranted) {
      setState(() {
        isLocationEnabled = true;
      });
    }
  }

  static final CameraPosition _kQueenElizabethOlympicPark = CameraPosition(
    target: LatLng(51.54265, -0.00956),
    zoom: 14.4746,
  );

  final LatLng kPoolLocation = const LatLng(51.53956, -0.03278);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;

  static final CameraPosition _kPool = CameraPosition(
      bearing: 110, target: LatLng(51.53956, -0.03278), tilt: 20, zoom: 19.5);

  Future<void> _goToThePool() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kPool));
  }

  void _addMarker(LatLng markerPosition) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: markerPosition,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      checkLocationStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex("Google Maps");
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        myLocationButtonEnabled: isLocationEnabled,
        myLocationEnabled: isLocationEnabled,
        initialCameraPosition: _kQueenElizabethOlympicPark,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _addMarker(LatLng(51.54265, -0.00956));
          _addMarker(kPoolLocation);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToThePool,
        label: Text('To the Pool'),
        icon: Icon(Icons.pool),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
