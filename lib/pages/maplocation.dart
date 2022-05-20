import 'dart:async';

import 'package:background_locator/location_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hnh_flutter/pages/location/location_background_service_class.dart';
import 'package:hnh_flutter/repository/retrofit/api_client.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_style/colors.dart';
import '../custom_style/strings.dart';

class MapLocation extends StatefulWidget {
  final MapLocationStateful myAppState = new MapLocationStateful();

  @override
 State<MapLocation> createState() => MapLocationStateful();

  void setUpdateLocation(LocationDto data) {
     myAppState.updateLocationData(data);

  }





}

class MapLocationStateful extends State<MapLocation> {


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
  LocationServiceClass locationServiceClass = new LocationServiceClass();
   LocationDto? _updatedLocationDTO;

  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController accuracyController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  String userToken='';

  @override
  void initState() {
    super.initState();
    _locationService.requestPermission();
    locationServiceClass.initState(this);

    locationServiceClass
        .checkCheckService()
        .then((value) => {
          updateStarted = value


    });


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
     // _updatedLocationDTO =null;
    });

    updateUserTokenValue();

  }

  @override
  Widget build(BuildContext context) {

    print('l....lat=${_updatedLocationDTO}');

  /*  latitudeController.text= _updatedLocationDTO  != null ? '${_updatedLocationDTO!.latitude}' :'Failed';
    longitudeController.text= _updatedLocationDTO  != null ? '${_updatedLocationDTO!.longitude}' :'Failed';
    accuracyController.text= _updatedLocationDTO  != null ? '${_updatedLocationDTO!.accuracy}' :'Failed';
    speedController.text= _updatedLocationDTO  != null ? '${_updatedLocationDTO!.speed}' :'Failed';
 */  // latitudeController.text=_currentLocation  != null ? '${_currentLocation!.latitude}' :'Failed';



    return new Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          "Flutter Track Location",
          style: TextStyle(color: Colors.white),
        ),
        /* actions: [
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
        ],*/
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0.0),

        child: Stack(
          children: [
            Visibility(
                visible: false,
                child: GoogleMap(
                  mapType: maptype,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: markers,
                )),
            SingleChildScrollView(
              child: Container(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          color: primaryColor,
                          /*    child: new Text(
                      _currentLocation != null
                          ? 'Current location: \nlat: ${_currentLocation!.latitude}\n  long: ${_currentLocation!.longitude} '
                          : 'Error: $error\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.pink, fontSize: 20),
                    ),*/

                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1,
                              right: 35,
                              left: 35),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,

                                child: Text(

                                  "Service Started",
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 30,),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Latitude:",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              TextField(

                                controller: latitudeController,
                                decoration: new InputDecoration(
                                    filled: true,
                                    fillColor: Colors.green.shade100,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade100,
                                            width: 5.0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade100,
                                            width: 5.0))),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Longitude:",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              TextField(
                                controller: longitudeController,

                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.green.shade100,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade100,
                                            width: 5.0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade100,
                                            width: 5.0))),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Accuracy:",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              TextField(
                                controller: accuracyController,

                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.green.shade100,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade100,
                                            width: 5.0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade100,
                                            width: 5.0))),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Speed:",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              TextField(
                                controller: speedController,

                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.green.shade100,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade100,
                                            width: 5.0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green.shade100,
                                            width: 5.0))),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: ElevatedButton(
                                    child: Text(!updateStarted ? 'Start Track!' : 'Stop Track'),

                                    onPressed: !updateStarted ? _startTrack : _stopTrack,
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(300, 50),
                                        primary:  !updateStarted ? Colors.blue : Colors.red,

                                        padding: EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(32.0)),
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal)),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: ElevatedButton(
                                    child: const Text('Logout'),
                                    onPressed: () {
                                      logoutUser(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(300, 50),
                                        primary: Colors.black54,
                                        padding: EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(32.0)),
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal)),
                                  )),
                              SizedBox(
                                height: 10,
                              ),


                            ],
                          )))),
            )

            /*Align(
                alignment: Alignment.bottomCenter,
                child: Container(

                  color: Colors.white60,
                   child: new Text(

                     locationData != null
                        ? 'Current location: \nlat: ${locationData!.latitude}\n  long: ${locationData!.longitude} '
                        : 'Error: $error\n',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.pink, fontSize: 20),
                  ),


                ))*/
          ],
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

          //**animateCamera(markers);
        //  animateLiveCamera(result);
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
    //Enable location Service foreground
    locationServiceClass.onStartService();
  }

  Future<void> _stopTrack() async {
    if (_locationSubscription != null) _locationSubscription.cancel();

    setState(() {
      updateStarted = false;
    });

    locationServiceClass.onStopService();
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

  void updateLocationData(LocationDto? data) {

    _updatedLocationDTO = data;
     print('gettting....lat=${_updatedLocationDTO!.latitude}');
    latitudeController.text= _updatedLocationDTO  != null ? '${_updatedLocationDTO!.latitude}' :'Failed';
    longitudeController.text= _updatedLocationDTO  != null ? '${_updatedLocationDTO!.longitude}' :'Failed';
    accuracyController.text= _updatedLocationDTO  != null ? '${_updatedLocationDTO!.accuracy}' :'Failed';
    speedController.text= _updatedLocationDTO  != null ? '${_updatedLocationDTO!.speed}' :'Failed';
    print('gettting....lng=${longitudeController.text}');

  }



  Future<String?> getUserToken() async {
    final pref = await SharedPreferences.getInstance() ;
    return pref.getString(ConstantData.pref_user_token);
  }




  void updateUserTokenValue() {
    getUserToken().then((value) {
      setState(() {
        userToken = value!; // Future is completed with a value.
      });
    });
  }





  FutureBuilder<void> logoutUser(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(
        contentType: "application/json",
        headers: {
          'Content-Type': 'application/json',
          'Authorization':'bearer ${userToken}'

        }

    )));
    return FutureBuilder<void>(
      future: client.logout(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData ) {
            return Center();
          } else {
            return Center(
            );
          }
        } else {
          return Center();
        }
      },
    );
  }

}
