import 'package:chat_app/app/modules/home/controller.dart';
import 'package:chat_app/app/modules/login/controller.dart';
import 'package:chat_app/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat Home'),
          actions: [
            IconButton(
                onPressed: () {
                  homeController.signout();
                },
                icon: Icon(Icons.logout)),
            IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.PROFILE);
                },
                icon: Icon(Icons.person))
          ],
        ),
        body: Obx(
          () => ListView.separated(
            itemBuilder: ((ctx, idx) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          homeController.otherUserList[idx].photoUrl),
                    ),
                    title: Text(homeController.otherUserList[idx].displayName),
                    onTap: () => homeController.navigateToChatScreen(
                        homeController.otherUserList[idx]),
                  ),
                )),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: homeController.otherUserList.length,
          ),
        ));
  }
}
