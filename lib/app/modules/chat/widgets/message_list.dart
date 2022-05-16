import 'package:chat_app/app/modules/chat/controller.dart';
import 'package:chat_app/app/modules/chat/widgets/message_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageList extends StatelessWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    return Flexible(
      child: Obx(
        () => ListView.builder(
          reverse: true,
          itemBuilder: (ctx, idx) {
            return MessageItem(
                isSend: chatController.isMessageSend(idx),
                message: chatController.messages[idx]);
          },
          itemCount: chatController.messages.length,
        ),
      ),
    );
  }
}
