import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test4/upload.dart';
//
// Future<void> Cameraaa() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();
//
//   // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;
//
//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: firstCamera,
//       ),
//     ),
//   );
// }

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  TakePictureScreen({
    super.key,
    required this.camera,
    required this.aaaaqqqa,
  });
  late final String aaaaqqqa;

  late final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final imagePicker = ImagePicker();
  File? image_path;

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
    print(pick?.path);
    setState(() async {
      if (pick != null) {
        image_path = File(pick.path);
        // back = 1;
        // uploadImage();
        await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImageUpload(
                image: image_path, latLngaaaa: widget.aaaaqqqa,
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
            return Container(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width, child: CameraPreview(_controller),) ;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),

      floatingActionButton: Row(
        children: [

          SizedBox(width: 30,),
          FloatingActionButton(backgroundColor: Colors.white54,
            onPressed: () async {imagePickerMethod();
            },
            child: const Icon(Icons.sd_storage),
          ),
          SizedBox(width: 105,),
          FloatingActionButton(backgroundColor: Colors.white54,
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final image = await _controller.takePicture();
                image_path = File(image.path);
                // Navigator.of(context).pop() ;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImageUpload(
                      image: image_path, latLngaaaa: widget.aaaaqqqa,
                    ),
                  ),
                );
                if (!mounted) return;

              } catch (e) {
                print(e);
              }
            },
          ),
          SizedBox(width: 105,),
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

