import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/globals.dart';
import '../intraction.dart';

class GetSpecificUserChat {
  static Future<Map<String, dynamic>> specificUserChat({
    required String otherUser,
    required String self,
  }) async {
    final url = Uri.parse('https://api.stringly.net/api/v1/chat/messages');

    String principal = await Intraction.getPrincipalOnChaBox();

    final Map<String, dynamic> requestData = {
      'otherUser': otherUser,
      'self': self,
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
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        // print('------------------------$responseBody');
        return responseBody;
      } else {
        print('get error for find specific user message: ${response.body}');
        return {"status": "false"};
      }
    } catch (e) {
      print('get error for find specific user message: $e');
      return {"status": "false"};
    }
  }
}
