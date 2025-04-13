// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BuildMessageTile extends StatelessWidget {
  BuildMessageTile({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    this.isRead = false,
    this.unreadCount = 0,
    required this.avatarImage,
    required this.chatId,
    this.onTap,
  }) : super(key: key);

  final String name;
  final String message;
  final String time;
  final bool isRead;
  final int unreadCount;
  final String avatarImage;
  final String chatId;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Avatar
            CircleAvatar(
              backgroundImage: NetworkImage(avatarImage),
              radius: 30,
            ),
            const SizedBox(width: 10),

            // Message and Name Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            // Time and Status Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 14),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 4),
                if (unreadCount > 0)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.black,
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                if (isRead)
                  const CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xFFE4E4E4),
                    child: Icon(Icons.check, color: Colors.black, size: 14),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
