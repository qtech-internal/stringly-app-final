import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:stringly/GetxControllerAndBindings/controllers/chatBoxScreenController/chatBoxScreenController.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/messageScreenController/messageScreenController.dart';
import 'package:stringly/Screens/Chat/audio_record_button.dart';
import 'package:stringly/Screens/Chat/message_tile.dart';
import 'package:stringly/Screens/loaders/message_screen_loader.dart';
import 'package:stringly/webSocketRegisterLogin/initialize_socket.dart';

class ChatBox extends StatefulWidget {
  ChatBox({super.key, required this.userInfo});
  Map<String, dynamic> userInfo;
  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  late ChatScreenController controller;

  final messageController = Get.find<MessageScreenController>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatScreenController());
    controller.initialize(widget.userInfo['chat_id'], widget.userInfo);
    controller.scrollController.value.addListener(() {
      if (controller.scrollController.value.position.userScrollDirection !=
          ScrollDirection.idle) {
        controller.isUserScrolling.value = true;
      }
    });
    debugPrint('PRINTING CHAT ---------------------');
    debugPrint(messageController.messages.value
        .firstWhere(
            (message) => message['chat_id'] == widget.userInfo['chat_id'])
        .toString());
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
    return Obx(() {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            // leading: IconButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     icon: const Icon(
            //       Icons.arrow_back_outlined,
            //       color: Colors.white,
            //     )),
            // elevation: 0,
            toolbarHeight: 66, // AppBar height increased by 10px
            title: Row(
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
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
                      child: CircleAvatar(
                          radius: 23, // Circular avatar size
                          backgroundImage: NetworkImage(
                              widget.userInfo['userProfileImage'])),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userInfo['name'], // Replace with dynamic name
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
                  const PopupMenuItem(
                    value: 'report',
                    child: Align(
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
                    const SizedBox(
                      height: 2,
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller.scrollController.value,
                        itemCount: controller.messages.value.length,
                        itemBuilder: (context, index) {
                          bool isSender = controller.messages.value[index]
                                  ['sender'] ==
                              controller.ids.value['sender_id'];
                          bool isLastMessage =
                              index == controller.messages.value.length - 1;

                          return MessageTile(
                            message: controller.messages.value[index],
                            isSender: isSender,
                            isLastMessage: isLastMessage,
                            scrollToBottom: () => controller.scrollToBottom,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  controller.createMessageController.value,
                              decoration: InputDecoration(
                                hintText: 'Type your message',
                                hintStyle:
                                    const TextStyle(color: Colors.black45),
                                contentPadding: const EdgeInsets.symmetric(
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
                                        widget.userInfo['chat_id'], 'photo');
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
                              debugPrint(
                                  'chat_id ${widget.userInfo['chat_id']}');
                              if (controller.createMessageController.value.text
                                  .isNotEmpty) {
                                try {
                                  InitializeSocket.socket.emit(
                                    'sendMessage',
                                    json.encode({
                                      'principal': controller.principal.value,
                                      'to_user_id':
                                          controller.ids.value['receiver_id'],
                                      'chat_id': widget.userInfo['chat_id'],
                                      'message': controller
                                          .createMessageController.value.text,
                                    }),
                                  );

                                  controller.messages.value.add({
                                    'sender': controller.ids.value['sender_id'],
                                    'senderName': 'You',
                                    'rawTime': DateTime.now()
                                        .toUtc()
                                        .toIso8601String(),
                                    'text': controller.createMessageController
                                            .value.text.isNotEmpty
                                        ? controller
                                            .createMessageController.value.text
                                        : '',
                                    'timestamp': controller
                                        .convertCreateTimeAtFetchMessage(
                                            DateTime.now()
                                                .toUtc()
                                                .toIso8601String()),
                                  });

                                  controller.scrollToBottom();

                                  controller.messages.refresh();

                                  // UPDATE

                                  final message = messageController
                                      .messages.value
                                      .firstWhere((message) =>
                                          message['chat_id'] ==
                                          widget.userInfo['chat_id']);

                                  message['message'] = controller
                                      .createMessageController.value.text;

                                  message['rawTime'] =
                                      DateTime.now().toUtc().toIso8601String();
                                  message['time'] = messageController
                                      .formatWhatsAppDateOnMessageScreen(
                                          DateTime.now()
                                              .toUtc()
                                              .toIso8601String());
                                  messageController.moveToTop(
                                      widget.userInfo['chat_id'],
                                      controller
                                          .createMessageController.value.text);

                                  debugPrint(
                                      'PRINTING CHAT ---------------------');
                                  debugPrint(messageController.messages.value
                                      .firstWhere((message) =>
                                          message['chat_id'] ==
                                          widget.userInfo['chat_id'])
                                      .toString());
                                } catch (e) {
                                  debugPrint('Error sending message: $e');
                                }

                                controller.createMessageController.value
                                    .clear();
                              }
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
    });
  }
}
