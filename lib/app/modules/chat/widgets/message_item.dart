import 'package:chat_app/app/data/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller.dart';

class MessageItem extends StatelessWidget {
  final bool isSend;
  final ChatMessage message;

  const MessageItem({Key? key, required this.isSend, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    if (isSend == true) {
      return Container(
        alignment: Alignment.centerRight,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 80),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 20.0),
                      child: Text(
                        message.message,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  CircleAvatar(
                    backgroundImage: chatController.currentUser.value != null
                        ? NetworkImage(
                            chatController.currentUser.value!.photoUrl)
                        : Image.asset('assets/images/anonymous-avatar.png')
                            .image,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                DateFormat.yMd().add_jm().format(message.timestamp.toDate()),
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: chatController.peerUser.value != null
                        ? NetworkImage(chatController.peerUser.value!.photoUrl)
                        : Image.asset('assets/images/anonymous-avatar.png')
                            .image,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(right: 80),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 20.0),
                      child: Text(
                        message.message,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                DateFormat.yMd().add_jm().format(message.timestamp.toDate()),
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      );
    }
    ;
  }
}
