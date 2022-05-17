import 'package:chat_app/app/routes/pages.dart';
import 'package:chat_app/app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'app/data/models/chat_user.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await registerNotification();
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      )));
}

registerNotification() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('chat_users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'token': token});
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? peerId) async {
    if (peerId == null || peerId.isEmpty) return;
    final chatUser = (await FirebaseFirestore.instance
            .collection('chat_users')
            .doc(peerId)
            .withConverter(
                fromFirestore: ChatUser.fromFirestore,
                toFirestore: (ChatUser chatuser, _) => chatuser.toFirestore())
            .get())
        .data();
    if (chatUser == null) return;
    if (Get.currentRoute == AppRoutes.CHAT) {
      Get.back();
    }
    Get.toNamed(AppRoutes.CHAT, arguments: chatUser);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final receiverId = message.data["receiverId"] as String;
    final senderId = message.data["senderId"] as String;
    var shouldShowNotification = true;
    if (Get.currentRoute == AppRoutes.CHAT) {
      final ChatUser? peerUser = Get.arguments;
      if (peerUser?.id == senderId) {
        shouldShowNotification = false;
      }
    }
    if (shouldShowNotification) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'messenger_channel',
        'Messenger channel',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      flutterLocalNotificationsPlugin.show(0, message.notification?.title ?? "",
          message.notification?.body ?? "", platformChannelSpecifics,
          payload: senderId);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    firebaseMessagingBackgroundHandler(message);
  });
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (FirebaseAuth.instance.currentUser != null) {
    final receiverId = message.data["receiverId"] as String;
    final senderId = message.data["senderId"] as String;
    if (senderId == null || senderId.isEmpty) return;
    final senderUser = (await FirebaseFirestore.instance
            .collection('chat_users')
            .doc(senderId)
            .withConverter(
                fromFirestore: ChatUser.fromFirestore,
                toFirestore: (ChatUser chatuser, _) => chatuser.toFirestore())
            .get())
        .data();
    if (senderUser == null) return;
    Get.toNamed(AppRoutes.CHAT, arguments: senderUser);
  }
}
