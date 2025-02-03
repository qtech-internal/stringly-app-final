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
        controller.separateIdsAsync(message['chat_id'], message);
        controller.filteredMessages.value =
            List.from(controller.messages.value);
        debugPrint('Card $index skipped');
      },
      onRightButtonPressed: () {
        debugPrint('Card $index matched');
      },
    );
  }
}
