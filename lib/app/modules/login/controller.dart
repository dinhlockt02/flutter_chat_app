import 'dart:async';

import 'package:async/async.dart';
import 'package:chat_app/app/data/models/chat_user.dart';
import 'package:chat_app/app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
}

class LoginController extends GetxController {
  final GoogleSignIn googleSignIn;
  final status = AuthStatus.uninitialized.obs;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  CancelableOperation? signInWithGoogleCancellableFuture;

  ChatUser? chatUser;

  LoginController({required this.googleSignIn}) {
    status.listen((status) {
      if (auth.currentUser != null) {
        Get.offNamed(AppRoutes.HOME);
      }
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      status.value = AuthStatus.authenticating;
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      User? firebaseUser =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return;
      }
      await createUserIfNotExists(firebaseUser);
      final token = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance
          .collection('chat_users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'token': token});
      status.value = AuthStatus.authenticated;
    } on PlatformException catch (e) {
      status.value = AuthStatus.authenticateError;
      Get.snackbar('Signin Failed', e.message.toString());
      auth.signOut();
    }
  }

  Future<ChatUser?> createUserIfNotExists(User firebaseUser) async {
    final chatUserCollectionRef = db.collection('chat_users').withConverter(
          fromFirestore: ChatUser.fromFirestore,
          toFirestore: (ChatUser user, options) => user.toFirestore(),
        );
    final chatUserDoc = await chatUserCollectionRef.doc(firebaseUser.uid).get();
    if (!chatUserDoc.exists) {
      chatUser = ChatUser(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? "",
        displayName: firebaseUser.displayName ?? "",
        photoUrl: firebaseUser.photoURL ?? "",
        aboutMe: "",
      );
      await chatUserCollectionRef.doc(firebaseUser.uid).set(chatUser!);
    } else {
      chatUser = chatUserDoc.data();
    }
    return chatUser;
  }
}
