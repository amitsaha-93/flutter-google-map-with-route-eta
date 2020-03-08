import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong/latlong.dart' as lt;
import 'dart:ui' as ui;

import 'package:location/location.dart';
import 'package:show_route_eta/model/EstimationTimeResponse.dart';
import 'package:wakelock/wakelock.dart';

const Color violet = Color(0xff4150B5);
const Color green = Color(0xffC6D74C);
const Color grey = Color(0xffA8A8AA);

class MovingCarScreen extends StatefulWidget {
  @override
  _MovingCarScreenState createState() => _MovingCarScreenState();
}

class _MovingCarScreenState extends State<MovingCarScreen> {
  BitmapDescriptor markerIcon, carIcon;

  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(
      apiKey: "AIzaSyAHfsLtAUy2rfI-zZ8gKI-CGr4Vl4Q44cM");

  Set<Marker> markers = Set();
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = Set<Polyline>();

  Marker endMarker, carMarker;

  GoogleMapController _controller;
  LocationData carCurrLocData;
  Location location;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool isDialogOpen = false;

  int elapsed;
  double t;
  bool isFirst = true;

  int durationInMs = 800;
  LatLng currLoc;
  LocationData current;

  LocationData old;
  String timeLeft = "";

//  int oldMills;

  DriveStatus driveStatus = DriveStatus.onway;

  createMarkerIcons() async {
    var s = await getBytesFromAsset("assets/marker.png", 100);
    markerIcon = await BitmapDescriptor.fromBytes(s);

    var c = await getBytesFromAsset("assets/car_icon.png", 32);
    carIcon = await BitmapDescriptor.fromBytes(c);
  }

  void getCordinates(LatLng l) async {
    polylineCoordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: l,
        destination: LatLng(23.8451172, 90.4082837),
        mode: RouteMode.driving);

    if (polylineCoordinates != null && polylineCoordinates.isNotEmpty) {
      endMarker = Marker(
          markerId: MarkerId("end"),
          position: polylineCoordinates[polylineCoordinates.length - 1],
          icon: markerIcon);

      carCurrLocData = LocationData.fromMap({
        "latitude": polylineCoordinates[0].latitude,
        "longitude": polylineCoordinates[0].longitude
      });
      carMarker = Marker(
          markerId: MarkerId("car"),
          position: polylineCoordinates[0],
          anchor: Offset(0.5, 0.5),
          icon: carIcon,
          rotation: carCurrLocData.heading);
    }

    setState(() {
      markers.add(endMarker);
      markers.add(carMarker);

      _polylines.add(Polyline(
          width: 5, // set the width of the polylines
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates));
    });
  }

  void getCordinatesFromLatLng(LatLng latLng) async {
    polylineCoordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: latLng,
        destination: LatLng(23.8451172, 90.4082837),
        mode: RouteMode.driving);

    if (polylineCoordinates != null && polylineCoordinates.isNotEmpty) {
      _polylines.clear();
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });

    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    location = new Location();
    getlocation();

    location.onLocationChanged().listen((LocationData cLoc) {
      if (_controller != null) {
        getCordinatesFromLatLng(LatLng(cLoc.latitude, cLoc.longitude));

        _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(cLoc.latitude, cLoc.longitude),
            zoom: 17.0,
          ),
        ));
      }

      if (old != null) {
//        print("oldTime: $oldMills");
//        durationInMs = DateTime.now().millisecondsSinceEpoch - oldMills;
//        print("durationInMs: $durationInMs");
        calTimeLeft(cLoc);
        _animateMarker(old, cLoc, DateTime.now().millisecondsSinceEpoch);
      }

      old = cLoc;
//      oldMills = DateTime.now().millisecondsSinceEpoch;
    });
  }

  Future<Void> calTimeLeft(LocationData cLoc) {
    if (polylineCoordinates!=null && polylineCoordinates.isNotEmpty) {
      updateTime(
          cLoc.latitude,
          cLoc.longitude,
          polylineCoordinates.last.latitude,
          polylineCoordinates.last.longitude);
    }
  }

  openArrivedDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        // return alert dialog object
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: 250,
            height: 250,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Transform.rotate(
                  angle: 90,
                    child: Image.asset("assets/car_icon.png", width: 100, height: 100,)
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Hi!!",
                    style: TextStyle(
                        color: violet,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Text(
                  "You have arrived to the destination",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: grey,
                      fontSize: 22,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    t = 2;
  }

  _animateMarker(LocationData startLoc, LocationData finalLoc, int startMills) {
    elapsed = DateTime.now().millisecondsSinceEpoch - startMills;
    t = elapsed / durationInMs;

    currLoc = new LatLng(t * finalLoc.latitude + (1 - t) * startLoc.latitude,
        t * finalLoc.longitude + (1 - t) * startLoc.longitude);

    print("currentPosition: ${currLoc.latitude}\n${t}");

    setState(() {
      markers.toList().removeAt(1);
      markers.add(Marker(
          markerId: MarkerId("car"),
          position: currLoc,
          anchor: Offset(0.5, 0.5),
          icon: carIcon,
          rotation: finalLoc.heading));
    });

    if (t < 1) {
      Future.delayed(Duration(microseconds: 50)).then((val) {
        _animateMarker(startLoc, finalLoc, startMills);
      });
    }
  }

  Future<void> updateTime(double sourceLat, double sourceLong, double destLat, double destLong) async {
    Dio dio = new Dio();
    Response response = await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$sourceLat,$sourceLong&destinations=$destLat,$destLong&key=AIzaSyAHfsLtAUy2rfI-zZ8gKI-CGr4Vl4Q44cM");
    if(response!=null) {
      var encodedRes = json.encode(response.data);
      Map parsedJson = json.decode(encodedRes);
      var resp = EstimationTimeResponse.fromJson(parsedJson);
      print("check post 1");
      if(resp.status=="OK") {
        print("check post 2");
        var r = resp.rows;
        if(r!=null && r.isNotEmpty && r[0].elements!=null && r[0].elements.isNotEmpty) {
          print("Estimation time: ${response.data}");
          setState(() {
            timeLeft = r[0].elements[0].duration.text;
          });
        }
      }
    }
  }

  double screenWidth = 720;
  double screenHeight = 1280;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: violet,
        leading: Icon(Icons.arrow_back_ios, color: Colors.white,),
      ),
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                polylines: Set<Polyline>.of(_polylines),
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                trafficEnabled: false,
                mapToolbarEnabled: true,
                tiltGesturesEnabled: true,
                markers: markers,
                compassEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(23.8331548, 90.4152883),
                  zoom: 17.0,
                ),
                onMapCreated: (GoogleMapController controller) async {
                  _controller = controller;
                  await createMarkerIcons();
                  //  getCordinates();
                },
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: Offset(0.5, 2),
                      )
                    ]
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: violet, width: 2)),
                        child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            "assets/user_image.jpg",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Mr. Abedin",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),

                            Text(
                              timeLeft.isNotEmpty? "Estimation Time: $timeLeft": "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 80,
                          height: 28,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: (driveStatus == DriveStatus.onway) ? green : violet),
                          child: Center(
                            child: Text(
                              (driveStatus == DriveStatus.onway) ? "on way":"arrived",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


void getlocation() async {
  location = new Location();
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.DENIED) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.GRANTED) {
      return;
    }
  }

  _locationData = await location.getLocation();
  location.onLocationChanged().listen((LocationData cLoc) {
    if (_controller != null && cLoc != null) {
      currLoc = LatLng(cLoc.latitude, cLoc.longitude);
      if (isFirst) {
        getCordinates(LatLng(cLoc.latitude, cLoc.longitude));
        isFirst = false;
      }
      getCordinatesFromLatLng(LatLng(cLoc.latitude, cLoc.longitude));

      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(cLoc.latitude, cLoc.longitude),
          zoom: 17.0,
        ),
      ));
    }
    final lt.Distance distance = new lt.Distance();


    var meter = distance(
        new lt.LatLng(cLoc.latitude,cLoc.longitude),
        new lt.LatLng(23.8451172, 90.4082837)
    );
    if(meter<=30){
      if(!isDialogOpen){
        isDialogOpen = true;
        openArrivedDialog();
      }
    }

    if (old != null) {
//        print("oldTime: $oldMills");
//        durationInMs = DateTime.now().millisecondsSinceEpoch - oldMills;
//        print("durationInMs: $durationInMs");
      _animateMarker(old, cLoc, DateTime
          .now()
          .millisecondsSinceEpoch);
    }

    old = cLoc;
//      oldMills = DateTime.now().millisecondsSinceEpoch;
  });
  location.onLocationChanged();
}


}

enum DriveStatus {
  onway, arrived, none
}