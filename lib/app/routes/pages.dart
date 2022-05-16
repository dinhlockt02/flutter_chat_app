import 'package:chat_app/app/modules/chat/page.dart';
import 'package:chat_app/app/modules/home/binding.dart';
import 'package:chat_app/app/modules/home/page.dart';
import 'package:chat_app/app/modules/login/binding.dart';
import 'package:chat_app/app/modules/login/page.dart';
import 'package:chat_app/app/modules/profile/binding.dart';
import 'package:chat_app/app/modules/profile/page.dart';
import 'package:chat_app/app/modules/splash/binding.dart';
import 'package:chat_app/app/modules/splash/page.dart';

import 'package:chat_app/app/modules/chat/binding.dart';
import './routes.dart';
import 'package:get/route_manager.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.CHAT,
      page: () => ChatPage(),
      binding: ChatBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    )
  ];
}
