import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/messageScreenController/messageScreenController.dart';

class DraggableCard extends StatelessWidget {
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
  final Widget messageTile;
  final String chatId;

  const DraggableCard({
    Key? key,
    required this.messageTile,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    required this.chatId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessageScreenController>();

    final dragOffset = controller.dragOffsets[chatId] ?? 0.0.obs;

    return Obx(() {
      return Stack(
        children: [
          // Background actions
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, right: 10),
                    child: InkWell(
                      onTap: onLeftButtonPressed,
                      child: const Text(
                        'Unmatch',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Draggable card
          Transform.translate(
            offset: Offset(dragOffset.value, 0),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                controller.updateDragOffset(chatId, details);
              },
              onHorizontalDragEnd: (details) {
                if (dragOffset.value <= -controller.maxDrag) {
                  onLeftButtonPressed();
                  controller.resetDragOffset(chatId);
                }
              },
              child: messageTile,
            ),
          ),
        ],
      );
    });
  }
}
