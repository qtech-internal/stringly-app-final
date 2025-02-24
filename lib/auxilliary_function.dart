import 'package:get/get.dart';
import 'Screens/mainScreenNav.dart';

class AuxiliaryFunction {
  static void navigationIntoMainScreen({required int index}) {
      Get.off(() => Mainscreennav(initialIndex: index));
  }
}