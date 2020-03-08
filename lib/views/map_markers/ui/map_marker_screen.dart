//import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:map_design/component/mark_creater.dart';
//import 'package:permission_handler/permission_handler.dart';
//
//class MapMarkerScreen extends StatefulWidget {
//  @override
//  _MapMarkerScreenState createState() => _MapMarkerScreenState();
//}
//
//class _MapMarkerScreenState extends State<MapMarkerScreen> {
//
//  BitmapDescriptor marker ;
//  Set<Marker> markers = Set();
//  var size = Size(80, 140);
//  PermissionStatus permission;
//
//  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
//
//  void  setMarkers() async{
//    var car = await saveImage(Image.asset("assets/marker.png"));
//    marker = await getMarkerIcon(car,size,"Mia");
//    markers.add(Marker(
//      infoWindow: InfoWindow(title: "Mia"),
//        icon: marker,
//        markerId: MarkerId('value1'),
//        position: LatLng(23.834152, 90.418068)));
//
// marker = await getMarkerIcon(car,size,"Mlai");
//    markers.add(Marker(
//      infoWindow: InfoWindow(title: "Mlai"),
//        icon: marker,
//        markerId: MarkerId('value2'),
//        position: LatLng(23.834776, 90.417226)));
//
//    marker = await getMarkerIcon(car,size,"Tom");
//    markers.add(Marker(
//      infoWindow: InfoWindow(title: "Tom"),
//        icon: marker,
//        markerId: MarkerId('value3'),
//        position: LatLng(23.834381, 90.416964)));
//
//
//    marker = await getMarkerIcon(car,size,"Arun");
//    markers.add(Marker(
//      infoWindow: InfoWindow(title: "Arun"),
//        icon: marker,
//        markerId: MarkerId('value4'),
//        position: LatLng(23.834353, 90.414456)));
//
//
//    marker = await getMarkerIcon(car,size,"Fora");
//    markers.add(Marker(
//      infoWindow: InfoWindow(title: "Fora"),
//        icon: marker,
//        markerId: MarkerId('value5'),
//        position: LatLng(23.832820, 90.416734)));
//
//
//    marker = await getMarkerIcon(car,size,"kira");
//    markers.add(Marker(
//      infoWindow: InfoWindow(title: "kira"),
//        icon: marker,
//        markerId: MarkerId('value6'),
//        position: LatLng(23.832208, 90.417439)));
//
//
//
//    setState(() {
//
//
//    });
//
//
//  }
//
//  @override
//  void initState() {
//    super.initState();
//   // setMarkers();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return  MaterialApp(
//      home: Scaffold(
//        key: _scaffoldKey,
//        body: GoogleMap(
//          indoorViewEnabled: true,
//          onMapCreated: (c){
//            setMarkers();
//          },
//          myLocationEnabled: true,
//          myLocationButtonEnabled: true,
//          trafficEnabled: false,
//          mapToolbarEnabled: true,
//          tiltGesturesEnabled: true,
//          markers: markers,
//          compassEnabled: true,
//          initialCameraPosition: CameraPosition(
//            target: LatLng(
//                23.834152, 90.418068),
//            zoom: 17.0,
//          ),
//
//        ),
//      ),
//    );
//  }
//
//
//  void fetchLocation() {
//    checkLocationPermission()?.then((permissionGranted) {
//      if (permissionGranted) {
//       // do here permission granted for location
//      } else {
//        _scaffoldKey.currentState.showSnackBar(
//          SnackBar(
//            content: Text('Please allow permission to access location.'),
//            action: SnackBarAction(
//                label: 'Open Setting',
//                onPressed: () {
//                  PermissionHandler().openAppSettings();
//                }),
//          ),
//        );
//      }
//    });
//  }
//
//  Future<bool> checkLocationPermission() async {
//    permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.location);
//    if (permission == PermissionStatus.denied) {
//      var permissionsResult = await PermissionHandler()
//          .requestPermissions([PermissionGroup.location]);
//      if (permissionsResult.values.length > 0 &&
//          permissionsResult.values.elementAt(0) == PermissionStatus.granted) {
//        return true;
//      } else {
//        return await PermissionHandler()
//            .shouldShowRequestPermissionRationale(PermissionGroup.location);
//      }
//    } else {
//      return true;
//    }
//  }
//}
//
