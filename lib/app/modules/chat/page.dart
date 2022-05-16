import 'package:chat_app/app/modules/chat/controller.dart';
import 'package:chat_app/app/modules/chat/widgets/message_input.dart';
import 'package:chat_app/app/modules/chat/widgets/message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      final chatController = Get.find<ChatController>();
      chatController
          .fetchGroupChatData()
          .then((_) => chatController.getChatMessage());
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    chatController.peerUser.value = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(chatController.peerUser.value?.displayName ?? ""),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: chatController.peerUser.value != null
                  ? NetworkImage(chatController.peerUser.value!.photoUrl)
                  : Image.asset('assets/images/anonymous-avatar.png').image,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [MessageList(), MessageInput()],
        ),
      )),
    );
  }
}
