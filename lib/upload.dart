import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:camera/camera.dart';


import 'camera_page.dart';

class ImageUpload extends StatefulWidget {
  final String? userId;
  final String? latLngaaaa;
  late final File? image;
  late final  CameraDescription? aaaaa;

  ImageUpload({Key? key, this.userId, this.latLngaaaa, this.image, this.aaaaa}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState(latLngaaaa);
}

class _ImageUploadState extends State<ImageUpload> {

  final imagePicker = ImagePicker();
  String? downloadURL;
  var latLng;
  num back = 2;
  // late  List<CameraDescription> cameras = <CameraDescription>[];
  _ImageUploadState(this.latLng);

  void initState() {
    aaa();
    super.initState();
  }
  aaa() async {
    final cameras = await availableCameras();
    widget.aaaaa = cameras.first;
  }
  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    print(pick?.path);
    setState(() {
      if (pick != null) {
        widget.image = File(pick.path);
        back = 1;
        // uploadImage();
      } else {
       showSnackBar("No File selected", Duration(milliseconds: 400));
      }
    });
  }
  Future uploadImage() async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(latLng.toString());
    await reference.putFile(widget.image!);
    downloadURL = await reference.getDownloadURL();
    CollectionReference aaaa = FirebaseFirestore.instance.collection('marker');

    await aaaa.add({
      'position': latLng.toString(),
      'downloadURL': downloadURL,
    });
  }
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    aaa();
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: widget.image == null
                    ?   Center( child:
                TakePictureScreen(camera: widget.aaaaa as CameraDescription, aaaaqqqa: latLng.toString() , ) )
                    : Image.file(widget.image!),
              ),
              // OutlinedButton(
              //       child: const Text(
              //         "Outlined Button",
              //         style: TextStyle(
              //           color: Colors.green,
              //         ),
              //       ),
              //       onPressed: () {imagePickerMethod(); },
              //     ),
              // Center(
              //   child: Row(children: [
              //     OutlinedButton(
              //       child: const Text(
              //         "Outlined Button",
              //         style: TextStyle(
              //           color: Colors.green,
              //         ),
              //       ),
              //       onPressed: () {imagePickerMethod(); },
              //     ),
              //     // ElevatedButton(onPressed: () {  imagePickerMethod();},  child:Container(height: 60, child: const Icon(Icons.add_a_photo),) ,),
              //     // // ElevatedButton(onPressed: () {   Cameraaa();},  child: const Icon(Icons.add_a_photo),),
              //     // ElevatedButton(onPressed: () {uploadImage(); int count = 0;
              //     // Navigator.of(context).popUntil((_) => count++ >= back) ;}
              //     // ,  child: Container(height: 60,child: const Icon(Icons.upload)),),
              //   ]),
              // )
            ],
          ),

        ),
        floatingActionButton: Row(
          children: [
            SizedBox(width: 30,),
            Visibility(
              visible: widget.aaaaa == null,
              child: FloatingActionButton(backgroundColor: Colors.black38,
                onPressed: () async { imagePickerMethod();},
                child: const Icon(Icons.sd_storage),
              ),
            ),
            SizedBox(width: 105,),
            Visibility(
              visible: widget.aaaaa == null,
              child: FloatingActionButton(backgroundColor: Colors.black38,
                  onPressed: () async {
                    TakePictureScreen(camera: widget.aaaaa as CameraDescription, aaaaqqqa: latLng.toString());
                  }
              ),
            ),
            SizedBox(width: 105,),
            Visibility(
              visible: widget.aaaaa == null,
              child:  FloatingActionButton(backgroundColor: Colors.black38,
                onPressed: () async {
                  try {
                    await uploadImage();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Icon(Icons.send),
              ),
            ),
          ],
        ),
    );
  }
}
