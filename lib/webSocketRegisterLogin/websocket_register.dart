import 'dart:convert';
import 'package:flutter_icp_auth/internal/_secure_store.dart';
import 'package:http/http.dart' as http;
import 'package:stringly/intraction.dart';

class WebSocketRegisterForChat {
  static Future<void> registerUserWithPrincipalPublicUserId() async {
    String publicKey = await SecureStore.readSecureData("pubKey");

    String principal = await Intraction.getPrincipalOnChaBox();

    String? userId = await Intraction.getUserIdByPrincipalId();

    print('pubkey---------------------$publicKey');
    print('princiapl---------------------$principal');
    print('userid-------------------$userId');

    await registerUser(
        principal: principal, publicKey: publicKey, userId: userId!);
  }

  static Future<void> registerUser({
    required String principal,
    required String publicKey,
    required String userId,
  }) async {
    final url = Uri.parse('https://api.stringly.net/api/v1/register/user');

    final Map<String, dynamic> requestData = {
      'principal': principal,
      'publicKey': publicKey,
      'user_id': userId,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration successful: ${response.body}');
      } else {
        print('Registration failed: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
