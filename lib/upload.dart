import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'image_retrive.dart';

class ImageUpload extends StatefulWidget {
  final String? userId;
  final String? latLngaaaa;

  const ImageUpload({Key? key, this.userId, this.latLngaaaa}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState(latLngaaaa);
}

class _ImageUploadState extends State<ImageUpload> {
  final imagePicker = ImagePicker();
  File? _image;
  String? downloadURL;
  var latLng;
  _ImageUploadState(this.latLng){
    print(latLng);
    print("fffffffffffffffffffffff");
  }

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    print(pick?.path);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
       showSnackBar("No File selected", Duration(milliseconds: 400));
      }
    });
  }

  Future uploadImage() async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(latLng.toString());
    await reference.putFile(_image!);
    downloadURL = await reference.getDownloadURL();
    print(downloadURL);
    await firebaseFirestore
         .collection("users")
         .doc(widget.userId)
        .collection("images")
        .add({'downloadURL': downloadURL})
    .whenComplete(
            () => showSnackBar("Image Uploaded", Duration(seconds: 2))
    );
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
               title: const Text("Upload Image "),
             ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
                       child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                              height: 500,
                              width: double.infinity,
                              child: Column(children: [
                                const Text("Upload Image"),
                                const SizedBox(
                                  height: 10,
                                ),
                              Expanded(
                                      flex: 4,
                                      child: Container(
                                        width: 300,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.red),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // the image that we wanted to upload
                                              Expanded(
                                                  child: _image == null
                                                  ? const Center(
                                                   child: Text("No image selected"))
                                                      : Image.file(_image!),
                                        ),
                                              ElevatedButton(onPressed: () {  imagePickerMethod();}, child: Text("asd"),),
                                              ElevatedButton(onPressed: () { uploadImage() ;}, child: Text("upload"),),
                                              ElevatedButton(onPressed: () { Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                           builder: (context) =>
                                                ImageRetrive(text: 'post_1668376106262')));
                                               },  child: Text("uplodad"), ),
                                            ],
                                        )),
                                      ),
                                    ),
                              ]
                          ),
                      ),

          ),
        ),
      ),
    );
  }

}
