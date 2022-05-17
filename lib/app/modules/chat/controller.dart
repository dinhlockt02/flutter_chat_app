import 'dart:async';

import 'package:async/async.dart';
import 'package:chat_app/app/data/models/chat_message.dart';
import 'package:chat_app/core/values/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/chat_user.dart';

class ChatController extends GetxController {
  final peerUser = Rx<ChatUser?>(null);
  final currentUser = Rx<ChatUser?>(null);
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final messageInputController = TextEditingController();
  final groupChatId = "".obs;
  final messages = <ChatMessage>[].obs;

  // Stream<QuerySnapshot> getChatMessage(String group)

  Future<void> fetchGroupChatData() async {
    if (auth.currentUser == null || peerUser.value == null) {
      Get.snackbar('Error', 'User not found');
      return;
    }
    try {
      final documentRef = db
          .collection(AppConsts.FirebaseChatRoomCollection)
          .where('memberIds.${auth.currentUser!.uid}', isEqualTo: true)
          .where('memberIds.${peerUser.value!.id}', isEqualTo: true);
      final docs = (await documentRef.get()).docs;
      if (docs.isNotEmpty) {
        final document = docs.first;
        groupChatId.value = document.id;
      } else {
        StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
            subscriptionStream;
        subscriptionStream = documentRef.snapshots().listen((event) {
          if (event.docs.isNotEmpty) {
            groupChatId.value = event.docs.first.id;
            getChatMessage();
            subscriptionStream?.cancel();
          }
        });
      }

      final chatUserCollectionRef = db.collection('chat_users').withConverter(
            fromFirestore: ChatUser.fromFirestore,
            toFirestore: (ChatUser user, options) => user.toFirestore(),
          );
      final chatUserDoc =
          await chatUserCollectionRef.doc(auth.currentUser?.uid).get();
      currentUser.value = chatUserDoc.data();
    } on Exception catch (e) {
      Get.snackbar('Error', 'An error occur');
    }
  }

  void getChatMessage() {
    if (groupChatId.value.isEmpty) {
      return;
    }
    db
        .collection(AppConsts.FirebaseChatRoomCollection)
        .doc(groupChatId.value)
        .collection('messages')
        .withConverter(
          fromFirestore: ChatMessage.fromFirestore,
          toFirestore: (ChatMessage chatmsg, options) => chatmsg.toFirestore(),
        )
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen(
      (event) {
        messages.value =
            event.docs.map((docsnapshot) => docsnapshot.data()).toList();
      },
    );
  }

  void sendChatMessage() {
    final message = messageInputController.text;
    final String? currentUserId = auth.currentUser?.uid;
    final String? peerId = peerUser.value?.id;
    if (message.isEmpty) return;
    if (currentUserId == null) return;
    if (peerId == null) return;
    if (groupChatId.value.isEmpty) {
      db.collection(AppConsts.FirebaseChatRoomCollection).doc().set({
        'memberIds': {auth.currentUser!.uid: true, peerUser.value!.id: true}
      }).then((_) {
        final documentReference = db
            .collection(AppConsts.FirebaseChatRoomCollection)
            .doc(groupChatId.value)
            .collection('messages')
            .withConverter(
              fromFirestore: ChatMessage.fromFirestore,
              toFirestore: (ChatMessage chatmsg, options) =>
                  chatmsg.toFirestore(),
            )
            .doc();
        final chatMessage = ChatMessage(
            id: documentReference.id,
            idFrom: currentUserId,
            idTo: peerId,
            message: message,
            timestamp: Timestamp.now());

        db.runTransaction((transaction) async {
          documentReference.set(chatMessage);
          messageInputController.text = "";
        });
      });
    } else {
      final documentReference = db
          .collection(AppConsts.FirebaseChatRoomCollection)
          .doc(groupChatId.value)
          .collection('messages')
          .withConverter(
            fromFirestore: ChatMessage.fromFirestore,
            toFirestore: (ChatMessage chatmsg, options) =>
                chatmsg.toFirestore(),
          )
          .doc();
      final chatMessage = ChatMessage(
          id: documentReference.id,
          idFrom: currentUserId,
          idTo: peerId,
          message: message,
          timestamp: Timestamp.now());

      db.runTransaction((transaction) async {
        documentReference.set(chatMessage);
        messageInputController.text = "";
      });
    }
  }

  bool isMessageSend(int idx) {
    return messages[idx].idFrom == auth.currentUser?.uid;
  }
}
