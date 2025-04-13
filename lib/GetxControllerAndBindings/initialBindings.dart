import 'package:get/get.dart';
import 'controllers/chatBoxScreenController/chatBoxScreenController.dart';
import 'controllers/mapScreen/mapScreenController.dart';
import 'controllers/messageScreenController/messageScreenController.dart';


class AllBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageScreenController());
    Get.lazyPut(() => ChatScreenController());
    Get.lazyPut(() => MapController());
  }
}