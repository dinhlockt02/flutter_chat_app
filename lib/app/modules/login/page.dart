import 'package:async/async.dart';
import 'package:chat_app/app/modules/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    return Scaffold(
      appBar: AppBar(title: Text("Chat Login")),
      body: Obx(
        () => Center(
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: 54,
              child: SignInButton(
                Buttons.Google,
                onPressed: () {
                  loginController.signInWithGoogle();
                },
              ),
            ),
            if (loginController.status.value == AuthStatus.authenticating)
              Dialog(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 8,
                      ),
                      Text("Loading"),
                    ],
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
