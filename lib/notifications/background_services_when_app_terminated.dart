import 'package:workmanager/workmanager.dart';
import 'package:stringly/notifications/local_notifications.dart';
import 'package:stringly/webSocketRegisterLogin/initialize_socket.dart';

// Function to perform the background task
void backgroundTask() {
  // Ensuring socket initialization (if needed)
  if (InitializeSocket.socket == null || !InitializeSocket.socket!.connected) {
    // Re-initialize the socket connection if not connected
    InitializeSocket.socketInitializationMethod();
  }

  // Show a test notification every time the background task runs (every 15 minutes)
  NotificationService.showBasicNotification(
    id: 0384,
    title: 'Test Notification',
    body: 'This is a test notification triggered by WorkManager.',
  );
  print('Test Notification sent every 15 minutes');
}

// WorkManager callback dispatcher
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // Perform the background task (send test notifications)
    backgroundTask();
    return Future.value(true);
  });
}

class BackgroundServiceManager {
  static final BackgroundServiceManager _instance = BackgroundServiceManager._internal();
  factory BackgroundServiceManager() => _instance;
  BackgroundServiceManager._internal();

  static bool _isRunning = false;

  // Starts the socket service and schedules background tasks
  static Future<void> startSocketService() async {
    if (_isRunning) return;

    // Initialize WorkManager with the callback dispatcher
    Workmanager().initialize(callbackDispatcher);

    // Register the background task to check the socket every 15 minutes (for example)
    Workmanager().registerPeriodicTask(
      'socket_task',
      'maintainSocket',
      inputData: <String, dynamic>{},
      frequency: const Duration(minutes: 15),  // Use a minimum interval of 15 minutes
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );

    _isRunning = true;

    // Attempt to initialize the socket connection
    InitializeSocket.socketInitializationMethod();
  }

  // Stops the background task
  Future<void> stopServices() async {
    await Workmanager().cancelAll();
    InitializeSocket.socket?.disconnect();
    _isRunning = false;
  }

  // Disposes resources when needed
  void dispose() {
    stopServices();
  }
}
