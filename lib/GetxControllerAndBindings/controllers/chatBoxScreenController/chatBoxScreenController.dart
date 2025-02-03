import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
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

  // Integers

  var ids = Rx<Map<String, String>>({});
  var idsCompleter = Rx<Completer<void>>(Completer<void>());

  String message = "No messages yet";

  var createMessageController = TextEditingController().obs;
  var messages = Rx<List<Map<String, dynamic>>>([]);
  var principal = Rx<String?>(null);

  var scrollController = ScrollController().obs;

  // Services
  final FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();

  // ------------------ INITIALIZE CHAT METHOD --------------------

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  Future<void> initialize(String chatId, Map<String, dynamic> userInfo) async {
    try {
      isLoading.value = true;
      isLoading.refresh();
      print('ISLOADING VALUE ----------------------- ${isLoading.value}');

      await _getPrincipalOfSender();
      await _loadIds(chatId);
      await idsCompleter.value.future; // Wait for IDs to be ready.
      await _fetchAllUserChatWithThisUser(userInfo);
      await getResponseMessage(userInfo);
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

  Future<void> getResponseMessage(Map<dynamic, dynamic> userInfo) async {
    InitializeSocket.socket.emit(
        'updateMessageStatus',
        json.encode({
          'user_id': ids.value['sender_id'],
          'to_user_id': ids.value['receiver_id'],
        }));

    InitializeSocket.socket.on('receiveMessage', (data) {
      debugPrint('Message received----: $data');
      Map<String, dynamic> messageData = data['data'];

      messages.value.add({
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
      });
      isUserScrolling.value = false;
      scrollToBottom();
    });
  }

  // ---------------- Method for send audio message ---------------------

  Future<void> sendAudioMessage(
      String path, Map<String, dynamic> userInfo) async {
    String audioUrl = '';
    // Upload the audio file and send the message
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

        messages.value.add({
          'sender': ids.value['sender_id'],
          'local': true,
          'senderName': 'You',
          'rawTime': DateTime.now().toUtc().toIso8601String(),
          'audio': audioUrl['Ok'] as String, // Use the audioUrl here
          'timestamp': convertCreateTimeAtFetchMessage(
              DateTime.now().toUtc().toIso8601String()),
        });

        scrollToBottom();
        messages.refresh();
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
      debugPrint('------------------------history -------------------- $data');

      if (data['status'] == true) {
        if (data['historyUsers'].isNotEmpty) {
          final allMessages = data['historyUsers'];
          debugPrint('---all message----------$allMessages');
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
          debugPrint('-----------message--------$messages');
          messages.refresh();
        }
      }
      isUserScrolling.value = false;
      scrollToBottom();
    });
    messages.refresh();
    debugPrint('Messages Values ---------------${messages.value}');
  }

  String _formatWhatsAppDateOnChatHistory(String dateTimeString) {
    // Parse the string into a DateTime object (assumed to be in UTC)
    DateTime dateTime = DateTime.parse(dateTimeString)
        .add(Duration(hours: 5, minutes: 30)); // Convert to IST

    // Get the current date and time in IST
    DateTime now = DateTime.now()
        .toUtc()
        .add(Duration(hours: 5, minutes: 30)); // Convert now to IST

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

  void scrollToBottom() {
    // Schedule the scroll after the widget rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.value.hasClients && !isUserScrolling.value) {
        scrollController.value.animateTo(
          scrollController.value.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
      messages.value.add({
        'sender': ids.value['sender_id'],
        'local': true,
        'senderName': 'You',
        'rawTime': DateTime.now().toUtc().toIso8601String(),
        'photo': File(imagePaths.last),
        'timestamp': convertCreateTimeAtFetchMessage(
            DateTime.now().toUtc().toIso8601String()),
      });
      messages.refresh();
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
}
