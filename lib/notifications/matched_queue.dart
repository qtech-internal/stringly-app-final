import 'dart:convert';

import 'package:stringly/intraction.dart';
import 'package:stringly/models/user_profile_params_model.dart';
import 'package:stringly/webSocketRegisterLogin/initialize_socket.dart';
import 'NotificationService.dart';
import 'package:get_storage/get_storage.dart';

class MatchedQueue {
  static final List<Map<String, dynamic>> matchQueueData = [];

  final storage = GetStorage();

  static Future<void> getMatchedQueue() async {
    var result = await Intraction.getLoggedUserMatchQueueNewWithContext();
    if (result.containsKey('Ok')) {
      var allData = result['Ok'];
      for (var dataWithContext in allData) {
        final data = dataWithContext['profile'];
        var userProfileId = data['user_id'];
        userProfileParamsModel userProfileInfo =
            userProfileParamsModel.fromMap(data['params']);

        String imageBytesProfile = (userProfileInfo.images != null &&
                userProfileInfo.images!.isNotEmpty)
            ? userProfileInfo.images![0]
            : '';

        String name = userProfileInfo.name ?? '';
        matchQueueData.add({
          'name': name,
          'path': imageBytesProfile,
          'userProfileId': userProfileId,
        });
      }

      print("Populated matchQueueData: $matchQueueData");
    } else {
      print("No data found in getMatchedQueue response");
    }
  }

  static Map<String, dynamic>? getUserDataById(String userProfileId) {
    try {
      print("Searching for user ID: $userProfileId in matchQueueData");
      return matchQueueData.firstWhere(
        (data) => data['userProfileId'] == userProfileId,
        orElse: () => {},
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _findMessageByUserIdOnLastMessageHistory(
      List<dynamic> messages, String? userId) {
    if (userId == null || userId.isEmpty) {
      return {};
    }

    final matchedMessage = messages.firstWhere(
      (message) =>
          message['from_user_id'] == userId || message['to_user_id'] == userId,
      orElse: () => {},
    );

    return matchedMessage.isNotEmpty ? matchedMessage : {};
  }

  void getNewMessagesFromUser() async {
    String? loggedUserId = Intraction.loggedUserId;
    print("Running");
    InitializeSocket.socket.on('lastMessageResponse', (data) async {
      final _lastMessage = data['lastMessage'];
      List<dynamic> unreadMessages = data['unreadMessages'];

      for (var message in unreadMessages) {
        var userData = getUserDataById(message['from_user_id']);

        print("User Data $userData");
        print("Message $message");
        String senderName = userData?['name'] ?? '';

        final userMessageInfo = _findMessageByUserIdOnLastMessageHistory(
            _lastMessage, message['from_user_id']);

        String messageContent = userMessageInfo['message'] ?? '';
        if (messageContent.isEmpty) {}

        bool isRead = message['isRead'] ?? false;
        if (isRead) {
          continue;
        }

        String createdAt = userMessageInfo['createdAt'] ?? '';
        if (createdAt.isEmpty) {
          continue;
        }

        // Check if the message has already been shown
        List<String> shownNotifications = (storage.read<List<dynamic>>(
                    '${message['from_user_id']} notifications') ??
                [])
            .cast<String>();

        if (shownNotifications.contains(createdAt)) {
          continue;
        }
        String? payload;

        if (userData?['name'] != "" || userData?['path'] != "") {
          payload = jsonEncode({
            'type': 'message',
            'userProfileImage': userData!['path'] ?? '',
            'name': userData['name'] ?? '',
            'chat_id': 'chat-$loggedUserId-${message['from_user_id']}'
          });
        }

        await NotificationService.showBasicNotification(
            id: DateTime.now().millisecondsSinceEpoch % 2147483647,
            title:
                senderName != '' ? "Message from $senderName" : "New Message",
            body: messageContent,
            payload: payload);

        // Save createdAt to prevent duplicate notifications
        shownNotifications.add(createdAt);
        storage.write(
            '${message['from_user_id']} notifications', shownNotifications);
      }
    });
  }

  Map<String, dynamic> _findUnReadMessageFromWebSocket(
      List<dynamic> messages, String? userId) {
    if (userId == null || userId.isEmpty) {
      return {};
    }

    final matchedMessage = messages.firstWhere(
      (message) => message['from_user_id'] == userId,
      orElse: () => {},
    );

    return matchedMessage.isNotEmpty ? matchedMessage : {};
  }
}
