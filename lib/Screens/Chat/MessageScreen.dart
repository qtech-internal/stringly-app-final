import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/messageScreenController/messageScreenController.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/profile/profile_controller.dart';
import 'package:stringly/Screens/Chat/message_widgets/chat_lists.dart';
import 'package:stringly/Screens/loaders/message_screen_loader.dart';
import 'package:stringly/auxilliary_function.dart';
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
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Get.put(ProfileController());
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AccountSetting()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFD83694),
                            Color(0xFF0039C7),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            controller.loggedUserImage.value != null
                                ? CachedNetworkImageProvider(
                                    controller.loggedUserImage.value!)
                                : null,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: -2,
                    right: -1,
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
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
