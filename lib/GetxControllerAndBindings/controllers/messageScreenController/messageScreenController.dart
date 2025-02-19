import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/webSocketRegisterLogin/initialize_socket.dart';

import '../../../Screens/Chat/ChatBox.dart';
import '../../../models/user_profile_params_model.dart';

class MessageScreenController extends GetxController {
  // ------------------- OBSERVABLE VARIABLES -------------------

  var draggableCardKeys = Rx<List<GlobalKey>>([]);

  RxBool makeSearchBarAndchatListVisible = RxBool(false);

  var matchQueueFunctionStatus = Rx<Future<dynamic>?>(null);
  var matchQueueData = Rx<List<Map<String, dynamic>>>([]);

  var lastMessage = Rx<List<dynamic>>([]);
  var unreadMessage = Rx<List<dynamic>>([]);

  var loggedUserImage = Rx<String?>(null);

  var messages = Rx<List<Map<String, dynamic>>>([]);
  var filteredMessages = Rx<List<Map<String, dynamic>>>([]);

  var searchController = TextEditingController().obs;

  var dragOffsets = <String, RxDouble>{}.obs;
  final double maxDrag = 140.0;

  // --------------------------- CONTROLLER INIT AND DISPOSE -------------------

  @override
  void onInit() {
    super.onInit();
    searchController.value = TextEditingController();
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }

  // ---------------------------- METHODS ------------------------------

  Future<void> initializeData() async {
    // await _getWebSocketUserChatHistory();
    await _getMatchQueue();
    await getAddUserChatList();
  }

  void initializeOffsets(List<Map<String, dynamic>> messages) {
    for (var message in messages) {
      final chatId = message['chat_id'];
      if (!dragOffsets.containsKey(chatId)) {
        dragOffsets[chatId] = 0.0.obs;
      }
    }
  }

  void updateDragOffset(String chatId, DragUpdateDetails details) {
    if (dragOffsets.containsKey(chatId)) {
      // dragOffsets[chatId]!.value = value.clamp(-maxDrag, 0.0);
      dragOffsets[chatId]!.value += details.delta.dx;

      dragOffsets[chatId]!.value =
          dragOffsets[chatId]!.value.clamp(-maxDrag, 0.0);
    }
  }

  void resetDragOffset(String chatId) {
    if (dragOffsets.containsKey(chatId)) {
      dragOffsets[chatId]!.value = 0.0;
    }
  }

  Future<void> getWebSocketUserChatHistory() async {
    String principal = await Intraction.getPrincipalOnChaBox();
    //  debugPrint('---------------ok $principal');
    InitializeSocket.socket
        .emit('lastMessageRequest', json.encode({'principal': principal}));
    InitializeSocket.socket.on('lastMessageResponse', (data) {
      lastMessage.value = data['lastMessage'];
      unreadMessage.value = data['unreadMessages'];

      if (filteredMessages.value != []) {
        for (var unread in unreadMessage.value) {
          final lastMessageFromSender = lastMessage.value.firstWhere(
              (lastMsg) => lastMsg['from_user_id'] == unread['from_user_id']);
          final message = filteredMessages.value.firstWhereOrNull(
              (msg) => msg['sender_id'] == unread['from_user_id']);
          if (message != null) {
            message['message'] = lastMessageFromSender['message'];
            message['unreadCount'] = int.parse(unread['count']);
            message['rawTime'] = lastMessageFromSender['createdAt'];
            message['isRead'] = false;
          }

          filteredMessages.refresh();
        }
      }

      // debugPrint(
      //     '--------klllllllll------last Message------------------------- ${lastMessage.value}');
      // debugPrint(
      //     '--------klllllllll------Unread Message------------------------- ${unreadMessage.value}');
    });

    debugPrint('check for end of on for chat history');
  }

  Future<Map<String, dynamic>> _getMatchQueue() async {
    try {
      matchQueueData.value = [];
      var result = await Intraction.getLoggedUserMatchQueueNewWithContext();
      var result2 = await Intraction.getLoggedUserAccount();
      String loggedUserId = result2['Ok']['user_id'];
      loggedUserImage.value = result2['Ok']['params']['images'][0].first;

      if (result.containsKey('Ok')) {
        var allData = result['Ok'];
        for (var dataWithContext in allData) {
          final context = dataWithContext['context'];
          final data = dataWithContext['profile'];
          var userProfileId = data['user_id'];
          userProfileParamsModel userProfileInfo =
              userProfileParamsModel.fromMap(data['params']);

          String imageBytesProfile = (userProfileInfo.images != null &&
                  userProfileInfo.images!.isNotEmpty)
              ? userProfileInfo.images![0]
              : '';

          String name = userProfileInfo.name!;
          matchQueueData.value.add({
            'name': name,
            'path': imageBytesProfile,
            'userProfileId': userProfileId,
            'logged_user_id': loggedUserId,
            'context': context,
          });
        }

        debugPrint('########## successful ');
        return result;
      } else {
        debugPrint('########## lloop breakc# ');
        return result;
      }
    } catch (e) {
      // debugPrint(
      //     '########################################################## $e');
      return {'Err': e};
    }
  }

  Future<dynamic> getAddUserChatList() async {
    messages.value = [];
    filteredMessages.value = [];
    var result = await Intraction.getLoggedUserAddChatList();

    if (result.containsKey('Ok')) {
      var chatList = result['Ok'];
      int chatListLength = chatList.length;

      if (chatListLength > 0) {
        makeSearchBarAndchatListVisible.value = true;
      }

      for (int i = 0; i < chatListLength; i++) {
        var singleUserChatList = chatList[i];
        final _userInds = await separateIdsAsyncOnMessageScreen(
            singleUserChatList['chat_id']);
        final senderId = _userInds['sender_id'];
        final receiverId = _userInds['receiver_id'];
        // debugPrint('-------senderId-----------$senderId');
        // debugPrint('-------receiverId----------$receiverId');

        String message = '';
        String time = '';
        String rawTime = '';
        int unReadCount = 0;
        bool isRead = false;

        if (lastMessage.value.isNotEmpty) {
          final userMessageAndTime = findMessageByUserIdOnLastMessageHistory(
              lastMessage.value, senderId);
          if (userMessageAndTime.isNotEmpty) {
            final umread =
                findUnReadMessageFromWebSocket(unreadMessage.value, senderId);
            //  debugPrint('---------------unread Messages $umread');
            if (umread.isNotEmpty) {
              unReadCount = int.parse('${umread['count']}');
              // debugPrint(unReadCount.toString());
              // debugPrint('---------------unread count $unReadCount');
            } else {
              isRead = true;
            }

            message = userMessageAndTime['message'];
            time = formatWhatsAppDateOnMessageScreen(
                userMessageAndTime['createdAt']);
            rawTime = userMessageAndTime['createdAt'];
            //  debugPrint('--------------userMessageAndTime $message, $time');
          }
        }

        String imageBytesProfile = singleUserChatList['image'].isNotEmpty
            ? singleUserChatList['image'][0]
            : '';

        bool exists = messages.value
            .any((chat) => chat['chat_id'] == singleUserChatList['chat_id']);

        if (exists) {
          messages.value = messages.value.map((chat) {
            if (chat['chat_id'] == singleUserChatList['chat_id']) {
              if (unReadCount > 0) {
                return {
                  'name': singleUserChatList['name'],
                  'message': message,
                  'time': time,
                  'avatar': imageBytesProfile,
                  'unreadCount': unReadCount,
                  'isRead': isRead,
                  'chat_id': singleUserChatList['chat_id'],
                  'sender_id': senderId,
                  'rawTime': rawTime
                };
              } else {
                return chat;
              }
            }
            return chat;
          }).toList();
        } else {
          messages.value.add({
            'name': singleUserChatList['name'],
            'message': message,
            'time': time,
            'avatar': imageBytesProfile,
            'unreadCount': unReadCount,
            'isRead': isRead,
            'chat_id': singleUserChatList['chat_id'],
            'sender_id': senderId,
            'rawTime': rawTime
          });
        }
      }

      messages.value.sort((a, b) {
        bool aHasMessage = a['message'].isNotEmpty && a['time'].isNotEmpty;
        bool bHasMessage = b['message'].isNotEmpty && b['time'].isNotEmpty;

        if (aHasMessage != bHasMessage) {
          return bHasMessage ? 1 : -1;
        }

        DateTime? timeA = _parseDateTime(a['rawTime']);
        DateTime? timeB = _parseDateTime(b['rawTime']);

        if (timeA != null && timeB != null) {
          return timeB.compareTo(timeA);
        }

        return 0;
      });

      filteredMessages.value = List.from(messages.value);
    }
  }

  Future<Map<String, String>> separateIdsAsyncOnMessageScreen(
      String input) async {
    String idString = input.replaceFirst('chat-', '');
    List<String> parts = idString.split('-');
    if (parts.length == 2) {
      return {
        'receiver_id': parts[0],
        'sender_id': parts[1],
      };
    } else {
      return {};
    }
  }

  Map<String, dynamic> findMessageByUserIdOnLastMessageHistory(
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

  Map<String, dynamic> findUnReadMessageFromWebSocket(
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

  void filterMessages() {
    final query = searchController.value.text.toLowerCase();
    filteredMessages.value = messages.value
        .where((message) =>
            message['name'].toLowerCase().contains(query) ||
            message['message'].toLowerCase().contains(query))
        .toList();
  }

  void markChatAsReadAndNavigate(String name, String message, String time,
      {bool isRead = false,
      int unreadCount = 0,
      required String avatarImage,
      required String chatId}) {
    final context = Get.context!;
    Map<String, dynamic> userInfo = {
      'userProfileImage': avatarImage,
      'name': name,
      'chat_id': chatId
    };
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChatBox(userInfo: userInfo)));

    for (var message in messages.value) {
      if (message['chat_id'] == chatId) {
        bool isMessagesAvailable = message['message'].isEmpty;

        message['unreadCount'] = 0;
        message['isRead'] = !isMessagesAvailable ? true : false;
      }
    }

    for (var message in filteredMessages.value) {
      if (message['chat_id'] == chatId) {
        bool isMessagesAvailable = message['message'].isEmpty;

        message['unreadCount'] = 0;
        message['isRead'] = !isMessagesAvailable ? true : false;
      }
    }
    messages.refresh();
    filteredMessages.refresh();
  }

  Future<void> separateIdsAsync(
      String input, Map<String, dynamic> message) async {
    String idString = input.replaceFirst('chat-', '');
    List<String> parts = idString.split('-');
    if (parts.length == 2) {
      String senderId = parts[0];
      String receiverId = parts[1];
      matchQueueData.value
          .removeWhere((item) => item['userProfileId'] == receiverId);
      messages.value
          .removeWhere((item) => item['chat_id'] == message['chat_id']);
      await Intraction.unmatchUser(receiverId: receiverId, senderId: senderId);
    }
  }

  // --------------------------------- TIME FORMATTER --------------------------

  String formatWhatsAppDateOnMessageScreen(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString)
        .add(const Duration(hours: 5, minutes: 30));

    // Get the current date and time in IST
    DateTime now = DateTime.now()
        .toUtc()
        .add(const Duration(hours: 5, minutes: 30)); // Convert now to IST

    // Remove the time component for accurate day comparison
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    // Get the difference in days
    int daysDifference = today.difference(inputDate).inDays;

    // Format the time
    String timeString = DateFormat('hh:mm a').format(dateTime);

    // Determine the appropriate date format
    if (daysDifference == 0) {
      // Today
      return timeString;
    } else if (daysDifference == 1) {
      // Yesterday
      return "Yesterday, $timeString";
    } else if (daysDifference < 7) {
      // Within the last week
      return "${DateFormat('EEEE').format(dateTime)}, $timeString"; // Day of the week (e.g., Monday)
    } else if (dateTime.year == now.year) {
      // Within the same year
      return "${DateFormat('d MMM').format(dateTime)}, $timeString"; // Day and month (e.g., 16 Jan)
    } else {
      // For dates in a different year
      return "${DateFormat('d MMM yyyy').format(dateTime)}, $timeString"; // Full date (e.g., 16 Jan 2024)
    }
  }

  DateTime? _parseDateTime(String time) {
    try {
      print('Time -----------------------$time');
      return DateTime.parse(time); // Adjust this based on actual format
    } catch (e) {
      debugPrint("Error parsing time: $time");
      return null;
    }
  }

  void moveToTop(String chatId, String msg) {
    final message =
        messages.value.firstWhere((message) => message['chat_id'] == chatId);

    message['message'] = msg;

    message['rawTime'] = DateTime.now().toUtc().toIso8601String();
    message['time'] = formatWhatsAppDateOnMessageScreen(
        DateTime.now().toUtc().toIso8601String());

    final index =
        filteredMessages.value.indexWhere((msg) => msg['chat_id'] == chatId);
    if (index != -1) {
      final item = filteredMessages.value.removeAt(index);
      filteredMessages.value.insert(0, item);
      filteredMessages.refresh();
    }
  }

  void updateRead(String chatId) {
    for (var message in messages.value) {
      if (message['chat_id'] == chatId) {
        bool isMessagesAvailable = message['message'].isEmpty;

        message['unreadCount'] = 0;
        message['isRead'] = !isMessagesAvailable ? true : false;
      }
    }

    for (var message in filteredMessages.value) {
      if (message['chat_id'] == chatId) {
        bool isMessagesAvailable = message['message'].isEmpty;

        message['unreadCount'] = 0;
        message['isRead'] = !isMessagesAvailable ? true : false;
      }
    }
    messages.refresh();
    filteredMessages.refresh();
    print('Mesasges Refreshed #######################################');
    print('#################################################');
  }
}
