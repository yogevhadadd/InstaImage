import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:camera/camera.dart';


import 'images/camera_page.dart';

class ImageUpload extends StatefulWidget {
  final String positionString;
  late final File? image;
  late final  CameraDescription? cameraDescription;

  ImageUpload({Key? key, required this.positionString, this.image, this.cameraDescription}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {

  final imagePicker = ImagePicker();
  String? downloadURL;
  num back = 2;

  void initState() {
    // initCamera();
    super.initState();
  }
  initCamera() async {
    final cameras = await availableCameras();
    widget.cameraDescription = cameras.first;
  }
  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        widget.image = File(pick.path);
        back = 1;
      }
      else {
        showSnackBar("No File selected", const Duration(milliseconds: 400));
      }
    });
  }
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future uploadImage() async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(widget.positionString);
    await reference.putFile(widget.image!);
    downloadURL = await reference.getDownloadURL();
    CollectionReference newImage = FirebaseFirestore.instance.collection('marker');

    await newImage.add({
      'position': widget.positionString,
      'downloadURL': downloadURL,
    });
  }

  @override
  Widget build(BuildContext context) {
    // aaa();
    return Scaffold(
        body:  widget.image == null
            ?   Center( child:
         TakePictureScreen(camera: widget.cameraDescription as CameraDescription, positionString: widget.positionString , ) )
            : Image.file(widget.image!),


        floatingActionButton: Row(
          children: [
            const SizedBox(width: 30,),
            Visibility(
              visible: widget.cameraDescription == null,
              child: FloatingActionButton(backgroundColor: Colors.black38,
                onPressed: () async { imagePickerMethod();},
                child: const Icon(Icons.sd_storage),
              ),
            ),
            const SizedBox(width: 105,),
            Visibility(
              visible: widget.cameraDescription == null,
              child: FloatingActionButton(backgroundColor: Colors.black38,
                  onPressed: () async {
                    TakePictureScreen(camera: widget.cameraDescription as CameraDescription, positionString: widget.positionString);
                  }
              ),
            ),
            const SizedBox(width: 105,),
            Visibility(
              visible: widget.cameraDescription == null,
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
