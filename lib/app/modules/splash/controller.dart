import 'package:chat_app/app/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final auth = FirebaseAuth.instance;

  Future<void> initialState() async {
    await Future.delayed(Duration(seconds: 1));
    if (auth.currentUser != null) {
      Get.offNamed(AppRoutes.HOME);
    } else {
      Get.offNamed(AppRoutes.LOGIN);
    }
  }
}
