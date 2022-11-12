import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/login_controller.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../setting/setting.dart';



class MapPage extends StatefulWidget {
  final LoginController myParam;
  const MapPage(this.myParam, {super.key});
  @override
  State<MapPage> createState() => _MyMapState(this.myParam);
}

class _MyMapState extends State<MapPage> {
  _MyMapState(this.myParam);
  final LoginController myParam;



  LatLng? latLnga;
  // BitmapDescriptor d = BitmapDescriptor.defaultMarker;
  // late Position a;
  final Completer<GoogleMapController> _controller = Completer();
  late  CameraPosition _kGoogle = CameraPosition(target: LatLng(0, 0));
  final List<Marker> _markers = <Marker>[];

  void initState() {
    // setMarker();
    setLocation();

    super.initState();
  }

  // void setMarker(){
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/fb.png").then((value)
  //   => {
  //     d = value,
  //   }
  //   );
  // }

  void addMarker(x,y){
    _markers.add(const Marker(
      markerId: MarkerId("3"),
      position: LatLng(51, 51),
      infoWindow: InfoWindow(
        title: 'My Current Location',
      ),),);
    _markers.add(const Marker(
      markerId: MarkerId("4"),
      position: LatLng(41, 41),
      infoWindow: InfoWindow(
        title: 'My Current Location',
      ),),);
    _markers.add(const Marker(
      markerId: MarkerId("5"),
      position: LatLng(31, 31),
      infoWindow: InfoWindow(
        title: 'My Current Location',
      ),),);
    _markers.add(const Marker(
      markerId: MarkerId("6"),
      position: LatLng(21, 21),
      infoWindow: InfoWindow(
        title: 'My Current Location',
      ),),);
    _markers.add(const Marker(
      markerId: MarkerId("7"),
      position: LatLng(11, 11),
      infoWindow: InfoWindow(
        title: 'My Current Location',
      ),),);
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
          markerId: const MarkerId("1"),
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
                Image.network(myParam.userDetails!.photoURL ?? "").image,
                radius: 22,
              ),
              const SizedBox(width: 15,),
              Text(myParam.userDetails!.displayName ?? ""),
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
        body: GoogleMap(
          mapType: MapType.normal,
          markers: Set<Marker>.of(_markers),
          initialCameraPosition: _kGoogle,
          myLocationEnabled: true,
          compassEnabled: true,
          onTap: (LatLng latLng) {
            latLnga = latLng
            // you have latitude and longitude here
            var latitude = latLng.latitude;
            var longitude = latLng.longitude;
          },
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton(
           onPressed: () { addMarker();},
        ),
      ),
    );
  }
}