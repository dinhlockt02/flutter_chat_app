import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              cursorColor: Theme.of(context).cursorColor,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
              controller: chatController.messageInputController,
            ),
          ),
          IconButton(
              onPressed: () {
                chatController.sendChatMessage();
              },
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
