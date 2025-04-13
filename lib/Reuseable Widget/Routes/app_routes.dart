import 'package:stringly/Screens/MainSection/detaileddating.dart';
import 'package:stringly/Screens/UserInfo1.dart';
import 'package:stringly/Screens/UserInfo2.dart';
import 'package:stringly/Screens/UserInfo3.dart';
import 'package:stringly/Screens/mainScreenNav.dart';

import '../../main.dart';
import 'app_pages.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static var initial = Routes.splash; // You can set the initial route here

  static final routes = [
    GetPage(
        name: Routes.splash,
        page: ()=>SplashScreen()),
    GetPage(
        name: Routes.welcomepage,
        page: () => Welcomepage()),
    GetPage(
      name: Routes.mainscreen,
      page: () => Mainscreennav(),
    ),
    GetPage(
      name: Routes.userinfo1,
      page: () => Userinfo1(),
    ),
    GetPage(
      name: Routes.userinfo2,
      page: () => UserInfo2(),
    ),
    GetPage(
      name: Routes.userinfo3,
      page: () => const UserInfo3(),
    ),
    // Add more GetPage entries here if needed
  ];
}
