import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/chat_user.dart';

class ProfileController extends GetxController {
  final emailTextController = TextEditingController();
  final displayNameTextController = TextEditingController();
  final aboutMeTextController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final imagePicker = ImagePicker();
  Rx<ChatUser?> chatUser = Rx<ChatUser?>(null);
  RxString photoUrl = "".obs;
  late CollectionReference<ChatUser> chatUserCollectionRef;

  @override
  void onInit() async {
    super.onInit();

    chatUserCollectionRef = db.collection('chat_users').withConverter(
          fromFirestore: ChatUser.fromFirestore,
          toFirestore: (ChatUser user, options) => user.toFirestore(),
        );

    final chatUserDoc =
        await chatUserCollectionRef.doc(auth.currentUser?.uid).get();
    chatUser.value = chatUserDoc.data();
    photoUrl.value = chatUserDoc.data()?.photoUrl ?? "";
    emailTextController.text = chatUserDoc.data()?.email ?? "";
    displayNameTextController.text = chatUserDoc.data()?.displayName ?? "";
    aboutMeTextController.text = chatUserDoc.data()?.aboutMe ?? "";
  }

  @override
  void onClose() {
    super.onClose();
    emailTextController.dispose();
    displayNameTextController.dispose();
    aboutMeTextController.dispose();
  }

  Future<void> saveProfile() async {
    ChatUser? user = chatUser.value;
    if (user != null) {
      Get.closeAllSnackbars();
      await chatUserCollectionRef.doc(user.id).set(user.copyWith(
            email: emailTextController.text,
            displayName: displayNameTextController.text,
            aboutMe: aboutMeTextController.text,
            photoUrl: photoUrl.value,
          ));
      Get.snackbar('Save profile', 'Save successful');
    }
  }

  Future<void> changeAvatar() async {
    try {
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        cropStyle: CropStyle.circle,
      );
      if (croppedFile == null) return;
      final imageRef = storage
          .ref('images/${DateTime.now().toIso8601String() + image.name}');

      final data = await croppedFile.readAsBytes();
      await imageRef.putData(data);
      final downloadUrl = await imageRef.getDownloadURL();
      photoUrl.value = downloadUrl;
      Get.snackbar('Successful', 'Upload image successful');
    } on Exception catch (e) {
      Get.snackbar('Upload failed', e.toString());
    }
  }
}
