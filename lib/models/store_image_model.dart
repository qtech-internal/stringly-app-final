import 'dart:io';
import 'package:stringly/models/user_input_params.dart';
import '../StorageServices/google_bucket_storage.dart';

class StoreImageFile {
  static List<File> allSelectFile = [];

  static void addImage(File image) {
    allSelectFile.add(image);
  }

  static void removeImage(File image) {
    allSelectFile.remove(image);
  }

  static List<File> getAllImages() {
    return List<File>.from(allSelectFile);
  }

  static void resetImages() {
    allSelectFile.clear();
  }
}

// to crate new profile
class GetImageUrlOfUploadFile {
  static Future<void> imageUrlFiles() async {
    List<File> storeFile = StoreImageFile.getAllImages();
    List<String?> imageUrls = [];
      imageUrls = await Future.wait(
            storeFile
            .where((image) => image?.path != null)
            .map((image) async {
          File profileImage = File(image!.path);

          final imageUrl = await ImageUploadAndGetUrl.uploadImageAndGetUrl(pickedFile: profileImage);

          if (imageUrl != null && imageUrl.containsKey('Ok') && imageUrl['Ok'] is String) {
            return imageUrl['Ok'] as String;
          } else {
            return null;
          }
        }),
      );
    imageUrls = imageUrls.whereType<String>().toList();
    final userInputParams = UserInputParams();
    userInputParams.updateField('images', imageUrls);
  }
}

// to update user profile and account
class UpdateProfileImageToGetUrl {
  static Future<List<String?>> imageUrlFiles() async {
    List<File> storeFile = StoreImageFile.getAllImages();
    List<String?> imageUrls = [];
    imageUrls = await Future.wait(
      storeFile
          .where((image) => image?.path != null)
          .map((image) async {
        File profileImage = File(image!.path);

        final imageUrl = await ImageUploadAndGetUrl.uploadImageAndGetUrl(pickedFile: profileImage);

        if (imageUrl != null && imageUrl.containsKey('Ok') && imageUrl['Ok'] is String) {
          return imageUrl['Ok'] as String;
        } else {
          return null;
        }
      }),
    );
    imageUrls = imageUrls.whereType<String>().toList();
    return imageUrls;
  }
}