import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../intraction.dart';

class InitializeSocket {
  static late IO.Socket socket;
  static bool _isInitialized = false;

  static Future<void> socketInitializationMethod() async {
    if (_isInitialized) return;

    String principal = await Intraction.getPrincipalOnChaBox();

    String? userId = await Intraction.getUserIdByPrincipalId();

    socket = IO.io(
      "https://api.stringly.net?principal=$principal&user_id=$userId",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) async {
      print('Connected to the server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from the server');
    });

    _isInitialized = true;
  }
}