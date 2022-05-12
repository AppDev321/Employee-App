import 'dart:async';

import 'package:background_locator/location_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hnh_flutter/pages/location/location_background_service_class.dart';
import 'package:hnh_flutter/pages/location/location_callback_handler.dart';
import 'package:location/location.dart';

import '../custom_style/applog.dart';

class MapLocation extends StatefulWidget {
  @override
  State<MapLocation> createState() => MapLocationStateful();
}

class MapLocationStateful extends State<MapLocation>
    {
  Completer _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(17.385044, 78.486671),
    zoom: 18,
  );

  Set<Marker> markers = {};
  late MarkerId markerId1;
  late Marker marker1;
  Location _locationService = new Location();
  LocationData? initialLocation;
  LocationData? _currentLocation;
  late MapType maptype;
  bool updateStarted = false;

  late StreamSubscription _locationSubscription;
  PermissionStatus? _permissionGranted;

  String error = "";

  @override
  void initState() {
    super.initState();
     _locationService.requestPermission();


    maptype = MapType.normal;
    markerId1 = MarkerId("Current");
    marker1 = Marker(
        markerId: markerId1,
        position: LatLng(17.385044, 78.486671),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
            title: "Hytech City", onTap: () {}, snippet: "Snipet Hitech City"));
    //  markers[markerId1]=marker1;

    setState(() {
      markers.add(marker1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text(
          "Flutter Track Location",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (builder) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text('Hybrid'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Normal'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Satellite'),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text('Terrain'),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 0:
                  setState(() {
                    maptype = MapType.hybrid;
                  });
                  break;
                case 1:
                  setState(() {
                    maptype = MapType.normal;
                  });
                  break;
                case 2:
                  setState(() {
                    maptype = MapType.satellite;
                  });
                  break;
                case 3:
                  setState(() {
                    maptype = MapType.terrain;
                  });
                  break;
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          children: [
            GoogleMap(
              mapType: maptype,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: Colors.white60,
                  child: new Text(
                    _currentLocation != null
                        ? 'Current location: \nlat: ${_currentLocation!.latitude}\n  long: ${_currentLocation!.longitude} '
                        : 'Error: $error\n',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.pink, fontSize: 20),
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: !updateStarted ? Colors.blue : Colors.red,
        onPressed: !updateStarted ? _startTrack : _stopTrack,
        label: Text(!updateStarted ? 'Start Track!' : 'Stop Track'),
        icon: Icon(
          Icons.directions_boat,
        ),
      ),
    );
  }

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000);

    LocationData? locationData;
    try {
      bool serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        PermissionStatus p;

        _permissionGranted = (await _locationService.requestPermission());
        if (_permissionGranted!.index == 0) {
          locationData = await _locationService.getLocation();
          enableLocationSubscription();
        }
      } else {
        bool serviceRequestGranted = await _locationService.requestService();
        if (serviceRequestGranted) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message!;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message!;
      }
      //locationData = null;
    }

    setState(() {
      initialLocation = locationData!;
    });
  }

  enableLocationSubscription() async {

    _locationSubscription =
        _locationService.onLocationChanged.listen((LocationData result) async {
      if (mounted) {
        setState(() {
          _currentLocation = result;

          markers.clear();
          MarkerId markerId1 = MarkerId("Current");
          Marker marker1 = Marker(
            markerId: markerId1,
            //   position: LatLng(17.385044, 78.486671),
            position: LatLng(
                result.latitude ?? 17.385044, result.longitude ?? 78.486671),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
          //   markers[markerId1]=marker1;
          setState(() {
            markers.add(marker1);
          });

          //animateCamera(markers);
          animateLiveCamera(result);
        });
      }
    });
  }

  slowRefresh() async {
    if (_locationSubscription != null) _locationSubscription.cancel();
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.balanced, interval: 10000);
    enableLocationSubscription();
  }

  Future<void> _startTrack() async {
    initPlatformState();
    setState(() {
      updateStarted = true;
    });
   // locationServiceClass.onStartService();
  }

  Future<void> _stopTrack() async {
    if (_locationSubscription != null) _locationSubscription.cancel();

    setState(() {
      updateStarted = false;
    });

//    locationServiceClass.onStopService();
  }

  animateCamera(marker1) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(marker1));
  }

  animateLiveCamera(LocationData loc) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
      zoom: 18.0,
    )));

    //  AppLog.e('Current location: \nlat: ${loc.latitude}\n  long: ${loc.longitude} ');
  }




}
