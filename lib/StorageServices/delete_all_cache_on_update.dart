import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

const String currentAppVersion = "1.0.0+19"; // Manually update this in each release

Future<void> clearCacheOnUpdate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? lastVersion = prefs.getString('app_version'); // Get stored version

  if (lastVersion != currentAppVersion) {
    print("New version detected ($currentAppVersion): Clearing cache & storage");

    // Clear SharedPreferences
    await prefs.clear();

    // Clear Secure Storage (if used)
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    // Clear Cache
    await DefaultCacheManager().emptyCache();

    // Clear Temporary Storage
    final tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }

    // Clear App’s Internal Storage (Only for Android)
    if (Platform.isAndroid) {
      final appDir = await getApplicationSupportDirectory();
      if (appDir.existsSync()) {
        appDir.deleteSync(recursive: true);
      }
    }

    // Store the new version
    await prefs.setString('app_version', currentAppVersion);
  }
}
