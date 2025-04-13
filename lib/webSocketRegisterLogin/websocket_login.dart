import 'dart:convert';
import 'package:flutter_icp_auth/internal/_secure_store.dart';
import 'package:http/http.dart' as http;
import 'package:stringly/constants/globals.dart';
import '../intraction.dart';


class WebSocketLoginForChat {
  static Future<void> loginUserWithPrincipalPublicUserId() async {
    String publicKey = await SecureStore.readSecureData("pubKey");

    String principal = await Intraction.getPrincipalOnChaBox();

    String? userId = await Intraction.getUserIdByPrincipalId();

    print('pubkey---------------------$publicKey');
    print('princiapl---------------------$principal');
    print('userid-------------------$userId');

    await loginUser(
        principal: principal, publicKey: publicKey, userId: userId!);
  }

  static Future<void> loginUser({
    required String principal,
    String? publicKey,
    String? userId,
  }) async {
    final url = Uri.parse('https://api.stringly.net/api/v1/login/user');

    final Map<String, dynamic> requestData = {
      'principal': principal,
      'publicKey': publicKey,
      'user_id': userId,
    };

    requestData.removeWhere((key, value) => value == null);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Login successful: ${responseData}');
        GlobalConstant.chatCredentials = responseData;
        print('${GlobalConstant.chatCredentials!['privateToken']}');
      } else {
        print('Login failed: ${response.body}');
      }
    } catch (e) {
      print('An error occurred during login: $e');
    }
  }
}

