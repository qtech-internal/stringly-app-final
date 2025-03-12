import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:stringly/GetxControllerAndBindings/controllers/chatBoxScreenController/chatBoxScreenController.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/messageScreenController/messageScreenController.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/report/report_controller.dart';
import 'package:stringly/Screens/Chat/audio_record_button.dart';
import 'package:stringly/Screens/Chat/message_tile.dart';
import 'package:stringly/Screens/NotificationScreen.dart';
import 'package:stringly/Screens/loaders/message_screen_loader.dart';
import 'package:stringly/Screens/report/new-report-style-in-bottom-sheet.dart';
import 'package:stringly/StorageServices/get_storage_service.dart';
import 'package:stringly/webSocketRegisterLogin/initialize_socket.dart';

class ChatBox extends StatefulWidget {
  ChatBox({super.key, required this.userInfo, this.isFromMessages = true});

  bool isFromMessages;
  Map<String, dynamic> userInfo;
  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  late ChatScreenController controller;
  late ReportController reportController;
  bool _intentions = false;

  final messageController = Get.find<MessageScreenController>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatScreenController());
    reportController = Get.put(ReportController());
    controller.initialize(widget.userInfo['chat_id'], widget.userInfo);
    controller.scrollController.value.addListener(() {
      if (controller.scrollController.value.position.userScrollDirection !=
          ScrollDirection.idle) {
        controller.isUserScrolling.value = true;
      }
    });
    setState(() {
      _intentions = StorageService.read('showIntentions') ?? false;
    });
  }

  Future<void> returnBackToPage() async {
    if (widget.isFromMessages) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/mainscreennav",
        (route) => false,
        arguments: {'initialIndex': 2},
      );
    }
  }

  void _toggleIntentions(bool value) {
    setState(() {
      _intentions = value; // Update local state
      // Save to storage
    });
    StorageService.write('showIntentions', value);
  }

  @override
  void dispose() {
    InitializeSocket.socket.off('updateMessageStatus');
    InitializeSocket.socket.off('receiveMessage');
    InitializeSocket.socket.off('historyResponse');
    InitializeSocket.socket.off('messageResponse');
    //  controller.scrollController.value.dispose();
    controller.audioRecorder.closeRecorder();

    controller.createMessageController.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        messageController.updateRead(widget.userInfo['chat_id']);
        await returnBackToPage();
        return false;
      },
      child: Obx(() {
        return controller.profileLoading.value ||
                reportController.isReporting.value
            ? Scaffold(
                body:
                    MessageScreenLoader.simpleLoader(text: 'Wait, Loading...'),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,

                  toolbarHeight: 66, // AppBar height increased by 10px
                  title: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            messageController
                                .updateRead(widget.userInfo['chat_id']);
                            returnBackToPage();
                          },
                          child: const Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await controller.navigatoNextCode(context);
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 23, // Circular avatar size
                                backgroundImage: NetworkImage(
                                    widget.userInfo['userProfileImage'])),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userInfo[
                                      'name'], // Replace with dynamic name
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                // const Text(
                                //   'Active',
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.white,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  actions: [
                    PopupMenuButton<String>(
                      key: UniqueKey(),
                      onSelected: (value) =>
                          controller.handleMenuItemClickc(context, value),
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 28,
                      ),
                      offset: const Offset(0, 40),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'report',
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Report',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'hide',
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Hide',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                body: controller.isLoading.value
                    ? MessageScreenLoader.simpleLoader(text: 'Wait, Loading...')
                    : Column(
                        children: [
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Color(0xFFD83694),
                                  Color(0xFFD83694),
                                  Color(0xFF0039C7)
                                ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Do you wish to reveal your intentions?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  CustomToggleButton(
                                    initialValue: _intentions,
                                    onToggle: (value) {
                                      _toggleIntentions(value);
                                      // setState(() {
                                      //   switchValue = value;
                                      // });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Expanded(
                            child: Obx(() {
                              return ListView.builder(
                                controller: controller.scrollController.value,
                                itemCount:
                                    controller.sortedMessages.value.length,
                                itemBuilder: (context, index) {
                                  var item =
                                      controller.sortedMessages.value[index];
                                  print('Item $item');

                                  if (item['type'] == 'date') {
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          controller.getFormattedDisplayDate(
                                              item['date']),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  } else {
                                    bool isSender = item['sender'] ==
                                        controller.ids.value['sender_id'];
                                    bool isLastMessage = index ==
                                        controller.sortedMessages.value.length -
                                            1;

                                    return MessageTile(
                                      message: item,
                                      isSender: isSender,
                                      isLastMessage: isLastMessage,
                                      scrollToBottom: () =>
                                          controller.scrollToBottom,
                                      imageScrollController:
                                          controller.imageScroll,
                                    );
                                  }
                                },
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller
                                        .createMessageController.value,
                                    decoration: InputDecoration(
                                      hintText: 'Type your message',
                                      hintStyle: const TextStyle(
                                          color: Colors.black45),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 15),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          controller.openImagePickerOnChatBox(
                                              context, widget.userInfo);
                                          messageController.moveToTop(
                                              widget.userInfo['chat_id'],
                                              'photo');
                                        },
                                        icon: const Icon(Icons.camera_alt,
                                            color: Colors.black),
                                        iconSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                AudioRecordButton(
                                  onAudioComplete: (path) {
                                    if (path.isNotEmpty) {
                                      controller.sendAudioMessage(
                                          path, widget.userInfo);

                                      messageController.moveToTop(
                                          widget.userInfo['chat_id'], 'audio');
                                    }
                                    debugPrint('Audio Path --$path');
                                  },
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () async {
                                    await controller.sendMessage(
                                        widget.userInfo['chat_id']);
                                    messageController.moveToTop(
                                        widget.userInfo['chat_id'],
                                        controller.createMessageController.value
                                            .text);
                                    controller.createMessageController.value
                                        .clear();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        'assets/send_icon.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ));
      }),
    );
  }
}
