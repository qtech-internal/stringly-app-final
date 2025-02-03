import 'dart:convert';
import 'package:flutter_icp_auth/internal/_secure_store.dart';
import 'package:http/http.dart' as http;
import 'package:stringly/intraction.dart';

import '../constants/globals.dart';

class GetChatHistory {
  static Future<Map<String, dynamic>> getChatHistory() async {

    String principal = await Intraction.getPrincipalOnChaBox();

    String privateToken = await SecureStore.readSecureData('privKey');

 var value =   await chatHistory(
        principal: principal,
        privateToken: privateToken
    );

 return value;
  }

  static Future<Map<String, dynamic>> chatHistory({
    required String principal,
    required String privateToken,
  }) async {
    final url = Uri.parse('https://api.stringly.net/api/v1/chat/history');

    final Map<String, dynamic> requestData = {
      'x-principal': principal,
      'x-private-token': GlobalConstant.chatCredentials!['privateToken'],
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
        print('get success for find specific user chat history: ${response.body}');
        return {'Ok': response.body};
      } else {
        print('getting error for finding chat history: ${response.body}');
        return {'Err': 'Err'};
      }
    } catch (e) {
      print('An error occurred in finding chat history of user: $e');
      return {'Err': 'Err'};
    }
  }
}
