import 'package:chat_app/app/modules/home/controller.dart';
import 'package:chat_app/app/modules/login/controller.dart';
import 'package:chat_app/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      final homeController = Get.find<HomeController>();
      homeController.initState();
    });
  }

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
