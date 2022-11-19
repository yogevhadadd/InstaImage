import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test4/upload.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
    required this.positionString,
  });
  final String positionString;
  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final imagePicker = ImagePicker();
  File? imagePath;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() async {
      if (pick != null) {
        imagePath = File(pick.path);
        await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImageUpload(
                image: imagePath, positionString: widget.positionString,
              ),
            ));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width, child: CameraPreview(_controller),) ;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),

      floatingActionButton: Row(
        children: [

          const SizedBox(width: 30,),
          FloatingActionButton(backgroundColor: Colors.white54,
            onPressed: () async {imagePickerMethod();
            },
            child: const Icon(Icons.sd_storage),
          ),
          const SizedBox(width: 105,),
          FloatingActionButton(backgroundColor: Colors.white54,
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final image = await _controller.takePicture();
                imagePath = File(image.path);
                // Navigator.of(context).pop() ;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImageUpload(
                      image: imagePath, positionString: widget.positionString,
                    ),
                  ),
                );
                if (!mounted) return;

              } catch (e) {
                print(e);
              }
            },
          ),
          const SizedBox(width: 105,),
          FloatingActionButton(backgroundColor: Colors.black38,
            onPressed: () async {
              } ,
            child: const Icon(Icons.send),
          ),
        ],
      )
    );
  }
}

