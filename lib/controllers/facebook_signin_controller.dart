import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInController with ChangeNotifier {
  Map? userData;

  login() async {
    var result = await FacebookAuth.instance.login(
      permissions: ["public_profile", "email"],
    );

    // check the status of our login
    if (result.status == LoginStatus.success) {
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email, name, picture",
      );

      userData = requestData;

      notifyListeners();
    }
  }

  // logout
  logout() async {
    // await FacebookAuth.instance.logOut();
    // userData = null;
    // notifyListeners();
  }
}
