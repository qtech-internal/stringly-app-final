import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AudioUploadAndGetUrl {
  static Future<Map<String, String>> uploadAudioAndGetUrl({
    required File pickedFile,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.stringly.net/api/v1/upload'), // Update with the correct endpoint
      );

      request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));
      request.headers['Content-Type'] = 'multipart/form-data';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Log the response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        if (data['url'] != null) {
          return {'Ok': data['url']};
        } else {
          return {'Err': 'Internal Error: No URL returned'};
        }
      } else {
        return {'Err': 'Failed to upload audio. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      return {'Err': 'Exception: ${e.toString()}'};
    }
  }
}