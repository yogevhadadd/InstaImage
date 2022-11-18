import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageRetrive extends StatefulWidget {
  final String? text;
  const ImageRetrive({Key? key, this.text}) : super(key: key);

  @override
  State<ImageRetrive> createState() => _ImageRetriveState(text);
}

class _ImageRetriveState extends State<ImageRetrive> {
  final String? text;

  String downloadURL = "";
  _ImageRetriveState(this.text){
    // FirebaseStorage.instance.ref().getDownloadURL().then((value) => downloadURL = value);

  }


  Widget build(BuildContext context) {
    //
    // FireStorageService.loadFromStorage(context, "text")
    //     .then((downloadUrl) {
    //   downloadURL = downloadUrl;
    // });

    return Opacity(opacity: 1,
      child: Scaffold(backgroundColor: Colors.white54,
        body: Ink.image(image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/instaimage-f6f3b.appspot.com/o/images%2F${text}?alt=media&toke")),
      ),
    );
  }
}


class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadFromStorage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}