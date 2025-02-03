import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  // Save a value
  static void write(String key, dynamic value) {
    _box.write(key, value);
  }

  // Read a value
  static dynamic read(String key) {
    return _box.read(key);
  }

  // Check if a key exists
  static bool hasData(String key) {
    return _box.hasData(key);
  }

  // Remove a value
  static void remove(String key) {
    _box.remove(key);
  }
}
