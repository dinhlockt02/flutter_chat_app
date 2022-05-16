import 'package:chat_app/app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/chat_user.dart';

class HomeController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final otherUserList = <ChatUser>[].obs;

  HomeController() {
    auth.authStateChanges().listen((user) {
      if (user == null) {
        Get.offNamed(AppRoutes.LOGIN);
      }
    });
    fetchOtherUser();
  }

  Future<void> signout() async {
    auth.signOut();
    GoogleSignIn().signOut();
  }

  Future<void> fetchOtherUser() async {
    final chatUserRef = db.collection('chat_users').withConverter(
          fromFirestore: ChatUser.fromFirestore,
          toFirestore: (ChatUser user, options) => user.toFirestore(),
        );
    final userListDocs = (await chatUserRef.get()).docs;
    otherUserList.value = userListDocs
        .map((doc) => doc.data())
        .where((user) => user.id != auth.currentUser?.uid)
        .toList();
  }

  void navigateToChatScreen(ChatUser user) {
    Get.toNamed(AppRoutes.CHAT, arguments: user);
  }
}
