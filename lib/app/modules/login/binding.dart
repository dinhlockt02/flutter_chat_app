import 'package:google_sign_in/google_sign_in.dart';

import 'controller.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(googleSignIn: GoogleSignIn()));
  }
}
