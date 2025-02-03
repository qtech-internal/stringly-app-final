import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class VideoUploadAndGetUrl {
  static Future<Map<String, String>> uploadVideoAndGetUrl({
    required File videoFile,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.stringly.net/api/v1/upload'),
      );

      // Specify the filename with .mp4 extension
      String fileName = '${videoFile.uri.pathSegments.last.split('.').first}.mp4';
      request.files.add(await http.MultipartFile.fromPath('file', videoFile.path, filename: fileName));
      request.headers['Content-Type'] = 'multipart/form-data';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);

      if (data['url'] != null) {
        return {'Ok': data['url']};
      } else {
        return {'Err': 'Internal Error'};
      }
    } catch (e) {
      return {'Err': 'Exception: $e'};
    }
  }
}