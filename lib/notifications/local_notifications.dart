import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSInitializationSettings =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  static void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      print('Notification payload: $payload');
    }
  }

  /// Method for showing a basic notification (without an image)
  static Future<void> showBasicNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Method for showing a notification with an image
  static Future<void> showImageNotification({
    required int id,
    required String title,
    required String body,
    required String imageUrl,
    String? payload,
  }) async {
    // Download the image and convert it to Base64 (for Android)
    final ByteArrayAndroidBitmap? bigPicture = await _getImageAsBitmap(imageUrl);

    // Android-specific image notification
    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
      bigPicture!,
      contentTitle: title,
      summaryText: body,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'image_channel_id',
      'Image Channel',
      channelDescription: 'Channel for image notifications',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
      icon: '@mipmap/ic_launcher',
    );

    // iOS-specific image notification
    final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      attachments: [
        DarwinNotificationAttachment(imageUrl),
      ],
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Helper method to download an image and convert it to ByteArrayAndroidBitmap
  static Future<ByteArrayAndroidBitmap?> _getImageAsBitmap(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(response.bodyBytes));
      }
    } catch (e) {
      print("Failed to download image: $e");
    }
    return null;
  }
}
