import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/messageScreenController/messageScreenController.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/profile/profile_controller.dart';
import 'package:stringly/Screens/Chat/message_widgets/chat_lists.dart';
import 'package:stringly/Screens/loaders/message_screen_loader.dart';
import '../../webSocketRegisterLogin/initialize_socket.dart';
import '../AccountSettings/AccountSettings.dart';
import '../mainScreenNav.dart';

class MessagesScreen extends StatefulWidget {
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late MessageScreenController controller;

  @override
  void initState() {
    controller = Get.put(MessageScreenController());
    controller.getWebSocketUserChatHistory();
    controller.matchQueueFunctionStatus.value = controller.initializeData();
    controller.filteredMessages.value = List.from(controller.messages.value);
    controller.searchController.value.addListener(controller.filterMessages);
    super.initState();
  }

  @override
  void dispose() {
    controller.searchController.value.removeListener(controller.filterMessages);
    controller.searchController.value.clear();
    InitializeSocket.socket.off('lastMessageResponse');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => Mainscreennav()));
            },
            icon: const Icon(Icons.arrow_back)),
        titleSpacing: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SFProDisplay',
          ),
        ),
        actions: [
          Obx(() {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFD83694),
                            Color(0xFF0039C7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            1.5), // Thickness of the gradient border
                        child: CircleAvatar(
                          backgroundImage: controller.loggedUserImage.value !=
                                  null
                              ? NetworkImage(controller.loggedUserImage.value!)
                              : null,
                          radius:
                              20, // Radius of the image inside the gradient border
                          backgroundColor: Colors
                              .white, // Optional: Background color for placeholder
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -6,
                  bottom: -10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 19, // Set the size of the icon
                    ),
                    onPressed: () {
                      Get.put(ProfileController());
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AccountSetting()));
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: FutureBuilder(
        future: controller.matchQueueFunctionStatus.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MessageScreenLoader.simpleLoader(text: 'Wait, Loading...');
          } else if (snapshot.connectionState == ConnectionState.done) {
            return const ChatLists();
          }
          return MessageScreenLoader.simpleLoader(text: 'Wait, Loading...');
        },
      ),
    );
  }
}
