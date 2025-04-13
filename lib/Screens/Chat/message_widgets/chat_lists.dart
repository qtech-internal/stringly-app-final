import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/messageScreenController/messageScreenController.dart';
import 'package:stringly/Screens/Chat/ChatBox.dart';
import 'package:stringly/Screens/Chat/message_widgets/draggable_match_card.dart';

class ChatLists extends GetView<MessageScreenController> {
  const ChatLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.matchQueueData.value.isEmpty)
              const Center(
                child: Text(
                  'No Matches Found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            else
              RichText(
                text: TextSpan(
                  text: 'Match Queue ',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  children: [
                    TextSpan(
                      text: '(${controller.matchQueueData.value.length})',
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0;
                      i < controller.matchQueueData.value.length;
                      i++) ...[
                    InkWell(
                      onTap: () async {
                        Map<String, dynamic> userInfo = {
                          'userProfileImage': controller.matchQueueData.value[i]
                              ['path'],
                          'name': controller.matchQueueData.value[i]['name'],
                          'chat_id':
                              'chat-${controller.matchQueueData.value[i]['logged_user_id']}-${controller.matchQueueData.value[i]['userProfileId']}',
                        };
                        // Intraction.addMatchQueueProfileToChatList(userProfileId: matchQueueData[i]['userProfileId']);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatBox(userInfo: userInfo)));
                      },
                      child: buildProfileCircle(
                          controller.matchQueueData.value[i]['path'],
                          i,
                          controller.matchQueueData.value[i]['context']),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (!controller.makeSearchBarAndchatListVisible.value)
              const Center(
                child: Text(
                  'No Messages Yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            else
              _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(
              child: controller.filteredMessages.value.isEmpty &&
                      controller.makeSearchBarAndchatListVisible.value
                  ? const Center(
                      child: Text(
                        'No User Found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: controller.filteredMessages.value.length,
                      separatorBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      itemBuilder: (context, index) {
                        controller.initializeOffsets(
                            controller.filteredMessages.value);
                        final message =
                            controller.filteredMessages.value[index];
                        final _info = {
                          'name': message['name'],
                          'message': message['message'],
                          'time': message['time'],
                          'avatar': message['avatar'],
                          'unreadCount': message['unreadCount'],
                          'isRead': message['isRead'],
                          'chat_id': message['chat_id'],
                        };

                        debugPrint('Rendering Message: ${_info.toString()}');
                        return DraggableMatchCard(message: _info, index: index);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildProfileCircle(String imagePath, int index, String context) {
    // Alternating colors based on index: even = #DC73B6, odd = #5355D0
    Color borderColor =
        context == 'dating' ? const Color(0xFFDC73B6) : const Color(0xFF5355D0);
    String iconPath =
        context == 'dating' ? 'assets/heart.png' : 'assets/link2.png';
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: borderColor, width: 3), // Alternating border colors
        ),
        child: CircleAvatar(
          radius: 35, // Larger size for the profile avatar
          backgroundImage: NetworkImage(imagePath),
          child: Align(
            alignment: Alignment.topLeft,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: Image.asset(
                iconPath, // Heart image
                width: 16,
                height: 16,
                fit: BoxFit.cover, // Adjust image fit
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4), // Shadow color with opacity
              spreadRadius: 2, // Extends the shadow area
              blurRadius: 10, // Smooth blur effect
              offset: const Offset(0, 5), // Vertical shadow offset
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30), // Make corners circular
          child: TextField(
            controller: controller.searchController.value,
            decoration: const InputDecoration(
              hintText: 'Search Here...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
              filled: true,
              // To fill the background
              fillColor: Colors.white,
              // White background for shadow contrast
              border: InputBorder.none,
              // Remove default border
              enabledBorder: InputBorder.none,
              // Remove border when inactive
              focusedBorder: InputBorder.none,
              // Remove border when focused
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0), // Adjust vertical padding
            ),
            style:
                const TextStyle(color: Colors.black), // Search input text color
          ),
        ),
      ),
    );
  }
}
