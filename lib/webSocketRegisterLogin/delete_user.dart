import 'dart:convert';
import 'package:http/http.dart' as http;
import '../intraction.dart';

class DeleteUserForChat {
  static Future<Map<String, dynamic>> deleteUserWithPrincipal() async {
    String principal = await Intraction.getPrincipalOnChaBox();
    print('principal---------------------$principal');
    try {
     var result = await Intraction.deleteUserAccount();
      await deleteUserForChat(
          principal: principal);
      return result;
    } catch(e) {
      return {'Err': e};
    }
  }
  static deleteUserForChat({required String principal}) async {
    final url = Uri.parse('https://api.stringly.net/api/v1/delete/user');

    final Map<String, dynamic> requestData = {
      'principal': principal,
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
        print('delete successful: ${responseData}');
      } else {
        print('delete failed failed: ${response.body}');
      }
    } catch (e) {
      print('An error occurred during login: $e');
    }
  }
}