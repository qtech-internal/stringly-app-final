// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:stringly/GetxControllerAndBindings/controllers/messageScreenController/messageScreenController.dart';
import 'package:stringly/Screens/Chat/message_widgets/draggable_card.dart';
import 'package:stringly/Screens/Chat/message_widgets/message_tile.dart';

class DraggableMatchCard extends GetView<MessageScreenController> {
  const DraggableMatchCard({
    super.key,
    required this.message,
    required this.index,
  });

  final Map<String, dynamic> message;
  final int index;

  void _showUnmatchDialog() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Are you sure you want to unmatch this user?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "This will remove the user from your matches, and you won’t be able to chat with them again.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE4E4E4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color(0xFFE4626F), fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    controller.separateIdsAsync(message['chat_id'], message);
                    controller.filteredMessages.value =
                        List.from(controller.messages.value);
                    debugPrint('Card $index skipped');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Unmatch',
                    style: TextStyle(color: Color(0xFF5355D0), fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardKey = GlobalKey();
    controller.draggableCardKeys.value.add(cardKey);

    return DraggableCard(
      key: cardKey,
      chatId: message['chat_id'],
      messageTile: BuildMessageTile(
        name: message['name'],
        message: message['message'],
        time: message['time'],
        avatarImage: message['avatar'],
        isRead: message['isRead'],
        chatId: message['chat_id'],
        unreadCount: message['unreadCount'],
        onTap: () => controller.markChatAsReadAndNavigate(
            message['name'], message['message'], message['time'],
            avatarImage: message['avatar'], chatId: message['chat_id']),
      ),
      onLeftButtonPressed: () {
        _showUnmatchDialog();
      },
      onRightButtonPressed: () {
        debugPrint('Card $index matched');
      },
    );
  }
}
