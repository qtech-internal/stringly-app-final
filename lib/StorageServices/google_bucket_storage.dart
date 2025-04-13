import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import "package:image/image.dart" as img;
import 'package:path_provider/path_provider.dart';


class ImageUploadAndGetUrl {

  static Future<File> compressImage(dynamic inputFile) async {
    late final File file;

    if (inputFile is XFile) {
      file = File(inputFile.path);
    } else if (inputFile is File) {
      file = inputFile;
    }

    List<int> imageBytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

    if (image == null) {
      throw Exception('Failed to decode image.');
    }

    img.Image compressedImage = img.copyResize(image, width: 800);
    List<int> compressedBytes = img.encodeJpg(compressedImage, quality: 70);
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String compressedFilePath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

    final File compressedFile = File(compressedFilePath)..writeAsBytesSync(compressedBytes);
    return compressedFile;
  }


  static Future<Map<String, String>> uploadImageAndGetUrl({
    required File pickedFile,
  }) async {
    try {
      // Compress image
      File imageFile = await compressImage(pickedFile);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.stringly.net/api/v1/upload'),
      );

      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));
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
      return {'Err': 'Exception'};
    }
  }
}
