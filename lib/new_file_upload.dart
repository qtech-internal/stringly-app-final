import 'package:flutter/material.dart';
import 'package:stringly/notifications/local_notifications.dart';

class TryNotification extends StatelessWidget {
  const TryNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            NotificationService.showBasicNotification(id: 300493, title: 'Just Testing it', body: 'Hello how are you');
          },
          child: const Text('Send Notification')
      ),
    );
  }
}
