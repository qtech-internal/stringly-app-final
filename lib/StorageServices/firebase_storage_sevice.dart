import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageService {
 static final FirebaseStorage firebaseStorageStorage = FirebaseStorage.instance;

  // Upload file to Google Cloud Storage
static  Future<void> uploadFile({required String filePath, required String fileName}) async {
    File file = File(filePath);
    try {
      await firebaseStorageStorage.ref('uploads/$fileName').putFile(file);
      String downloadURL = await firebaseStorageStorage.ref('uploads/$fileName').getDownloadURL();
      print('Download URL: $downloadURL');
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
