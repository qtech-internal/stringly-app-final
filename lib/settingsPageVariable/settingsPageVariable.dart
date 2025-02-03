import 'package:stringly/StorageServices/get_storage_service.dart';

class SettingPageVariables {
  static bool profileVisibility = StorageService.hasData('profileVisibility');
  static bool newMatchesSound = StorageService.hasData('newMatchesSound');
  static bool likesSound = StorageService.hasData('likeSound');
  static bool messageSound = StorageService.hasData('messageSound');
  static bool profileBoostSound = StorageService.hasData('profileBoostSound');
  static bool newMatchesSoundOnEmail = StorageService.hasData('newMatchesSoundOnEmail');
  static bool offersPlaySound = StorageService.hasData('offersPlaySound');
  static bool newAppUpdatesSound = StorageService.hasData('newAppUpdatesSound');
  static bool allowLocationAccess = StorageService.hasData('allowLocationAccess');
}