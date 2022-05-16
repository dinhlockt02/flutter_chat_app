import 'package:chat_app/app/modules/profile/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => GestureDetector(
                    child: CircleAvatar(
                      radius: 54,
                      backgroundImage:
                          NetworkImage(profileController.photoUrl.value),
                    ),
                    onTap: () {
                      profileController.changeAvatar();
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  controller: profileController.emailTextController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Display name',
                  ),
                  controller: profileController.displayNameTextController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'About me',
                  ),
                  controller: profileController.aboutMeTextController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    profileController.saveProfile();
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      profileController.saveProfile();
                    },
                    child: const Text("SAVE"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
