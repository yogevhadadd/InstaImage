import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../login/login_controller.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import '../images/image_retrive.dart';
import '../upload.dart';



class MapPage extends StatefulWidget {
  final LoginController myParam;
  const MapPage(this.myParam, {super.key});
  @override
  State<MapPage> createState() => _MyMapState();
}

class _MyMapState extends State<MapPage> {
  LatLng? position;
  final Completer<GoogleMapController> _controller = Completer();
  late  CameraPosition _kGoogle = const CameraPosition(target: LatLng(0, 0));
  final List<Marker> _markers = <Marker>[];
  late CameraDescription? cameraDescription;

  void initState() {
    setLocation();
    markers();
    initCamera();
    super.initState();
  }

  initCamera() async {
    final cameras = await availableCameras();
    cameraDescription = cameras.first;
    // Get a specific camera from the list of available cameras.
  }

  Future markers() async{
    await FirebaseFirestore.instance.collection('marker').get().then((value) =>
      value.docs.forEach((element) {
        final imagePosition =  element['position'].toString().split(",");
        addMarker(LatLng(double.parse(imagePosition[0]), double.parse(imagePosition[1])));
      })
    );
  }

  void addMarker(LatLng latLng){

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        onTap:() {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return GestureDetector(
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/instaimage-f6f3b.appspot.com/o/images%2F${latLng.latitude.toString()},${latLng.longitude.toString()}?alt=media&toke"

                     , width: 240,
                    ),
                    onTap: () {
                      var a = "${latLng.latitude},${latLng.longitude}";
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageRetrive(text: a)));

                    });
                  // Container(
                  //   decoration:  BoxDecoration(
                  //     image: DecorationImage(
                  //         fit: BoxFit.cover),
                  //   ),
                  // );
              });
          // showMarker(latLng);
        },
        ),);
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  void setLocation(){
    getUserCurrentLocation().then((value) async {
      _kGoogle = CameraPosition(target: LatLng(value.latitude, value.longitude));
      // marker added for current users location
      _markers.add(
        Marker(
          markerId: const MarkerId("My Uer"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(
            title: 'My Current Location',
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment(-.2, 0),
                            image: AssetImage("assets/fb.png"),
                            fit: BoxFit.cover),
                      ),
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 20),
                    ),);
                });
          },
        ),
      );

      // specified current users location
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future showMarker(LatLng latLng) {
    String img = "${latLng.latitude},${latLng.longitude}";
      return Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageRetrive(text: img)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title:Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage:
                Image.network(widget.myParam.userDetails!.photoURL ?? "").image,
                radius: 22,
              ),
              const SizedBox(width: 15,),
              Text(widget.myParam.userDetails!.displayName ?? ""),
            ]
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                Provider.of<LoginController>(context, listen: false).logout();
              },
            )
          ],
        ),
        body:GoogleMap(
          mapType: MapType.normal,
          markers: Set.from(_markers),
          initialCameraPosition: _kGoogle,
          myLocationEnabled: true,
          compassEnabled: true,
          onTap: (LatLng latLng) {
            position = latLng;
            String stringPosition = "${latLng.latitude},${latLng.longitude}";
            // addMarker(latLng);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageUpload(positionString: stringPosition, cameraDescription: cameraDescription as CameraDescription,)));
          },
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}