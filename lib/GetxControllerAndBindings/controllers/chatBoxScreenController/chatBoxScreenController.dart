import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/messageScreenController/messageScreenController.dart';
import 'package:stringly/Reuseable%20Widget/SelectOneImageAtOneTime.dart';
import 'package:stringly/Screens/Chat/AudioUpload.dart';
import 'package:stringly/Screens/FAQ%20Qusetions/Repor.dart';
import 'package:stringly/Screens/MainSection/detaileddating.dart';
import 'package:stringly/Screens/mainScreenNav.dart';
import 'package:stringly/StorageServices/google_bucket_storage.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/user_profile_params_model.dart';
import 'package:stringly/webSocketRegisterLogin/initialize_socket.dart';

class ChatScreenController extends GetxController {
// ------------------- OBSERVABLE VARIABLES ---------------------

  // Booleans
  var isLoading = false.obs;
  var isUserScrolling = true.obs;
  var profileLoading = false.obs;
  var initialScrolling = true.obs;

  // Integers

  var ids = Rx<Map<String, String>>({});
  var idsCompleter = Rx<Completer<void>>(Completer<void>());

  String message = "No messages yet";

  var createMessageController = TextEditingController().obs;
  var messages = Rx<List<Map<String, dynamic>>>([]);
  Rx<List<Map<String, dynamic>>> sortedMessages =
      Rx<List<Map<String, dynamic>>>([]);

  var principal = Rx<String?>(null);

  var scrollController = ScrollController().obs;

  // Services
  final FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();

  final messageController = Get.find<MessageScreenController>();

  // ------------------ INITIALIZE CHAT METHOD --------------------

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  Future<void> initialize(String chatId, Map<String, dynamic> userInfo) async {
    try {
      isLoading.value = true;
      initialScrolling.value = true;
      isLoading.refresh();
      print('ISLOADING VALUE ----------------------- ${isLoading.value}');

      await _getPrincipalOfSender();
      await _loadIds(chatId);
      await idsCompleter.value.future; // Wait for IDs to be ready.
      await _fetchAllUserChatWithThisUser(userInfo);
      await getResponseMessage(userInfo, chatId);
      await _requestPermissions();
      await audioRecorder.openRecorder();

      isLoading.value = false;

      isLoading.refresh();
    } catch (e) {
      isLoading.value = false;
      print('ISLOADING VALUE ----------------------- ${isLoading.value}');
      debugPrint('Initialization error: $e');
    }
  }

  Future<void> _loadIds(String input) async {
    Map<String, String> result = await separateIdsAsync(input);
    ids.value = result;
    print('IDs loaded: $ids');
    if (!idsCompleter.value.isCompleted) {
      idsCompleter.value.complete(); // Mark IDs as ready.
    }
  }

  Future<void> getResponseMessage(
      Map<dynamic, dynamic> userInfo, String chatId) async {

    InitializeSocket.socket.on('receiveMessage', (data) {
      debugPrint('Message received----: $data');
      Map<String, dynamic> messageData = data['data'];

      Map<String, dynamic> newMessage = {
        'sender': messageData['to_user_id'] == ids.value['receiver_id']
            ? ids.value['sender_id']
            : ids.value['receiver_id'],
        'local': false,
        'senderName': userInfo['name'],
        'rawTime': messageData['createdAt'],
        'photo': messageData['photo'],
        'video': messageData['video'],
        'audio': messageData['audio'],
        'text': messageData['message'], // Keep it dynamic
        'timestamp': convertCreateTimeAtFetchMessage(messageData['createdAt']),
      };

      messages.value.add(newMessage);
      messages.refresh();

      //  print('Message Received ------------------------------');

      bool todayKeyExists = sortedMessages.value.any(
        (message) => message['type'] == 'date' && message['date'] == 'Today',
      );

      if (todayKeyExists) {
        int todayLength = sortedMessages.value
            .map((today) => today['date'] == 'Today')
            .length;

        sortedMessages.value.insert(todayLength, newMessage);
      } else {
        sortedMessages.value.add({'type': 'date', 'date': 'Today'});
        sortedMessages.value.add(newMessage);
      }

      sortedMessages.refresh();
      isUserScrolling.value = false;
      scrollToBottom();
      InitializeSocket.socket.emit(
          'updateMessageStatus',
          json.encode({
            'user_id': ids.value['sender_id'],
            'to_user_id': ids.value['receiver_id'],
          }));
    });
  }

  // ---------------- Method for send audio message ---------------------

  Future<void> sendAudioMessage(
      String path, Map<String, dynamic> userInfo) async {
    String audioUrl = '';
    try {
      final audioUrl = await AudioUploadAndGetUrl.uploadAudioAndGetUrl(
          pickedFile: File(path));
      if (audioUrl.containsKey('Ok')) {
        InitializeSocket.socket.emit(
          'sendMessage',
          json.encode({
            'principal': principal.value,
            'to_user_id': ids.value['receiver_id'],
            'chat_id': userInfo['chat_id'],
            'message': 'audio',
            'audio': audioUrl['Ok'],
          }),
        );

        var newMessage = {
          'sender': ids.value['sender_id'],
          'senderName': 'You',
          'rawTime': DateTime.now().toUtc().toIso8601String(),
          'audio': audioUrl['Ok'] as String, // Use the audioUrl here
          'timestamp': convertCreateTimeAtFetchMessage(
              DateTime.now().toUtc().toIso8601String()),
        };

        messages.value.add(newMessage);

        bool todayKeyExists = sortedMessages.value.any(
          (message) => message['type'] == 'date' && message['date'] == 'Today',
        );

        if (todayKeyExists) {
          int todayLength = sortedMessages.value
              .map((today) => today['date'] == 'Today')
              .length;

          sortedMessages.value.insert(todayLength, newMessage);
        } else {
          sortedMessages.value.add({'type': 'date', 'date': 'Today'});
          sortedMessages.value.add(newMessage);
        }

        sortedMessages.refresh();
        scrollToBottom();

        debugPrint('PRINTING AUDIO CHAT ---------------------');
        debugPrint(sortedMessages.value.toString());
      } else {
        debugPrint('Error uploading audio: ${audioUrl['Err']}');
      }
    } catch (e) {
      debugPrint('Error sending audio message: $e');
    }
  }

  Future<Map<String, String>> separateIdsAsync(String input) async {
    String idString = input.replaceFirst('chat-', '');
    List<String> parts = idString.split('-');
    if (parts.length == 2) {
      return {
        'sender_id': parts[0],
        'receiver_id': parts[1],
      };
    } else {
      return {};
    }
  }

  Future<void> _getPrincipalOfSender() async {
    String principalId = await Intraction.getPrincipalOnChaBox();
    principal.value = principalId;
  }

  // fetch message function

  String convertCreateTimeAtFetchMessage(dynamic timestamp) {
    DateTime utcTime = DateTime.parse(timestamp);

    DateTime istTime = utcTime.add(const Duration(hours: 5, minutes: 30));

    return DateFormat('hh:mm a').format(istTime);
  }

  Future<void> _fetchAllUserChatWithThisUser(
      Map<String, dynamic> userInfo) async {
    // update message status for read
    messages.value = [];
    sortedMessages.value = [];
    InitializeSocket.socket.emit(
        'updateMessageStatus',
        json.encode({
          'user_id': ids.value['sender_id'],
          'to_user_id': ids.value['receiver_id'],
        }));
    // get history of two user
    InitializeSocket.socket.emit(
        'history',
        json.encode({
          'principal': principal.value,
          'to_user_id': ids.value['receiver_id'],
        }));
    InitializeSocket.socket.on('historyResponse', (data) {
      //  debugPrint('------------------------history -------------------- $data');

      if (data['status'] == true) {
        if (data['historyUsers'].isNotEmpty) {
          final allMessages = data['historyUsers'];
          //  debugPrint('---all message----------$allMessages');
          messages.value.addAll(List<Map<String, dynamic>>.from(
            allMessages.map((data) {
              return {
                'sender': data['to_user_id'] == ids.value['receiver_id']
                    ? ids.value['sender_id']
                    : ids.value['receiver_id'],
                'local': false,
                'senderName': data['to_user_id'] == ids.value['receiver_id']
                    ? 'You'
                    : userInfo['name'],
                'rawTime': data['createdAt'],
                'photo': data['photo'],
                'video': data['video'],
                'audio': data['audio'],
                'text': data['message'].toString(), // Keep it dynamic
                'timestamp': _formatWhatsAppDateOnChatHistory(
                    data['createdAt']), // Include any additional dynamic data
              };
            }),
          ));
          messages.value.reversed;

          messages.refresh();
          sortedMessages.value = groupMessagesByDate(messages.value);
          sortedMessages.refresh();
        }
      }
      isUserScrolling.value = false;
      scrollToBottom();
    });
    messages.refresh();

    //  debugPrint('Messages Values ---------------${messages.value}');
  }

  List<Map<String, dynamic>> groupMessagesByDate(
      List<Map<String, dynamic>> messages) {
    Map<DateTime, List<Map<String, dynamic>>> groupedMessages = {};

    for (var message in messages) {
      DateTime messageDate = DateTime.parse(message['rawTime']).toLocal();
      DateTime formattedDate = _getFormattedDate(messageDate);

      if (!groupedMessages.containsKey(formattedDate)) {
        groupedMessages[formattedDate] = [];
      }
      groupedMessages[formattedDate]!.add(message);
    }

    List<Map<String, dynamic>> sortedMessages = [];

    var sortedKeys = groupedMessages.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    for (var date in sortedKeys) {
      String displayDate = _getDisplayDate(date);

      bool dateExists = sortedMessages
          .any((item) => item['type'] == 'date' && item['date'] == displayDate);

      if (!dateExists) {
        sortedMessages.add({'type': 'date', 'date': displayDate});
      }

      sortedMessages.addAll(groupedMessages[date]!);
    }

    return sortedMessages;
  }

  DateTime _getFormattedDate(DateTime messageDate) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (messageDate.year == today.year &&
        messageDate.month == today.month &&
        messageDate.day == today.day) {
      return today;
    }

    if (messageDate.year == yesterday.year &&
        messageDate.month == yesterday.month &&
        messageDate.day == yesterday.day) {
      return yesterday;
    }

    if (messageDate.isAfter(today.subtract(Duration(days: today.weekday)))) {
      return messageDate;
    }

    return DateTime(messageDate.year, messageDate.month, messageDate.day);
  }

  String _getDisplayDate(DateTime date) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    // Check if it's today or yesterday
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    }

    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    // Otherwise, return the weekday (Monday, Tuesday, etc.) or full date
    if (date.isAfter(today.subtract(Duration(days: today.weekday)))) {
      return DateFormat('EEEE').format(date); // Monday, Tuesday, etc.
    }

    return DateFormat('yyyy-MM-dd')
        .format(date); // For older dates, use the full date
  }

  Future<void> sendMessage(String chatId) async {
    // Ensure the message text is not empty
    if (createMessageController.value.text.isNotEmpty) {
      try {
        // Create a new message object
        var newMessage = {
          'sender': ids.value['sender_id'],
          'senderName': 'You',
          'rawTime': DateTime.now().toUtc().toIso8601String(),
          'text': createMessageController.value.text,
          'timestamp': convertCreateTimeAtFetchMessage(
            DateTime.now().toUtc().toIso8601String(),
          ),
        };

        // Add the new message to the controller's message list
        messages.value.add(newMessage);

        // Check if 'Today' key exists in sortedMessages
        bool todayKeyExists = sortedMessages.value.any(
          (message) => message['type'] == 'date' && message['date'] == 'Today',
        );

        if (todayKeyExists) {
          int todayLength = sortedMessages.value
              .map((today) => today['date'] == 'Today')
              .length;

          sortedMessages.value.insert(todayLength, newMessage);
        } else {
          sortedMessages.value.add({'type': 'date', 'date': 'Today'});
          sortedMessages.value.add(newMessage);
        }

        sortedMessages.refresh();

        scrollToBottom();
        InitializeSocket.socket.emit(
          'sendMessage',
          json.encode({
            'principal': principal.value,
            'to_user_id': ids.value['receiver_id'],
            'chat_id': chatId,
            'message': createMessageController.value.text,
          }),
        );

        debugPrint('PRINTING CHAT ---------------------');
        debugPrint(sortedMessages.value.toString());
      } catch (e) {
        debugPrint('Error sending message: $e');
      }
    }
  }

  String _formatWhatsAppDateOnChatHistory(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString)
        .add(Duration(hours: 5, minutes: 30)); // Convert to IST

    DateTime now = DateTime.now()
        .toUtc()
        .add(Duration(hours: 5, minutes: 30)); // Convert now to IST

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    // Format the time
    String timeString = DateFormat('hh:mm a').format(dateTime);
    return timeString;
  }

  void imageScroll() {
    if (initialScrolling.value) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.value.hasClients) {
          scrollController.value.animateTo(
            scrollController.value.position.maxScrollExtent + 200.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    }

    initialScrolling.value = false;
    initialScrolling.refresh();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.value.animateTo(
        scrollController.value.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> openImagePickerOnChatBox(
      BuildContext context, Map<String, dynamic> userInfo) async {
    // Launch the custom image picker
    final List<String> imagePaths = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CustomImagePickerOneAtATime()),
    );

    // Add images if fewer than 4 images are already selected
    if (imagePaths.isNotEmpty) {
      final newMessage = {
        'sender': ids.value['sender_id'],
        'local': true,
        'senderName': 'You',
        'rawTime': DateTime.now().toUtc().toIso8601String(),
        'photo': File(imagePaths.last),
        'timestamp': convertCreateTimeAtFetchMessage(
            DateTime.now().toUtc().toIso8601String()),
      };
      messages.value.add(newMessage);
      bool todayKeyExists = sortedMessages.value.any(
        (message) => message['type'] == 'date' && message['date'] == 'Today',
      );

      if (todayKeyExists) {
        int todayLength = sortedMessages.value
            .map((today) => today['date'] == 'Today')
            .length;

        sortedMessages.value.insert(todayLength, newMessage);
      } else {
        sortedMessages.value.add({'type': 'date', 'date': 'Today'});
        sortedMessages.value.add(newMessage);
      }

      sortedMessages.refresh();
      isUserScrolling.value = false;
      scrollToBottom();
      try {
        final imageUrl = await ImageUploadAndGetUrl.uploadImageAndGetUrl(
            pickedFile: File(imagePaths.last));
        if (imageUrl.containsKey('Ok')) {
          debugPrint('Emitting message: ${json.encode({
                'photo': imageUrl['Ok'],
                'principal': principal.value,
                'to_user_id': ids.value['receiver_id'],
                'chat_id': userInfo['chat_id'],
                'message': 'photo'
              })}');

          InitializeSocket.socket.emit(
              'sendMessage',
              json.encode({
                'principal': principal.value,
                'to_user_id': ids.value['receiver_id'],
                'chat_id': userInfo['chat_id'],
                'message': 'photo',
                'photo': imageUrl['Ok'],
              }));
          InitializeSocket.socket.on('messageResponse', (data) {
            debugPrint(
                '=============================== send message response $data');
          });
          debugPrint('------------image uplaod test ${imageUrl['Ok']}');
        } else {
          debugPrint('Err: ${imageUrl['Err']}');
        }
      } catch (e) {
        debugPrint('Error uploading image: $e');
      }
    }
  }

  Future<void> hideUserFunction(BuildContext context) async {
    profileLoading.value = true;
    await Intraction.hideUser(receiverId: ids.value['receiver_id']!);
    profileLoading.value = false;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              Mainscreennav()), // Replace LoginScreen with your login page widget.
      (Route<dynamic> route) => false, // Remove all the previous routes.
    );
  }

  Future<void> handleMenuItemClickc(BuildContext context, String value) async {
    if (value == 'report') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ReportIssueScreen()));
    } else if (value == 'hide') {
      debugPrint('functon is called-------------------');
      await hideUserFunction(context);
    }
  }

  Future<void> navigatoNextCode(BuildContext context) async {
    try {
      profileLoading.value = true;
      final result =
          await Intraction.getAnAccount(userId: ids.value['receiver_id']!);
      debugPrint('$result');
      var singleUserInfo =
          userProfileParamsModel.fromMap(result['Ok']['params']);
      debugPrint('------------${singleUserInfo.toMap()}');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailedDating(data: singleUserInfo),
        ),
      );
    } catch (e) {
      profileLoading.value = false;
    } finally {
      profileLoading.value = false;
    }
  }

  String getFormattedDisplayDate(String displayDate) {
    if (displayDate == 'Today') {
      return 'Today'; // Simply return "Today"
    }
    if (displayDate == 'Yesterday') {
      return 'Yesterday'; // Simply return "Yesterday"
    }

    if ([
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ].contains(displayDate)) {
      return displayDate; // Return the day as is (e.g., Monday, Tuesday)
    }

    try {
      DateTime parsedDate = DateTime.parse(displayDate);
      int currentYear = DateTime.now().year;

      if (parsedDate.year == currentYear) {
        return DateFormat('d MMM')
            .format(parsedDate); // Format as d MMM (e.g., 26 Jan)
      } else {
        return DateFormat('d MMM yyyy')
            .format(parsedDate); // Format as d MMM yyyy (e.g., 26 Jan 2025)
      }
    } catch (e) {
      return displayDate;
    }
  }
}
